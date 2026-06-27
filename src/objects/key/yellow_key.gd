extends Area2D

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
var is_unlocked: bool = false


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Disables monitoring processing loops at start so players can't touch an invisible key
	monitoring = false
	
	# Connects to our global system signals to track level progression
	body_entered.connect(_on_body_entered)
	GameManager.gem_collected.connect(_on_gem_collected)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
# Monitors global progression counts to evaluate objectives gating conditions
func _on_gem_collected(current_count: int, total_required: int) -> void:
	if current_count >= total_required:
		_reveal_key()


# Makes the objective item visible and interactive within the active game loops
func _reveal_key() -> void:
	is_unlocked = true
	visible = true
	monitoring = true
	print("All objective gems gathered! The Yellow Key has materialised.")


# Evaluates overlapping bodies to confirm player collection and advance level state
func _on_body_entered(body: Node2D) -> void:
	if is_unlocked and (body.name == "Player" or body.is_in_group("player")):
		GameManager.obtain_key()
		queue_free()
