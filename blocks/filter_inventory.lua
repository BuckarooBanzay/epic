

local update_formspec = function(meta)
	meta:set_string("infotext", "Filter inventory")

	meta:set_string("formspec", "size[8,7;]" ..
		-- col 2
		"list[context;main;0,0.5;8,1;]" ..
		"list[current_player;main;0,3;8,4;]" ..
		"listring[]" ..
		"")
end

local function filter_inventory(inv, listname, filter_names)
	local list = inv:get_list(listname)
	local removed = {}
	for i, stack in ipairs(list) do
		if filter_names[stack:get_name()] then
			inv:set_stack(listname, i, ItemStack(""))
			table.insert(removed, stack)
		end
	end
	return removed
end

minetest.register_node("epic:filter_inv", {
	description = "Epic filter inventory block: filters the inventory from the given items",
	tiles = epic.create_texture("action", "epic_briefcase.png"),
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = epic.on_rotate,

	after_place_node = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8)

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

	epic = {
    on_check = function(_, meta, player, ctx)
			local inv = meta:get_inventory()
			local player_inv = player:get_inventory()

			local filter_names = {}
      local filter_items = inv:get_list("main")
      for _, filter_item in ipairs(filter_items) do
				if not filter_item:is_empty() then
					filter_names[filter_item:get_name()] = true
				end
      end


			local removed_main = filter_inventory(player_inv, "main", filter_names)
			local removed_craft = filter_inventory(player_inv, "craft", filter_names)
			local removed_string = ""
			local items_removed = false
			for _,list in pairs({removed_main,removed_craft}) do
				for _,stack in pairs(list) do
					if not stack:is_empty() then
						removed_string = removed_string .. stack:to_string() .. ", "
						items_removed = true
					end
				end
			end

			if items_removed then
				minetest.log("action", ("{ %s } filtered from %s's inventory"):format(removed_string:sub(1,-3),  player:get_player_name()))
			end

			ctx.next()

    end
  }
})
