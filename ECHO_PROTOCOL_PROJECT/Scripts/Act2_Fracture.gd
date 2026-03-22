extends Node3D

@onready var dialogue_system = get_node("Systems/DialogueSystem")

func _ready():
	print("Act 2: Fracture Initialized.")
	setup_fracture_environment()

func setup_fracture_environment():
	# Procedurally detail Act 2 with more overgrowth and damage
	print("Adding X-7 overgrowth and containment breach details...")

func _on_warden_encounter():
	# Faisal Dern encounter logic
	print("The Warden approaches...")
	if dialogue_system: dialogue_system.play_dialogue("yusuf_intro")
