gm3 = gm3

if SERVER then
    gm3 = gm3
    gm3.disableChat = gm3.disableChat or {}

    lyx = lyx

    local tool = GM3Module.new(
        "Disable Chat",
        "Disables a command from being used in chat. Enter the command again to re-enable it.", 
        "Justice#4956",
        {
            ["Chat Command"] = {
                type = "string",
                def = "/ooc"
            }
        },
        function(ply, args)
            local cmd = args["Chat Command"]
            if gm3.disableChat[args["Chat Command"]] then
                lyx:HookRemove("PlayerSay", gm3.disableChat[args["Chat Command"]])
                lyx:MessageServer({
                    ["type"] = "header",
                    ["color1"] = Color(0,255,213),
                    ["header"] = "Event",
                    ["color2"] = Color(255,255,255),
                    ["text"] = "Chat command " .. args["Chat Command"] .. " has been re-enabled."
                })
            else
                local chatHook = lyx:HookStart("PlayerSay", function(...)
                    local args = {...}
                    local ply = args[1]
                    local text = args[2]
    
                    if string.sub(text, 1, string.len(cmd)) == cmd then
                        return ""
                    end
                end)

                lyx:MessageServer({
                    ["type"] = "header",
                    ["color1"] = Color(0,255,213),
                    ["header"] = "Event",
                    ["color2"] = Color(255,255,255),
                    ["text"] = "Chat command " .. args["Chat Command"] .. " has been disabled."
                })
                gm3.disableChat[args["Chat Command"]] = chatHook
            end
        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx


end