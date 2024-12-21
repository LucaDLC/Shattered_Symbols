local game = Game()
local FortuneTellerLocalID = Isaac.GetItemIdByName("Fortune Teller")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", FortuneTellerLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(FortuneTellerLocalID, "{{ArrowUp}} Grants +5 Luck {{Luck}}#{{ArrowDown}} Gives 2 Broken Hearts which does not replace Heart{{BrokenHeart}}")
end

-- Function to handle item pickup
function ShatteredSymbols:useFortuneTeller(player)
    -- Get the player's data table
    local data = player:GetData()
    local FortuneTellerCounter = player:GetCollectibleNum(FortuneTellerLocalID)
    
    if not data.FortuneTellerRelative then data.FortuneTellerRelative = 0 end
    if not data.FortuneTellerPreviousCounter then data.FortuneTellerPreviousCounter = 1 end
    if not data.FortuneTellerLuckBoost then data.FortuneTellerLuckBoost = 0 end
    
    if player:HasCollectible(FortuneTellerLocalID) then
        
        -- Apply the effect based on the number of items picked up
        if FortuneTellerCounter >= data.FortuneTellerPreviousCounter then
            data.FortuneTellerPreviousCounter = data.FortuneTellerPreviousCounter + 1
            data.FortuneTellerRelative = data.FortuneTellerRelative + 1
            player:AddBrokenHearts(1) -- Add 1 broken heart
            data.FortuneTellerLuckBoost = 5*data.FortuneTellerRelative -- Track the permanent damage boost
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

-- Function to handle cache update
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
