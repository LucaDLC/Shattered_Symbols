local game = Game()
local MidnightBiteLocalID = Isaac.GetItemIdByName("Midnight Bite")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(MidnightBiteLocalID, "{{RottenHeart}} Relpaces all Red Hearts with Rotten Hearts for the rest of the game #{{HalfHeart}} Every Half Heart counts as Rotten Heart and all types of spawned Hearts become a Rotten Heart")
end

function ShatteredSymbols:useMidnightBite(player)
    
    if player:HasCollectible(MidnightBiteLocalID) then
        local rottenHearts = player:GetRottenHearts()      
        local allHearts = player:GetHearts()              

        local pureRedHearts = allHearts - (rottenHearts * 2)

        if pureRedHearts > 0 then
            player:AddHearts(-1)
            player:AddRottenHearts(2)
        end
    end
end

function ShatteredSymbols:ConvertDroppedRedHeartsMidnightBite(entity)
    local heart = entity:ToPickup()
    
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if heart and heart.Variant == PickupVariant.PICKUP_HEART and player:HasCollectible(MidnightBiteLocalID) then
            if heart.SubType == HeartSubType.HEART_FULL or 
               heart.SubType == HeartSubType.HEART_HALF or 
               heart.SubType == HeartSubType.HEART_DOUBLEPACK then
                heart:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, true, false, false)
            end
        end
    end
end



ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ShatteredSymbols.ConvertDroppedRedHeartsMidnightBite, PickupVariant.PICKUP_HEART)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useMidnightBite)
