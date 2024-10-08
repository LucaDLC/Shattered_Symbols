local itemID = Isaac.GetItemIdByName("Origami Shuriken")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(itemID, "{{ArrowUp}} Grants +3 Damage {{Damage}}#{{ArrowDown}} Gives 1 Broken Hearts {{BrokenHeart}}##{{ColorGreen}}It's cumulative with other Paper Shuriken{{CR}}")
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

    -- Check if the player has picked up the item
    if player:HasCollectible(itemID) then
        -- Increase the counter
        data.BrokenOrigamiCounter = player:GetCollectibleNum(itemID)
        
        -- Apply the effect based on the number of items picked up
        if data.BrokenOrigamiCounter >= data.BrokenOrigamiPreviousCounter then
            data.BrokenOrigamiPreviousCounter = data.BrokenOrigamiPreviousCounter + 1
            data.BrokenOrigamiRelative = data.BrokenOrigamiRelative + 1
            player:AddBrokenHearts(1) -- Add 1 broken heart
            data.BrokenOrigamiDamageBoost = 3*data.BrokenOrigamiRelative -- Track the permanent damage boost
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if data.BrokenOrigamiDamageBoost then
            player.Damage = player.Damage + data.BrokenOrigamiDamageBoost
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.onItemPickup)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCache)
