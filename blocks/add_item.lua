
local update_formspec = function(meta)
	local pos = meta:get_string("pos")

	meta:set_string("infotext", "Add item block: pos=" .. pos)

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

local function do_add_item(pos, meta)
	local target_pos = minetest.string_to_pos(meta:get_string("pos"))

	local objs = minetest.get_objects_inside_radius(target_pos, 2)
	local count = 0
	for _ in ipairs(objs) do
		count = count + 1
	end

	if count > 5 then
		-- too many objects
		return
	end

	local inv = meta:get_inventory()
	local stack = inv:get_stack("main", 1)
	minetest.add_item(epic.to_absolute_pos(pos, target_pos), stack)
end

minetest.register_node("epic:additem", {
	description = "Epic add item block: Adds an item at the defined position",
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

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("pos", minetest.pos_to_string({x=0, y=0, z=0}))

		local inv = meta:get_inventory()
		inv:set_size("main", 1)

    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		local playername = sender:get_player_name()
		if not sender or minetest.is_protected(pos, playername) then
			-- not allowed
			return
		end

		local meta = minetest.get_meta(pos);

		if fields.setpos then
			minetest.chat_send_player(playername, "[epic] Please punch the desired target position")
			epic.punchnode_callback(sender, {
			  timeout = 300,
			  callback = function(punch_pos)
					local pos_str = minetest.pos_to_string(epic.to_relative_pos(pos, vector.add(punch_pos, {x=0, y=0.5, z=0})))
					meta:set_string("pos", pos_str)
					minetest.chat_send_player(playername, "[epic] target position successfully set to " .. pos_str)
					update_formspec(meta)
				end
			})
		end

		if fields.showpos then
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			if target_pos then
				epic.show_waypoint(
					sender:get_player_name(),
					epic.to_absolute_pos(pos, target_pos),
					"Target position", 2
				)
			end
		end
  end,

	allow_metadata_inventory_put = epic.allow_metadata_inventory_put,
	allow_metadata_inventory_take = epic.allow_metadata_inventory_take,

	-- allow mesecons triggering
	mesecons = {
		effector = {
	    action_on = function (pos)
				local meta = minetest.get_meta(pos)
				do_add_item(pos, meta)
			end
	  }
	},

	epic = {
    on_enter = function(pos, meta, _, ctx)
			do_add_item(pos, meta)
			ctx.next()
    end
  }
})
