class_name TitleScreenState
extends BaseGameState
## Initial state shown on launch; dismisses the title screen and starts gameplay on any key press.


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS


func enter() -> void:
    get_tree().paused = true
    game.title_screen_overlay.show()


func exit() -> void:
    game.title_screen_overlay.hide()


func process_input(event: InputEvent) -> C3State:
    if C3Utils.is_any_key(event):
        return game.gameplay_state
    return null
