local game = Game()
local FortuneTellerLocalID = Isaac.GetItemIdByName("Fortune Teller")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(FortuneTellerLocalID, "{{LuckSmall}} +5 Luck #{{BrokenHeart}} Gives 1 Broken Heart which replaces Hearts in this order {{Heart}}{{BoneHeart}}{{SoulHeart}}{{BlackHeart}}")
end

local function BrokenHeartRemovingSystem(player)
    local slotRemoved = false

    if player:GetMaxHearts() >= 2 and not slotRemoved then
        player:AddMaxHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBoneHearts() >= 1 then
        player:AddBoneHearts(-1) 
        slotRemoved = true
    end

    if not slotRemoved and player:GetSoulHearts() >= 2 then
        player:AddSoulHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBlackHearts() >= 2 then
        player:AddBlackHearts(-2)  
        slotRemoved = true
    end

    player:AddBrokenHearts(1)

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
            BrokenHeartRemovingSystem(player) 
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
