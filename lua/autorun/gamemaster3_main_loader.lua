gm3 = {}

function gm3:Log(str)
    MsgC(Color(0, 247, 255), "[GM3] ", Color(255, 255, 255), str, "\n")
end

function gm3:TextPrint(str)
    local f = file.Read(str, "LUA")
    if f then
        local t = string.Explode("\n", f)
        for k, v in ipairs(t) do
            MsgC(Color(0, 247, 255), "[GM3] ", Color(255, 255, 255), v, "\n")
        end
    end
end

local function loadServerFile(str)
    if CLIENT then return end
    include(str)
    gm3:Log("Loaded server file: " .. str)
end

local function loadClientFile(str)
    if SERVER then AddCSLuaFile(str) return end
    include(str)
    gm3:Log("Loaded client file: " .. str)
end

local function loadSharedFile(str)
    if SERVER then AddCSLuaFile(str) end
    include(str)
    gm3:Log("Loaded shared file: " .. str)
end

local function makeClientUsable(str)
    if CLIENT then return end
    AddCSLuaFile(str)
    gm3:Log("Made client usable: " .. str)
end


local function load()
    gm3:TextPrint("gm3/extra/logo.txt")

    local clientFiles = file.Find("gm3/cl/*.lua", "LUA")
    local sharedFiles = file.Find("gm3/sh/*.lua", "LUA")
    local serverFiles = file.Find("gm3/sv/*.lua", "LUA")
    local vguiFiles = file.Find("gm3/vgui/*.lua", "LUA")
    local thirdPartyFiles = file.Find("gm3/thirdparty/*.lua", "LUA")
    local tools = file.Find("gm3/tools/*.lua", "LUA")

    --? can be first because it doesnt rely on anything 😓
    for _, fl in pairs(clientFiles) do
        loadClientFile("gm3/cl/" .. fl)
    end

    for _, fl in pairs(sharedFiles) do
        loadSharedFile("gm3/sh/" .. fl)
    end

    for _, fl in pairs(serverFiles) do
        loadServerFile("gm3/sv/" .. fl)
    end

    for _, fl in pairs(vguiFiles) do
        loadClientFile("gm3/vgui/" .. fl)
    end

    for _, fl in pairs(thirdPartyFiles) do
        makeClientUsable("gm3/thirdparty/" .. fl)
    end

    --! this needs to be ran last ⚠️
    timer.Simple(5, function()
        gm3:Log("Loading tools...")
        for _, fl in pairs(tools) do
            loadSharedFile("gm3/tools/" .. fl)
        end
    end)

    gm3:Log("Loaded " .. #clientFiles + #sharedFiles + #serverFiles + #vguiFiles + #thirdPartyFiles + #tools  .. " files.")
end

-- For all the cute niggas
-- wait for lyx to load
timer.Simple(5, load)