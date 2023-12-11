local PANEL = {}

function PANEL:Init()
    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))

    local CutscenesTitle = vgui.Create("lyx.Label2", self.ScrollPanel)
    CutscenesTitle:Dock(TOP)
    CutscenesTitle:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    CutscenesTitle:SetText("Cutscenes (Player must be on Chromium Branch to see...)")
    CutscenesTitle:SetFont("GM3.Title")
    CutscenesTitle:SetTextColor(Color(255, 255, 255))

    local LinkEntry = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    LinkEntry:Dock(TOP)
    LinkEntry:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    LinkEntry:SetTall(lyx.Scale(40))
    LinkEntry:SetValue("https://www.youtube.com/watch?v=xKmzRfkpQFA")

    local LinkButton = vgui.Create("lyx.TextButton2", self.ScrollPanel)
    LinkButton:Dock(TOP)
    LinkButton:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    LinkButton:SetTall(lyx.Scale(30))
    LinkButton:SetText("Play Global Cutscene")
    LinkButton:SetBackgroundColor(Color(63,61,61))
    LinkButton.DoClick = function()
        net.Start("gm3:panel:videoPlay")
            net.WriteString(LinkEntry:GetValue() or "https://www.youtube.com/watch?v=8xrX7JaXP6k")
        net.SendToServer()
    end

    local StopButton = vgui.Create("lyx.TextButton2", self.ScrollPanel)
    StopButton:Dock(TOP)
    StopButton:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    StopButton:SetTall(lyx.Scale(30))
    StopButton:SetText("Stop Global Cutscene")
    StopButton:SetBackgroundColor(Color(63,61,61))
    StopButton.DoClick = function()
        net.Start("gm3:panel:videoStop")
        net.SendToServer()
    end
end

function PANEL:SetPlayer(ply)
   
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, lyx.Colors.Foreground)
end


vgui.Register("GM3.Pages.Cutscenes", PANEL)
