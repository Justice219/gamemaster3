local PANEL = {}

function PANEL:Init()

end

lyx.RegisterFont("GM3.Components.Player", "Open Sans SemiBold", 20)
surface.CreateFont("Roboto Black", {
    font = "Roboto Bold",
    size = lyx.Scale(16),
    weight = 1000,
    antialias = true,
    shadow = false
})

function PANEL:SetPlayer(ply)
    ply = ply

    self.Label = vgui.Create("lyx.Label2", self)
    self.Label:SetText("Player Name: " ..ply:Nick())
    self.Label:Dock(TOP)
    self.Label:DockMargin(lyx.ScaleW(15), lyx.Scale(14), lyx.ScaleW(0), lyx.Scale(0))
    self.Label:SetFont("GM3.Components.Player")
    self.Label:SetWide(lyx.Scale(200))

    self.Kill = vgui.Create("lyx.TextButton2", self)
    self.Kill:SetText("Kill Player")
    self.Kill:SetFont("GM3.Components.Player")
    self.Kill:Dock(TOP)
    self.Kill:DockMargin(lyx.ScaleW(15), lyx.Scale(12), lyx.ScaleW(15), lyx.Scale(12))
    self.Kill.DoClick = function()
         surface.PlaySound("buttons/button10.wav")

         net.Start("gm3:player:kill")
            net.WriteString(ply:SteamID())
         net.SendToServer()
    end

    -- send message label
    self.MessageLabel = vgui.Create("lyx.Label2", self)
    self.MessageLabel:SetText("Send Message")
    self.MessageLabel:Dock(TOP)
    self.MessageLabel:DockMargin(lyx.ScaleW(15), lyx.Scale(-0), lyx.ScaleW(15), lyx.Scale(0))
    self.MessageLabel:SetFont("GM3.Components.Player")

    -- send message text entry
    -- header entry
    self.HeaderEntry = vgui.Create("lyx.TextEntry2", self)
    self.HeaderEntry:Dock(TOP)
    self.HeaderEntry:DockMargin(lyx.ScaleW(10), lyx.Scale(0), lyx.ScaleW(10), lyx.Scale(10))
    self.HeaderEntry:SetTall(lyx.Scale(40))
    self.HeaderEntry:SetPlaceholderText("Enter your header here...")

    self.MessageEntry = vgui.Create("lyx.TextEntry2", self)
    self.MessageEntry:Dock(TOP)
    self.MessageEntry:DockMargin(lyx.ScaleW(10), lyx.Scale(0), lyx.ScaleW(10), lyx.Scale(10))
    self.MessageEntry:SetTall(lyx.Scale(40))
    self.MessageEntry:SetPlaceholderText("Enter your message here...")

    -- send message button
    self.MessageButton = vgui.Create("lyx.TextButton2", self)
    self.MessageButton:SetText("Send Message")
    self.MessageButton:SetFont("GM3.Components.Player")
    self.MessageButton:Dock(TOP)
    self.MessageButton:DockMargin(lyx.ScaleW(15), lyx.Scale(0), lyx.ScaleW(15), lyx.Scale(12))
    self.MessageButton.DoClick = function()
        --! FIX THIS SHIT ASS CODE LOL
        surface.PlaySound("buttons/button10.wav")
        local header = self.HeaderEntry:GetValue()
        local message = self.MessageEntry:GetValue()
        if header == "" then 
            header = "No header was sent..."
        end
        if message == "" then 
            message = "No message was sent..."
        end

        net.Start("gm3:player:message")
            net.WriteString(ply:SteamID())
            net.WriteString(header)
            net.WriteString(message)
        net.SendToServer()
    end



end

function PANEL:Resize()
    self:SetTall(self.Height)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, Color(22, 22, 22,183))
end

vgui.Register("GM3.Components.Player", PANEL)