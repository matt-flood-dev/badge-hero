# \# Badge Hero (CS50 Final Project)

# 

# \## Project Description

# \*\*Badge Hero\*\* is a 2D kinematic platformer built from the ground up using the Godot 4.x game engine and written in GDScript. The project focuses on implementing robust, framerate-independent physics, clean input mapping, and an industry-standard modular file architecture. 

# 

# Rather than relying on generic engine templates or black-box physics wrappers, the movement mechanics utilize custom linear interpolation models to calculate friction, acceleration, and gravity parameters over a discrete time delta. This ensures stable collision resolution and a predictable, responsive player experience across varying hardware configurations.

# 

# \---

# 

# \## Technical Architecture \& File Descriptions

# 

# To enforce a strict \*\*Separation of Concerns (SoC)\*\*, the project directory is bifurcated into distinct conceptual layers: `src/` for executable engine configurations and scripts, and `assets/` for static graphics and binary textures. This architectural choice decouples data from logic, allowing assets to be swapped or scaled dynamically without introducing regression bugs into the underlying codebase.

# 

# \### Core Project Configurations

# \* \*\*`project.godot`\*\*: The primary configuration manifest for the application context. This file handles global namespace overrides, specifies target viewport resolutions ($640 \\times 360$ pixels), enforces aspect-ratio scaling modes, and registers hardware-agnostic input abstraction keys (e.g., binding standard keyboard layouts to abstract actions like `move\_left` and `move\_right`).

# \* \*\*`.gitignore`\*\*: A version-control exclusion manifest configured specifically for Godot environments. It explicitly masks volatile metadata directories (like `.godot/`) and runtime local cache structures to prevent repository pollution and maintain a lightweight source history.

# 

# \### The Actors Directory (`src/actors/`)

# This directory contains self-contained, modular blueprints for independent game entities. These files act as autonomous software components that can be instantiated across any environment layout without structural dependencies.

# \* \*\*`src/actors/player/player.tscn`\*\*: The composite scene tree definition for the user-controlled agent. It integrates a `CharacterBody2D` root physics node, a `Sprite2D` node for processing matrix-sliced sprite sheets, and a `CollisionShape2D` node running a capsule boundary configuration for physical interaction layout.

# \* \*\*`src/actors/player/player.gd`\*\*: The core kinematic execution script. It processes input events inside the engine's fixed `\_physics\_process` tick rate. By multiplying vector translations against a fractional `delta` value, it guarantees uniform movement velocities independent of rendering hardware framerates. Horizontal movement leverages linear accumulation through `move\_toward()` to achieve smooth acceleration and rapid kinetic friction dampening.

# 

# \### The Levels Directory (`src/levels/`)

# This directory houses specific map layouts and gameplay instances, acting as the structural environments where modular actors are loaded and executed.

# \* \*\*`src/levels/world.tscn`\*\*: The primary test runtime environment scene. It serves as the global root origin where the decoupled `player.tscn` module is instanced. It configures a structural `StaticBody2D` boundary running a rectangular matrix shape alongside a `ColorRect` visual primitive to resolve terrain collision limits visually during testing.

# 

# \### The Assets Directory (`assets/`)

# \* \*\*`assets/textures/player\_tilesheet.png`\*\*: A public domain (CC0) 2D character texture grid atlas containing multi-frame character states. It is systematically parsed inside the scene parameters via geometric row and column calculations (`Hframes` and `Vframes`) to isolate specific rendering regions dynamically without multiplying draw-call overhead.

