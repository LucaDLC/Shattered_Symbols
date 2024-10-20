local game = Game()
local WrigglingShadowLocalID = Isaac.GetItemIdByName("Wriggling Shadow")
local TornHookExternalID = Isaac.GetItemIdByName("Torn Hook")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(WrigglingShadowLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{Warning}} WORKS ONLY IF YOU HAVE TORN HOOK #{{ArrowUp}} Remove all Torn Hooks and multiply all current stats x3 #{{ArrowUp}} Grant +2 Luck {{Luck}} if it is 0 #{{ArrowUp}} Remove 1 Broken Heart {{BrokenHeart}} #{{ArrowUp}} Add 1 Heart {{Heart}}")
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
        player:AddBrokenHearts(-1)
        player:AddMaxHearts(2)  
        player:AddHearts(2)
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
            local DamageTemp = player.Damage
            DamageTemp = DamageTemp * 2
            player.Damage = player.Damage + DamageTemp
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            local SpeedTemp = player.MoveSpeed
            SpeedTemp = SpeedTemp * 2
            player.MoveSpeed = player.MoveSpeed + SpeedTemp
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            local RangeTemp = player.TearRange
            RangeTemp = RangeTemp * 2
            player.TearRange = player.TearRange + RangeTemp
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local TearsTemp = player.MaxFireDelay
            TearsTemp = TearsTemp * 2
            local newTears = (30.0 / (player.MaxFireDelay + 1)) + TearsTemp
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            local LuckTemp = player.Luck
            LuckTemp = LuckTemp * 2
            if player.Luck == 0 then
                player.Luck = player.Luck + 2
            else
                player.Luck = player.Luck + LuckTemp
            end
        end
    end
end


BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useWrigglingShadow, WrigglingShadowLocalID)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCacheWrigglingShadow)
