local sacredLantern = RegisterMod("Sacred Lantern", 1)
local game = Game()
local itemID = Isaac.GetItemIdByName("Sacred Lantern")

--EID
if EID then
    EID:addCollectible(itemID, "Remove all your broken hearts {{BrokenHeart}} for the rest of the game#For every broken heart {{BrokenHeart}} removed or gain during the rest of the game you obtain:#{{HalfSoulHeart}} Half Soul Heart#{{ColorRed}}It's not cumulative with other Sacred Lanterns{{CR}}")
end

-- Function to handle item pickup
function sacredLantern:onItemPickup(player)
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(itemID) then
        local brokenHearts = player:GetBrokenHearts() -- Get number of broken hearts
        if brokenHearts > 0 then
            player:AddSoulHearts(brokenHearts) -- Add soul hearts (1 broken heart = half soul hearts)
            player:AddBrokenHearts(-brokenHearts) -- Remove all broken hearts
        end
    end
end


sacredLantern:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, sacredLantern.onItemPickup)