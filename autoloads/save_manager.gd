extends Node

var json = JSON.new()
var path = "user://parameters.json"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func save(nCaixas,nBolas,cdRoll):
	var data = {"nCaixas":nCaixas,"nBolas":nBolas,"cdRoll":cdRoll}
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	pass
