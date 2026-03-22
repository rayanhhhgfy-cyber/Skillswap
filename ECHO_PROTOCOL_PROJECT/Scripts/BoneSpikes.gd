extends Node3D

@export var DAMAGE = 100.0
@export var MUTATION_COST = 4.0
@export var COOLDOWN = 1.5

var can_attack = true
var current_cooldown = 0.0

@onready var mutation_manager = get_parent().get_node("MutationManager")
@onready var animation_player = get_parent().get_node("Player/AnimationPlayer")

func _process(delta):
	# Update cooldown
	if not can_attack:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_attack = true

	# Check for input (Attack)
	if Input.is_action_just_pressed("attack"):
		if mutation_manager.has_bone_spikes and can_attack:
			perform_bone_spikes_attack()

func perform_bone_spikes_attack():
	# Animation for brutal melee
	animation_player.play("bone_spikes_attack")

	# Raycast or detection area logic
	var target = $AttackArea.get_overlapping_bodies()
	for body in target:
		if body.is_in_group("infected"):
			body.take_damage(DAMAGE)

	can_attack = false
	current_cooldown = COOLDOWN

	# Mutation cost
	mutation_manager.mutation_level += MUTATION_COST
	mutation_manager.emit_signal("mutation_changed", mutation_manager.mutation_level)
