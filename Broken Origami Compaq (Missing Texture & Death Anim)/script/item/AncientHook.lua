
local game = Game()
local AncientHookLocalID = Isaac.GetItemIdByName("Ancient Hook")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", AncientHookLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(AncientHookLocalID, "{{BrokenHeart}} Gives 1 Broken Hearts at every Floor #At every floor grants:#{{ArrowUp}} Damage +0.7#{{ArrowUp}} Speed +0.2#{{ArrowUp}} Range +0.5#{{ArrowUp}} Tears +0.7#{{ArrowUp}} Luck +0.5 #{{Luck}} You have same Chance as Luck to remove Ancient Hooks on each floor, at the floor when Ancient Hooks removed the effects not activate")
end

local statMultiplier = {
    damage = 0.7,  -- +0.7 Damage per ogni broken heart
    speed = 0.2,   -- +0.2 Speed per ogni broken heart
    range = 20,    -- +0.5 Range per ogni broken heart
    tears = 0.7,   -- +0.7 Fire Rate per ogni broken heart
    luck = 0.5,    -- +0.5 Luck per ogni broken heart
}

function BrokenOrigami:onAncientHook()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()

        if not data.AncientHookCounter then data.AncientHookCounter = 0 end

        if player:HasCollectible(AncientHookLocalID) then
            local luck = math.max(player.Luck, 0)
            if math.random(1, 100) <= luck then
                for i = 1, player:GetCollectibleNum(AncientHookLocalID) do
                    player:RemoveCollectible(AncientHookLocalID)
                end
            else
                local AncientHooksNum = player:GetCollectibleNum(AncientHookLocalID)
                player:AddBrokenHearts(1*AncientHooksNum)
                data.AncientHookCounter = data.AncientHookCounter + (1 * player:GetCollectibleNum(AncientHookLocalID))
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                player:AddCacheFlags(CacheFlag.CACHE_RANGE)
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                player:AddCacheFlags(CacheFlag.CACHE_LUCK)
                player:EvaluateItems()
            end
        end
    end
end

function BrokenOrigami:onEvaluateCacheAncientHook(player, cacheFlag)
    local data = player:GetData()
    if not data.AncientHookCounter then data.AncientHookCounter = 0 end
    if player:HasCollectible(AncientHookLocalID) or data.AncientHookCounter > 0 then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + (data.AncientHookCounter * statMultiplier.damage)
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + (data.AncientHookCounter * statMultiplier.speed)
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + (data.AncientHookCounter * statMultiplier.range)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local newTears = (30.0 / (player.MaxFireDelay + 1)) + (data.AncientHookCounter * statMultiplier.tears)
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + (data.AncientHookCounter * statMultiplier.luck)
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BrokenOrigami.onAncientHook)
BrokenOrigami:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BrokenOrigami.onEvaluateCacheAncientHook)
