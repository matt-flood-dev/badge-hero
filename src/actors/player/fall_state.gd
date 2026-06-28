class_name FallState
extends PlayerState

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

const SPEED = 200.0
const ACCELERATION = 1200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# --- LIFECYCLE CALLBACKS ---


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func physics_update(delta: float) -> void:
	# Continuously accumulate down-ward gravitational acceleration velocities
	player.velocity.y += gravity * delta
	
	# Handle mid-air tracking control adjustments
	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = move_toward(player.velocity.x, direction * SPEED, ACCELERATION * delta)
	
	# Orient texture facing direction mid-flight
	if direction != 0:
		sprite.flip_h = (direction < 0)

	# Transition Boundary: Solid contact boundary is successfully resolved under player collision shape
	if player.is_on_floor():
		# Determine subsequent state assignment based purely on current user intent inputs
		if direction == 0:
			state_machine.transition_to("idle")
		else:
			state_machine.transition_to("move")


# --- PUBLIC METHODS ---
func enter() -> void:
	sprite.play("fall")


func exit() -> void:
	pass


# --- PRIVATE METHODS ---
