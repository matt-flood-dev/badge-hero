extends CanvasLayer

# --- DATA & REFERENCES ---
@onready var overlay: Control = $Overlay


func _ready() -> void:
	visible = false
	GameManager.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	visible = true


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_pressed() and not event.is_echo():
		GameManager.restart_game()
