extends Node

const wall = preload("res://Prefabs/wall.tscn")
const ground = preload("res://Prefabs/ground.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func rooms_creator(level):
	var tmp_thing = [[-1,0],[1,0],[0,-1],[0,1]]
	var chao:Object = ground.instantiate()
	chao.mesh.size = Vector2(level["x_tam"],level["z_tam"])
	add_child(chao)
	chao.position = Vector3(0,0,0)
	chao.get_child(0).get_child(0).shape.size = Vector3(level["x_tam"],0.01,level["z_tam"])
	for i in range(4):
		var nWalls: int = randi_range(1,3)
		for k in range(nWalls):
			var aux:int = k-1
			var parede:Object = wall.instantiate()
			add_child(parede)
			#cria uma parede em 
			parede.mesh.material.albedo_color = Color(0.5+(0.4*aux),0.5+(0.4*aux),0.5+(0.4*aux))
			parede.position.x = (aux*tmp_thing[i][0]*level["x_tam"]/2)+(tmp_thing[i][0]*level["x_tam"]/2)
			parede.position.y = 1.5
			parede.position.z = (aux*tmp_thing[i][0]*level["x_tam"]/2)+(tmp_thing[i][1]*level["z_tam"]/2)
			parede.rotation_degrees.y = (90+(90*tmp_thing[i][0])) * (tmp_thing[i][1] if tmp_thing[i][0] == 0 else 1)
			#TODO Modifica tamanhos x ou z dependendo de nWall e move dependendo de k
			if i<2:
				parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["x_tam"]/nWalls)
				parede.mesh.size = Vector2(level["x_tam"]/nWalls,3)
			else:
				parede.get_child(0).get_child(0).shape.size = Vector3(0.01,3,level["z_tam"]/nWalls)
				parede.mesh.size = Vector2(level["z_tam"]/nWalls,3)
