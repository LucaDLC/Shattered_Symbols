local game = Game()
local OrigamiShurikenLocalID = Isaac.GetItemIdByName("Origami Shuriken")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(OrigamiShurikenLocalID, "{{ArrowUp}} Grants +3 Damage {{Damage}}#{{ArrowDown}} Gives 1 Broken Hearts {{BrokenHeart}}")
end

-- Function to handle item pickup
function BrokenOrigami:useOrigamiShuriken(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the OrigamiShurikenCounter if it doesn't exist
    if not data.OrigamiShurikenCounter then
        data.OrigamiShurikenCounter = 0
        data.OrigamiShurikenRelative = 0
        data.OrigamiShurikenPreviousCounter = 1
    end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiShurikenLocalID) then
        -- Increase the counter
        data.OrigamiShurikenCounter = player:GetCollectibleNum(OrigamiShurikenLocalID)
        
        -- Apply the effect based on the number of items picked up
        if data.OrigamiShurikenCounter >= data.OrigamiShurikenPreviousCounter then
            data.OrigamiShurikenPreviousCounter = data.OrigamiShurikenPreviousCounter + 1
            data.OrigamiShurikenRelative = data.OrigamiShurikenRelative + 1
            player:AddBrokenHearts(1) -- Add 1 broken heart
            data.OrigamiShurikenDamageBoost = 3*data.OrigamiShurikenRelative -- Track the permanent damage boost
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    else
        data.OrigamiShurikenCounter = 0
        data.OrigamiShurikenPreviousCounter = 1
    end
    if data.OrigamiShurikenRelative > data.OrigamiShurikenCounter then
        data.OrigamiShurikenPreviousCounter = data.OrigamiShurikenCounter +1
    end
end

-- Function to handle cache update
function BrokenOrigami:onEvaluateCacheOrigamiShuriken(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if data.OrigamiShurikenDamageBoost then
            player.Damage = player.Damage + data.OrigamiShurikenDamageBoost
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiShuriken)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCacheOrigamiShuriken)
