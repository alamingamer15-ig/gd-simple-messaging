class_name aec extends Node

static var audio_manager: JavaObject
static var previous_mode : int = 0

static func set_audio_mode(state: int) -> void:
	if OS.get_name() != "Android":
		return
	var android_runtime = Engine.get_singleton("AndroidRuntime")
	if android_runtime == null:
		push_error("AndroidRuntime unavailable")
		return
	audio_manager = android_runtime.getApplicationContext().getSystemService("audio")
	if audio_manager == null:
		push_error("AudioManager unavailable")
		return
	previous_mode = audio_manager.getMode()
	audio_manager.setMode(state)
	var exception = JavaClassWrapper.get_exception()
	if exception != null:
		printerr(exception)


func _exit_tree() -> void:
	if audio_manager == null:
		return
	audio_manager.setMode(previous_mode)
	var exception = JavaClassWrapper.get_exception()
	if exception != null:
		printerr(exception)
