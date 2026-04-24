extends Node

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

var _peer
var is_multiplayer_enabled = false

const PORT = 9999
#const DEFAULT_SERVER_IP = "192.168.1.25" # IPv4 localhost
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 10

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info = {"name": "name", "color": Color(randf_range(0,0.5),randf_range(0,0.5),randf_range(0,0.5))}

var players_loaded = 0



func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func join_game(nickname:String, address := ""):
	player_info["name"] = nickname
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	_peer = peer
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	_add_new_player_label(player_info)


func create_game(nickname:String):
	player_info["name"] = nickname
	var peer = ENetMultiplayerPeer.new()
	_peer = peer
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	players[1] = player_info
	_add_new_player_label(player_info)
	player_connected.emit(1, player_info)
	Utils.get_group_node_by_name("UI", "StartGame").disabled = false
	#get_node("%StartGame").disabled = false


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()


# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file.call_deferred(game_scene_path)


# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			players_loaded = 0
			$/root/Game.start_game()


# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)
	#_add_new_player_label()


func _add_new_player_label(new_player_info):
	var players_cards = Utils.get_group_node_by_name("UI", "ConnectedPlayers")
	var card := Label.new()
	card.text = new_player_info["name"]
	card.add_theme_font_size_override("font_size", 24)
	var new_color = new_player_info["color"] + Color(0.5,0.5,0.5)
	new_color.a = 1.0
	card.add_theme_color_override("font_color", new_color)
	card.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var new_sb = StyleBoxFlat.new()
	new_sb.set_content_margin_all(5.0)
	new_sb.bg_color = new_player_info["color"]
	card.add_theme_stylebox_override("normal", new_sb)
	players_cards.get_node("CardsContainer").add_child(card)


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	print("player registered %s " % multiplayer.get_unique_id())
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	_add_new_player_label(new_player_info)
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail():
	remove_multiplayer_peer()


func _on_server_disconnected():
	remove_multiplayer_peer()
	players.clear()
	server_disconnected.emit()
