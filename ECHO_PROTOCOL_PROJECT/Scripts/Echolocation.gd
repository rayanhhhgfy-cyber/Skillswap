extends Node3D

@export var SONAR_RADIUS = 15.0
@export var MUTATION_COST = 2.0
@export var COOLDOWN = 5.0

var can_use_echolocation = true
var current_cooldown = 0.0

@onready var player = get_node("/root/Game/Player")
@onready var mutation_manager = get_node("/root/Game/MutationManager")
@onready var sonar_visuals = get_node_or_null("/root/Game/UI/HUD/SonarOverlay")

func _process(delta):
	if not can_use_echolocation:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_use_echolocation = true

	if player and player.velocity.length() < 0.1 and Input.is_action_just_pressed("interact"):
		if mutation_manager and mutation_manager.has_echolocation and can_use_echolocation:
			perform_sonar_ping()

func perform_sonar_ping():
	if sonar_visuals and sonar_visuals.has_method("activate_ping"):
		sonar_visuals.activate_ping(SONAR_RADIUS)

	var sonar_area = get_node_or_null("SonarDetectionArea")
	if sonar_area:
		var bodies = sonar_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("interactable") or body.is_in_group("infected"):
				if body.has_method("highlight_visual"):
					body.highlight_visual(3.0)

	can_use_echolocation = false
	current_cooldown = COOLDOWN

	if mutation_manager:
		mutation_manager.mutation_level += MUTATION_COST
		mutation_manager.emit_signal("mutation_changed", mutation_manager.mutation_level)
