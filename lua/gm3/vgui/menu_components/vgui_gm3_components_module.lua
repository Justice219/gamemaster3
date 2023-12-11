local PANEL = {}

function PANEL:Init()

end

lyx.RegisterFont("GM3.Components.Rank", "Open Sans SemiBold", 20)
surface.CreateFont("Roboto Black", {
    font = "Roboto Bold",
    size = lyx.Scale(16),
    weight = 1000,
    antialias = true,
    shadow = false
})

function PANEL:SetModule(module)
    local args = {}
    local height = 0

    self.Label = vgui.Create("lyx.Label2", self)
    self.Label:SetText(module.name)
    self.Label:Dock(TOP)
    self.Label:DockMargin(lyx.ScaleW(15), lyx.Scale(14), lyx.ScaleW(0), lyx.Scale(0))
    self.Label:SetFont("GM3.Components.Rank")
    self.Label:SetWide(lyx.Scale(200))
    height = height + self.Label:GetTall()

    self.Description = vgui.Create("RichText", self)
    self.Description:Dock(TOP)
    self.Description:DockMargin(lyx.ScaleW(15), lyx.Scale(0), lyx.ScaleW(15), lyx.Scale(0))
    self.Description:SetVerticalScrollbarEnabled(false)
    self.Description:InsertColorChange(255, 255, 255, 255)
    self.Description:SetText(module.description)
    function self.Description:PerformLayout()
        self:SetFontInternal("Roboto Black")
    end
    if string.len(module.description) > 80 then
        self.Description:SetTall(lyx.Scale(60))
    else 
        self.Description:SetTall(lyx.Scale(50))
    end
    if string.len(module.description) > 100 then
        self.Description:SetTall(lyx.Scale(70))
    end
    if string.len(module.description) > 150 then
        self.Description:SetTall(lyx.Scale(80))
    end
    height = height + self.Description:GetTall()

    self.ArgumentsScrollPanel = vgui.Create("DScrollPanel", self)
    self.ArgumentsScrollPanel:Dock(TOP)
    self.ArgumentsScrollPanel:DockMargin(lyx.ScaleW(15), lyx.Scale(0), lyx.ScaleW(15), lyx.Scale(0))
    self.ArgumentsScrollPanel:SetTall(lyx.Scale(50))
    self.ArgumentsScrollPanel:TDLib()
        :ClearPaint() 
        :Background(Color(34, 110, 57, 59))
    if table.Count(module.args) < 1 then
        self.ArgumentsScrollPanel:Remove()
    end

    local count = 0
    for k,v in pairs(module.args) do
        if v.type == "string" then
            local entry = vgui.Create("lyx.TextEntry2", self.ArgumentsScrollPanel)
            entry:Dock(TOP)
            entry:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
            entry:SetPlaceholderText(v.def)
            entry:SetValue(v.def)
            args[k] = v.def 
            entry:SetTall(lyx.Scale(30))
            function entry:OnValueChange(value)
                args[k] = value
            end
            count = count + 1
        elseif v.type == "number" then
            local entry = vgui.Create("lyx.TextEntry2", self.ArgumentsScrollPanel)
            entry:Dock(TOP)
            entry:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
            entry:SetPlaceholderText(v.def)
            entry:SetValue(v.def)
            args[k] = tonumber(v.def)
            entry:SetTall(lyx.Scale(30))
            function entry:OnValueChange(value)
                args[k] = tonumber(value)
            end
            count = count + 1
        elseif v.type == "boolean" then
            local checkbox = vgui.Create("lyx.Checkbox2", self.ArgumentsScrollPanel)
            checkbox:Dock(TOP)
            checkbox:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
            checkbox:SetTall(lyx.Scale(30))
            checkbox:SetToggle(v.def)
            args[k] = v.def
            function checkbox:OnValueChange(value)
                args[k] = value
            end
            count = count + 1
        end
    end
    self.ArgumentsScrollPanel:SetTall((lyx.Scale(50) * count))
    height = height + self.ArgumentsScrollPanel:GetTall()

    self.RunModule = vgui.Create("lyx.TextButton2", self)
    self.RunModule:SetText("Run")
    self.RunModule:SetFont("GM3.Components.Rank")
    self.RunModule:Dock(TOP)
    self.RunModule:DockMargin(lyx.ScaleW(15), lyx.Scale(12), lyx.ScaleW(15), lyx.Scale(12))
    self.RunModule.DoClick = function()
         surface.PlaySound("buttons/button10.wav")

         net.Start("gm3:tool:run")
            net.WriteString(module.name)
            net.WriteTable(args)
         net.SendToServer()

    end
    height = height + self.RunModule:GetTall()

    self.Height = height + lyx.Scale(40)
end

function PANEL:Resize()
    self:SetTall(self.Height)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, Color(94, 88, 88,50))
end

vgui.Register("GM3.Components.Module", PANEL)