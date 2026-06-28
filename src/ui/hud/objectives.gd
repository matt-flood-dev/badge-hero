extends Control

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var gem_label: Label = $MarginContainer/HBoxContainer/GemCounter/Label
@onready var key_label: Label = $MarginContainer/HBoxContainer/KeyCounter/Label
@onready var badge_label: Label = $MarginContainer/HBoxContainer/BadgeCounter/Label


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Listen to GameManager so the HUD stays in sync without hard-coding level logic here.
	GameManager.gem_collected.connect(_on_gem_collected)
	GameManager.key_obtained.connect(_update_key_counter)
	GameManager.badge_collected.connect(_on_badge_collected)
	GameManager.level_reset.connect(_refresh_counters)
	_refresh_counters()


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _refresh_counters() -> void:
	_on_gem_collected(GameManager.gems_collected, GameManager.TOTAL_GEMS_IN_LEVEL)
	_update_key_counter()
	_update_badge_counter()


func _on_gem_collected(current_count: int, total_required: int) -> void:
	gem_label.text = "%d/%d" % [current_count, total_required]


func _update_key_counter() -> void:
	key_label.text = "1/1" if GameManager.has_key else "0/1"


func _on_badge_collected(_current_count: int, _total_required: int) -> void:
	_update_badge_counter()


func _update_badge_counter() -> void:
	if GameManager.total_badges_in_level <= 0:
		badge_label.text = "--"
	else:
		badge_label.text = "%d/%d" % [GameManager.badges_collected, GameManager.total_badges_in_level]
