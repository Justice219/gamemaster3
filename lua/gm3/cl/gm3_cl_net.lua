gm3 = gm3
gm3.ranks = gm3.ranks or {}
gm3.tools = gm3.tools or {}
lyx = lyx

lyx:NetAdd("gm3:sync:request", {
    func = function(ply, cmd, args)
        gm3.tools = net.ReadTable()
        gm3.ranks = net.ReadTable()

        gm3:Log("Server Sync Complete")
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

gm3:Log("Client-side net messages loaded.")