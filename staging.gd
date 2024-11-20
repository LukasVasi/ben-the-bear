class_name Staging
extends Node

@export_file("*.tscn") var main_menu_path : String

@onready var _scene_container : Node = get_node("SceneContainer")
@onready var _fade : ColorRect = get_node("Fade")

var _current_scene : Node
var _tween : Tween

func _ready() -> void:
	load_scene(main_menu_path)

func load_scene(scene_path: String) -> void:
	# If a current scene is visible then fade it out and unload it.
	if _current_scene:
		# Fade to black
		if _tween:
			_tween.kill()
		_tween = get_tree().create_tween()
		_tween.tween_method(_set_fade, 0.0, 1.0, 1.0)
		await _tween.finished

		# Remove old scene
		_scene_container.remove_child(_current_scene)
		_current_scene.queue_free()
		_current_scene = null
	
	# Get the new scene TODO: loading screen
	var new_scene : PackedScene = load(scene_path)
	
	# Setup the new scene
	_current_scene = new_scene.instantiate()
	_scene_container.add_child(_current_scene)
	
	# Fade to visible
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_method(_set_fade, 1.0, 0.0, 1.0)
	await _tween.finished
	
	# TODO: notify the scene about finished loading

func _set_fade(value : float):
	_fade.color.a = value
