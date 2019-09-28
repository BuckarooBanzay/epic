
epic.register_opcode("epic:waypoint", {
	description = "Epic waypoint block",
  overlay = "epic_waypoint.png",
  directions = {
    right = true
  },
  epic = {
    on_enter = function(pos, meta, data, player, ctx)
    end,
    on_check = function(pos, meta, data, player, ctx)
    end,
    on_exit = function(pos, meta, data, player, ctx)
    end
  }
})
