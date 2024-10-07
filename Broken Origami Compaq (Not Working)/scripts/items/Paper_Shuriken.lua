local paperShuriken = BrokenOrigami
local itemID = Isaac.GetItemIdByName("Paper Shuriken")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(itemID, "{{ArrowUp}} Grants +3 Damage {{Damage}}#{{ArrowDown}} Gives 1 Broken Hearts {{BrokenHeart}}##{{ColorGreen}}It's cumulative with other Paper Shuriken{{CR}}")
end

-- Function to handle item pickup
function paperShuriken:onItemPickup(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the paperShurikenCounter if it doesn't exist
    if not data.paperShurikenCounter then
        data.paperShurikenCounter = 0
        data.paperShurikenRelative = 0
        data.paperShurikenPreviousCounter = 1
    end

    -- Check if the player has picked up the item
    if player:HasCollectible(itemID) then
        -- Increase the counter
        data.paperShurikenCounter = player:GetCollectibleNum(itemID)
        
        -- Apply the effect based on the number of items picked up
        if data.paperShurikenCounter >= data.paperShurikenPreviousCounter then
            data.paperShurikenPreviousCounter = data.paperShurikenPreviousCounter + 1
            data.paperShurikenRelative = data.paperShurikenRelative + 1
            player:AddBrokenHearts(1) -- Add 1 broken heart
            data.paperShurikenDamageBoost = 3*data.paperShurikenRelative -- Track the permanent damage boost
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    else
        data.paperShurikenCounter = 0
        data.paperShurikenPreviousCounter = 1
    end
    if data.paperShurikenRelative > data.paperShurikenCounter then
        data.paperShurikenPreviousCounter = data.paperShurikenCounter +1
    end
end

-- Function to handle cache update
function paperShuriken:onEvaluateCache(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if data.paperShurikenDamageBoost then
            player.Damage = player.Damage + data.paperShurikenDamageBoost
        end
    end
end

paperShuriken:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, paperShuriken.onItemPickup)
paperShuriken:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, paperShuriken.onEvaluateCache)
