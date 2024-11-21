extends Control

@onready var _money_label : Label = get_node("PanelContainer/HBoxContainer/VSplitContainer/MoneyLabel")

func _process(_delta: float) -> void:
	_money_label.text = str(PlayerManager.get_money())
