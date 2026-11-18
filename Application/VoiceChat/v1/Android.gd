class_name aec extends Node

const PLUGIN_NAME := "AndroidAudioAEC"
const MODE_NORMAL := 0
const MODE_RINGTONE := 1
const MODE_IN_CALL := 2
const MODE_IN_COMMUNICATION := 3

static func set_audio_mode(mode: int) -> void:
	if OS.get_name() != "Android":
		return

	if not Engine.has_singleton(PLUGIN_NAME):
		push_error("AndroidAudioAEC plugin is unavailable")
		return

	var plugin = Engine.get_singleton(PLUGIN_NAME)
	plugin.set_audio_mode(mode)


func _exit_tree() -> void:
	if OS.get_name() != "Android":
		return

	if Engine.has_singleton(PLUGIN_NAME):
		var plugin = Engine.get_singleton(PLUGIN_NAME)
		plugin.restore_audio_mode()
