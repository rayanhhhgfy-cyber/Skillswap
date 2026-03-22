extends Node3D

@export var min_energy = 0.5
@export var max_energy = 2.0
@export var flicker_speed = 0.1

@onready var light = get_node(".")

func _process(_delta):
	if light and light is Light3D:
		if randf() < flicker_speed:
			light.light_energy = lerp(min_energy, max_energy, randf())
