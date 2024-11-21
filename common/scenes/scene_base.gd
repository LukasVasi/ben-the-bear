class_name SceneBase
extends Node

## Stores the states of the scene's objects with the object's name as key.
var scene_object_state : Dictionary

## Stores the previous states of the scene's timelines 
## with the name of timeline as key and checkpoint label as value.
var scene_dialogue_state : Dictionary

@onready var staging: Staging = get_tree().get_first_node_in_group("staging")

func load_scene_state() -> void:
	scene_dialogue_state = SaveManager.load_scene_dialogue_state(name)
	scene_object_state = SaveManager.load_scene_object_state(name)
	_load_object_states()


func save_scene_state() -> void:
	SaveManager.save_scene_dialogue_state(name, scene_dialogue_state)
	SaveManager.save_scene_object_state(name, scene_object_state)


func cleanup() -> void:
	pass


func _load_object_states() -> void:
	# Override the default states
	for object : InteractableObject in get_tree().get_nodes_in_group("interactable_object"):
		if scene_object_state.has(object.name):
			print("State with key ", object.name, " has been found, loading")
			object.load_object(self, scene_object_state[object.name])
		else:
			object.load_object(self, null)


func update_object_state(key: String, state: ObjectState) -> void:
	if scene_object_state.has(key):
		print("State with key ", key, " has been found, updating")
	else:
		print("State with key ", key, " has not been found adding a new state")
	
	scene_object_state[key] = state
	
	
