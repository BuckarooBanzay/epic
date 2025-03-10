function epic.chat_send_player(playername, msg)
    minetest.chat_send_player(playername, minetest.colorize("#00FF00", "[epic] ") .. msg)
end