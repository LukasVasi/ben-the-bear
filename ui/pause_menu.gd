class_name PauseMenu
extends Control

@onready var _pause_menu : CenterContainer = get_node("PauseMenuContainer")
@onready var _settings_menu : CenterContainer = get_node("SettingsContainer")
@onready var _sfx_slider : VolumeSlider = get_node("SettingsContainer/PanelContainer/MarginContainer/VBoxContainer/SFXVolumeHBoxContainer/SFXHSlider")
@onready var _music_slider : VolumeSlider = get_node("SettingsContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeHBoxContainer2/MusicHSlider")

var _original_sfx_volume : float = 1.0
var _original_music_volume : float = 1.0

func _ready() -> void:
	visible = false
	_pause_menu.visible = true
	_settings_menu.visible = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		var paused : bool = not visible
		get_tree().paused = paused
		visible = paused


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_settings_button_pressed() -> void:
	_pause_menu.visible = false
	_settings_menu.visible = true
	_original_sfx_volume = _sfx_slider.value
	_original_music_volume = _music_slider.value

func _on_quit_button_pressed() -> void:
	var staging : Staging = get_tree().get_first_node_in_group("staging")
	staging.handle_quit()


func _on_settings_save_button_pressed() -> void:
	_settings_menu.visible = false
	_pause_menu.visible = true


func _on_cancel_button_pressed() -> void:
	_sfx_slider.value = _original_sfx_volume
	_music_slider.value = _original_music_volume
	_settings_menu.visible = false
	_pause_menu.visible = true
