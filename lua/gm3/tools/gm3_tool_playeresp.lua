gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx
    
    local tool = GM3Module.new(
        "Player ESP",
        "Gives you esp of the entire server. Run again to remove!", 
        "Justice#4956",
        {},
        function(ply, args)
            net.Start("gm3:net:clientConvar")
            if ply.gm3esp then 
                ply.gm3esp = false
                net.WriteBool(false)
            else
                ply.gm3esp = true
                net.WriteBool(true)
            end

            net.WriteString("gm3_esp")
            net.Send(ply)

            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Player ESP",["color2"] = Color(255,255,255),["text"] = "ESP Toggled!",
                ["ply"] = ply
            })
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    gm3.espData = nil

    lyx = lyx

    local function wallhack()
        if GetConVar("gm3_esp") then
            if GetConVar("gm3_esp"):GetBool() then
                for k, v in pairs (player.GetAll()) do
                    local plypos = (v:GetPos() + Vector(0,0,80)):ToScreen()
                    if v:IsAdmin() or v:IsSuperAdmin() then
                        draw.DrawText("" ..v:Name().. "[Admin]", "TabLarge", plypos.x, plypos.y, Color(220,60,90,255), 1)
                    else
                        draw.DrawText(v:Name(), "Trebuchet18", plypos.x, plypos.y, Color(255,255,255), 1)
                    end
                end
            end
        end
    end
    
    if !gm3.espData then
        gm3.espData = lyx:HookStart("HUDPaint", wallhack)
    end
end