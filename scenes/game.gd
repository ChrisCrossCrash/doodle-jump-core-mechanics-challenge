class_name Game
extends Node2D
## Root scene that owns all subsystems and serves as the shared context for the state machine.

## The amount of offset (in pixels) to apply to the camera relative to the player.
@export var camera_offset := -DisplayServer.window_get_size().y / 4.0

var camera_target := 0.0
var _player_position_start: Vector2
var _debug_height_markers: Dictionary = {} # int y -> Node2D

@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player
@onready var max_height_label: Label = $Overlays/GameplayOverlay/MaxHeightLabel

@onready var title_screen_overlay: CanvasLayer = $Overlays/TitleScreenOverlay
@onready var gameplay_overlay: CanvasLayer = $Overlays/GameplayOverlay
@onready var paused_overlay: CanvasLayer = $Overlays/PausedOverlay
@onready var game_over_overlay: CanvasLayer = $Overlays/GameOverOverlay

@onready var _debug_overlay: Node2D = $Overlays/DebugOverlay
@onready var _camera_target_line: Line2D = $Overlays/DebugOverlay/CameraTargetLine
@onready var _debug_height_marker_scene: PackedScene = preload("res://scenes/debug_height_marker.tscn")

@onready var platforms: Node2D = $Platforms

@onready var state_machine: C3StateMachine = $StateMachine
@onready var title_screen_state: TitleScreenState = $StateMachine/TitleScreenState
@onready var gameplay_state: GameplayState = $StateMachine/GameplayState
@onready var game_over_state: GameOverState = $StateMachine/GameOverState
@onready var pause_state: PausedState = $StateMachine/PausedState


func _ready() -> void:
    state_machine.init(self)
    camera.offset.y = camera_offset
    camera_target = player.position.y
    _player_position_start = player.position

    _debug_overlay.visible = OS.is_debug_build()


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


## Resets the player and camera to starting positions.
func reset_game() -> void:
    player.position = _player_position_start
    player.velocity = Vector2.ZERO
    camera_target = _player_position_start.y


func _update_debug_overlay() -> void:
    # Draw camera target (red line)
    _camera_target_line.position.y = camera_target

    # Draw height markers
    var gen_stop := snappedi(camera.position.y + 2000.0, 100)
    var gen_start := snappedi(camera.position.y - 2000.0, 100)

    for y: int in _debug_height_markers.keys():
        if y < gen_start or y >= gen_stop:
            _debug_height_markers[y].queue_free()
            _debug_height_markers.erase(y)

    for y in range(gen_start, gen_stop, 100):
        if not _debug_height_markers.has(y):
            var marker: Node2D = _debug_height_marker_scene.instantiate()
            marker.position = Vector2(0, y)
            _debug_overlay.add_child(marker)
            _debug_height_markers[y] = marker
