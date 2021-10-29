

local update_formspec = function(meta)
	meta:set_string("infotext", "Stash inventory")

	meta:set_string("formspec", "size[8,7;]" ..
		-- col 2
		"list[context;main;0,0.5;8,1;]" ..
		"list[current_player;main;0,3;8,4;]" ..
		"listring[]" ..
		"")
end

minetest.register_node("epic:stash_inv", {
	description = "Epic stash inventory block: moves the player inventory temporarily away from the player",
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
		on_enter = function(pos, meta, player, ctx)
			local filter_map = {}
			local inv = meta:get_inventory()
			local filter_items = inv:get_list("main")
			local filter_items_count = 0
			for _, filter_item in ipairs(filter_items) do
				local node_name = filter_item:get_name()
				if node_name and node_name ~= "" then
					filter_items_count = filter_items_count + 1
					filter_map[node_name] = true
				end
			end

			local player_inv = player:get_inventory()
			local filter_all = filter_items_count == 0 -- no filter means stash EVERYTHING!
			local i = 1
			local stashed_string = ""
			local items_stashed = false
			local stashed_items = {}
			while i <= player_inv:get_size("main") do
				local stack = player_inv:get_stack("main", i)
				if not stack:is_empty() and filter_all or filter_map[stack:get_name()] then
					player_inv:set_stack("main", i, ItemStack(nil))
					local stack_str = stack:to_string()
					stashed_string = stashed_string .. stack_str .. ", "
					items_stashed = true
					table.insert(stashed_items, stack_str)
				end

				i = i + 1
			end

			-- save stash in player meta
			player:get_meta():set_string("epic_stash", minetest.serialize(stashed_items))

			if items_stashed then
				minetest.log("action", ("[epic::stash_inventory@%s] %s's inventory has had items stashed: { %s }")
					:format(minetest.pos_to_string(pos), player:get_player_name(), stashed_string:sub(1, -3)))
			end

			ctx.next()
		end
	}
})
