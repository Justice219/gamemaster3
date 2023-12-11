TOOL.Category		=	"Gamemaster 3"
TOOL.Name			=	"Datapad Creator"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

TOOL.ClientConVar["duration"] = 0
TOOL.ClientConVar["radius"] = 0

if CLIENT then
	language.Add("Tool.gm3_datapad_creator.name", "Datapad Creator")
	language.Add("Tool.gm3_datapad_creator.desc", "Created a datapad using Gamemaster 3 (tbfr just use the actual entity lol)")
	language.Add("Tool.gm3_datapad_creator.0", "Left click to create a datapad, right click to remove a datapad")

	language.Add("tool.gm3_datapad.title", "Title:")
	language.Add("tool.gm3_datapad.body", "Description:")
	

	surface.CreateFont("datapadToolScreenFont", { font = "Arial", size = 35, weight = 1000, antialias = true, additive = false })
	surface.CreateFont("datapadToolScreenSubFont", { font = "Arial", size = 30, weight = 1000, antialias = true, additive = false })
end

function TOOL:LeftClick(trace)
	if CLIENT then return true end

	if not trace.Entity then return end
	
	local own = self:GetOwner()
	local ent = ents.Create("gm3_datapad")
	ent:SetPos(trace.HitPos + trace.HitNormal * 10)
	ent:SetAngles(trace.HitNormal:Angle() + Angle(90, 0, 0))
	ent:Spawn()
	ent:CPPISetOwner(own)
	ent:SetData(self:GetClientInfo("title"), self:GetClientInfo("body"), own)
	print(self:GetClientInfo("title"), self:GetClientInfo("body"), own)

	cleanup.Add(own, "props", ent)
	undo.Create( "Datapad" )
		undo.AddEntity( ent )
		undo.SetPlayer( own )
	undo.Finish()

    lyx:MessagePlayer({
        ["type"] = "header",
        ["color1"] = Color(0,255,213),
        ["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),
        ["text"] = "You have created a datapad.",
        ["ply"] = own
    })

	return true
end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	
	if not trace.Entity then return end

	local own = self:GetOwner()
	if trace.Entity:GetClass() == "gm3_datapad" then
		trace.Entity:Remove()
	end

	return true
end

function TOOL:Reload(trace)
	if CLIENT then return true end

	return true
end

function TOOL.BuildCPanel(panel)

	panel:AddControl("Header",{Text = "datapad", Description = "datapad Tool\n Will datapad anything you click on, aswell as igniting anything in the given radius."})
	panel:AddControl("Textbox",{Label = "#tool.gm3_datapad.title", Command = "gm3_datapad_title"})
	panel:AddControl("Textbox",{Label = "#tool.gm3_datapad.body", Command = "gm3_datapad_body"})

end

function TOOL:DrawToolScreen(width, height)

	if SERVER then return end

	surface.SetDrawColor(36, 36, 36)
	surface.DrawRect(0, 0, 256, 256)

	surface.SetFont("datapadToolScreenFont")
	local w, h = surface.GetTextSize(" ")
	surface.SetFont("datapadToolScreenSubFont")
	local w2, h2 = surface.GetTextSize(" ")

	draw.SimpleText("Datapad Creator", "datapadToolScreenFont", 128, 100, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)
	draw.SimpleText("By Justice", "datapadToolScreenSubFont", 128, 128 + (h + h2) / 2 - 4, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)

end