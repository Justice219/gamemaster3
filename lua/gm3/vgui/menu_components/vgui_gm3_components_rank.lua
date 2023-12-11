local PANEL = {}

function PANEL:Init()

end

lyx.RegisterFont("GM3.Components.Rank", "Open Sans SemiBold", 20)

function PANEL:SetRank(name)
    self.Label = vgui.Create("lyx.Label2", self)
    self.Label:SetText(name)
    self.Label:Dock(LEFT)
    self.Label:DockMargin(lyx.ScaleW(15), lyx.Scale(14), lyx.ScaleW(0), lyx.Scale(0))
    self.Label:SetFont("GM3.Components.Rank")
    self.Label:SetWide(lyx.Scale(200))

    self.RemoveRank = vgui.Create("lyx.TextButton2", self)
    self.RemoveRank:SetText("Remove")
    self.RemoveRank:SetFont("GM3.Components.Rank")
    self.RemoveRank:Dock(RIGHT)
    self.RemoveRank:DockMargin(lyx.ScaleW(0), lyx.Scale(12), lyx.ScaleW(15), lyx.Scale(12))
    self.RemoveRank.DoClick = function()
         surface.PlaySound("buttons/button10.wav")

         net.Start("gm3:rank:remove")
            net.WriteString(name)   
        net.SendToServer()

        self:Remove()
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, lyx.Colors.Foreground)
end

vgui.Register("GM3.Components.Rank", PANEL)