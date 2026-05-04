class_name TitleScreenState
extends BaseGameState
## Initial state shown on launch; dismisses the title screen and starts gameplay on any key press.


func enter(_from: C3State) -> void:
    get_tree().paused = true
    game.title_screen_overlay.show()

    # Clear any existing platforms from previous games.
    for child in game.platforms.get_children():
        child.queue_free()

    game.player.sprite.animation = "idle"


func exit() -> void:
    game.title_screen_overlay.hide()
    game.player.sprite.animation = "jumping"


func process_input(event: InputEvent) -> C3State:
    if C3Utils.is_any_key(event):
        return game.gameplay_state
    return null
