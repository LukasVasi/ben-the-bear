class_name ObjectState
extends Resource

enum VisibilityState {
	Disabled, # cannot be found or picked up yet
	Hidden, # can be found
	Found, # object has been found in the scene
	PickedUp, # object has been found and picked up - not visible
}

@export var visibility_state : VisibilityState = VisibilityState.Disabled

# Convert to a dictionary for saving
func to_dict() -> Dictionary:
	return {
		"visibility_state": int(visibility_state)
	}

# Load from a dictionary
func from_dict(data: Dictionary) -> void:
	visibility_state = data.get("visibility_state", VisibilityState.Disabled)
