extends Node

#var cdRoll:int
var staUsage:float = 1.0
var staRecover:float = 0.35
var walkingSPEED:float = 5.0
var runningSPEED:float = 10.0
var balancingMode:bool = false
var pontos:int = 0
var fs = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen") and not fs:
		fs = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif event.is_action_pressed("toggle_fullscreen") and fs:
		fs = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
