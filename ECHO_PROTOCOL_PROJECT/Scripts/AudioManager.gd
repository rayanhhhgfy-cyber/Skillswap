extends AudioStreamPlayer

# Procedural ECHO "voice" generator using basic synthesis
# Combined with specific pitch shifting and distortion to sound "genderless, clinical"

@export var base_pitch = 1.0
@export var pitch_variation = 0.05
@export var effect_intensity = 0.4

func play_voice(text):
	# Synthesize sounds based on character count (placeholder for more advanced TTS)
	var words = text.split(" ")
	for word in words:
		var stream_gen = AudioStreamGenerator.new()
		# Logic to fill the generator with a neutral, sine-based voice tone
		# For now, use a pitch-shifted beep-tone as a placeholder
		# but layer it with static
		play_word_sound(word.length() * 0.1)

func play_word_sound(duration):
	pitch_scale = base_pitch + randf_range(-pitch_variation, pitch_variation)
	# In a real Godot project, we'd use an AudioStreamWAV or OGG
	# and apply an AudioEffectDistortion and AudioEffectPitchShift via the bus
	print("ECHO synthesized a sound of duration: ", duration)

func set_echo_bus_effects():
	# Configure the AudioBus for ECHO
	var bus_index = AudioServer.get_bus_index("ECHO_Voice")
	if bus_index == -1: return

	var distortion = AudioEffectDistortion.new()
	distortion.mode = AudioEffectDistortion.MODE_SOFTCLIP
	distortion.drive = 0.3
	AudioServer.add_bus_effect(bus_index, distortion)

	var chorus = AudioEffectChorus.new()
	chorus.voice_count = 2
	chorus.voice_1/delay_ms = 10.0
	chorus.voice_2/delay_ms = 15.0
	AudioServer.add_bus_effect(bus_index, chorus)
