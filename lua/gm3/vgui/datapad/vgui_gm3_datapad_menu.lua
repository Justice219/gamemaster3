gm3 = gm3 or {}

local PANEL = {}

lyx.RegisterFont("GM3.Title", "Open Sans SemiBold", lyx.Scale(18))
lyx.RegisterFont("GM3.Button", "Open Sans SemiBold", 20)

function PANEL:Init()
    self:SetSize(lyx.Scale(1280), lyx.Scale(720))
    self:Center()
    self:SetTitle("Select a tab")
    self:MakePopup()

    local sidebar = self:CreateSidebar("Dashboard", nil, nil, lyx.Scale(10), lyx.Scale(10))

    sidebar:AddItem("Datapad Viewer", "Datapad Viewer", "NwmR5Gc", function() self:ChangeTab("GM3.Datapad.Pages.DatapadViewer", "Datapad Viewer") end)
    if gm3.ranks[LocalPlayer():GetUserGroup()] then
        sidebar:AddItem("Datapad Config", "Datapad Config", "NwmR5Gc", function() self:ChangeTab("GM3.Datapad.Pages.DatapadConfig", "Datapad Config") end)
    end
end

function PANEL:SetDatapadEntity(ent)
    self.DatapadEntity = ent
end

function PANEL:ChangeTab(pnl, tabName)
    if self.ContentPanel and self.ContentPanel:IsValid() then
        self.ContentPanel:Remove()
    end

    self.ContentPanel = vgui.Create(pnl, self)
        self.ContentPanel:Dock(FILL)
        self.ContentPanel:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
        self:SetTitle("Datapad - " .. tabName)

    self.SideBar:SelectItem(tabName)
end

vgui.Register("GM3.Datapad.Menu", PANEL, "lyx.Frame2")