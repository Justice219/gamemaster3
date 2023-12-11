local PANEL = {}

function PANEL:Init()

end

lyx.RegisterFont("GM3.Components.Command", "Open Sans SemiBold", 20)
surface.CreateFont("Roboto Black", {
    font = "Roboto Bold",
    size = lyx.Scale(16),
    weight = 1000,
    antialias = true,
    shadow = false
})

function PANEL:SetCommand(cmd)
    self.cmd = cmd

    self.Label = vgui.Create("lyx.Label2", self)
    self.Label:SetText(cmd.command)
    self.Label:Dock(TOP)
    self.Label:DockMargin(lyx.ScaleW(15), lyx.Scale(14), lyx.ScaleW(0), lyx.Scale(0))
    self.Label:SetFont("GM3.Components.Command")
    self.Label:SetWide(lyx.Scale(200))

    self.CommandExample = vgui.Create("RichText", self)
    self.CommandExample:Dock(TOP)
    self.CommandExample:DockMargin(lyx.ScaleW(10), lyx.Scale(0), lyx.ScaleW(10), lyx.Scale(0))
    self.CommandExample:SetTall(lyx.Scale(20))
    function self.CommandExample:PerformLayout()
        self:SetFontInternal("Roboto Black")
    end

    local function setCommandExample()
        self.CommandExample:SetText("")
        self.CommandExample:InsertColorChange(cmd.color1.r, cmd.color1.g, cmd.color1.b, 255)
        if cmd.useHeader then
            -- remove first character from command
            self.CommandExample:AppendText(string.upper("[" .. string.sub(cmd.command, 2) .. "] "))
        end
        if cmd.showPlayerName then
            self.CommandExample:AppendText(LocalPlayer():Nick() .. ": ")
        end
        self.CommandExample:InsertColorChange(cmd.color2.r, cmd.color2.g, cmd.color2.b, 255)
        self.CommandExample:AppendText("Typed Message will show here.")
    end

    setCommandExample()

    local ranks 

    local EditRanks = vgui.Create("lyx.TextButton2", self)
    EditRanks:Dock(TOP)
    EditRanks:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    EditRanks:SetTall(lyx.Scale(30))
    EditRanks:SetText("Edit Ranks")
    EditRanks:SetBackgroundColor(Color(63,61,61))
    EditRanks.DoClick = function()
        for k,v in pairs(cmd.ranks) do
            if !gm3.ranks[k] then
                cmd.ranks[k] = nil
                net.Start("gm3:command:removeRank")
                    net.WriteString(cmd.command)
                    net.WriteString(k)
                net.SendToServer()
            end
        end

        local menu = DermaMenu()
        for k, v in pairs(gm3.ranks) do
            if cmd.ranks[k] then
                menu:AddOption( k, function()
                    net.Start("gm3:command:removeRank")
                        net.WriteString(cmd.command)
                        net.WriteString(k)
                    net.SendToServer()
                    gm3:SyncReopenMenu("Commands")
                end):SetIcon( "icon16/tick.png" )
            else
                menu:AddOption( k, function()
                    net.Start("gm3:command:addRank")
                        net.WriteString(cmd.command)
                        net.WriteString(k)
                    net.SendToServer()
                    gm3:SyncReopenMenu("Commands")
                end):SetIcon( "icon16/cross.png" )
            end
        end
        menu:Open()
    end

    local RemoveButton = vgui.Create("lyx.TextButton2", self)
    RemoveButton:Dock(TOP)
    RemoveButton:DockMargin(lyx.ScaleW(10), lyx.Scale(0), lyx.ScaleW(10), lyx.Scale(10))
    RemoveButton:SetTall(lyx.Scale(30))
    RemoveButton:SetText("Remove Chat Command")
    RemoveButton:SetBackgroundColor(Color(63,61,61))
    RemoveButton.DoClick = function()
        net.Start("gm3:command:remove")
            net.WriteString(cmd.command)
        net.SendToServer()

        gm3:SyncReopenMenu("Commands")
    end
end

function PANEL:Resize()
    self:SetTall(self.Height)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, Color(14, 11, 11,50))
end

vgui.Register("GM3.Components.Command", PANEL)