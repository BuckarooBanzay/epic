-- allow_metadata_inventory* helpers


epic.allow_metadata_inventory_put = function(pos, _, _, stack, player)
  if minetest.is_protected(pos, player:get_player_name()) then
    return 0
  end
  return stack:get_count()
end


epic.allow_metadata_inventory_take = function(pos, _, _, stack, player)
  if minetest.is_protected(pos, player:get_player_name()) then
    return 0
  end
  return stack:get_count()
end
