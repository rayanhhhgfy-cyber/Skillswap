extends StaticBody3D

@export var interact_id = "mirror_check"
@onready var mutation_manager = get_node_or_null("../../MutationManager")
@onready var dialogue_system = get_node_or_null("../../Systems/DialogueSystem")

func interact():
	if mutation_manager:
		var mutation_level = mutation_manager.mutation_level

		# Narrative Reaction to Reflection
		if mutation_level < 25.0:
			if dialogue_system: dialogue_system.play_dialogue("mara_mirror_early")
		elif mutation_level < 50.0:
			if dialogue_system: dialogue_system.play_dialogue("mara_mirror_mid")
		elif mutation_level < 75.0:
			if dialogue_system: dialogue_system.play_dialogue("mara_mirror_high")
		else:
			# Mutation above 75% - Mara avoids mirrors
			if dialogue_system: dialogue_system.play_dialogue("mara_mirror_extreme")
			trigger_avoid_mirror_effect()

func trigger_avoid_mirror_effect():
	# Procedural camera shake and turn away
	var player_cam = get_node_or_null("/root/Game/Player/Camera3D")
	if player_cam:
		var tween = create_tween()
		tween.tween_property(player_cam, "rotation:y", deg_to_rad(45), 0.5).as_relative()
		tween.tween_property(player_cam, "rotation:x", deg_to_rad(-15), 0.5).as_relative()
		print("Mara refuses to look at the reflection.")

func highlight_visual(duration):
	# Echolocation highlight for mirrors
	print("Mirror highlighted by sonar.")
