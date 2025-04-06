' ========================================================
' SPACEGAME by sean butler
' ========================================================

' MIT License

' ========================================================
'
' hardware and global setup, seed, window, etc
' 

RANDOMIZE 0
OPTION BASE 0

CONST TRUE = 1
CONST FALSE = 0


'=========================================================
'
' SETUP THE GRAPHICS CONTEXT
'

const screen_width = 640
const screen_height = 640

const screen_buffer = 0
const back_buffer = 1
let current_draw_buffer = back_buffer


graphics window 0, screen_width, screen_height, 1
graphics write 0

'GRAPHICS BUFFER back_buffer, screen_width, screen_height
'GRAPHICS WRITE back_buffer


' ========================================================	
'
' WHERE WE STORE THE DATA FOR THE GALAXY / SYSTEMS 
'

CONST galaxy_size = 256
CONST num_systems = 64

DIM system_coords(num_systems, 2)
DIM system_details(num_systems, 9)
DIM system_name$(num_systems)

' ========================================================
'
' DIFFERENT HARDWARE HAS DIFFERENT SIZE SCREENS WINDOWS/PICOCALC  
'

CONST scale = screen_width / galaxy_size

' ========================================================
'
' GENERATE THE CONTENTS OF THE SYSTEMS AND GALAXY
'

SUB GENERATE_STAR(id)
	system_coords(id,0) = fix(rnd() * galaxy_size)
	system_coords(id,1) = fix(rnd() * galaxy_size)
END SUB

SUB GENERATE_SYSTEM(id)
	local n
	
	for n = 0 to 9
		system_details(id,n) = rnd() * 5 + rnd() * 5
	next n
END SUB

SUB GENERATE_NAME(id)
	local vowels$ = "AEIOU"
	local consonants$ = "BCDFGHIJKLMNPQRSTVWXYZ"
	local name$ = "" 

	for l = 2 to 3 + fix(rnd() * 4)

		name$ = name$ + MID$(consonants$, fix( RND() * LEN ( consonants$ )-1 )+1, 1)
		name$ = name$ + MID$(vowels$,     fix( RND() * LEN ( vowels$     )-1 )+1, 1)

		if ( FIX(20*RND())<1 ) THEN
			name$ = name$ + "'"
		endif
	next l

	name$ = name$ + MID$(consonants$, fix(RND()*LEN(consonants$)-1)+1, 1)

	system_name$(id) = name$
END SUB

SUB GENERATE_GALAXY()
	for n = 1 to num_systems
		GENERATE_NAME(n)
		GENERATE_STAR(n)
		GENERATE_SYSTEM(n)

		print "system: " system_name$(n) " " ;
		print "at gal coords: " system_coords(n, 0) ", " system_coords(n, 1)
	next n
END SUB	


' ========================================================

SUB DRAW_GALAXY()

	FOR n = 1 TO num_systems 
		PIXEL scale * system_coords(n, 0), scale * system_coords(n, 1)
	NEXT n

END SUB

' ========================================================

SUB DRAW_RETICULE(posx, posy)
		
	r = 4		
	CIRCLE scale * posx , scale * posy, scale * r
	LINE scale * posx, scale * posy - scale * r, scale * posx, scale * posy + scale * r
	LINE scale * posx - scale * r, scale * posy, scale * posx + scale * r, scale * posy

END SUB

' ========================================================
'
' GAME STATES
'

SUB GAMESTATE_INTRO()

	IF game_state <> previous_game_state THEN
		previous_game_state = game_state

		
'		GRAPHICS CLEAR back_buffer
'		GRAPHICS WRITE back_buffer

		TEXT MM.HRes/2, MM.VRes/4, "SPACE GAME",  "CM", 1, 4, RGB(255, 127, 0), RGB(0, 0, 0)
		TEXT MM.HRes/2, MM.VRes*3/4, "Press Space", "CM", 1, 2
	ENDIF

'	IF INKEY$ = " " THEN 
'		game_state = 2
'	endif	

END SUB


' ------------------------------------------------------

posx = 32
posy = 32

SUB GAMESTATE_MAP()

	IF game_state <> previous_game_state THEN
		previous_game_state = game_state

		CLS
		TEXT 0, 0, "Galactic Map", "LT", 1, 1

		DRAW_GALAXY()
	ENDIF

	DRAW_RETICULE(posx, posy)

	user_input$ = INKEY$

	if user_input$ = "w" THEN posy = posy + scale
	if user_input$ = "s" THEN posy = posy - scale

	if user_input$ = "a" THEN posx = posx + scale
	if user_input$ = "d" THEN posx = posx - scale

'	DRAW_SYSTEM_DATA()

	IF INKEY$ = " " THEN 
		game_state = 3
	endif	


END SUB

' ------------------------------------------------------

SUB GAMESTATE_CARGOHOLD()

	IF game_state <> previous_game_state THEN
		previous_game_state = game_state

		CLS
		TEXT 0, 0, "Cargo Hold", "LT", 1, 1

	ENDIF


	IF INKEY$ = " " THEN 
		game_state = 4
	endif	


END SUB


' ------------------------------------------------------

SUB GAMESTATE_LOCALMARKET()

	IF game_state <> previous_game_state THEN
		previous_game_state = game_state

		CLS
		TEXT 0, 0, "Local Market", "LT", 1, 1

	ENDIF


	IF INKEY$ = " " THEN 
		game_state = 5
	endif	


END SUB



' ------------------------------------------------------

SUB GAMESTATE_EQUIPMENT()

	IF game_state <> previous_game_state THEN
		previous_game_state = game_state

		CLS
		TEXT 0, 0, "Ship Equipment", "LT", 1, 1

	ENDIF


	IF INKEY$ = " " THEN 
		game_state = 6
	endif	


END SUB

' ------------------------------------------------------

SUB GAMESTATE_HYPERSPACE()

	IF game_state <> previous_game_state THEN
		previous_game_state = game_state

		CLS
		TEXT 0, 0, "Hyperspace", "LT", 1, 1

	ENDIF


	IF INKEY$ = " " THEN 
		game_state = 7
	endif	


END SUB


' --------------------------------------------------------

SUB GAMESTATE_ENCOUNTER()

	IF game_state <> previous_game_state THEN
		previous_game_state = game_state

		clS
		TEXT 0, 0, "Encounter", "LT", 1, 1

	ENDIF

	IF INKEY$ = " " THEN 
		game_state = 1
	endif	


END SUB


' ========================================================

GENERATE_GALAXY()




game_running = 1
game_state = 1
previous_game_state = 0

user_input$ = ""

DO

	SELECT CASE game_state

		CASE 1	GAMESTATE_INTRO()

		CASE 2	GAMESTATE_MAP()

		CASE 3	GAMESTATE_CARGOHOLD()

		CASE 4	GAMESTATE_MARKET()

		CASE 5  GAMESTATE_SYSTEM()

		CASE 6  GAMESTATE_ENCOUNTER()
		
		CASE 7 GAMESTATE_HYPERSPACE()

		CASE ELSE
			GAMESTATE_INTRO()

	END SELECT

'	GRAPHICS COPY back_buffer TO screen_buffer

LOOP UNTIL game_running = 0
