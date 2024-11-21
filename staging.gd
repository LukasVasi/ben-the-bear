class_name Staging
extends Node

@export_file("*.tscn") var main_menu_path : String

@onready var _scene_container : Node = get_node("SceneContainer")
@onready var _fade : ColorRect = get_node("Fade")

var _current_scene : SceneBase
var _tween : Tween

func _ready() -> void:
	# Make sure we don't automatically quit when window close is requested
	get_tree().set_auto_accept_quit(false)
	_set_fade(1.0)
	load_scene(main_menu_path)

func load_scene(scene_path: String) -> void:
	# Pause the game
	get_tree().paused = true
	
	# If a current scene is visible then fade it out and unload it.
	if _current_scene:
		# Fade to black
		if _tween:
			_tween.kill()
		_tween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		_tween.tween_method(_set_fade, 0.0, 1.0, 1.0)
		await _tween.finished
		
		# Save the scene state
		_current_scene.save_scene_state()
		
		# Remove old scene
		_scene_container.remove_child(_current_scene)
		_current_scene.queue_free()
		_current_scene = null
	
	# Get the new scene TODO: loading screen
	var new_scene : PackedScene = load(scene_path)
	
	# Setup the new scene
	_current_scene = new_scene.instantiate()
	_scene_container.add_child(_current_scene)
	
	# Load the scene state
	_current_scene.load_scene_state()
	
	# Fade to visible
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_tween.tween_method(_set_fade, 1.0, 0.0, 1.0)
	await _tween.finished
	
	# Unpause
	get_tree().paused = false


func handle_quit() -> void:
	if _current_scene:
		# Fade to black
		if _tween:
			_tween.kill()
		_tween = get_tree().create_tween()
		_tween.tween_method(_set_fade, 0.0, 1.0, 1.0)
		await _tween.finished
		
		# Save the scene state
		_current_scene.save_scene_state()
	
	get_tree().quit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		handle_quit()


func _set_fade(value : float):
	_fade.color.a = value
