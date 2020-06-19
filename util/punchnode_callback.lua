-- punch configuration utility helper

-- playername -> punchDef
local punch_handler = {}

--[[
Registers a punch-configuration callback:

epic.punchnode_callback({
  nodes = {"default:dirt"},
  timeout = 300,
  check_protection = true,
  callback = function(pos, node) end
})
--]]
function epic.punchnode_callback(player, punchDef)
  local playername = player:get_player_name()
  punch_handler[playername] = punchDef
end


minetest.register_on_punchnode(function(pos, node, puncher)
	local playername = puncher:get_player_name()
  local punchDef = punch_handler[playername]

  -- abort if no callback waiting
  if not punchDef then
    return
  end

  -- TODO: check timeout

  -- clear callback
  punch_handler[playername] = nil

  if punchDef.check_protection then
    if minetest.is_protected(pos, playername) and
      not minetest.check_player_privs(playername, {epic_admin=true}) then
        minetest.chat_send_player(playername, "[epic] target is protected! aborting selection.")
      return
    end
  end

  -- check valid nodes
  local valid_node = false

  if punchDef.nodes then
    -- go through list
    for _, nodename in ipairs(punchDef.nodes) do
      if node.name == nodename then
        valid_node = true
        break
      end
    end
  else
    -- all nodes valid
    valid_node = true
  end

  if not valid_node then
    minetest.chat_send_player(playername, "[epic] target node invalid! valid types: " .. dump(punchDef.nodes))
    return
  end

  punchDef.callback(pos, node)
end)

-- cleanup
minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	punch_handler[playername] = nil
end)
