local PANEL = {}

function PANEL:Init()
    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))

    local function searchModules(search)
        local modules = {}
        for k,v in pairs(gm3.tools) do
            if string.find(string.lower(k), string.lower(search)) then
                table.insert(modules, table.Count(modules) + 1, v)
            end
        end
        return modules
    end

    local function makeDefaultButtons()
        self.SearchBar = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
        self.SearchBar:Dock(TOP)
        self.SearchBar:DockMargin(lyx.Scale(3), lyx.Scale(3), lyx.Scale(3), lyx.Scale(3))
        self.SearchBar:SetPlaceholderText("Search")
        self.SearchBar:SetTall(lyx.Scale(45))
        self.SearchBar.OnEnter = function(self)
            self:GetParent():Clear()
            makeDefaultButtons()
            local modules = searchModules(self:GetValue())
            for k,v in pairs(modules) do
                local Module = vgui.Create("GM3.Components.Module", self:GetParent())
                Module:Dock(TOP)
                Module:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
                Module:SetModule(v)
                Module:SetTall(lyx.Scale(300))

                timer.Simple(0.1, function() Module:Resize() end)
            end
        end
    end

    makeDefaultButtons()

    for k,v in pairs(gm3.tools) do
        local Module = vgui.Create("GM3.Components.Module", self.ScrollPanel)
        Module:Dock(TOP)
        Module:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
        Module:SetModule(v)
        Module:SetTall(lyx.Scale(300))

        timer.Simple(0.1, function() Module:Resize() end)
    end
end

function PANEL:SetPlayer(ply)
   
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, lyx.Colors.Foreground)
end


vgui.Register("GM3.Pages.Modules", PANEL)
