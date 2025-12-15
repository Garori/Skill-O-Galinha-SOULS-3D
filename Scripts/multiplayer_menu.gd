extends Control

@onready var ip = $menuContainer/ip
@onready var nickname = $menuContainer/nickname

var http_request: HTTPRequest
var waiting = [false, false]
var ip_addr = ""
var last_dont_read = ""
var last_timestamp = 0

func _ready() -> void:
	http_request = $HTTPRequest
	http_request.request_completed.connect(_http_request_completed)


func _on_server_button_down() -> void:
	print(nickname.text)
	Lobby.create_game(nickname.text)
	var error = http_request.request("https://icanhazip.com/")
	#waiting = [true, false]
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		waiting = [false, false]


func _on_client_button_down() -> void:
	Lobby.join_game(nickname.text, ip.text)


func _on_start_button_down() -> void:
	Lobby.load_game.rpc("res://Scenes/game.tscn")
	pass # Replace with function body.


func _on_find_ip_button_down() -> void:
	#print(Lobby._peer.get_peer(1).get_remote_address())
	var error = http_request.request("https://api.dontpad.com/condepintofonseca/arena_game.body.json?lastModified=0")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
	#OS.shell_open("https://icanhazip.com/")

func _http_request_completed(_result, response_code, headers, body):
	print("---------- requisicao ------------")
	print(response_code)
	print(headers)
	print(waiting)
	if "Server: Caddy" in headers and not waiting[1]:
		print("entrei")
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		print(response)
		if typeof(response) == typeof({}) and "error" in response:
			print("deu ruim")
			return
		if typeof(response) == typeof({}):
			last_dont_read = response["body"]
			if not last_dont_read:
				last_dont_read = ""
			last_timestamp = int(response["lastModified"])
		else:
			last_timestamp = int(response)
		
		#print(last_dont_read)
		
		if waiting[0]:
			waiting[0] = false
			#waiting[1] = true
			var msg = last_dont_read + "\n" + "Please disregard this section" #+ ip_addr
			var data = "text=%s&lastModified=%s&force=false" % [msg, last_timestamp+1]
			var error = http_request.request("https://api.dontpad.com/condepintofonseca/arena_game",
				["Content-Type: application/x-www-form-urlencoded; charset=UTF-8"],
				HTTPClient.METHOD_POST,
				data
				)
			if error != OK:
				push_error("An error occurred in the HTTP request.")
				return
		else:
			print_debug("entrei no false")
			for c in $servers_container/VBoxContainer.get_children(false):
				if c.name == "refresh": continue
				c.queue_free()
				
			for line in last_dont_read.split("\n"):
				print(line)
				if line == "": continue
				var n_button = Button.new()
				#n_button.name = line
				n_button.text = line
				n_button.button_down.connect(_paste_server.bind(n_button))
				$servers_container/VBoxContainer.add_child(n_button)
				
				
	elif "Server: cloudflare" in headers: # resposta do ICANHAZIP
		ip_addr = body.get_string_from_utf8()
		DisplayServer.clipboard_set(ip_addr)
		var alert = preload("res://Prefabs/UI/alert.tscn").instantiate()
		alert.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_CENTER_BOTTOM, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
		get_parent().add_child(alert)
		print_debug("ip copiado!")
		if waiting[0]:
			var error = http_request.request("https://api.dontpad.com/condepintofonseca/arena_game.body.json?lastModified=0")
			if error != OK:
				push_error("An error occurred in the HTTP request.")
			
	#if waiting[1]:


func _on_nickname_text_changed(text: String) -> void:
	#print_debug(text)
	if text != "":
		$menuContainer/Server.disabled = false
		$menuContainer/Client.disabled = false
	pass # Replace with function body.


func _paste_server(button):
	ip.text = button.text
	pass


func _on_ip_text_changed(_text: String) -> void:
	#if text != "":
		#$menuContainer/Server.disabled = false
		#$menuContainer/Join.disabled = false
		pass


func _on_refresh_button_down() -> void:
	var error = http_request.request("https://api.dontpad.com/condepintofonseca/arena_game.body.json?lastModified=0")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	pass # Replace with function body.
