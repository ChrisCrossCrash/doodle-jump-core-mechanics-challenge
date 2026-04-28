class_name BaseGameState
extends C3State
## Base class for all game states; provides a typed [member game] reference to the root scene.

# We could just use `context`, but it's nice to have a typed `game` interface.
## Typed reference to the root [Game] scene context.
var game: Game:
    get: return context as Game
