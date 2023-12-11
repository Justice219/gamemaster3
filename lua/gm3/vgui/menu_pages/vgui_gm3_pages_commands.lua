gm3.commands = gm3.commands or {}
local PANEL = {}

lyx.RegisterFont("GM3.Components.Commands", "Open Sans SemiBold", 20)
function PANEL:Init()
    local cmd = {
        color1 = Color(255, 255, 255),
        color2 = Color(255, 255, 255),
        useHeader = false,
        showPlayerName = false,
        command = "/command",
        ranks = {}
    }

    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))

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

    self.CommandEntry = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    self.CommandEntry:Dock(TOP)
    self.CommandEntry:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    self.CommandEntry:SetTall(lyx.Scale(40))
    self.CommandEntry:SetPlaceholderText("ex. /force")
    function self.CommandEntry:OnValueChange(value)
        -- make sure there are no spaces
        if string.find(value, " ") then
                chat.AddText(Color(255, 0, 0), "No spaces allowed in command.")
            return end
        cmd.command = value
        setCommandExample()
    end

    local PrimaryColor = vgui.Create("DColorMixer", self.ScrollPanel)
    PrimaryColor:Dock(TOP)
    PrimaryColor:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    PrimaryColor:SetTall(lyx.Scale(75))
    PrimaryColor:SetPalette(false)
    PrimaryColor:SetAlphaBar(false)
    function PrimaryColor:ValueChanged(value)
        cmd.color1 = PrimaryColor:GetColor()
        setCommandExample()
    end

    local SecondaryColor = vgui.Create("DColorMixer", self.ScrollPanel)
    SecondaryColor:Dock(TOP)
    SecondaryColor:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    SecondaryColor:SetTall(lyx.Scale(75))
    SecondaryColor:SetPalette(false)
    SecondaryColor:SetAlphaBar(false)
    function SecondaryColor:ValueChanged(value)
        cmd.color2 = SecondaryColor:GetColor()
        setCommandExample()
    end

    self.HeaderCheckboxLabel = vgui.Create("lyx.Label2", self.ScrollPanel)
    self.HeaderCheckboxLabel:Dock(TOP)
    self.HeaderCheckboxLabel:DockMargin(lyx.ScaleW(10), lyx.Scale(0), lyx.ScaleW(10), lyx.Scale(0))
    self.HeaderCheckboxLabel:SetTall(lyx.Scale(20))
    self.HeaderCheckboxLabel:SetText("Use Header")
    self.HeaderCheckboxLabel:SetFont("GM3.Components.Commands")

    self.HeaderCheckbox = vgui.Create("lyx.Checkbox2", self.ScrollPanel)
    self.HeaderCheckbox:Dock(TOP)
    self.HeaderCheckbox:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    self.HeaderCheckbox:SetTall(lyx.Scale(15))
    self.HeaderCheckbox:SetText("Use Header")
    self.HeaderCheckbox.OnToggled = function(self, val)
        cmd.useHeader = val
        setCommandExample()
    end

    self.ShowPlayerNameCheckboxLabel = vgui.Create("lyx.Label2", self.ScrollPanel)
    self.ShowPlayerNameCheckboxLabel:Dock(TOP)
    self.ShowPlayerNameCheckboxLabel:DockMargin(lyx.ScaleW(10), lyx.Scale(0), lyx.ScaleW(10), lyx.Scale(0))
    self.ShowPlayerNameCheckboxLabel:SetTall(lyx.Scale(20))
    self.ShowPlayerNameCheckboxLabel:SetText("Show Player Name")
    self.ShowPlayerNameCheckboxLabel:SetFont("GM3.Components.Commands")

    self.ShowPlayerNameCheckbox = vgui.Create("lyx.Checkbox2", self.ScrollPanel)
    self.ShowPlayerNameCheckbox:Dock(TOP)
    self.ShowPlayerNameCheckbox:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    self.ShowPlayerNameCheckbox:SetTall(lyx.Scale(15))
    self.ShowPlayerNameCheckbox:SetText("Show Player Name")
    self.ShowPlayerNameCheckbox.OnToggled = function(self, val)
        cmd.showPlayerName = val
        setCommandExample()
    end

    self.CommandExample = vgui.Create("RichText", self.ScrollPanel)
    self.CommandExample:Dock(TOP)
    self.CommandExample:DockMargin(lyx.ScaleW(10), lyx.Scale(0), lyx.ScaleW(10), lyx.Scale(0))
    self.CommandExample:SetTall(lyx.Scale(20))
    self.CommandExample:SetText("Your Command - Set Some Data")
    function self.CommandExample:PerformLayout()
        self:SetFontInternal("Roboto Black")
    end

    local CreateButton = vgui.Create("lyx.TextButton2", self.ScrollPanel)
    CreateButton:Dock(TOP)
    CreateButton:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    CreateButton:SetTall(lyx.Scale(30))
    CreateButton:SetText("Create Chat Command")
    CreateButton:SetBackgroundColor(Color(63,61,61))
    CreateButton.DoClick = function()
        net.Start("gm3:command:create")
            net.WriteTable(cmd)
        net.SendToServer()

        gm3:SyncReopenMenu("Commands")
    end

    for k,v in pairs(gm3.commands) do
        local Module = vgui.Create("GM3.Components.Command", self.ScrollPanel)
        Module:Dock(TOP)
        Module:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
        Module:SetCommand(v)
        Module:SetTall(lyx.Scale(150))
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, lyx.Colors.Foreground)
end


vgui.Register("GM3.Pages.Commands", PANEL)
