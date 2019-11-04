
-- player -> kills
local kill_counter = {}

local update_formspec = function(meta)
	local kills = meta:get_int("kills")
	meta:set_string("infotext", "Kill count block: " .. kills .. " kills")

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;kills;Kills;" .. kills .. "]" ..

		-- col 2
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic:kill_count", {
	description = "Epic kill count block",
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
		meta:set_int("kills", 5)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
      local kills = tonumber(fields.kills) or 5
			if kills < 0 then
				kills = 1
			end

			meta:set_int("kills", kills)
			update_formspec(meta, pos)
    end

  end,

  epic = {
    on_enter = function(_, meta, player, ctx)
      kill_counter[player:get_player_name()] = 0
      ctx.step_data.kills = meta:get_int("kills")
    end,
    on_check = function(_, _, player, ctx)
      if kill_counter[player:get_player_name()] >= ctx.step_data.kills then
        ctx.next()
      end
    end
  }
})

local function get_damage(tool_capabilities)
  return (tool_capabilities.damage_groups and tool_capabilities.damage_groups.fleshy) or 0
end

local function check_kill(target, hitter, tool_capabilities)
  local damage = get_damage(tool_capabilities)
  if hitter:is_player() and target:get_hp() <= damage then
    local name = hitter:get_player_name()
    kill_counter[name] = kill_counter[name] + 1
  end
end

minetest.register_on_punchplayer(function(player, hitter, _, tool_capabilities)
  -- player got hit by another player
  check_kill(player, hitter, tool_capabilities)
end)

minetest.register_on_mods_loaded(function()
  for _,entity in pairs(minetest.registered_entities) do
    if entity.on_punch ~= nil and entity.hp_min ~= nil and entity.hp_min > 0 then
      local originalPunch = entity.on_punch
      entity.on_punch = function(self, hitter,time_from_last_punch, tool_capabilities, direction)
        check_kill(self, hitter, tool_capabilities)
        return originalPunch(self, hitter, time_from_last_punch, tool_capabilities, direction)
      end
    end
  end
end)
