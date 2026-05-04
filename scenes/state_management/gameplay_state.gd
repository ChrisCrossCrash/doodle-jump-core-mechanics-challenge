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

## The world-space Y of the highest platform generated so far; used as the cursor for upward generation.
var _highest_platform_y := 0.0

## The world-space Y of the first platform; the ramp origin for difficulty scaling.
var _start_platform_y := 0.0


func enter(from: C3State) -> void:
    get_tree().paused = false
    game.music.play()
    game.gameplay_overlay.show()
    if not from is PausedState:
        _initialize_platforms()


func exit() -> void:
    game.gameplay_overlay.hide()
    game.music.stop()


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
    game.camera.position.y = min(pos.y, game.camera.position.y)
    _update_max_height_label()
    _update_platforms()


## Clears all existing platforms and seeds a fresh set around the player's starting position.
## Called every time gameplay begins (including after game-over resets).
func _initialize_platforms() -> void:
    # Clear any existing platforms.
    for child in game.platforms.get_children():
        child.queue_free()

    # Place a starting platform just below the player.
    _highest_platform_y = game.player.position.y + 80.0
    _start_platform_y = _highest_platform_y
    _spawn_platform(Vector2(game.player.position.x, _highest_platform_y))

    # Generate the initial platforms.
    var viewport_half_h := game.get_viewport_rect().size.y * 0.5
    # camera_target is the desired camera center; subtracting half the viewport
    # height gives the top edge in world space.
    var camera_top := game.camera.position.y + game.camera.offset.y - viewport_half_h
    _generate_platforms_up_to(camera_top - SPAWN_LOOKAHEAD)


## Instantiates platforms at random horizontal positions, stepping upward by random gaps,
## until target_y is reached or exceeded.
func _generate_platforms_up_to(target_y: float) -> void:
    var viewport_width := game.get_viewport_rect().size.x
    while _highest_platform_y > target_y:
        var difficulty := clampf((_start_platform_y - _highest_platform_y) / ramp_distance, 0.0, 1.0)
        var gap := randf_range(
            lerpf(min_gap_start, min_gap, difficulty),
            lerpf(max_gap_start, max_gap, difficulty)
        )
        _highest_platform_y -= gap
        var x := randf_range(PLATFORM_HALF_WIDTH, viewport_width - PLATFORM_HALF_WIDTH)
        _spawn_platform(Vector2(x, _highest_platform_y))


## Spawns new platforms ahead of the camera target and frees platforms that have
## scrolled off the bottom of the screen. Called on every player bounce.
func _update_platforms() -> void:
    var viewport_half_h := game.get_viewport_rect().size.y * 0.5
    var spawn_camera_top := game.camera.position.y + game.camera.offset.y - viewport_half_h
    if _highest_platform_y > spawn_camera_top - SPAWN_LOOKAHEAD:
        _generate_platforms_up_to(spawn_camera_top - SPAWN_LOOKAHEAD)


## Instantiates a platform at the given world-space position and adds it to the platforms node.
## Returns the new platform instance, which can be used for further configuration if needed.
func _spawn_platform(pos: Vector2) -> Node2D:
    var platform := PLATFORM_SCENE.instantiate() as Platform
    platform.position = pos
    game.platforms.add_child(platform)
    return platform


## Update the label on the bottom of the screen with the player's progress in meters (1 m = 100 px).
func _update_max_height_label() -> void:
    var progress = floori(game.y_coord_to_progress(game.camera.position.y) * 0.01)
    game.max_height_label.text = str(progress) + " m"
    game.game_over_score_label.text = "Score: " + str(progress) + " m"
