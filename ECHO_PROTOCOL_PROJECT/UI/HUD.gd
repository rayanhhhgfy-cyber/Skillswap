extends Control

@onready var mutation_bar = $VBoxContainer/MutationBar
@onready var subtitle_label = $CenterContainer/SubtitleLabel
@onready var mobile_controls = $MobileControls

func _ready():
	# Connect to MutationManager signals
	var mutation_manager = get_node("/root/Game/MutationManager")
	mutation_manager.connect("mutation_changed", _on_mutation_changed)

	# Detect mobile to show/hide virtual controls
	if OS.get_name() in ["Android", "iOS"]:
		mobile_controls.show()
	else:
		mobile_controls.hide()

func _on_mutation_changed(level):
	mutation_bar.value = level

func show_subtitle(text, duration):
	subtitle_label.text = text
	subtitle_label.show()
	await get_tree().create_timer(duration).timeout
	subtitle_label.hide()
