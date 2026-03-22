extends Control

@onready var mutation_bar = get_node_or_null("VBoxContainer/MutationBar")
@onready var subtitle_label = get_node_or_null("SubtitleContainer/SubtitleLabel")
@onready var vignette = get_node_or_null("Vignette")
@onready var grain_overlay = get_node_or_null("Grain") # Corrected from 'GrainOverlay'

func _ready():
	var mutation_manager = get_node_or_null("/root/Game/MutationManager")
	if mutation_manager:
		mutation_manager.connect("mutation_changed", _on_mutation_changed)

	setup_diegetic_vignette()

func setup_diegetic_vignette():
	if vignette:
		vignette.color = Color(0, 0, 0, 0.4)

func _on_mutation_changed(level):
	if mutation_bar:
		mutation_bar.value = level

	if vignette:
		vignette.color.a = clamp(level / 120.0, 0.4, 0.9)

	if grain_overlay:
		grain_overlay.modulate.a = clamp((level - 50.0) / 100.0, 0.0, 0.5)

func show_subtitle(text, duration):
	if subtitle_label:
		subtitle_label.text = text
		subtitle_label.show()
		if "ECHO" in text:
			subtitle_label.visible_ratio = 0.0
			var tween = create_tween()
			tween.tween_property(subtitle_label, "visible_ratio", 1.0, 0.5)
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
