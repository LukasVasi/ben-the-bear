extends Node

var player_state : PlayerState

func _ready() -> void:
	var saved_state : PlayerState = SaveManager.load_player_state()
	if saved_state == null:
		player_state = PlayerState.new()
	else:
		player_state = saved_state
		Dialogic.VAR.set_variable("progression_variable", player_state.progression_variable)
		print("Player state loaded:\n", saved_state)


func set_last_scene(scene_path : String) -> void:
	player_state.last_scene_path = scene_path


func get_last_scene() -> String:
	return player_state.last_scene_path


func save_settings(sfx_volume : float, music_volume : float) -> void:
	player_state.sfx_volume = sfx_volume
	player_state.music_volume = music_volume
	print(player_state.sfx_volume, " ", player_state.music_volume)


func get_sfx_setting() -> float:
	print(player_state.sfx_volume)
	return player_state.sfx_volume


func get_music_setting() -> float:
	print(player_state.music_volume)
	return player_state.music_volume


func add_item(item : Resource) -> void:
	player_state.inventory.append(item)


func add_money(value : int) -> void:
	player_state.money += value


func get_money() -> int:
	return player_state.money


func get_inventory() -> Array[Item]:
	return player_state.inventory


func has_map() -> bool:
	return player_state.inventory.any(func (item : Item): return item.name == "Map")


func save_state() -> void:
	# Retrieve the current progression variable value
	player_state.progression_variable = Dialogic.VAR.get_variable("progression_variable")
	SaveManager.save_player_state(player_state)
