local origamiShuriken = RegisterMod("Origami Shuriken", 1)
local itemID = Isaac.GetItemIdByName("Origami Shuriken")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(itemID, "{{ArrowUp}} Grants +3 Damage {{Damage}}#{{ArrowDown}} Gives 1 Broken Hearts {{BrokenHeart}}")
end

-- Function to handle item pickup
function origamiShuriken:onItemPickup(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the origamiShurikenCounter if it doesn't exist
    if not data.origamiShurikenCounter then
        data.origamiShurikenCounter = 0
        data.origamiShurikenRelative = 0
        data.origamiShurikenPreviousCounter = 1
    end

    -- Check if the player has picked up the item
    if player:HasCollectible(itemID) then
        -- Increase the counter
        data.origamiShurikenCounter = player:GetCollectibleNum(itemID)
        
        -- Apply the effect based on the number of items picked up
        if data.origamiShurikenCounter >= data.origamiShurikenPreviousCounter then
            data.origamiShurikenPreviousCounter = data.origamiShurikenPreviousCounter + 1
            data.origamiShurikenRelative = data.origamiShurikenRelative + 1
            player:AddBrokenHearts(1) -- Add 1 broken heart
            data.origamiShurikenDamageBoost = 3*data.origamiShurikenRelative -- Track the permanent damage boost
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    else
        data.origamiShurikenCounter = 0
        data.origamiShurikenPreviousCounter = 1
    end
    if data.origamiShurikenRelative > data.origamiShurikenCounter then
        data.origamiShurikenPreviousCounter = data.origamiShurikenCounter +1
    end
end

-- Function to handle cache update
function origamiShuriken:onEvaluateCache(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if data.origamiShurikenDamageBoost then
            player.Damage = player.Damage + data.origamiShurikenDamageBoost
        end
    end
end

origamiShuriken:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, origamiShuriken.onItemPickup)
origamiShuriken:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, origamiShuriken.onEvaluateCache)
