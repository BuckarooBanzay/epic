
# Exit Functions

Every [Epic starter](./blocks/epic.md) can have a *main* and an *exit* function.

The exit function runs on every abort/exit condition:

* Main epic finished
* Player death
* Player logout
* Manual abort with `/epic_abort`

This is intended for cleanup/revert operations, such as:

* Reset skybox
* Reset position of player
* etc.
