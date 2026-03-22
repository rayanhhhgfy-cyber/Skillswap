extends Node

@onready var music_player = $MusicPlayer
@onready var sfx_player = $SFXPlayer
@onready var ambient_player = $AmbientPlayer

var current_tension = 0.0 # 0.0 (Safe) to 1.0 (Boss Fight)

func _process(delta):
	# Gradually adjust music based on player tension
	update_tension_music()

func update_tension_music():
	var volume_safe = 1.0 - current_tension
	var volume_intense = current_tension

	# Cross-fade between safe and intense audio streams
	# Logic to set volume levels for different players
	pass

func play_sfx(id):
	var stream = load("res://Audio/SFX/" + id + ".wav")
	sfx_player.stream = stream
	sfx_player.play()

func trigger_dynamic_horror():
	# Creaking vents, distant screams logic
	if randf() > 0.98:
		play_sfx("vent_move")
