class_name HurtState
extends PlayerState

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

const KNOCKBACK_SPEED: float = 180.0
const HURT_DURATION: float = 0.6

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var hurt_timer: float = 0.0


# --- LIFECYCLE CALLBACKS ---


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func physics_update(delta: float) -> void:
	hurt_timer += delta
	player.velocity.y += gravity * delta

	if hurt_timer >= HURT_DURATION:
		player.is_invincible = false
		player.knockback_from = Vector2.ZERO

		# Kill floor sets this flag so we respawn only after the hurt animation finishes.
		if player.pending_spawn_after_hurt:
			player.return_to_spawn()
			state_machine.transition_to("idle")
			return

		if player.is_on_floor():
			state_machine.transition_to("idle")
		else:
			state_machine.transition_to("fall")


# --- PUBLIC METHODS ---
func enter() -> void:
	sprite.play("hurt")
	hurt_timer = 0.0
	player.is_invincible = true

	var knockback: Vector2 = player.knockback_from
	if knockback == Vector2.ZERO:
		# Fallback knockback if no damage source position was provided.
		var horizontal: float = -1.0 if sprite.flip_h else 1.0
		knockback = Vector2(horizontal, -0.35)
	knockback = knockback.normalized()
	player.velocity = knockback * KNOCKBACK_SPEED


func exit() -> void:
	player.knockback_from = Vector2.ZERO


# --- PRIVATE METHODS ---
