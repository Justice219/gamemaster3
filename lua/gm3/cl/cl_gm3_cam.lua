gm3 = gm3
lyx = lyx

hook.Add("InitPostEntity", "GM3_Cam_Call", function()
    CamAngle = Angle()
    CamOriginalAngle = Angle(LocalPlayer():EyeAngles())
    CamPos = Vector(LocalPlayer():EyePos())
    CamOriginalPos = Vector(LocalPlayer():EyePos())
    CamSpeed = 2
    CamFOV = 90
    CamLock = false
    CamSensitivity = .02
    EnabledCam = false
    EnabledCamConfirm = false
end)

-- client ConVars
local gm3ZeusCam = {}
local CVCamFOV = CreateClientConVar("gm3Cam_fov", 90, true, false, "FOV of Simple FreeCam", 25, 179)
local CVCamSpeed = CreateClientConVar("gm3Cam_speed", 2, true, false, "Movement speed of Simple FreeCam", 0.1, 10)
local CVCamLock = CreateClientConVar("gm3Cam_lock", 0, true, false, "Lock Simple FreeCam", 0, 1)
local CVCamSens = CreateClientConVar("gm3Cam_sens", 0.02, true, false, "Mouse sensitivity of Simple FreeCam", 0.001, 1)
local gm3_entitiesToHighlight = {}
local gm3_entitiesCount = 0
local wireframeMat = Material("models/wireframe")
local gm3CamPanel = nil

local LastClick = 0
local delay = .1

surface.CreateFont("GM3_Cam_Subtitle", {
    font = "Roboto",
    size = 20,
    weight = 500,
    antialias = true,
    shadow = false
})
surface.CreateFont("GM3_Cam_Title", {
    font = "Roboto",
    size = 30,
    weight = 500,
    antialias = true,
    shadow = false,
    bold = true,
})

function gm3ZeusCam:CreateCamPanel(bool)
    if bool then
        if (gm3CamPanel) then
            gm3CamPanel:Remove()
        end

        -- draw a panel that covers the whole screen but is transparent
        gm3CamPanel = vgui.Create("DPanel")
        gm3CamPanel:SetSize(ScrW(), ScrH())
        gm3CamPanel:SetPos(0, 0)
        gm3CamPanel.Paint = function(self, w, h)
            surface.SetDrawColor( 0, 0, 0, 0)
            surface.DrawRect( 0, 0, w, h )
        end
        
        -- draw a bottom bar
        local gm3CamPanelBottom = vgui.Create("DPanel", gm3CamPanel)
        gm3CamPanelBottom:SetSize(ScrW(), lyx.Scale(60))
        gm3CamPanelBottom:SetPos(0, ScrH() - lyx.Scale(60))
        gm3CamPanelBottom.Paint = function(self, w, h)
            surface.SetDrawColor( 37, 36, 36)
            surface.DrawRect( 0, 0, w, h )
        end

        local cameraToggle = vgui.Create("lyx.TextButton2", gm3CamPanelBottom)
        cameraToggle:Dock(RIGHT)
        cameraToggle:DockMargin(lyx.Scale(5), lyx.Scale(5), lyx.Scale(5), lyx.Scale(5))
        cameraToggle:SetText("Toggle Zeus")
        cameraToggle:SetWide(lyx.Scale(150))
        cameraToggle:SetBackgroundColor(Color(70,196,91))
        cameraToggle.DoClick = function()
            EnabledCam = !EnabledCam
            EnabledCamConfirm = !EnabledCamConfirm
        
            gm3ZeusCam:CreateCameraHooks(EnabledCam)
        end

        local removeSelected = vgui.Create("lyx.TextButton2", gm3CamPanelBottom)
        removeSelected:Dock(RIGHT)
        removeSelected:DockMargin(lyx.Scale(5), lyx.Scale(5), lyx.Scale(5), lyx.Scale(5))
        removeSelected:SetText("Remove Selected")
        removeSelected:SetWide(lyx.Scale(150))
        removeSelected:SetBackgroundColor(Color(255,0,0))
        removeSelected.DoClick = function()
            net.Start("gm3ZeusCam_removeSelected")
                net.WriteTable(gm3_entitiesToHighlight)
            net.SendToServer()
        end

        -- move to camera
        local moveToCamera = vgui.Create("lyx.TextButton2", gm3CamPanelBottom)
        moveToCamera:Dock(RIGHT)
        moveToCamera:DockMargin(lyx.Scale(5), lyx.Scale(5), lyx.Scale(5), lyx.Scale(5))
        moveToCamera:SetText("Move to Camera")
        moveToCamera:SetWide(lyx.Scale(150))
        -- purple
        moveToCamera:SetBackgroundColor(Color(139,36,139))
        moveToCamera.DoClick = function()
            net.Start("gm3ZeusCam_moveToCamera")
                -- ensure npcs or nextbos
                local entities = {}
                for k,v in pairs(gm3_entitiesToHighlight) do
                    if k:IsNPC() or k:IsNextBot() then
                        table.insert(entities, 0, k)
                    end
                end
            net.SendToServer()
        end

        -- move to click
        local moveToClick = vgui.Create("lyx.TextButton2", gm3CamPanelBottom)
        moveToClick:Dock(RIGHT)
        moveToClick:DockMargin(lyx.Scale(5), lyx.Scale(5), lyx.Scale(5), lyx.Scale(5))
        moveToClick:SetText("Move to Click (OFF)")
        moveToClick:SetWide(lyx.Scale(150))
        -- purple
        moveToClick:SetBackgroundColor(Color(139,36,139))
        moveToClick.DoClick = function()
            net.Start("gm3ZeusCam_moveToClick")
                -- ensure npcs or nextbos
                local entities = {}
                for k,v in pairs(gm3_entitiesToHighlight) do
                    if k:IsNPC() or k:IsNextBot() then
                        table.insert(entities, 0, k)
                    end
                end
            net.SendToServer()
        end

    else
        gm3CamPanel:Remove()
    end
end

function gm3ZeusCam:CreateCameraHooks(bool)
    if bool then
        hook.Add("CalcView", "GM3_Cam_View", function(ply, pos, angles, fov)
            local view = {}
            if (CamEnabled) then
                view = {
                    origin = CamPos,
                    angles = CamAngle,
                    fov = CamFOV,
                    drawviewer = true
                }
                return view
            else
                view = {
                    origin = pos,
                    angles = angles,
                    fov = fov,
                    drawviewer = false
                }
            end
        end)

        hook.Add("Tick", "CamUpdateTick", function(ply)
            if (EnabledCamConfirm) then
                CamEnabled = true
            else
                CamEnabled = false
                CamAngle = LocalPlayer():EyeAngles()
                CamOriginalAngle = LocalPlayer():EyeAngles()
                CamPos = LocalPlayer():EyePos()
            end
        
            CamOriginalAngle = LocalPlayer():EyeAngles() -- i spent a good 3 hours figuring out the Lock camera view thing but this is the only thing making it work
            
            -- send ConVar info to regular vars as to update
            CamFOV = CVCamFOV:GetFloat()
            CamSpeed = CVCamSpeed:GetFloat()
            CamSensitivity = CVCamSens:GetFloat()
            CamLock = CVCamLock:GetBool()
            
        end)

        hook.Add("CreateMove", "GM3_Cam_Move", function(cmd, ply)
            if (EnabledCam) then
                local SideMove = cmd:GetSideMove()
                local ForwardMove = cmd:GetForwardMove()
                local UpMove = cmd:GetUpMove()
                if (!CamLock) then
                    local CamSpeedActual = CamSpeed
                    cmd:SetSideMove(0)
                    cmd:SetForwardMove(0)
                    cmd:SetUpMove(0)
                    cmd:ClearMovement()
                    
                    cmd:SetViewAngles(CamOriginalAngle)
                    
                    CamAngle = (CamAngle + Angle(cmd:GetMouseY() * CamSensitivity, cmd:GetMouseX() * -CamSensitivity, 0))
        
                    -- SPEED
                    if (cmd:KeyDown(IN_SPEED)) then
                        CamSpeedActual = CamSpeed * 2
                    end
                    if (cmd:KeyDown(IN_WALK)) then
                        CamSpeedActual = CamSpeed / 2
                    end
                    
                    -- UP AND DOWN
                    if (cmd:KeyDown(IN_JUMP)) then
                        CamPos = CamPos + Vector(0,0,CamSpeedActual)
                    end
                    if (cmd:KeyDown(IN_DUCK)) then
                        CamPos = CamPos - Vector(0,0,CamSpeedActual)
                    end
                        
                    -- BASIC INPUT CONTROLS
                    if (cmd:KeyDown(IN_FORWARD)) then
                        CamPos = CamPos + (CamAngle:Forward() * CamSpeedActual)
                    end
                    if (cmd:KeyDown(IN_BACK)) then
                        CamPos = CamPos - (CamAngle:Forward() * CamSpeedActual)
                    end
                    if (cmd:KeyDown(IN_MOVERIGHT)) then
                        CamPos = CamPos + (CamAngle:Right() * CamSpeedActual)
                    end
                    if (cmd:KeyDown(IN_MOVELEFT)) then
                        CamPos = CamPos - (CamAngle:Right() * CamSpeedActual)
                    end
                    
                    -- ensure that the player itself cant walk, use, jump, duck or fire while in static freecam
                    cmd:RemoveKey(IN_FORWARD)
                    cmd:RemoveKey(IN_BACK)
                    cmd:RemoveKey(IN_MOVELEFT)
                    cmd:RemoveKey(IN_MOVERIGHT)
                    
                    cmd:RemoveKey(IN_USE)
                    cmd:RemoveKey(IN_JUMP)
                    cmd:RemoveKey(IN_DUCK)
                    cmd:RemoveKey(IN_ATTACK)
                    cmd:RemoveKey(IN_ATTACK2)
                    -- disable scrolling
                    cmd:RemoveKey(IN_RELOAD)
                    -- disbale middle mouse button
                    cmd:RemoveKey(IN_WALK)
                    cmd:RemoveKey(IN_WEAPON1)
                    cmd:RemoveKey(IN_WEAPON2)
                    cmd:RemoveKey(IN_BULLRUSH)
                    -- in zoom
                    cmd:RemoveKey(IN_ZOOM)
                    -- in alt
                    cmd:RemoveKey(IN_ALT1)
                    cmd:RemoveKey(IN_ALT2)

                else
                    cmd:SetSideMove(SideMove)
                    cmd:SetForwardMove(ForwardMove)
                    cmd:SetUpMove(UpMove)
                end
            end
        end)

        hook.Add("Think", "GM3_Cam_Mouse", function()
            if (EnabledCam) then
                if (input.IsMouseDown(MOUSE_LEFT) && LastClick < CurTime()) then
                    -- highlight entity on click
                    local tr = util.TraceLine( {
                        start = CamPos,
                        endpos = CamPos + CamAngle:Forward() * 1000,
                    } )
                    if IsValid( tr.Entity ) and !(gm3_entitiesToHighlight[tr.Entity]) then
                        gm3_entitiesToHighlight[tr.Entity] = true 
                        gm3_entitiesCount = gm3_entitiesCount + 1
                    end
                    LastClick = CurTime() + delay
                end
                if (input.IsMouseDown(MOUSE_RIGHT) && LastClick < CurTime()) then
                    local tr = util.TraceLine( {
                        start = CamPos,
                        endpos = CamPos + CamAngle:Forward() * 1000,
                    } )
                    if IsValid( tr.Entity ) and gm3_entitiesToHighlight[tr.Entity] then
                        gm3_entitiesToHighlight[tr.Entity] = nil
                        gm3_entitiesCount = gm3_entitiesCount - 1    
                    end
        
        
                    LastClick = CurTime() + delay
                end
        
            end
        end)

        hook.Add("PostDrawTranslucentRenderables", "GM3_Drawing", function()
            -- draw a line from the camera's forward pos and angle to the end of the trace
            local startPos = CamPos + CamAngle:Forward() + CamAngle:Up() * 10
            local endPos = CamPos + CamAngle:Forward() * 10000
            render.DrawLine(startPos, endPos, Color(255, 255, 255), true)

            for k,v in pairs(gm3_entitiesToHighlight) do
                if !IsValid(k) then
                    gm3_entitiesToHighlight[k] = nil
                    gm3_entitiesCount = gm3_entitiesCount - 1
                end
                render.SetMaterial(wireframeMat)
                if !IsValid(k) then return end
                render.DrawBox(k:GetPos(), k:GetAngles(), k:OBBMins(), k:OBBMaxs(), Color(255, 0, 0, 255), true)
            end
        end)

        -- 2d drawing
        hook.Add("HUDPaint", "GM3_Cam_HUD", function()
            if (EnabledCam) then         
                -- draw a top bar
                surface.SetDrawColor( 37, 36, 36)
                surface.DrawRect( 0, 0, ScrW(), lyx.Scale(40) )

                -- draw title
                draw.SimpleText("Gamemaster 3: Zeus Mode", "GM3_Cam_Title", lyx.ScaleW(10), lyx.Scale(5), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            
                -- draw a little box on the left side to put some text
                surface.SetDrawColor( 37,36,36)
                surface.DrawRect( lyx.ScaleW(5), lyx.Scale(50), lyx.ScaleW(200), lyx.Scale(200) )

                -- draw the amount of entities in the table
                draw.SimpleText("Entities: " .. gm3_entitiesCount, "GM3_Cam_Subtitle", lyx.ScaleW(10), lyx.Scale(50), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            end
        end)

        -- enable mouse on screen
        --gui.EnableScreenClicker(true)

        gm3ZeusCam:CreateCamPanel(true)
    else
        hook.Remove("CalcView", "GM3_Cam_View")
        hook.Remove("Tick", "CamUpdateTick")
        hook.Remove("CreateMove", "GM3_Cam_Move")
        hook.Remove("Think", "GM3_Cam_Mouse")
        hook.Remove("PostDrawTranslucentRenderables", "GM3_Drawing")
        hook.Remove("HUDPaint", "GM3_Cam_HUD")
        gm3ZeusCam:CreateCamPanel(false)
       -- gui.EnableScreenClicker(false)
    end
end

concommand.Add( "gm3Cam_toggle", function(ply, cmd, args)
    EnabledCam = !EnabledCam
    EnabledCamConfirm = !EnabledCamConfirm

    gm3ZeusCam:CreateCameraHooks(EnabledCam)
end)