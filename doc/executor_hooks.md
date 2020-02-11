
# Executor hooks

```lua
epic.register_hook({
  -- called before an epic is called
  -- this is usually user-triggered (from epic or function)
  on_execute_epic = function(player, main_pos, state) end,

  -- called before each node enter call
  on_before_node_enter = function(pos, player, ctx) end,

  -- called before each node check call
  on_before_node_check = function(pos, player, ctx) end,

  -- called before each node exit call
  on_before_node_exit = function(pos, player, ctx) end,

  -- called on epic exit
  on_epic_exit = function(playername, state) end,

  -- called on epic abort
  -- reason: "epic_timeout", "manual", "leave", "leave_timed_out", "died"
  on_epic_abort = function(playername, state, reason) end,

  -- called on each globalstep
  -- stats = { time = 0.1 }
  globalstep_stats = function(stats) end
})
```
