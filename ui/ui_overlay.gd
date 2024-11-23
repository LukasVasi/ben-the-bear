class_name UIOverlay
extends Control

func _ready() -> void:
	visible = false # ensure we start invisible


func open() -> void:
	visible = true


func close() -> void:
	visible = false
