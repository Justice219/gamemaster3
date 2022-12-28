gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx

    lyx:NetAdd("gm3:tools:opsatRemove", {})
    lyx:NetAdd("gm3:tools:opsatSet", {})

    local opsatHook = nil

    local tool = GM3Module.new(
        "Opsat",
        "Objective like board on the screen", 
        "Justice#4956",
        {
            ["Title 1"] = {
                type = "string",
                def = "Information"
            },
            ["Line 1"] = {
                type = "string",
                def = "Planet: KG3"
            },
            ["Line 2"] = {
                type = "string",
                def = "Era: 22BBY"
            },
            ["Title 2"] = {
                type = "string",
                def = "Objective"
            },
            ["Line 3"] = {
                type = "string",
                def = "- Kill Someone"
            },
            ["Line 4"] = {
                type = "string",
                def = "- Raid Base"
            },
        },
        function(ply, args)
            if args["Title 1"] == "" then
                net.Start("gm3:tools:opsatRemove")
                net.WriteTable(args)
                net.Broadcast()
    
                if opsatHook then
                    lyx:HookRemove("PlayerInitialSpawn", opsatHook)
                end
            else            
                net.Start("gm3:tools:opsatSet")
                net.WriteTable(args)
                net.Broadcast()
    
                if !opsatHook then
                    opsatHook = lyx:HookStart("PlayerInitialSpawn", function(...)
                        local args = {...}
                        net.Start("gm3:tools:opsatSet")
                        net.WriteTable(args)
                        net.Broadcast()
                    end)
                end

                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Opsat",["color2"] = Color(255,255,255),["text"] = "Opsat has been set!",
                    ["ply"] = ply
                })
            end
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    gm3.opsatData = gm3.opsatData or {}

    lyx = lyx

    local function Opsat(args, method)
        local function ScaleW(size)
            return ScrW() * size/1920
        end
        local function ScaleH(size)
            return ScrH() * size/1080        
        end
    
        surface.CreateFont("gm_opsat_font", {
            font = "Roboto",
            size = ScreenScale(10),
            weight = 500,
            antialias = true,
            shadow = false
        })
    
        if method == "set" then
            for k,v in pairs(gm3.opsatData) do
                k = nil
                v:Remove()
            end
    
            local back = vgui.Create("DPanel")
            back:SetSize(ScrW(), ScrH())
            back:SetPos(ScaleW(1550), ScaleH(0))
            back:SetBackgroundColor(color_black)
            back.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, ScaleH(115), ScaleW(325), ScaleH(400), Color(41,41,41, 200) )
            end
            table.insert(gm3.opsatData, #gm3.opsatData, back)
    
            side1 = back:Add("DPanel")
            side1:SetPos(ScaleW(0), ScaleH(115))
            side1:SetSize(ScaleW(325), ScaleH(5))
            side1.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, ScaleW(325), ScaleH(5), Color(255,255,255, 200) )
            end
    
            side2 = back:Add("DPanel")
            side2:SetPos(ScaleW(0), ScaleH(115))
            side2:SetSize(ScaleW(325), ScaleH(5))
            side2.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, ScaleW(325), ScaleH(5), Color(255,255,255, 200) )
            end
    
            side3 = back:Add("DPanel")
            side3:SetPos(ScaleW(0), ScaleH(515))
            side3:SetSize(ScaleW(325), ScaleH(5))
            side3.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, ScaleW(325), ScaleH(5), Color(255,255,255, 200) )
            end
    
            side4 = back:Add("DPanel")
            side4:SetPos(ScaleW(0), ScaleH(120))
            side4:SetSize(ScaleW(5), ScaleH(400))
            side4.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, ScaleW(325), ScaleH(515), Color(255,255,255, 200) )
            end
    
            side5 = back:Add("DPanel")
            side5:SetPos(ScaleW(320), ScaleH(120))
            side5:SetSize(ScaleW(5), ScaleH(400))
            side5.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, ScaleW(325), ScaleH(515), Color(255,255,255, 200) )
            end
    
            label = back:Add("DLabel")
            label:SetParent(back)
            label:SetPos(ScaleW(20), ScaleH(130))
            label:SetSize(ScaleW(300), ScaleH(50))
            label:SetText(args["Title 1"])
            label:SetFont("gm_opsat_font")
    
            label = back:Add("DPanel")
            label:SetPos(ScaleW(10), ScaleH(170))
            label:SetSize(ScaleW(300), ScaleH(5))
            label.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, ScaleW(300), ScaleH(5), Color(255,255,255, 200) )
            end
    
            text1 = back:Add("DLabel")
            text1:SetParent(back)
            text1:SetPos(ScaleW(20), ScaleH(170))
            text1:SetSize(ScaleW(300), ScaleH(50))
            text1:SetText(args["Line 1"])
    
            text2 = back:Add("DLabel")
            text2:SetParent(back)
            text2:SetPos(ScaleW(20), ScaleH(190))
            text2:SetSize(ScaleW(300), ScaleH(50))
            text2:SetText(args["Line 2"])
    
            title2 = back:Add("DLabel")
            title2:SetParent(back)
            title2:SetPos(ScaleW(20), ScaleH(230))
            title2:SetSize(ScaleW(300), ScaleH(50))
            title2:SetText(args["Title 2"])
            title2:SetFont("gm_opsat_font")
    
            label = back:Add("DPanel")
            label:SetPos(ScaleW(10), ScaleH(270))
            label:SetSize(ScaleW(300), ScaleH(5))
            label.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, ScaleW(300), ScaleH(5), Color(255,255,255, 200) )
            end
    
            text3 = back:Add("DLabel")
            text3:SetParent(back)
            text3:SetPos(ScaleW(20), ScaleH(270))
            text3:SetSize(ScaleW(300), ScaleH(50))
            text3:SetText(args["Line 3"])
    
            text4 = back:Add("DLabel")
            text4:SetParent(back)
            text4:SetPos(ScaleW(20), ScaleH(290))
            text4:SetSize(ScaleW(300), ScaleH(50))
            text4:SetText(args["Line 4"])
        elseif method == "remove" then
            for k,v in pairs(gm3.opsatData) do
                k = nil
                v:Remove()
            end
        end
    
    end

    lyx:NetAdd("gm3:tools:opsatRemove", {
        func = function()   
            Opsat({}, "remove") 
        end
    })
    lyx:NetAdd("gm3:tools:opsatSet", {
        func = function()
            local data = net.ReadTable()
            PrintTable(data)

            Opsat(data, "set")
        end
    })

end