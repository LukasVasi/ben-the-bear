@tool
class_name InteractableObject
extends Area2D

## An object that can be found in the scene and picked up

enum State {
	Disabled, # cannot be found or picked up yet
	Hidden, # can be found
	Found, # object has been found in the scene
	PickedUp, # object has been found and picked up
}

## Find distance specifies how close the pointer has to be to the obejct to find it.
@export var find_distance : float = 10

## The texture of the object.
@export var texture : Texture2D = load("res://assets/kenney_cursor_pixel_pack/Tiles/tile_0180.png") : set = set_texture

@onready var _sprite : Sprite2D = get_node("Sprite2D")

var _state : State = State.Hidden


func _ready() -> void:
	_sprite.texture = texture # gotta ensure this is set once sprite is initialised
	_sprite.material = _sprite.material.duplicate() # ensure that the material is unique


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact") and _state == State.Found:
		print("Successfully interacted with object")


func find() -> void:
	if Engine.is_editor_hint():
		return
	
	if _state == State.Hidden:
		print("Object ", self, " has been found")
		_state = State.Found
		_sprite.material.set_shader_parameter("enabled", true) # enable the highlight


func is_hidden() -> bool:
	return _state == State.Hidden


func set_texture(new_texture : Texture2D) -> void:
	texture = new_texture
	if is_instance_valid(_sprite):
		_sprite.texture = texture
