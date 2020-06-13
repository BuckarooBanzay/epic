
local update_formspec = function(meta)
	meta:set_string("formspec", "size[8,1;]" ..
		"button_exit[0.1,0.2;8,1;execute;Execute]")
end

minetest.register_node("epic:function", {
	description = "Epic function block: start-block for further epic blocks",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_go.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	epic = {
    on_enter = function(_, _, _, ctx)
      ctx.next()
    end
  },

  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender then
			return
		end

		if not minetest.check_player_privs(sender, "epic_debug") then
			-- direct call not allowed
			return
		end

		if minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.execute then
			local name = "function@" .. minetest.pos_to_string(pos)
      epic.execute_epic(sender, pos, name)
    end

  end

})
