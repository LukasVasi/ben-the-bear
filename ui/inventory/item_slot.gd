class_name ItemSlot
extends PanelContainer


@onready var _display: TextureRect = get_node("CenterContainer/ItemDisplay")

var _item: Item = null


func _ready() -> void:
	_display.visible = false


## Adds item to slot and enables its visual.
func set_item(item: Item) -> void:
	if not is_instance_valid(item):
		_display.visible = false
	else:
		_item = item
		_display.texture = item.texture
		_display.visible = true


## Starts the item's Dialogic timeline on click.
func _on_gui_input(event: InputEvent) -> void:
	if is_instance_valid(_item) and event.is_action_pressed("interact"):
		Dialogic.start(_item.timeline)
