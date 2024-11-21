extends Node

const SAVE_FILE_START = "user://"
const OBJECT_SAVE_FILE_END = "_objects.save"
const DIALOGUE_SAVE_FILE_END = "_dialogue.save"


func save_scene_object_state(scene_name : String, scene_object_state : Dictionary) -> void:
	var serialized_scene_state : Dictionary
	
	# Serialize the scene_state dictionary
	for key in scene_object_state.keys():
		if scene_object_state[key] is ObjectState:
			serialized_scene_state[key] = scene_object_state[key].to_dict()
	
	# Save the state to file
	var file_path : String = SAVE_FILE_START + scene_name + OBJECT_SAVE_FILE_END
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var json_content = JSON.stringify(serialized_scene_state)
		file.store_string(json_content)
		file.close()
		print("Successfully saved the object state of ", scene_name, " scene")


func save_scene_dialogue_state(scene_name : String, scene_dialogue_state : Dictionary) -> void:
	# Save the state to file
	var file_path : String = SAVE_FILE_START + scene_name + DIALOGUE_SAVE_FILE_END
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var json_content = JSON.stringify(scene_dialogue_state) # no need for serialization, just strings
		file.store_string(json_content)
		file.close()
		print("Successfully saved the dialogue state of ", scene_name, " scene")


func load_scene_object_state(scene_name : String) -> Dictionary:
	var file_path : String = SAVE_FILE_START + scene_name + OBJECT_SAVE_FILE_END
	if not FileAccess.file_exists(file_path):
		print("Object state save file for scene ", scene_name, " not found")
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
		
	print("Successfully loaded the object state of ", scene_name, " scene:\n", scene_state)
	
	return scene_state


func load_scene_dialogue_state(scene_name : String) -> Dictionary:
	var file_path : String = SAVE_FILE_START + scene_name + DIALOGUE_SAVE_FILE_END
	if not FileAccess.file_exists(file_path):
		print("Dialogue state save file for scene ", scene_name, " not found")
		return Dictionary()
	
	var save_file = FileAccess.open(file_path, FileAccess.READ)
	var json_content = save_file.get_as_text()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_content)
	if not parse_result == OK:
			print("Encountered JSON Parse Error while loading: ", json.get_error_message())
			return Dictionary()
	
	var scene_state = json.get_data()
	
	print("Successfully loaded the dialogue state of ", scene_name, " scene:\n", scene_state)
	
	return scene_state
