gm3 = gm3
gm3.ranks = gm3.ranks or {}
gm3.tools = gm3.tools or {}
gm3.settings = gm3.settings or {}
lyx = lyx

do
    lyx:NetAdd("gm3:sync:request", {
        func = function(ply, cmd, args)
            gm3.tools = net.ReadTable()
            gm3.ranks = net.ReadTable()
            gm3.commands = net.ReadTable()
            gm3.settings = net.ReadTable()
    
            gm3.Logger:Log("Server Sync Complete")
        end
    })
    
    lyx:NetAdd("gm3:net:clientConvar", {
        func = function()
            local bool = net.ReadBool()
            local name = net.ReadString()
    
            if bool then
                if GetConVar(name) then
                    GetConVar(name):SetBool(true)
                else
                    CreateClientConVar(name, 1, true, false)
                end
            else
                if GetConVar(name) then
                    GetConVar(name):SetBool(false)
                else
                    CreateClientConVar(name, 0, true, false)
                end
            end
        end
    })
    
    lyx:NetAdd("gm3:net:stringConCommand", {
        func = function()
            local cmd = net.ReadString()
            RunConsoleCommand(cmd)
        end
    })
    
    lyx:NetAdd("gm3:tools:enableLights", {
        func = function()
            render.RedownloadAllLightmaps(true, true)
        end
    })
    
    function gm3:SyncReopenMenu(tab)
        net.Start("gm3:sync:request")
        net.SendToServer()

        timer.Simple(0.5, function()
            if gm3.Menu then
                gm3.Menu:Remove()
            end

            gm3.Menu = vgui.Create("GM3.Frame")
            timer.Simple(0.1, function()
                gm3.Menu.SideBar:SelectItem(tab)
            end)
        end)
    end
end

gm3.Logger:Log("Client-side net messages loaded.")