local fortuneTeller = RegisterMod("Fortune Teller", 1)
local game = Game()
local itemID = Isaac.GetItemIdByName("Fortune Teller")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(itemID, "{{ArrowUp}} Grants +5 Luck {{Luck}}#{{ArrowDown}} Gives 2 Broken Hearts {{BrokenHeart}}")
end

-- Function to handle item pickup
function fortuneTeller:onItemPickup(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the fortuneTellerCounter if it doesn't exist
    if not data.fortuneTellerCounter then
        data.fortuneTellerCounter = 0
        data.fortuneTellerRelative = 0
        data.fortuneTellerPreviousCounter = 1
    end
    
    if player:HasCollectible(itemID) then
        -- Increase the counter
        data.fortuneTellerCounter = player:GetCollectibleNum(itemID)
        
        -- Apply the effect based on the number of items picked up
        if data.fortuneTellerCounter >= data.fortuneTellerPreviousCounter then
            data.fortuneTellerPreviousCounter = data.fortuneTellerPreviousCounter + 1
            data.fortuneTellerRelative = data.fortuneTellerRelative + 1
            player:AddBrokenHearts(2) -- Add 1 broken heart
            data.fortuneTellerLuckBoost = 5*data.fortuneTellerRelative -- Track the permanent damage boost
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()
        end
    else
        data.fortuneTellerCounter = 0
        data.fortuneTellerPreviousCounter = 1
    end
    if data.fortuneTellerRelative > data.fortuneTellerCounter then
        data.fortuneTellerPreviousCounter = data.fortuneTellerCounter +1
    end
end

-- Function to handle cache update
function fortuneTeller:onEvaluateCache(player, cacheFlag)
    local data = player:GetData()
    if cacheFlag == CacheFlag.CACHE_LUCK then
        if data.fortuneTellerLuckBoost then
            player.Luck = player.Luck + data.fortuneTellerLuckBoost
        end
    end
end

fortuneTeller:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, fortuneTeller.onItemPickup)
fortuneTeller:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, fortuneTeller.onEvaluateCache)
