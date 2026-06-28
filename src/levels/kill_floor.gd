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
# Detects when a physics body plunges into the hazard zone
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		_process_player_hazard_fall(body)


# Handles the execution sequence when the player trips the kill floor boundary
func _process_player_hazard_fall(player: Node2D) -> void:
	print("Player plummeted into the hazard zone!")

	if player.has_method("apply_hazard_fall"):
		player.apply_hazard_fall(global_position)