
local next_fn

minetest = {
  after = function(_, fn)
    next_fn = fn
  end,

  get_modpath = function(name)
    if name == "epic" then
      return "."
    else
      return nil
    end
  end,

  get_worldpath = function()
    return "."
  end,

  register_node = function() end,
  register_on_punchnode = function() end,
  register_on_punchplayer = function() end,
  register_on_mods_loaded = function() end,
  register_on_player_receive_fields = function() end,
  register_on_joinplayer = function() end,
  register_on_leaveplayer = function() end,
  register_on_dieplayer = function() end,
  register_privilege = function() end,
  register_chatcommand = function() end,

  get_connected_players = function()
    return {}
  end,

  global_exists = function() end,
  mkdir = function() end,

  get_us_time = function()
    return 1000
  end,

  registered_nodes = {},

  settings = {
    get_bool = function() end,
    get = function() end,
  }
}

screwdriver = {}


dofile("./init.lua")

assert(next_fn)
next_fn()
