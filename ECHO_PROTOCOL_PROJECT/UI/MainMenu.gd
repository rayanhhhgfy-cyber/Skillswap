extends Control

@onready var start_button = $CenterContainer/VBoxContainer/StartButton
@onready var credits_button = $CenterContainer/VBoxContainer/CreditsButton
@onready var settings_button = $CenterContainer/VBoxContainer/SettingsButton
@onready var credits_screen = $CreditsScreen
@onready var settings_screen = $SettingsScreen

func _ready():
	print("Main Menu Ready.")
	# Display credits for Rayyan
	$CreditsScreen/CreditsLabel.text = "ECHO PROTOCOL\n\nDeveloped by\nRayyan the Dev\n\nLead Designer: Rayyan the Dev\nLead Programmer: Rayyan the Dev\nVisual Effects: Rayyan the Dev\nSound Design: Rayyan the Dev\n\nA Survival Horror Experience"

func _on_StartButton_pressed():
	print("Starting Game...")
	var result = get_tree().change_scene_to_file("res://Scenes/Act1_Descent.tscn")
	if result != OK:
		print("Error: Could not load Act1 scene. Error code: ", result)

func _on_CreditsButton_pressed():
	credits_screen.show()

func _on_SettingsButton_pressed():
	settings_screen.show()

func _on_CloseSettings_pressed():
	settings_screen.hide()
	# Apply settings (Visuals & Mobile Controls)
	var quality = $SettingsScreen/VBoxContainer/VisualQuality/QualityButton.selected
	var use_mobile = $SettingsScreen/VBoxContainer/MobileControls/MobileCheck.button_pressed

	ProjectSettings.set_setting("rendering/quality/visual_quality", quality)
	# Save to a config file for persistence (Implementation detail)
	print("Settings Applied: Quality ", quality, " Mobile Controls: ", use_mobile)

func _on_ExitButton_pressed():
	get_tree().quit()
