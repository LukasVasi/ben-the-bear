class_name Player
extends CharacterBody2D


@export var movement_speed : float = 10.0

@onready var _navigation_agent : NavigationAgent2D = get_node("NavigationAgent2D")

@onready var _search_cursor : SearchCursor =get_node("SearchCursor")

@onready var _map : Map = get_node("Map")

var _pointer_state : PointerState = PointerState.Default

enum PointerState {
	Default,
	Search,
}

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_search"):
		_toggle_search()
	
	if Input.is_action_just_released("interact") or Input.is_action_just_pressed("cancel"):
		if _pointer_state == PointerState.Search:
			_toggle_search()
	
	if Input.is_action_just_pressed("open_map"):
		if _pointer_state == PointerState.Search:
			_toggle_search()
		
		_map.visible = not _map.visible


func _toggle_search() -> void:
	if _pointer_state == PointerState.Default:
		_pointer_state = PointerState.Search
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		_search_cursor.enabled = true
	else:
		_pointer_state = PointerState.Default
		_search_cursor.enabled = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Dialogic.current_timeline == null:
		var pointer_location := get_global_mouse_position()
		_navigation_agent.target_position = pointer_location
	
	if not _navigation_agent.is_navigation_finished():
		var next_path_position := _navigation_agent.get_next_path_position()
		velocity = global_position.direction_to(next_path_position) * movement_speed
		move_and_slide()
