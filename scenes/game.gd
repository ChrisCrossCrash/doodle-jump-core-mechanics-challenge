class_name Game
extends Node2D
## Root scene that owns all subsystems and serves as the shared context for the state machine.

## The amount of offset (in pixels) to apply to the camera relative to the player.
@export var camera_offset := -DisplayServer.window_get_size().y / 4.0

var _player_position_start: Vector2

const PX_PER_M := 100

## Kamil's vertical progress in meters.
var progress_m: int = 0

@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player
@onready var _max_height_label: Label = $Overlays/GameplayOverlay/MaxHeightLabel
@onready var _game_over_score_label: Label = $Overlays/GameOverOverlay/ScoreLabel
@onready var music: AudioStreamPlayer = $MainMusic
@onready var game_over_music: AudioStreamPlayer = $GameOverMusic

@onready var title_screen_overlay: CanvasLayer = $Overlays/TitleScreenOverlay
@onready var gameplay_overlay: CanvasLayer = $Overlays/GameplayOverlay
@onready var paused_overlay: CanvasLayer = $Overlays/PausedOverlay
@onready var game_over_overlay: CanvasLayer = $Overlays/GameOverOverlay

@onready var platforms: Node2D = $Platforms

@onready var state_machine: C3StateMachine = $StateMachine
@onready var title_screen_state: TitleScreenState = $StateMachine/TitleScreenState
@onready var gameplay_state: GameplayState = $StateMachine/GameplayState
@onready var game_over_state: GameOverState = $StateMachine/GameOverState
@onready var pause_state: PausedState = $StateMachine/PausedState

@onready var quit_button: Button = $Overlays/PausedOverlay/QuitButton


func _ready() -> void:
    state_machine.init(self)
    camera.offset.y = camera_offset
    camera.position.y = player.position.y
    _player_position_start = player.position

    # Don't show the quit button on the web build version.
    quit_button.visible = not OS.has_feature("web")


func _input(event: InputEvent) -> void:
    if OS.is_debug_build():
        if event.is_action_pressed("debug_quit"):
            get_tree().quit()
        if event.is_action_pressed("debug_reset"):
            get_tree().reload_current_scene()


func _process(_delta: float) -> void:
    progress_m = floori(y_coord_to_progress(camera.position.y) / PX_PER_M)
    set_max_height_label(progress_m)
    set_game_over_height_label(progress_m)



## Resets the player and camera to starting positions.
func reset_game() -> void:
    player.position = _player_position_start
    player.velocity = Vector2.ZERO
    camera.position.y = _player_position_start.y


## Remove all spawned platforms.
func clear_platforms() -> void:
    for child in platforms.get_children():
        child.queue_free()


## Given a world-space Y coordinate, returns the player's progress
## in pixels relative to the starting position.
func y_coord_to_progress(y: float) -> float:
    return _player_position_start.y - y


## Set the value to be displayed on the height label
## on the bottom of the screen during gameplay.
func set_max_height_label(height: int) -> void:
    _max_height_label.text = str(height) + " m"


## Set the value to be displayed on the game over height label
## on the bottom of the screen on the game over screen.
func set_game_over_height_label(height: int) -> void:
    _game_over_score_label.text = "Score: " + str(height) + " m"
