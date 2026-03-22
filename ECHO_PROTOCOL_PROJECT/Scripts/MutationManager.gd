extends Node

signal mutation_changed(level)
signal ability_unlocked(ability_name)

@export var mutation_level: float = 12.0 # Act 1 starting point
@export var stress_rate: float = 0.01

var has_bone_spikes = false
var has_echolocation = false
var has_pheromone_dominance = true # Basic instinct starts early

func _process(delta):
	# Gradually increase mutation based on stress, sprint, combat
	var stress_multiplier = 1.0
	var player = get_parent().get_node("Player")
	if player:
		if player.is_sprinting:
			stress_multiplier = 2.0
		elif player.is_crouching:
			stress_multiplier = 0.5

	mutation_level += stress_rate * stress_multiplier * delta
	mutation_level = clamp(mutation_level, 0, 100)

	emit_signal("mutation_changed", mutation_level)
	check_thresholds()

func check_thresholds():
	if mutation_level >= 30.0 and not has_bone_spikes:
		unlock_ability("bone_spikes")
	if mutation_level >= 50.0 and not has_echolocation:
		unlock_ability("echolocation")

	if mutation_level >= 85.0:
		handle_cortical_override()

func unlock_ability(ability_name):
	match ability_name:
		"bone_spikes":
			has_bone_spikes = true
		"echolocation":
			has_echolocation = true
	emit_signal("ability_unlocked", ability_name)

func handle_cortical_override():
	# Visual/UI feedback for the 85% threshold
	pass

func reduce_mutation(amount):
	mutation_level -= amount
	mutation_level = clamp(mutation_level, 0, 100)
	emit_signal("mutation_changed", mutation_level)
