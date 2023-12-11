gm3 = gm3
lyx = lyx

--[[ 
--! Internal GM3 Chat Handler
--+ Please use lyx stuff here i beg 😓💯
--]]

do
   --+ GM3 menu command using lyx
    lyx:ChatAddCommand("gm3", { -- ? command name
    prefix = "!", -- ? prefix to use command
    func = function(ply, args) -- ? function to run when command is used
        if !gm3:SecurityCheck(ply) then return end -- ? Security check
        net.Start("gm3:menu:open") -- ? net request to client
        net.Send(ply) -- ? send request to player
    end
    }, false) 
end

do
    -- lyx:NetAdd("gm3:command:create", {
    --     func = function(ply)
    --         if !gm3:SecurityCheck(ply) then return end
            
    --         local cmd = net.ReadString()
    --         local color = net.ReadColor()

    --         gm3:CommandCreate(cmd, color)
    --     end
    -- })
    -- lyx:NetRemove("gm3:command:remove", {
    --     func = function(ply)
    --         if !gm3:SecurityCheck(ply) then return end
            
    --         local cmd = net.ReadString()
    --         gm3:CommandRemove(cmd)
    --     end
    -- })

    function gm3:CommandExists(cmd, ply)
        if !cmd then return end

        return gm3.commands[cmd] != nil
    end

    function gm3:CommandCreate(tbl, ply)
        if !tbl.command then return end

        if gm3:CommandExists(tbl.command) then
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "Command " .. tbl.command .. " already exists!",
            ["ply"] = ply
            })    
        return end

        gm3.commands[tbl.command] = tbl
        -- lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "You cannot remove the superadmin rank! It is required.",
        -- ["ply"] = ply
        -- })
        lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "Command " .. tbl.command .. " has been created!",
        ["ply"] = ply
        })
        lyx:JSONSave("gm3_commands.txt", gm3.commands)
    end

    function gm3:CommandRemove(cmd, ply)
        if !cmd then return end

        if !gm3:CommandExists(cmd) then
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "Command " .. cmd .. " does not exist!",
            ["ply"] = ply
            })    
        return end

        gm3.commands[cmd] = nil
        lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "Command " .. cmd .. " has been removed!",
        ["ply"] = ply
        })
        lyx:JSONSave("gm3_commands.txt", gm3.commands)
    end

    function gm3:CommandAddRank(cmd, rank, ply)
        if !gm3:CommandExists(cmd) then
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "Command " .. cmd .. " does not exist!",
            ["ply"] = ply
            })
        return end

        gm3.commands[cmd].ranks[rank] = true
        lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = rank .. " has been added to " .. cmd .. "!",
        ["ply"] = ply
        })
        lyx:JSONSave("gm3_commands.txt", gm3.commands)
    end

    function gm3:CommandRemoveRank(cmd, rank, ply)
        if !gm3:CommandExists(cmd) then
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "Command " .. cmd .. " does not exist!",
            ["ply"] = ply
            })
        return end

        gm3.commands[cmd].ranks[rank] = nil
        lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = rank .. " has been removed from " .. cmd .. "!",
        ["ply"] = ply
        })
        lyx:JSONSave("gm3_commands.txt", gm3.commands)
    end

    -- hook for calling commands
    hook.Add("PlayerSay", "gm3:command:call", function(ply, text)
        if !gm3:SecurityCheck(ply) then return end

        local args = string.Explode(" ", text)
        local cmd = args[1]
        table.remove(args, 1)

        if !gm3:CommandExists(cmd) then return end

        if !gm3.commands[cmd].ranks[ply:GetUserGroup()] then
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "You do not have permission to use this command!",
            ["ply"] = ply
            })
        return end

        net.Start("gm3:command:run")
            net.WriteTable(gm3.commands[cmd])
            net.WriteTable(args)
        net.Broadcast()

        return ""
    end)
    timer.Simple(1, function()
        local commands = lyx:JSONLoad("gm3_commands.txt")
        if commands then
            gm3.commands = commands
            gm3.Logger:Log("Loading commands...")
            for k, v in pairs(gm3.commands) do
                gm3.Logger:Log("Loaded Command: " .. k)
            end
        else
            gm3.Logger:Log("No commands found! Try making some :(")
        end
    end)
end