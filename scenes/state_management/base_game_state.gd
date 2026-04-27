class_name BaseGameState
extends C3State

# We could just use `context`, but it's nice to have a typed `game` interface.
var game: Game:
    get: return context as Game
