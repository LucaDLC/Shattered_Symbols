local game = Game()
local OrigamiCrowdLocalID = Isaac.GetItemIdByName("Origami Crowd")

if EID then
    EID:assignTransformation("collectible", OrigamiCrowdLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiCrowdLocalID, "Every stats up increasing:#{{ArrowUp}} Damage +0.3#{{ArrowUp}} Speed +0.1#{{ArrowUp}} Range +0.5#{{ArrowUp}} Tears +0.3#{{ArrowUp}} Luck +0.2")
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
local flagCounter = {
    damage = 0,
    speed = 0,
    range = 0,
    tears = 0,
    luck = 0,
}

function BrokenOrigami:useOrigamiCrowd(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the OrigamiCrowdCounter if it doesn't exist
    if not data.OrigamiCrowdCounter then
        data.OrigamiCrowdCounter = 0
        data.OrigamiCrowdRelative = 0
        data.OrigamiCrowdPreviousCounter = 1
    end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiCrowdLocalID) then
        -- Increase the counter
        data.OrigamiCrowdCounter = player:GetCollectibleNum(OrigamiCrowdLocalID)
        
        -- Apply the effect based on the number of items picked up
        if data.OrigamiCrowdCounter >= data.OrigamiCrowdPreviousCounter then
            data.OrigamiCrowdPreviousCounter = data.OrigamiCrowdPreviousCounter + 1
            data.OrigamiCrowdRelative = data.OrigamiCrowdRelative + 1
            player:AddBrokenHearts(1) -- Add 1 broken heart
        end
    else
        data.OrigamiCrowdCounter = 0
        data.OrigamiCrowdPreviousCounter = 1
    end
    if data.OrigamiCrowdRelative > data.OrigamiCrowdCounter then
        data.OrigamiCrowdPreviousCounter = data.OrigamiCrowdCounter +1
    end
end

function BrokenOrigami:onEvaluateCacheOrigamiCrowd(player, cacheFlag)
    local data = player:GetData()
    if player:HasCollectible(OrigamiCrowdLocalID) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            flagCounter.damage = flagCounter.damage + 1
            player.Damage = player.Damage + (flagCounter.damage * statMultiplier.damage)
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            flagCounter.speed = flagCounter.speed + 1
            player.MoveSpeed = player.MoveSpeed + (flagCounter.speed * statMultiplier.speed)
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            flagCounter.range = flagCounter.range + 1
            player.TearRange = player.TearRange + (flagCounter.range * statMultiplier.range)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            flagCounter.tears = flagCounter.tears + 1
            local newTears = (30.0 / (player.MaxFireDelay + 1)) + (flagCounter.tears * statMultiplier.tears)
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            flagCounter.luck = flagCounter.luck + 1
            player.Luck = player.Luck + (flagCounter.luck * statMultiplier.luck)
        end
    end
end
function BrokenOrigami:onGameStartOrigamiCrowd()
    flagCounter.damage = 0
    flagCounter.speed = 0
    flagCounter.range = 0
    flagCounter.tears = 0
    flagCounter.luck = 0
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiCrowd)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCacheOrigamiCrowd)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BrokenOrigami.onGameStartOrigamiCrowd)
