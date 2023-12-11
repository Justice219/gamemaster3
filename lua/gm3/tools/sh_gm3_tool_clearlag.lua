gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx
    
    local tool = GM3Module.new(
        "Clear Lag",
        "Attempts to clear a server's lag by removing all ragdolls, effects, and npc weapons. \n " ..
        "depending on the server and certain factors, this may not work for you. \n" ..
        "This tool is meant to be used as a LAST RESORT. \n", 
        "Justice#4956",
        {},
        function(ply, args)
            for k, v in pairs(ents.GetAll()) do
                if v:IsRagdoll() or v:IsWeapon() then
                    v:Remove()
                end
            end

            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Clear Lagg",["color2"] = Color(255,255,255),["text"] = "Attempting to clear lag...",
                ["ply"] = ply
            })
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx


end