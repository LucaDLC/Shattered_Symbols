local game = Game()
local FortuneTellerLocalID = Isaac.GetItemIdByName("Fortune Teller")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(FortuneTellerLocalID, "{{ArrowUp}} Grants +5 Luck {{Luck}}#{{ArrowDown}} Gives 1 Broken Hearts which does not replace Heart{{BrokenHeart}}")
end

function ShatteredSymbols:useFortuneTeller(player)
    local data = player:GetData()
    local FortuneTellerCounter = player:GetCollectibleNum(FortuneTellerLocalID)
    
    if not data.FortuneTellerRelative then data.FortuneTellerRelative = 0 end
    if not data.FortuneTellerPreviousCounter then data.FortuneTellerPreviousCounter = 1 end
    if not data.FortuneTellerLuckBoost then data.FortuneTellerLuckBoost = 0 end
    
    if player:HasCollectible(FortuneTellerLocalID) then
        
        if FortuneTellerCounter >= data.FortuneTellerPreviousCounter then
            data.FortuneTellerPreviousCounter = data.FortuneTellerPreviousCounter + 1
            data.FortuneTellerRelative = data.FortuneTellerRelative + 1
            player:AddBrokenHearts(1) 
            data.FortuneTellerLuckBoost = 5*data.FortuneTellerRelative 
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()
        end
    else
        FortuneTellerCounter = 0
        data.FortuneTellerPreviousCounter = 1
    end
    if data.FortuneTellerRelative > FortuneTellerCounter then
        data.FortuneTellerPreviousCounter = FortuneTellerCounter +1
    end
end

function ShatteredSymbols:onEvaluateCacheFortuneTeller(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_LUCK then
        if data.FortuneTellerLuckBoost then
            player.Luck = player.Luck + data.FortuneTellerLuckBoost
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useFortuneTeller)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheFortuneTeller)
