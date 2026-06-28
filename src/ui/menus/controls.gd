extends Control

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var controls_table: GridContainer = $MarginContainer/CenterContainer/ControlsTable
@onready var back_button: Button = $BackButton

const TITLE_SCENE_PATH: String = "res://src/ui/menus/title.tscn"

const ARROW_KEY_LABELS: Dictionary = {
	KEY_LEFT: "Left Arrow",
	KEY_RIGHT: "Right Arrow",
	KEY_UP: "Up Arrow",
	KEY_DOWN: "Down Arrow",
}

# Display order and labels for each action in the project input map.
const ACTION_ROWS: Array[Dictionary] = [
	{"label": "Move Left", "action": "move_left"},
	{"label": "Move Right", "action": "move_right"},
	{"label": "Jump", "action": "jump"},
	{"label": "Pause", "action": "pause"},
	{"label": "Toggle Mouse", "action": "mouse"},
	{"label": "Quit", "action": "close"},
]


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	back_button.pressed.connect(_on_back_pressed)
	_build_controls_table()


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _build_controls_table() -> void:
	for row in ACTION_ROWS:
		var action_name: String = row["action"]
		var action_label := Label.new()
		action_label.text = row["label"]
		action_label.add_theme_font_size_override("font_size", 16)

		var input_label := Label.new()
		input_label.text = _format_action_events(action_name)
		input_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		input_label.add_theme_font_size_override("font_size", 16)

		controls_table.add_child(action_label)
		controls_table.add_child(input_label)


func _format_action_events(action_name: String) -> String:
	if not InputMap.has_action(action_name):
		return "Unassigned"

	var event_labels: PackedStringArray = []
	for event: InputEvent in InputMap.action_get_events(action_name):
		if event is InputEventKey:
			event_labels.append(_format_key_event(event))

	if event_labels.is_empty():
		return "Unassigned"

	return ", ".join(event_labels)


func _format_key_event(event: InputEventKey) -> String:
	var keycode: Key = event.physical_keycode as Key

	if ARROW_KEY_LABELS.has(keycode):
		return ARROW_KEY_LABELS[keycode]

	if keycode == KEY_SPACE:
		return "Space"

	if keycode == KEY_ESCAPE:
		return "Escape"

	var key_name: String = OS.get_keycode_string(keycode)
	if key_name.is_empty():
		return event.as_text()

	return key_name.to_upper() if key_name.length() == 1 else key_name


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(TITLE_SCENE_PATH)
