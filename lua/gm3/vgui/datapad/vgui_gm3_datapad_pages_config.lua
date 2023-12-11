local PANEL = {}

function PANEL:Init()
    local ent = self:GetParent().DatapadEntity
    local title = ent:GetTitle()

    self:AddTextField("Title", ent:GetTitle(), function(val)
        title = val
    end)

    local BodyEntry = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    BodyEntry:Dock(TOP)
    BodyEntry:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    BodyEntry:SetValue(ent:GetDescription())
    BodyEntry:SetTall(lyx.Scale(150))
    BodyEntry:SetMultiline(true)

    local UpdateDatapad = vgui.Create("lyx.TextButton2", self.ScrollPanel)
    UpdateDatapad:SetText("Update Record")
    UpdateDatapad:SetFont("MPRR.Title")
    UpdateDatapad:Dock(TOP)
    UpdateDatapad:SetTall(30)
    UpdateDatapad:DockMargin(lyx.ScaleW(0), lyx.Scale(12), lyx.ScaleW(15), lyx.Scale(12))
    UpdateDatapad.DoClick = function()
        surface.PlaySound("buttons/button10.wav")

        net.Start("GM3:Entities:Datapad:Set")
            net.WriteEntity(ent)
            net.WriteString(title)
            net.WriteString(BodyEntry:GetValue())
        net.SendToServer()
    end
end

vgui.Register("GM3.Datapad.Pages.DatapadConfig", PANEL, "lyx.PageBase")
