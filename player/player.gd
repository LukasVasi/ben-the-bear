class_name Player
extends CharacterBody2D


enum PointerState {
	Default,
	Search,
}

@export var movement_speed: float = 80.0

@onready var _navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var _search_cursor: SearchCursor = get_node("SearchCursor")

@onready var _pause_menu: PauseMenu = get_node("PauseMenu")
@onready var _inventory: Inventory = get_node("Inventory")
@onready var _map: Map = get_node("Map")

var _pointer_state : PointerState = PointerState.Default


func _process(_delta: float) -> void:
	#region Process escape action
	if Input.is_action_just_pressed("escape"):
		# Close any open overlays
		var overlay_was_visible: bool = false
		if _pause_menu.visible:
			_pause_menu.close()
			overlay_was_visible = true
		if _inventory.visible:
			_inventory.close()
			overlay_was_visible = true
		if _map.visible:
			_map.close()
			overlay_was_visible = true
		
		# If no overlay was open assume player wanted to pause
		if not overlay_was_visible:
			if _pointer_state == PointerState.Search:
				_toggle_search()
			_pause_menu.open()
	#endregion
	
	#region Process search action
	if (
		Input.is_action_just_pressed("search") and 
		not _pause_menu.visible and not _inventory.visible and not _map.visible
	):
		_toggle_search()
	
	
	# Disable search on any interaction or overlay opening
	if (
		_pointer_state == PointerState.Search and 
		(
			Input.is_action_just_pressed("interact") or 
			Input.is_action_just_pressed("cancel") or 
			Input.is_action_just_pressed("map") or 
			Input.is_action_just_pressed("inventory")
		)
		):
		_toggle_search()
	#endregion
	
	#region Process map action
	if (
		Input.is_action_just_pressed("map") and PlayerManager.has_map() and 
		not _pause_menu.visible and not _inventory.visible
		):
		if not _map.visible:
			_map.open()
		else:
			_map.close()
	#endregion
	
	#region Process inventory action
	if (
		Input.is_action_just_pressed("inventory") and
		not _pause_menu.visible and not _map.visible
	):
		if not _inventory.visible:
			_inventory.open()
		else:
			_inventory.close()
	#endregion


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
	if get_tree().paused or Dialogic.current_timeline != null:
		return
	
	if Input.is_action_just_pressed("interact"):
		_navigation_agent.target_position = get_global_mouse_position()
	
	if not _navigation_agent.is_navigation_finished():
		velocity = global_position.direction_to(
			_navigation_agent.get_next_path_position()
			) * movement_speed
		move_and_slide()
