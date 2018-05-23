extends Label

var type
var gridPos = Vector2()

var status = "none"
var spriteSize = Vector2()
var mousePos = Vector2()

func _ready():
	spriteSize = self.get_size()
	set_process(true)

func _process(delta):
	if status == "dragging":
		set_global_position(mousePos - spriteSize / 2)

func _on_token_gui_input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_LEFT:
			if ev.pressed:
				accept_event()
				status = "pressed"
	
	if status == "pressed" and ev is InputEventMouseMotion:
		accept_event()
		status = "dragging"
	
	if ev is InputEventMouseButton and !ev.pressed:
		accept_event()
		status = "released"
		
	mousePos = get_global_mouse_position()
