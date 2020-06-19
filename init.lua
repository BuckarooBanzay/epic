
epic = {
	log_executor = minetest.settings:get_bool("epic.log_executor"),

	-- playername => player_state
	state = {},

	hud = {
		posx = tonumber(minetest.settings:get("epic.hud.offsetx") or 0.5),
		posy = tonumber(minetest.settings:get("epic.hud.offsety") or 0.2)
	}
}

local MP = minetest.get_modpath("epic")

-- common stuff
dofile(MP.."/privs.lua")
dofile(MP.."/common.lua")
dofile(MP.."/chatcommands.lua")
dofile(MP.."/state.lua")
dofile(MP.."/executor/executor.lua")
dofile(MP.."/executor/executor_hooks.lua")
dofile(MP.."/executor/executor_hud.lua")
dofile(MP.."/trace.lua")

-- utilities
dofile(MP.."/util/savegame.lua")
dofile(MP.."/util/punchnode_callback.lua")

-- forms
epic.form = {}
dofile(MP.."/forms/epic_configure.lua")
dofile(MP.."/forms/epic_view.lua")
dofile(MP.."/forms/epic_savegame_load.lua")
dofile(MP.."/forms/epic_savegame_load_configure.lua")

-- blocks
dofile(MP.."/blocks/epic.lua")
dofile(MP.."/blocks/nop.lua")
dofile(MP.."/blocks/on_exit.lua")
dofile(MP.."/blocks/on_abort.lua")
dofile(MP.."/blocks/function.lua")
dofile(MP.."/blocks/message.lua")
dofile(MP.."/blocks/waypoint.lua")
dofile(MP.."/blocks/waypoint_inverse.lua")
dofile(MP.."/blocks/teleport.lua")
dofile(MP.."/blocks/teleport_relative.lua")
dofile(MP.."/blocks/command.lua")
dofile(MP.."/blocks/delay.lua")
dofile(MP.."/blocks/call.lua")
dofile(MP.."/blocks/stats.lua")
dofile(MP.."/blocks/review.lua")
dofile(MP.."/blocks/branch.lua")
dofile(MP.."/blocks/kill_count.lua")
dofile(MP.."/blocks/send_mapblock.lua")
dofile(MP.."/blocks/set_node.lua")
dofile(MP.."/blocks/set_param2.lua")
dofile(MP.."/blocks/set_clouds.lua")
dofile(MP.."/blocks/set_gravity.lua")
dofile(MP.."/blocks/set_day_night.lua")
dofile(MP.."/blocks/add_item.lua")
dofile(MP.."/blocks/remove_item.lua")
dofile(MP.."/blocks/lock.lua")
dofile(MP.."/blocks/unlock.lua")
dofile(MP.."/blocks/settimeout.lua")
dofile(MP.."/blocks/save.lua")
dofile(MP.."/blocks/load.lua")
dofile(MP.."/blocks/random.lua")
dofile(MP.."/blocks/fill_chest.lua")
dofile(MP.."/blocks/stash_inventory.lua")
dofile(MP.."/blocks/unstash_inventory.lua")
dofile(MP.."/blocks/deduct_inventory.lua")
dofile(MP.."/blocks/filter_inventory.lua")
dofile(MP.."/blocks/check_empty_inventory.lua")
dofile(MP.."/blocks/check_empty_armor.lua")

if minetest.get_modpath("mobs") then
	dofile(MP.."/blocks/spawn_mob.lua")
end

if minetest.get_modpath("signs") then
	dofile(MP.."/compat/signs_paper_poster.lua")
end

if minetest.get_modpath("soundblock") then
	dofile(MP.."/blocks/play_sound.lua")
	dofile(MP.."/blocks/loop_sound.lua")
end

if minetest.get_modpath("mesecons") then
	dofile(MP.."/blocks/mesecon_emit.lua")
	dofile(MP.."/blocks/mesecon_check.lua")
end

if minetest.get_modpath("digilines") then
	dofile(MP.."/blocks/digiline_emit.lua")
end

if minetest.get_modpath("lightning") then
	dofile(MP.."/blocks/lightning.lua")
end

if minetest.get_modpath("monitoring") then
	dofile(MP.."/monitoring.lua")
end

if minetest.settings:get_bool("epic.build_restrictions") then
	dofile(MP.."/build_restriction.lua")
end

if epic.log_executor then
	dofile(MP.."/log_executor.lua")
end

if minetest.settings:get_bool("enable_epic_integration_test") then
        dofile(MP.."/integration_test.lua")
end
