extends Node

var dialogue_data = {}

func _ready():
	load_dialogue("res://Dialogue/DialogueData.json")

func load_dialogue(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	dialogue_data = JSON.parse_string(content)

func play_dialogue(id):
	var line = dialogue_data[id]
	var hud = get_node("/root/Game/UI/HUD")
	hud.show_subtitle(line["text"], line["duration"])

	# Play audio if available
	var audio_player = get_node("/root/Game/Systems/AudioManager/VoicePlayer")
	audio_player.stream = load("res://Audio/Voice/" + id + ".ogg")
	audio_player.play()

func play_voice_log(log_id):
	# Specific logic for lore logs
	play_dialogue("log_" + log_id)
