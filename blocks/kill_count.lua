
local HUD_POSITION = {x = epic.hud.posx, y = epic.hud.posy}
local HUD_ALIGNMENT = {x = 1, y = 0}

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

      ctx.step_data.hud_kills = player:hud_add({
        hud_elem_type = "text",
        position = HUD_POSITION,
        offset = {x = 0,   y = 40},
        text = "",
        alignment = HUD_ALIGNMENT,
        scale = {x = 100, y = 100},
        number = 0x0000FF
      })

    end,
    on_check = function(_, _, player, ctx)
      local count = kill_counter[player:get_player_name()]
      local txt = "Kills: " .. ctx.step_data.kills .. "/" .. count

      player:hud_change(ctx.step_data.hud_kills, "text", txt)
      if count >= ctx.step_data.kills then
        ctx.next()
      end
    end,
    on_exit = function(_, _, player, ctx)
      player:hud_remove(ctx.step_data.hud_kills)
    end
  }
})

local function check_kill(target, hitter, time_from_last_punch, tool_capabilities)
  if not hitter or not hitter:is_player() then
    return
  end

  local hit = minetest.get_hit_params(target:get_armor_groups(), tool_capabilities, time_from_last_punch)
  local damage = hit.hp

  if damage >= target:get_hp() then
    local name = hitter:get_player_name()
    kill_counter[name] = kill_counter[name] + 1
  end
end

-- players
minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities)
  -- player got hit by another player
  check_kill(player, hitter, time_from_last_punch, tool_capabilities)
end)

-- mobs
minetest.register_on_mods_loaded(function()
  for _,entity in pairs(minetest.registered_entities) do
    if entity.on_punch ~= nil and entity.hp_min ~= nil and entity.hp_min > 0 then
      local originalPunch = entity.on_punch
      entity.on_punch = function(self, hitter, time_from_last_punch, tool_capabilities, direction)
        check_kill(self, hitter, time_from_last_punch, tool_capabilities)
        return originalPunch(self, hitter, time_from_last_punch, tool_capabilities, direction)
      end
    end
  end
end)
