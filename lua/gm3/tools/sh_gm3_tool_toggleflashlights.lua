gm3 = gm3

if SERVER then
    gm3 = gm3
    gm3.flashlightData = false
    gm3.flashlightHook = nil

    lyx = lyx
    
    local tool = GM3Module.new(
        "Toggle Flashlights",
        "Disable or enable flashlights on the server.", 
        "Justice#4956",
        {},
        function(ply, args)
            if gm3.flashlightData then
                gm3.flashlightData = false

                for k,v in pairs(player.GetAll()) do
                    v:AllowFlashlight(true)
                end

                lyx:HookRemove("PlayerInitialSpawn", gm3.flashlightHook)
            else
                gm3.flashlightData = true

                for k,v in pairs(player.GetAll()) do
                    v:AllowFlashlight(false)
                end
                
                gm3.flashlightHook = lyx:HookStart("PlayerInitialSpawn", function(...)
                    ply:AllowFlashlight(false)
                end)

            end
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Toggle Flashlights",["color2"] = Color(255,255,255),["text"] = "Toggled flashlights!",
                ["ply"] = ply
            })
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx


end