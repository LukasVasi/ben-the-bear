extends Node

const SAVE_FILE_START = "user://"
const SAVE_FILE_END = "_data.save"

signal finished_saving

func save_scene_state(scene_name : String, scene_state : Dictionary) -> void:
	var serialized_scene_state : Dictionary
	
	# Serialize the scene_state dictionary
	for key in scene_state.keys():
		if scene_state[key] is ObjectState:
			serialized_scene_state[key] = scene_state[key].to_dict()
	
	# Save the state to file
	var file_path : String = SAVE_FILE_START + scene_name + SAVE_FILE_END
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var json_content = JSON.stringify(serialized_scene_state)
		file.store_string(json_content)
		file.close()
		print("Successfully saved the data of ", scene_name, " scene")
	
	finished_saving.emit()


func load_scene_state(scene_name : String) -> Dictionary:
	var file_path : String = SAVE_FILE_START + scene_name + SAVE_FILE_END
	if not FileAccess.file_exists(file_path):
		print("Data save file for scene ", scene_name, " not found, data not loaded")
		return Dictionary()
	
	var save_file = FileAccess.open(file_path, FileAccess.READ)
	var json_content = save_file.get_as_text()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_content)
	if not parse_result == OK:
			print("Encountered JSON Parse Error while loading: ", json.get_error_message())
			return Dictionary()
			
	var serialized_scene_state : Dictionary = json.get_data()
	var scene_state : Dictionary
	for object_name : String in serialized_scene_state.keys():
		var serialized_object_state : Dictionary = serialized_scene_state[object_name]
		var object_state : ObjectState = ObjectState.new()
		object_state.from_dict(serialized_object_state)
		scene_state[object_name] = object_state
		
	print("Successfully loaded the data of ", scene_name, " scene:\n", scene_state)
	
	return scene_state
