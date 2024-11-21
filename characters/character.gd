class_name Character
extends Area2D


func interact() -> void:
	pass # overriden by concrete characters


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		interact()
