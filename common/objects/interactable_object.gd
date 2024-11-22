@tool
class_name InteractableObject
extends Area2D

## An object that can be found in the scene and picked up

signal visibility_state_changed(state : ObjectState.VisibilityState)

## Find distance specifies how close the pointer has to be to the obejct to find it.
@export var find_distance : float = 10

## The texture of the object.
@export var texture : Texture2D = load("res://assets/kenney_cursor_pixel_pack/Tiles/tile_0180.png") : set = set_texture

@onready var _sprite : Sprite2D = get_node("Sprite2D")

@export var state : ObjectState

@export var item : Item

var _parent_scene : SceneBase

func _ready() -> void:
	_sprite.texture = texture # gotta ensure this is set once sprite is initialised
	_sprite.material = _sprite.material.duplicate() # ensure that the material is unique


## Called by the parent scene base when loading in.
func load_object(parent: SceneBase, saved_state: ObjectState) -> void:
	_parent_scene = parent
	if is_instance_valid(saved_state):
		state = saved_state # override the default state if provided
		_update_visual()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		match state.visibility_state:
			ObjectState.VisibilityState.Found:
				pick_up()
			ObjectState.VisibilityState.Hidden:
				find()


func pick_up() -> void:
	state.visibility_state = ObjectState.VisibilityState.PickedUp
	visibility_state_changed.emit(state.visibility_state)
	_parent_scene.update_object_state(name, state)
	_update_visual()
	PlayerManager.add_item(item)
	print("Successfully picked up " + name)


func find() -> void:
	if Engine.is_editor_hint():
		return
	
	if state.visibility_state == ObjectState.VisibilityState.Hidden:
		print("Object ", self, " has been found")
		state.visibility_state = ObjectState.VisibilityState.Found
		visibility_state_changed.emit(state.visibility_state)
		_update_visual()
		_parent_scene.update_object_state(name, state)


func enable() -> void:
	if Engine.is_editor_hint():
		return
	
	if state.visibility_state == ObjectState.VisibilityState.Disabled:
		state.visibility_state = ObjectState.VisibilityState.Hidden
		visibility_state_changed.emit(state.visibility_state)
		_update_visual()
		_parent_scene.update_object_state(name, state)


func is_hidden() -> bool:
	return state.visibility_state == ObjectState.VisibilityState.Hidden


func _update_visual() -> void:
	match state.visibility_state:
		ObjectState.VisibilityState.Found:
			visible = true
			_sprite.material.set_shader_parameter("enabled", true) # enable the highlight
		ObjectState.VisibilityState.PickedUp:
			visible = false
			_sprite.material.set_shader_parameter("enabled", false) # disable the highlight
		_:
			visible = true
			_sprite.material.set_shader_parameter("enabled", false) # disable the highlight


func set_texture(new_texture : Texture2D) -> void:
	texture = new_texture
	if is_instance_valid(_sprite):
		_sprite.texture = texture
