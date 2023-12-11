local PANEL = {}

lyx.RegisterFont("GM3.Pages.Server", "Open Sans SemiBold", 20)
surface.CreateFont("OpsatColors", {
    font = "Roboto Bold",
    size = lyx.Scale(22),
    weight = 1000,
    antialias = true,
    shadow = false
})

function PANEL:Init()
    local categories = {}

    for k,v in pairs(gm3.settings) do
        if v.type == "boolean" then
            self:AddCheckbox(v.nickname, v.value, function(value)
                net.Start("gm3:setting:change")
                    net.WriteTable({
                        key = k,
                        value = value
                    })
                net.SendToServer()
                gm3:SyncReopenMenu("Server")
            end)
        elseif v.type == "table" then
            self:AddColorMixer(v.nickname, Color(v.value.r, v.value.g, v.value.b, v.value.a), function(value)
                net.Start("gm3:setting:change")
                    net.WriteTable({
                        key = k,
                        value = value
                    })
                net.SendToServer()
                --gm3:SyncReopenMenu("Server")
            end, Color(v.default.r, v.default.g, v.default.b, v.default.a))
        end
    end

end

function PANEL:UpdateSettings(key, value)
    -- net.Start("mprr:restriction:job:edit")
    --     net.WriteTable({
    --         job = self.JobName,
    --         key = key,
    --         value = value
    --     })
    -- net.SendToServer()
end

vgui.Register("GM3.Pages.Server", PANEL, "lyx.PageBase")
