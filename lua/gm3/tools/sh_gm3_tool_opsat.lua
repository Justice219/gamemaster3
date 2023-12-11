gm3 = gm3

if SERVER then
    gm3 = gm3
    gm3.opsat = gm3.opsat or false
    lyx = lyx

    lyx:NetAdd("gm3:tools:opsatRemove", {
        func = function(ply)   
            if gm3:SecurityCheck(ply) then
                net.Start("gm3:tools:opsatRemove")
                net.Broadcast() 
                gm3.opsat = false
            end
        end
    })
    lyx:NetAdd("gm3:tools:opsatSet", {
        func = function(ply)
            local args = net.ReadTable()

            if gm3:SecurityCheck(ply) then
                net.Start("gm3:tools:opsatSet")
                net.WriteTable(args)
                net.Broadcast()
                gm3.opsat = true
                gm3.opsatData = args
            end
        end
    })
    lyx:NetAdd("gm3:tools:requestOpsat", {
        func = function(ply)
            if gm3.opsat then
                net.Start("gm3:tools:opsatSet")
                net.WriteTable(gm3.opsatData)
                net.Send(ply)
            end
        end
    })

    print("OPSAT SERVER SIDE LOADED")
end

if CLIENT then
    gm3 = gm3
    gm3.opsat = gm3.opsat or false
    gm3.opsatClientData = gm3.opsatClientData or {}
    gm3.opsatData = gm3.opsatData or {}

    lyx = lyx

    local function ScaleW(size)
        return ScrW() * size / 1920
    end
    
    local function ScaleH(size)
        return ScrH() * size / 1080
    end

    surface.CreateFont("GM3_Opsat_Title", {
        font = "Roboto",
        size = ScaleW(27),
        weight = 500,
        antialias = true,

    })
    surface.CreateFont("GM3_Opsat_SubTitle", {
        font = "Roboto",
        size = ScaleW(20),
        weight = 500,
        antialias = true
    })

    local function CreateOpsatPanel(args)
        local primaryColor = gm3.settings["gm3_opsat_primaryColor"].value
        primaryColor = Color(primaryColor.r, primaryColor.g, primaryColor.b)
        local secondaryColor = gm3.settings["gm3_opsat_secondaryColor"].value
        secondaryColor = Color(secondaryColor.r, secondaryColor.g, secondaryColor.b)

        local back = vgui.Create("DPanel")
        back:SetSize(ScaleW(325), ScaleH(150))
        back:SetPos(ScaleW(1550), ScaleH(30))
        back:TDLib():ClearPaint()
            :Background(Color(39, 38, 38))
            :BarHover(primaryColor, 4)
    
        local title1 = vgui.Create("DLabel", back)
        title1:SetFont("GM3_Opsat_Title")
        title1:SetText(args["Title 1"])
        title1:SetColor(primaryColor)
        title1:Dock(TOP)
        title1:DockMargin(ScaleW(10), ScaleH(10), ScaleW(10), ScaleH(0))
        title1:SetContentAlignment(5)

        local line1 = vgui.Create("DLabel", back)
        line1:SetFont("GM3_Opsat_SubTitle")
        line1:SetText(args["Line 1"])
        line1:SetColor(secondaryColor)
        line1:Dock(TOP)
        line1:DockMargin(ScaleW(10), ScaleH(0), ScaleW(10), ScaleH(0))
        line1:SetContentAlignment(5)

        local line2 = vgui.Create("DLabel", back)
        line2:SetFont("GM3_Opsat_SubTitle")
        line2:SetText(args["Line 2"])
        line2:SetColor(secondaryColor)
        line2:Dock(TOP)
        line2:DockMargin(ScaleW(10), ScaleH(0), ScaleW(10), ScaleH(0))
        line2:SetContentAlignment(5)

        local title2 = vgui.Create("DLabel", back)
        title2:SetFont("GM3_Opsat_Title")
        title2:SetText(args["Title 2"])
        title2:SetColor(primaryColor)
        title2:Dock(TOP)
        title2:DockMargin(ScaleW(10), ScaleH(10), ScaleW(10), ScaleH(0))
        title2:SetContentAlignment(5)

        local line3 = vgui.Create("DLabel", back)
        line3:SetFont("GM3_Opsat_SubTitle")
        line3:SetText(args["Line 3"])
        line3:SetColor(secondaryColor)
        line3:Dock(TOP)
        line3:DockMargin(ScaleW(10), ScaleH(0), ScaleW(10), ScaleH(0))
        line3:SetContentAlignment(5)

        local line4 = vgui.Create("DLabel", back)
        line4:SetFont("GM3_Opsat_SubTitle")
        line4:SetText(args["Line 4"])
        line4:SetColor(secondaryColor)
        line4:Dock(TOP)
        line4:DockMargin(ScaleW(10), ScaleH(0), ScaleW(10), ScaleH(0))
        line4:SetContentAlignment(5)



        return back
    end
    
    local function Opsat(args, method)
        if method == "set" then
            for k, v in pairs(gm3.opsatData) do
                v:Remove()
            end
    
            local opsatPanel = CreateOpsatPanel(args)
            table.insert(gm3.opsatData, #gm3.opsatData, opsatPanel)
            gm3.opsat = true
        elseif method == "remove" then
            for k, v in pairs(gm3.opsatData) do
                v:Remove()
            end
            gm3.opsat = false
        end
    end

    lyx:NetAdd("gm3:tools:opsatRemove", {
        func = function()   
            Opsat({}, "remove") 
            gm3.opsat = false
        end
    })
    lyx:NetAdd("gm3:tools:opsatSet", {
        func = function()
            local data = net.ReadTable()
            PrintTable(data)

            Opsat(data, "set")
            gm3.opsatClientData = data
            gm3.opsat = true
        end
    })

    hook.Add("ClientSignOnStateChanged", "GM3_Opsat", function(userid, oldState, newState)
        print("SIGNONSTATE: " .. newState)
        if newState == 6 then
            print("ATTEMPTING TO SYNC OPSAT")
            net.Start("gm3:tools:requestOpsat")
            net.SendToServer()
            print("OPSAT SYNCED")
        end
    end)
    print("OPSAT CLIENT SIDE LOADED")
end