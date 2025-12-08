extends Node



func get_group_node_by_name(group_name: String, node_name: String) -> Node:
	for node in get_tree().get_nodes_in_group(group_name):
		if node.name == node_name:
			return node
	return null
