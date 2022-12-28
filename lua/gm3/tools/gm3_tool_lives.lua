gm3 = gm3

if SERVER then
    gm3 = gm3
    gm3.livesData = false

    gm3.livesHook = nil 
    gm3.livesHook2 = nil

    lyx = lyx
    
    local tool = GM3Module.new(
        "Lives",
        "Sets customizable lives on the server, before being unable to respawn.", 
        "Justice#4956",
        {
            ["Lives"] = {
                type = "number",
                def = 3
            },
        },
        function(ply, args)
            local function findAlivePlayer()
                local targ
                for k,v in pairs(player.GetAll()) do -- micro optimisations 
                    if v && v:IsValid() && v:Alive() then
                        targ = v
                        break -- found someone kill loop fast.
                    end
                end
                return targ
            end

            if gm3.livesData then
                lyx:HookRemove("PlayerDeath", gm3.livesHook)
                lyx:HookRemove("PlayerDeathThink", gm3.livesHook2)
                gm3.livesData = false

                for k,v in pairs(player.GetAll()) do
                    v:UnSpectate()
                    lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Lives",["color2"] = Color(255,255,255),["text"] = "You may now respawn.",
                        ["ply"] = v
                    })
                    v:Respawn()
                end

                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Lives",["color2"] = Color(255,255,255),["text"] = "Server lives have been disabled.",
                    ["ply"] = ply
                })
            else
                for k,v in pairs(player.GetAll()) do
                    v:SetNWInt("gm3_lives", args["Lives"])
                    lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Lives",["color2"] = Color(255,255,255),["text"] = "Server lives have been enabled." ..
                        " You have " .. v:GetNWInt("gm3_lives") .. " lives!",
                        ["ply"] = v
                    })
                end
                gm3.livesHook = lyx:HookStart("PlayerDeath", function(...)
                    local args = {...}
                    local p = args[1]

                    p:SetNWInt("gm3_lives", p:GetNWInt("gm3_lives") - 1)
                    if p:GetNWInt("gm3_lives") <= 0 then
                        lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Lives",["color2"] = Color(255,255,255),["text"] = "You have died and are spectating.",
                            ["ply"] = p
                        })

                        p:Spectate(OBS_MODE_CHASE)
                        p:SpectateEntity(findAlivePlayer())
                    else
                        lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Lives",["color2"] = Color(255,255,255),["text"] = "You have died and have " .. p:GetNWInt("gm3_lives") .. " lives left.",
                            ["ply"] = p
                        })
                    end
                end)
                gm3.livesHook2 = lyx:HookStart("PlayerDeathThink", function(...)
                    local args = {...}
                    local p = args[1]
                    if p:GetNWInt("gm3_lives") == 0 then
                        return false
                    end     
                end)
                gm3.livesData = true
                lyx:MessagePlayer({["type"] = "header",["color1"] = Color(0,255,213),["header"] = "Lives",["color2"] = Color(255,255,255),["text"] = "Lives are now enabled!",
                    ["ply"] = ply
                })

            end

        end)
    gm3:addTool(tool)
end

if CLIENT then
    gm3 = gm3
    lyx = lyx


end