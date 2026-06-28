extends CanvasLayer

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var overlay: Control = $Overlay


# --- LIFECYCLE CALLBACKS ---
# process_mode is ALWAYS on this scene so it can receive input while the tree is paused.
func _ready() -> void:
	visible = false
	GameManager.pause_opened.connect(_on_pause_opened)
	GameManager.pause_closed.connect(_on_pause_closed)


# --- INPUT HANDLING ---
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause", false, true):
		GameManager.toggle_pause()
		get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("mouse", false, true):
		if not GameManager.is_paused:
			return

		GameManager.toggle_mouse_visibility()
		get_viewport().set_input_as_handled()


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _on_pause_opened() -> void:
	visible = true


func _on_pause_closed() -> void:
	visible = false
