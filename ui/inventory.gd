class_name Inventory
extends Control

@onready var _inv_slots : Array[Node] = get_node("NinePatchRect/GridContainer").get_children()

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if not visible:
			_open_inventory()
		else:
			visible = false


func _open_inventory() -> void:
	var inventory : Array[Item] = PlayerManager.get_inventory()
	for i : int in min(inventory.size(), _inv_slots.size()):
		_inv_slots[i].set_item(inventory[i])
	
	visible = true
