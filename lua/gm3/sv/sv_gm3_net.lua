gm3 = gm3
gm3.tools = gm3.tools or {}
gm3.ranks = gm3.ranks or {}
gm3.commands = gm3.commands or {}
gm3.settings = gm3.settings or {}
lyx = lyx

--! Make sure to use
--? lyx:NetAdd(string, func)
--+ This allows editing within the lyx library

do
    local function loadSharedFile(str)
        if SERVER then AddCSLuaFile(str) return end
        include(str)
        gm3.Logger:Log("Loaded shared file: " .. str)
    end 
end

do
    function gm3:RemoveFromTable(tbl, valueToRemove)
        PrintTable(tbl)
        local newTable = {}
        for k, v in pairs(tbl) do
            if v[valueToRemove] then
                v[valueToRemove] = nil
            end
        end
        PrintTable(newTable)
        return newTable
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
            local tools = {}
            for k, v in pairs(gm3.tools) do
                tools[k] = {
                    name = v.name,
                    description = v.description,
                    args = v.args,
                    author = v.author,
                }
            end
            local settings = {}
            for k, v in pairs(gm3.settings) do
                settings[k] = {
                    name = v.name,
                    value = v.value,
                    type = v.type,
                    nickname = v.nickname,
                    default = v.default,
                }
            end
    
            net.WriteTable(tools)
            net.WriteTable(gm3.ranks)
            net.WriteTable(gm3.commands)
            net.WriteTable(settings)
            net.Send(ply)
        end
    })

    function gm3:SyncPlayer(ply)
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
        local settings = {}
        for k, v in pairs(gm3.settings) do
            settings[k] = {
                name = v.name,
                value = v.value,
                type = v.type,
                nickname = v.nickname,
                default = v.default,
            }
        end

        net.WriteTable(tools)
        net.WriteTable(gm3.ranks)
        net.WriteTable(gm3.commands)
        net.WriteTable(settings)
        net.Send(ply)
    end
    
    lyx:NetAdd("gm3:tool:run", {
        func = function(ply, cmd, args)
            if !gm3:SecurityCheck(ply) then return end
            
            local tool = net.ReadString()
            local args = net.ReadTable()
    
            if !gm3:getTool(tool) then
                gm3.Logger:Log("Attempted to run invalid tool: " .. tool .. " Player: " .. ply .. " [THIS SHOULD NOT HAPPEN]")    
            return end
    
            gm3:runTool(tool, ply, args)
    
        end
    })
    
    lyx:NetAdd("gm3:rank:add", {
        func = function(ply)
            if !ply:GetUserGroup() == "superadmin" then return end
            if !gm3:SecurityCheck(ply) then return end
            local rank = net.ReadString()
        
            gm3:RankAdd(rank)
        end
    })
    
    lyx:NetAdd("gm3:rank:remove", {
        func = function(ply)
            if !ply:GetUserGroup() == "superadmin" then return end
            if !gm3:SecurityCheck(ply) then return end

            local rank = net.ReadString()
            if rank == "superadmin" then
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "You cannot remove the superadmin rank! It is required.",
                    ["ply"] = ply
                })
            return end
            --! Someone reported that a rogue staff member deleted this rank.
            --! doesnt make sense that they should be able to do that so lets just not allow it entirely
        
            gm3:RankRemove(rank)
        end
    })
    
    lyx:NetAdd("gm3:command:create", {
        func = function(ply)
            if !gm3:SecurityCheck(ply) then return end
            
            local tbl = net.ReadTable()

            gm3:CommandCreate(tbl, ply)
        end
    })
    lyx:NetAdd("gm3:command:remove", {
        func = function(ply)
            if !gm3:SecurityCheck(ply) then return end
            
            local name = net.ReadString()
            gm3:CommandRemove(name, ply)
        end
    })
    -- remove rank and add rank
    lyx:NetAdd("gm3:command:addRank", {
        func = function(ply)
            if !gm3:SecurityCheck(ply) then return end
            
            local cmd = net.ReadString()
            local rank = net.ReadString()
            gm3:CommandAddRank(cmd, rank, ply)
        end
    })
    lyx:NetAdd("gm3:command:removeRank", {
        func = function(ply)
            if !gm3:SecurityCheck(ply) then return end
            
            local cmd = net.ReadString()
            local rank = net.ReadString()
            gm3:CommandRemoveRank(cmd, rank, ply)
        end
    })
    -- gm3ZeusCam_removeSelected
    lyx:NetAdd("gm3ZeusCam_removeSelected", {
        func = function(ply)
            print("removeSelected")
            if !gm3:SecurityCheck(ply) then return end
            
            local tbl = net.ReadTable()
            for k, v in pairs(tbl) do
                k:Remove()
            end
        end
    })
    lyx:NetAdd("gm3ZeusCam_moveToCamera", {
        func = function(ply)
            if !gm3:SecurityCheck(ply) then return end
            
            local npcs = net.ReadTable()
            local camPos = net.ReadVector()

            for k, v in pairs(npcs) do
                -- set their next move pos to the camera pos
                
            end
        end
    })
    lyx:NetAdd("gm3ZeusCam_moveToClick", {
        func = function(ply)
            if !gm3:SecurityCheck(ply) then return end
            
            local npcs = net.ReadTable()
            local ply = net.ReadEntity()

            for k, v in pairs(npcs) do
                -- set their next move pos to the camera pos
                
            end
        end
    })

    --+ Only here because it needs to be initialized server side
    --+ using lyx instead of net.add because my library lyx, allows monitoring of the net messages
    lyx:NetAdd("gm3:menu:open", {})
    lyx:NetAdd("gm3:net:clientConvar", {})
    lyx:NetAdd("gm3:net:stringConCommand", {})
    lyx:NetAdd("gm3:tools:enableLights", {}) 
    lyx:NetAdd("gm3:command:run", {})
end
