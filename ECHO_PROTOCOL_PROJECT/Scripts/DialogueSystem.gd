extends Node

var dialogue_data = {}

func _ready():
	print("Dialogue System Ready.")
	load_dialogue("res://Dialogue/DialogueData.json")

func load_dialogue(path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		dialogue_data = JSON.parse_string(content)
		print("Dialogue Data Loaded.")
	else:
		print("Error: DialogueData.json not found at ", path)

func play_dialogue(id):
	if id in dialogue_data:
		var line = dialogue_data[id]
		print("Playing Dialogue: ", id, " - ", line["text"])

		var hud = get_node("/root/Game/UI/HUD")
		if hud:
			hud.show_subtitle(line["text"], line["duration"])

		# Skip audio if not available to prevent crashes
		var voice_path = "res://Audio/Voice/" + id + ".ogg"
		if FileAccess.file_exists(voice_path):
			var audio_player = get_node("../AudioManager/VoicePlayer")
			if audio_player:
				audio_player.stream = load(voice_path)
				audio_player.play()
	else:
		print("Warning: Dialogue ID '", id, "' not found.")

func play_voice_log(log_id):
	play_dialogue(log_id)
