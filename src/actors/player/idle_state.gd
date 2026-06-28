class_name IdleState
extends PlayerState

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
# Node path reference back to the player's primary visual texture controller
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"


# --- LIFECYCLE CALLBACKS ---


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func physics_update(delta: float) -> void:
	# Forcefully damp horizontal velocity vectors toward absolute zero over time
	player.velocity.x = move_toward(player.velocity.x, 0.0, 1500.0 * delta)
	
	# Transition Boundary: Detect loss of solid terrain contacts underneath
	if not player.is_on_floor():
		state_machine.transition_to("fall")
		return
		
	# Transition Boundary: Detect jump request inputs
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("jump")
		return
		
	# Transition Boundary: Detect non-zero directional vector inputs
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_machine.transition_to("move")


# --- PUBLIC METHODS ---
func enter() -> void:
	sprite.play("idle")
	# Cease all residual horizontal kinetic energy vectors immediately on entry
	player.velocity.x = 0.0


func exit() -> void:
	pass


# --- PRIVATE METHODS ---

