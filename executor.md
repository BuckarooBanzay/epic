
# Execution model

## Node definition

```lua
minetest.register_node("example:node", {
  epic = {
    on_enter = function(pos, meta, data, player, ctx)
      -- executed on block-entry once
    end,
    on_check = function(pos, meta, data, player, ctx)
      -- executed periodically until either ctx.next() or ctx.exit() called
    end,
    on_exit = function(pos, meta, data, player)
      -- executed once on block-exit (for cleanups)
    end
  }
})
```

## Context definition

```lua
ctx = {
  -- next block
  next = function() end,
  -- abort epic execution
  exit = function(msg) end
}
```

## Shared data for epic execution

```lua
data = {}
```
