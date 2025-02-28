local game = Game()
local OrigamiBoatLocalID = Isaac.GetItemIdByName("Origami Boat")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(OrigamiBoatLocalID, "{{BrokenHeart}} Every Broken Heart grants:#{{DamageSmall}} +0.9 Damage#{{SpeedSmall}} +0.3 Speed#{{RangeSmall}} +1.1 Range#{{TearsSmall}} +0.8 Tears#{{LuckSmall}} +0.7 Luck")
end

local statMultiplier = {
    damage = 0.9,  -- +0.9 Damage 
    speed = 0.3,   -- +0.3 Speed 
    range = 44,    -- +1.1 Range 
    tears = 0.8,   -- +0.8 Fire Rate
    luck = 0.7,    -- +0.7 Luck 
}

function ShatteredSymbols:useOrigamiBoat(player)
    local data = player:GetData()

    if not data.OrigamiBoatBrokenHeartsCount then data.OrigamiBoatBrokenHeartsCount = 0 end
    if not data.OrigamiBoatHoldingItemforStats then data.OrigamiBoatHoldingItemforStats = false end
    
    local currentBrokenHearts = player:GetBrokenHearts()
    if player:HasCollectible(OrigamiBoatLocalID) then
        if currentBrokenHearts ~= data.OrigamiBoatBrokenHeartsCount then
            local diff = currentBrokenHearts - data.OrigamiBoatBrokenHeartsCount

            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:AddCacheFlags(CacheFlag.CACHE_RANGE)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()

            data.OrigamiBoatBrokenHeartsCount = currentBrokenHearts
        end
    elseif not player:HasCollectible(OrigamiBoatLocalID) and data.OrigamiBoatHoldingItemforStats == true then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
    end
end

function ShatteredSymbols:onEvaluateCacheOrigamiBoat(player, cacheFlag)
    local data = player:GetData()
    local brokenHearts = player:GetBrokenHearts()
    if (currentBrokenHearts ~= data.OrigamiBoatBrokenHeartsCount) and player:HasCollectible(OrigamiBoatLocalID) then
        data.OrigamiBoatHoldingItemforStats = true
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
    elseif data.OrigamiBoatHoldingItemforStats == true then
        data.OrigamiBoatHoldingItemforStats = false
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

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useOrigamiBoat)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheOrigamiBoat)
