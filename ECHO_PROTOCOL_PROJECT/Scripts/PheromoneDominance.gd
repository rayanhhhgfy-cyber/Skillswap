extends Node3D

@export var COOLDOWN = 6.0 # Faster availability
@export var RADIUS = 8.0 # Larger area
@export var DRAIN_RATE = 1.0 # Minimal mutation cost

var can_use_pheromone = true
var current_cooldown = 0.0

@onready var player = get_parent()
@onready var mutation_manager = get_node_or_null("../../MutationManager")

func _process(delta):
	if not can_use_pheromone:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_use_pheromone = true

	if player and player.is_holding_breath and Input.is_action_just_pressed("use_ability"):
		if can_use_pheromone:
			emit_signal_to_infected()

func emit_signal_to_infected():
	if mutation_manager:
		var effective_radius = RADIUS * (1.0 + (mutation_manager.mutation_level / 100.0))
		var detection_area = get_node_or_null("DetectionArea")
		if detection_area:
			var bodies = detection_area.get_overlapping_bodies()
			for body in bodies:
				if body.is_in_group("infected"):
					if body.has_method("freeze_in_place"):
						body.freeze_in_place(effective_radius)

		can_use_pheromone = false
		current_cooldown = COOLDOWN
		mutation_manager.mutation_level += DRAIN_RATE
		mutation_manager.emit_signal("mutation_changed", mutation_manager.mutation_level)
