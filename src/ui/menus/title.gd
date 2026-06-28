extends Control

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var start_button: Button = $MenuContainer/StartButton
@onready var controls_button: Button = $MenuContainer/ControlsButton

const WORLD_SCENE_PATH: String = "res://src/levels/world.tscn"
const CONTROLS_SCENE_PATH: String = "res://src/ui/menus/controls.tscn"


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Menus use the mouse; gameplay scenes will hide it again on start.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_button.pressed.connect(_on_start_pressed)
	controls_button.pressed.connect(_on_controls_pressed)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _on_start_pressed() -> void:
	GameManager.reset_game_state()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().change_scene_to_file(WORLD_SCENE_PATH)


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file(CONTROLS_SCENE_PATH)
