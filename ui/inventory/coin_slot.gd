class_name CoinSlot
extends PanelContainer

var money: int = 0 : set = _set_money

@onready var _label: Label = get_node("CenterContainer/HBoxContainer/Label")


func _set_money(value: int) -> void:
	money = value
	_label.text = str(value)


## Starts the item's Dialogic timeline on click.
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		Dialogic.start("coins_timeline")
