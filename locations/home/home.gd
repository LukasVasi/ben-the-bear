class_name HomeScene
extends SceneBase

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
	else:
		Dialogic.finish_dialogue()
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


func _on_handle_event(_resource: DialogicEvent) -> void:
	Dialogic.Save.save(scene_name + "_save")


func _on_dialogic_signal_event(argument: String) -> void:
	if argument == "quit_game":
		staging.handle_quit()
