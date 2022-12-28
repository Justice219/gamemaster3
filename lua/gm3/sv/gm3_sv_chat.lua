gm3 = gm3
lyx = lyx

--[[ 
--! Internal GM3 Chat Handler
--+ Please use lyx stuff here i beg 😓💯
--]]

--+ GM3 menu command using lyx
lyx:ChatAddCommand("gm3", { -- ? command name
    prefix = "!", -- ? prefix to use command
    func = function(ply, args) -- ? function to run when command is used
        if !gm3:SecurityCheck(ply) then return end -- ? Security check
        net.Start("gm3:menu:open") -- ? net request to client
        net.Send(ply) -- ? send request to player
    end
}, false)