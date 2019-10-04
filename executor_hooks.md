
# Executor hooks

```lua
epic.register_hook({
  -- called before a function is called
  -- this is usually user-triggered
  on_execute_function = function(player, main_pos, exit_pos) end,

  -- called on state-restore
  -- on join of a player with a saved mission
  on_state_restored = function(playername, state)

  -- called before each node enter call
  on_before_node_enter = function(pos, player, ctx) end,

  -- called before each node exit call
  on_before_node_exit = function(pos, player, ctx) end,

  -- called on epic exit
  on_epic_exit = function(playername, state) end,

  -- called on epic abort
  -- reason: "epic_timeout", "manual", "leave", "leave_timed_out"
  on_epic_abort = function(playername, state, reason) end
})
```
