extends Node3D

const player = preload("res://Prefabs/player.tscn")
const wall = preload("res://Prefabs/wall.tscn")
const ground = preload("res://Prefabs/ground.tscn")

var points = 0
var nObjectives
var numero = RandomNumberGenerator.new()

var rooms_dict:Dictionary = {}
var global_rooms_counter = -1

var multiplayer_spawner

#@onready var currentLevel = Levels.levels[str(GlobalVar.currentLevel)]

func _ready():
	nObjectives = Levels.current_level["nCaixas"]
	
	rooms_creator(Levels.current_level)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Lobby.is_multiplayer_enabled:
		multiplayer_spawner = $MultiplayerSpawner
		Lobby.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.
		return
		
	#var currentLevel = Levels.levels["1"]
	#rooms_creator(currentLevel)
	#var parameters = JSON.parse_string(FileAccess.get_file_as_string("res://Others/parameters.json"))
	var player:Object = player.instantiate()
	add_child(player)
	player.position = Levels.generate_spwn_point(0)
	
	Levels.objectives_spawner(self)
	
	Levels.enemies_spawner(self)
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/Menu_Inicial.tscn")
	

func start_game():
	print_debug("todos os jogadores estão prontos")
	for player in Lobby.players:
		print(Lobby.players[player])
		multiplayer_spawner.spawn([player,Lobby.players[player]])
	# All peers are ready to receive RPCs in this scene.
	pass


func points_counter():
	points += 1
	if points == nObjectives:
		if Levels.current_level_num < len(Levels.levels):
			Levels.set_current_level(Levels.current_level_num+1)
			get_tree().change_scene_to_file("res://Scenes/next_level.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/vitoria.tscn")
	

#
#func generate_spwn_point(tipo:int, level):
	#var spwnPoint = Vector3(numero.randf_range((-level["x_tam"]/2)+1, (level["x_tam"]/2)-1),0.5,numero.randf_range((-level["z_tam"]/2)+1, (level["z_tam"]/2))-1)
	##print_debug(localizacoes)
	#if tipo != 3:
		#
		#for i in localizacoes:
			#if i.has_point(Vector2(spwnPoint.x,spwnPoint.z)):
				#spwnPoint = generate_spwn_point(tipo,level)
				#break
	#var deadzone
	#match tipo:
		#0:
			#deadzone = Vector2(25,25)
		#1:
			#deadzone = Vector2(10,10)
		#2:
			#deadzone = Vector2(1.5,1.5)
		#3:
			#deadzone = Vector2(17,17)
	#localizacoes.append(Rect2(Vector2(spwnPoint.x,spwnPoint.z)-(deadzone/2),deadzone))
	#return spwnPoint

## Criador original da sala única.
## Cria uma sala com os tamanhos do descrito na lista de níveis e é isso aí
#func rooms_creator__(level):
	#var tmp_thing = [[-1,0],[1,0],[0,-1],[0,1]]
	#var chao:Object = ground.instantiate()
	#chao.mesh.size = Vector2(level["x_tam"],level["z_tam"])
	#add_child(chao)
	#chao.position = Vector3(0,0,0)
	#chao.get_child(0).get_child(0).shape.size = Vector3(level["x_tam"],0.01,level["z_tam"])
	#for i in range(4):
		#var parede:Object = wall.instantiate()
		#add_child(parede)
		#parede.position.x = tmp_thing[i][0]*level["x_tam"]/2
		#parede.position.y = 1.5
		#parede.position.z = tmp_thing[i][1]*level["z_tam"]/2
		#parede.rotation_degrees.y = (90+(90*tmp_thing[i][0])) * (tmp_thing[i][1] if tmp_thing[i][0] == 0 else 1)
		#if i<2:
			#parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["x_tam"])
			#parede.mesh.size = Vector2(level["x_tam"],3)
		#else:
			#parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["z_tam"])
			#parede.mesh.size = Vector2(level["z_tam"],3)

func rooms_creator(level):
	if global_rooms_counter != -1:
		var nSala = rooms_dict.keys().pick_random() ## asala onde a nova sala será attached
		var nIntersecao = rooms_dict[nSala].keys().pick_random() ## em que interseção de paredes o corredor será attached

	global_rooms_counter +=1
	rooms_dict[global_rooms_counter] = {}
	var tmp_thing = [[-1,0],[1,0],[0,-1],[0,1]] ## acho que são as rotações
	var chao:Object = ground.instantiate()
	chao.mesh.size = Vector2(level["x_tam"],level["z_tam"])
	add_child(chao)
	chao.position = Vector3(0,0,0)
	chao.get_child(0).get_child(0).shape.size = Vector3(level["x_tam"],0.01,level["z_tam"])
	for i in range(4):
		var nWalls: float = randi_range(1,3)
		if nWalls > 1:
			rooms_dict[global_rooms_counter][i]={}
		#rooms_dict[global_rooms_counter][]
		#print_debug("wall n",i)
		#print_debug("numero de paredes = ",nWalls)
		var auxiliar = range(-floor(nWalls/2.0),floor(nWalls/2.0)+1,1)
		#print_debug(auxiliar)
		var par = 2
		if fmod(nWalls, 2) == 0:
			auxiliar.erase(0)
			par = 1
			auxiliar.size()
		#print_debug(auxiliar)
		for z in range(auxiliar.size() -1):
			rooms_dict[global_rooms_counter][i][z] = {"parede0":"","parede1":""}
			
		var contador1 = 0
		var contador2 = 0
		for k in auxiliar:
			var rng = RandomNumberGenerator.new()
			var cor = Color(rng.randf_range(0,1),rng.randf_range(0,1),rng.randf_range(0,1),1)
			#print_debug("subparede ",k)
			#var aux:float = nWalls/2.0 + k-1
			var parede:Object = wall.instantiate()
			#print_debug(parede.get_child(0).get_child(0).shape)
			#cria uma parede em 
			
			var mesh:QuadMesh = QuadMesh.new()
			mesh.orientation = 0
			
			#parede.mesh.set_surface_override_material(0, material)
			#QuadMesh
			#MeshInstance3D.set_surface_override_material(0, new() StandardMaterial3D)
			
			#parede.mesh.material.albedo_color = Color(rng.randf_range(0,1),rng.randf_range(0,1),rng.randf_range(0,1))
			parede.position.x = (k*tmp_thing[i][1]*level["x_tam"]/(nWalls*(2.0/par)))+(tmp_thing[i][0]*level["x_tam"]/2.0)
			parede.position.y = 1.5
			parede.position.z = (k*tmp_thing[i][0]*level["z_tam"]/(nWalls*(2.0/par)))+(tmp_thing[i][1]*level["z_tam"]/2.0)
			parede.rotation_degrees.y = (90+(90*tmp_thing[i][0])) * (tmp_thing[i][1] if tmp_thing[i][0] == 0 else 1)
			#print_debug("posicao da subparede = ", parede.position)
			#print_debug(parede.get_child(0).get_child(0).shape)
			#TODO Modifica tamanhos x ou z dependendo de nWall e move dependendo de k
			if i<2:
				mesh.size = Vector2(level["x_tam"]/nWalls,3)
				parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["x_tam"]/nWalls)
				#print_debug(parede.get_child(0).get_child(0).shape.size)
			else:
				mesh.size = Vector2(level["z_tam"]/nWalls,3)
				parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["z_tam"]/nWalls)
				#print_debug(parede.get_child(0).get_child(0).shape.size)
			parede.mesh = mesh
			var material:StandardMaterial3D = StandardMaterial3D.new()
			material.albedo_color = cor
			material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
			parede.set_surface_override_material(0,material)
			#print_debug(parede.get_child(0).get_child(0).shape)
			#print_debug("tamanho da mesh = ",parede.mesh.size)
			#print_debug("tamanho colisor = ",parede.get_child(0).get_child(0).shape.size)
			#print_debug("cor rgba",parede.get_surface_override_material(0).albedo_color*255)
			add_child(parede)
			if nWalls > 1:
				#print(parede.name)
				rooms_dict[global_rooms_counter][i][contador1]["parede"+str(contador2)] = parede
				contador2 +=1
		contador2 = 0
		contador1 += 1
		
#func yet_another_room_creator(level):
	#var tmp_thing = [[-1,0],[1,0],[0,-1],[0,1]]
	#var chao:Object = ground.instantiate()
	#chao.mesh.size = Vector2(level["x_tam"],level["z_tam"])
	#add_child(chao)
	#chao.position = Vector3(0,0,0)
	#chao.get_child(0).get_child(0).shape.size = Vector3(level["x_tam"],0.01,level["z_tam"])
	#for i in range(4):
		#var parede:Object = wall.instantiate()
		#add_child(parede)
		#var mesh:QuadMesh = QuadMesh.new()
		#mesh.orientation = 0
		#parede.position.x = tmp_thing[i][0]*level["x_tam"]/2
		#parede.position.y = 1.5
		#parede.position.z = tmp_thing[i][1]*level["z_tam"]/2
		#parede.rotation_degrees.y = (90+(90*tmp_thing[i][0])) * (tmp_thing[i][1] if tmp_thing[i][0] == 0 else 1)
		#if i<2:
			#parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["x_tam"])
			#mesh.size = Vector2(level["x_tam"],3)
		#else:
			#parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["z_tam"])
			#mesh.size = Vector2(level["z_tam"],3)
		#parede.mesh = mesh
	#
	##for i in range(4):
		##for k in range(2):
			##tmp_thing[i][k] *= -1
	##print_debug(tmp_thing)
	#for k in range(5):
		#var internal_room = Node3D.new()
		#internal_room.name = "internal room "+str(k)
		#for i in range(4):
			#var parede:Object = wall.instantiate()
			#internal_room.add_child(parede)
			#var mesh:BoxMesh = BoxMesh.new()
			##mesh.orientation = 0
			##mesh.flip_faces = true
			#parede.position.x = float(tmp_thing[i][0])*15/2
			#parede.position.y = 0
			#parede.position.z = float(tmp_thing[i][1])*15/2
			#parede.rotation_degrees.y = (90+(90*tmp_thing[i][0])) * (tmp_thing[i][1] if tmp_thing[i][0] == 0 else 1)
			#if i<2:
				#parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,15)
				#mesh.size = Vector3(0.01,3,15)
			#else:
				#parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,15)
				#mesh.size = Vector3(0.01,3,15)
			#parede.mesh = mesh
		#add_child(internal_room)
		#internal_room.position =  generate_spwn_point(3,level)
		#
