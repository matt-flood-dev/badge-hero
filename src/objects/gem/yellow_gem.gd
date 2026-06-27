extends Area2D

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Connects the internal engine physics signal to our local verification loop
	body_entered.connect(_on_body_entered)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
# Evaluates overlapping bodies to confirm player collision and advance level state
func _on_body_entered(body: Node2D) -> void:
	# Professional validation check: ensures the colliding body is our active player
	if body.name == "Player" or body.is_in_group("player"):
		GameManager.collect_gem()
		# Removes the node safely from the active game loop memory at the end of the frame
		queue_free()
