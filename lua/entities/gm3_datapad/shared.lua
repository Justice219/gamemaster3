-- Basic Ent Stuff
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "Gamemaster 3"
ENT.PrintName = "Datapad"
ENT.Spawnable = true

function ENT:SetupDataTables()

    --[[self:NetworkVar("Entity", 0, "owning_ent")
    self:NetworkVar("Bool" , 1 , "HasBeenLooted")
    self:NetworkVar("Int", 1, "TrashItem")
    self:NetworkVar("Int" , 2 , "RegenTimeLeft")
    self:NetworkVar("Bool" , 2 , "Regenerating")
    self:NetworkVar("Int" , 3 , "LootStage")
    self:NetworkVar("Int" , 4 , "TimerID")--]]

    self:NetworkVar("String", 1, "Title")
    self:NetworkVar("String", 2, "Description")
    --owning_ent
    self:NetworkVar("Entity", 0, "owning_ent")
end

