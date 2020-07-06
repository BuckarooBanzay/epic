
local function is_chest(meta)
	local inv = meta:get_inventory()
	return inv:get_size("main") == 8*4
end

local update_formspec = function(meta)
	local pos = meta:get_string("pos")

	meta:set_string("infotext", "Fill chest @ " .. pos)

	meta:set_string("formspec", "size[8,11;]" ..
		"list[context;main;0,0.5;8,4;]" ..

		"button_exit[0.1,5.5;4,1;setfn;Set target chest]" ..
    "button_exit[4.1,5.5;4,1;showpos;Show]" ..

		"list[current_player;main;0,7;8,4;]" ..
		"listring[]" ..
		"")
end

local function do_fill(pos, meta)
	local target_pos_str = meta:get_string("pos")
	local target_pos = epic.to_absolute_pos(pos, minetest.string_to_pos(target_pos_str))

	if not is_chest(meta) then
		-- not a chest with appropriate size
		return
	end

	local inv = meta:get_inventory()
	local items = inv:get_list("main")

	local target_meta = minetest.get_meta(target_pos)
	local target_inv = target_meta:get_inventory()
	target_inv:set_list("main", items)
end

minetest.register_node("epic:fill_chest", {
	description = "Epic fill chest block: fills a chest with the defined contents",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_add_item.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	after_place_node = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
		meta:set_string("pos", minetest.pos_to_string({x=0, y=0, z=0}))

		update_formspec(meta, pos)
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

	on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		if fields.setfn then
			local playername = sender:get_player_name()
			minetest.chat_send_player(playername, "[epic] Please punch the target chest")
			epic.punchnode_callback(sender, {
			  timeout = 300,
				check_protection = true,
			  callback = function(punch_pos)
					local meta = minetest.get_meta(pos)

					if not is_chest(meta) then
						-- not a chest with apropiate size
						minetest.chat_send_player(playername, "[epic] target inventory not of appropriate size (8*4)")
						return
					end

					local pos_str = minetest.pos_to_string(epic.to_relative_pos(pos, punch_pos))
					meta:set_string("pos", pos_str)
					minetest.chat_send_player(playername, "[epic] target chest successfully set to " .. pos_str)
					update_formspec(meta)
				end
			})

		end

		if fields.showpos then
			local meta = minetest.get_meta(pos)
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			if target_pos then
			        epic.show_waypoint(
								sender:get_player_name(),
								epic.to_absolute_pos(pos, target_pos),
								"Target position",
								2
							)
			end
		end
  end,

	-- allow mesecons triggering
	mesecons = {
		effector = {
	    action_on = function (pos)
				local meta = minetest.get_meta(pos)
				do_fill(pos, meta)
			end
	  }
	},

	epic = {
    on_enter = function(pos, meta, _, ctx)
			do_fill(pos, meta)
			ctx.next()
    end
  }
})
