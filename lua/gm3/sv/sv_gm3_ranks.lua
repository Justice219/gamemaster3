gm3 = gm3
lyx = lyx

gm3.ranks = gm3.ranks or {}

-- TODO: Use meta tables to make this more efficient
-- TODO: Maybe Add permissions to ranks? Not sure if this is needed

--+ This implementation is terrible, but it works for now

do
    function gm3:RankAdd(name)
        if gm3.ranks[name] then
            gm3.Logger:Log("Couldnt add Rank, it already exists: " .. name)    
        return end
        
        gm3.ranks[name] = true
        lyx:JSONSave("gm3_ranks.txt", gm3.ranks)
        gm3.Logger:Log("Added Rank: " .. name)
    end
    
    function gm3:RankRemove(name)
        if not gm3.ranks[name] then
            gm3.Logger:Log("Couldnt remove Rank, it doesnt exist: " .. name)    
        return end
        
        gm3.ranks[name] = nil
        lyx:JSONSave("gm3_ranks.txt", gm3.ranks)
        gm3.Logger:Log("Removed Rank: " .. name)
    end
    
    function gm3:RankLoadTable()
        -- return the json version of the ranks
        return lyx:JSONLoad("gm3_ranks.txt")
    end
    
    --! This will not work unless you wait a second for the server to catch up?
    --! Not sure why but it genuinley doesnt work without atleast a 0.1 second delay
    --+ Please message me if you know why this is happening
    
    timer.Simple(1, function()
        local ranks = gm3:RankLoadTable()
        if ranks then
            gm3.ranks = ranks
            gm3.Logger:Log("Loading ranks...")
            for k, v in pairs(gm3.ranks) do
                gm3.Logger:Log("Loaded Rank: " .. k)
            end
        else 
            gm3.Logger:Log("No ranks found, creating default ranks")
            gm3:RankAdd("superadmin")
            gm3:RankAdd("admin")
            gm3:RankAdd("moderator")
            gm3:RankAdd("user")
        end
    end) 
end