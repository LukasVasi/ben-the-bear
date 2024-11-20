class_name SearchCursor
extends Sprite2D

## Imitates the cursor when in search mode.
## Used to find nearby interactable objects.
## Shakes based on proximity to interactable objects.

@export var enabled : bool = false: set = set_enabled

## How much the shake offset is increased after calculating intensity.
@export var shake_multiplier : float = 1.0

## How much the outline width is increased after calculating intensity.
@export var width_multiplier : float = 1.0

@onready var _find_audio_player : AudioStreamPlayer = get_node("FindAudioPlayer")

@onready var _find_particles : GPUParticles2D = get_node("FindParticles")

func _ready() -> void:
	z_index = 36 # ensure the z index is high enough to be above everything else
	material = material.duplicate() # ensure the material is unique
	_update_enabled()


func _process(_delta: float) -> void:
	var closest_object : InteractableObject = null
	var min_distance : float = 0.0
	var cursor_position : Vector2 = get_global_mouse_position()
	
	# Iterate through the scene's interactable objects and find the closes hidden one
	for object : InteractableObject in get_tree().get_nodes_in_group("interactable_object"):
		if object.is_hidden():
			var distance_to_object : float = cursor_position.distance_to(object.global_position)
			if not is_instance_valid(closest_object) or distance_to_object < min_distance:
				closest_object = object
				min_distance = distance_to_object
	
	# The shake intensity that decides the offset from cursor's position.
	var shake_intensity : float = 0.0
	
	# Check if a hidden object has been found
	if is_instance_valid(closest_object):
		# Find object if close enough
		if min_distance < closest_object.find_distance:
			closest_object.find()
			_find_audio_player.play()
			_find_particles.restart()
		else:
			# Shake the cursor based on how close we are to the object
			# Shake intensity is calcualted by interpolating distance between two values
			# it is 0 when further than closest_object.find_distance * 6
			# and 1.0 when at closest_object.find_distance * 2 or closer
			shake_intensity = 1 - \
				clampf(
					(min_distance - closest_object.find_distance * 2) / (closest_object.find_distance * 4), 
					0.0, 1.0
					)
	
	# Generate a random offset for shaking
	var shake_offset = Vector2(
		randf_range(-shake_intensity, shake_intensity),
		randf_range(-shake_intensity, shake_intensity)
	)
	
	# Move the cursor
	global_position = get_global_mouse_position() + shake_offset * shake_multiplier
	
	# Apply a highlight to the cursor
	var outline_material = material as ShaderMaterial
	if shake_intensity > 0.0:
		outline_material.set_shader_parameter("enabled", true)
		outline_material.set_shader_parameter("width", shake_intensity * width_multiplier)
	else:
		outline_material.set_shader_parameter("enabled", false)


func set_enabled(value : bool) -> void:
	enabled = value
	_update_enabled()


func _update_enabled() -> void:
	visible = enabled
	set_process(enabled)
