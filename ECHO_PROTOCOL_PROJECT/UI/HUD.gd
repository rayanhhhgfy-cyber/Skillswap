extends Control

@onready var mutation_bar = get_node_or_null("VBoxContainer/MutationBar")
@onready var subtitle_label = get_node_or_null("SubtitleContainer/SubtitleLabel")
@onready var vignette = get_node_or_null("Vignette")
@onready var grain_overlay = get_node_or_null("GrainOverlay")

func _ready():
	var mutation_manager = get_node_or_null("../../MutationManager")
	if mutation_manager:
		mutation_manager.connect("mutation_changed", _on_mutation_changed)

	setup_diegetic_vignette()

func setup_diegetic_vignette():
	# Use a gradient texture for the vignette instead of solid color
	if vignette:
		vignette.color = Color(0, 0, 0, 0.4)
		vignette.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _on_mutation_changed(level):
	if mutation_bar:
		mutation_bar.value = level

	# Reactive UI intensity based on mutation level
	if vignette:
		# Vignette tightens as mutation rises
		vignette.color.a = clamp(level / 120.0, 0.4, 0.9)

	if grain_overlay:
		# Screen grain increases to simulate "biological interference"
		grain_overlay.modulate.a = clamp((level - 50.0) / 100.0, 0.0, 0.5)

func show_subtitle(text, duration):
	if subtitle_label:
		subtitle_label.text = text
		subtitle_label.show()
		# Add character-by-character effect for ECHO
		if "ECHO" in text:
			subtitle_label.visible_ratio = 0.0
			var tween = create_tween()
			tween.tween_property(subtitle_label, "visible_ratio", 1.0, duration * 0.5)
		else:
			subtitle_label.visible_ratio = 1.0

		await get_tree().create_timer(duration).timeout
		if subtitle_label: subtitle_label.hide()

func show_damage_flash():
	if vignette:
		var original_color = vignette.color
		vignette.color = Color(0.8, 0, 0, 0.9)
		var tween = create_tween()
		tween.tween_property(vignette, "color", original_color, 0.5)

func show_interaction_prompt(p_visible: bool):
	var prompt = get_node_or_null("InteractionPrompt")
	if prompt:
		prompt.visible = p_visible
