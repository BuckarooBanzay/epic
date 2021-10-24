

local update_formspec = function(meta)
	meta:set_string("infotext", "Deduct from inventory")

	meta:set_string("formspec", "size[8,7;]" ..
		-- col 2
		"list[context;main;0,0.5;8,1;]" ..
		"list[current_player;main;0,3;8,4;]" ..
		"listring[]" ..
		"")
end

minetest.register_node("epic:deduct_inv", {
	description = "Epic deduct from inventory block: removes items from the inventory",
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
    on_check = function(pos, meta, player, ctx)
			local inv = meta:get_inventory()
			local player_inv = player:get_inventory()

			local success = true
      local deduct_items = inv:get_list("main")
      for _, deduct_item in ipairs(deduct_items) do
				if not player_inv:contains_item("main", deduct_item) then
					success = false
					break
				end
      end

			if success then
				local deduct_string = ""
				local items_deducted = false
				for _, deduct_item in ipairs(deduct_items) do
					if not deduct_item:is_empty() then
						deduct_string = deduct_string .. deduct_item:to_string() .. ", "
						items_deducted = true
						player_inv:remove_item("main", deduct_item)
					end
				end
				if items_deducted then
					minetest.log("action", ("[epic::deduct_inventory@%s] { %s } deducted from %s's inventory")
						:format(minetest.pos_to_string(pos), deduct_string:sub(1,-3),  player:get_player_name()))
				end

				ctx.next()
			end

    end
  }
})
