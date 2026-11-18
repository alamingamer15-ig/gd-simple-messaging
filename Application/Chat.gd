extends Button

# Copyright 2026© Alamin.
# Messaging script

func _pressed() -> void:
	set_multiplayer_authority(multiplayer.get_unique_id())
	var message = $"../LineEdit"
	var messagebox : Label = $"../ScrollContainer/Label"
	var username = $"../../Menu/LineEdit".text
	
	if message.text == "":
		return
	messagebox.text += "\n" + "[ " + username + " ] : " + message.text
	message.text = ""
