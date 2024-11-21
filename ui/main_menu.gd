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
	var sfx_setting : float = PlayerManager.get_sfx_setting()
	print(sfx_setting)
	if sfx_setting >= 0: _sfx_slider.value = sfx_setting
	var music_setting : float = PlayerManager.get_sfx_setting()
	print(music_setting)
	if music_setting >= 0: _music_slider.value = music_setting

func load_scene_state() -> void:
	pass # override to do nothing


func save_scene_state() -> void:
	pass # override to do nothing


func _on_play_button_pressed() -> void:
	var last_scene_path : String = PlayerManager.get_last_scene()
	if last_scene_path == null or last_scene_path.is_empty():
		staging.load_scene("res://locations/home/home.tscn")
	else:
		staging.load_scene(last_scene_path)


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
	PlayerManager.save_settings(_sfx_slider.value, _music_slider.value)


func _on_settings_cancel_button_pressed() -> void:
	_sfx_slider.value = _original_sfx_volume
	_music_slider.value = _original_music_volume
	_settings_menu.visible = false
	_main_menu.visible = true
