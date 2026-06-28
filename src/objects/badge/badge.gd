extends Area2D

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Connects the engine's internal physics signal to our local callback
	body_entered.connect(_on_body_entered)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
# Evaluates overlapping bodies to confirm player collision and trigger level victory
func _on_body_entered(body: Node2D) -> void:
	# Professional validation check: ensures the colliding body is our active player
	if body.name == "Player" or body.is_in_group("player"):
		_trigger_level_victory()


# Locks down player movement or states and runs the final level completion sequences
func _trigger_level_victory() -> void:
	print("VICTORY! Level-Ending Badge collected successfully.")
	
	# Safely deactivates this area after the physics frame to prevent multiple triggers
	set_deferred("monitoring", false)
	
	# Temporary verification sequence before we implement UI screen transitions
	print("Transitioning to the next staging zone...")

    # Safely removes the badge object from the scene tree layout
	queue_free()