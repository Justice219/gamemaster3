gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx
    
    local tool = GM3Module.new(
        "Lock Doors",
        "locks the entire server's doors", 
        "Justice#4956",
        {
            ["Lock"] = {
                type = "boolean",
                def = true
            }
        },
        function(ply, args)
            local lock = args["Lock"]
            if lock then
                for k,v in pairs(ents.GetAll()) do
                    if v:GetClass() == "prop_door_rotating" then
                        v:Fire("lock")
                    end
                end
            else
                for k,v in pairs(ents.GetAll()) do
                    if v:GetClass() == "prop_door_rotating" then
                        v:Fire("unlock")
                    end
                end
            end
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Cutscene",["color2"] = Color(255,255,255),["text"] = "Toggled door locks",
                ["ply"] = ply
            })
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx


end