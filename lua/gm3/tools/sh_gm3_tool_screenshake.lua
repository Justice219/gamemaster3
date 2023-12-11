gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx

    local tool = GM3Module.new(
        "Screenshake",
        "Shakes the server's screen", 
        "Justice#4956",
        {
            ["Magnitude"] = {
                type = "number",
                def = 5
            },
            ["Duration"] = {
                type = "number",
                def = 5
            },
        },
        function(ply, args)
            local magnitude = args["Magnitude"] or 5
            local duration = args["Duration"] or 5

            util.ScreenShake(Vector(0,0,0), magnitude, 5, duration, 9999999)
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx


end