class_name BakeryScene
extends SceneBase

@export var _basket_item : Item

@onready var _buns : InteractableObject = get_node("Buns")

func load_scene_state() -> void:
	super()
	Dialogic.VAR.variable_changed.connect(_on_dialogic_variable_changed)
	if Dialogic.VAR.progression_variable == "return_to_baker":
		_buns.enable()


func _on_dialogic_variable_changed(info : Dictionary) -> void:
	if info["variable"] == "progression_variable":
		match info["new_value"]:
			"return_to_baker":
				_buns.enable()
			"quest_complete":
				if _basket_item:
					PlayerManager.add_item(_basket_item)


func _on_buns_visibility_state_changed(state: ObjectState.VisibilityState) -> void:
	if state == ObjectState.VisibilityState.Found:
		Dialogic.VAR.progression_variable = "found_the_buns"


func _on_rick_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		Dialogic.start("ricky_timeline")
