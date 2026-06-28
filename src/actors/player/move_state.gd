class_name MoveState
extends PlayerState

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

const SPEED = 200.0
const ACCELERATION = 1200.0


# --- LIFECYCLE CALLBACKS ---


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func physics_update(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = move_toward(player.velocity.x, direction * SPEED, ACCELERATION * delta)

	if direction != 0:
		sprite.flip_h = (direction < 0)

	if not player.is_on_floor():
		state_machine.transition_to("fall")
		return

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("jump")
		return

	if direction == 0 and is_equal_approx(player.velocity.x, 0.0):
		state_machine.transition_to("idle")


# --- PUBLIC METHODS ---
func enter() -> void:
	sprite.play("move")


func exit() -> void:
	pass


# --- PRIVATE METHODS ---
