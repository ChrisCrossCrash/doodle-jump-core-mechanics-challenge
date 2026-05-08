class_name Game
extends Node2D
## Root scene that owns all subsystems and serves as the shared context for the state machine.

## The amount of offset (in pixels) to apply to the camera relative to the player.
@export var camera_offset := -DisplayServer.window_get_size().y / 4.0

var _player_position_start: Vector2

const PX_PER_M := 100

## Kamil's vertical progress in meters.
var progress_m: int = 0

@onready var _camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player
@onready var music: AudioStreamPlayer = $MainMusic
@onready var game_over_music: AudioStreamPlayer = $GameOverMusic

@onready var overlay_manager: OverlayManager = $OverlayManager

@onready var platforms: Node2D = $Platforms

@onready var state_machine: C3StateMachine = $StateMachine
@onready var title_screen_state: TitleScreenState = $StateMachine/TitleScreenState
@onready var gameplay_state: GameplayState = $StateMachine/GameplayState
@onready var game_over_state: GameOverState = $StateMachine/GameOverState
@onready var pause_state: PausedState = $StateMachine/PausedState


func _ready() -> void:
    state_machine.init(self)
    _camera.offset.y = camera_offset
    _camera.position.y = player.position.y
    _player_position_start = player.position


func _input(event: InputEvent) -> void:
    if OS.is_debug_build():
        if event.is_action_pressed("debug_quit"):
            get_tree().quit()
        if event.is_action_pressed("debug_reset"):
            get_tree().reload_current_scene()


func _process(_delta: float) -> void:
    progress_m = floori(y_coord_to_progress(_camera.position.y) / PX_PER_M)
    overlay_manager.set_progress_labels(progress_m)



## Resets the player and camera to starting positions.
func reset_game() -> void:
    player.position = _player_position_start
    player.velocity = Vector2.ZERO
    _camera.position.y = _player_position_start.y


## Remove all spawned platforms.
func clear_platforms() -> void:
    for child in platforms.get_children():
        child.queue_free()


## Given a world-space Y coordinate, returns the player's progress
## in pixels relative to the starting position.
func y_coord_to_progress(y: float) -> float:
    return _player_position_start.y - y


func get_camera_pos_y() -> float:
    return _camera.position.y


func set_camera_pos_y(y: float) -> void:
    _camera.position.y = y


func get_fall_distance() -> float:
    return -(get_camera_pos_y() - player.position.y)
