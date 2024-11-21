class_name MainMenu
extends SceneBase

@onready var _main_menu : CenterContainer = get_node("MainMenuContainer")
@onready var _settings_menu : CenterContainer = get_node("SettingsContainer")
@onready var _sfx_slider : VolumeSlider = get_node("SettingsContainer/PanelContainer/MarginContainer/VBoxContainer/SFXVolumeHBoxContainer/SFXHSlider")
@onready var _music_slider : VolumeSlider = get_node("SettingsContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeHBoxContainer2/MusicHSlider")

var _original_sfx_volume : float = 1.0
var _original_music_volume : float = 1.0

func _ready() -> void:
	_main_menu.visible = true
	_settings_menu.visible = false

func load_scene_state() -> void:
	pass # override to do nothing


func save_scene_state() -> void:
	pass # override to do nothing


func _on_play_button_pressed() -> void:
	staging.load_scene("res://locations/home/home.tscn")


func _on_settings_button_pressed() -> void:
	_main_menu.visible = false
	_settings_menu.visible = true
	_original_sfx_volume = _sfx_slider.value
	_original_music_volume = _music_slider.value


func _on_quit_button_pressed() -> void:
	staging.handle_quit()


func _on_settings_save_button_pressed() -> void:
	_settings_menu.visible = false
	_main_menu.visible = true


func _on_settings_cancel_button_pressed() -> void:
	_sfx_slider.value = _original_sfx_volume
	_music_slider.value = _original_music_volume
	_settings_menu.visible = false
	_main_menu.visible = true
