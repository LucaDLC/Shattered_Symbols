local fiendishSeed = BrokenOrigami
local game = Game()
local itemID = Isaac.GetItemIdByName("Fiendish Seed")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(itemID, "{{ArrowUp}} Grants +5 Luck {{Luck}}#{{ArrowDown}} Gives 2 Broken Hearts {{BrokenHeart}}#{{ColorGreen}}It's cumulative with other Fiendish Seed{{CR}}")
end

-- Function to handle item pickup
function fiendishSeed:onItemPickup(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the fiendishSeedCounter if it doesn't exist
    if not data.fiendishSeedCounter then
        data.fiendishSeedCounter = 0
        data.fiendishSeedRelative = 0
        data.fiendishSeedPreviousCounter = 1
    end
    
    if player:HasCollectible(itemID) then
        -- Increase the counter
        data.fiendishSeedCounter = player:GetCollectibleNum(itemID)
        
        -- Apply the effect based on the number of items picked up
        if data.fiendishSeedCounter >= data.fiendishSeedPreviousCounter then
            data.fiendishSeedPreviousCounter = data.fiendishSeedPreviousCounter + 1
            data.fiendishSeedRelative = data.fiendishSeedRelative + 1
            player:AddBrokenHearts(2) -- Add 1 broken heart
            data.fiendishSeedLuckBoost = 5*data.fiendishSeedRelative -- Track the permanent damage boost
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()
        end
    else
        data.fiendishSeedCounter = 0
        data.fiendishSeedPreviousCounter = 1
    end
    if data.fiendishSeedRelative > data.fiendishSeedCounter then
        data.fiendishSeedPreviousCounter = data.fiendishSeedCounter +1
    end
end

-- Function to handle cache update
function fiendishSeed:onEvaluateCache(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_LUCK then
        if data.fiendishSeedLuckBoost then
            player.Luck = player.Luck + data.fiendishSeedLuckBoost
        end
    end
end

fiendishSeed:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, fiendishSeed.onItemPickup)
fiendishSeed:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, fiendishSeed.onEvaluateCache)
