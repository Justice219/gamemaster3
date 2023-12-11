local PANEL = {}

lyx.RegisterFont("GM3.Button", "Open Sans SemiBold", 20)

function PANEL:Init()
    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))

    for k,v in pairs(gm3.ranks) do
        local RankComponent = vgui.Create("GM3.Components.Rank", self.ScrollPanel)
        RankComponent:Dock(TOP)
        RankComponent:SetTall(lyx.Scale(50))
        RankComponent:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
        RankComponent:SetRank(k)
    end

    local RankEntry = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    RankEntry:Dock(TOP)
    RankEntry:DockMargin(lyx.ScaleW(3), lyx.Scale(20), lyx.ScaleW(3), lyx.Scale(3))
    RankEntry:SetPlaceholderText("Rank Name")
    RankEntry:SetTall(lyx.Scale(40))

    local RankButton = vgui.Create("lyx.TextButton2", self.ScrollPanel)
    RankButton:Dock(TOP)
    RankButton:DockMargin(lyx.ScaleW(3), lyx.Scale(3), lyx.ScaleW(3), lyx.Scale(3))
    RankButton:SetText("Add Rank")
    RankButton:SetFont("GM3.Button")
    RankButton:SetBackgroundColor(Color(68, 68, 68))

    RankButton.DoClick = function()
        local rank = RankEntry:GetValue()
        if rank == "" then
            chat.AddText(Color(38, 224, 94), "[MPRR] ", Color(255, 255, 255), "Please enter a rank name!")    
        return end

        net.Start("gm3:rank:add")
            net.WriteString(rank)
        net.SendToServer()

        gm3.Menu:Remove()
        gm3:SyncReopenMenu("Ranks")
    end
end

function PANEL:SetPlayer(ply)
   
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, lyx.Colors.Foreground)
end


vgui.Register("GM3.Pages.Ranks", PANEL)
