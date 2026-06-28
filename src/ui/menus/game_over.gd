extends CanvasLayer

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var overlay: Control = $Overlay


# --- LIFECYCLE CALLBACKS ---
# process_mode is ALWAYS on this scene so it can receive input while the tree is paused.
func _ready() -> void:
	visible = false
	GameManager.game_over.connect(_on_game_over)


# --- INPUT HANDLING ---
func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	# Any key restarts the level for now.
	if event.is_pressed() and not event.is_echo():
		GameManager.restart_game()


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _on_game_over() -> void:
	visible = true
