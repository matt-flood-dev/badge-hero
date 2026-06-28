class_name HurtState
extends PlayerState

# --- DATA & REFERENCES ---
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

const KNOCKBACK_SPEED: float = 180.0
const HURT_DURATION: float = 0.6

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var hurt_timer: float = 0.0


func enter() -> void:
	sprite.play("hurt")
	hurt_timer = 0.0
	player.is_invincible = true

	var knockback: Vector2 = player.knockback_from
	if knockback == Vector2.ZERO:
		var horizontal: float = -1.0 if sprite.flip_h else 1.0
		knockback = Vector2(horizontal, -0.35)
	knockback = knockback.normalized()
	player.velocity = knockback * KNOCKBACK_SPEED


func physics_update(delta: float) -> void:
	hurt_timer += delta
	player.velocity.y += gravity * delta

	if hurt_timer >= HURT_DURATION:
		player.is_invincible = false
		player.knockback_from = Vector2.ZERO
		if player.is_on_floor():
			state_machine.transition_to("idle")
		else:
			state_machine.transition_to("fall")


func exit() -> void:
	player.knockback_from = Vector2.ZERO
