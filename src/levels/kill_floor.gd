extends Area2D

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		_process_player_hazard_fall(body)


func _process_player_hazard_fall(player: Node2D) -> void:
	print("Player plummeted into the hazard zone!")

	# Player handles damage and delayed respawn so the hurt animation can finish first.
	if player.has_method("apply_hazard_fall"):
		player.apply_hazard_fall(global_position)
