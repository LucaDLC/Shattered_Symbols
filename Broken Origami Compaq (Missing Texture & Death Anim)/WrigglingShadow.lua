local game = Game()
local WrigglingShadowLocalID = Isaac.GetItemIdByName("Wriggling Shadow")
local TornHookExternalID = Isaac.GetItemIdByName("Torn Hook")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(WrigglingShadowLocalID, "{{Warning}} SINGLE USE, WORKS ONLY IF YOU HAVE TORN HOOK{{Warning}}#{{ArrowUp}} Remove Torn Hook and multiply all current stats x3")
end

-- Funzione per gestire l'uso dell'oggetto "Wriggling Shadow"
function BrokenOrigami:useWrigglingShadow(_, rng, player)
    if player:HasCollectible(TornHookExternalID) then
        -- Aggiorna le cache per tutte le statistiche
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
        for i = 1, player:GetCollectibleNum(TornHookExternalID) do
            player:RemoveCollectible(TornHookExternalID)
        end
    end

    -- Oggetto Wriggling Shadow viene rimosso dopo l'uso
    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

-- Callback per aggiornare le statistiche quando l'oggetto viene raccolto
function BrokenOrigami:onEvaluateCacheWrigglingShadow(player, cacheFlag)
    if player:HasCollectible(TornHookExternalID) and player:HasCollectible(WrigglingShadowLocalID) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * 3
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed * 3
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange * 3
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local newTears = (30.0 / (player.MaxFireDelay + 1)) * 3
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            if player.Luck == 0 then
                player.Luck = player.Luck + 1
            else
                player.Luck = player.Luck * 3
            end
        end
    end
end


BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useWrigglingShadow, WrigglingShadowLocalID)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCacheWrigglingShadow)
