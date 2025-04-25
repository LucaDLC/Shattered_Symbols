local game = Game()
local DystopicMantleLocalID = Isaac.GetItemIdByName("Dystopic Mantle")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(DystopicMantleLocalID, "{{HolyMantleSmall}} After death, it become Holy Mantle and grants flight")
end


function ShatteredSymbols:useDystopicMantle()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()
        if not data.IsDeadDystopicMantle then data.IsDeadDystopicMantle = 5 end
        if player:IsDead() and player:HasCollectible(DystopicMantleLocalID) then  
            data.IsDeadDystopicMantle = 0
        end
        if not player:IsDead() and (data.IsDeadDystopicMantle < 5) and player:HasCollectible(DystopicMantleLocalID) then
            player:AddCacheFlags(CacheFlag.CACHE_FLYING)
            player:EvaluateItems()
            data.IsDeadDystopicMantle = 10
            player:RemoveCollectible(DystopicMantleLocalID)
            player:AddCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE, 1, false)
            SFXManager():Play(SoundEffect.SOUND_HOLY)
        end
        if data.IsDeadDystopicMantle > 5 then
            data.IsDeadDystopicMantle = data.IsDeadDystopicMantle - 1 
            player:AddCostume(Isaac.GetItemConfig():GetCollectible(33), 1)
        end
    end
end

function ShatteredSymbols:onEvaluateCacheDystopicMantle(player, cacheFlag)
    local data = player:GetData()
    if not data.IsDeadDystopicMantle then data.IsDeadDystopicMantle = 5 end
    if cacheFlag == CacheFlag.CACHE_FLYING and (data.IsDeadDystopicMantle < 5) and player:HasCollectible(DystopicMantleLocalID) then
        player.CanFly = true
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.useDystopicMantle)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheDystopicMantle)
