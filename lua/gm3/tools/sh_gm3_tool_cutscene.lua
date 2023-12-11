gm3 = gm3

if SERVER then
    gm3 = gm3
    gm3.cutscene = gm3.cutscene or false

    lyx = lyx
    
    local tool = GM3Module.new(
        "Cutscene",
        "Globally broadcasts a cutscene! Only works if the player is using the Chrominum x64 Branch of Garry's Mod. Use the =1s on the youtube url to specify the time to start the video at.", 
        "Justice#4956",
        {
            ["Youtube URL"] = {
                type = "string",
                def = "https://www.youtube.com/watch?v=jiLdDQ6R3bI&t=1s"
            },
        },  
        function(ply, args)
            if gm3.cutscene then
                gm3.cutscene = false 
                lyx:VideoStopBroadcast()
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Cutscene",["color2"] = Color(255,255,255),["text"] = "Stopping cutscene...",
                    ["ply"] = ply
                })
            else
                gm3.cutscene = true
                lyx:VideoBroadcast(args["Youtube URL"], {
                    width = 1920,
                    height = 1080,
                })
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Cutscene",["color2"] = Color(255,255,255),["text"] = "Playing cutscene...",
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