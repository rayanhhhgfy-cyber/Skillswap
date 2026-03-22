extends Node3D

@export var COOLDOWN = 10.0
@export var RADIUS = 5.0
@export var DRAIN_RATE = 2.0

var can_use_pheromone = true
var current_cooldown = 0.0

@onready var player = get_parent().get_node("Player")
@onready var mutation_manager = get_parent().get_node("MutationManager")

func _process(delta):
	# Update cooldown
	if not can_use_pheromone:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_use_pheromone = true

	# Check for input (Hold Breath + Action)
	if player.is_holding_breath and Input.is_action_just_pressed("interact"):
		if can_use_pheromone:
			emit_signal_to_infected()

func emit_signal_to_infected():
	# Core stealth tool logic
	var effective_radius = RADIUS * (1.0 + (mutation_manager.mutation_level / 100.0))
	var bodies = $DetectionArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("infected"):
			body.freeze_in_place(effective_radius)

	can_use_pheromone = false
	current_cooldown = COOLDOWN

	# Mutation cost
	mutation_manager.mutation_level += DRAIN_RATE
	mutation_manager.emit_signal("mutation_changed", mutation_manager.mutation_level)
