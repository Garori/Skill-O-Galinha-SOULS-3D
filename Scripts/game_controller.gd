extends Node3D

const objetivo = preload("res://Prefabs/objetivo.tscn")
const inimigo = preload("res://Prefabs/inimigo.tscn")
const player = preload("res://Prefabs/player.tscn")
const caixa2D = preload("res://Prefabs/caixa_2d_ui.tscn")
const wall = preload("res://Prefabs/wall.tscn")
const ground = preload("res://Prefabs/ground.tscn")
var nCaixas
var nBolas
var cdRoll
var localizacoes = []
var numero = RandomNumberGenerator.new()

@onready var currentLevel = Levels.levels[str(GlobalVar.currentLevel)]

func _init():
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	#var currentLevel = Levels.levels["1"]
	rooms_creator(currentLevel)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GlobalVar.pontos = 0
	#var parameters = JSON.parse_string(FileAccess.get_file_as_string("res://Others/parameters.json"))
	var player:Object = player.instantiate()
	add_child(player)
	var posicao = generate_spwn_point(player,0,currentLevel)
	player.position = posicao 
	
	for i in range(currentLevel["nCaixas"]):
		var ui_box:Object = caixa2D.instantiate()
		$UI/GridContainer.add_child(ui_box)
		var obj:Object = objetivo.instantiate()
		add_child(obj)
		posicao = generate_spwn_point(obj,1,currentLevel)
		obj.position = posicao
		obj.rotation = Vector3(0,numero.randf_range(-1, 1),0)
		obj.ui_box = ui_box
	
	for i in range(currentLevel["nBolas"]):
		var obj:Object = inimigo.instantiate()
		add_child(obj)
		posicao = generate_spwn_point(obj,2,currentLevel)
		obj.position = posicao
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVar.pontos == currentLevel["nCaixas"]:
		if GlobalVar.currentLevel < len(Levels.levels):
			GlobalVar.currentLevel+=1
			get_tree().change_scene_to_file("res://Scenes/next_level.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/vitoria.tscn")
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/Menu_Inicial.tscn")
	
func generate_spwn_point(obj:Object, tipo:int, level):
	var spwnPoint = Vector3(numero.randf_range((-level["x_tam"]/2)+1, (level["x_tam"]/2)-1),0.5,numero.randf_range((-level["z_tam"]/2)+1, (level["z_tam"]/2))-1)
	#print_debug(localizacoes)
	for i in localizacoes:
		if i.has_point(Vector2(spwnPoint.x,spwnPoint.z)):
			spwnPoint = generate_spwn_point(obj,tipo,level)
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
	
func rooms_creator(level):
	var tmp_thing = [[-1,0],[1,0],[0,-1],[0,1]]
	var chao:Object = ground.instantiate()
	chao.mesh.size = Vector2(level["x_tam"],level["z_tam"])
	add_child(chao)
	chao.position = Vector3(0,0,0)
	chao.get_child(0).get_child(0).shape.size = Vector3(level["x_tam"],0.01,level["z_tam"])
	for i in range(4):
		var parede:Object = wall.instantiate()
		add_child(parede)
		parede.position.x = tmp_thing[i][0]*level["x_tam"]/2
		parede.position.y = 1.5
		parede.position.z = tmp_thing[i][1]*level["z_tam"]/2
		parede.rotation_degrees.y = (90+(90*tmp_thing[i][0])) * (tmp_thing[i][1] if tmp_thing[i][0] == 0 else 1)
		if i<2:
			parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["x_tam"])
			parede.mesh.size = Vector2(level["x_tam"],3)
		else:
			parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["z_tam"])
			parede.mesh.size = Vector2(level["z_tam"],3)




