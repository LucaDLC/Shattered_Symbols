
local game = Game()
local PyriteLocalID = Isaac.GetItemIdByName("Pyrite")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(PyriteLocalID, "{{Coin}} All coins turn into Golden Pennies #{{ArrowDown}} Your coins reset to 0 at the start of each floor")
end

function ShatteredSymbols:OnPickupInitPyrite(entity)
    local coin = entity:ToPickup()
    
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        
        if coin and coin.Variant == PickupVariant.PICKUP_COIN and player:HasCollectible(PyriteLocalID) then
            coin:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN, true, false, false)
            
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