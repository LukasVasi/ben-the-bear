class_name Inventory
extends UIOverlay


@onready var _coin_slot: CoinSlot = get_node("CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/CoinSlot")

var _item_slots: Array[ItemSlot]


func _ready() -> void:
	super()
	_item_slots.assign(get_node("CenterContainer/PanelContainer/VBoxContainer/GridContainer").get_children())


func open() -> void:
	_update_inventory()
	super()


func _update_inventory() -> void:
	_coin_slot.money = PlayerManager.get_money()
	
	var inventory : Array[Item] = PlayerManager.get_inventory()
	for i : int in min(inventory.size(), _item_slots.size()):
		_item_slots[i].set_item(inventory[i])
