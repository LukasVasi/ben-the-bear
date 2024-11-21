class_name VolumeSlider
extends HSlider

@export var bus_name : String

var _bus_index : int

func _ready() -> void:
	if bus_name:
		_bus_index = AudioServer.get_bus_index(bus_name)
		value = db_to_linear(AudioServer.get_bus_volume_db(_bus_index))
		value_changed.connect(_on_value_changed)

func _on_value_changed(_value : float) -> void:
	AudioServer.set_bus_volume_db(
		_bus_index,
		linear_to_db(value)
	)
