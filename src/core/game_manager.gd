extends Node

# --- SIGNALS ---
# Autoload singleton that tracks level progress and broadcasts changes to the HUD and menus.
signal gem_collected(current_count: int, total_required: int)
signal key_obtained()
signal enemy_defeated()
signal badge_collected(current_count: int, total_required: int)
signal game_over()
signal victory()
signal pause_opened()
signal pause_closed()
signal level_reset()


# --- CONFIGURATION & EXPORTS ---
const TOTAL_GEMS_IN_LEVEL: int = 5


# --- DATA & REFERENCES ---
var gems_collected: int = 0
var has_key: bool = false
var total_badges_in_level: int = 0
var badges_collected: int = 0
var is_game_over: bool = false
var is_victory: bool = false
var is_paused: bool = false


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Keep receiving input while paused so Escape can quit from any screen.
	process_mode = Node.PROCESS_MODE_ALWAYS
	reset_game_state()


# --- INPUT HANDLING ---
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close", false, true):
		quit_game()
		get_viewport().set_input_as_handled()


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---
# Clears progress flags whenever the level starts fresh or restarts.
func reset_game_state() -> void:
	gems_collected = 0
	has_key = false
	total_badges_in_level = 0
	badges_collected = 0
	is_game_over = false
	is_victory = false
	is_paused = false
	level_reset.emit()


func collect_gem() -> void:
	gems_collected += 1
	gem_collected.emit(gems_collected, TOTAL_GEMS_IN_LEVEL)
	print("Gem acquired. Current progress: ", gems_collected, "/", TOTAL_GEMS_IN_LEVEL)


func obtain_key() -> void:
	has_key = true
	key_obtained.emit()
	print("Objective Key secured. Level progression unlocked.")


# Each badge scene calls this in _ready so the win condition scales with however many we place in the level.
func register_level_badge() -> void:
	total_badges_in_level += 1
	badge_collected.emit(badges_collected, total_badges_in_level)


func notify_enemy_defeated() -> void:
	enemy_defeated.emit()
	print("Enemy defeated! The level badge has materialised.")


func collect_badge() -> void:
	if is_victory:
		return

	badges_collected += 1
	badge_collected.emit(badges_collected, total_badges_in_level)
	print("Victory badge collected: ", badges_collected, "/", total_badges_in_level)

	# Victory only triggers once every badge in the level has been picked up.
	if badges_collected >= total_badges_in_level:
		handle_level_victory()


func toggle_pause() -> void:
	# End screens already own the pause state, so ignore manual pause input there.
	if is_game_over or is_victory:
		return

	if is_paused:
		unpause_game()
	else:
		pause_game()


func pause_game() -> void:
	if is_game_over or is_victory or is_paused:
		return

	is_paused = true
	get_tree().paused = true
	pause_opened.emit()


func unpause_game() -> void:
	if not is_paused:
		return

	is_paused = false
	get_tree().paused = false
	pause_closed.emit()


func toggle_mouse_visibility() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func handle_player_death(_player: Node2D = null) -> void:
	if is_game_over or is_victory:
		return

	# Close the pause menu first so game over does not stack on top of it.
	if is_paused:
		unpause_game()

	is_game_over = true
	print("Player health depleted. Game over.")
	get_tree().paused = true
	game_over.emit()


func handle_level_victory() -> void:
	if is_victory or is_game_over:
		return

	if is_paused:
		unpause_game()

	is_victory = true
	print("All badges collected. Victory!")
	get_tree().paused = true
	victory.emit()


func restart_game() -> void:
	reset_game_state()
	get_tree().paused = false
	get_tree().reload_current_scene()


func quit_game() -> void:
	get_tree().quit()


# --- PRIVATE METHODS ---
