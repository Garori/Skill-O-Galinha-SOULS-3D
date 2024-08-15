extends Node

#var cdRoll:int
var staUsage:float = 1.0
var staRecover:float = 0.35
var walkingSPEED:float = 5.0
var runningSPEED:float = 10.0
var balancingMode:bool = false
var pontos:int = 0
var currentLevel = 1
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
