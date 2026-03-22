extends Control

@onready var password_field = $VBoxContainer/PasswordField
@onready var console_content = $VBoxContainer/ConsoleContent
@onready var mutation_slider = $VBoxContainer/ConsoleContent/MutationSlider
@onready var act_selection = $VBoxContainer/ConsoleContent/ActSelection

var is_unlocked = false
const PASSWORD = "rayyan3mk"

func _ready():
	hide() # Console is hidden by default

func _input(event):
	if Input.is_action_just_pressed("toggle_console"):
		if visible:
			hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_PasswordField_text_submitted(new_text):
	if new_text == PASSWORD:
		is_unlocked = true
		password_field.hide()
		console_content.show()
		print("Console Unlocked. Welcome, Rayyan.")
	else:
		print("Incorrect Password.")
		password_field.text = ""

func _on_MutationSlider_value_changed(value):
	if is_unlocked:
		var mutation_manager = get_node("/root/Game/MutationManager")
		mutation_manager.mutation_level = value
		mutation_manager.emit_signal("mutation_changed", value)

func _on_ActSelection_item_selected(index):
	if is_unlocked:
		var act_names = ["Act1_Descent", "Act2_Fracture", "Act3_TheCore"]
		var act_path = "res://Scenes/" + act_names[index] + ".tscn"
		get_tree().change_scene_to_file(act_path)
