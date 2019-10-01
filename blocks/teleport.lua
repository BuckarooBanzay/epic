
-- playername => pos
local punch_handler = {}

local update_formspec = function(meta)
	local pos = meta:get_string("pos")

	meta:set_string("infotext", "Teleport block: pos=" .. pos)

	meta:set_string("formspec", "size[8,1;]" ..
		-- col 2
		"button_exit[0.1,0.5;8,1;setpos;Set position]" ..
		"")
end

minetest.register_node("epic:teleport", {
	description = "Epic Teleport block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_teleport.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("pos", minetest.pos_to_string(pos))
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end


		if fields.setpos then
			minetest.chat_send_player(sender:get_player_name(), "[epic] Please punch the desired target position")
			punch_handler[sender:get_player_name()] = pos
		end

  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			player:set_pos(target_pos)
			ctx.next()
    end
  }
})

minetest.register_on_punchnode(function(pos, _, puncher, _)
	local playername = puncher:get_player_name()
	local cfg_pos = punch_handler[playername]
	if cfg_pos then
		local meta = minetest.get_meta(cfg_pos)
		local pos_str = minetest.pos_to_string(vector.add(pos, {x=0, y=0.5, z=0}))
		meta:set_string("pos", pos_str)
		minetest.chat_send_player(playername, "[epic] target position successfully set to " .. pos_str)
		punch_handler[playername] = nil
	end
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	punch_handler[playername] = nil

end)
