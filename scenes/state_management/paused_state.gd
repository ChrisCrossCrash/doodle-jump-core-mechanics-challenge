class_name PausedState
extends BaseGameState


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS


func enter() -> void:
    get_tree().paused = true
    game.paused_overlay.show()


func exit() -> void:
    game.paused_overlay.hide()


func process_input(event: InputEvent) -> C3State:
    if C3Utils.is_any_key(event):
        return game.gameplay_state
    return null
