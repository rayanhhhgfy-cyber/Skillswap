extends Control

@onready var mutation_bar = get_node_or_null("VBoxContainer/MutationBar")
@onready var subtitle_label = get_node_or_null("CenterContainer/SubtitleLabel")
@onready var mobile_controls = get_node_or_null("MobileControls")

func _ready():
	var mutation_manager = get_node_or_null("../../MutationManager")
	if mutation_manager:
		mutation_manager.connect("mutation_changed", _on_mutation_changed)

	if mobile_controls:
		if OS.get_name() in ["Android", "iOS"]:
			mobile_controls.show()
		else:
			mobile_controls.hide()

func _on_mutation_changed(level):
	if mutation_bar:
		mutation_bar.value = level

func show_subtitle(text, duration):
	if subtitle_label:
		subtitle_label.text = text
		subtitle_label.show()
		await get_tree().create_timer(duration).timeout
		subtitle_label.hide()
