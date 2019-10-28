
epic -- Enhanced Programmer for Ingame Control
-----------------

A mod for [minetest](http://www.minetest.net)

[![Build Status](https://travis-ci.org/damocles-minetest/epic.svg?branch=master)](https://travis-ci.org/thomasrudin-mt/epic)

# Overview

Create and program missions or quests by placing and configuring blocks.

<img src="./screenshot.png"/>

# Links

* Github: https://github.com/damocles-minetest/epic
* Issues: https://github.com/damocles-minetest/epic/issues
* ContentDB: TODO
* Forums: TODO

# Manual

* Available [blocks](doc/blocks.md)
* Simple Quest [example](doc/example.md)
* [Exit-Functions](doc/exit-functions.md)
* [Best practices](doc/best-practices.md)

# Dependencies

Mandatory:
* default
* screwdriver

Optional:
* mobs
* mesecons
* player_monoids
* soundblock
* monitoring
* signs

# Settings

* **epic.log_executor** (bool) logs executor internals to the action log
* **epic.hud.offsetx** (float) hud x offset
* **epic.hud.offsety** (float) hud y offset

# Portability notes

All coordinates are stored relative in the blocks.
This makes it possible to copy your creations in the same or across worlds with WorldEdit or a similar tool.

# Technical docs

* [Executor hooks](doc/executor_hooks.md)
* [Executor](doc/executor.md)
* [State](doc/state.md)

# Licenses

* default_steel_block.png / epic_node_bg.png / epic_mese_crystal.png
  * CC BY-SA 3.0 https://github.com/minetest/minetest_game

* 16x16 Icons in `textures/*`
  * CC BY-SA 3.0 http://www.small-icons.com/packs/16x16-free-toolbar-icons.htm
  * CC BY-SA 3.0 http://www.small-icons.com/packs/16x16-free-application-icons.htm
