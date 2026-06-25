extends CharacterBody2D

# Movement Constants
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1200.0
const FRICTION = 1500.0

# Get gravity from project settings so it matches the engine's physics global environment
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Apply Gravity if character is airborne
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")

	# Handle Velocity Calculation using Linear Interpolation
	if direction != 0:
		# Smoothly accelerate toward the target speed
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		# Smoothly decelerate to a complete stop when no keys are pressed
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	# Execute kinematic physics movement and resolve collisions automatically
	move_and_slide()
