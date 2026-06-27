class_name StateMachine
extends Node

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---
# Inspector-exposed slot to declare which state node executes immediately on game boot
@export var initial_state: PlayerState


# --- DATA & REFERENCES ---
# Memory reference to the child state node currently executing its update loops
var current_state: PlayerState
# Key-value dictionary tracking string names mapped to their respective node references
var states: Dictionary = {}


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Yield initialization until the player scene tree is completely loaded
	await owner.ready
	
	# Iterate over all direct child nodes to dynamically discover available states
	for child in get_children():
		if child is PlayerState:
			# Cache the node reference using its lowercase string name as the lookup key
			states[child.name.to_lower()] = child
	
	# Establish and boot into the primary assigned state configuration
	if initial_state:
		current_state = initial_state
		current_state.enter()


# --- INPUT HANDLING ---
func _unhandled_input(event: InputEvent) -> void:
	# Intercept and route unhandled input events directly to the active state execution loop
	if current_state:
		current_state.handle_input(event)


# --- UPDATE LOOPS ---
func _process(delta: float) -> void:
	# Route frame-by-frame processing iterations down to the active state node
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	# Route fixed physics iterations down to the active state node
	if current_state:
		current_state.physics_update(delta)


# --- PUBLIC METHODS ---
# Primary state transitions broker (Central Control Flow)
func transition_to(new_state_name: String) -> void:
	# Attempt to locate the target state in our cached memory dictionary
	var target_state = states.get(new_state_name.to_lower())
	if not target_state:
		return
		
	# Teardown the outgoing state context cleanly
	if current_state:
		current_state.exit()
		
	# Bind and initialize the incoming state behavior context
	current_state = target_state
	current_state.enter()


# --- PRIVATE METHODS ---

