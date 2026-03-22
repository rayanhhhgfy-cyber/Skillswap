extends Control

func _on_ResumeButton_pressed():
	var player = get_node_or_null("/root/Game/Player")
	if player:
		player.toggle_pause()

func _on_SettingsButton_pressed():
	var settings_menu = get_node_or_null("../SettingsScreen")
	if settings_menu:
		settings_menu.show()

func _on_QuitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
