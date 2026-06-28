# Badge Hero

#### Video Demo: TODO — add your YouTube URL before submitting to CS50

#### Description

**Badge Hero** is a 2D platformer built in **Godot 4.6** with **GDScript**. You play as a hero who must collect gems, unlock a key, open a door, defeat an enemy, and collect a victory badge to win the level. The project demonstrates framerate-independent character physics, a node-based **Finite State Machine (FSM)** for player movement, and a signal-driven **GameManager** autoload that coordinates objectives, HUD updates, pause, game over, and victory screens.

The game opens on a title screen, runs a single handcrafted level (`world.tscn`), and supports keyboard controls with optional mouse visibility during gameplay. Press **Escape** to quit the application from any screen.

---

## How to Run

1. Install [Godot 4.6](https://godotengine.org/download) (GL Compatibility renderer is configured in this project).
2. Clone or download this repository and open **`project.godot`** in the Godot editor.
3. Press **F5** (or click **Run Project**). The main scene is the title screen at `src/ui/menus/title.tscn`.
4. Click **Start Game** to load the level, or **Controls** to view the input map.
5. To test from the editor without the title screen, you can temporarily set the main scene to `src/levels/world.tscn`, but the intended player experience starts at the title menu.

No external build step, package manager, or database is required. Godot imports assets automatically on first open.

---

## Controls

| Action | Keys |
|--------|------|
| Move left | A, Left Arrow |
| Move right | D, Right Arrow |
| Jump | Space, Up Arrow |
| Pause | P |
| Toggle mouse cursor | M |
| Quit game | Escape |

Stomp enemies by landing on them from above. Side contact deals damage. Falling off the bottom of the level triggers hazard damage and respawns you at your last safe position after the hurt animation finishes.

---

## Gameplay and Win Condition

The level is a linear objective chain:

1. **Collect five yellow gems** scattered across the map. The objective HUD updates after each pickup.
2. After the fifth gem, the **yellow key** appears. Touch it to add it to your inventory.
3. Walk into the **yellow door** while holding the key; it opens and removes its collision so you can pass through.
4. **Defeat the patrol enemy** by jumping on its head (Mario-style stomp). Contact from the side knocks back and removes health.
5. Once the enemy is defeated, the **victory badge** materialises. Collect it to trigger the victory screen.

If your health reaches zero, the game over screen appears. On game over or victory, press any key to restart the level. Escape quits the program entirely.

---

## Technical Architecture

### Finite State Machine (Player)

Rather than one large script with nested `if/else` branches for every movement case, player behaviour is split into discrete states. A **StateMachine** node holds references to **Idle**, **Move**, **Jump**, **Fall**, and **Hurt** states. Each state extends an abstract **PlayerState** base class that defines `enter()`, `exit()`, and `physics_update()`. The player root script only calls `move_and_slide()`; velocity and transitions are owned by the active state. This separation of concerns makes it straightforward to add new behaviours (for example, a dash state) without rewriting unrelated code.

### GameManager Autoload

`GameManager` is registered in `project.godot` and persists for the entire session. It tracks gem count, key ownership, badge registration, pause state, game over, and victory. It emits signals such as `gem_collected`, `key_obtained`, `enemy_defeated`, and `badge_collected` so HUD and menu scenes stay decoupled from level objects. Collectibles call into GameManager; the objectives HUD listens to signals rather than polling state each frame.

### Menus and Pause

End-game and pause overlays use `CanvasLayer` nodes with `process_mode = PROCESS_MODE_ALWAYS` so they still receive input while `get_tree().paused` is true. The pause menu toggles via **P**; GameManager blocks pause during game over and victory because those screens already pause the tree.

### Design Choices

- **Badge gated on enemy defeat:** The win collectible stays hidden until the enemy is stomped, forcing the player to engage with combat rather than sequence-breaking to the badge.
- **Deferred respawn on kill floor:** Falling into the hazard sets a flag and waits for the hurt state to finish before teleporting the player, avoiding jarring mid-animation snaps.
- **Dynamic controls screen:** The controls menu reads Godot's InputMap at runtime so displayed bindings always match `project.godot`.
- **Signal-driven HUD:** Objective counters and hearts update through signals, keeping UI scripts thin and reusable if the level layout changes.

---

## File Index

### Configuration

| File | Purpose |
|------|---------|
| `project.godot` | Engine settings: 640×360 viewport, input actions, main scene, GameManager autoload |
| `.gitignore` | Excludes `.godot/` cache from version control |
| `LICENSE` | MIT license for project source code (Matt Flood, 2026) |

### `src/core/`

| File | Purpose |
|------|---------|
| `game_manager.gd` | Autoload singleton: progress tracking, pause, game over, victory, restart, quit |

### `src/actors/player/`

| File | Purpose |
|------|---------|
| `player.tscn` / `player.gd` | CharacterBody2D root, health, damage, camera, delegates physics to FSM |
| `player_state.gd` | Abstract base class for all player states |
| `state_machine.gd` | Routes input and physics ticks to the active state |
| `idle_state.gd` | Standing, friction, transition to move or jump |
| `move_state.gd` | Ground acceleration and sprite facing |
| `jump_state.gd` | Jump impulse and air control |
| `fall_state.gd` | Gravity and landing detection |
| `hurt_state.gd` | Invincibility frames, knockback, kill-floor respawn |

### `src/actors/enemy/`

| File | Purpose |
|------|---------|
| `enemy.tscn` / `enemy.gd` | Patrol enemy with wall/ledge detection, stomp defeat, contact damage |

### `src/objects/`

| File | Purpose |
|------|---------|
| `gem/yellow_gem.gd` | Collectible gem; increments GameManager gem count |
| `key/yellow_key.gd` | Hidden until five gems collected; grants key |
| `door/yellow_door.gd` | Opens when player has key |
| `badge/badge.gd` | Hidden until enemy defeated; triggers victory when collected |

### `src/levels/`

| File | Purpose |
|------|---------|
| `world.tscn` | Main level: tilemap, player, collectibles, enemy, HUD, menu overlays |
| `kill_floor.gd` | Bottom hazard area; damages player and triggers respawn |

### `src/ui/hud/`

| File | Purpose |
|------|---------|
| `heart.tscn` / `heart.gd` | Single heart icon (filled or empty) |
| `objectives.tscn` / `objectives.gd` | Top-bar gem, key, and badge counters |

### `src/ui/menus/`

| File | Purpose |
|------|---------|
| `title.gd` / `title.tscn` | Entry menu: Start Game and Controls |
| `controls.gd` / `controls.tscn` | Displays input bindings; Back button returns to title |
| `pause.gd` / `pause.tscn` | Pause overlay toggled with P |
| `game_over.gd` / `game_over.tscn` | Shown on zero health; any key restarts |
| `victory.gd` / `victory.tscn` | Shown when all badges collected; any key restarts |

### `assets/textures/`

Sprite sheets and tilesets used for the player, enemies, collectibles, and tilemap (`platformPack_tilesheet.png`, `platformerPack_character.png`, `player_tilesheet.png`, `flat.png`).

---

## Asset Credits

Art assets are from **[Kenney](https://kenney.nl/)** (Platformer Pack / related CC0 packs). Kenney assets are free for personal and commercial use; see [kenney.nl](https://kenney.nl/assets) for license details. The MIT `LICENSE` file in this repository applies to **source code only**, not to third-party art.

---

## AI Tools Used

Per CS50 policy, AI-based tools were used as helpers during development. **Cursor** (with Claude) assisted with drafting GDScript, scene wiring, menu systems, enemy logic, README documentation, and code review suggestions. All generated code was reviewed, tested in Godot, and adapted by the author. AI assistance is also cited in comments at the top of each `.gd` file under `src/`.

---

## Submitting to CS50

From the project root (the folder containing this `README.md`):

```
submit50 cs50/problems/2026/x/project
```

After submitting, visit [cs50.me/cs50x](https://cs50.me/cs50x) to confirm the gradebook shows completion. Remember to replace the video URL placeholder above and submit the CS50 video form before the course deadline.
