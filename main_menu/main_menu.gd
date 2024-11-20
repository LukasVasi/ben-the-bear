class_name MainMenu
extends Control

@onready var _staging: Staging = get_tree().get_first_node_in_group("staging")


func _on_play_button_pressed() -> void:
	_staging.load_scene("res://locations/home/home.tscn")


func _on_settings_button_pressed() -> void:
	pass # TODO: settings menu


func _on_quit_button_pressed() -> void:
	get_tree().quit()
