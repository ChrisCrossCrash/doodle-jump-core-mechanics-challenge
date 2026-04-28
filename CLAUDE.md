# CLAUDE.md

This file defines conventions and guidelines for this Godot 4 project. Follow these rules consistently across all GDScript files.

---

## Code Style

### Indentation

Use **4 spaces** for indentation. Never use tabs.

### Type Hints

Always annotate variable declarations and function signatures with type hints. Prefer explicit types over `Variant`.

For variables, use `:=` to infer the type from the assigned value rather than spelling it out explicitly. Always annotate function return types and parameters.

```gdscript
# Good
var speed := 5.0
func get_label() -> String:

# Avoid
var speed = 5.0
func get_label():
```

### Comments

Comment **sparingly**. Comments should answer *why*, not *what* — the code itself should make the what obvious.

```gdscript
# Good: explains a non-obvious decision
# Slight delay prevents physics body from sleeping before impulse registers
await get_tree().physics_frame

# Avoid: restates what the code already says
# Set speed to 5
speed = 5.0
```

Use `##` documentation comments on exported variables, public methods, and class-level declarations. These appear as tooltips in the Godot editor.

```gdscript
## The maximum speed the player can reach, in units per second.
@export var max_speed: float = 10.0
```

Do **not** use `##` on private helpers or internal implementation details.

### Node Ordering Conventions

Follow Godot's recommended declaration order within a class:

1. `class_name`
2. `extends`
3. `## Class-level doc comment`
4. Signals
5. Enums
6. Constants
7. `@export` variables
8. Public variables
9. Private variables (prefix with `_`)
10. `@onready` variables
11. Built-in virtual methods (`_ready`, `_process`, `_physics_process`, etc.)
12. Public methods
13. Private methods (prefix with `_`)

---

## Example File

```gdscript
class_name ItemSlot
extends Node3D
## Represents a single slot in the player's physical inventory space.
## Tracks occupancy and exposes methods for placing and removing items.

signal item_placed(item: RigidBody3D)
signal item_removed(item: RigidBody3D)

enum SlotState {
	EMPTY,
	OCCUPIED,
	RESERVED,
}

const SNAP_DISTANCE: float = 0.25

## Whether this slot accepts items automatically from the conveyor.
@export var auto_accept: bool = false

## The item category this slot is restricted to, if any.
@export var filter_category: String = ""

var state := SlotState.EMPTY

var _current_item: RigidBody3D = null
var _snap_tween: Tween = null

@onready var _collision_area: Area3D = $CollisionArea
@onready var _highlight_mesh: MeshInstance3D = $HighlightMesh


func _ready() -> void:
	_collision_area.body_entered.connect(_on_body_entered)
	_highlight_mesh.visible = false


func _physics_process(_delta: float) -> void:
	if state == SlotState.RESERVED and _current_item == null:
		# Reservation timed out externally — clean up so the slot doesn't stay locked.
		state = SlotState.EMPTY


## Places an item into this slot, snapping it into position.
## Returns false if the slot is already occupied or the item is filtered out.
func place_item(item: RigidBody3D) -> bool:
	if state != SlotState.EMPTY:
		return false
	if not _passes_filter(item):
		return false

	_current_item = item
	state = SlotState.OCCUPIED
	_snap_item_to_position(item)
	item_placed.emit(item)
	return true


## Removes and returns the current item, leaving the slot empty.
## Returns null if the slot is already empty.
func remove_item() -> RigidBody3D:
	if state == SlotState.EMPTY:
		return null

	var item := _current_item
	_current_item = null
	state = SlotState.EMPTY
	item_removed.emit(item)
	return item


## Returns true if the item is allowed in this slot.[br]
## An empty [member filter_category] means all items are accepted.
## Otherwise, the item must have a matching "category" meta value.
func _passes_filter(item: RigidBody3D) -> bool:
	if filter_category.is_empty():
		return true
	return item.get_meta("category", "") == filter_category


## Temporarily freezes the item's physics body and tweens it to this slot's position.[br]
## Physics is re-enabled after the tween completes so the solver doesn't fight the animation.
func _snap_item_to_position(item: RigidBody3D) -> void:
	# Disable physics influence during snap so the tween isn't fought by the solver.
	item.freeze = true

	_snap_tween = create_tween()
	_snap_tween.tween_property(item, "global_position", global_position, 0.1)
	await _snap_tween.finished

	item.freeze = false


## Shows the highlight mesh when a physics body enters the collision area.[br]
## The highlight is hidden again by [method place_item] once an item is accepted.
func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and state == SlotState.EMPTY:
		_highlight_mesh.visible = true
```