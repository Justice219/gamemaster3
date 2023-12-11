gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx
    
    local tool = GM3Module.new(
        "Levitate",
        "Levitates a player, make sure their name is correct! THIS is dangerous and will send them high in the air!", 
        "Justice#4956",
        {
            ["Name/SteamID"] = {
                type = "string",
                def = "Garry"
            },
            ["Duration"] = {
                type = "number",
                def = 5
            },
        },
        function(ply, args)
            for k,v in pairs(player.GetAll()) do
                if v:Nick() == args["Name/SteamID"] or v:SteamID() == args["Name/SteamID"] then
                    v:SetGravity(-1)
                    net.Start("gm3:net:stringConCommand")
                    net.WriteString("+jump")
                    net.Send(v)
                    timer.Simple(args["Duration"], function()
                        if IsValid(v) then
                            v:SetGravity(1)
                            net.Start("gm3:net:stringConCommand")
                            net.WriteString("-jump")
                            net.Send(v)
                        end
                    end)
                end
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Levitate",["color2"] = Color(255,255,255),["text"] = "Attempted to levitate " .. args["Name/SteamID"],
                    ["ply"] = ply
                })
            end
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx


end