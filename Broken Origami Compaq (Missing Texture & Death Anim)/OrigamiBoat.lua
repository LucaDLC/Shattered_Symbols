local game = Game()
local OrigamiBoatLocalID = Isaac.GetItemIdByName("Origami Boat")

if EID then
    EID:addCollectible(OrigamiBoatLocalID, "Every broken heart {{BrokenHeart}} grants:#{{ArrowUp}} Damage +0.3#{{ArrowUp}} Speed +0.1#{{ArrowUp}} Range +0.5#{{ArrowUp}} Tears +0.3#{{ArrowUp}} Luck +0.2#{{ColorRed}}It's not cumulative with other Origami Boat{{CR}}")
end

-- Valori base per l'aumento delle statistiche
local statMultiplier = {
    damage = 0.3,  -- +0.3 Damage per ogni broken heart
    speed = 0.1,   -- +0.1 Speed per ogni broken heart
    range = 20,    -- +0.5 Range per ogni broken heart
    tears = 0.3,   -- +0.3 Fire Rate per ogni broken heart
    luck = 0.2,    -- +0.2 Luck per ogni broken heart
}

-- Variabile per tenere traccia del numero di broken hearts
local brokenHeartsCount = 0
local holdingItemforStats = false

-- Funzione che aggiorna le statistiche del giocatore
function BrokenOrigami:useOrigamiBoat(player)
    local currentBrokenHearts = player:GetBrokenHearts()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(OrigamiBoatLocalID) then
        if currentBrokenHearts ~= brokenHeartsCount then
            local diff = currentBrokenHearts - brokenHeartsCount

            -- Aumenta o riduci le stats in base alla differenza di broken hearts
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:AddCacheFlags(CacheFlag.CACHE_RANGE)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()

            -- Aggiorna il conteggio di broken hearts
            brokenHeartsCount = currentBrokenHearts
        end
    elseif not player:HasCollectible(OrigamiBoatLocalID) and holdingItemforStats == true then
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
    if (currentBrokenHearts ~= brokenHeartsCount) and player:HasCollectible(OrigamiBoatLocalID) then
        holdingItemforStats = true
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
    elseif holdingItemforStats == true then
        holdingItemforStats = false
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
