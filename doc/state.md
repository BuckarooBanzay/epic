
# State definition

```lua
epic.state[playername] = {

  -- instruction pointer to currently executed block
  ip = pos,

  -- optional name
  name = "my epic",

  -- optional timeout
  time = 300,

  -- call stack (table of positions)
  stack = {},

  -- initialization flag
  initialized = false,

  -- state data, re-used across block-executions (used in epic.on_enter and epic.on_check as "data")
  data = {},

  -- current step data (a place for temporary hud-id's / waypoints)
  step_data = {}
}
```
