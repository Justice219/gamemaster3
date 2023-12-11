gm3 = gm3

if SERVER then
    gm3 = gm3
    lyx = lyx

    util.AddNetworkString("gm3:tools:screenTimerStop")
    util.AddNetworkString("gm3:tools:screenTimerStart")
    util.AddNetworkString("gm3:tools:screenTimerSync")

    local timerHook = nil
    local tool = GM3Module.new(
        "Screen Timer",
        "A tool that allows you to set a timer on the screen.", 
        "Justice#4956",
        {
            ["Time"] = {
                type = "number",
                def = 5
            },
        },
        function(ply, args)
            if args["Time"] == 0 then
                if timer.Exists("gm3_timer") then
                    timer.Remove("gm3_timer")
                    
                    net.Start("gm3:tools:screenTimerStop")
                    net.Broadcast()
                end
            else
                if timer.Exists("gm3_timer") then
                    timer.Remove("gm3_timer")
                end
    
                net.Start("gm3:tools:screenTimerStart")
                net.WriteInt(args["Time"], 32)
                net.Broadcast()

                timer.Create("gm3_timer", args["Time"], 1, function()
                    net.Start("gm3:tools:screenTimerStop")
                    net.Broadcast()
                end)
            end
        end)
    gm3:addTool(tool)

    lyx:NetAdd("gm3:tools:requestTimer", {
        func = function(ply)
            if timer.Exists("gm3_timer") then
                net.Start("gm3:tools:screenTimerStart")
                net.WriteInt(timer.TimeLeft("gm3_timer"), 32)
                net.Send(ply)
            end
        end
    })
end

if CLIENT then
    gm3 = gm3
    gm3.opsat = gm3.opsat or false
    gm3.timerData = gm3.timerData or {}

    lyx = lyx

    local function Timer(time, method)

        local function ScaleW(size)
            return ScrW() * size/1920
        end
        local function ScaleH(size)
            return ScrH() * size/1080        
        end
    
        surface.CreateFont("gm_timer_font", {
            font = "Roboto",
            size = ScaleH(50),
            weight = 500,
            antialias = true,
            shadow = false,
            stroke = true,
            outline = true
        })
        
    
        if method == "start" then
            for k,v in pairs(gm3.timerData) do
                k = nil
                v:Remove()
            end
    
            if timer.Exists("gm3_timer") then
                timer.Remove("gm3_timer")
            end
    
            timer.Create("gm3_timer", time, 1, function()
                for k,v in pairs(gm3.timerData) do
                    k = nil
                    v:Remove()
                end
            end)
    
            if gm3.opsat then
                local back = vgui.Create("DPanel")
                back:SetSize(ScrW(), ScrH())
                back:SetPos(0, 0)
                back.Paint = function(self, w, h)
                    draw.RoundedBox( 6, ScaleW(0), ScaleH(30), ScrW() - ScaleW(1150), ScaleH(50), Color(39, 38, 38))
                end
                table.insert(gm3.timerData, #gm3.timerData, back)
            else
                local back = vgui.Create("DPanel")
                back:SetSize(ScrW(), ScrH())
                back:SetPos(0, 0)
                back.Paint = function(self, w, h)
                    draw.RoundedBox( 6, ScaleW(0), ScaleH(30), ScrW() - ScaleW(1150), ScaleH(50), Color(39, 38, 38))
                end
                table.insert(gm3.timerData, #gm3.timerData, back)
            end
    
            local label = vgui.Create("DLabel")
            label:SetFont("gm_timer_font")
            label:SetTextColor(Color(255,255,255))
            label:SetSize(ScrW(200), ScaleH(50))
            -- Lets make the label so its at the top of the screen
            label:SetPos(ScrW()/2 - ScaleW(900), ScrH()/2 - ScaleH(510))
            label.Think = function()
                timeString = os.date( "%M Minute(s) %S Seconds" , timer.TimeLeft("gm3_timer") ) .. " remaining"
                label:SetText(timeString)
            end
            table.insert(gm3.timerData, #gm3.timerData, label)
    
        elseif method == "stop" then
            if timer.Exists("gm3_timer") then
                timer.Remove("gm3_timer")
            end
            for k,v in pairs(gm3.timerData) do
                k = nil
                v:Remove()
            end
        end
    end
    
    lyx:NetAdd("gm3:tools:screenTimerStart", {
        func = function(len, ply)
            local time = net.ReadInt(32)
            Timer(time, "start")
        end
    })
    lyx:NetAdd("gm3:tools:screenTimerStop", {
        func = function(len, ply)
            Timer(0, "stop")
        end
    })

    hook.Add("ClientSignOnStateChanged", "GM3_Timer", function(userid, oldState, newState)
        print("SIGNONSTATE: " .. newState)
        if newState == 6 then
            print("ATTEMPTING TO SYNC TIMER")
                net.Start("gm3:tools:requestTimer")
                net.SendToServer()
            print("TIMER SYNCED")
        end
    end)
end