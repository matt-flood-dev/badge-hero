class_name PlayerState
extends Node

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
# Explicit type hinting holds a memory reference to the main player body
var player: CharacterBody2D
# Holds a memory reference to the parent state machine manager node
var state_machine: Node


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Halt execution until the root owner scene node completely loads into memory
	await owner.ready
	# Safely cast the root scene node as a CharacterBody2D entity
	player = owner as CharacterBody2D
	# Fetch the direct parent node managing the state transitions
	state_machine = get_parent()


# --- INPUT HANDLING ---
# Virtual method interface for parsing raw window input events down to individual states
func handle_input(_event: InputEvent) -> void:
	pass


# --- UPDATE LOOPS ---
# Virtual method interface for frame-rate dependent game loop processing
func update(_delta: float) -> void:
	pass


# Virtual method interface for uniform, fixed physics-step frame intervals
func physics_update(_delta: float) -> void:
	pass


# --- PUBLIC METHODS ---
# Virtual callback triggered automatically when this specific state becomes active
func enter() -> void:
	pass


# Virtual callback triggered automatically right before transitioning out of this state
func exit() -> void:
	pass


# --- PRIVATE METHODS ---