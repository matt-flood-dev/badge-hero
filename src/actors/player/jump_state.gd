class_name JumpState
extends PlayerState

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

const JUMP_VELOCITY = -400.0
const SPEED = 200.0
const ACCELERATION = 1200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# --- LIFECYCLE CALLBACKS ---


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func physics_update(delta: float) -> void:
	player.velocity.y += gravity * delta

	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = move_toward(player.velocity.x, direction * SPEED, ACCELERATION * delta)

	if direction != 0:
		sprite.flip_h = (direction < 0)

	# Once upward motion stops, gravity takes over in the fall state.
	if player.velocity.y >= 0:
		state_machine.transition_to("fall")


# --- PUBLIC METHODS ---
func enter() -> void:
	sprite.play("jump")
	player.velocity.y = JUMP_VELOCITY


func exit() -> void:
	pass


# --- PRIVATE METHODS ---
