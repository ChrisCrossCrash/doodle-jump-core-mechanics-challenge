class_name PlatformManager
extends Node2D


## The world-space Y of the highest platform generated so far; used as the cursor for upward generation.
var _highest_platform_y := 0.0

## The world-space Y of the first platform; the ramp origin for difficulty scaling.
var _start_platform_y := 0.0

## The platform scene instantiated by the generator.
const PLATFORM_SCENE := preload("res://scenes/platform.tscn")

## Half the platform collision width (260 px), used to keep platforms fully on-screen.
const PLATFORM_HALF_WIDTH := 130.0

## How many pixels above the camera's top edge to pre-generate platforms.
const SPAWN_LOOKAHEAD := 500.0

## Minimum vertical gap between platforms at the start of the game (dense phase).
@export var min_gap_start := 80.0

## Maximum vertical gap between platforms at the start of the game (dense phase).
@export var max_gap_start := 160.0

## Minimum vertical gap between platforms at full difficulty (sparse phase).
@export var min_gap := 200.0

## Maximum vertical gap between platforms at full difficulty (sparse phase).
## Must be less than the player's max jump height (~510 px).
@export var max_gap := 380.0

## Height in pixels over which gaps ramp from the dense start to full-difficulty values.
@export var ramp_distance := 100000.0


## Remove all spawned platforms.
func clear() -> void:
    for child in get_children():
        child.queue_free()


## Clears all existing platforms and seeds a fresh set around the player's starting position.
## Called every time gameplay begins (including after game-over resets).
func initialize(start_pos_player: Vector2, camera: Camera2D) -> void:
    clear()

    # Place a starting platform just below the player.
    _highest_platform_y = start_pos_player.y + 80.0
    _start_platform_y = _highest_platform_y
    _spawn_platform(Vector2(start_pos_player.x, _highest_platform_y))

    # Generate the initial platforms.
    var viewport_half_h := get_viewport_rect().size.y * 0.5
    # camera_target is the desired camera center; subtracting half the viewport
    # height gives the top edge in world space.
    var camera_top := camera.position.y + camera.offset.y - viewport_half_h
    _generate_platforms_up_to(camera_top - SPAWN_LOOKAHEAD)


## Spawns new platforms ahead of the camera target and frees platforms that have
## scrolled off the bottom of the screen. Called on every player bounce.
func update(camera: Camera2D) -> void:
    var viewport_half_h := get_viewport_rect().size.y * 0.5
    var spawn_camera_top := camera.position.y + camera.offset.y - viewport_half_h
    if _highest_platform_y > spawn_camera_top - SPAWN_LOOKAHEAD:
        _generate_platforms_up_to(spawn_camera_top - SPAWN_LOOKAHEAD)


## Instantiates platforms at random horizontal positions, stepping upward by random gaps,
## until target_y is reached or exceeded.
func _generate_platforms_up_to(target_y: float) -> void:
    var viewport_width := get_viewport_rect().size.x
    while _highest_platform_y > target_y:
        var difficulty := clampf((_start_platform_y - _highest_platform_y) / ramp_distance, 0.0, 1.0)
        var gap := randf_range(
            lerpf(min_gap_start, min_gap, difficulty),
            lerpf(max_gap_start, max_gap, difficulty)
        )
        _highest_platform_y -= gap
        var x := randf_range(PLATFORM_HALF_WIDTH, viewport_width - PLATFORM_HALF_WIDTH)
        _spawn_platform(Vector2(x, _highest_platform_y))


## Instantiates a platform at the given world-space position and adds it to the platforms node.
## Returns the new platform instance, which can be used for further configuration if needed.
func _spawn_platform(pos: Vector2) -> Node2D:
    var platform := PLATFORM_SCENE.instantiate() as Platform
    platform.position = pos
    add_child(platform)
    return platform
