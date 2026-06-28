class_name IdleState
extends PlayerState

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"


# --- LIFECYCLE CALLBACKS ---


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func physics_update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0.0, 1500.0 * delta)

	# Leave idle when the player walks off a ledge, jumps, or starts moving.
	if not player.is_on_floor():
		state_machine.transition_to("fall")
		return

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("jump")
		return

	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_machine.transition_to("move")


# --- PUBLIC METHODS ---
func enter() -> void:
	sprite.play("idle")
	player.velocity.x = 0.0


func exit() -> void:
	pass


# --- PRIVATE METHODS ---
