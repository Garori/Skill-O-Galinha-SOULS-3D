extends Node3D

const objetivo = preload("res://Prefabs/objetivo.tscn")
const inimigo = preload("res://Prefabs/inimigo.tscn")
const player = preload("res://Prefabs/player.tscn")
var nCaixas
var nBolas
var cdRoll
var localizacoes = []
var numero = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GlobalVar.pontos = 0
	#var parameters = JSON.parse_string(FileAccess.get_file_as_string("res://Others/parameters.json"))
	var player:Object = player.instantiate()
	add_child(player)
	var posicao = generate_spwn_point(player,0)
	player.position = posicao
	
	for i in range(GlobalVar.nCaixas):
		var obj:Object = objetivo.instantiate()
		add_child(obj)
		posicao = generate_spwn_point(obj,1)
		obj.position = posicao
		obj.rotation = Vector3(0,numero.randf_range(-1, 1),0)
	
	for i in range(GlobalVar.nBolas):
		var obj:Object = inimigo.instantiate()
		add_child(obj)
		posicao = generate_spwn_point(obj,2)
		obj.position = posicao
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVar.pontos == GlobalVar.nCaixas:
		get_tree().change_scene_to_file("res://Scenes/vitoria.tscn")
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/Menu_Inicial.tscn")
	
func generate_spwn_point(obj:Object, tipo:int):
	var spwnPoint = Vector3(numero.randf_range(-49, 49),0.5,numero.randf_range(-49, 49))
	#print_debug(localizacoes)
	for i in localizacoes:
		if i.has_point(Vector2(spwnPoint.x,spwnPoint.z)):
			spwnPoint = generate_spwn_point(obj,tipo)
			break
	var deadzone
	match tipo:
		0:
			deadzone = Vector2(25,25)
		1:
			deadzone = Vector2(10,10)
		2:
			deadzone = Vector2(1.5,1.5)
	localizacoes.append(Rect2(Vector2(spwnPoint.x,spwnPoint.z)-(deadzone/2),deadzone))
	return spwnPoint




