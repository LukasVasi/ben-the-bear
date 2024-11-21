class_name ItemSlot
extends Panel

@onready var _display : Sprite2D = get_node("CenterContainer/ItemDisplay")

var _item : Item

func set_item(item : Item) -> void:
	if not item:
		_display.visible = false
	else:
		_item = item
		_display.texture = item.texture
		_display.visible = true


func _on_gui_input(event: InputEvent) -> void:
	if _item and event.is_action_pressed("interact"):
		Dialogic.start(_item.timeline)
