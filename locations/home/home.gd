extends Node2D

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	Dialogic.start("intro_timeline")

func _on_dialogic_signal_event(argument: String) -> void:
	if argument == "quit_game":
		get_tree().quit()
