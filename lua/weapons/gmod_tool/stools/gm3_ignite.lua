TOOL.Category		=	"Gamemaster 3"
TOOL.Name			=	"Ignite"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

TOOL.ClientConVar["duration"] = 0
TOOL.ClientConVar["radius"] = 0

if CLIENT then
	language.Add("Tool.gm3_ignite.name", "Ignite")
	language.Add("Tool.gm3_ignite.desc", "Permanently changes a players model")
	language.Add("Tool.gm3_ignite.0", "Left Click: Ignite, Right Click: Remove Ignite")
	language.Add("tool.gm3_ignite.duration", "Duration In Seconds:")
	language.Add("tool.gm3_ignite.radius", "Radius:")
	

	surface.CreateFont("IgniteToolScreenFont", { font = "Arial", size = 40, weight = 1000, antialias = true, additive = false })
	surface.CreateFont("IgniteToolScreenSubFont", { font = "Arial", size = 30, weight = 1000, antialias = true, additive = false })
end

function TOOL:LeftClick(trace)
	if CLIENT then return true end

	if not trace.Entity then return end
	
	local own = self:GetOwner()
	trace.Entity:Ignite(self:GetClientNumber("duration"), self:GetClientNumber("radius"))
    lyx:MessagePlayer({
        ["type"] = "header",
        ["color1"] = Color(0,255,213),
        ["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),
        ["text"] = "You have ignited a entity for "..self:GetClientNumber("duration").." seconds.",
        ["ply"] = own
    })

	return true
end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	
	if not trace.Entity then return end

	local own = self:GetOwner()
	trace.Entity:Extinguish()
    lyx:MessagePlayer({
        ["type"] = "header",
        ["color1"] = Color(0,255,213),
        ["header"] = "Gamemaster 3",["color2"] = Color(255,255,255),
        ["text"] = "You have extinguished a entity.",
        ["ply"] = own
    })

	return true
end

function TOOL:Reload(trace)
	if CLIENT then return true end

	return true
end

function TOOL.BuildCPanel(panel)

	panel:AddControl("Header",{Text = "Ignite", Description = "Ignite Tool\n Will ignite anything you click on, aswell as igniting anything in the given radius."})
	panel:AddControl("Slider",{Label = "#tool.gm3_ignite.duration", Command = "gm3_ignite_duration", Min = 0, Max = 1000, type = "Float"})
	panel:AddControl("Slider",{Label = "#tool.gm3_ignite.radius", Command = "gm3_ignite_radius", Min = 0, Max = 20000, type = "Float"})

end

function TOOL:DrawToolScreen(width, height)

	if SERVER then return end

	surface.SetDrawColor(165, 104, 23)
	surface.DrawRect(0, 0, 256, 256)

	surface.SetFont("IgniteToolScreenFont")
	local w, h = surface.GetTextSize(" ")
	surface.SetFont("IgniteToolScreenSubFont")
	local w2, h2 = surface.GetTextSize(" ")

	draw.SimpleText("Ignite Tool", "IgniteToolScreenFont", 128, 100, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)
	draw.SimpleText("By Justice", "IgniteToolScreenSubFont", 128, 128 + (h + h2) / 2 - 4, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)

end