gm3 = gm3 or {}

local PANEL = {}

lyx.RegisterFont("GM3.Title", "Open Sans SemiBold", lyx.Scale(18))
lyx.RegisterFont("GM3.Button", "Open Sans SemiBold", 20)

function PANEL:Init()
    self:SetSize(lyx.Scale(1280), lyx.Scale(720))
    self:Center()
    self:SetTitle("Gamemaster 3: Revamped")
    self:MakePopup()

    local sidebar = self:CreateSidebar("Dashboard", nil, nil, lyx.Scale(10), lyx.Scale(10))

    sidebar:AddItem("Dashboard", "Dashboard", "NwmR5Gc", function() self:ChangeTab("GM3.Pages.Dashboard", "Dashboard") end)
    sidebar:AddItem("Modules", "Modules", "lOMzrJ6", function() self:ChangeTab("GM3.Pages.Modules", "Modules") end)
    sidebar:AddItem("Cutscenes", "Cutscenes", "LiuIplf", function() self:ChangeTab("GM3.Pages.Cutscenes", "Cutscenes") end)
    sidebar:AddItem("Player", "Player", "sy2ObLg", function() self:ChangeTab("GM3.Pages.Player", "Player") end)
    sidebar:AddItem("Opsat", "Opsat", "Y9BRhjr", function() self:ChangeTab("GM3.Pages.Opsat", "Opsat") end)
    sidebar:AddItem("Server", "Server", "mrDq6Ar", function() self:ChangeTab("GM3.Pages.Server", "Server") end)
    sidebar:AddItem("Commands", "Commands", "xkFWEkK", function() self:ChangeTab("GM3.Pages.Commands", "Commands") end)
    if LocalPlayer():GetUserGroup() == "superadmin" then
        sidebar:AddItem("Ranks", "Ranks", "J9YZQgp", function() self:ChangeTab("GM3.Pages.Ranks", "Ranks") end)
    end
end

function PANEL:ChangeTab(pnl, tabName)
    if self.ContentPanel and self.ContentPanel:IsValid() then
        self.ContentPanel:Remove()
    end

    self.ContentPanel = vgui.Create(pnl, self)
        self.ContentPanel:Dock(FILL)
        self.ContentPanel:DockMargin(lyx.Scale(10), lyx.Scale(10), lyx.Scale(10), lyx.Scale(10))
        self:SetTitle("Gamemaster 3: Revamped - " .. tabName)

    self.SideBar:SelectItem(tabName)
end

vgui.Register("GM3.Frame", PANEL, "lyx.Frame2")

lyx:NetAdd("gm3:menu:open", { 
    func = function()
        net.Start("gm3:sync:request")
        net.SendToServer()

        timer.Simple(0.1, function()
            if IsValid(gm3.Menu) then
                gm3.Menu:Remove()
            end

            gm3.Menu = vgui.Create("GM3.Frame")
        end)
    end
})