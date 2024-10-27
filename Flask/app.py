from flask import Flask, render_template, request
import psycopg2
from psycopg2 import sql
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Initialize Flask app
app = Flask(__name__)

# Database connection parameters from environment variables
DB_HOST = os.getenv('DB_HOST')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')

def get_db_connection():
    """Establishes a new database connection."""
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        return conn
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None

@app.route('/', methods=['GET', 'POST'])
def index():
    try:
        # Establish a new database connection
        conn = get_db_connection()
        if conn is None:
            return "Database connection error.", 500  # Return HTTP 500 for server errors

        cursor = conn.cursor()

        # Fetch all sports from the 'sports' table
        cursor.execute("SELECT sport_id, name FROM sports ORDER BY name;")
        sports = cursor.fetchall()  # List of tuples [(sport_id, name), ...]

        selected_sport = None
        selected_league = None
        leagues = []
        events = []

        if request.method == 'POST':
            # Determine which form was submitted based on the presence of 'sport_submit' or 'league_submit'
            if 'sport_submit' in request.form:
                selected_sport = request.form.get('sport')
                if selected_sport:
                    # Fetch leagues for the selected sport
                    cursor.execute(
                        "SELECT league_id, name FROM leagues WHERE sport_id = %s ORDER BY name;",
                        (selected_sport,)
                    )
                    leagues = cursor.fetchall()
            elif 'league_submit' in request.form:
                selected_sport = request.form.get('sport_id')  # Hidden input to retain selected sport
                selected_league = request.form.get('league')
                if selected_sport and selected_league:
                    # Fetch events for the selected league with team long names
                    cursor.execute(
                        """
                        SELECT 
                            e.event_id, 
                            ht.name_long AS home_team_name_long, 
                            at.name_long AS away_team_name_long
                        FROM events e
                        JOIN teams ht ON e.home_team_id = ht.team_id
                        JOIN teams at ON e.away_team_id = at.team_id
                        WHERE e.league_id = %s
                        ORDER BY e.event_id;
                        """,
                        (selected_league,)
                    )
                    events_raw = cursor.fetchall()

                    # Debugging: Print fetched events_raw
                    print(f"Fetched {len(events_raw)} events.")

                    # For each event, fetch its odds and associated bookmakers
                    events = []
                    for event in events_raw:
                        event_id = event[0]
                        home_team_name_long = event[1]
                        away_team_name_long = event[2]

                        print(f"Processing Event ID: {event_id}")
                        print(f"Home Team: {home_team_name_long}, Away Team: {away_team_name_long}")

                        cursor.execute(
                            """
                            SELECT o.odd_type, o.odds_value, b.name
                            FROM odds o
                            JOIN bookmakers b ON o.bookmaker_id = b.bookmaker_id
                            WHERE o.event_id = %s AND o.odd_type IN ('points-away-game-ml-away', 'points-home-game-ml-home');
                            """,
                            (event_id,)
                        )
                        odds = cursor.fetchall()  # List of tuples [(odd_type, odds_value, bookmaker_name), ...]

                        # Debugging: Print fetched odds for the event
                        print(f"Event ID {event_id} has {len(odds)} odds entries.")

                        # Organize odds by bookmaker
                        bookmakers = {}
                        for odd in odds:
                            odd_type = odd[0]
                            bookmaker = odd[2]

                            # Attempt to convert odds_value to float
                            try:
                                odds_value = float(odd[1])
                            except (ValueError, TypeError):
                                # If conversion fails, skip this odd entry
                                print(f"Invalid odds value for Event ID {event_id}, Bookmaker {bookmaker}: {odd[1]}")
                                continue  # Skip to the next odd entry

                            if bookmaker not in bookmakers:
                                bookmakers[bookmaker] = {
                                    'points_away_game_ml_away': None,
                                    'points_home_game_ml_home': None
                                }

                            if odd_type == "points-away-game-ml-away":
                                bookmakers[bookmaker]['points_away_game_ml_away'] = odds_value
                            elif odd_type == "points-home-game-ml-home":
                                bookmakers[bookmaker]['points_home_game_ml_home'] = odds_value

                        # Convert bookmakers dictionary to a list
                        bookmakers_list = []
                        for bookmaker_name, odds_dict in bookmakers.items():
                            bookmakers_list.append({
                                'name': bookmaker_name,
                                'points_away_game_ml_away': odds_dict['points_away_game_ml_away'],
                                'points_home_game_ml_home': odds_dict['points_home_game_ml_home']
                            })

                        # Debugging: Print bookmakers_list
                        print(f"Event ID {event_id} has {len(bookmakers_list)} bookmakers.")

                        # Identify best odds for each odd type
                        best_odds = {}
                        # Initialize best odds with None
                        best_odds['points_away_game_ml_away'] = {'value': None, 'bookmakers': []}
                        best_odds['points_home_game_ml_home'] = {'value': None, 'bookmakers': []}

                        for bookmaker in bookmakers_list:
                            # For 'points-away-game-ml-away'
                            paa = bookmaker['points_away_game_ml_away']
                            if paa:
                                if (best_odds['points_away_game_ml_away']['value'] is None) or (paa > best_odds['points_away_game_ml_away']['value']):
                                    best_odds['points_away_game_ml_away']['value'] = paa
                                    best_odds['points_away_game_ml_away']['bookmakers'] = [bookmaker['name']]
                                elif paa == best_odds['points_away_game_ml_away']['value']:
                                    best_odds['points_away_game_ml_away']['bookmakers'].append(bookmaker['name'])

                            # For 'points-home-game-ml-home'
                            phh = bookmaker['points_home_game_ml_home']
                            if phh:
                                if (best_odds['points_home_game_ml_home']['value'] is None) or (phh > best_odds['points_home_game_ml_home']['value']):
                                    best_odds['points_home_game_ml_home']['value'] = phh
                                    best_odds['points_home_game_ml_home']['bookmakers'] = [bookmaker['name']]
                                elif phh == best_odds['points_home_game_ml_home']['value']:
                                    best_odds['points_home_game_ml_home']['bookmakers'].append(bookmaker['name'])

                        # Calculate implied probabilities for best odds
                        implied_prob_sum = 0
                        for odd_type in ['points_away_game_ml_away', 'points_home_game_ml_home']:
                            best_odd = best_odds[odd_type]['value']
                            if best_odd and best_odd > 0:
                                implied_prob = 1 / best_odd
                                implied_prob_sum += implied_prob
                            else:
                                # Handle missing or invalid odds
                                implied_prob_sum += 1  # To avoid division by zero later

                        # Calculate arbitrage profit or loss percentage
                        if implied_prob_sum < 1:
                            profit_percentage = (1 - implied_prob_sum) * 100
                            arbitrage = True
                        else:
                            profit_percentage = (1 - implied_prob_sum) * 100
                            arbitrage = False

                        # Append event data with team names, bookmakers, best odds, and arbitrage info
                        events.append({
                            'event_id': event_id,
                            'home_team_name_long': home_team_name_long,
                            'away_team_name_long': away_team_name_long,
                            'bookmakers': bookmakers_list,
                            'best_odds': best_odds,
                            'arbitrage': arbitrage,
                            'profit_percentage': round(profit_percentage, 2)
                        })

    except Exception as e:
        print(f"Error in index route: {e}")
        return "An error occurred while processing your request.", 500  # Return HTTP 500 for server errors
    finally:
        # Close cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()
    return render_template('index.html',
                           sports=sports,
                           selected_sport=selected_sport,
                           leagues=leagues,
                           selected_league=selected_league,
                           events=events)

if __name__ == '__main__':
    app.run(debug=True)
