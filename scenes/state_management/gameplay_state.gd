class_name GameplayState
extends BaseGameState

const FALL_DEATH_THRESHOLD := 960.0  # half viewport height


func enter() -> void:
    get_tree().paused = false
    game.gameplay_overlay.show()


func exit() -> void:
    game.gameplay_overlay.hide()


func process_input(event: InputEvent) -> C3State:
    if event.is_action_pressed("pause"):
        return game.pause_state
    return null


func process_physics(_delta: float) -> C3State:
    var fall_distance := -(game.camera.position.y - game.player.position.y)
    if fall_distance > FALL_DEATH_THRESHOLD:
        return game.game_over_state
    return null


func _on_player_bounce(pos: Vector2) -> void:
    game.camera_target = min(pos.y, game.camera_target)
