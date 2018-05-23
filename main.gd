extends Node

const TOKEN_SIZE = 32
const TOKEN_TYPES = {1: "circle", 2: "cross", 3: "square", 4: "triangle", 5: "gem", 6: "i"}
const BOARD_SIZE = Vector2(8,12)

var boardArray = {}
var boardOrigin = Vector2(370,100)

var matchArray = []

onready var token = load("res://token.tscn") 

func _ready():

	randomize()
	set_process_input(true)
	_init_game_board()

func _init_game_board():
	
	var boardPos = boardOrigin

	# loop through rows
	for row in range(BOARD_SIZE.y):
		# loop through columns
		for col in range(BOARD_SIZE.x):		
			# assign random number %n to boardArray(x,y)
			boardArray[Vector2(col,row)] = randi()%4 +1
			var n = boardArray[Vector2(col,row)]
			var t = token.instance()
			t.type = n
			t.gridPos = boardPos
			t.set_position(boardPos)
			t.set_text(str(t.type))
			get_node("tokens").add_child(t)
			boardPos.x += TOKEN_SIZE		
			
		boardPos = Vector2(370, boardPos.y + TOKEN_SIZE)
	
