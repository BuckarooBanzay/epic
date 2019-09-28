
--[[

minetest.register_node("example:node", {
  epic = {
    on_enter = function(pos, meta, data, ctx) end,
    check_interval = 0.5,
    on_check = function(pos, meta, data, ctx) end,
    on_exit = function(pos, meta, data, ctx) end,
    conditional = false
  }
})

-- context object
ctx = {
  -- epic success
  success = function(msg) end,
  -- epic failure
  failure = function(msg) end,
  -- next block
  next = function() end,
}

-- per-epic data (persistet across blocks,functions and restarts)
data = {}

--]]

epic.register_opcode = function(name, options)

  local default_tile = "epic_node_bg.png"
  local front_tile = default_tile

  if options.overlay then
    front_tile = front_tile .. "^" .. options.overlay
  end

  if options.directions then
    if options.directions.right then
      front_tile = front_tile .. "^epic_green_right.png"
    end

    if options.directions.straight then
      front_tile = front_tile .. "^epic_green_straight.png"
    end

    if options.directions.start then
      front_tile = front_tile .. "^epic_green_right_start.png"
    end

    if options.directions.final then
      front_tile = front_tile .. "^epic_green_right_end.png"
    end

    if options.directions.rightconditional then
      front_tile = front_tile .. "^epic_yellow_right.png"
    end
  end

  minetest.register_node(name, {
  	description = options.description,
  	tiles = {
  		default_tile,
      default_tile,
      default_tile,
      default_tile,
      default_tile,
      front_tile,
  	},
    paramtype2 = "facedir",
  	groups = {cracky=3,oddly_breakable_by_hand=3},
  	on_rotate = screwdriver.rotate_simple,
    epic = options.epic,
    on_receive_fields = options.on_receive_fields,
    on_construct = options.on_construct
  })

end


epic.register_opcode("epic:mob", {
	description = "Epic mob block",
  overlay = "epic_mob.png",
  directions = {
    right = true
  }
})

epic.register_opcode("epic:call", {
	description = "Epic call block",
  overlay = "epic_call.png",
  directions = {
    right = true
  }
})

epic.register_opcode("epic:nop", {
	description = "Epic nop block",
  overlay = "epic_nop.png",
  directions = {
    straight = true
  },
  epic = {
    on_enter = function(pos, meta, data, ctx)
      ctx.next()
    end
  }
})

epic.register_opcode("epic:waypoint", {
	description = "Epic waypoint block",
  overlay = "epic_waypoint.png",
  directions = {
    right = true
  },
  epic = {
    on_enter = function(pos, meta, data, ctx)
    end,
    on_check = function(pos, meta, data, ctx)
    end,
    on_exit = function(pos, meta, data, ctx)
    end
  }
})


epic.register_opcode("epic:if", {
	description = "Epic if block",
  overlay = "epic_if.png",
  directions = {
    rightconditional = true
  },
  epic = {
    conditional = true
  }
})

epic.register_opcode("epic:end", {
	description = "Epic end block",
  overlay = "epic_end.png",
  directions = {
    final = true
  }
})

epic.register_opcode("epic:ret", {
	description = "Epic ret block",
  overlay = "epic_ret.png",
  directions = {
    final = true
  }
})
