extends Node

# --- SIGNALS ---
signal gem_collected(current_count: int, total_required: int)
signal key_obtained()
signal level_reset()


# --- CONFIGURATION & EXPORTS ---
const TOTAL_GEMS_IN_LEVEL: int = 5


# --- DATA & REFERENCES ---
var gems_collected: int = 0
var has_key: bool = false


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	reset_game_state()


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---
func reset_game_state() -> void:
	gems_collected = 0
	has_key = false
	level_reset.emit()


func collect_gem() -> void:
	gems_collected += 1
	gem_collected.emit(gems_collected, TOTAL_GEMS_IN_LEVEL)
	print("Gem acquired. Current progress: ", gems_collected, "/", TOTAL_GEMS_IN_LEVEL)


func obtain_key() -> void:
	has_key = true
	key_obtained.emit()
	print("Objective Key secured. Level progression unlocked.")


# Called when the player's health reaches zero. Resets level progress and respawns the player.
func handle_player_death(player: Node2D) -> void:
	print("Player health depleted. Resetting level progress and respawning...")
	reset_game_state()

	if player.has_method("respawn_after_death"):
		player.respawn_after_death()
