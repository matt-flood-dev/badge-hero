extends CharacterBody2D

# --- SIGNALS ---
signal health_changed(current_health: int)
signal died


# --- CONFIGURATION & EXPORTS ---
@export var max_health: int = 3


# --- DATA & REFERENCES ---
var current_health: int = max_health
var spawn_position: Vector2
var is_invincible: bool = false
var knockback_from: Vector2 = Vector2.ZERO
var pending_spawn_after_hurt: bool = false

@onready var state_machine: StateMachine = $StateMachine
@onready var hearts_container: HBoxContainer = get_node("/root/World/HUD/MarginContainer/HeartsContainer")


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	spawn_position = global_position
	current_health = max_health
	# Hearts may not be ready on the same frame, so update the HUD after the scene settles.
	call_deferred("_update_health_ui")
	health_changed.emit(current_health)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func _physics_process(_delta: float) -> void:
	# Movement logic lives in the state machine; this node only applies the final velocity.
	move_and_slide()


# --- PUBLIC METHODS ---
func take_damage(amount: int, from_global_position: Vector2 = Vector2.ZERO) -> void:
	if current_health <= 0 or is_invincible:
		return

	current_health = clampi(current_health - amount, 0, max_health)
	health_changed.emit(current_health)
	_update_health_ui()

	if current_health <= 0:
		pending_spawn_after_hurt = false
		died.emit()
		GameManager.handle_player_death(self)
		return

	# Knockback direction points away from whatever hurt the player.
	if from_global_position != Vector2.ZERO:
		knockback_from = global_position - from_global_position
	else:
		knockback_from = Vector2.ZERO

	state_machine.transition_to("hurt")


# Kill floor damage uses the same hurt flow, but respawns after the animation instead of immediately.
func apply_hazard_fall(from_global_position: Vector2) -> void:
	if current_health <= 0 or is_invincible:
		return

	pending_spawn_after_hurt = true
	take_damage(1, from_global_position)


func return_to_spawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	pending_spawn_after_hurt = false


# --- PRIVATE METHODS ---
func _update_health_ui() -> void:
	if not hearts_container:
		return

	var heart_nodes = hearts_container.get_children()
	for i in range(heart_nodes.size()):
		if i < current_health:
			heart_nodes[i].set_filled(true)
		else:
			heart_nodes[i].set_filled(false)
