local game = Game()
local WrigglingShadowLocalID = Isaac.GetItemIdByName("Wriggling Shadow")
local TornHookExternalID = Isaac.GetItemIdByName("Torn Hook")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(WrigglingShadowLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{Warning}} WORKS ONLY IF YOU HAVE TORN HOOK #{{ArrowUp}} Remove all Torn Hooks takens until now and multiply all current stats x3 #{{ArrowUp}} Grant +2 Luck {{Luck}} if it is 0 #{{ArrowUp}} Remove 1 Broken Heart {{BrokenHeart}} #{{ArrowUp}} Add 1 Heart {{Heart}}")
end

-- Funzione per gestire l'uso dell'oggetto "Wriggling Shadow"
function BrokenOrigami:useWrigglingShadow(player)
    local data = player:GetData()
    
    -- Initialize the WrigglingShadowCounter if it doesn't exist
    if not data.WrigglingShadowCounter then
        data.WrigglingShadowCounter = 0
        data.WrigglingShadowRelative = 0
        data.WrigglingShadowPreviousCounter = 1
    end

    -- Check if the player has picked up the item
    if player:HasCollectible(WrigglingShadowLocalID) then
        -- Increase the counter
        data.WrigglingShadowCounter = player:GetCollectibleNum(WrigglingShadowLocalID)
        
        -- Apply the effect based on the number of items picked up
        if data.WrigglingShadowCounter >= data.WrigglingShadowPreviousCounter then
            data.WrigglingShadowPreviousCounter = data.WrigglingShadowPreviousCounter + 1
            data.WrigglingShadowRelative = data.WrigglingShadowRelative + 1
            if player:HasCollectible(TornHookExternalID) and player:HasCollectible(WrigglingShadowLocalID) then
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
        end
    else
        data.WrigglingShadowCounter = 0
        data.WrigglingShadowPreviousCounter = 1
    end
    if data.WrigglingShadowRelative > data.WrigglingShadowCounter then
        data.WrigglingShadowPreviousCounter = data.WrigglingShadowCounter +1
    end
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


BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useWrigglingShadow)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCacheWrigglingShadow)
