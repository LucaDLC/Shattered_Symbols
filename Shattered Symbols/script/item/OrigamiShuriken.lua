local game = Game()
local OrigamiShurikenLocalID = Isaac.GetItemIdByName("Origami Shuriken")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(OrigamiShurikenLocalID, "{{ArrowUp}} Grants +3 Damage {{Damage}}#{{ArrowDown}} Gives 1 Broken Hearts which does not replace Heart{{BrokenHeart}}")
end

-- Function to handle item pickup
function ShatteredSymbols:useOrigamiShuriken(player)
    -- Get the player's data table
    local data = player:GetData()
    local OrigamiShurikenCounter = player:GetCollectibleNum(OrigamiShurikenLocalID)

    if not data.OrigamiShurikenRelative then data.OrigamiShurikenRelative = 0 end
    if not data.OrigamiShurikenPreviousCounter then data.OrigamiShurikenPreviousCounter = 1 end
    if not data.OrigamiShurikenDamageBoost then data.OrigamiShurikenDamageBoost = 0 end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiShurikenLocalID) then
        
        -- Apply the effect based on the number of items picked up
        if OrigamiShurikenCounter >= data.OrigamiShurikenPreviousCounter then
            data.OrigamiShurikenPreviousCounter = data.OrigamiShurikenPreviousCounter + 1
            data.OrigamiShurikenRelative = data.OrigamiShurikenRelative + 1
            player:AddBrokenHearts(1) -- Add 1 broken heart
            data.OrigamiShurikenDamageBoost = 3*data.OrigamiShurikenRelative -- Track the permanent damage boost
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    else
        OrigamiShurikenCounter = 0
        data.OrigamiShurikenPreviousCounter = 1
    end
    if data.OrigamiShurikenRelative > OrigamiShurikenCounter then
        data.OrigamiShurikenPreviousCounter = OrigamiShurikenCounter +1
    end
end

-- Function to handle cache update
function ShatteredSymbols:onEvaluateCacheOrigamiShuriken(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if data.OrigamiShurikenDamageBoost then
            player.Damage = player.Damage + data.OrigamiShurikenDamageBoost
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useOrigamiShuriken)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheOrigamiShuriken)
