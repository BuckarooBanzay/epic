
epic.skyboxes = {} -- list<skyboxdef>

--[[
skyboxdef = {
	name = "",
	color = {r=0, g=0, b=0},
	textures = {}
}
--]]

-- register a new skybox
epic.register_skybox = function(skyboxdef)
	table.insert(epic.skyboxes, skyboxdef)
end

-- sets a players skybox
function epic.set_skybox(player, skyboxdef)
	if skyboxdef.textures then
		player:set_sky({r=0, g=0, b=0}, "skybox", skyboxdef.textures)
	elseif skyboxdef.color then
		player:set_sky(skyboxdef.color, "plain", {})
	else
		player:set_sky({r=0, g=0, b=0}, "regular", {})
	end
end

-- common (plain) skyboxes
epic.register_skybox({ name = "default" })

epic.register_skybox({
  name = "Plain Black",
	color = {r=0, g=0, b=0}
})

epic.register_skybox({
  name = "Plain Red",
	color = {r=255, g=0, b=0}
})

epic.register_skybox({
  name = "Plain Green",
	color = {r=0, g=255, b=0}
})

epic.register_skybox({
  name = "Plain Blue",
	color = {r=0, g=0, b=255}
})

epic.register_skybox({
  name = "Plain White",
	color = {r=255, g=255, b=255}
})


minetest.register_chatcommand("skybox_list", {
	description = "Lists all available skyboxes",
	func = function()
		local list = ""
		for _, skyboxdef in ipairs(epic.skyboxes) do
			list = list .. skyboxdef.name .. ","
		end

		return true, list
	end
})
