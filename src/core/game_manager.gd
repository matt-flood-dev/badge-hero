extends Node

# --- SIGNALS ---
signal health_changed(current_health: int)
signal gem_collected(current_count: int, total_required: int)
signal key_obtained()


# --- CONFIGURATION & EXPORTS ---
const MAX_HEALTH: int = 3
const TOTAL_GEMS_IN_LEVEL: int = 5


# --- DATA & REFERENCES ---
var current_health: int = MAX_HEALTH
var gems_collected: int = 0
var has_key: bool = false


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	reset_game_state()


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---
# Restores all global parameters to defaults for resets or respawns
func reset_game_state() -> void:
	current_health = MAX_HEALTH
	gems_collected = 0
	has_key = false


# Modifies player health and emits updates to the user interface
func update_health(amount: int) -> void:
	current_health = clampi(current_health + amount, 0, MAX_HEALTH)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		handle_player_death()


# Increments the gathered gem counter and alerts tracking systems
func collect_gem() -> void:
	gems_collected += 1
	gem_collected.emit(gems_collected, TOTAL_GEMS_IN_LEVEL)
	print("Gem acquired. Current progress: ", gems_collected, "/", TOTAL_GEMS_IN_LEVEL)


# Sets the key security flag to true once objective conditions are met
func obtain_key() -> void:
	has_key = true
	key_obtained.emit()
	print("Objective Key secured. Level progression unlocked.")


# --- PRIVATE METHODS ---
# Evaluates level state updates when the player health reaches zero
func handle_player_death() -> void:
	print("Player health depleted. Triggering respawn sequence...")
	reset_game_state()
