extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var arrayDerrotas = ["CANJA", "VIROU\nCANJA","GALINHADA", "DERROTA", "VIROU\nSOPA DE GALINHA","SOPA\nDE\nGALINHA"]
	mesh.text = arrayDerrotas.pick_random()
