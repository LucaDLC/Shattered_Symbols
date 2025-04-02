local game = Game()
local DystopicMantleLocalID = Isaac.GetItemIdByName("Dystopic Mantle")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(DystopicMantleLocalID, "{{HolyMantleSmall}} After death, it become Holy Mantle")
end


function ShatteredSymbols:useDystopicMantle()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:IsDead() and player:HasCollectible(DystopicMantleLocalID) then
            player:AddCacheFlags(CacheFlag.CACHE_FLYING)
            player:EvaluateItems()
            player:RemoveCollectible(DystopicMantleLocalID)
            player:AddCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE, 1, false)
        end
    end
end

function ShatteredSymbols:onEvaluateCacheDystopicMantle(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FLYING and player:IsDead() and player:HasCollectible(DystopicMantleLocalID) then
        player.CanFly = true
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.useDystopicMantle)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheDystopicMantle)
