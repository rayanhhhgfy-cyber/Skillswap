extends Node3D

@onready var generator = null # Placeholder if LevelGenerator script is not on a child node
@onready var dialogue_system = get_node("Systems/DialogueSystem")

func _ready():
	print("Act 1: Descent Initialized.")
	setup_morgue_environment()
	# Cinematic Intro (Cutscene 01)
	start_cutscene_01()

func setup_morgue_environment():
	# Procedurally detail the hand-crafted morgue with Syrian markers
	# Add Arabic signage for "Morgue" (مشرحة) and "Biohazard" (خطر بيولوجي)
	print("Adding Syrian signage and environment details...")

func start_cutscene_01():
	print("Starting Intro Cutscene...")
	if dialogue_system:
		dialogue_system.play_dialogue("intro_breathing")
		await get_tree().create_timer(3.0).timeout
		dialogue_system.play_dialogue("intro_mara_01")
		await get_tree().create_timer(2.0).timeout
		dialogue_system.play_dialogue("intro_mara_02")
	else:
		print("Warning: DialogueSystem not found.")

func _on_first_contact_echo():
	dialogue_system.play_dialogue("echo_first_contact")

func _on_first_ability_unlocked():
	# Triggered when mutation reaches 30% or during scripted Act 2 event
	dialogue_system.play_dialogue("mahmoud_intro") # Transition to first boss encounter
