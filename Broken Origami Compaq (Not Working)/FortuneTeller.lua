local game = Game()
local itemID = Isaac.GetItemIdByName("Fortune Teller")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(itemID, "{{ArrowUp}} Grants +5 Luck {{Luck}}#{{ArrowDown}} Gives 2 Broken Hearts {{BrokenHeart}}#{{ColorGreen}}It's cumulative with other Fiendish Seed{{CR}}")
end

-- Function to handle item pickup
function BrokenOrigami:onItemPickup(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the BrokenOrigamiCounter if it doesn't exist
    if not data.BrokenOrigamiCounter then
        data.BrokenOrigamiCounter = 0
        data.BrokenOrigamiRelative = 0
        data.BrokenOrigamiPreviousCounter = 1
    end
    
    if player:HasCollectible(itemID) then
        -- Increase the counter
        data.BrokenOrigamiCounter = player:GetCollectibleNum(itemID)
        
        -- Apply the effect based on the number of items picked up
        if data.BrokenOrigamiCounter >= data.BrokenOrigamiPreviousCounter then
            data.BrokenOrigamiPreviousCounter = data.BrokenOrigamiPreviousCounter + 1
            data.BrokenOrigamiRelative = data.BrokenOrigamiRelative + 1
            player:AddBrokenHearts(2) -- Add 1 broken heart
            data.BrokenOrigamiLuckBoost = 5*data.BrokenOrigamiRelative -- Track the permanent damage boost
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()
        end
    else
        data.BrokenOrigamiCounter = 0
        data.BrokenOrigamiPreviousCounter = 1
    end
    if data.BrokenOrigamiRelative > data.BrokenOrigamiCounter then
        data.BrokenOrigamiPreviousCounter = data.BrokenOrigamiCounter +1
    end
end

-- Function to handle cache update
function BrokenOrigami:onEvaluateCache(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_LUCK then
        if data.BrokenOrigamiLuckBoost then
            player.Luck = player.Luck + data.BrokenOrigamiLuckBoost
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.onItemPickup)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCache)
