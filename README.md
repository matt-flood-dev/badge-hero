# Badge Hero (CS50 Final Project)

## Project Description
**Badge Hero** is a 2D kinematic platformer built using the Godot 4.x game engine and written in GDScript. The primary technical objective of this project is to implement robust, framerate-independent character physics while showcasing intermediate and advanced software engineering patterns. 

Rather than relying on monolithic scripts or brittle nested conditional branches (`if/else` spaghetti logic) to manage character behaviors, this project implements a decoupled, node-based **Finite State Machine (FSM)**. This architecture ensures deterministic state boundaries, making the player controller highly scalable, easily testable, and strictly compliant with modern clean-code paradigms.

---

## Technical Architecture & Design Patterns

### 1. Finite State Machine (FSM)
The core player logic is broken down into discrete computational states. By enforcing a strict architectural rule that the entity can only occupy a single state at any given atomic tick, we eliminate overlapping states and race conditions during physics integration.

### 2. Polymorphism via Class Inheritance
To satisfy the computer science principle of **Separation of Concerns (SoC)**, the state machine leverages polymorphism. A base virtual class (`PlayerState`) establishes the generic interface hooks (`enter`, `exit`, `physics_update`). Concrete states extend this parent class, allowing the state machine manager to process lifecycle ticks uniformly without needing to know the low-level logical details of individual states.

---

## File Schema & Directory Index

The project directory separates static source assets (`assets/`) from compiled executable runtime engine logic (`src/`).

### System Configurations
* **`project.godot`**: The central application configuration manifest. Defines viewport dimension parameters ($640 \times 360$ pixels), aspect ratio scaling policies, and maps hardware-agnostic input actions (`move_left`, `move_right`, `jump`).
* **`.gitignore`**: Version-control tracking mask configured to prevent local engine cache files (`.godot/`) from polluting the shared source repository.

### Core Player System Architecture (`src/actors/player/`)
This self-contained directory houses the entire player agent pipeline, acting as a plug-and-play component:

* **`player.tscn`**: The composite visual and physical node hierarchy tree mapping out the layout boundaries of the player entity.
* **`player.gd`**: The root controller script. It serves as a lightweight execution shell that simply triggers the engine's physical collision solver (`move_and_slide()`), deferring all behavioral velocity logic to the active state sub-component.
* **`player_state.gd`**: The abstract parent class defining the interface contract for all states. It caches global environment variables and player references across the subsystem hierarchy.
* **`state_machine.gd`**: The centralized component broker that intercepts engine runtime signals and marshals execution down to the active state node. It safely handles cleanup routines during state transitions.
* **`idle_state.gd`**: Manages standing-state routines, executing continuous horizontal kinetic friction dampening while monitoring input streams for movement or jump overrides.
* **`move_state.gd`**: Handles ground-based kinematic translation. Computes linear interpolation formulas (`move_toward`) over a discrete frame delta to execute responsive acceleration, and updates the visual rendering layer's texture frames dynamically.
* **`jump_state.gd`**: Injects an instantaneous upward vertical vector impulse force, tracks variable airborne deceleration curves, and triggers transitions upon hitting peak apex thresholds.
* **`fall_state.gd`**: Applies environmental gravitational acceleration constants dynamically down the Y-axis and runs high-precision raycast queries to handle floor impact resolution.

### Environmental Design Layouts (`src/levels/`)
* **`world.tscn`**: The primary compilation environment scene where the player module is instantiated over a physical static ground collision plane to evaluate physics interactions.