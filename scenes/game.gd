class_name Game
extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player
@onready var max_height_label: Label = $Overlays/GameplayOverlay/MaxHeightLabel

@onready var title_screen_overlay: CanvasLayer = $Overlays/TitleScreenOverlay
@onready var gameplay_overlay: CanvasLayer = $Overlays/GameplayOverlay
@onready var paused_overlay: CanvasLayer = $Overlays/PausedOverlay
@onready var game_over_overlay: CanvasLayer = $Overlays/GameOverOverlay

@onready var debug_overlay: Node2D = $Overlays/DebugOverlay
@onready var camera_target_line: Line2D = $Overlays/DebugOverlay/CameraTargetLine

@onready var state_machine: C3StateMachine = $StateMachine
@onready var title_screen_state: TitleScreenState = $StateMachine/TitleScreenState
@onready var gameplay_state: GameplayState = $StateMachine/GameplayState
@onready var game_over_state: GameOverState = $StateMachine/GameOverState
@onready var pause_state: PausedState = $StateMachine/PausedState

## The amount of offset (in pixels) to apply to the camera relative to the player.
@export var camera_offset := -DisplayServer.window_get_size().y / 4.0

var camera_target := 0.0
var _player_position_start: Vector2


func _ready() -> void:
    state_machine.init(self)
    camera.offset.y = camera_offset
    camera_target = player.position.y
    _player_position_start = player.position

    debug_overlay.visible = OS.is_debug_build()


func _physics_process(_delta: float) -> void:
    camera.position.y = camera_target
    if OS.is_debug_build():
        _update_debug_overlay()


func _input(event: InputEvent) -> void:
    if OS.is_debug_build():
        if event.is_action_pressed("debug_quit"):
            get_tree().quit()
        if event.is_action_pressed("debug_reset"):
            get_tree().reload_current_scene()


func reset_game() -> void:
    player.position = _player_position_start
    player.velocity = Vector2.ZERO
    camera_target = _player_position_start.y


func _update_debug_overlay() -> void:
    camera_target_line.position.y = camera_target
