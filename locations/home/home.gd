class_name HomeScene
extends SceneBase

@onready var _movement_area : Area2D = get_node("MovementArea")
@onready var _map : InteractableObject = get_node("Map")

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	Dialogic.event_handled.connect(_on_handle_event)
	
	# Try loading the previous state of the home scene
	if Dialogic.Save.has_slot(scene_name + "_save"):
		Dialogic.Save.load(scene_name + "_save")
	
	if Dialogic.current_timeline == null:
		# Nothing loaded, playing the intro
		print("No timeline loaded, starting the intro")
		Dialogic.start("intro_timeline")
	
	#else:
		#Dialogic.paused = true
		#match Dialogic.VAR.HomeScene.Checkpoint:
			#"intro_start":
				#print("Intro not finished, starting intro")
				#Dialogic.end_timeline()
				#Dialogic.start("intro_timeline")
			#"intro_skip":
				#print("Intro skipped, ending timeline")
				#Dialogic.end_timeline()
			#"eddie_intro_start":
				#print("Eddie intro not finished, starting Eddie intro")
				#Dialogic.end_timeline()
				#Dialogic.start("eddie_intro_timeline")
			#"eddie_intro_finished":
				#print("Eddie intro finished, ending timeline")
				#Dialogic.end_timeline()
			#_:
				#print("Checkpoint not recognised, starting the intro")
				#Dialogic.end_timeline()
				#Dialogic.start("intro_timeline")


func cleanup() -> void:
	Dialogic.signal_event.disconnect(_on_dialogic_signal_event)
	Dialogic.event_handled.disconnect(_on_handle_event)
	_movement_area.body_entered.disconnect(_on_movement_area_body_entered)
	_map.visibility_state_changed.disconnect(_on_map_visibility_state_changed)


func _on_map_visibility_state_changed(state: ObjectState.VisibilityState) -> void:
	print("Visibility change processing called")
	if state == ObjectState.VisibilityState.PickedUp:
		_map.visibility_state_changed.disconnect(_on_map_visibility_state_changed)
		Dialogic.start("tutorial_timeline", "the map")


func _on_movement_area_body_entered(body : Node2D) -> void:
	if body == get_node("Player"):
		_movement_area.body_entered.disconnect(_on_movement_area_body_entered)
		_movement_area.visible = false
		Dialogic.start("tutorial_timeline", "the searching")


func _on_handle_event(_resource: DialogicEvent) -> void:
	Dialogic.Save.save(scene_name + "_save")


func _on_dialogic_signal_event(argument: String) -> void:
	match argument:
		"quit_game":
			staging.handle_quit()
		"tutorial_accepted":
			_movement_area.visible = true
			_movement_area.body_entered.connect(_on_movement_area_body_entered)
			_map.visibility_state_changed.connect(_on_map_visibility_state_changed)
