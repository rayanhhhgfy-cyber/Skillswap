extends CharacterBody3D

enum State { IDLE, PATROL, CHASE, ATTACK, STUNNED, DEAD }
var current_state = State.IDLE

@export var health = 100.0
@export var speed = 2.0
@export var patrol_speed = 1.0
@export var detection_range = 12.0
@export var attack_range = 1.8 # Slightly increased to avoid "clipping"
@export var attack_damage = 10.0
@export var attack_cooldown = 1.5

var player = null
var current_attack_cooldown = 0.0
var is_frozen = false
var freeze_timer = 0.0
var patrol_points = []
var current_patrol_index = 0

@onready var mesh = get_node_or_null("MeshInstance3D")

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

    if not is_on_floor():
        velocity.y -= 9.8 * delta

    move_and_slide()

func update_frozen_state(delta):
    freeze_timer -= delta
    if freeze_timer <= 0:
        is_frozen = false
        if mesh and mesh.get_surface_override_material(0):
             mesh.get_surface_override_material(0).set_shader_parameter("is_frozen", false)
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
        # Generic patrol: Rotate occasionally
        velocity = transform.basis.z * patrol_speed
        if randf() < 0.01: rotate_y(randf_range(-PI/2, PI/2))
    else:
        var target = patrol_points[current_patrol_index]
        if global_position.distance_to(target) < 1.0:
            current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
        var dir = (target - global_position).normalized()
        velocity = dir * patrol_speed

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

    # Safety check for look_at to avoid degenerate cases
    if abs(dir.x) > 0.001 or abs(dir.z) > 0.001:
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
    if randf() < 0.01:
        current_state = State.CHASE

func take_damage(amount):
    health -= amount
    if amount > 30: current_state = State.STUNNED
    if health <= 0:
        current_state = State.DEAD
        die()

func freeze_in_place(duration):
    is_frozen = true
    freeze_timer = duration
    velocity = Vector3.ZERO
    if mesh and mesh.get_surface_override_material(0):
        mesh.get_surface_override_material(0).set_shader_parameter("is_frozen", true)

func attempt_attack(delta):
    current_attack_cooldown -= delta
    if current_attack_cooldown <= 0:
        if player and player.has_method("take_damage"):
            player.take_damage(attack_damage)
            current_attack_cooldown = attack_cooldown

func highlight_visual(_duration):
    # Highlight logic
    pass

func die():
    queue_free()
