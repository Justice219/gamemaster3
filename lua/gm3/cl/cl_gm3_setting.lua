gm3 = gm3
gm3.settings = gm3.settings or {}
lyx = lyx

do
    lyx:NetAdd("gm3:setting:syncSetting", {
        func = function()
            local name = net.ReadString()
            local value = net.ReadType()
    
            if gm3.settings[name] then
                gm3.settings[name].value = value
            else
                gm3.settings[name] = {
                    value = value
                }
            end
        end

    })

    hook.Add("ClientSignOnStateChanged", "gm3_clientSetting_sync", function(userid, oldState, newState)
        print("SIGNONSTATE: " .. newState)
        if newState == 6 then
            net.Start("gm3:setting:requestClientSettings")
            net.SendToServer()
        end
    end)
end