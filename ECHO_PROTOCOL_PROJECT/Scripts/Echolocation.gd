extends Node3D

@export var SONAR_RADIUS = 15.0
@export var MUTATION_COST = 2.0
@export var COOLDOWN = 5.0

var can_use_echolocation = true
var current_cooldown = 0.0

@onready var player = get_parent().get_node("Player")
@onready var mutation_manager = get_parent().get_node("MutationManager")
@onready var sonar_visuals = get_parent().get_node("UI/SonarOverlay")

func _process(delta):
	# Update cooldown
	if not can_use_echolocation:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_use_echolocation = true

	# Check for input (Standing Still + Action)
	if player.velocity.length() < 0.1 and Input.is_action_just_pressed("interact"):
		if mutation_manager.has_echolocation and can_use_echolocation:
			perform_sonar_ping()

func perform_sonar_ping():
	# Visual effect for sonar
	sonar_visuals.activate_ping(SONAR_RADIUS)

	# Detect nearby objects through walls
	var bodies = $SonarDetectionArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("interactable") or body.is_in_group("infected"):
			body.highlight_visual(3.0) # Highlight for 3 seconds

	can_use_echolocation = false
	current_cooldown = COOLDOWN

	# Mutation cost
	mutation_manager.mutation_level += MUTATION_COST
	mutation_manager.emit_signal("mutation_changed", mutation_manager.mutation_level)
