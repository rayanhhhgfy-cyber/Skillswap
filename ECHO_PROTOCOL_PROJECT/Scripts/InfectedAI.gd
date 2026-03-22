extends CharacterBody3D

@export var health = 100.0
@export var speed = 2.0
@export var detection_range = 10.0

var player = null
var is_frozen = false
var freeze_timer = 0.0

@onready var mesh = $MeshInstance3D

func _ready():
	add_to_group("infected")
	player = get_node_or_null("/root/Game/Player")

func _physics_process(delta):
	if is_frozen:
		freeze_timer -= delta
		if freeze_timer <= 0:
			is_frozen = false
			if mesh: mesh.set_instance_shader_parameter("frozen", false)
		return

	if player:
		var dir = (player.global_position - global_position).normalized()
		dir.y = 0
		if global_position.distance_to(player.global_position) < detection_range:
			velocity = dir * speed
			look_at(player.global_position)
			rotation.x = 0
			rotation.z = 0
		else:
			velocity = Vector3.ZERO

	move_and_slide()

func take_damage(amount):
	health -= amount
	print("Infected hit! Health remaining: ", health)
	if health <= 0:
		die()

func freeze_in_place(duration):
	is_frozen = true
	freeze_timer = duration
	velocity = Vector3.ZERO
	if mesh: mesh.set_instance_shader_parameter("frozen", true)
	print("Infected frozen for ", duration, " seconds.")

func highlight_visual(duration):
	# Echolocation highlight
	print("Infected highlighted by sonar.")

func die():
	print("Infected died.")
	queue_free()
