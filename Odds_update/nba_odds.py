import psycopg2
from psycopg2 import sql
import requests
import json
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv
import sys

load_dotenv()

API_KEY = os.getenv('SPORTSGAMEODDS_API_KEY')
DB_HOST = os.getenv('DB_HOST')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')

if not API_KEY:
    raise ValueError("API key not found. Please check your '.env' file.")
BASE_URL = 'https://api.sportsgameodds.com/v1'

headers = {'X-Api-Key': API_KEY}

try:
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    conn.autocommit = True
    cursor = conn.cursor()
except Exception as e:
    print(f"Error connecting to the database: {e}")
    sys.exit(1)

def insert_sport(sport):
    try:
        cursor.execute("""
            INSERT INTO sports (sport_id, name)
            VALUES (%s, %s)
            ON CONFLICT (sport_id) DO NOTHING;
        """, (sport['sportID'], sport['name']))
    except Exception as e:
        print(f"Error inserting sport: {e}")

def insert_league(league, sport_id):
    try:
        cursor.execute("""
            INSERT INTO leagues (league_id, name, sport_id)
            VALUES (%s, %s, %s)
            ON CONFLICT (league_id) DO NOTHING;
        """, (league['leagueID'], league['name'], sport_id))
    except Exception as e:
        print(f"Error inserting league: {e}")

def insert_team(team):
    try:
        cursor.execute("""
            INSERT INTO teams (team_id, name_short, name_medium, name_long, primary_color, primary_contrast_color, secondary_color, secondary_contrast_color)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (team_id) DO NOTHING;
        """, (
            team['teamID'],
            team['names'].get('short'),
            team['names'].get('medium'),
            team['names'].get('long'),
            team['colors'].get('primary'),
            team['colors'].get('primaryContrast'),
            team['colors'].get('secondary'),
            team['colors'].get('secondaryContrast')
        ))
    except Exception as e:
        print(f"Error inserting team: {e}")

def insert_event(event):
    try:
        cursor.execute("""
            INSERT INTO events (event_id, league_id, home_team_id, away_team_id, event_date)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (event_id) DO NOTHING;
        """, (
            event['eventID'],
            event['leagueID'],
            event['teams']['home']['teamID'],
            event['teams']['away']['teamID'],
            event.get('startDate')
        ))
    except Exception as e:
        print(f"Error inserting event: {e}")

def insert_bookmaker(bookmaker_id):
    try:
        cursor.execute("""
            INSERT INTO bookmakers (bookmaker_id, name)
            VALUES (%s, %s)
            ON CONFLICT (bookmaker_id) DO NOTHING;
        """, (bookmaker_id, bookmaker_id))
    except Exception as e:
        print(f"Error inserting bookmaker: {e}")

def insert_odd(odd):
    try:
        cursor.execute("""
            INSERT INTO odds (event_id, bookmaker_id, odd_type, odds_value, last_updated_at)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (event_id, bookmaker_id, odd_type) DO UPDATE
            SET odds_value = EXCLUDED.odds_value,
                last_updated_at = EXCLUDED.last_updated_at;
        """, (
            odd['eventID'],
            odd['bookmakerID'],
            odd['oddID'],
            odd['odds'],
            odd['lastUpdatedAt']
        ))
    except Exception as e:
        print(f"Error inserting odd: {e}")

def delete_existing_events(league_id):
   
    try:
        cursor.execute("""
            DELETE FROM events
            WHERE league_id = %s;
        """, (league_id,))
        print(f"Deleted existing events for league ID '{league_id}'.")
    except Exception as e:
        print(f"Error deleting events for league ID '{league_id}': {e}")
        sys.exit(1)  

def get_sports():
    url = f'{BASE_URL}/sports/'
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        sports_data = response.json()

        if 'data' in sports_data:
            sports = sports_data['data']
            print(f"Found {len(sports)} sports available:")
            for sport in sports:
                insert_sport(sport)
            return sports
        else:
            print("No sports found in the response.")
            print("Response content:", sports_data)
            return None
    except Exception as e:
        print(f"Error fetching sports: {e}")
        return None

def get_leagues(sport_id):
    url = f'{BASE_URL}/leagues/'
    params = {'sportID': sport_id}
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        leagues_data = response.json()

        if 'data' in leagues_data:
            leagues = leagues_data['data']
            print(f"\nFound {len(leagues)} leagues for sport ID '{sport_id}':")
            for league in leagues:
                insert_league(league, sport_id)
            return leagues
        else:
            print("No leagues found in the response.")
            print("Response content:", leagues_data)
            return None
    except Exception as e:
        print(f"Error fetching leagues: {e}")
        return None

def get_events(league_id):

    delete_existing_events(league_id)

    url = f'{BASE_URL}/events/'
    today = datetime.utcnow()
    ten_days_ahead = today + timedelta(days=10)
    start_date = today.strftime('%Y-%m-%d')
    end_date = ten_days_ahead.strftime('%Y-%m-%d')

    params = {
        'leagueID': league_id,
        'startDate': start_date,
        'endDate': end_date,
        'limit': 50,   
        'oddsAvailable': 'true',
    }
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        events_data = response.json()

        if 'data' in events_data:
            events = events_data['data']
            print(f"\nFound {len(events)} events with odds for league ID '{league_id}':")
            for event in events:
                insert_team(event['teams']['home'])
                insert_team(event['teams']['away'])
                event['leagueID'] = league_id  
                insert_event(event)
            return events
        else:
            print("No events found in the response.")
            print("Response content:", events_data)
            return None
    except Exception as e:
        print(f"Error fetching events: {e}")
        return None

def get_odds(event_id):
    url = f'{BASE_URL}/odds/'
    params = {
        'eventID': event_id,
        'aggregate': 'false',
        'includeOpposingOddIDs': 'true',
        'oddIDs': 'points-home-game-ml-home,points-away-game-ml-away',  # NBA odds
    }
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        odds_response = response.json()

        if 'data' not in odds_response:
            print("No odds data available.")
            return None

        event_odds_list = odds_response['data']
        if not event_odds_list:
            print("No odds data available.")
            return None

        event_odds = event_odds_list[0]
        for odd_id, odds_item in event_odds.get('odds', {}).items():
            if 'byBookmaker' not in odds_item:
                continue
            for bookmaker_id, bookmaker_data in odds_item['byBookmaker'].items():
                insert_bookmaker(bookmaker_id)
                insert_odd({
                    'eventID': event_id,
                    'bookmakerID': bookmaker_id,
                    'oddID': odd_id,
                    'odds': bookmaker_data['odds'],
                    'lastUpdatedAt': bookmaker_data['lastUpdatedAt']
                })

    except Exception as e:
        print(f"Error fetching odds: {e}")
        return None

if __name__ == "__main__":
    sports = get_sports()

    if sports:
        sport_id = 'BASKETBALL'  # 'BASKETBALL', 'SOCCER'
        leagues = get_leagues(sport_id)
        if leagues:
            league_index = 0  # 0 = NBA
            if league_index < len(leagues):
                league_id = leagues[league_index]['leagueID']
                print(f"\nUsing league ID: {league_id}")
                events = get_events(league_id)
                if events:
                    print(f"\nProcessing {len(events)} events for league ID '{league_id}':")
                    for event in events:
                        event_id = event['eventID']
                        print(f"Fetching odds for event ID: {event_id}")
                        get_odds(event_id)
                else:
                    print(f"No events found for league ID '{league_id}'.")
            else:
                print(f"Invalid league index: {league_index}.")
        else:
            print(f"No leagues found for sport ID '{sport_id}'.")
    else:
        print("No sports data available.")

    cursor.close()
    conn.close()
