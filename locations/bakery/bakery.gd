class_name BakeryScene
extends SceneBase


func _on_buns_visibility_state_changed(state: ObjectState.VisibilityState) -> void:
	if state == ObjectState.VisibilityState.Found:
		Dialogic.VAR.progression_variable = "found_the_buns"


func _on_rick_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		Dialogic.start("ricky_timeline")
