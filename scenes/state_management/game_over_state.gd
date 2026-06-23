class_name GameOverState
extends BaseGameState
## State shown after the player dies; resets and restarts gameplay on any key press.


func enter(_from: C3State) -> void:
    get_tree().paused = true
    game.overlay_manager.show_overlay(OverlayManager.Overlay.GAME_OVER)
    game.play_game_over_music()


func exit() -> void:
    game.stop_game_over_music()


func process_input(event: InputEvent) -> C3State:
    if C3Utils.is_any_key(event):
        game.reset_game()
        return game.title_screen_state
    return null
