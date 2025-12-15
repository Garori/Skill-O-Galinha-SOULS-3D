extends Node

#Prefabs
const objetivo = preload("res://Prefabs/objetivo.tscn")
const inimigo = preload("res://Prefabs/inimigo.tscn")
const caixa2D = preload("res://Prefabs/caixa_2d_ui.tscn")

var rng = RandomNumberGenerator.new()

#objetos posicionados
var localizacoes = []

var current_level_num
var current_level

var levels = {
	"-1":{"x_tam":100,"z_tam":100,"nBolas":150,"nCaixas":12},
	"1":{"x_tam":50,"z_tam":50,"nBolas":0,"nCaixas":1}, #25, 5
	"2":{"x_tam":70,"z_tam":70,"nBolas":50,"nCaixas":7},
	"3":{"x_tam":100,"z_tam":100,"nBolas":100,"nCaixas":10},
	"4":{"x_tam":100,"z_tam":100,"nBolas":150,"nCaixas":12},
	"5":{"x_tam":100,"z_tam":100,"nBolas":200,"nCaixas":24}
}
@rpc("any_peer", "call_local", "reliable")
func set_current_level(level:int):
	current_level = levels[str(level)]
	current_level_num = level


func objectives_spawner(scene:Node3D):
	for i in range(current_level["nCaixas"]):
		var ui_box:Object = caixa2D.instantiate()
		scene.get_node("UI/GridContainer").add_child(ui_box)
		var obj:RigidBody3D = objetivo.instantiate()
		#obj.tree_exiting.connect(scene.points_counter)
		obj.set_multiplayer_authority(1)
		scene.add_child(obj, true)
		
		var posicao = generate_spwn_point(1)
		obj.position = posicao
		obj.rotation = Vector3(0,rng.randf_range(-1, 1),0)
		obj.ui_box = ui_box


func enemies_spawner(scene:Node3D):
	for i in range(current_level["nBolas"]):
		var obj:Object = inimigo.instantiate()
		scene.add_child(obj, true)
		obj.position = generate_spwn_point(2)


func generate_spwn_point(tipo:int):
	var spwnPoint = Vector3(rng.randf_range((-current_level["x_tam"]/2)+1, (current_level["x_tam"]/2)-1),0.5,rng.randf_range((-current_level["z_tam"]/2)+1, (current_level["z_tam"]/2))-1)
	#print_debug(localizacoes)
	if tipo != 3:
		
		for i in localizacoes:
			if i.has_point(Vector2(spwnPoint.x,spwnPoint.z)):
				spwnPoint = generate_spwn_point(tipo)
				break
	var deadzone
	match tipo:
		0:
			deadzone = Vector2(25,25)
		1:
			deadzone = Vector2(10,10)
		2:
			deadzone = Vector2(1.5,1.5)
		3:
			deadzone = Vector2(17,17)
	localizacoes.append(Rect2(Vector2(spwnPoint.x,spwnPoint.z)-(deadzone/2),deadzone))
	return spwnPoint
