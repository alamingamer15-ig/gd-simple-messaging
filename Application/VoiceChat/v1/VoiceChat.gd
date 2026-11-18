extends Node
class_name VoiceChatPlayer

static var mic_enabled := false
static var audio_layout_loaded := false

const FRAME_COUNT := 720

@onready var record_player: AudioStreamPlayer = $Record
@onready var playback_player: AudioStreamPlayer = $Play

var capture: AudioEffectCapture
var playback: AudioStreamGeneratorPlayback


func _enter_tree() -> void:
	set_multiplayer_authority(str(get_parent().name).to_int())


func _ready() -> void:
	if multiplayer.multiplayer_peer == null:
		return

	if not audio_layout_loaded:
		AudioServer.set_bus_layout(load("res://buslayout.tres"))
		audio_layout_loaded = true

	var record_bus := AudioServer.get_bus_index("Record")

	if record_bus == -1:
		push_error("VC: 0x01")
		return

	capture = AudioServer.get_bus_effect(record_bus, 0) as AudioEffectCapture

	if capture == null:
		push_error("VC: 0x02")
		return

	if is_multiplayer_authority() and mic_enabled:
		record_player.play()
	
	playback_player.play()
	playback = playback_player.get_stream_playback() as AudioStreamGeneratorPlayback


func _process(_delta: float) -> void:
	if multiplayer.multiplayer_peer == null:
		return

	if not is_multiplayer_authority() or capture == null:
		return
		
	if not mic_enabled:
		if record_player.playing:
			record_player.stop()
			capture.clear_buffer() # Discards leftover audio frames in the buffer
		return
	
	if not record_player.playing:
		record_player.play()
	
	while capture.get_frames_available() >= FRAME_COUNT:
		var frames := capture.get_buffer(FRAME_COUNT)
		if frames.is_empty():
			break
		if multiplayer.is_server():
			_relay_voice(multiplayer.get_unique_id(), frames)
		else:
			send_voice.rpc_id(1, frames)



@rpc("any_peer", "call_remote", "unreliable")
func send_voice(frames: PackedVector2Array) -> void:
	if not multiplayer.is_server():
		return

	var sender_id := multiplayer.get_remote_sender_id()

	if sender_id == 0 or sender_id != get_multiplayer_authority():
		return

	_relay_voice(sender_id, frames)


func _relay_voice(sender_id: int, frames: PackedVector2Array) -> void:
	receive_voice.rpc(sender_id, frames)


@rpc("any_peer", "call_remote", "unreliable")
func receive_voice(sender_id: int, frames: PackedVector2Array) -> void:
	if multiplayer.get_remote_sender_id() != 1:
		return

	if sender_id == multiplayer.get_unique_id():
		return

	var target_player := get_tree().current_scene.get_node_or_null(
		"Users/%s" % sender_id
	)

	if target_player == null:
		return

	var voice_player := target_player as VoiceChatPlayer

	if voice_player == null or voice_player.playback == null:
		return

	if voice_player.playback.can_push_buffer(frames.size()):
		voice_player.playback.push_buffer(frames)
