gm3 = gm3
lyx = lyx

do
    lyx:NetAdd("gm3:panel:videoPlay", {
        func = function(ply)
            if gm3:SecurityCheck(ply) then
                lyx:VideoBroadcast(net.ReadString(), {
                    width = 1920,
                    height = 1080,
                })    
            end
        end
    })
    
    lyx:NetAdd("gm3:panel:videoStop", {
        func = function(ply)
            if gm3:SecurityCheck(ply) then
                lyx:VideoStopBroadcast()
            end
        end
    })    
end


-- player part
do
    lyx:NetAdd("gm3:player:kill", {
        func = function(ply)
            if !gm3:SecurityCheck(ply) then return end

            local target = net.ReadString()
            local ent = player.GetBySteamID(target)
            if !IsValid(ent) then return end

            ent:Kill()
            gm3.Logger:Log("Player " .. ent:Nick() .. " has been killed by " .. ply:Nick() .. ":" .. ply:SteamID())
            gm3.Logger:Log("This has been printed to prevent abuse.")
        end
    })

    lyx:NetAdd("gm3:player:message", {
        func = function(ply)
            if !gm3:SecurityCheck(ply) then return end

            local target = net.ReadString()
            local header = net.ReadString()
            local message = net.ReadString()
            local ent = player.GetBySteamID(target)
            if !IsValid(ent) then return end

            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(196,62,62,190),["header"] = header,["color2"] = Color(255,255,255),["text"] = message,
                ["ply"] = ply
            })
        end
    })
end

-- server
do
    lyx:NetAdd("gm3:setting:change", {
        func = function(ply)
            if !gm3:SecurityCheck(ply) then return end

            local tbl = net.ReadTable()
            local key = tbl.key
            local value = tbl.value 

            gm3:ChangeSetting(key, value)
        end
    })
end