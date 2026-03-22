extends CharacterBody3D

enum Phase { PROFESSOR, ARCHITECT, FINAL_FORM }
var current_phase = Phase.PROFESSOR

@export var health = 300.0
@export var mutation_speed = 1.0

@onready var mutation_manager = get_node_or_null("../MutationManager")
@onready var dialogue_system = get_node_or_null("../Systems/DialogueSystem")

func _ready():
	add_to_group("boss")
	# Initial appearance
	setup_phase_one()

func take_damage(amount):
	health -= amount
	if health <= 200 and current_phase == Phase.PROFESSOR:
		transition_to_phase_two()
	elif health <= 100 and current_phase == Phase.ARCHITECT:
		transition_to_phase_three()
	elif health <= 0:
		pass

func transition_to_phase_two():
	current_phase = Phase.ARCHITECT
	if dialogue_system: dialogue_system.play_dialogue("mahmoud_phase_two")
	setup_phase_two()

func transition_to_phase_three():
	current_phase = Phase.FINAL_FORM
	if dialogue_system: dialogue_system.play_dialogue("mahmoud_phase_three")
	setup_phase_three()

func setup_phase_one():
	print("Mahmoud: Phase 1 - The Professor.")
	health = 1000.0
	# Strategic movement: Stay at distance and use environmental traps
	velocity = Vector3.ZERO

func setup_phase_two():
	print("Mahmoud: Phase 2 - The Architect.")
	# Wall-crawling behavior: Offset vertical position to simulate being on the wall
	position.y += 4.0
	rotation.z = PI / 2.0 # 90-degree tilt
	# Pheromone spike emission logic would go here

func setup_phase_three():
	print("Mahmoud: Phase 3 - Final Form.")
	# Transform into a stationary but massive biological engine
	scale *= 1.5
	position.y = 1.5 # Reset to floor
	rotation.z = 0

func handle_suppressor_injection():
	if health <= 20 and current_phase == Phase.FINAL_FORM:
		var ending_manager = get_node_or_null("../Systems/EndingManager")
		if ending_manager:
			ending_manager.trigger_boss_defeat()
