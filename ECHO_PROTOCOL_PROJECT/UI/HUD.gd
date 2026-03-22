extends Control

@onready var mutation_bar = $VBoxContainer/MutationBar
@onready var subtitle_label = $CenterContainer/SubtitleLabel
@onready var ability_icon_container = $HBoxContainer/AbilityIcons
@onready var stress_indicator = $ColorRect/StressVignette

func _ready():
	# Connect to MutationManager signals
	var mutation_manager = get_node("/root/Game/MutationManager")
	mutation_manager.connect("mutation_changed", _on_mutation_changed)
	mutation_manager.connect("ability_unlocked", _on_ability_unlocked)

func _on_mutation_changed(level):
	mutation_bar.value = level

	# Update stress vignette based on mutation level
	var alpha = (level / 100.0) * 0.5
	stress_indicator.modulate.a = alpha

func _on_ability_unlocked(ability_name):
	var icon = TextureRect.new()
	icon.texture = load("res://Assets/Textures/UI/AbilityIcons/" + ability_name + ".png")
	ability_icon_container.add_child(icon)

func show_subtitle(text, duration):
	subtitle_label.text = text
	subtitle_label.show()
	await get_tree().create_timer(duration).timeout
	subtitle_label.hide()
