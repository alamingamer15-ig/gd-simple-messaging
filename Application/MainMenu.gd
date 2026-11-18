class_name App extends Node

# --------------------------------------------------
# NETWORK
# --------------------------------------------------

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

const PORT: int = 7778
const MAX_CLIENTS: int = 8

const PLAYER_SCENE: PackedScene = preload(
	"res://PlayerScene.tscn"
)


# --------------------------------------------------
# NODES
# --------------------------------------------------

@onready var Connect = $"Menu/buttons/Connect"
@onready var buttons = $"Menu/buttons"
@onready var Join_panel = $"Menu/Panel"
@onready var join = $"Menu/Panel/Button"

@onready var users: Node = $"Users"

@onready var spawner: MultiplayerSpawner = \
	$"ChatPanel/MultiplayerSpawner"

var user_consent : bool
var android_aec = load("res://Application/VoiceChat/v1/Android.gd")

# --------------------------------------------------
# READY
# --------------------------------------------------

func _ready() -> void:
	$ChatPanel/HBoxContainer/Return.pressed.connect(_return_to_mainmenu)
	$Menu/buttons/Guide.pressed.connect(guide_pressed)
	$Guide/Button.pressed.connect(close_guide)
	Connect.pressed.connect(_display_join_menu)
	join.pressed.connect(join_server)
	$"Menu/buttons/Create".pressed.connect(create_server)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	spawner.spawn_path = "../../Users"
	spawner.add_spawnable_scene(PLAYER_SCENE.resource_path)

# --------------------------------------------------
# MENU
# --------------------------------------------------

func _display_join_menu() -> void:
	buttons.hide()
	Join_panel.show()

# --------------------------------------------------
# CLIENT
# --------------------------------------------------

func join_server() -> void:
	if user_consent == false:
		show_error("Tell us your 13+", true)
		print("User above 13 is false")
		return
	else:
		show_error("", false)
		pass
	var address: String = $"Menu/Panel/IP".text.strip_edges()
	var port_text: String = $"Menu/Panel/Port".text.strip_edges()

	if $"Menu/LineEdit".text.strip_edges().is_empty():
		print("Enter a name first!")
		show_error("Enter a name first!", true)
		return
	else:
		show_error("", false)
	if address.is_empty() or not port_text.is_valid_int():
		print("Enter a valid address and port!")
		show_error("Enter a valid address and port!", true)
		return
	else:
		show_error("", false)

	var server_port := int(port_text)

	if server_port < 1 or server_port > 65535:
		print("Invalid port!")
		return

	peer = ENetMultiplayerPeer.new()

	var err := peer.create_client(address, server_port)

	if err != OK:
		push_error("Connection failed: " + error_string(err))
		return
	multiplayer.multiplayer_peer = peer
	$"Menu/LineEdit".editable = false
	
	_start()



# --------------------------------------------------
# SERVER
# --------------------------------------------------

func create_server() -> void:
	if user_consent == false:
		show_error("Tell us your 13+", true)
		print("User above 13 is false")
		return
	else:
		show_error("", false)
		pass
	if $"Menu/LineEdit".text.strip_edges().is_empty():
		print("Enter a name first!")
		show_error("Enter a name first!", true)
		return
	else:
		show_error("", false)

	peer = ENetMultiplayerPeer.new()

	var err := peer.create_server(PORT, MAX_CLIENTS)

	if err != OK:
		push_error("Server creation failed: " + error_string(err))
		return

	multiplayer.multiplayer_peer = peer
	_start()
	_spawn_player(1)
	print("ENet server started on UDP ", PORT)


# --------------------------------------------------
# CONNECTION EVENTS
# --------------------------------------------------

func _on_connected() -> void:

	print("Connected to server!")

	$"Menu".hide()
	$"VersionMetaData".hide()
	$"ChatPanel".show()


func _on_peer_connected(id: int) -> void:

	print("Peer connected: ", id)

	if multiplayer.is_server():
		_spawn_player(id)


func _on_peer_disconnected(id: int) -> void:

	print("Peer disconnected: ", id)

	if multiplayer.is_server():

		var player := users.get_node_or_null(str(id))

		if player:
			player.queue_free()


func _on_connection_failed() -> void:

	print("Connection failed!")

	_close_network()

	$"Menu/LineEdit".editable = true


func _on_server_disconnected() -> void:

	print("Server disconnected!")

	_close_network()

	$"Menu".show()
	$"ChatPanel".hide()
	$"Menu/LineEdit".editable = true


# --------------------------------------------------
# PLAYER SPAWNING
# --------------------------------------------------

func _spawn_player(id: int) -> void:
	if not multiplayer.is_server():
		return
	if users.has_node(str(id)):
		return
	if OS.get_name() =="Android":
		aec.set_audio_mode(3)

	var player: Node = PLAYER_SCENE.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)
	player.username = $Menu/LineEdit.text

	users.add_child(player, true)

	print("Spawned player: ", id)


func _start() -> void:
	if $Guide.visible == true:
		$Guide.visible = false
	$Menu.hide()
	$ChatPanel.show()

# --------------------------------------------------
# NETWORK CLEANUP
# --------------------------------------------------

func _close_network() -> void:

	multiplayer.multiplayer_peer = null

	if peer != null:
		peer.close()

	peer = ENetMultiplayerPeer.new()

	for player in users.get_children():
		player.queue_free()


# --------------------------------------------------
# EXIT
# --------------------------------------------------

func _on_exit_pressed() -> void:
	get_tree().quit()

func guide_pressed():
	$Menu.hide()
	$Guide.show()

func close_guide():
	$Menu.show()
	$Guide.hide()

func _exit_tree() -> void:
	multiplayer.multiplayer_peer = null
	if peer != null:
		peer.close()


# ------------------------
# Extra
# ------------------------

func _return_to_mainmenu() -> void:
	clear_chat_on_leave()
	_close_network()
	$Menu.show()
	$ChatPanel.hide()
	if $"Guide".visible == true:
		$Guide.hide()

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		user_consent = true
	elif toggled_on == false:
		user_consent = false
	print(user_consent)


func show_error(text: String, show: bool):
	var error = $Menu/Error
	error.visible = show
	error.text = text

func clear_chat_on_leave() -> void:
	if not multiplayer.is_server(): return
	var chat = $ChatPanel/ScrollContainer/Label
	chat.text = "[System] Welcome to chat! (Free chat)"
	print("Cleared Chat on leave")
