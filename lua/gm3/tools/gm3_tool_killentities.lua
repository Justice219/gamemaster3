gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx
    
    local tool = GM3Module.new(
        "Kill Entites",
        "Kills all of a given entity class", 
        "Justice#4956",
        {
            ["Entity Path"] = {
                type = "string",
                def = "npc_monk"
            },
        },
        function(ply, args)
            for k,v in pairs(ents.GetAll()) do
                if v:GetClass() == args["Entity Path"] then
                    v:Remove()
                end

            end
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Kill Entities",["color2"] = Color(255,255,255),["text"] = "Killed all entities of class " .. args["Entity Path"] .. "!",
                ["ply"] = ply
            })
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx


end