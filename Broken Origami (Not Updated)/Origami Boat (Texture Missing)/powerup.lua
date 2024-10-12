local sacredLantern = RegisterMod("Sacred Lantern", 1)
local game = Game()
local itemID = Isaac.GetItemIdByName("Sacred Lantern")

--EID
if EID then
    EID:addCollectible(itemID, "Remove all your broken hearts {{BrokenHeart}} for the rest of the game#For every broken heart {{BrokenHeart}} removed or gain during the rest of the game you obtain:#{{HalfSoulHeart}} Half Soul Heart#{{ArrowUp}} Random Stats Up#{{ColorRed}}It's not cumulative with other Sacred Lanterns{{CR}}")
end

-- Function to handle item pickup
function sacredLantern:onItemPickup(player)
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(itemID) then
        local brokenHearts = player:GetBrokenHearts() -- Get number of broken hearts
        if brokenHearts > 0 then
            player:AddSoulHearts(brokenHearts) -- Add soul hearts (1 broken heart = half soul hearts)
            player:AddBrokenHearts(-brokenHearts) -- Remove all broken hearts
            
            for i = 1, brokenHearts do
                local statUp = math.random(1, 5)
                if statUp == 1 then
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                    player.Damage = player.Damage + 0.5
                elseif statUp == 2 then
                    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                    player.MoveSpeed = player.MoveSpeed + 0.1
                elseif statUp == 3 then
                    player:AddCacheFlags(CacheFlag.CACHE_RANGE)
                    player.TearHeight = player.TearHeight + 0.75
                elseif statUp == 4 then
                    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                    player.MaxFireDelay = player.MaxFireDelay - 0.5
                elseif statUp == 5 then
                    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
                    player.Luck = player.Luck + 0.5
                end
            end
            
            player:EvaluateItems()
        end
    end
end

-- Callback to update player stats when cache is updated
function sacredLantern:onCache(player, cacheFlag)
    if player:HasCollectible(itemID) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + 0.5
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + 0.1
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight + 0.75
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay - 0.5
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + 0.5
        end
    end
end

sacredLantern:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, sacredLantern.onItemPickup)
sacredLantern:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, sacredLantern.onCache)
