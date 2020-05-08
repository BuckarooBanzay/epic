
-- playername => pos
local punch_handler = {}

local update_formspec = function(meta)
	local pos = meta:get_string("pos")

	meta:set_string("infotext", "Set node block: pos=" .. pos)

	meta:set_string("formspec", "size[8,7;]" ..
		-- col 2
		"button_exit[0.1,0.5;4,1;setpos;Set position]" ..
		"button_exit[4.1,0.5;4,1;showpos;Show]" ..

		"label[0,1.5;Item]" ..

		"list[context;main;4,1.5;1,1;]" ..
		"list[current_player;main;0,3;8,4;]" ..
		"listring[]" ..
		"")
end

local function do_set(pos, meta)
	local target_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(meta:get_string("pos")))
	local owner = meta:get_string("owner")
	if minetest.is_protected(target_pos, owner) then
		return
	end

	local inv = meta:get_inventory()
	local stack = inv:get_stack("main", 1)
	local node_name = stack:get_name()
	if node_name == "ignore" or node_name == "" then
		node_name = "air"
	end
	minetest.set_node(target_pos, { name = node_name })
end

minetest.register_node("epic:setnode", {
	description = "Epic set node block: sets a single node at the defined position",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_add_node.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("pos", minetest.pos_to_string({x=0, y=0, z=0}))

		local inv = meta:get_inventory()
		inv:set_size("main", 1)

		update_formspec(meta, pos)
	end,

	on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

		if fields.setpos then
			minetest.chat_send_player(sender:get_player_name(), "[epic] Please punch the desired target position")
			punch_handler[sender:get_player_name()] = pos
		end

		if fields.showpos then
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			if target_pos then
				epic.show_waypoint(sender:get_player_name(), epic.to_absolute_pos(pos, target_pos), "Target position", 2)
			end
		end
	end,

	allow_metadata_inventory_put = function(pos, _, _, stack, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_take = function(pos, _, _, stack, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return stack:get_count()
	end,

	epic = {
    on_enter = function(pos, meta, _, ctx)
			do_set(pos, meta)
			ctx.next()
    end
  },

	-- allow mesecons triggering
	mesecons = {
		effector = {
	    action_on = function (pos)
				local meta = minetest.get_meta(pos)
				do_set(pos, meta)
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
