local PANEL = {}

function PANEL:Init()
    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))

    local function searchPlayers(search)
        local players = {}
        for k,v in pairs(player.GetAll()) do
            if string.find(string.lower(v:Nick()), string.lower(search)) then
                table.insert(players, table.Count(players) + 1, v)
            end
        end
        return players
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
            
            local players = searchPlayers(self:GetValue())
            for k,v in pairs(players) do
                local Module = vgui.Create("GM3.Components.Player", self:GetParent())
                Module:Dock(TOP)
                Module:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
                Module:SetPlayer(v)
                Module:SetTall(lyx.Scale(275))

            end
        end
    end

    makeDefaultButtons()

    for k,v in pairs(player.GetAll()) do
        local Module = vgui.Create("GM3.Components.Player", self.ScrollPanel)
        Module:Dock(TOP)
        Module:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
        Module:SetPlayer(v)
        Module:SetTall(lyx.Scale(275))

    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, lyx.Colors.Foreground)
end


vgui.Register("GM3.Pages.Player", PANEL)
