class_name MainMenu
extends SceneBase

func load_scene_state() -> void:
	pass # override to do nothing


func save_scene_state() -> void:
	pass # override to do nothing


func _on_play_button_pressed() -> void:
	staging.load_scene("res://locations/home/home.tscn")


func _on_settings_button_pressed() -> void:
	pass # TODO: settings menu


func _on_quit_button_pressed() -> void:
	staging.handle_quit()
