local game = Game()
local MidnightBiteLocalID = Isaac.GetItemIdByName("Midnight Bite")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(MidnightBiteLocalID, "nothing")
end

-- Function to handle item pickup
function BrokenOrigami:useMidnightBite(player)
    
    if player:HasCollectible(MidnightBiteLocalID) then

        for i = 0, player:GetMaxHearts() // 2 - 1 do
            if player:GetHeartContainerType(i) == HeartContainerType.HEART_CONTAINER then
                player:SetHeartContainerType(i, HeartContainerType.HEART_ROTTEN)
            end
        end
        
    end
end

function BrokenOrigami:ConvertDroppedRedHearts(_, entity)
    if entity.Variant == PickupVariant.PICKUP_HEART then
        local heart = entity:ToPickup()
        if heart and (heart.SubType == HeartSubType.HEART_FULL or heart.SubType == HeartSubType.HEART_HALF or heart.SubType == HeartSubType.HEART_DOUBLEPACK) then
            heart:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, true, false, false)
        end
    end
end


BrokenOrigami:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, BrokenOrigamiConvertDroppedRedHearts, EntityType.ENTITY_PICKUP)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useMidnightBite)
