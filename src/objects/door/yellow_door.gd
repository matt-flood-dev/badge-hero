extends StaticBody2D

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var interaction_zone: Area2D = $InteractionZone
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var closed_sprite: Sprite2D = $ClosedSprite
@onready var open_sprite: Sprite2D = $OpenSprite


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	interaction_zone.body_entered.connect(_on_interaction_zone_body_entered)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		if GameManager.has_key:
			_unlock_and_open()
		else:
			print("The door is securely locked. Find the Yellow Key first!")


func _unlock_and_open() -> void:
	print("Yellow Door unlocked successfully!")

	# Remove the solid blocker so the player can walk through.
	collision_shape.set_deferred("disabled", true)
	closed_sprite.visible = false
	open_sprite.visible = true
