extends Node

onready var SCREEN_SIZE = get_tree().get_root().get_visible_rect().size
const TOKEN_SIZE = 32
const TOKEN_TYPES = {1: "circle", 2: "cross", 3: "square", 4: "triangle", 5: "gem", 6: "i"}

#set size of active game board, and token pool twice the depth
var ACTIVE_BOARD = Vector2(8,7)
var TOKEN_POOL = Vector2(ACTIVE_BOARD.x, ACTIVE_BOARD.y * 2)

var boardArray = []
var boardOrigin

var matchArray = []

var MATCH_ROW = []
var MATCH_COL = []

var previous_slot
var current_slot

var previous_row

onready var token = load("res://token.tscn") 

func _ready():

	randomize()
	boardOrigin = Vector2((SCREEN_SIZE.x /2) - TOKEN_SIZE * 2,100)
	set_process_input(true)
	_init_game_board()

func _init_game_board():
	
	var boardPos = boardOrigin
	var iter = 0
	
	# loop through rows
	for row in range(TOKEN_POOL.y):
		# loop through columns
		for col in range(TOKEN_POOL.x):		
			# assign random number %n to boardArray(iter)
			boardArray.push_back(randi()%4 +1)
			var n = boardArray[iter]
			var t = token.instance()
			t.name = str(iter)
			t.type = n
			t.gridPos = boardPos
			t.set_position(boardPos)
			t.set_text(str(t.type))
			get_node("tokens").add_child(t)
			boardPos.x += TOKEN_SIZE	
			iter = iter + 1	
			
		boardPos = Vector2((SCREEN_SIZE.x /2) - TOKEN_SIZE * 2, boardPos.y + TOKEN_SIZE)
#	print(boardArray)
	match_tokens()
	
func match_tokens():

	previous_slot = null

	for slot in range(boardArray.size()):
		
		current_slot = slot
		
#		print(slot)
		
		#check which row and column this token belongs to
		var row = ceil((slot+1) / ACTIVE_BOARD.x)
		
		#hackish solution to get the first slot ´0´ to be recognized as being on the first row
#		if row == 0:
#			row = 1
			
		var col = row * ACTIVE_BOARD.x - slot
#		print("row is: " + str(row))
		#if slot is with the ACTIVE_BOARD area
		if 5 == 5:
			if previous_slot != null:
				#only match if current token is same type as previous token, and they are on the same row
				if boardArray[current_slot] == boardArray[previous_slot] and row == previous_row:
#					print("Match! Type: " + str(boardArray[slot]))
					#check if current row already added to array, else add
					#FIX: this only stores the matching token slot, not the slot of the token it matched
					if MATCH_ROW.has(row) and row != ACTIVE_BOARD.y:
						MATCH_ROW[row].push_back(current_slot)
					else:
						MATCH_ROW.push_back(current_slot)

				if boardArray[current_slot] == boardArray[current_slot - ACTIVE_BOARD.x] and row != 1:

					#check if current col already added to array, else add
					if MATCH_COL.has(col) and col != ACTIVE_BOARD.x:	
						MATCH_COL[col].push_back(current_slot)
					else:
						MATCH_COL.push_back(current_slot)
					
		previous_slot = slot
		previous_row = row
		
	check_for_combo()
	
	print(MATCH_ROW)
	print(MATCH_COL)
		
	#transfer the matching tokens into an easily traversable array, so we can destroy all matching tokens at once	
#	for collection in MATCH_COL:
#		for item in collection:
	for item in MATCH_COL:
		matchArray.push_back(item)

#	for collection in MATCH_ROW:
#		for item in collection:
	for item in MATCH_ROW:
		if matchArray.has(item):
			pass
		else:
			matchArray.push_back(item)
				
	matchArray.sort()
	incinerate()

func check_for_combo():
	pass
		
func incinerate():
	for i in $tokens.get_children():
		print(i.name)
		print(i)
	#add all matching tokens to a group for deletion, and delete
	#reference in TOKEN_POOL
	for slot in matchArray:
		print(slot)
		get_node("tokens/" + str(slot)).add_to_group("destroy")
		boardArray[slot] = 0

	#remove token from tree	
	for token in get_tree().get_nodes_in_group("destroy"):
		token.set_name("incinerated")
		token.queue_free()

	matchArray.clear()

#	_init_game_board()