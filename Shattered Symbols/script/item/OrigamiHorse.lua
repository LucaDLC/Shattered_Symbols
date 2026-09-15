local game = Game()
local OrigamiHorseLocalID = Isaac.GetItemIdByName("Origami Horse")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(OrigamiHorseLocalID, "{{BrokenHeart}} Every Broken Heart grants: #{{DamageSmall}} 0.5X Damage Multiplier #{{TearsSmall}} 1.5X Tears Multiplier #{{LuckSmall}} 1.25X Luck #{{Heart}} Every Heart Container grants: #{{DamageSmall}} 1.5X Damage Multiplier #{{TearsSmall}} 0.5X Tears Multiplier #{{LuckSmall}} 0.75X Luck")
end

local statMultiplierBroken = {
    damage = 0.5,  -- *0.5 Damage 
    tears = 1.5,   -- *1.5 Fire Rate
    luck = 1.25,   -- *1.25 Luck 
}

local statMultiplierContainer = {
    damage = 1.5,  -- *1.5 Damage 
    tears = 0.5,   -- *0.5 Fire Rate
    luck = 0.75,   -- *0.75 Luck 
}

function ShatteredSymbols:useOrigamiHorse(player)
    local data = player:GetData()
    local playerType = player:GetPlayerType()
    
    if not data.OrigamiHorseBrokenHeartsCount then data.OrigamiHorseBrokenHeartsCount = 0 end
    if not data.OrigamiHorseHoldingItemforStats then data.OrigamiHorseHoldingItemforStats = false end
    
    local currentBrokenHearts = player:GetBrokenHearts()
    if player:HasCollectible(OrigamiHorseLocalID) and not (playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B) then
        if currentBrokenHearts ~= data.OrigamiHorseBrokenHeartsCount then
            local diff = currentBrokenHearts - data.OrigamiHorseBrokenHeartsCount

            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:AddCacheFlags(CacheFlag.CACHE_RANGE)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()

            data.OrigamiHorseBrokenHeartsCount = currentBrokenHearts
        end
    elseif not player:HasCollectible(OrigamiHorseLocalID) and data.OrigamiHorseHoldingItemforStats == true and not (playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:AddCacheFlags(CacheFlag.CACHE_RANGE)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
    end
end

function ShatteredSymbols:onEvaluateCacheOrigamiHorse(player, cacheFlag)
    local data = player:GetData()
    local brokenHearts = player:GetBrokenHearts()
    local max = player:GetEffectiveMaxHearts()
    if (currentBrokenHearts ~= data.OrigamiHorseBrokenHeartsCount) and player:HasCollectible(OrigamiHorseLocalID) and not (playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B) then
        data.OrigamiHorseHoldingItemforStats = true
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + (brokenHearts * statMultiplierBroken.damage) + (max * statMultiplierContainer.damage)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local newTears = (30.0 / (player.MaxFireDelay + 1)) + (brokenHearts * statMultiplierBroken.tears) + (max * statMultiplierContainer.tears)
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + (brokenHearts * statMultiplierBroken.luck) + (max * statMultiplierContainer.luck)
        end
    elseif data.OrigamiHorseHoldingItemforStats == true and not (playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B) then
        data.OrigamiHorseHoldingItemforStats = false
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + (0 * statMultiplierBroken.damage) + (0 * statMultiplierContainer.damage)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local newTears = (30.0 / (player.MaxFireDelay + 1)) + (0 * statMultiplierBroken.tears) + (0 * statMultiplierContainer.tears)
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + (0 * statMultiplierBroken.luck) + (0 * statMultiplierContainer.luck)
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useOrigamiHorse)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheOrigamiHorse)
