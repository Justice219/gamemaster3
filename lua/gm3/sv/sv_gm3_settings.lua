gm3 = gm3 or {}
gm3.settings = gm3.settings or {}
lyx = lyx

do
    function gm3:CheckSettingExists(label, func)
        local settings = lyx:JSONLoad("gm3_settings.txt")
        if settings then
            if settings[label] then
                gm3.settings[label] = settings[label]
                gm3.settings[label].callback = func

                if gm3.settings[label].syncWithClient then
                    gm3:SyncSetting(label)
                end

                gm3.Logger:Log("Loaded setting: " .. label .. " with value: " .. tostring(gm3.settings[label].value))

                return true
            else
                return false
            end
        else
            return false
        end
    end

    function gm3:CreateSetting(label, value, func, nickname, syncWithClient, category)
        local check = gm3:CheckSettingExists(label, func)
        if check then return end

        gm3.settings[label] = {
            name = label,
            value = value,
            type = type(value),
            callback = func,
            nickname = nickname,
            syncWithClient = syncWithClient,
            default = value,
            category = category
        }
        gm3.settings[label].callback(value)

        if syncWithClient then
            gm3:SyncSetting(label)
        end

        gm3.Logger:Log("Created setting: " .. label .. " with value: " .. tostring(value))
        gm3:SaveSettings()
    end
    
    function gm3:GetSetting(label)
        if !gm3.settings[label] then return end
        return gm3.settings[label].value
    end

    function gm3:SyncSetting(label)
        if !gm3.settings[label] then return end

        net.Start("gm3:setting:syncSetting")
            net.WriteString(label)
            net.WriteType(gm3.settings[label].value)
        net.Broadcast()
    end
    
    function gm3:RemoveSetting(label)
        if !gm3.settings[label] then return end
        gm3.settings[label] = nil

        gm3:SaveSettings()
    end

    function gm3:ChangeSetting(label, value)
        if !gm3.settings[label] then return end

        gm3.settings[label].value = value
        gm3.settings[label].callback(value)

        if gm3.settings[label].syncWithClient then
            gm3:SyncSetting(label)
        end

        gm3:SaveSettings()
    end
    
    function gm3:SaveSettings()
        lyx:JSONSave("gm3_settings.txt", gm3.settings)
    end
end

do
    lyx:NetAdd("gm3:setting:syncSetting", {})

    lyx:NetAdd("gm3:setting:requestClientSettings", {
        func = function(ply)
            for k, v in pairs(gm3.settings) do
                if v.syncWithClient then
                    net.Start("gm3:setting:syncSetting")
                        net.WriteString(v.name)
                        net.WriteType(v.value)
                    net.Send(ply)
                end
            end
        end
    })
end

do
    -- freeze nextbot
    gm3:CreateSetting("gm3_server_freezeNextbots", false, function(value)
        if value then
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:IsNextBot() then
                    v:Freeze(true)
                end
            end
        else
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:IsNextBot() then
                    v:Freeze(false)
                end
            end
        end
    end, "Freeze Nextbots", false, "Freeze")

    gm3:CreateSetting("gm3_server_freezePlayers", false, function(value)
        for k, v in pairs(player.GetAll()) do
            v:Freeze(value)
        end
    end, "Freeze Players", false, "Freeze")

    gm3:CreateSetting("gm3_server_freezeProps", false, function(value)
        if value then
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:GetClass() == "prop_physics" then
                    v:PhysicsInit(SOLID_VPHYSICS)
                    v:SetMoveType(MOVETYPE_NONE)
                    v:SetSolid(SOLID_VPHYSICS)
                end
            end
        else
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:GetClass() == "prop_physics" then
                    v:PhysicsInit(SOLID_VPHYSICS)
                    v:SetMoveType(MOVETYPE_VPHYSICS)
                    v:SetSolid(SOLID_VPHYSICS)
                end
            end
        end
    end, "Freeze Props", false, "Freeze")

    gm3:CreateSetting("gm3_server_freezeVehicles", false, function(value)
        if value then
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:IsVehicle() then
                    v:PhysicsInit(SOLID_VPHYSICS)
                    v:SetMoveType(MOVETYPE_NONE)
                    v:SetSolid(SOLID_VPHYSICS)
                end
            end
        else
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:IsVehicle() then
                    v:PhysicsInit(SOLID_VPHYSICS)
                    v:SetMoveType(MOVETYPE_VPHYSICS)
                    v:SetSolid(SOLID_VPHYSICS)
                end
            end
        end
    end, "Freeze Vehicles", false, "Freeze")

    gm3:CreateSetting("gm3_server_freezeNPCs", false, function(value)
        if value then
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:IsNPC() then
                    v:PhysicsInit(SOLID_VPHYSICS)
                    v:SetMoveType(MOVETYPE_NONE)
                    v:SetSolid(SOLID_VPHYSICS)
                end
            end
        else
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:IsNPC() then
                    v:PhysicsInit(SOLID_VPHYSICS)
                    v:SetMoveType(MOVETYPE_VPHYSICS)
                    v:SetSolid(SOLID_VPHYSICS)
                end
            end
        end
    end, "Freeze NPCs", false, "Freeze")

    gm3:CreateSetting("gm3_server_freezeRagdolls", false, function(value)
        if value then
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:GetClass() == "prop_ragdoll" then
                    v:PhysicsInit(SOLID_VPHYSICS)
                    v:SetMoveType(MOVETYPE_NONE)
                    v:SetSolid(SOLID_VPHYSICS)
                end
            end
        else
            for k, v in pairs(ents.GetAll()) do
                if v:IsValid() and v:GetClass() == "prop_ragdoll" then
                    v:PhysicsInit(SOLID_VPHYSICS)
                    v:SetMoveType(MOVETYPE_VPHYSICS)
                    v:SetSolid(SOLID_VPHYSICS)
                end
            end
        end
    end, "Freeze Ragdolls", false, "Freeze")

    gm3:CreateSetting("gm3_opsat_primaryColor", Color(189, 88, 88), function(value) end, "OPSAT Primary Color", true, "OPSAT")
    gm3:CreateSetting("gm3_opsat_secondaryColor", Color(255, 255, 255), function(value) end, "OPSAT Secondary Color", true, "OPSAT")



end
