class_name StateMachine
extends Node

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---
@export var initial_state: PlayerState


# --- DATA & REFERENCES ---
var current_state: PlayerState
var states: Dictionary = {}


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	await owner.ready

	# Build a lookup table so we can switch states by name string.
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child

	if initial_state:
		current_state = initial_state
		current_state.enter()


# --- INPUT HANDLING ---
func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


# --- UPDATE LOOPS ---
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


# --- PUBLIC METHODS ---
func transition_to(new_state_name: String) -> void:
	var target_state = states.get(new_state_name.to_lower())
	if not target_state:
		return

	if current_state:
		current_state.exit()

	current_state = target_state
	current_state.enter()


# --- PRIVATE METHODS ---
