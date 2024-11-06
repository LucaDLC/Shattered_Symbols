local game = Game()
local SacredLanternLocalID = Isaac.GetItemIdByName("Sacred Lantern")

--EID
if EID then
    EID:addCollectible(SacredLanternLocalID, "{{ArrowUp}} Remove all your broken hearts {{BrokenHeart}} #For every broken heart {{BrokenHeart}} removed you obtain:#{{HalfSoulHeart}} Half Soul Heart")
end

-- Function to handle item pickup
function BrokenOrigami:useSacredLantern(_, rng, player)

    if player:HasCollectible(SacredLanternLocalID) then
        local brokenHearts = player:GetBrokenHearts() -- Get number of broken hearts
        if brokenHearts > 0 then
            -- For each broken heart, add a half soul heart and remove one broken heart
            for i = 1, brokenHearts do
                player:AddSoulHearts(1) -- Adds half a soul heart
                player:AddBrokenHearts(-1) -- Removes one broken heart
            end
        end
        
    end

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
    
end


BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useSacredLantern, SacredLanternLocalID)