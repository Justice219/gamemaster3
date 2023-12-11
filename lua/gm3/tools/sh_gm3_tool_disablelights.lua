gm3 = gm3

if SERVER then
    gm3 = gm3
    gm3.lightData = false

    lyx = lyx
    
    local tool = GM3Module.new(
        "Disable Lights",
        "Disable all lights in the map. Super buggy with events that have a ton of props places down, as they dont have their shadows returned after reenabling lights.", 
        "Justice#4956",
        {},
        function(ply, args)
            if gm3.lightData then
                gm3.lightData = false
                
                engine.LightStyle(0, "m")
                net.Start("gm3:tools:enableLights")
                net.Broadcast()
    
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Lights",["color2"] = Color(255,255,255),["text"] = "Lights are now enabled!",
                    ["ply"] = ply
                })
            else    
                gm3.lightData = true
    
                engine.LightStyle(0, "a")
                net.Start("gm3:tools:enableLights")
                net.Broadcast()
                
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Lights",["color2"] = Color(255,255,255),["text"] = "Lights are now disabled!",
                    ["ply"] = ply
                })
            end
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx

    gm3.Logger:Log("Loading client-side code for Disable Lights")
end