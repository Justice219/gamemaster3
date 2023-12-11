TOOL.Category		=	"Gamemaster 3"
TOOL.Name			=	"Perma Model"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

TOOL.ClientConVar["model"] = ""

if CLIENT then
	language.Add("Tool.gm3_permamodel.name", "PermaModel")
	language.Add("Tool.gm3_permamodel.desc", "Permanently changes a players model")
	language.Add("Tool.gm3_permamodel.0", "Left Click: Model Player, Reload: Self Model, Empty Model Path: Remove Model")
	language.Add("tool.gm3_permamodel.model", "Model String:")

	surface.CreateFont("PermaModelToolScreenFont", { font = "Arial", size = 40, weight = 1000, antialias = true, additive = false })
	surface.CreateFont("PermaModelToolScreenSubFont", { font = "Arial", size = 30, weight = 1000, antialias = true, additive = false })
end

if SERVER then
	-- set model hook
	hook.Add("")
end

function TOOL:LeftClick(trace)
	if CLIENT then return true end

	gm3 = gm3 or {}

	local ent = trace.Entity
	local ply = self:GetOwner()

	if IsValid(ent) and ent:IsPlayer() then
		if self:GetClientInfo("model") == "" then
			local val = lyx:JSONLoad("gm3_permamodel.txt")
			if val then
				tbl[ent:SteamID()] = nil
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "This player's model has been removed.",
                    ["ply"] = ply
                })
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "Your model has been removed.",
                    ["ply"] = ent
                })
				lyx:JSONSave("gm3_permamodel.txt", tbl)
			end
		else
			local val = lyx:JSONLoad("gm3_permamodel.txt")
			if val then
				tbl[ent:SteamID()] = self:GetClientInfo("model")
				lyx:JSONSave("gm3_permamodel.txt", tbl)
				
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "This player's model has been set.",
                    ["ply"] = ply
                })
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "Your model has been set.",
                    ["ply"] = ent
                })
				ent:SetModel(self:GetClientInfo("model"))
			else
				local tbl = {}
				tbl[ent:SteamID()] = self:GetClientInfo("model")
				lyx:JSONSave("gm3_permamodel.txt", tbl)

				ent:SetModel(self:GetClientInfo("model"))
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "This player's model has been set.",
                    ["ply"] = ply
                })
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "Your model has been set.",
                    ["ply"] = ent
                })
			end
		end
	else
        lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "You must target a player.",
            ["ply"] = ply
        })
	end

	return true
end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	
	return true
end

function TOOL:Reload(trace)
	if CLIENT then return true end

	local ply = self:GetOwner()
	if self:GetClientInfo("model") == "" then
		local val = lyx:JSONLoad("gm3_permamodel.txt")
		if val then
			val[ply:SteamID()] = nil
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "Your model has been removed.",
                ["ply"] = ply
            })
			lyx:JSONSave("gm3_permamodel.txt", tbl)
		end
	else
		local val = lyx:JSONLoad("gm3_permamodel.txt")
		if val then
			val[ply:SteamID()] = self:GetClientInfo("model")
			lyx:JSONSave("gm3_permamodel.txt", tbl)
			
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "Your model has been set.",
                ["ply"] = ply
            })
			ply:SetModel(self:GetClientInfo("model"))
		else
			local tbl = {}
			tbl[ply:SteamID()] = self:GetClientInfo("model")
			lyx:JSONSave("gm3_permamodel.txt", tbl)

			ply:SetModel(self:GetClientInfo("model"))
            lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Permamodel",["color2"] = Color(255,255,255),["text"] = "Your model has been set.",
                ["ply"] = ply
            })
		end
	end

	return true
end

function TOOL.BuildCPanel(panel)

	panel:AddControl("Header",{Text = "PermaModel", Description = "Perma Model\n Permanently changes a players model!\n"})
	panel:AddControl("TextBox",{Label = "#tool.gm3_permamodel.model", Command = "gm3_permamodel_model"})

end

function TOOL:DrawToolScreen(width, height)

	if SERVER then return end

	surface.SetDrawColor(110, 36, 179)
	surface.DrawRect(0, 0, 256, 256)

	surface.SetFont("PermaModelToolScreenFont")
	local w, h = surface.GetTextSize(" ")
	surface.SetFont("PermaModelToolScreenSubFont")
	local w2, h2 = surface.GetTextSize(" ")

	draw.SimpleText("Perma Model", "PermaModelToolScreenFont", 128, 100, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)
	draw.SimpleText("By Justice", "PermaModelToolScreenSubFont", 128, 128 + (h + h2) / 2 - 4, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)

end