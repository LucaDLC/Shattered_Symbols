local game = Game()
local SacredLanternLocalID = Isaac.GetItemIdByName("Sacred Lantern")

--EID
if EID then
    EID:addCollectible(SacredLanternLocalID, "{{ArrowUp}} Remove all your broken hearts {{BrokenHeart}} #For every broken heart {{BrokenHeart}} removed you obtain:#{{HalfSoulHeart}} Half Soul Heart")
end

-- Function to handle item pickup
function BrokenOrigami:useSacredLantern(player)
    local data = player:GetData()
    
    -- Initialize the SacredLanternCounter if it doesn't exist
    if not data.SacredLanternCounter then
        data.SacredLanternCounter = 0
        data.SacredLanternRelative = 0
        data.SacredLanternPreviousCounter = 1
    end

    -- Check if the player has picked up the item
    if player:HasCollectible(SacredLanternLocalID) then
        -- Increase the counter
        data.SacredLanternCounter = player:GetCollectibleNum(SacredLanternLocalID)
        
        -- Apply the effect based on the number of items picked up
        if data.SacredLanternCounter >= data.SacredLanternPreviousCounter then
            data.SacredLanternPreviousCounter = data.SacredLanternPreviousCounter + 1
            data.SacredLanternRelative = data.SacredLanternRelative + 1
            local brokenHearts = player:GetBrokenHearts() -- Get number of broken hearts
            if brokenHearts > 0 then
                -- For each broken heart, add a half soul heart and remove one broken heart
                for i = 1, brokenHearts do
                    player:AddSoulHearts(1) -- Adds half a soul heart
                    player:AddBrokenHearts(-1) -- Removes one broken heart
                end
            end
        end
    else
        data.SacredLanternCounter = 0
        data.SacredLanternPreviousCounter = 1
    end
    if data.SacredLanternRelative > data.SacredLanternCounter then
        data.SacredLanternPreviousCounter = data.SacredLanternCounter +1
    end
    
end


BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useSacredLantern)