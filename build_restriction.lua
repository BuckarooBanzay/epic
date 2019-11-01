
minetest.register_on_mods_loaded(function()
  for name, nodedef in pairs(minetest.registered_nodes) do
    if nodedef.epic then
      minetest.override_item(name, {
        on_place = function(itemstack, placer, pointed_thing)
          local playername = (placer and placer:get_player_name()) or ""
          if not minetest.check_player_privs(playername, {epic_builder=true}) then
            minetest.chat_send_player(playername, "[epic] placing this requires the 'epic_builder' priv!")
            return
          end
          return minetest.item_place(itemstack, placer, pointed_thing)
        end
      })
    end
  end
end)
