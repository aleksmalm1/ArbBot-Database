PGDMP                     	    |         	   Odds_data %   14.13 (Ubuntu 14.13-0ubuntu0.22.04.1) %   14.13 (Ubuntu 14.13-0ubuntu0.22.04.1) !    F           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            G           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            H           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            I           1262    16384 	   Odds_data    DATABASE     `   CREATE DATABASE "Odds_data" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
    DROP DATABASE "Odds_data";
                postgres    false            �            1259    16425 
   bookmakers    TABLE     ~   CREATE TABLE public.bookmakers (
    bookmaker_id character varying(50) NOT NULL,
    name character varying(100) NOT NULL
);
    DROP TABLE public.bookmakers;
       public         heap    postgres    false            �            1259    16405    events    TABLE       CREATE TABLE public.events (
    event_id character varying(50) NOT NULL,
    league_id character varying(50) NOT NULL,
    home_team_id character varying(50) NOT NULL,
    away_team_id character varying(50) NOT NULL,
    event_date timestamp without time zone
);
    DROP TABLE public.events;
       public         heap    postgres    false            �            1259    16390    leagues    TABLE     �   CREATE TABLE public.leagues (
    league_id character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    sport_id character varying(50) NOT NULL
);
    DROP TABLE public.leagues;
       public         heap    postgres    false            �            1259    16431    odds    TABLE     &  CREATE TABLE public.odds (
    odd_id integer NOT NULL,
    event_id character varying(50) NOT NULL,
    bookmaker_id character varying(50) NOT NULL,
    odd_type character varying(100) NOT NULL,
    odds_value character varying(20) NOT NULL,
    last_updated_at timestamp without time zone
);
    DROP TABLE public.odds;
       public         heap    postgres    false            �            1259    16430    odds_odd_id_seq    SEQUENCE     �   CREATE SEQUENCE public.odds_odd_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.odds_odd_id_seq;
       public          postgres    false    215            J           0    0    odds_odd_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.odds_odd_id_seq OWNED BY public.odds.odd_id;
          public          postgres    false    214            �            1259    16385    sports    TABLE     v   CREATE TABLE public.sports (
    sport_id character varying(50) NOT NULL,
    name character varying(100) NOT NULL
);
    DROP TABLE public.sports;
       public         heap    postgres    false            �            1259    16400    teams    TABLE     t  CREATE TABLE public.teams (
    team_id character varying(50) NOT NULL,
    name_short character varying(50),
    name_medium character varying(100),
    name_long character varying(150),
    primary_color character varying(7),
    primary_contrast_color character varying(7),
    secondary_color character varying(7),
    secondary_contrast_color character varying(7)
);
    DROP TABLE public.teams;
       public         heap    postgres    false            �           2604    16434    odds odd_id    DEFAULT     j   ALTER TABLE ONLY public.odds ALTER COLUMN odd_id SET DEFAULT nextval('public.odds_odd_id_seq'::regclass);
 :   ALTER TABLE public.odds ALTER COLUMN odd_id DROP DEFAULT;
       public          postgres    false    215    214    215            A          0    16425 
   bookmakers 
   TABLE DATA           8   COPY public.bookmakers (bookmaker_id, name) FROM stdin;
    public          postgres    false    213   �'       @          0    16405    events 
   TABLE DATA           ]   COPY public.events (event_id, league_id, home_team_id, away_team_id, event_date) FROM stdin;
    public          postgres    false    212   a)       >          0    16390    leagues 
   TABLE DATA           <   COPY public.leagues (league_id, name, sport_id) FROM stdin;
    public          postgres    false    210   (.       C          0    16431    odds 
   TABLE DATA           e   COPY public.odds (odd_id, event_id, bookmaker_id, odd_type, odds_value, last_updated_at) FROM stdin;
    public          postgres    false    215   �.       =          0    16385    sports 
   TABLE DATA           0   COPY public.sports (sport_id, name) FROM stdin;
    public          postgres    false    209   �Z       ?          0    16400    teams 
   TABLE DATA           �   COPY public.teams (team_id, name_short, name_medium, name_long, primary_color, primary_contrast_color, secondary_color, secondary_contrast_color) FROM stdin;
    public          postgres    false    211   [       K           0    0    odds_odd_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.odds_odd_id_seq', 4584, true);
          public          postgres    false    214            �           2606    16429    bookmakers bookmakers_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.bookmakers
    ADD CONSTRAINT bookmakers_pkey PRIMARY KEY (bookmaker_id);
 D   ALTER TABLE ONLY public.bookmakers DROP CONSTRAINT bookmakers_pkey;
       public            postgres    false    213            �           2606    16409    events events_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);
 <   ALTER TABLE ONLY public.events DROP CONSTRAINT events_pkey;
       public            postgres    false    212            �           2606    16394    leagues leagues_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.leagues
    ADD CONSTRAINT leagues_pkey PRIMARY KEY (league_id);
 >   ALTER TABLE ONLY public.leagues DROP CONSTRAINT leagues_pkey;
       public            postgres    false    210            �           2606    16436    odds odds_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.odds
    ADD CONSTRAINT odds_pkey PRIMARY KEY (odd_id);
 8   ALTER TABLE ONLY public.odds DROP CONSTRAINT odds_pkey;
       public            postgres    false    215            �           2606    16515 (   odds odds_unique_event_bookmaker_oddtype 
   CONSTRAINT        ALTER TABLE ONLY public.odds
    ADD CONSTRAINT odds_unique_event_bookmaker_oddtype UNIQUE (event_id, bookmaker_id, odd_type);
 R   ALTER TABLE ONLY public.odds DROP CONSTRAINT odds_unique_event_bookmaker_oddtype;
       public            postgres    false    215    215    215            �           2606    16389    sports sports_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.sports
    ADD CONSTRAINT sports_pkey PRIMARY KEY (sport_id);
 <   ALTER TABLE ONLY public.sports DROP CONSTRAINT sports_pkey;
       public            postgres    false    209            �           2606    16404    teams teams_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (team_id);
 :   ALTER TABLE ONLY public.teams DROP CONSTRAINT teams_pkey;
       public            postgres    false    211            �           2606    16420    events events_away_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_away_team_id_fkey FOREIGN KEY (away_team_id) REFERENCES public.teams(team_id);
 I   ALTER TABLE ONLY public.events DROP CONSTRAINT events_away_team_id_fkey;
       public          postgres    false    211    3235    212            �           2606    16415    events events_home_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_home_team_id_fkey FOREIGN KEY (home_team_id) REFERENCES public.teams(team_id);
 I   ALTER TABLE ONLY public.events DROP CONSTRAINT events_home_team_id_fkey;
       public          postgres    false    212    3235    211            �           2606    16410    events events_league_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_league_id_fkey FOREIGN KEY (league_id) REFERENCES public.leagues(league_id);
 F   ALTER TABLE ONLY public.events DROP CONSTRAINT events_league_id_fkey;
       public          postgres    false    210    212    3233            �           2606    16395    leagues leagues_sport_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.leagues
    ADD CONSTRAINT leagues_sport_id_fkey FOREIGN KEY (sport_id) REFERENCES public.sports(sport_id);
 G   ALTER TABLE ONLY public.leagues DROP CONSTRAINT leagues_sport_id_fkey;
       public          postgres    false    3231    209    210            �           2606    16442    odds odds_bookmaker_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.odds
    ADD CONSTRAINT odds_bookmaker_id_fkey FOREIGN KEY (bookmaker_id) REFERENCES public.bookmakers(bookmaker_id);
 E   ALTER TABLE ONLY public.odds DROP CONSTRAINT odds_bookmaker_id_fkey;
       public          postgres    false    3239    215    213            �           2606    16516    odds odds_event_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.odds
    ADD CONSTRAINT odds_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id) ON DELETE CASCADE;
 A   ALTER TABLE ONLY public.odds DROP CONSTRAINT odds_event_id_fkey;
       public          postgres    false    212    3237    215            A   �  x�]��ҝ @���t�i�{�nr1*#&���}�(�~9���3i׈��Y<�-��%�;�EL�c�/.�g�A�-6�p~��D�^<;��h����,>N>�___g܂�����yug����G��󖔪d�o��t��p��[��ꃜә�"֝P������Dn��H��E�T��Q�����6Cb���Tf9��p��Yia�^㋛m ���8��b�!�5X���<�f�i h���GրER��[l�o:��J���_7S���-:g�p�V���7`=��;膉��H�f��Z��ƶ��ގ䵯�[�޻�\<��ʬ�@7��"������6g�Vh�Q6�
��G�T��C��z�`���)б%h��a� km��i�+��|��B=�K0��RY��m����AC�׊���Q���=o5^�������"���g      @   �  x���[s�:���ك'�� !����0`�E�z�_�Qk��J�!�o�������?�41�ާhjJ�c�!2� �"@@b27�>�u��
q�	���x���d��M�h������ux�ȌRG$!��߶�gB�Ȟb~v�x�W��t�mld����l�8DM8'2��	�0�Ml��r��PT�6YxhD�4x�7^#����x�p�#*d�S��;$:��ږ2�
��y	Ҽ��"ډ7�F�
I�r�a ����6F��şT����G�����:)d鮆]�FhHIZ|o �������ו�;��AD���=�T0���3� �/�5�ӈ��1��� P�{���)I�9R~�T�TuQc��gkn���}`�D���^U!g��FW��q-�@�D��fe�vS�����H��O	��k{�u�݄1���5*Xt��/�<�;�.�q�&�n�1���?ћph��Ɵ��;B!��S3g�&�c� c�65�!�4��@OǏ㡺Q=ahC*��B�.Q�`s��DD���7,a���w���l= 'nw)p��qu @1`�4���!�5�� ���q�6���V��Ǚu�ĥ(��K�n`�EK@0Ly�z�2�&���l�X*݅8�q��fm�z�k;d&3�f�/L�2@�Ŷ���y�����X�@z����Ļ�
��SF��b���oAB��.�����o�K8�^;�c`�&��7ࢴ��Z����id�{����x�u�����1�f�5Z�+1�m(Z����[�,��b~�e���YGQ��-J���G��2s������AS���=w�ҕ~Qǁ�hYZ�g-�k�>qz�p,�}ƛ�x�g�mKΉUB�BH�G�R�������<� n����"&�[wy�\)�M'�����y���n sɆ���.;�O�y6�y���c�~�RL��z�ʋ"7ز:?-��#�7]�8��� Ga�q�p����t�6	����Ӵ/j�Eh���QkZ�˒Yl��m���xoP\$P��v�s��Ę�;m[���b�rv���N�+��_Z��>iX��g���b=��#��Q����=�sE6rT��z�疲T{��~�k/�0�E��E�zrR�1����ϊ�dm]�A�{A<g��`�m��7f�e����:��Y3�J���Skc��,:�D���	�{��Iy��?�����7 .&      >   U   x��sr��b'�`o�'G. 7�=����=�$��듚�^������щ�9?''5=U�)�8;�$)1'YM8��p4�c���� z��      C      x���Yw����}~�}gqVjJI��<�y\��0�6)ۀ��7����;bWs�Xt�ޭR�B�-E�1n|�����{��w�϶l=*;��7>ώfg{[�'�{Gg��g�g�wf���ƿl\�}��;�������?�������bLP������[U�^��>=9��}��U7˺g�ۧ[�����.���������ю��9i�U�>�}�tqr�}{�^���dS'���y�7����;;��V��fw�i;���KE2I�<6�˒��ӓ����UQ_�I���έ��-M3
��� ����c��I�*4M@�����ޖ�:\�׏����٧����m}�J�j�S@���Ч�(�e� �gg[��������J������kb��^=`�������pw�c��qѷ=����d>3Z:a��V�:�;:�m�S@v�S��u8���v���|2,��b����῞�{@ٰ6���Y�aCC�{߶��ګ�Sv2��P�U��m�N��כ��� �:�>���3S�`:�.D3 ��h�U��$����|g��ӏ�Tpߟ�:ps\;���o������������O�~�f@����������jL|m�ͷf�:�̈��o�O��� �������p������`�H�ǅ��b�- ������v�^!ۚS lm�mͷ���\Z�x( �������	^t��;��o�[�(P,���ϟמ�N����p��=�>W�UX����6e�2vф��Y jG��Lg� k+�O8�bE,��a��ڛ�ET�֢���(��V��������_�(N<�]����i���fώϷv��`l'��Q�? k�˳��>���U\^����Wa�4������X]k��ZYçZo4��� NW�R�ǃ�R��e�z��M �JZJ���]�L]IK��^����Z_�5MKI��|Ī4�l���c�R�Ck���������o�V�Rt'���]MKI�C�*�oS��մ��	���ܮ��$�a�mr��IZ�\��&9��$-E��֧�����o�;-�Lq\IK��_��gZ��v�� [BZ��˾\M�R���:�i�� ZW�R����eZ*9�J������:�[IK�=�{@�i��X�8=�gZJjk��)[MK��0�3-E�0v��jZJ�擗�0ɱg����_J�&i)QU��GU ���ZO�5IK��	(X���Z{d�H�#-ŭ��y6 ��HK�=��i)�TY�HKI�v��ލ����Z�;-���ϴ+;F��6IK������b�� ���b�ڥ.Bm5-%N��S#:i���ֆ"�M�մ=�tj�i)����c1#D|�,��֓F���i��VG�혤���ql+��jZj�@q�i)Zr�8��GZ�^��v���|�l��#!�4-%n�4����jZ�Tn���jZj��Y8V�R\�r��J;q����V��ۣ�}����΋O�pK��6��R׃vZ���C�5�R�aU7˺�[��.�6㖲���Ҵ�I���l@[�5��h3MstH����zg�Q�˲�[JI�5;�$j:��P��$e����а�����m��I�_i��fy����ٮ�a���W���&$��e�'�(��62 ��
�L�^!e�f@�2.2`��
Y} (��BJ�$�l�����ey�����p^!v���,�+�@P \�WH[KU��2Flt�^�A�j����&Z�t�����zRAl^!� Z�W�H�ę��zc@a?�U�y
���
)SM����ѡ�(<4�G�hc�
 ��G�~�#,�J�V����M"F���%��WHx�-t�&%oR[�Ih�(qRQ�h����������w 0ˀ��4}�RZ;[��	��(FK��"EF��@���{
C ��;�����˨�bXÖ��be�; �����Q�������2-�wh�2�R��D_� S�[�Zp�. �tKY�El1n)K Ƹ����,4��{0��$w�H�ô��&�mZt 7��%�t1�:���^�Q�f:��߿�lډ�$l#�=�q�f!�6����I��eZ�� 6˃$���Y�]=�eZ���04t.��{�I$�B�P�$ҖC�5��~u�� 0�+��Y@���]���WH��@��6��	�e{��U�>�$��R>V p^!�c-UQ���
i�p^!�� -�+d�� ��Wh���ݚEZ�h�ҽBF$[�W�@+��2���83=`�ix��#Yu���#���
�ȣ�ވΟu�~衏(<4�G���>�(����ť.@���k��1�x�iB�W�0�&wwV8H�3�դ�8�tW�e�'�a��QE���I��xF9��n@�zÀZۘE��(Ʊ���a����2�b���*ʆy8�{
`-hc@�oh��׃��7���#���z@�v�i)d�P�R((hzq��~~��Ώ�����<�q/��Ƹ��~~������fU�����2ڛe]�-ehY�rK�U���R����Am�-�곓%)����g/�2&$��I���Jx����l���6�g���i%%�2@�1a�����`3�R��xN��L�<=^ ��W���eX~�pʩ�x%cS���\�r�.�&�7�n( [�ڥωpkY���* Z�ڥ�)���a�2t�����HXv���vM�.�%
3�]8�W \�����Z\_\��Kp1�.��� -�ڥ��
貭]���9��E��嵛�}ElY�.�m�߲ -��e4p����(%�*��4��[�5��k\r`��]��7�)�k|X*w 2��sh��1�.�S�"fX��;�c��Q�u���k��b@�Ă/+��e�`H�;�c��?��g�GWk��>,E f���.h�l�.y�ۉ�R�Rʗ`Qv)�h�Wm�l�����(��㋃�ˡ�v07�, K�a�(>��� W��kپ�ђeڰ���o]��m��Ӡ{U��ٰm�g�ҥ1i��{��z��mX��h��G�"c��Ȇ�=ڊ�&����Ƙ��AH� 8��%�Ť�2f��$�e�+���]��5j�Ͷa�> ��G,��j�  �����;��� Z�i�Z���`���wu�ub�xv�ۻ�U" �,{�6� �ޥ�<Sfٻ4�H� 3�ޅ�H9��?a�B�9�D�e�pE e��-�� .�ޅ���]�� -�ޥ�X�L4�]��
�����eػ�y !�L{�.���h{���%����X���TN 6�8&N
m�I 6�ޅ�H�\۰w9dp�	�@:��1��	�$'�j^o'���@9����ʐ����pb)- 0�)��s��Gy?�߅nAd��`�XxaD�މ�V�6�tp5��L{�� G��B���x9tw�98(w�0NW�BN���&u
Y$���Hk�,rr�)y�mzq�����כ���ovO�?}����1���̹�����|�{M�=�!�R����r{�C�����ϐ6����]C���*�e����=�!��W{�	w��w{�CҴ��ɗ��YI�)���aI�+˨�H��MҠ]I���Y2N���[�W2.N��e��,��q���R|�k�Atq�"\�*�P-���
��a* �p
]SJ�Pf:���ΐ+ �,{��E���
�2�	?)	�b
��G=st������q���h1��[:@�]0n:�.�1��|�Eo�	�����Y�脸`��
f�K�������6-��F���E)_�zJ�3�щ�-�*@�)F�+�ͪ�&���-cvy;��wq 3����o���15���S^ƌ�V�C9�S�O�f[p��c�
�b��ɽ�*`�(�'�hFA@�=0J���q���D= ���C��Yf�<�\U�x�RK�ɏֵ�PT��P�$O� ,��t�\�_9�-�����n������R|��Í} ТJF-�V<�L����,�"_��G%�Ѭȗ��b	 0���!@���	���7 ���F҈2t�.h,�̼�{=I��QA ��    e���<PDH�K��\��*�h|.@��@�����2-U"��,��J(�o#@�+�`t�B����z��*�Ŕ�A9,���kO��N������!cz�8�B�ID�`\�޹\m+��q�. �,'�ݭ��(�P¯$��0
�E��RI -�`�ЩKU@Y0Np1�UtF��GV��D�`\��2�HK%�Y�Vl��&@�U�.j���
f�K����1��PeU�F8��Ϸ����٘U�N�� �����FF����n	��^z�������f\y;!�X�TQ�X�T����M�S�N��T3"���(kc\1��䰣���2|x��q��+çH���q�*6���zy�jd�����f d�0�G�� �7����� QX:鵛eZ
�8�:��A�LK!'Q�O�cZ
Y9�ҁq:V��9Ԋ|`K������ͧ']���wc�}��j��מ4iePJI�4�RO�J/뒖];�ڶ�E�Ӆ(k[Z�#��*K2Y��_} h�C�dU�㦖�)�ɺ���.�ˢ�n+5Ȳ���.�f[���J�q�h�(f;zT�*��t��N\��+q��>���_�����(�֩�d�#�:I� \��h��_v��!�� W�����(�r�@�Z�psV��7�EY��#�Gj9��0_��Hls��V3�G�KBաŋ����l������ۑ����T�c<B��|u�8�#$�6� 
	�_�4�#$�◺�3�#;�c����V��0�&�׾������z@�?�} 3<�Y{�XQ~&�T%4U��#q �Ҁ/�*�vI��?`1~&18j�pe���%��Vbe�[aЪE���By��N (�{�'� `��|�[5�M�md72-cT`�22	�W&� ��|<�՗Ui@�m�Q�j@�Q�];��Kw������k�;D�\Ԑ��5&�9������@��bQ���pcLR��U#`��b5���iB�45��徒���c ƙc`��a�9F�+�Ls�Ԅ���Inh��	p�X�`y���f�xԝb��.�ţ��Lt�Ԅ�"\<0*N�+�Ń,5�(�*�X�V����(�:�z@���^#Zfxz������;���-�vZ{�x�v��Y�l�)�ժ=>�2<�Ų����\d}8�nу?5��۠J�5�8����]����2&Ͱ����F9b��Ԩ�3����f@c�Q� ��z�OXQ� �E�8:�<�tS��p)��-����"�AJKQ�вɒm�B��(a��\�G��W��6,|}�"�w}B�b��E�.�$�?fx�_�����le��Ƭ�9ߊ�_?�}��d��o��,̋GN��T�	-v�>���_������4<{~�`~�C|�����	���q�����_͞��t�p�������U��P�b@�
��;�ܙ߾�{��ɋ������T�u��	K-�?^�辞������~<�7�?�sr�R|�'�V�++=m�5��L�U4�;x�7O���o7l}p�'�:%�6�:Y�.��z|�j���.��.�^��,M�\�;�FĠ��Q���MP�,�(�������f�,���q�̲$Y��e�t�p���?�&i.�5�z�B��1O���(u&���~���%�ȅ��3�v���GU�S@~�b��$��>�b���F\�4T\)X}�u�.�.�>�8�Q�WKa����4��cDE.<z�S���Ҕ�*���$S6�ʈ2<"n�T �]-�)>�A`fW�qRe�ߺ 5*fr^�A< �)��"N�x!3
#�4����6�f@�Y���-� 	X#�}����V\s���	h�
���E� oD�	7����� 6�@���Rp�TrP>@�)g����w띗�BU1\ƻ�nZMm�T\-}ƍhkFT�Ч��"J�i��Ao�՚9nZ^tU�����bG��A�1�;��TQ�h?/�0�ʈ��ŉk�=��'?��{���'��Y9�=�%.�i��A�ʺ��.��p�Uԥ�z����N�f��x5�O*�f� uɛB%�Ch)j�w]P-�A2����� ����I����,��eY�F�\!y���4�F�P'z)
0c��ck�����C�0@��������r)�Q�e\>P4T�E'}*�[�Ee}.�cy1�̻�F_ ҈�3��8��4�~����&b�iĝ��QPF�ƽ��� �����Ѡ0�=�ڋ �.@���k�i����K��ޠH�헆.�5�9�zπ6�2��S��5��Jѽ26� �({�|9�
�f[
 �0�
Ud�� 3�։?T��.Tt�~�1�YE��xؔ��2<l��=h���>�w�E��+`�/��0ޚ���Ay_s�E�2ۀ)�0kM�169y��5����9���8t�@��_߇��>�������kx��3��l��+˺��_�[6HY���k� �*;���o]7k�K���W�� v���͝�����t�:�k�ECG|��&�󗽸��FY�ئ#�� �dQ3� ܃[J̘��0f�� 2r�n�� 1f�4����э����*MG�P{hu�r�ŤԹ�9 ��;��d`v��/�E���>'cv�I�`�* ����t���.���tR���w�Y�xq�4/��2fg��V�2^������!#w�N����j��\h�4�H3��e�-[6�Fm��y=Ȣ���GW��x@����()܎���|� e��<;�s0�l�U��5����A�el�{�6j���:�� Z̞_�d ��>gu% 0;%,C;�.ڊ�[r��	& -y��./�Fl�elGQ@�%1W�8������Ϗ_~����[��>8�=!B.7�cV@����o;BE7ʺܵ��I�f���r���~�s*���:�l7,Dms�/|���ʒ�R苅�S���~��(!9�^���T� 8fs����,���GI@�-W
 �,�Ӌ�KU�e��-p1�g}:H -Ɔ����~]���[~���dc��\l�8w��1f{.O_m��c��\��FQ@c��(Q �}��M���m�1 jԶ_4t���1�~���l��_��Ac��0�̀6s��v��4�k�fR�͏� 7j�/��ۢ�p�ֿm�@[p�>]eKU���Pl�KI@�Co	)�
 cv���3�ء����Y \�FZ�
@����` Ɲ��sM���Վ�
`�ة��<�]0���[�V^`�ة�S�(
(#v����R6^ݭ}�1;�_��r���w�n0v�i��ՏUe]����?u��>jv�:Y�0��M�P�6ͣ��Y�6���p�����5�XT����]�eͿ�㻚eY�;�y+`���ã�
H�o�eI��X;>[��Qv|��?�U);>2��E��&`���kl��E����� `��_[$|(���ڣ5��1v|4��`F��E �5�;@c�Ǣ�2ʎ/�pZ��������;��P�����;��Y�y-�����ѡ�;��m�G�0�f̭�# ka����wv|�k��?�$���5�;�l����p�� 2֎��
���X F��u�{��Yv|(y�e�W��xcfZ�Չ<�������xk�g��&��aǗ:y�h���㋃�������ǿ��v莁B�7�={x���G���go�t�_>QO�c ˺ē�t��˝�O���!]ei3�`��/�eO�+�P��dm�a?��6�$��_�p��`?ɨ�p��֓�ғ�=�dM��@�({�@"���`���F��7�٥*@�~���|�QO� `��`�@�R�E�	��O�-�Y?��b��mf� [�+��"� cVF���1OJ�<�	0F=(����c��Ee��@�c��Ȉ'��O0#�� �=@�{2pzʻ*�2�a?���[/c��~�÷������ګt����R�F�*�G�V{�f�*�	��˞�qO"�B +  �R���V�e �����!Q��3@�z27 F=8}cj��W1��@�R�����@�3�Y?�v�E���ڋD�[35�`��3#�D�}�QOF��/�1��@q�Ee̓����7�����ŭ�����7O�?
���6�vߴ=�'�2�	�@���.�QP=��dY���kȰ�D��GA����[em��&��ɒ��8�|u���b!�EW/+s�	@Q�A6��`n�p���?
�*`�����
H�n@U �'h/ U���'f��&@��M�ז7Gs�]�H��B#ohz� c�m]0F�& 瑡�q�	��*���M "���?��R7v*���M����1�	�2t 5�6��_�%� k��_���[/f��zu1|@����Zph)c=�`������fIp�n SAp 8�6X�����X�.(��78@w� �z u� �Y��n�^� -�6�6\= ��M��
����	�	�����,`��M�u�n�E�̨��1��e�mi莋���?^߸y�����=�y���ї~�8�W�m�ɺ��P��ᇈ�\QF�Ȩ�	*J�g�~Z�mU7B]��m�����m���S���5�荎Ȳ2u�}!Y�<��e�0,ɢ$�G�^�j�	�бKU i���R�Ɯ�+� 2朾��*F�8�WZ
�b��u" �;N���3����
!ƈ�t�/��+ʘ�t��L&�q�.S6�ʈ�tq��ko����^�`�>N�*-��2�j�v�5$ �}�nt^���t�r�b�&��y�.4y1�$�q�ް		�F�P�[w����Ғ�z��ه�~:.Ej̡�бKU �~���1G�Jsd�ѷ�V��q��h���o��ƝP�M3O�Vd3`�8��b��2��9��b��Lf�qB-�QPF�P{i�>��9n�#��A�������ޏ�{�g��2�^5P���Kx0՛!��04��Tg�?r�kS�+�k7z������/�ۏ�?��><�w�!�]�L7�8Y����Q�,M�����6u��
G���4����~�O��a�������\?s���ec���ٗ�?o׷�n��8��6߼ o�8�6J��ù���f�;��CCu\�%��:AW��a��뷩�w�ɝ�[���j�����Y�P��07!��I�&'$]���Y���f���.l?���`�t?���v�����/��ŋww��oϞ>}�b�&s+P����ɺ̤�{Y���T� K�`t�H��8ѩ������{��ח�t?��]6��<9�w��ey�x�������C��,m��]�u�rӪ��di���.�da�]�S�,|?�Q�����KG��Eam����~��������?��z;l>߹�q�v������=�!
S��b�8D�T�����
W�͂tU���~��b������/�����w?y��j7{'�2pki��,�MHz��,M��v��Y�~j⤕Ƣ�YP��[�g�Yj��_�>���~;����������߽;~����҃�[eݿ}�<��.	����9'K��k��,7D?� U7p�,	��h�l?��J� �����G�Q��=�>����޽won�G�'���񬮯!˺̾[
B���}���*K��YՎ���4�r�ϒ�:�F����f��@����7^����ܘ?�''�e9��p���C]bcb�%
5�I��,��J*-1ot���_��4�����~�4��۫�1Y�o���Xe����2�v��͍]�Q���k7&���$�9�c
t?��������i���W?n}8�p��|���w��x�ۈ�R/��u���,L�t�"k�}��*��kGI}��������=���K���W�n>�~0?��c��Փ[{�=���x��l�e����w�?4]Td9�I��9k~M���^���֯:v��J7O�f���Ț�YE�ʪ���O)a��y6���Q�v����f�>Ώ����g���z�W$�6�T���\bQ�e�xf�������_1��ēn�ح��<%I1�=@ɾC�k/1���n���P�WAX�>��
�\x �O���@�*��	���W�W�,ic���G���C�`vp�����i>%z�z�^��VOxy2�,뚫�,9vk�%��S��__���n�x�����H�4�&x�263���x��7�^��WO�iiz�r}��_�FY�Y�U@����G<+ਔ2e�3�-� ".�Q��-����q<��%Y��U� L�,;�\�$׺`>u�$�zw�Rxb|��� �/��K�������S��� 1k��
HbnDK_�1�:��U�EQ�c��������{o�n����?>���zܓ��ԧ��u�,K��nO�ɺ̼7=3]6�ˢv� J���,�ѬO&�q�͈�"�41�=��%���H��5���fY�HP	��
h�@�`���KL ���;y ����̦�δ�~!y�;�kw����T0�,h2�����L���[�y� %3ȑO5�_H���2��� ���U��8,N5KFP����W &&(QTKDP"~�q	 $=����BM/m�����|�������ǽG���;HY�ÿe�xe�SȲ.�w@��O���y�V���+�4�h�0t��I-��i���J,��E/kZy�p���˭����L-
ry�
H����s��#&�[چg����FY �w@�
S4�yQ�}�`���( %@�w /ϤH������ OD�ՉJ	 e��U|�' ��w��_�D��* ��;��`R1yq?7ϺqQ^�y���l�����ݻ[^�w�P>&�R�<�m�i��=�i����<H�� �,i��f��YS��� ������W��S�˚T�-��\PU��+j�YdM5 �.<���z�?��نR(�a�&b*?���S�"�f���G2`��K�F�ecMv@"�38~+ ��w�/��P����5�r@�8�d@�8p��
��_���� (#ȁ�H,Q1����P* %+t�!&ȑ��0�������gh,2      =   �   x�5�A� D��Sx� -�-��٘�4�h�6`J7�ަ���̼��.�	޶L�2���	4ʋ�1���P!�D��N���[C(���rq��i����P@ss�h��s�kl+V��]�ٚ�hI����ԫw.�`}����h1�ӑ>y^
�O �2�8o      ?   �  x���Q��:ǟ˧h�����>�R�cm	�zvs�뒕��q����w
V��ǘ��b���f�DA�P����	�D�b�/����R�
_L{4��� ����?��8�[qq0�$�y�!�h�i��sQ�J�g=��n>Y0�M���e���k�(r�����H�	�m���5�� �%�mm"�#�5c�����0���ڔՇ:�6������`S�p+�IƉ�,!�}N����	�ZUVد�g٦�*U?�?���=�\�%��`�\&���1�����Q\T�^�'H��mU�3�B]ߥ7��t1s��$��rCre�ynE��޷\S���s�"y�ԡyU���ol�S���3�-��oYD'&#yHv�4A������N�����!�O�����y����;�$���x���N�m�@WM�\�8�TW�+���2�������(�M�8��V�ۛ.oN��/EU���M�;���XeR��$��0ڕ��}>A̧CY�tM���.�V]"��ݒM���d��Ū����b_ew¿p+`Y"�,���������PPtmSv���(��/�YEtPM��F��{R�7x���,��-":�,p�hH.3(o(�k_Ea�ֺ��A�U�Ae��sJ�7��`<�F�[�Է�)�YD/�B��UW�aV4��ؘ��3�_�:�z�2Y�k�a!�h]�z:�{l�#���Zs�Ӊw�Z&)2�'$Ό��%��Z͚���ۦl<���:pk��0�A��zO`���m;u���]�/d��٥��P2��ӭ0��'Jϵ�MQ���ް��&��T�
�$<��'������S��R'|w������_%���`���E�%;���e��E��T�u]�(`p�BU��4%"��$E$�4�^ʐBw�ogHz�j�y�F�����#K�}�p����'���������qA��N���~ܢ�=�~�P�@xd�GT����^hU��&�1{>���^+��ű���87��֫*�\�.^<XS���%����T@H�_^t_E5�ƴ�K2��e���Կ�Pn�>M$]w�P���|؜�F5���.[�m�OE�����	�v
۠U[~~B�@%�+��8��'�3s�lwo<_��A*4!�[v�(��5o��}�^ݱ�g�)],o��l1Z��~�cY���ȉ�     