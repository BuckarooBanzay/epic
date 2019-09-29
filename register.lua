

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
