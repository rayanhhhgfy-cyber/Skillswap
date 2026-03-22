extends Node3D

@export var DAMAGE = 150.0 # High damage for power fantasy
@export var MUTATION_COST = 1.5 # Lower cost so players can use it more
@export var COOLDOWN = 0.8 # Faster cooldown

var can_attack = true
var current_cooldown = 0.0

@onready var mutation_manager = get_node_or_null("../../MutationManager")
@onready var animation_player = get_parent().get_node_or_null("AnimationPlayer")

func _process(delta):
	if not can_attack:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_attack = true

	if Input.is_action_just_pressed("attack"):
		if mutation_manager and mutation_manager.has_bone_spikes and can_attack:
			perform_bone_spikes_attack()

func perform_bone_spikes_attack():
	if animation_player:
		animation_player.play("bone_spikes_attack")

	var attack_area = get_node_or_null("AttackArea")
	if attack_area:
		var target = attack_area.get_overlapping_bodies()
		for body in target:
			if body.is_in_group("infected"):
				if body.has_method("take_damage"):
					body.take_damage(DAMAGE)

	can_attack = false
	current_cooldown = COOLDOWN

	if mutation_manager:
		mutation_manager.mutation_level += MUTATION_COST
		mutation_manager.emit_signal("mutation_changed", mutation_manager.mutation_level)
