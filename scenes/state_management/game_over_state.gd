class_name GameOverState
extends BaseGameState
## State shown after the player dies; resets and restarts gameplay on any key press.


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS


func enter(_from: C3State) -> void:
    get_tree().paused = true
    game.game_over_overlay.show()


func exit() -> void:
    game.game_over_overlay.hide()


func process_input(event: InputEvent) -> C3State:
    if C3Utils.is_any_key(event):
        game.reset_game()
        return game.gameplay_state
    return null
