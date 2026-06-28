extends Node

# --- SIGNALS ---
signal gem_collected(current_count: int, total_required: int)
signal key_obtained()
signal enemy_defeated()
signal game_over()
signal level_reset()


# --- CONFIGURATION & EXPORTS ---
const TOTAL_GEMS_IN_LEVEL: int = 5


# --- DATA & REFERENCES ---
var gems_collected: int = 0
var has_key: bool = false
var is_game_over: bool = false


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	reset_game_state()


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---
func reset_game_state() -> void:
	gems_collected = 0
	has_key = false
	is_game_over = false
	level_reset.emit()


func collect_gem() -> void:
	gems_collected += 1
	gem_collected.emit(gems_collected, TOTAL_GEMS_IN_LEVEL)
	print("Gem acquired. Current progress: ", gems_collected, "/", TOTAL_GEMS_IN_LEVEL)


func obtain_key() -> void:
	has_key = true
	key_obtained.emit()
	print("Objective Key secured. Level progression unlocked.")


func notify_enemy_defeated() -> void:
	enemy_defeated.emit()
	print("Enemy defeated! The level badge has materialised.")


# Pauses the level and shows the game over screen.
func handle_player_death(_player: Node2D = null) -> void:
	if is_game_over:
		return

	is_game_over = true
	print("Player health depleted. Game over.")
	get_tree().paused = true
	game_over.emit()


# Unpauses and reloads the current level from scratch.
func restart_game() -> void:
	reset_game_state()
	get_tree().paused = false
	get_tree().reload_current_scene()
