extends Node3D

@onready var generator = $LevelGenerator
@onready var dialogue_system = get_node("/root/Game/Systems/DialogueSystem")

func _ready():
	# Cinematic Intro (Cutscene 01)
	start_cutscene_01()

	# Generate Sublevel NINE Layout
	generator.generate_level(1) # Act 1 Difficulty/Complexity

func start_cutscene_01():
	# "Wake" Sequence
	dialogue_system.play_dialogue("intro_breathing")
	await get_tree().create_timer(3.0).timeout
	dialogue_system.play_dialogue("intro_mara_01")
	# Movement starts here

func _on_first_contact_echo():
	dialogue_system.play_dialogue("echo_first_contact")
	# Logic for tutorial hints
