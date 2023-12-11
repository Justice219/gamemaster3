TOOL.Category		=	"Gamemaster 3"
TOOL.Name			=	"Detonator"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

TOOL.ClientConVar["time"] = 20

if CLIENT then
	language.Add("Tool.gm3_detonator.name", "Detonator")
	language.Add("Tool.gm3_detonator.desc", "Allows a player to place a detonator.")
	language.Add("Tool.gm3_detonator.0", "Left Click: Place, Right Click: Remove")
	language.Add("tool.gm3_detonator.time", "Duration Before Explosion:")
	

	surface.CreateFont("DetonatorToolScreenFont", { font = "Arial", size = 40, weight = 1000, antialias = true, additive = false })
	surface.CreateFont("DetonatorToolScreenSubFont", { font = "Arial", size = 30, weight = 1000, antialias = true, additive = false })
end

function TOOL:LeftClick(trace)
	if CLIENT then return true end

	if IsValid(trace.Entity) and !trace.Entity:IsPlayer() then
		local ghostDet = ents.Create("gm3_detonator")
		ghostDet:SetPos(trace.HitPos)
		ghostDet:SetAngles(self:GetOwner():EyeAngles())
		ghostDet:Spawn()
		ghostDet:GetPhysicsObject():EnableMotion(false)
		ghostDet:SetMaterial("models/wireframe")
		ghostDet:SetData(self:GetClientInfo("time"), trace.Entity)

		-- set ghost det to players spawn group
		cleanup.Add(self:GetOwner(), "props", ghostDet)

		trace.Entity:GetPhysicsObject():EnableMotion(false)
	end
	return true
end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	
	if IsValid(trace.Entity) and trace.Entity:GetClass() == "gm3_detonator" then
		trace.Entity:Delete()
	end

	return true
end

function TOOL:Reload(trace)
	if CLIENT then return true end

	return true
end

function TOOL.BuildCPanel(panel)

	panel:AddControl("Header",{Text = "Detonator Tool", Description = "Detonator Tool \n Allows a player to place a detonator. \n The detonator will explode after a set amount of time after being placed."})
	panel:AddControl("Slider",{Label = "#tool.gm3_detonator.time", Command = "gm3_detonator_time", Min = 0, Max = 1000, type = "Float"})

end

function TOOL:DrawToolScreen(width, height)

	if SERVER then return end

	surface.SetDrawColor(175, 37, 37)
	surface.DrawRect(0, 0, 256, 256)

	surface.SetFont("DetonatorToolScreenFont")
	local w, h = surface.GetTextSize(" ")
	surface.SetFont("DetonatorToolScreenSubFont")
	local w2, h2 = surface.GetTextSize(" ")

	draw.SimpleText("Detonator Tool", "DetonatorToolScreenFont", 128, 100, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)
	draw.SimpleText("By Justice", "DetonatorToolScreenSubFont", 128, 128 + (h + h2) / 2 - 4, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)

end