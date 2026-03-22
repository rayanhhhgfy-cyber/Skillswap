extends CharacterBody3D

enum State { IDLE, PATROL, CHASE, ATTACK, STUNNED, DEAD }
var current_state = State.IDLE

@export var health = 100.0
@export var speed = 2.0
@export var patrol_speed = 1.0
@export var detection_range = 12.0
@export var attack_range = 1.5
@export var attack_damage = 10.0
@export var attack_cooldown = 1.0

var player = null
var current_attack_cooldown = 0.0
var is_frozen = false
var freeze_timer = 0.0
var patrol_points = []
var current_patrol_index = 0

@onready var mesh = $MeshInstance3D

func _ready():
	add_to_group("infected")
	player = get_node_or_null("/root/Game/Player")

func _physics_process(delta):
	if is_frozen:
		update_frozen_state(delta)
		return

	match current_state:
		State.IDLE:
			process_idle(delta)
		State.PATROL:
			process_patrol(delta)
		State.CHASE:
			process_chase(delta)
		State.ATTACK:
			process_attack(delta)
		State.STUNNED:
			process_stunned(delta)

	move_and_slide()

func update_frozen_state(delta):
	freeze_timer -= delta
	if freeze_timer <= 0:
		is_frozen = false
		if mesh: mesh.set_instance_shader_parameter("frozen", false)
		current_state = State.IDLE

func process_idle(_delta):
	if player and global_position.distance_to(player.global_position) < detection_range:
		current_state = State.CHASE
		return
	if randf() < 0.005: current_state = State.PATROL

func process_patrol(_delta):
	if player and global_position.distance_to(player.global_position) < detection_range:
		current_state = State.CHASE
		return
	if patrol_points.is_empty():
		velocity = Vector3.FORWARD.rotated(Vector3.UP, randf() * TAU) * patrol_speed
	else:
		var target = patrol_points[current_patrol_index]
		if global_position.distance_to(target) < 0.5:
			current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
		velocity = (target - global_position).normalized() * patrol_speed

func process_chase(_delta):
	if not player:
		current_state = State.IDLE
		return
	var dist = global_position.distance_to(player.global_position)
	if dist > detection_range * 1.5:
		current_state = State.IDLE
		return
	if dist < attack_range:
		current_state = State.ATTACK
		return
	var dir = (player.global_position - global_position).normalized()
	dir.y = 0
	velocity = dir * speed
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))

func process_attack(delta):
	if not player:
		current_state = State.IDLE
		return
	var dist = global_position.distance_to(player.global_position)
	if dist > attack_range * 1.2:
		current_state = State.CHASE
		return
	velocity = Vector3.ZERO
	attempt_attack(delta)

func process_stunned(delta):
	velocity = velocity.move_toward(Vector3.ZERO, delta * 5.0)
	# Recover after a moment
	if randf() < 0.01:
		current_state = State.CHASE

func take_damage(amount):
	health -= amount
	print("Infected hit! Health remaining: ", health)

	# High damage might stun
	if amount > 30:
		current_state = State.STUNNED

	# Enraged state at low health
	if health < 30 and health > 0:
		speed *= 1.5
		attack_damage *= 1.2
		print("Infected is ENRAGED!")

	if health <= 0:
		current_state = State.DEAD
		die()

func freeze_in_place(duration):
	is_frozen = true
	freeze_timer = duration
	velocity = Vector3.ZERO
	if mesh: mesh.set_instance_shader_parameter("frozen", true)
	print("Infected frozen for ", duration, " seconds.")

func attempt_attack(delta):
	current_attack_cooldown -= delta
	if current_attack_cooldown <= 0:
		if player.has_method("take_damage"):
			player.take_damage(attack_damage)
			current_attack_cooldown = attack_cooldown
			print("Infected attacked player!")

func highlight_visual(_duration):
	# Echolocation highlight
	print("Infected highlighted by sonar.")

func die():
	print("Infected died.")
	queue_free()
