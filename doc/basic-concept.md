
# Basic concept

An epic consists of several functions.

A function is basically a bunch of blocks that get executed **from left to right**:
<img src="./pics/basic_concept.png"/>

A function starts with a [function](./blocks/function.md) block and ends implicitly on the end of the blocks.

Functions can be called with a [call](./blocks/call.md) or an [epic](./blocks/epic.md) block, the position of the called function is not relevant.
It can be on the other side of the world if needed...
Functions can also call each other or themselfes (but be cautious with that!)

The [epic](./blocks/epic.md) block acts as a starting point for players and executes a *main* and an optional *exit* / *abort* function.

## Main function

This function gets called on the start of the epic.

## Exit function

This function gets called if the epic exits (for whatever reason).
Cleanup stuff should be done in here (remove nodes, teleport out of the arena, etc)

## Abort function

This function gets called if the player dies/disconnects/timeouts or executes `/epic_abort`

# Function composition

Function can be (and should) be grouped to logical units, see [best practices](./best-practices.md).
