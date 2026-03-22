extends CharacterBody3D

enum Phase { PROFESSOR, ARCHITECT, FINAL_FORM }
var current_phase = Phase.PROFESSOR

@export var health = 300.0
@export var mutation_speed = 1.0

@onready var mutation_manager = get_node("/root/Game/MutationManager")
@onready var dialogue_system = get_node("/root/Game/Systems/DialogueSystem")

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
		# Final push/kill mechanic triggered by player interaction
		pass

func transition_to_phase_two():
	current_phase = Phase.ARCHITECT
	dialogue_system.play_dialogue("mahmoud_phase_two")
	# Change appearance/abilities
	setup_phase_two()

func transition_to_phase_three():
	current_phase = Phase.FINAL_FORM
	dialogue_system.play_dialogue("mahmoud_phase_three")
	# Final massive mutation appearance
	setup_phase_three()

func setup_phase_one():
	# Strategic movements, using environment barriers
	pass

func setup_phase_two():
	# Ceiling crawling, projectile bone spurs
	pass

func setup_phase_three():
	# Pheromone spike, massive size, calling other infected
	pass

func handle_suppressor_injection():
	if health <= 20 and current_phase == Phase.FINAL_FORM:
		# Trigger Death Cutscene
		get_node("/root/Game/EndingManager").trigger_boss_defeat()
