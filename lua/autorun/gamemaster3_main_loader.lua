do
    local addonName = "gm3"

    local createFunc = function()
         lyx.CreateAddon(addonName, Color(199, 83, 54), {"sv", "sh", "cl", "vgui", "tools"})
         gm3.Loaded = true
    end
    if lyx and lyx.Loaded then
        createFunc()
    else
        hook.Add("lyx.Loaded", addonName, createFunc)
    end

    hook.Run("gm3.Loaded")
end

    