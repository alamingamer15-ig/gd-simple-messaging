@tool
extends EditorPlugin

var _android_export_plugin: AndroidAudioAECExportPlugin


func _enter_tree() -> void:
	_android_export_plugin = AndroidAudioAECExportPlugin.new()
	add_export_plugin(_android_export_plugin)


func _exit_tree() -> void:
	remove_export_plugin(_android_export_plugin)
	_android_export_plugin = null


class AndroidAudioAECExportPlugin extends EditorExportPlugin:
	const PLUGIN_NAME := "AndroidAudioAEC"

	func _supports_platform(platform: EditorExportPlatform) -> bool:
		return platform is EditorExportPlatformAndroid

	func _get_android_libraries(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		if debug:
			return PackedStringArray(["AndroidAudioAEC/bin/debug/AndroidAudioAEC.aar"])
		return PackedStringArray(["AndroidAudioAEC/bin/release/AndroidAudioAEC.aar"])

	func _get_name() -> String:
		return PLUGIN_NAME
