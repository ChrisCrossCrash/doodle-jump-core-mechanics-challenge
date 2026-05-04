class_name Game
extends Node2D
## Root scene that owns all subsystems and serves as the shared context for the state machine.

## The amount of offset (in pixels) to apply to the camera relative to the player.
@export var camera_offset := -DisplayServer.window_get_size().y / 4.0

var _player_position_start: Vector2

@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player
@onready var max_height_label: Label = $Overlays/GameplayOverlay/MaxHeightLabel
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


## Resets the player and camera to starting positions.
func reset_game() -> void:
    player.position = _player_position_start
    player.velocity = Vector2.ZERO
    camera.position.y = _player_position_start.y


## Given a world-space Y coordinate, returns the player's progress
## in pixels relative to the starting position.
func y_coord_to_progress(y: float) -> float:
    return _player_position_start.y - y
