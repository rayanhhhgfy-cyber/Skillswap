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
	var fov = $SettingsScreen/VBoxContainer/FOVSlider/Slider.value
	var sens = $SettingsScreen/VBoxContainer/Sensitivity/Slider.value
	var vol = $SettingsScreen/VBoxContainer/AudioVolume/Slider.value

	ProjectSettings.set_setting("rendering/quality/visual_quality", quality)
	# Apply audio and gameplay settings
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(vol))

	print("Settings Applied: Quality ", quality, " FOV: ", fov, " Sens: ", sens)

func linear_to_db(p_vol):
	if p_vol <= 0: return -80.0
	return log(p_vol) * 8.6858896380650365530225783783321

func _on_ExitButton_pressed():
	get_tree().quit()
