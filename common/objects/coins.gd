@tool
extends InteractableObject

@export var value : int = 2

func pick_up() -> void:
	state.visibility_state = ObjectState.VisibilityState.PickedUp
	visibility_state_changed.emit(state.visibility_state)
	_parent_scene.update_object_state(name, state)
	_update_visual()
	PlayerManager.add_money(value)
	print("Successfully picked up ", value, " coins")
