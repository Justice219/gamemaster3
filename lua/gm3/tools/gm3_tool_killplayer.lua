gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx

    local tool = GM3Module.new(
        "Kill Player",
        "Kills a given player", 
        "Justice#4956",
        {
            ["Name/SteamID"] = {
                type = "string",
                def = "Garry Newman"
            }
        },
        function(ply, args)
            for k, v in pairs(player.GetAll()) do
                if v:Nick() == args["Name/SteamID"] or v:SteamID() == args["Name/SteamID"] then
                    lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Player Kill",["color2"] = Color(255,255,255),["text"] = "Player not found",
                        ["ply"] = ply
                    })
                    v:Kill()
                end
            end
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx


end