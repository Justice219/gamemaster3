-- Incoludes
include("shared.lua")
local imgui = include("lyx_core/thirdparty/cl_lyx_imgui.lua")

function ENT:DrawTranslucent()
    self:DrawModel()
    
    if imgui.Entity3D2D(self, Vector(-3,6,1.6), Angle(0,90,0), 0.1) then

        -- Main UI
        draw.RoundedBox(6, -145,-1, 170, 50, Color(36,33,33,222))
        draw.SimpleText("Datapad", imgui.xFont("!Roboto@26"),-100, -0, Color(223,189,41)) 
        draw.SimpleText("Press E To View" .. "", imgui.xFont("!Roboto@20"),-120, 25, Color(255,255,255))  


        imgui.End3D2D()
    end
end

local function configMenu(ent)
    if IsValid(gm3.DatapadMenu) then
        gm3.DatapadMenu:Remove()
    end

    gm3.DatapadMenu = vgui.Create("GM3.Datapad.Menu")
    gm3.DatapadMenu:SetDatapadEntity(ent)
    gm3.DatapadMenu.SideBar:SelectItem("Datapad Viewer")
end

net.Receive("GM3:Entities:Datapad:Open", function(len, ply)
    configMenu(net.ReadEntity())
end)

-- local function configMenu(ent)
--     local tabs = {}
--     local data = {}
--     local funcs = {}
--     local entData = util.JSONToTable(ent:GetDataTable())

--     local function ScaleW(size)
--         return ScrW() * size/1920
--     end
--     local function ScaleH(size)
--         return ScrH() * size/1080        
--     end

--     surface.CreateFont("menu_title", {
--         font = "Roboto",
--         size = 20,
--         weight = 500,
--         antialias = true,
--         shadow = false
--     })
--     surface.CreateFont("menu_button", {
--         font = "Roboto",
--         size = 22.5,
--         weight = 500,
--         antialias = true,
--         shadow = false
--     })

--     local panel = vgui.Create("DFrame")
--     panel:TDLib()
--     panel:SetTitle("GM2 by Justice#4956")
--     panel:ShowCloseButton(false)
--     panel:SetSize(ScaleW(960), ScaleH(540))
--     panel:Center()
--     panel:MakePopup()
--     panel:ClearPaint()
--         :Background(Color(40, 41, 40), 6)
--         :Text("Datapad Viewer", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(405), ScaleH(-240))
--         :Text("v1.0", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(5),ScaleH(250))
--         :CircleHover(Color(59, 59, 59), 5, 20)

--     local panel2 = panel:Add("DPanel")
--     panel2:TDLib()
--     panel2:SetPos(ScaleW(0), ScaleH(60))
--     panel2:SetSize(ScaleW(1920), ScaleH(5))
--     panel2:ClearPaint()
--         :Background(Color(255, 255, 255), 0)

--     local panel3 = panel:Add("DPanel")
--     panel3:TDLib()
--     panel3:SetPos(ScaleW(275), ScaleH(60))
--     panel3:SetSize(ScaleW(5), ScaleH(1000))
--     panel3:ClearPaint()
--         :Background(Color(255, 255, 255), 0)


--     local close = panel:Add("DImageButton")
--     close:SetPos(ScaleW(925),ScaleH(10))
--     close:SetSize(ScaleW(20),ScaleH(20))
--     close:SetImage("icon16/cross.png")
--     close.DoClick = function()
--         panel:Remove()
--     end

--     local scroll = panel:Add("DScrollPanel")
--     scroll:SetPos(ScaleW(17.5), ScaleH(75))
--     scroll:SetSize(ScaleW(240), ScaleW(425))
--     scroll:TDLib()
--     scroll:ClearPaint()
--         --:Background(Color(0, 26, 255), 6)
--         :CircleHover(Color(59, 59, 59), 5, 20)

--     local function ChangeTab(name)
--         print("Changing Tab")
--         for k,v in pairs(data) do
--             table.RemoveByValue(data, v)
--             v:Remove()
--             print("Removed")
--         end

--         local tbl = tabs[name]
--         tbl.change()

--     end
    
--     local function CreateTab(name, tbl)
--         local scroll = scroll:Add( "DButton" )
--         scroll:SetText( name)
--         scroll:Dock( TOP )
--         scroll:SetTall( 50 )
--         scroll:DockMargin( 0, 5, 0, 5 )
--         scroll:SetTextColor(Color(255,255,255))
--         scroll:TDLib()
--         scroll:SetFont("menu_button")
--         scroll:SetIcon(tbl.icon)
--         scroll:ClearPaint()
--             :Background(Color(59, 59, 59), 5)
--             :BarHover(Color(255, 255, 255), 3)
--             :CircleClick()
--         scroll.DoClick = function()
--             ChangeTab(name)
--         end

--         if tabs[name] then return end
--         tabs[name] = tbl
--     end
--     CreateTab("Datapad", {
--         icon = "icon16/page_white_text.png",
--         change = function()
--             local d = {}
--             local p = nil

--             main = panel:Add("DPanel")
--             main:SetPos(ScaleW(290), ScaleH(75))
--             main:SetSize(ScaleW(660), ScaleH(455))
--             main:TDLib()
--             main:ClearPaint()
--                 :Background(Color(59, 59, 59), 6)
--                 :Text("Datapad Information", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(210),ScaleH(-202.5))
--             table.insert(d, #d, main)

--             dinfo = panel:Add("DPanel")
--             dinfo:SetPos(ScaleW(300), ScaleH(125))
--             dinfo:SetSize(ScaleW(640), ScaleH(395))
--             dinfo:TDLib()
--             dinfo:ClearPaint()
--                 :Background(Color(40,41,40), 6)

--             name = panel:Add("DLabel")
--             name:SetPos(ScaleW(310), ScaleH(150))
--             name:SetSize(ScaleW(600), ScaleH(50))
--             name:SetFont("menu_title")
--             name:SetTextColor(Color(255,255,255))
--             name:SetText("Name: " .. entData["name"])

--             desc = panel:Add("DLabel")
--             desc:SetPos(ScaleW(310), ScaleH(180))
--             desc:SetSize(ScaleW(600), ScaleH(50))
--             desc:SetFont("menu_title")
--             desc:SetTextColor(Color(255,255,255))
--             desc:SetText("Description: " .. entData["desc"])

--             text = panel:Add("RichText")
--             text:SetPos(ScaleW(310), ScaleH(225))
--             text:SetSize(ScaleW(600), ScaleH(275))
--             text:TDLib()
--             text:SetText(entData["text"])
--             text:ClearPaint()
--                 :Background(Color(59, 59, 59), 6)



--             for k,v in pairs(d) do
--                 table.insert(data, #data, v)
--             end
--         end
--     })
--     if gm.client.data.main.ranks[LocalPlayer():GetUserGroup()] then
--         CreateTab("Config", {
--             icon = "icon16/wrench.png",
--             change = function()
--                 local d = {}
--                 local p = nil
    
--                 main = panel:Add("DPanel")
--                 main:SetPos(ScaleW(290), ScaleH(75))
--                 main:SetSize(ScaleW(660), ScaleH(455))
--                 main:TDLib()
--                 main:ClearPaint()
--                     :Background(Color(59, 59, 59), 6)
--                     :Text("Model Configuration", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(210),ScaleH(-202.5))
--                 table.insert(d, #d, main)
    
--                 dinfo = panel:Add("DPanel")
--                 dinfo:SetPos(ScaleW(300), ScaleH(125))
--                 dinfo:SetSize(ScaleW(640), ScaleH(395))
--                 dinfo:TDLib()
--                 dinfo:ClearPaint()
--                     :Background(Color(40,41,40), 6)
    
--                 nameLabel = dinfo:Add("DLabel")
--                 nameLabel:SetPos(ScaleW(10), ScaleH(10))
--                 nameLabel:SetSize(ScaleW(600), ScaleH(50))
--                 nameLabel:SetFont("menu_title")
--                 nameLabel:SetText("Model String")

--                 name = dinfo:Add("DTextEntry")
--                 name:SetPos(ScaleW(10), ScaleH(50))
--                 name:SetSize(ScaleW(620), ScaleH(25))
--                 name:SetText(entData["name"])
--                 name:SetFont("menu_title")
--                 name.Paint = function(self, w, h)
--                     draw.RoundedBox( 6, 0, 0, w, h, Color(59, 59, 59))
--                     self:DrawTextEntryText(Color(255, 255, 255), Color(255, 0, 0), Color(255, 255, 255))
--                 end

--                 descLabel = dinfo:Add("DLabel")
--                 descLabel:SetPos(ScaleW(10), ScaleH(80))
--                 descLabel:SetSize(ScaleW(600), ScaleH(50))
--                 descLabel:SetFont("menu_title")
--                 descLabel:SetText("Description")

--                 desc = dinfo:Add("DTextEntry")
--                 desc:SetPos(ScaleW(10), ScaleH(120))
--                 desc:SetSize(ScaleW(620), ScaleH(25))
--                 desc:SetText(entData["desc"])
--                 desc:SetFont("menu_title")
--                 desc.Paint = function(self, w, h)
--                     draw.RoundedBox( 6, 0, 0, w, h, Color(59, 59, 59))
--                     self:DrawTextEntryText(Color(255, 255, 255), Color(255, 0, 0), Color(255, 255, 255))
--                 end

--                 textLabel = dinfo:Add("DLabel")
--                 textLabel:SetPos(ScaleW(10), ScaleH(150))
--                 textLabel:SetSize(ScaleW(600), ScaleH(50))
--                 textLabel:SetFont("menu_title")
--                 textLabel:SetText("Text")

--                 text = dinfo:Add("DTextEntry")
--                 text:SetPos(ScaleW(10), ScaleH(190))
--                 text:SetSize(ScaleW(620), ScaleH(25))
--                 text:SetText(entData["text"])
--                 text:SetFont("menu_title")
--                 text.Paint = function(self, w, h)
--                     draw.RoundedBox( 6, 0, 0, w, h, Color(59, 59, 59))
--                     self:DrawTextEntryText(Color(255, 255, 255), Color(255, 0, 0), Color(255, 255, 255))
--                 end
            
    
--                 update = dinfo:Add("DButton")
--                 update:SetPos(ScaleW(10), ScaleH(330))
--                 update:SetSize(ScaleW(620), ScaleH(50))
--                 update:SetText("Update")
--                 update:SetFont("menu_button")
--                 update:SetTextColor(Color(255,255,255))
--                 update:TDLib()
--                 update:ClearPaint()
--                     :Background(Color(59, 59, 59), 5)
--                     :BarHover(Color(255, 255, 255), 3)
--                     :CircleClick()
--                 update.DoClick = function()
--                     local data = {
--                         name = name:GetValue(),
--                         desc = desc:GetValue(),
--                         text = text:GetValue()
--                     }
--                     net.Start("GM2:Entities:Datapad:Set")
--                     net.WriteEntity(ent)
--                     net.WriteTable(data)
--                     net.SendToServer()

--                     panel:Remove()
--                     chat.AddText(Color(207,226,31), "[Datapad]" , Color(255,255,255), " Updated entity data!")
--                 end
    
    
--                 for k,v in pairs(d) do
--                     table.insert(data, #data, v)
--                 end
--             end
--         })
--     end
--     ChangeTab("Datapad")
-- end

-- net.Receive("GM3:Entities:Datapad:Open", function(len, ply)
--     configMenu(net.ReadEntity())
-- end)