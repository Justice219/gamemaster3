gm3 = gm3
gm3.tools = gm3.tools or {}
gm3.ranks = gm3.ranks or {}

lyx = lyx

--! THIS FUCKING PANEL SUCKS HAHAH
--+ DO NOT USE THIS AS TUTORIAL CODE 🤑😓😓
local function openMenu()
    local frame = vgui.Create("lyx_frame")
    frame:ShowNavbar(true)
    frame:SetTitle("Gamemaster 3 v1.4")

    -- *! THIS IS THE DASHBOARD PAGE !*
    --+ This is the first page that will be shown when the menu is opened.
    --+ This page is used to display information about the gamemaster tools and ranks.
    --+ This page is also used to display information about the gamemaster itself.
    frame.Navbar:AddButton("Dash", lyx.Colors1.Primary, lyx.Icons1.Info, function(pnl)
        pnl:Clear()

        local label = pnl:Add("DLabel")
        label:SetText("Dashboard")
        label:SetFont("lyx.font.title")
        label:SetTextColor(lyx.Colors1.White)
        label:SetPos(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(5))
        label:SizeToContents()

        local dashTable = vgui.Create("lyx_table", pnl)
        dashTable:SetSize(pnl:GetWide() - lyx.Scaling1.ScaleW(30), lyx.Scaling1.ScaleH(100))
        dashTable:SetPos(lyx.Scaling1.ScaleW(15), lyx.Scaling1.ScaleH(25))

        local richInfo = vgui.Create("RichText", pnl)
        richInfo:SetSize(pnl:GetWide() - lyx.Scaling1.ScaleW(30), lyx.Scaling1.ScaleH(100))
        richInfo:SetPos(lyx.Scaling1.ScaleW(15), lyx.Scaling1.ScaleH(150))
        richInfo:InsertColorChange(255, 255, 255, 255)
        richInfo:AppendText("Gamemaster 3 is a gamemastering tool that allows you to make your events better and more immersive." ..
        "This tool is made by Justice#4956, as a competetor for other event addons and as a remake of Gamemaster 2")

        local count = 0
        local count2 = 0
        for k, v in pairs(gm3.tools) do
            count = count + 1
        end
        for k, v in pairs(gm3.ranks) do
            count2 = count2 + 1
        end

        dashTable:AddTableItem("Gamemaster Tools", {
            name = "Gamemaster Tools",
            value = count,
        })
        dashTable:AddTableItem("Gamemaster Ranks", {
            name = "Gamemaster Ranks",
            value = count2,
        })

        dashTable:Setup()

    end)

    -- *! Tools Page !*
    --+ This page is used to display all the tools that are available to the gamemaster.
    --+ This page is also used to display information about the tools and run them.
    frame.Navbar:AddButton("Tools", lyx.Colors1.Primary, lyx.Icons1.Stats, function(pnl)
        pnl:Clear()

        local toolSelect = nil
        local args = {}

        --! PANEL LABEL !--
        local label = pnl:Add("DLabel")
        label:SetText("Gamemaster Tools")
        label:SetFont("lyx.font.title")
        label:SetTextColor(lyx.Colors1.White)
        label:SetPos(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(5))
        label:SizeToContents()

        --! TOOL INFORMATION LABELS !--
        local toolInfo = vgui.Create("DPanel", pnl)
        toolInfo:SetSize(390, lyx.Scaling1.ScaleH(230))
        toolInfo:SetPos(lyx.Scaling1.ScaleW(550), lyx.Scaling1.ScaleH(25))
        toolInfo:TDLib()
        toolInfo:ClearPaint()   
            :Background(lyx.Colors1.Primary, 6)
            :Outline(lyx.Colors1.Primary, 1)
        local toolTitle = toolInfo:Add("DLabel")
            toolTitle:SetText("Tool Information")
            toolTitle:SetFont("lyx.font.title")
            toolTitle:SetTextColor(lyx.Colors1.White)
            toolTitle:Dock(TOP)
            toolTitle:SizeToContents()
            toolTitle:DockMargin(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(10), 0, 0)
        local toolName = toolInfo:Add("DLabel")
            toolName:SetText("Tool Name: ")
            toolName:SetFont("lyx.font.subtitle")
            toolName:SetTextColor(lyx.Colors1.White)
            toolName:Dock(TOP)
            toolName:SizeToContents()
            toolName:DockMargin(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(10), 0, 0)
        local toolDesc = toolInfo:Add("RichText")
            toolDesc:SetText("Tool Description: ")
            toolDesc:Dock(TOP)
            toolDesc:SizeToContents()
            toolDesc:DockMargin(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(10), 0, 0)
        --! END OF TOOL INFORMATION LABELS !--

        --! RUNNING + ARGUMENTS !--
        local toolArguments = nil 
        local function addArguments()
            toolArguments = toolInfo:Add("lyx_list")
            toolArguments:SetSize(lyx.Scaling1.ScaleW(150), lyx.Scaling1.ScaleH(100))
            toolArguments:SetPos(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(75))
            toolArguments:Dock(TOP)
            toolArguments:DockMargin(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(20), lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(10))
        end

        local toolButton = toolInfo:Add("lyx_button")
        toolButton:SetText("Run")
        toolButton:SetSize(lyx.Scaling1.ScaleW(150), lyx.Scaling1.ScaleH(15))
        toolButton:SetPos(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(190))
        toolButton:Inverse()
        toolButton:Dock(BOTTOM)
        toolButton:DockMargin(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(10), lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(10))
        --! END OF RUNNING + ARGUMENTS !--

        --? LIST OF TOOLS !--
        -- search bar
        local search = vgui.Create("lyx_entry", pnl)
        search:SetSize(pnl:GetWide() - lyx.Scaling1.ScaleW(750), lyx.Scaling1.ScaleH(20))
        search:SetPos(lyx.Scaling1.ScaleW(650), lyx.Scaling1.ScaleH(5))
        search:SetText("Tool Search")
        search:SetFont("lyx.font.subtitle")

        local toolsTable = nil
        local function addTools()
            toolsTable = vgui.Create("lyx_list", pnl)
            toolsTable:SetSize(pnl:GetWide() - lyx.Scaling1.ScaleW(750), lyx.Scaling1.ScaleH(230))
            toolsTable:SetPos(lyx.Scaling1.ScaleW(15), lyx.Scaling1.ScaleH(25))
        end
        addTools()

        search.OnValueChange = function(self)
            toolsTable:Remove()
            addTools()
            for k,v in pairs(gm3.tools) do
                if (string.find(k, self:GetValue())) then
                    toolsTable:AddButton(k, {
                        buttonText = "Select",
                        callback = function()
                            toolSelect = k
                            args = {}
        
                            --? Updates the toolName and toolDesc labels.
                            toolName:SetText("Tool Name: " .. k)
                            toolDesc:SetText("Tool Description: " .. v.description)
                            
                            for k,v in pairs(v.args) do
                                args[k] = v.def
                            end
        
                            -- clear the arguments list
                            if toolArguments then
                                toolArguments:Remove()
                                addArguments()
                            end
                            for k,v in pairs(v.args) do
                                if v.type == "string" then
                                    toolArguments:AddEntry(k, {
                                        value = v.def,
                                        callback = function(pnl, text)
                                            args[k] = text
                                        end
                                    })
                                elseif v.type == "number" then
                                    toolArguments:AddEntry(k, {
                                        value = v.def,
                                        callback = function(pnl, text)
                                            if tonumber(text) then
                                                args[k] = tonumber(text)
                                            else
                                                chat.AddText(Color(255,0,0), "Please enter a valid number.")
                                            end
                                        end
                                    })
                                elseif v.type == "boolean" then
                                    toolArguments:AddCheckbox(k, {
                                        value = v.def,
                                        callback = function(pnl, val)
                                            args[k] = val
                                        end
                                    })
                                end
                            end
                            toolArguments:Setup()
        
                            chat.AddText(Color(0,238,255), "You have selected the tool: ", lyx.Colors1.White, k)
                        end
                    }) 
                end
            end
            toolsTable:Setup()
            
        end

        --? This is where the tools are added to the table.
        --+ Allows them to be selected and ran.
        addArguments()
        for k,v in pairs(gm3.tools) do
            toolsTable:AddButton(k, {
                buttonText = "Select",
                callback = function()
                    toolSelect = k
                    args = {}

                    --? Updates the toolName and toolDesc labels.
                    toolName:SetText("Tool Name: " .. k)
                    toolDesc:SetText("")
                    toolDesc:SetText("Tool Description: " .. v.description)
                    
                    for k,v in pairs(v.args) do
                        args[k] = v.def
                    end

                    -- clear the arguments list
                    if toolArguments then
                        toolArguments:Remove()
                        addArguments()
                    end
                    for k,v in pairs(v.args) do
                        if v.type == "string" then
                            toolArguments:AddEntry(k, {
                                value = v.def,
                                callback = function(pnl, text)
                                    args[k] = text
                                end
                            })
                        elseif v.type == "number" then
                            toolArguments:AddEntry(k, {
                                value = v.def,
                                callback = function(pnl, text)
                                    if tonumber(text) then
                                        args[k] = tonumber(text)
                                    else
                                        chat.AddText(Color(255,0,0), "Please enter a valid number.")
                                    end
                                end
                            })
                        elseif v.type == "boolean" then
                            toolArguments:AddCheckbox(k, {
                                value = v.def,
                                callback = function(pnl, val)
                                    args[k] = val
                                end
                            })
                        end
                    end
                    toolArguments:Setup()

                    chat.AddText(Color(0,238,255), "You have selected the tool: ", lyx.Colors1.White, k)
                end
            })
        end

        --todo- RUN BUTTON CODE
        toolButton.DoClick = function()
            if toolSelect then
                net.Start("gm3:tool:run")
                    net.WriteString(toolSelect)
                    net.WriteTable(args)
                net.SendToServer()
            else
                chat.AddText(Color(255,0,0), "Please select a tool first.")
            end
        end

        toolsTable:Setup()

    end)
    frame.Navbar:AddButton("Ranks", lyx.Colors1.Primary, lyx.Icons1.Sell, function(pnl)
        pnl:Clear()
        local r = "admin"

        local label = pnl:Add("DLabel")
        label:SetText("Panel Rank Options")
        label:SetFont("lyx.font.title")
        label:SetTextColor(lyx.Colors1.White)
        label:SetPos(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(5))
        label:SizeToContents()


        local rankOptions = vgui.Create("lyx_list", pnl)
        rankOptions:SetSize(pnl:GetWide() - lyx.Scaling1.ScaleW(30), lyx.Scaling1.ScaleH(40))
        rankOptions:SetPos(lyx.Scaling1.ScaleW(15), lyx.Scaling1.ScaleH(25))

        rankOptions:AddEntry("Rank Name", {
            value = "admin",
            callback = function(box, value)
                r = value
            end,
        })
        rankOptions:Setup()

        local button = pnl:Add("lyx_button")
        button:SetText("Add Rank")
        button:SetPos(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(70))
        button:SetSize(lyx.Scaling1.ScaleW(1235), lyx.Scaling1.ScaleH(15))
        button.DoClick = function()
            if r then
                net.Start("gm3:rank:add")
                    net.WriteString(r)
                net.SendToServer()
                chat.AddText(Color(0,255,242), "[GM3] ", lyx.Colors1.White, "Added rank " .. r)
                frame:Remove()
            end
        end

        local rankList = vgui.Create("lyx_list", pnl)
        rankList:SetSize(pnl:GetWide() - lyx.Scaling1.ScaleW(30), lyx.Scaling1.ScaleH(150))
        rankList:SetPos(lyx.Scaling1.ScaleW(15), lyx.Scaling1.ScaleH(90))
        for k,v in pairs(gm3.ranks) do
            rankList:AddButton(k, {
                buttonText = "Select",
                callback = function(box, value)
                    r = k
                    chat.AddText(Color(0,255,242), "[GM3] ", lyx.Colors1.White, "Selected rank " .. k .. " for deletion.")
                end
            })
        end
        rankList:Setup()

        local button2 = pnl:Add("lyx_button")
        button2:SetText("Remove Rank")
        button2:SetPos(lyx.Scaling1.ScaleW(10), lyx.Scaling1.ScaleH(245))
        button2:SetSize(lyx.Scaling1.ScaleW(1235), lyx.Scaling1.ScaleH(15))
        button2.DoClick = function()
            net.Start("gm3:rank:remove")
                net.WriteString(r)
            net.SendToServer()
            frame:Remove()
        end
    end)

    frame:Setup()
    frame.Navbar:SetTab(1)
end