class_name GameplayState
extends BaseGameState
## Active during live gameplay; manages platform generation, camera tracking, and fall detection.

## How far below the camera center the player must fall to trigger game over (half the viewport height).
const FALL_DEATH_THRESHOLD := 960.0

## The platform scene instantiated by the generator.
const PLATFORM_SCENE := preload("res://scenes/platform.tscn")

## Half the platform collision width (260 px), used to keep platforms fully on-screen.
const PLATFORM_HALF_WIDTH := 130.0

## How many pixels above the camera's top edge to pre-generate platforms.
const SPAWN_LOOKAHEAD := 500.0

## How many pixels below the camera's bottom edge a platform must be before it is freed.
const DESPAWN_MARGIN := 300.0

## Minimum vertical distance between consecutive platforms.
@export var min_gap := 150.0

## Maximum vertical distance between consecutive platforms.
## Must be less than the player's max jump height (~510 px).
@export var max_gap := 350.0

# The world-space Y of the highest platform generated so far; used as the cursor for upward generation.
var _highest_platform_y := 0.0

func enter(from: C3State) -> void:
    get_tree().paused = false
    game.gameplay_overlay.show()
    if not from is PausedState:
        _initialize_platforms()


func exit() -> void:
    game.gameplay_overlay.hide()


func process_input(event: InputEvent) -> C3State:
    if event.is_action_pressed("pause"):
        return game.pause_state
    return null


func process_physics(_delta: float) -> C3State:
    var fall_distance := -(game.camera.position.y - game.player.position.y)
    if fall_distance > FALL_DEATH_THRESHOLD:
        return game.game_over_state
    return null


func _on_player_bounce(pos: Vector2) -> void:
    game.camera_target = min(pos.y, game.camera_target)
    _update_platforms()


# Clears all existing platforms and seeds a fresh set around the player's starting position.
# Called every time gameplay begins (including after game-over resets).
func _initialize_platforms() -> void:
    for child in game.platforms.get_children():
        child.queue_free()
    _highest_platform_y = game.player.position.y + 80.0
    var start_platform := PLATFORM_SCENE.instantiate() as Node2D
    start_platform.position = Vector2(game.player.position.x, _highest_platform_y)
    game.platforms.add_child(start_platform)
    var viewport_half_h := game.get_viewport_rect().size.y * 0.5
    var camera_top := game.camera_target + game.camera.offset.y - viewport_half_h
    _generate_platforms_up_to(camera_top - SPAWN_LOOKAHEAD)


# Instantiates platforms at random horizontal positions, stepping upward by random gaps,
# until target_y is reached or exceeded.
func _generate_platforms_up_to(target_y: float) -> void:
    var viewport_width := game.get_viewport_rect().size.x
    while _highest_platform_y > target_y:
        _highest_platform_y -= randf_range(min_gap, max_gap)
        var x := randf_range(PLATFORM_HALF_WIDTH, viewport_width - PLATFORM_HALF_WIDTH)
        var platform := PLATFORM_SCENE.instantiate() as Node2D
        platform.position = Vector2(x, _highest_platform_y)
        game.platforms.add_child(platform)


# Spawns new platforms ahead of the camera target and frees platforms that have
# scrolled off the bottom of the screen. Called on every player bounce.
func _update_platforms() -> void:
    var viewport_half_h := game.get_viewport_rect().size.y * 0.5
    var spawn_camera_top := game.camera_target + game.camera.offset.y - viewport_half_h
    if _highest_platform_y > spawn_camera_top - SPAWN_LOOKAHEAD:
        _generate_platforms_up_to(spawn_camera_top - SPAWN_LOOKAHEAD)
    var despawn_threshold := game.camera.position.y + game.camera.offset.y + viewport_half_h + DESPAWN_MARGIN
    for platform in game.platforms.get_children():
        if platform.position.y > despawn_threshold:
            platform.queue_free()
