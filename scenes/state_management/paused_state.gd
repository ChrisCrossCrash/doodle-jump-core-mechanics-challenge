class_name PausedState
extends BaseGameState
## State active while the game is paused; returns to gameplay on any key press.


func enter(_from: C3State) -> void:
    get_tree().paused = true
    game.paused_overlay.show()
    var resume_button: Button = get_tree().get_first_node_in_group("pause_menu_resume_button")
    resume_button.grab_focus()


func exit() -> void:
    game.paused_overlay.hide()


func process_input(event: InputEvent) -> C3State:
    if event.is_action_pressed("pause"):
        return game.gameplay_state
    return null


func _on_resume_button_pressed() -> void:
    game.state_machine.change_state(game.gameplay_state)


func _on_quit_button_pressed() -> void:
    get_tree().quit()
