extends CharacterBody2D

# --- SIGNALS ---
signal health_changed(current_health: int)
signal died


# --- CONFIGURATION & EXPORTS ---
@export var max_health: int = 3


# --- DATA & REFERENCES ---
var current_health: int = max_health
var spawn_position: Vector2

@onready var hearts_container: HBoxContainer = get_node("/root/World/HUD/MarginContainer/HeartsContainer")


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	spawn_position = global_position
	current_health = max_health
	call_deferred("_update_health_ui")
	health_changed.emit(current_health)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---
func _physics_process(_delta: float) -> void:
	move_and_slide()


# --- PUBLIC METHODS ---
func take_damage(amount: int) -> void:
	if current_health <= 0:
		return

	current_health = clampi(current_health - amount, 0, max_health)
	health_changed.emit(current_health)
	_update_health_ui()

	if current_health <= 0:
		died.emit()
		GameManager.handle_player_death(self)


# Moves the player back to their spawn point without altering health.
func return_to_spawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO


# Restores health and returns the player to their spawn point after a full death.
func respawn_after_death() -> void:
	current_health = max_health
	health_changed.emit(current_health)
	_update_health_ui()
	return_to_spawn()


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
