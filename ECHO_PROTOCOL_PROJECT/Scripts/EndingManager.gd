extends Node

@onready var mutation_manager = get_node_or_null("../../MutationManager")
@onready var dialogue_system = get_node_or_null("../DialogueSystem")

func trigger_boss_defeat():
	if dialogue_system: dialogue_system.play_dialogue("final_choice_ready")

func complete_game(choice):
	var level = 0.0
	if mutation_manager: level = mutation_manager.mutation_level

	var inventory = get_node_or_null("../../Inventory")
	var logs_found = inventory.get_total_logs() if inventory else 0

	# Determine Ending based on conditions in Project Echo Protocol Document

	# ENDING A - HUMAN (Good)
	# Condition: Mutation below 50%. Yusuf/Priya alive (implied by low mutation/safe play)
	if choice == "inject" and level < 50.0:
		play_ending_a()
		return

	# ENDING B - INHERITANCE (Bad)
	# Condition: Mutation above 85% at end. Mahmoud's data preserved (implied by smash choice)
	if choice == "smash" and level > 85.0:
		play_ending_b()
		return

	# ENDING C - ECHO (True/Secret)
	# Condition: Full trust built with ECHO (implied by log hunting). Mutation 50-84%.
	if choice == "half" and level >= 50.0 and level <= 84.0 and logs_found >= 12: # Threshold for prototype
		play_ending_c()
		return

	# Fallback/Default based on final mutation level
	if level < 60.0:
		play_ending_a()
	else:
		play_ending_b()

func play_ending_a():
	# HUMAN - GOOD ENDING
	print("Ending A: HUMAN. Mara survives and destroys the research.")
	get_tree().change_scene_to_file("res://Scenes/Ending_A.tscn")

func play_ending_b():
	# INHERITANCE - BAD ENDING
	print("Ending B: INHERITANCE. Mara mutates fully and takes the data.")
	get_tree().change_scene_to_file("res://Scenes/Ending_B.tscn")

func play_ending_c():
	# ECHO - TRUE ENDING
	print("Ending C: ECHO. Mara and ECHO collaborate on a voluntary variant.")
	get_tree().change_scene_to_file("res://Scenes/Ending_C.tscn")
