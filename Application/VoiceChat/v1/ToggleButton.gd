extends Node

var VC = VoiceChatPlayer

func _ready() -> void:
	pass
	# Note to contributors: the main script will handle $Return

func _v_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		
		VC.mic_enabled = true
	elif toggled_on == false:
		VC.mic_enabled = false
