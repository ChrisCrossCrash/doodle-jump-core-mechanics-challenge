class_name OverlayManager
extends Node2D

enum Overlay { GAMEPLAY, TITLE_SCREEN, PAUSED, GAME_OVER }

@onready var _gameplay_overlay: CanvasLayer = $GameplayOverlay
@onready var _title_screen_overlay: CanvasLayer = $TitleScreenOverlay
@onready var _paused_overlay: CanvasLayer = $PausedOverlay
@onready var _game_over_overlay: CanvasLayer = $GameOverOverlay

@onready var _max_height_label: Label = $GameplayOverlay/MaxHeightLabel
@onready var _game_over_score_label: Label = $GameOverOverlay/ScoreLabel
@onready var _pause_screen_quit_button: Button = $PausedOverlay/QuitButton

func _ready() -> void:
    # Don't show the quit button on the web build version.
    _pause_screen_quit_button.visible = not OS.has_feature("web")


## Switches to the specified overlay.
func show_overlay(selected_overlay: Overlay) -> void:
    for child in get_children():
        if child is CanvasLayer:
            child.hide()

    match selected_overlay:
        Overlay.GAMEPLAY:
            _gameplay_overlay.show()
        Overlay.TITLE_SCREEN:
            _title_screen_overlay.show()
        Overlay.PAUSED:
            _paused_overlay.show()
        Overlay.GAME_OVER:
            _game_over_overlay.show()


# Update the overlays with the player's current progress in meters.
func set_progress_labels(progress_m: int) -> void:
    _max_height_label.text = str(progress_m) + " m"
    _game_over_score_label.text = "Score: " + str(progress_m) + " m"
