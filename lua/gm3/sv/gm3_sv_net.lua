gm3 = gm3
gm3.tools = gm3.tools or {}
gm3.ranks = gm3.ranks or {}
lyx = lyx

--! Make sure to use
--? lyx:NetAdd(string, func)
--+ This allows editing within the lyx library

local function loadSharedFile(str)
    if SERVER then AddCSLuaFile(str) return end
    include(str)
    gm3:Log("Loaded shared file: " .. str)
end

lyx:NetAdd("gm3:security:check", {
    func = function(ply, cmd, args)
        net.Start("gm3:security:check")
        if gm3:SecurityCheck(ply) then
            net.WriteBool(true)
        else
            net.WriteBool(false)
        end
    end
})

--+ Called to insure the player gets server data when using the menu
lyx:NetAdd("gm3:sync:request", {
    func = function(ply, cmd, args)
        if !gm3:SecurityCheck(ply) then return end

        net.Start("gm3:sync:request")

        --! We need to redo the table but remove all the functions
        local tools = {}
        for k, v in pairs(gm3.tools) do
            tools[k] = {
                name = v.name,
                description = v.description,
                args = v.args,
                author = v.author,
            }
        end

        net.WriteTable(tools)
        net.WriteTable(gm3.ranks)
        net.Send(ply)
    end
})

lyx:NetAdd("gm3:tool:run", {
    func = function(ply, cmd, args)
        if !gm3:SecurityCheck(ply) then return end
        
        local tool = net.ReadString()
        local args = net.ReadTable()

        if !gm3:getTool(tool) then
            gm3:Log("Attempted to run invalid tool: " .. tool .. " Player: " .. ply .. " [THIS SHOULD NOT HAPPEN]")    
        return end

        gm3:runTool(tool, ply, args)

    end
})

lyx:NetAdd("gm3:rank:add", {
    func = function(ply)
        if !gm3:SecurityCheck(ply) then return end
        local rank = net.ReadString()
    
        gm3:RankAdd(rank)
    end
})

lyx:NetAdd("gm3:rank:remove", {
    func = function(ply)
        if !gm3:SecurityCheck(ply) then return end
        local rank = net.ReadString()
    
        gm3:RankRemove(rank)
    end
})

--+ Only here because it needs to be initialized server side
lyx:NetAdd("gm3:menu:open", {})
lyx:NetAdd("gm3:net:clientConvar", {})
lyx:NetAdd("gm3:net:stringConCommand", {})
lyx:NetAdd("gm3:tools:enableLights", {})