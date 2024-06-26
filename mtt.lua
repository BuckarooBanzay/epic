
-- param0 == 0: execution in the X+ direction

minetest.get_player_by_name = function(name)
	if name == "testuser" then
		return {
			get_player_name = function() return name end,
			hud_add = function() return 0 end,
			hud_change = function() end,
			hud_remove = function() end
		}
	end
end

local sent_messages = {}
minetest.chat_send_player = function(name, message)
	sent_messages[name] = message
end

local pos1 = { x=-50, y=100, z=-50}
local pos2 = { x=50, y=150, z=50 }

mtt.emerge_area(pos1, pos2)

mtt.register("setup_simple", function(callback)
	minetest.set_node({ x=0, y=110, z=0 }, { name = "epic:epic" })
	local meta = minetest.get_meta({ x=0, y=110, z=0 })
	meta:set_string("owner", "admin")
	meta:set_string("name", "")
	meta:set_int("time", "600")
	meta:set_string("main_pos", minetest.pos_to_string({ x=2, y=0, z=0 }))

	minetest.set_node({ x=2, y=110, z=0 }, { name = "epic:function" })

	minetest.set_node({ x=3, y=110, z=0 }, { name = "epic:message" })
	meta = minetest.get_meta({ x=3, y=110, z=0 })
	meta:set_string("text", "test123")

	epic.start("testuser", { x=0, y=110, z=0 })

	minetest.after(2, function()
		assert(sent_messages["testuser"] == "test123")
		callback()
	end)
end)
