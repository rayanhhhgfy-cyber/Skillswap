extends Node

@onready var mutation_manager = get_node("/root/Game/MutationManager")
@onready var dialogue_system = get_node("/root/Game/Systems/DialogueSystem")

func trigger_boss_defeat():
	# Final Choice Cutscene
	dialogue_system.play_dialogue("final_choice_ready")
	# Logic to present UI for Ending Choice (Inject/Smash/Half)

func complete_game(choice):
	var level = mutation_manager.mutation_level
	var trust = get_node("/root/Game/Systems/EchoTrust").trust_level
	var logs_found = get_node("/root/Game/Systems/Inventory").get_total_logs()

	if choice == "inject" and level < 50:
		play_ending_a()
	elif choice == "smash" and level > 85:
		play_ending_b()
	elif choice == "half" and trust > 80 and logs_found == 42:
		play_ending_c()
	else:
		# Default to standard ending based on mutation level
		if level < 70:
			play_ending_a()
		else:
			play_ending_b()

func play_ending_a():
	# Human ending
	get_tree().change_scene_to_file("res://Scenes/Ending_A.tscn")

func play_ending_b():
	# Inheritance ending
	get_tree().change_scene_to_file("res://Scenes/Ending_B.tscn")

func play_ending_c():
	# ECHO (True) ending
	get_tree().change_scene_to_file("res://Scenes/Ending_C.tscn")
