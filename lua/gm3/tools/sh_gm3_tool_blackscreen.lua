gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx

    lyx:NetAdd("gm3:tools:blackscreen", {})

    local tool = GM3Module.new(
        "Black Screen",
        "Makes the screen black for a certain amount of time.", 
        "Justice#4956",
        {
            ["Duration"] = {
                type = "number",
                def = 10
            },
            ["Fade Time"] = {
                type = "number",
                def = 75
            },
        },
        function(ply, args)
            net.Start("gm3:tools:blackscreen")
            net.WriteTable(gm3.ranks)
            net.WriteInt(args["Duration"], 32)
            net.WriteInt(args["Fade Time"], 32)
            net.Broadcast()

            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Black Screen",["color2"] = Color(255,255,255),["text"] = "Black Screen toggled",
                ["ply"] = ply
            })
        end)
    gm3:addTool(tool)
end

--! THIS CODE IS DIRECTLY TAKEN FROM THE OTHER GM2 ADDON.
--+ THIS IMPLEMENTATION IS TERRIBLE, AND SHOULD BE REWRITTEN.
--+ IF YOU FEEL LIKE REWRITING THIS MESSAGE ME :)
if CLIENT then
    lyx = lyx
    gm3 = gm3

    gm3.data = gm3.data or {}
    gm3.blackData = gm3.blackData or {}
    
    local function blackScreen(time, fade, isStaff)
        if isStaff then
            if !LocalPlayer().gm3_blackscreen then
                local alpha = 0
                local lerp = false
                LocalPlayer().gm3_blackscreen = true
            
                local black = vgui.Create("DFrame")
                black:SetSize(ScrW(), ScrH())
                black:Center()
                black:SetTitle("")
                black:ShowCloseButton(false)
                black:SetDraggable(false)
                black:SetAlpha(0)
                black.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
                end
                table.insert(gm3.blackData, #gm3.blackData, black)
                black.Think = function()
                    if alpha < 255 then
                        alpha = math.Clamp(alpha + (fade * FrameTime()), 0, 150)
                        black:SetAlpha(alpha)
                        lerp = true
                    end
                    timer.Simple(time, function()
                        if lerp == true then
                            alpha = math.Clamp(alpha - (fade * FrameTime()), 0, 150)
                            if IsValid(black) then
                                black:SetAlpha(alpha)
                            end
                        end
                        if alpha <= 0 then
                            lerp = false
                            black:Remove()
                        end
                    end)
                end
                LocalPlayer().gm3_blackscreen = true
            else
                for k,v in pairs(gm3.blackData) do
                    if IsValid(v) then
                        k = nil
                        v:Remove()
                    end
                end
                LocalPlayer().gm3_blackscreen = false
            end
        else
            if !LocalPlayer().gm3_blackscreen then
                local alpha = 0
                local lerp = false
                LocalPlayer().gm3_blackscreen = true
            
                local black = vgui.Create("DFrame")
                black:SetSize(ScrW(), ScrH())
                black:Center()
                black:SetTitle("")
                black:ShowCloseButton(false)
                black:SetDraggable(false)
                black:SetAlpha(0)
                black.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
                end
                table.insert(gm3.blackData, #gm3.blackData, black)
                black.Think = function()
                    if alpha < 255 then
                        alpha = math.Clamp(alpha + (fade * FrameTime()), 0, 255)
                        black:SetAlpha(alpha)
                        lerp = true
                    end
                    timer.Simple(time, function()
                        if lerp == true then
                            alpha = math.Clamp(alpha - (fade * FrameTime()), 0, 255)
                            if IsValid(black) then
                                black:SetAlpha(alpha)
                            end
                        end
                        if alpha <= 0 then
                            lerp = false
                            black:Remove()
                        end
                    end)
                end
                LocalPlayer().gm3_blackscreen = true
            else
                for k,v in pairs(gm3.blackData) do
                    if IsValid(v) then
                        k = nil
                        v:Remove()
                    end
                end
                LocalPlayer().gm3_blackscreen = false
            end
        end
    end

    lyx:NetAdd("gm3:tools:blackscreen", {
        func = function()
            local ranks = net.ReadTable()
            local time = net.ReadInt(32)
            local fade = net.ReadInt(32)
            local isStaff = false
            if ranks[LocalPlayer():GetUserGroup()] then
                isStaff = true
            end
            blackScreen(time, fade, isStaff)
        end
    })
end