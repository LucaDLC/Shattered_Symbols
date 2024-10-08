local game = Game()
local FortuneTellerLocalID = Isaac.GetItemIdByName("Fortune Teller")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(FortuneTellerLocalID, "{{ArrowUp}} Grants +5 Luck {{Luck}}#{{ArrowDown}} Gives 2 Broken Hearts {{BrokenHeart}}#{{ColorGreen}}It's cumulative with other Fiendish Seed{{CR}}")
end

-- Function to handle item pickup
function BrokenOrigami:onItemPickup(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the FortuneTellerCounter if it doesn't exist
    if not data.FortuneTellerCounter then
        data.FortuneTellerCounter = 0
        data.FortuneTellerRelative = 0
        data.FortuneTellerPreviousCounter = 1
    end
    
    if player:HasCollectible(FortuneTellerLocalID) then
        -- Increase the counter
        data.FortuneTellerCounter = player:GetCollectibleNum(FortuneTellerLocalID)
        
        -- Apply the effect based on the number of items picked up
        if data.FortuneTellerCounter >= data.FortuneTellerPreviousCounter then
            data.FortuneTellerPreviousCounter = data.FortuneTellerPreviousCounter + 1
            data.FortuneTellerRelative = data.FortuneTellerRelative + 1
            player:AddBrokenHearts(2) -- Add 1 broken heart
            data.FortuneTellerLuckBoost = 5*data.FortuneTellerRelative -- Track the permanent damage boost
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()
        end
    else
        data.FortuneTellerCounter = 0
        data.FortuneTellerPreviousCounter = 1
    end
    if data.FortuneTellerRelative > data.FortuneTellerCounter then
        data.FortuneTellerPreviousCounter = data.FortuneTellerCounter +1
    end
end

-- Function to handle cache update
function BrokenOrigami:onEvaluateCache(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_LUCK then
        if data.FortuneTellerLuckBoost then
            player.Luck = player.Luck + data.FortuneTellerLuckBoost
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.onItemPickup)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCache)
