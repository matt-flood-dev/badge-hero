class_name MoveState
extends PlayerState

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

# Kinematic movement configuration boundaries
const SPEED = 200.0
const ACCELERATION = 1200.0


# --- LIFECYCLE CALLBACKS ---


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func physics_update(delta: float) -> void:
	# Pull raw vector inputs from project input map settings (-1, 0, or 1)
	var direction = Input.get_axis("move_left", "move_right")
	
	# Linearly accumulate horizontal velocity toward the mapped direction scalar
	player.velocity.x = move_toward(player.velocity.x, direction * SPEED, ACCELERATION * delta)
	
	# Handle dynamic horizontal texture orientation mapping
	if direction != 0:
		sprite.flip_h = (direction < 0)
	# Transition Boundary: Detect running off a ledge into open space
	if not player.is_on_floor():
		state_machine.transition_to("fall")
		return
		
	# Transition Boundary: Detect mid-stride upward impulse requests
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("jump")
		return
		
	# Transition Boundary: Return to rest if input halts and velocity effectively hits zero
	if direction == 0 and is_equal_approx(player.velocity.x, 0.0):
		state_machine.transition_to("idle")


# --- PUBLIC METHODS ---
func enter() -> void:
	sprite.play("move")


func exit() -> void:
	pass


# --- PRIVATE METHODS ---
