class_name Player
extends CharacterBody2D
## Handles player movement, auto-jumping, and horizontal screen wrapping.

## Emitted when the player lands on a platform, passing the landing position.
signal bounce(pos: Vector2)

## The upward velocity applied to the player when they land on a platform.
@export var jump_velocity := 1000.0
## The horizontal top speed of the player.
@export var max_speed := 1000.0
## The horizontal acceleration of the player, based on input.
@export var acceleration := 2000.0
## The friction applied to the player when no input is applied.
@export var friction := 500.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var col_shape: CollisionShape2D = $CollisionShape2D
@onready var bounce_sound: AudioStreamPlayer2D = $BounceSound

var col_shape_start_x: float


func _ready() -> void:
    col_shape_start_x = col_shape.position.x


func _physics_process(delta: float) -> void:
    # Vertical movement
    velocity += get_gravity() * delta
    if is_on_floor():
        velocity.y = -jump_velocity # Auto-jump
        bounce_sound.play()
        bounce.emit(position)

    # Horizontal movement
    var move_dir := Input.get_axis("move_left", "move_right")
    if move_dir != 0:
        velocity.x = move_toward(velocity.x, move_dir * max_speed, acceleration * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, friction * delta)
    if position.x < 0.0:
        position.x = get_viewport_rect().size.x
    if position.x > get_viewport_rect().size.x:
        position.x = 0.0

    move_and_slide()


func _process(_delta: float) -> void:
    # Make Kamil face in the direction of movement.
    # Only update facing when actually moving, so he keeps facing
    # the last direction after coming to a stop.
    if absf(velocity.x) > 0.1:
        var flip := velocity.x < 0.0
        sprite.flip_h = flip
        if flip:
            col_shape.position.x = -col_shape_start_x
        else:
            col_shape.position.x = col_shape_start_x
