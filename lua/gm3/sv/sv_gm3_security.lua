gm3 = gm3
gm3.ranks = gm3.ranks or {}

lyx = lyx

-- ! Check if the player has a valid rank
-- * Used internally for making sure a player can use the system
-- * if the rank is in the gm3.ranks table, then it is valid
do
    function gm3:SecurityCheck(ply)
        local ranks = gm3:RankLoadTable()
    
        if ranks[ply:GetUserGroup()] then
            return true
        else
            return false
        end
    end
end