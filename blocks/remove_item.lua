
-- playername => pos
local punch_handler = {}

local update_formspec = function(meta)
	local pos = meta:get_string("pos")
	local radius = meta:get_string("radius")

	meta:set_string("infotext", "Remove item block: pos=" .. pos)

	meta:set_string("formspec", "size[8,3;]" ..
		"button_exit[0.1,0.1;4,1;setpos;Set position]" ..
		"button_exit[4.1,0.1;4,1;showpos;Show]" ..

		"field[0.2,1.5;8,1;radius;Radius;" .. radius .. "]" ..
		"button_exit[0.1,2.5;8,1;save;Save]" ..

		"")
end

local function do_remove(pos, meta)
	local target_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(meta:get_string("pos")))
	local radius = tonumber(meta:get_string("radius")) or 5

	if radius > 20 or radius < 1 then
		radius = 1
	end

	local objects = minetest.get_objects_inside_radius(target_pos, radius)
	for _, object in ipairs(objects) do
		object:remove()
	end

end

minetest.register_node("epic:removeitem", {
	description = "Epic remove item block: removes objects within the given radius",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_remove.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("pos", minetest.pos_to_string({x=0, y=0, z=0}))
		meta:set_string("radius", "5")

    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos)

		if fields.setpos then
			minetest.chat_send_player(sender:get_player_name(), "[epic] Please punch the desired target position")
			punch_handler[sender:get_player_name()] = pos
		end

		if fields.save then
			meta:set_string("radius", fields.radius or "5")
			update_formspec(meta, pos)
    end

		if fields.showpos then
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			if target_pos then
				epic.show_waypoint(sender:get_player_name(), epic.to_absolute_pos(pos, target_pos), "Target position", 2)
			end
		end
  end,

	epic = {
    on_enter = function(pos, meta, _, ctx)
			do_remove(pos, meta)
			ctx.next()
    end
  },

	-- allow mesecons triggering
	mesecons = {
		effector = {
	    action_on = function (pos)
				local meta = minetest.get_meta(pos)
				do_remove(pos, meta)
			end
	  }
	}
})

minetest.register_on_punchnode(function(pos, _, puncher, _)
	local playername = puncher:get_player_name()
	local cfg_pos = punch_handler[playername]
	if cfg_pos then
		if minetest.is_protected(pos, playername) and
			not minetest.check_player_privs(playername, {epic_admin=true}) then
			minetest.chat_send_player(playername, "[epic] target is protected! aborting selection.")

		else
			local meta = minetest.get_meta(cfg_pos)
			local pos_str = minetest.pos_to_string(epic.to_relative_pos(cfg_pos, pos))
			meta:set_string("pos", pos_str)
			minetest.chat_send_player(playername, "[epic] target position successfully set to " .. pos_str)
			update_formspec(meta)

		end
		punch_handler[playername] = nil
	end
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	punch_handler[playername] = nil

end)
