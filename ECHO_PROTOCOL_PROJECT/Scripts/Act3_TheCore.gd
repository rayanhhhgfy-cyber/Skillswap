extends Node3D

@onready var dialogue_system = get_node("Systems/DialogueSystem")
@onready var boss = get_node("BossMahmoud")

func _ready():
	print("Act 3: The Core Initialized.")
	setup_core_environment()

func setup_core_environment():
	# Impeccably clean laboratory environment as per bible
	print("Setting up the Architect's Core Laboratory...")

func start_final_encounter():
	if dialogue_system: dialogue_system.play_dialogue("mahmoud_intro")
	if boss: boss.show()
