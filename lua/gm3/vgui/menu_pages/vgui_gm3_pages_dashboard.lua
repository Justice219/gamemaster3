local PANEL = {}

function PANEL:Init()
    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))

    self.DashboardText = vgui.Create("RichText", self)
    self.DashboardText:Dock(TOP)
    self.DashboardText:DockMargin(lyx.ScaleW(10), lyx.Scale(0), lyx.ScaleW(10), lyx.Scale(0))
    self.DashboardText:SetTall(lyx.Scale(200))
    function self.DashboardText:PerformLayout()
        self:SetFontInternal("Roboto Black")
    end
    self.DashboardText:InsertColorChange(186, 32, 55, 255)
    self.DashboardText:AppendText("Welcome to GM3: Revamped!\n")
    self.DashboardText:InsertColorChange(255, 255, 255, 255)
    self.DashboardText:AppendText("This is a brand new version of Gamemaster 3, built from the ground up to be more stable, \n" ..
     "more performant, and more feature-rich than ever before!\n\n")
    self.DashboardText:InsertColorChange(186, 32, 55, 255)
    self.DashboardText:AppendText("What's new?\n")
    self.DashboardText:InsertColorChange(255, 255, 255, 255)
    self.DashboardText:AppendText(" - A brand new UI!\n")
    self.DashboardText:AppendText(" - A new, powerful, chat command system! Need a good comms system? well! look no further than the commands tab!\n")
    self.DashboardText:AppendText(" - Better performance! GM3:R is built from the ground up to be more performant than ever before!\n")
    self.DashboardText:AppendText(" - A new, powerful, and easy to use permissions system! No more messing around with the old, clunky, system!\n")
    
end

function PANEL:SetPlayer(ply)
   
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, lyx.Colors.Foreground)
end


vgui.Register("GM3.Pages.Dashboard", PANEL)
