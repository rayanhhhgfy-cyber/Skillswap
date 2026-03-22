extends Node3D

@export var ROOM_SIZE = 10.0
@export var ROOM_COUNT = 10

func generate_level(act_id):
	print("Generating Level for Act ", act_id)
	seed(12345 + act_id)

	var current_pos = Vector3.ZERO

	for i in range(ROOM_COUNT):
		spawn_room(current_pos)
		# Simple procedural path: randomly move forward, left, or right
		var dir = randi() % 3
		match dir:
			0: current_pos.z -= ROOM_SIZE # Forward
			1: current_pos.x -= ROOM_SIZE # Left
			2: current_pos.x += ROOM_SIZE # Right

func spawn_room(pos):
	var room = MeshInstance3D.new()
	var mesh = BoxMesh.new()
	mesh.size = Vector3(ROOM_SIZE - 1.0, 0.1, ROOM_SIZE - 1.0)
	room.mesh = mesh
	room.position = pos

	# Add a light to each room
	var light = OmniLight3D.new()
	light.light_energy = 0.5
	light.omni_range = ROOM_SIZE
	room.add_child(light)

	add_child(room)
	print("Spawned Room at: ", pos)
