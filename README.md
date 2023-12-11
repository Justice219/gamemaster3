
# Gamemaster 3

Advanced gamemaster system developed for [Garry's Mod](https://gmod.facepunch.com)



## API Reference

#### Get all items

```lua
GM3Module.new(name, description, author, args, func)
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `name` | `string` | **Required** - name of module to add.|
| `description` | `string` | **Required** - description of module to add.|
| `author` | `string` | **Required** - author of module to add.|
| `args` | `table` | **Required**. - table of arguments for the module.|
| `func` | `function` | **Required**. callback with arguments on module run. |

Creates a new ``GM3Module`` and returns the meta table. Usually you now add the tool to the ``gamemaster3`` list for it to be included in the in game menu. 

```lua
gm3:addTool(tool)
```
| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `tool` | `GM3Module` | **Required** - the module metatable.|

Populates a ``GM3Module`` into the ``gamemaster3`` system!

**Example of a GM3Module**
```lua
gm3 = gm3

if SERVER then
    --! IT IS VERY IMPORTANT YOU INCLUDE BOTH OF THESE REFERENCES !-
    --+ THEY ALLOW YOU TO USE GM3 AND MY LYX LIBRARY
    gm3 = gm3
    lyx = lyx

    --+ CREATE A NEW GM3MODULE
    local tool = GM3Module.new(
        "Example", --? name
        "This is an example tool", --? description
        "GM3", --? author
        { --? arguments
            ["age"] = {
                type = "number",
                def = 0
            },
            ["name"] = {
                type = "string",
                def = "GM3"
            }
        },
        function(ply, args) --? func
            lyx:MessageServer({
                ["type"] = "header",
                ["color1"] = Color(0,255,213),
                ["header"] = "GM3",
                ["color2"] = Color(255,255,255),
                ["text"] = "This is an example tool! Age: " .. args["age"] .. " Name: " .. args["name"]
            })
        end)

    --+ Add the tool to the GM3 tool list
    --! THIS IS VERY IMPORTANT !--
    gm3:addTool(tool)
end

if CLIENT then
    // if your tool has any client side code, put it here
    // an example would be a menu or drawing, yada yada

    gm3.Logger:Log("Example tool loaded!")

end
```
This is a very basic implementation of the ``GM3Module`` power. It has the ability to read both server and client code, and network within one file. Super convienent. 
## Contributing

Contributions are always welcome! Whether its new modules or code help.

Everything else not mentioned in the above API Refference are internal functions, currently the only developer intention is to be able to create your own modules and load them from different addons, so I dont see a point in documenting every little thing in ``gamemaster3``