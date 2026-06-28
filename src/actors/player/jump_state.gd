class_name JumpState
extends PlayerState

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var sprite: Sprite2D = $"../../Sprite2D"

# Jump physics threshold settings
const JUMP_VELOCITY = -400.0
const SPEED = 200.0
const ACCELERATION = 1200.0

# Fetch the global environmental default gravity scaling from the project registry
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# --- LIFECYCLE CALLBACKS ---


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func physics_update(delta: float) -> void:
	# Accumulate downward gravity acceleration onto the vertical velocity vector
	player.velocity.y += gravity * delta
	
	# Process mid-air horizontal steering vector logic overrides
	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = move_toward(player.velocity.x, direction * SPEED, ACCELERATION * delta)
	
	# Orient texture facing direction mid-flight
	if direction != 0:
		sprite.flip_h = (direction < 0)

	# Transition Boundary: Upward upward velocity vector momentum depletes completely
	if player.velocity.y >= 0:
		state_machine.transition_to("fall")


# --- PUBLIC METHODS ---
func enter() -> void:
	# Instantly switch rendering frame to jump graphics pose (Frame index 3)
	sprite.frame = 3
	# Apply an immediate negative vertical impulse force to initiate flight tracking
	player.velocity.y = JUMP_VELOCITY


func exit() -> void:
	pass


# --- PRIVATE METHODS ---
