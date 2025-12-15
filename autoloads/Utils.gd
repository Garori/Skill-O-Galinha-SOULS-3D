extends Node



func _enter_tree() -> void:
	var args = OS.get_cmdline_args()
	if "--d1" in args:
		print(DisplayServer.get_primary_screen())
		DisplayServer.window_set_current_screen(0,1)
		print("aaaaaaaaaa")
	if "--d2" in args:
		print("bbbbbbbbbbb")
		DisplayServer.window_set_current_screen(2,0)

func get_group_node_by_name(group_name: String, node_name: String) -> Node:
	for node in get_tree().get_nodes_in_group(group_name):
		if node.name == node_name:
			return node
	return null
