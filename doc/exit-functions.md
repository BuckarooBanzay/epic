
# Exit Functions

Every [Epic starter](./blocks/epic.md) can have a *main*, *abort* and an *exit* function.

The *main* function is where the main action finds place.

The *abort* function is called if the player aborts or dies:
* On death
* On disconnect
* On `/epic_abort`

The *exit* function runs on every abort/exit condition:

* Main epic finished
* Player death
* Player logout
* Manual abort with `/epic_abort`

The *exit* function is intended for cleanup or revert operations, such as:

* Reset skybox
* Reset position of player
* etc.
