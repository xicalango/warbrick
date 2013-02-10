warbrick
========
A bomberman-like game, where you grab boxes and throw them on your opponent.

Grab a box by standing next to it (it flashes green) and press the pickup-key.
Then throw it by walking in the direction you want to throw it
and press the throw-key.

Needs löve2D engine version 0.8.0.

Controls
========

Player 1
--------

- wasd - walk
- tab - pickup/throw

Player 2
--------

- arrowkeys - walk
- shift - pickup/throw

Player 3
--------

- ijkl - walk
- tab - pickup/throw

Player 4
--------

- tfgh - walk
- shift - pickup/throw

Adding more players
==================

In main.lua change the last number on line n. 42:

```lua
gameStateManager:change( "ingame", "level1", 2  ) --last number = playercount (up to 4)
```
