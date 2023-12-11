gm3 = gm3 or {}

lyx:NetAdd("gm3:command:run", {
    func = function()
        local cmd = net.ReadTable()
        local args = net.ReadTable()
        PrintTable(cmd)

        local str = ""
        if cmd.useHeader and cmd.showPlayerName then
            str = string.upper("[" .. string.sub(cmd.command, 2) .. "] ")
            str = str .. LocalPlayer():Nick() .. ": "
            chat.AddText(Color(cmd.color1.r, cmd.color1.g, cmd.color1.b), str, Color(cmd.color2.r, cmd.color2.g, cmd.color2.b), table.concat(args, " "))
        end
        if cmd.useHeader and not cmd.showPlayerName then
            str = string.upper("[" .. string.sub(cmd.command, 2) .. "] ")
            chat.AddText(Color(cmd.color1.r, cmd.color1.g, cmd.color1.b), str, Color(cmd.color2.r, cmd.color2.g, cmd.color2.b), table.concat(args, " "))
        end
        if not cmd.useHeader and cmd.showPlayerName then
            str = LocalPlayer():Nick() .. ": "
            chat.AddText(Color(cmd.color1.r, cmd.color1.g, cmd.color1.b), str, Color(cmd.color2.r, cmd.color2.g, cmd.color2.b), table.concat(args, " "))
        end
        if not cmd.useHeader and not cmd.showPlayerName then
            chat.AddText(Color(cmd.color2.r, cmd.color2.g, cmd.color2.b), table.concat(args, " "))
        end
    end
})
