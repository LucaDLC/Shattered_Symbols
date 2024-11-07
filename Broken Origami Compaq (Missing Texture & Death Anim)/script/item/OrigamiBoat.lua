local game = Game()
local OrigamiBoatLocalID = Isaac.GetItemIdByName("Origami Boat")

if EID then
    EID:assignTransformation("collectible", OrigamiBoatLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiBoatLocalID, "Every broken heart {{BrokenHeart}} grants:#{{ArrowUp}} Damage +0.5#{{ArrowUp}} Speed +0.2#{{ArrowUp}} Range +0.5#{{ArrowUp}} Tears +0.5#{{ArrowUp}} Luck +0.3")
end

-- Valori base per l'aumento delle statistiche
local statMultiplier = {
    damage = 0.5,  -- +0.5 Damage per ogni broken heart
    speed = 0.2,   -- +0.2 Speed per ogni broken heart
    range = 20,    -- +0.5 Range per ogni broken heart
    tears = 0.5,   -- +0.5 Fire Rate per ogni broken heart
    luck = 0.3,    -- +0.3 Luck per ogni broken heart
}

-- Funzione che aggiorna le statistiche del giocatore
function BrokenOrigami:useOrigamiBoat(player)
    local data = player:GetData()

    if not data.brokenHeartsCount then data.brokenHeartsCount = 0 end
    if not data.holdingItemforStats then data.holdingItemforStats = false end
    
    local currentBrokenHearts = player:GetBrokenHearts()
    if player:HasCollectible(OrigamiBoatLocalID) then
        if currentBrokenHearts ~= data.brokenHeartsCount then
            local diff = currentBrokenHearts - data.brokenHeartsCount

            -- Aumenta o riduci le stats in base alla differenza di broken hearts
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:AddCacheFlags(CacheFlag.CACHE_RANGE)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()

            -- Aggiorna il conteggio di broken hearts
            data.brokenHeartsCount = currentBrokenHearts
        end
    elseif not player:HasCollectible(OrigamiBoatLocalID) and data.holdingItemforStats == true then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
    end
end

function BrokenOrigami:onEvaluateCacheOrigamiBoat(player, cacheFlag)
    local data = player:GetData()
    local brokenHearts = player:GetBrokenHearts()
    if (currentBrokenHearts ~= data.brokenHeartsCount) and player:HasCollectible(OrigamiBoatLocalID) then
        data.holdingItemforStats = true
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + (brokenHearts * statMultiplier.damage)
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + (brokenHearts * statMultiplier.speed)
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + (brokenHearts * statMultiplier.range)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local newTears = (30.0 / (player.MaxFireDelay + 1)) + (brokenHearts * statMultiplier.tears)
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + (brokenHearts * statMultiplier.luck)
        end
    elseif data.holdingItemforStats == true then
        data.holdingItemforStats = false
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + (0 * statMultiplier.damage)
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + (0 * statMultiplier.speed)
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + (0 * statMultiplier.range)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local newTears = (30.0 / (player.MaxFireDelay + 1)) + (0 * statMultiplier.tears)
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + (0 * statMultiplier.luck)
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiBoat)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCacheOrigamiBoat)
