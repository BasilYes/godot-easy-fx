@tool
extends EditorPlugin


func _enter_tree() -> void:
	var gui = get_editor_interface().get_base_control()
	add_custom_type("EFXPlayOnSignal", "Node", preload("uid://dbgp8o5pnif4w"), gui.get_theme_icon("Signals", "EditorIcons"))


func _exit_tree() -> void:
	remove_custom_type("EFXPlayOnSignal")
