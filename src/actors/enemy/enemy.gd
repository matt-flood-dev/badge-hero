extends CharacterBody2D

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---
@export var patrol_speed: float = 80.0
@export var damage_amount: int = 1
@export var damage_cooldown: float = 1.0
@export var stomp_bounce_velocity: float = -250.0
@export var patrol_direction: int = 1


# --- DATA & REFERENCES ---
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $HurtBox
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var floor_ray: RayCast2D = $RayCast2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead: bool = false
var can_damage_player: bool = true
var is_turn_locked: bool = false

const FLOOR_RAY_FORWARD: float = 26.0
const FLOOR_RAY_DROP: float = 16.0


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)
	sprite.flip_h = patrol_direction < 0
	_configure_floor_ray()
	sprite.play("idle")


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	velocity.x = patrol_direction * patrol_speed
	_configure_floor_ray()
	move_and_slide()
	_evaluate_patrol_turn()
	_check_player_overlaps()
	_update_animation()


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
# Place the ledge ray at the leading foot so we detect open air before walking off a platform.
func _configure_floor_ray() -> void:
	var foot_y: float = collision_shape.position.y + (collision_shape.shape as RectangleShape2D).size.y / 2.0
	floor_ray.enabled = true
	floor_ray.position = Vector2(FLOOR_RAY_FORWARD * patrol_direction, foot_y)
	floor_ray.target_position = Vector2(0.0, FLOOR_RAY_DROP)
	floor_ray.force_raycast_update()


func _evaluate_patrol_turn() -> void:
	if is_turn_locked:
		return

	if _is_wall_ahead():
		_turn_around()
		return

	if _is_ledge_ahead():
		_turn_around()


# Only treat a collision as a blocking wall if it faces against our current patrol direction.
func _is_wall_ahead() -> bool:
	if not is_on_wall():
		return false

	return get_wall_normal().x * patrol_direction < 0.0


func _is_ledge_ahead() -> bool:
	if not is_on_floor():
		return false

	floor_ray.force_raycast_update()
	return not floor_ray.is_colliding()


func _turn_around() -> void:
	if is_turn_locked:
		return

	is_turn_locked = true
	patrol_direction *= -1
	sprite.flip_h = patrol_direction < 0
	_configure_floor_ray()
	# Brief lock stops the enemy flipping every frame while still touching a wall or ledge.
	get_tree().create_timer(0.2).timeout.connect(_release_turn_lock)


func _release_turn_lock() -> void:
	is_turn_locked = false


func _update_animation() -> void:
	if is_on_floor() and abs(velocity.x) > 0.0:
		if sprite.animation != "move":
			sprite.play("move")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")


func _on_hurtbox_body_entered(body: Node2D) -> void:
	_handle_player_overlap(body)


# body_entered only fires once, so we re-check overlaps every frame for stomps after a side hit.
func _check_player_overlaps() -> void:
	for body in hurtbox.get_overlapping_bodies():
		_handle_player_overlap(body)


func _handle_player_overlap(body: Node2D) -> void:
	if is_dead:
		return

	if not (body.name == "Player" or body.is_in_group("player")):
		return

	if _is_player_stomping(body):
		_defeat_enemy(body)
		return

	_apply_contact_damage(body)


# Mario-style stomp: feet near the top of the enemy while moving downward or landing.
func _is_player_stomping(body: Node2D) -> bool:
	if body is not CharacterBody2D:
		return false

	var player_shape: CollisionShape2D = body.get_node_or_null("CollisionShape2D")
	if player_shape == null or player_shape.shape is not RectangleShape2D:
		return false

	var player_rect: RectangleShape2D = player_shape.shape as RectangleShape2D
	var player_feet_y: float = body.global_position.y + player_shape.position.y + player_rect.size.y / 2.0
	var enemy_head_y: float = global_position.y + collision_shape.position.y - (collision_shape.shape as RectangleShape2D).size.y / 2.0

	if player_feet_y > enemy_head_y + 14.0:
		return false

	return body.velocity.y >= 0.0


func _apply_contact_damage(player: Node2D) -> void:
	if not can_damage_player:
		return

	if player.get("is_invincible"):
		return

	if player.has_method("take_damage"):
		player.take_damage(damage_amount, global_position)
		can_damage_player = false
		get_tree().create_timer(damage_cooldown).timeout.connect(_reset_damage_cooldown)


func _reset_damage_cooldown() -> void:
	can_damage_player = true


func _defeat_enemy(player: Node2D) -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	hurtbox.set_deferred("monitoring", false)
	collision_shape.set_deferred("disabled", true)

	if player is CharacterBody2D:
		player.velocity.y = stomp_bounce_velocity

	sprite.sprite_frames.set_animation_loop("death", false)
	sprite.play("death")
	sprite.animation_finished.connect(_on_death_animation_finished, CONNECT_ONE_SHOT)


func _on_death_animation_finished() -> void:
	queue_free()
	GameManager.notify_enemy_defeated.call_deferred()
