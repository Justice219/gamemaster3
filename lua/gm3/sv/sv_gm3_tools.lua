gm3 = gm3
gm3.tools = gm3.tools or {}
lyx = lyx


--[[
* GM3 MODULE CLASS
+ Used for creating modules in an OOP style, to allow for more modularity
+ as well as flexibility in the future.
--]]
do
    GM3Module = {}
    GM3Module.__index = GM3Module

    function GM3Module.new(name, description, author, args, func)
        local self = setmetatable({}, GM3Module)
        self.name = name
        self.description = description
        self.func = func
        self.args = args
        self.author = author

        return self
    end

    function GM3Module:run(ply, args)
        self.func(ply, args)
    end
end

--[[ 
* Logic Code For Handling GM3 Modules
+ This is where the magic happens
--]]
do
    function gm3:addTool(tool)
        if gm3.tools[tool.name] then
            gm3.Logger:Log("Tool with name " .. tool.name .. " already exists!")
        end
    
        gm3.tools[tool.name] = tool
        gm3.Logger:Log("Added tool with name " .. tool.name .. " to the tool list!")
    end
    
    --? method for getting a tool table
    function gm3:getTool(name)
        if gm3.tools[name] then
            return gm3.tools[name]
        else
            gm3.Logger:Log("Tool with name " .. name .. " does not exist!")
        end
    end
    
    --+ method for getting a tool's name
    function gm3:getToolName(name)
        if gm3.tools[name] then
            return gm3.tools[name].name
        else
            gm3.Logger:Log("Tool with name " .. name .. " does not exist!")
        end
    end
    
    --+ method for getting the tool author
    function gm3:getToolDescription(name)
        if gm3.tools[name] then
            return gm3.tools[name].description
        else
            gm3.Logger:Log("Tool with name " .. name .. " does not exist!")
        end
    end
    
    --! method for running a tool
    --* all values should be checked prior to running the tool
    --+ even if this has error handling, it's better to be safe than sorry
    function gm3:runTool(name, ply, args)
        if gm3.tools[name] then
            gm3.tools[name]:run(ply, args)
        else
            gm3.Logger:Log("Tool with name " .. name .. " does not exist!")
        end
        gm3.Logger:Log("Ran tool with name " .. name .. "!" .. "ply: " .. ply:SteamID())
    end
    
    --! PLEASE CHECK
    -- gm3/tools/gm3_tool_example.lua 
    --! for an example of how to use this module
end