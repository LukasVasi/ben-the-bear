class_name SceneBase
extends Node

@export var scene_name : String = "SceneBase"

var scene_state : Dictionary

@onready var staging: Staging = get_tree().get_first_node_in_group("staging")

func load_scene_state() -> void:
	scene_state = SaveManager.load_scene_state(scene_name)
	_load_object_states()


func save_scene_state() -> void:
	SaveManager.save_scene_state(scene_name, scene_state)


func _load_object_states() -> void:
	# Override the default states
	for object : InteractableObject in get_tree().get_nodes_in_group("interactable_object"):
		if scene_state.has(object.name):
			print("State with key ", object.name, " has been found, loading")
			object.load_object(self, scene_state[object.name])
		else:
			object.load_object(self, null)


func update_object_state(key: String, state: ObjectState) -> void:
	if scene_state.has(key):
		print("State with key ", key, " has been found, updating")
	else:
		print("State with key ", key, " has not been found adding a new state")
	
	scene_state[key] = state
	
	
