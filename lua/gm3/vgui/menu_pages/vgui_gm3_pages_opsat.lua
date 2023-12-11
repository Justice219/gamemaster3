local PANEL = {}
gm3 = gm3 or {}
gm3.opsatData = gm3.opsatData or {}
gm3.opsatClientData = gm3.opsatClientData or {
    ["Title 1"] = "Information",
    ["Line 1"] = "Planet: KG3",
    ["Line 2"] = "Era: 22BBY",
    ["Title 2"] = "Objective",
    ["Line 3"] = "- Raid CIS Base",
    ["Line 4"] = "- Kill CIS Leader",
}

function PANEL:Init()
    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))

    --[[
                    ["Title 1"] = {
                type = "string",
                def = "Information"
            },
            ["Line 1"] = {
                type = "string",
                def = "Planet: KG3"
            },
            ["Line 2"] = {
                type = "string",
                def = "Era: 22BBY"
            },
            ["Title 2"] = {
                type = "string",
                def = "Objective"
            },
            ["Line 3"] = {
                type = "string",
                def = "- Kill Someone"
            },
            ["Line 4"] = {
                type = "string",
                def = "- Raid Base"
            },
        
    ]]--
            PrintTable(gm3.opsatClientData)

    local OpsatTitle = vgui.Create("lyx.Label2", self.ScrollPanel)
    OpsatTitle:Dock(TOP)
    OpsatTitle:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    OpsatTitle:SetText("Opsat")
    OpsatTitle:SetFont("GM3.Title")
    OpsatTitle:SetTextColor(Color(255, 255, 255))

    local OpsatTitleEntry1 = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    OpsatTitleEntry1:Dock(TOP)
    OpsatTitleEntry1:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    OpsatTitleEntry1:SetTall(lyx.Scale(40))
    OpsatTitleEntry1:SetPlaceholderText("Operation: Test")
    OpsatTitleEntry1:SetValue(gm3.opsatClientData["Title 1"])

    local OpsatDescEntryA1 = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    OpsatDescEntryA1:Dock(TOP)
    OpsatDescEntryA1:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    OpsatDescEntryA1:SetTall(lyx.Scale(40))
    OpsatDescEntryA1:SetPlaceholderText("Description1: Test")
    OpsatDescEntryA1:SetValue(gm3.opsatClientData["Line 1"])

    local OpsatDescEntryA2 = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    OpsatDescEntryA2:Dock(TOP)
    OpsatDescEntryA2:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    OpsatDescEntryA2:SetTall(lyx.Scale(40))
    OpsatDescEntryA2:SetPlaceholderText("Description2: Test")
    OpsatDescEntryA2:SetValue(gm3.opsatClientData["Line 2"])

    local OpsatTitleEntry2 = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    OpsatTitleEntry2:Dock(TOP)
    OpsatTitleEntry2:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    OpsatTitleEntry2:SetTall(lyx.Scale(40))
    OpsatTitleEntry2:SetPlaceholderText("Objective: Test")
    OpsatTitleEntry2:SetValue(gm3.opsatClientData["Title 2"])

    local OpsatDescEntryB1 = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    OpsatDescEntryB1:Dock(TOP)
    OpsatDescEntryB1:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    OpsatDescEntryB1:SetTall(lyx.Scale(40))
    OpsatDescEntryB1:SetPlaceholderText("Description1: Test")
    OpsatDescEntryB1:SetValue(gm3.opsatClientData["Line 3"])

    local OpsatDescEntryB2 = vgui.Create("lyx.TextEntry2", self.ScrollPanel)
    OpsatDescEntryB2:Dock(TOP)
    OpsatDescEntryB2:DockMargin(lyx.ScaleW(10), lyx.Scale(10), lyx.ScaleW(10), lyx.Scale(10))
    OpsatDescEntryB2:SetTall(lyx.Scale(40))
    OpsatDescEntryB2:SetPlaceholderText("Description2: Test")
    OpsatDescEntryB2:SetValue(gm3.opsatClientData["Line 4"])

    local AddOpsatButton = vgui.Create("lyx.TextButton2", self.ScrollPanel)
    AddOpsatButton:Dock(TOP)
    AddOpsatButton:DockMargin(lyx.Scale(3), lyx.Scale(3), lyx.Scale(3), lyx.Scale(3))
    AddOpsatButton:SetText("Create OPSAT")
    AddOpsatButton:SetBackgroundColor(Color(63,61,61))
    AddOpsatButton.DoClick = function()
        local tbl = {
            ["Title 1"] = OpsatTitleEntry1:GetValue() or "Information",
            ["Line 1"] = OpsatDescEntryA1:GetValue() or "Planet: KG3",
            ["Line 2"] = OpsatDescEntryA2:GetValue() or "Era: 22BBY",
            ["Title 2"] = OpsatTitleEntry2:GetValue() or "Objective",
            ["Line 3"] = OpsatDescEntryB1:GetValue() or "Raid CIS Base",
            ["Line 4"] = OpsatDescEntryB2:GetValue() or "Kill CIS Leader",
        }

        net.Start("gm3:tools:opsatSet")
        net.WriteTable(tbl)
        net.SendToServer()
    end

    local RemoveOpsatButton = vgui.Create("lyx.TextButton2", self.ScrollPanel)
    RemoveOpsatButton:Dock(TOP)
    RemoveOpsatButton:DockMargin(lyx.Scale(3), lyx.Scale(3), lyx.Scale(3), lyx.Scale(3))
    RemoveOpsatButton:SetText("Remove OPSAT")
    RemoveOpsatButton:SetBackgroundColor(Color(63,61,61))
    RemoveOpsatButton.DoClick = function()
        net.Start("gm3:tools:opsatRemove")
        net.SendToServer()
    end
end

function PANEL:SetPlayer(ply)
   
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, lyx.Colors.Foreground)
end


vgui.Register("GM3.Pages.Opsat", PANEL)
