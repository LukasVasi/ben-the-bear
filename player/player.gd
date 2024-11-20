class_name Player
extends CharacterBody2D

@export var movement_speed : float = 10.0

@onready var _navigation_agent : NavigationAgent2D = get_node("NavigationAgent2D")

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Dialogic.current_timeline == null:
		var pointer_location := get_global_mouse_position()
		_navigation_agent.target_position = pointer_location
	
	if not _navigation_agent.is_navigation_finished():
		var next_path_position := _navigation_agent.get_next_path_position()
		velocity = global_position.direction_to(next_path_position) * movement_speed
		move_and_slide()
