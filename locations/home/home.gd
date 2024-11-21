class_name HomeScene
extends SceneBase

@onready var _movement_area : Area2D = get_node("MovementArea")
@onready var _map : InteractableObject = get_node("Map")

func load_scene_state() -> void:
	super()
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	
	# Choose the timeline and label to play
	if scene_dialogue_state.is_empty():
		print("No dialogue state acquired, starting from intro")
		Dialogic.start("intro_timeline")
	
	if not scene_dialogue_state.has("eddie_timeline"):
		print("No eddie timeline checkpoint, starting it from the start")
		Dialogic.start("eddie_timeline")
	else:
		match scene_dialogue_state["eddie_timeline"]:
			"quest accepted":
				print("Starting Eddie timeline at quest accepted")
				Dialogic.start("eddie_timeline", "quest accepted")
			"quest refused":
				print("Starting Eddie timeline at change of heart")
				Dialogic.start("eddie_timeline", "change of heart")
			"intro finished":
				if not scene_dialogue_state.has("tutorial_timeline"):
					print("No tutorial checkpoint, starting it from the start")
					Dialogic.start("tutorial_timeline")
				else:
					match scene_dialogue_state["tutorial_timeline"]:
						"finished":
							return
						_:
							Dialogic.start("tutorial_timeline", scene_dialogue_state["tutorial_timeline"])
	
	


func cleanup() -> void:
	Dialogic.signal_event.disconnect(_on_dialogic_signal_event)
	#Dialogic.event_handled.disconnect(_on_handle_event)
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


#func _on_handle_event(_resource: DialogicEvent) -> void:
	#Dialogic.Save.save(scene_name + "_save")


func _on_dialogic_signal_event(argument: String) -> void:
	if argument.contains("checkpoint_"):
		print("Encountered a dialogue checkpoint: ", argument)
		match argument:
			"checkpoint_intro_finished":
				scene_dialogue_state["intro_timeline"] = "finished"
			"checkpoint_quest_accepted":
				scene_dialogue_state["eddie_timeline"] = "quest accepted"
			"checkpoint_quest_refused":
				scene_dialogue_state["eddie_timeline"] = "quest refused"
			"checkpoint_eddie_intro_finished":
				scene_dialogue_state["eddie_timeline"] = "intro finished"
			"checkpoint_tutorial_finished":
				scene_dialogue_state["tutorial_timeline"] = "finished"
			"checkpoint_tutorial_movement":
				scene_dialogue_state["tutorial_timeline"] = "the movement"
			"checkpoint_tutorial_searching":
				scene_dialogue_state["tutorial_timeline"] = "the searching"
			"checkpoint_tutorial_map":
				scene_dialogue_state["tutorial_timeline"] = "the map"
	else:
		match argument:		
			"quit_game":
				staging.handle_quit()
			"tutorial_accepted":
				_movement_area.visible = true
				_movement_area.body_entered.connect(_on_movement_area_body_entered)
				_map.visibility_state_changed.connect(_on_map_visibility_state_changed)
