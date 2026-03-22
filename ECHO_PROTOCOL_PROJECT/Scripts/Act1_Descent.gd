extends Node3D

@onready var generator = null # Placeholder if LevelGenerator script is not on a child node
@onready var dialogue_system = get_node("Systems/DialogueSystem")

func _ready():
	print("Act 1: Descent Initialized.")
	# Cinematic Intro (Cutscene 01)
	start_cutscene_01()

	# If there was a generator node, we would call it here
	# generator.generate_level(1)

func start_cutscene_01():
	print("Starting Intro Cutscene...")
	if dialogue_system:
		dialogue_system.play_dialogue("intro_breathing")
		await get_tree().create_timer(3.0).timeout
		dialogue_system.play_dialogue("intro_mara_01")
	else:
		print("Warning: DialogueSystem not found.")

func _on_first_contact_echo():
	dialogue_system.play_dialogue("echo_first_contact")
