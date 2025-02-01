
local game = Game()
local PyriteLocalID = Isaac.GetItemIdByName("Pyrite")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(PyriteLocalID, "{{Coin}} All coins turn into Golden Pennies #{{ArrowDown}} Your coins reset to 0 at the start of each floor")
end

function ShatteredSymbols:OnPickupInitPyrite(entity)
 
    if entity.Variant == PickupVariant.PICKUP_COIN then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)  
            if player:HasCollectible(PyriteLocalID) then
                entity.SubType = CoinSubType.COIN_GOLDEN_PENNY
            end
        end
    end
end

function ShatteredSymbols:OnNewLevelPyrite()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local currentCoins = player:GetNumCoins()
        if currentCoins ~= 0 and player:HasCollectible(PyriteLocalID) then
            player:AddCoins(-currentCoins)
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ShatteredSymbols.OnPickupInitPyrite, PickupVariant.PICKUP_COIN)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelPyrite)