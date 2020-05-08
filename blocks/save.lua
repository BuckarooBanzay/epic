-- playername => pos
local punch_handler = {}

local update_formspec = function(meta)
	local topic = meta:get_string("topic")
	local name = meta:get_string("name")

	meta:set_string("infotext", "Savegame block: '" .. topic .. "/" .. name .. "'")

	meta:set_string("formspec", "size[8,4;]" ..
		"field[0.2,0.5;8,1;topic;Topic;" .. topic .. "]" ..

		"field[0.2,1.5;8,1;name;Name;" .. name .. "]" ..

		"button_exit[0.1,2.1;4,1;setpos;Set position]" ..
		"button_exit[4.1,2.1;4,1;showpos;Show]" ..

		"button_exit[0.1,3.5;8,1;save;Save]" ..
		"")
end


minetest.register_node("epic:save", {
	description = "Epic save block: stores a savegame for the player, the target can be an epic-block " ..
		"to continue the quest at that point",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_save.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("pos", minetest.pos_to_string({x=0, y=1, z=0}))
		meta:set_string("topic", "My maze")
		meta:set_string("name", "Level 1")
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

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

    if fields.save then
			meta:set_string("topic", fields.topic or "My maze")
			meta:set_string("name", fields.name or "Level 1")
			update_formspec(meta, pos)
    end

  end,

  epic = {
    on_enter = function(pos, meta, player, ctx)
			local playername = player:get_player_name()
			local topic = meta:get_string("topic")
			local name = meta:get_string("name")

			local savegame = epic.savegame.load(playername)
			savegame[topic] = savegame[topic] or {}
			savegame[topic][name] = pos

			epic.savegame.save(playername, savegame)

			minetest.chat_send_player(playername, "[epic] Game state '" .. topic .. "/" .. name .. "' saved!")
			ctx.next()
    end
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
