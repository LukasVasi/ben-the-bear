class_name HairSalonScene
extends SceneBase


func _on_nina_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		Dialogic.start("nina_timeline")
