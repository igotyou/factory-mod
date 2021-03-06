f_constants.turbine = {name = minetest.get_current_modname()..":turbine", max_steam_pull = 10, watt_per_steam = 200}

local function turbine_node_timer(pos, elapsed)
    local connected_pipes = f_util.find_neighbor_pipes(pos)

    if table.getn(connected_pipes) > 0 then
        local steam_per_pipe = f_constants.turbine.max_steam_pull*elapsed / table.getn(connected_pipes)
        local extracted = 0
        for i, pipe in pairs(connected_pipes) do
            extracted = extracted + f_steam.extract_steam(pipe, steam_per_pipe)
        end
        local produced_watts = extracted*f_constants.turbine.watt_per_steam
        minetest.chat_send_all("Extracted " .. extracted .. " Units of steam, generated " .. produced_watts .. " Watts")
        if extracted > 0 then return true else return false end
    else return false
    end
end

function turbine.get_reg_values()
    return f_constants.turbine.name, {
        description = "Turbine",
        tiles = {"^[colorize:#48a832"},
        groups = {choppy = 2, oddly_breakable_by_hand = 2, wood = 1},
        on_timer = turbine_node_timer,
        after_place_node = function(pos, placer, itemstack, pointed_thing)
        end,
        on_destruct = function (pos)
        end,
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            local timer = minetest.get_node_timer(pos)
            timer:start(1.0) -- in seconds
        end,
    }
end