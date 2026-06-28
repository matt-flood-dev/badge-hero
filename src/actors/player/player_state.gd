class_name PlayerState
extends Node

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
# Shared references every state script needs once the player scene is ready.
var player: CharacterBody2D
var state_machine: Node


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	await owner.ready
	player = owner as CharacterBody2D
	state_machine = get_parent()


# --- INPUT HANDLING ---
# Base methods that individual states can override when needed.
func handle_input(_event: InputEvent) -> void:
	pass


# --- UPDATE LOOPS ---
func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


# --- PUBLIC METHODS ---
func enter() -> void:
	pass


func exit() -> void:
	pass


# --- PRIVATE METHODS ---
