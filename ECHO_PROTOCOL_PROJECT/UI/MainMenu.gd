extends Control

@onready var start_button = $CenterContainer/VBoxContainer/StartButton
@onready var credits_button = $CenterContainer/VBoxContainer/CreditsButton
@onready var settings_button = $CenterContainer/VBoxContainer/SettingsButton
@onready var credits_screen = $CreditsScreen
@onready var settings_screen = $SettingsScreen

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/Act1_Descent.tscn")

func _on_CreditsButton_pressed():
	credits_screen.show()
	$CreditsScreen/CreditsLabel.text = "ECHO PROTOCOL\n\nDeveloped by\nRayyan the Dev\n\nA Survival Horror Experience"

func _on_SettingsButton_pressed():
	settings_screen.show()

func _on_ExitButton_pressed():
	get_tree().quit()
