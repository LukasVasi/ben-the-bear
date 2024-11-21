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
	var slot : int = 0
	for item : Item in inventory:
		_inv_slots[slot].set_item(item)
		slot += 1
	
	visible = true
