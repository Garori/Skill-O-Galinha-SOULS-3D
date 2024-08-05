extends Node

var nBolas:int
var nCaixas:int
var cdRoll:int
var staUsage:float
var staRecover:float
var walkingSPEED:float
var runningSPEED:float
var pontos:int = 0
var fs = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen") and not fs:
		fs = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("toggle_fullscreen") and fs:
		fs = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	pass
