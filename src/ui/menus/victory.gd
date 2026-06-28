extends CanvasLayer

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var overlay: Control = $Overlay


# --- LIFECYCLE CALLBACKS ---
# process_mode is ALWAYS on this scene so it can receive input while the tree is paused.
func _ready() -> void:
	visible = false
	GameManager.victory.connect(_on_victory)


# --- INPUT HANDLING ---
func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_pressed() and not event.is_echo():
		GameManager.restart_game()


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _on_victory() -> void:
	visible = true
