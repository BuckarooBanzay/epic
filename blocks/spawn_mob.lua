
local mob_names = {} -- list<name>

minetest.register_on_mods_loaded(function()
	for i,item in pairs(minetest.registered_items) do
		if item.groups.spawn_egg == 1 then
			table.insert(mob_names, item.name)
		end
	end
end)

-- playername => pos
local punch_handler = {}

local update_formspec = function(meta, pos)
	local pos = meta:get_string("pos")
	local mobname = meta:get_string("mobname")

	meta:set_string("infotext", "Spawn mob block: pos=" .. pos ..
		" mobname: '" .. mobname .. "'")


	local selected = 1
	local list = ""
	for i,name in ipairs(mob_names) do
		if name == mobname then
			selected = i
		end

		list = list .. minetest.formspec_escape(name)
		if i < #mob_names then
			-- not end of list
			list = list .. ","
		end
	end

	meta:set_string("formspec", "size[8,7;]" ..
		"textlist[0,0.1;8,5;mobname;" .. list .. ";" .. selected .. "]" ..
		"button_exit[0.1,5.5;8,1;setpos;Set position]" ..
		"button_exit[0.1,6.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:spawn_mob", {
	description = "Epic Spawn mob block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_mob.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("pos", minetest.pos_to_string(pos))
		meta:set_string("mobname", "")
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, formname, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end


		if fields.setpos then
			minetest.chat_send_player(sender:get_player_name(), "[epic] Please punch the desired target position")
			punch_handler[sender:get_player_name()] = pos
		end

		if fields.mobname then
			local parts = fields.mobname:split(":")
			if parts[1] == "CHG" then
				local selected_mob = tonumber(parts[2])
				meta:set_string("mobname", mob_names[selected_mob])
				minetest.chat_send_all("Selected: " .. mob_names[selected_mob])
				update_formspec(meta, pos)
			end
		end

  end,

	epic = {
    on_enter = function(pos, meta, player, ctx)
			local target_pos = minetest.string_to_pos(meta:get_string("pos"))
			local mobname = meta:get_string("mobname")

			if mobname and mobname ~= "" then
				minetest.add_entity(target_pos, mobname)
			end
			ctx.next()
    end
  }
})

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	local playername = puncher:get_player_name()
	local cfg_pos = punch_handler[playername]
	if cfg_pos then
		local meta = minetest.get_meta(cfg_pos)
		local pos_str = minetest.pos_to_string(vector.add(pos, {x=0, y=1.5, z=0}))
		meta:set_string("pos", pos_str)
		minetest.chat_send_player(playername, "[epic] target position successfully set to " .. pos_str)
		punch_handler[playername] = nil
	end
end)

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	punch_handler[playername] = nil

end)