extends CanvasLayer

# --- DATA & REFERENCES ---
@onready var overlay: Control = $Overlay


func _ready() -> void:
	visible = false
	GameManager.victory.connect(_on_victory)


func _on_victory() -> void:
	visible = true


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_pressed() and not event.is_echo():
		GameManager.restart_game()
