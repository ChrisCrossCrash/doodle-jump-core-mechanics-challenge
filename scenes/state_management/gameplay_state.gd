class_name GameplayState
extends BaseGameState
## Active during live gameplay; manages platform generation, camera tracking, and fall detection.

## How far below the camera center the player must fall to trigger game over (half the viewport height).
const FALL_DEATH_THRESHOLD := 960.0


func enter(from: C3State) -> void:
    get_tree().paused = false
    game.music.play()
    game.overlay_manager.show_overlay(game.overlay_manager.Overlay.GAMEPLAY)
    if not from is PausedState:
        game.initialize_platforms()


func exit() -> void:
    game.music.stop()


func process_input(event: InputEvent) -> C3State:
    if event.is_action_pressed("pause"):
        return game.pause_state
    return null


func process_physics(_delta: float) -> C3State:
    var fall_distance := game.get_fall_distance()
    if fall_distance > FALL_DEATH_THRESHOLD:
        return game.game_over_state
    return null


func _on_player_bounce(pos: Vector2) -> void:
    game.set_camera_pos_y(min(pos.y, game.get_camera_pos_y()))
    game.update_platforms()
