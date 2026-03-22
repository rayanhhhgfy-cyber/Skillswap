extends Node

@onready var mutation_manager = get_node_or_null("../../MutationManager")
@onready var dialogue_system = get_node_or_null("../DialogueSystem")

func trigger_boss_defeat():
	if dialogue_system: dialogue_system.play_dialogue("final_choice_ready")

func complete_game(choice):
	var level = 0.0
	if mutation_manager: level = mutation_manager.mutation_level

	var inventory = get_node_or_null("../Inventory")
	var logs_found = inventory.get_total_logs() if inventory else 0

	if choice == "inject" and level < 50:
		play_ending_a()
	elif choice == "smash" and level > 85:
		play_ending_b()
	elif choice == "half" and logs_found == 42:
		play_ending_c()
	else:
		if level < 70:
			play_ending_a()
		else:
			play_ending_b()

func play_ending_a():
	get_tree().change_scene_to_file("res://Scenes/Ending_A.tscn")

func play_ending_b():
	get_tree().change_scene_to_file("res://Scenes/Ending_B.tscn")

func play_ending_c():
	get_tree().change_scene_to_file("res://Scenes/Ending_C.tscn")
