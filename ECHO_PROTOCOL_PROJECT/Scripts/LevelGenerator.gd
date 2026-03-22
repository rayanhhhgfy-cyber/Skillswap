extends Node3D

@export var SEED = 12345
@export var ROOM_COUNT = 15

func generate_level(act_id):
	# Seed-based generation for Sublevel NINE
	seed(SEED + act_id)

	# Select modular pieces (Corridors, Labs, Medical Bays)
	var room_types = ["corridor", "lab", "medical", "server", "morgue"]

	for i in range(ROOM_COUNT):
		var type = room_types[randi() % room_types.size()]
		# Instantiate room scene and connect with logic
		spawn_room(type, i)

func spawn_room(type, index):
	# Logic to connect modular pieces based on a grid or path
	pass
