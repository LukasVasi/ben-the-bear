class_name Map
extends UIOverlay


func travel_to(scene_path: String) -> void:
	var _staging : Staging = get_tree().get_first_node_in_group("staging")
	_staging.load_scene(scene_path)


func _on_home_button_pressed() -> void:
	travel_to("res://locations/home/home.tscn")


func _on_bakery_button_pressed() -> void:
	travel_to("res://locations/bakery/bakery.tscn")


func _on_hair_salon_button_pressed() -> void:
	travel_to("res://locations/hair_salon/hair_salon.tscn")
