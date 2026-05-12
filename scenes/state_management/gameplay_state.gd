class_name GameplayState
extends BaseGameState
## Active during live gameplay; manages platform generation, camera tracking, and fall detection.

## How far below the camera center the player must fall to trigger game over (half the viewport height).
const FALL_DEATH_THRESHOLD := 960.0


func enter(from: C3State) -> void:
    get_tree().paused = false
    game.play_music()
    game.overlay_manager.show_overlay(OverlayManager.Overlay.GAMEPLAY)
    if not from is PausedState:
        game.platform_manager.initialize()


func exit() -> void:
    game.stop_music()


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
    game.camera.position.y = min(pos.y, game.camera.position.y)
    game.platform_manager.update()
