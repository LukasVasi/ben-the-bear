@tool
extends InteractableObject

@export var value : int = 2

func pick_up() -> void:
	super()
	PlayerManager.add_money(value)
