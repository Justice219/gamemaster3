AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("lyx_core/thirdparty/cl_lyx_imgui.lua")
include("shared.lua")

lyx:NetAdd("GM3:Entities:Datapad:Open", {func = function() end})

function ENT:Initialize()

    -- Setup ent basics
    self:SetModel("models/lt_c/sci_fi/holo_tablet.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetSkin(1)
    self:CPPISetOwner(self:Getowning_ent())

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

end

function ENT:Use(act, caller)
    gm3:SyncPlayer(caller)

    timer.Simple(0.1, function()
        net.Start("GM3:Entities:Datapad:Open")
         net.WriteEntity(self)
        net.Send(caller)
    end)
end

function ENT:SetData(title, desc, caller)
    self:SetTitle(title)
    self:SetDescription(desc)

    lyx:MessagePlayer({["type"] = "header",["color1"] = Color(44,168,71),["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),["text"] = "Datapad Information Set",
    ["ply"] = caller
})
end

lyx:NetAdd("GM3:Entities:Datapad:Set", {
    func = function(ply)
        if gm3:SecurityCheck(ply) then
            local ent = net.ReadEntity()
            local title = net.ReadString()
            local desc = net.ReadString()

            -- check if the player owns the entity
            ent:SetData(title, desc, ply)
        end
end})

