local PANEL = {}

surface.CreateFont("GM3.Datapad.Description", {
    font = "Roboto",
    size = lyx.Scale(15),
    weight = 500,
    antialias = true
})
surface.CreateFont("GM3.Datapad.Title", {
    font = "Roboto",
    size = lyx.Scale(20),
    weight = 500,
    antialias = true
})

function PANEL:Init()
    local ent = self:GetParent().DatapadEntity
    local title = ent:GetTitle()

    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))

    local DashboardTitle = vgui.Create("lyx.Label2", self.ScrollPanel)
    DashboardTitle:Dock(TOP)
    DashboardTitle:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    DashboardTitle:SetText("Title: " .. title)
    DashboardTitle:SetTall(lyx.Scale(25))
    DashboardTitle:SetFont("GM3.Datapad.Title")
    DashboardTitle:SetTextColor(Color(255, 255, 255))

    local DashboardText = vgui.Create("RichText", self.ScrollPanel)
    DashboardText:Dock(TOP)
    DashboardText:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    DashboardText:SetVerticalScrollbarEnabled(false)
    DashboardText:SetTall(lyx.Scale(100))
    DashboardText:SetText("Body: " .. ent:GetDescription())
    function DashboardText:PerformLayout()
        self:SetFontInternal("GM3.Datapad.Description")
        self:SetFGColor(Color(255, 255, 255))
    end
end

function PANEL:SetPlayer(ply)
   
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, lyx.Colors.Foreground)
end


vgui.Register("GM3.Datapad.Pages.DatapadViewer", PANEL)
