local game = Game()
local MidnightBiteLocalID = Isaac.GetItemIdByName("Midnight Bite")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(MidnightBiteLocalID, "nothing")
end

-- Function to handle item pickup
function BrokenOrigami:useMidnightBite(player)
    
    if player:HasCollectible(MidnightBiteLocalID) then
        local currentHeart = player:GetHearts()
        local currentRottenHeart = player:GetRottenHearts()
        
        -- Se ci sono cuori rossi, procedi
        if currentHeart ~= currentRottenHeart then
            player:AddHearts(-1)  -- Rimuove un cuore rosso
            player:AddRottenHearts(1)
        end
    end
end

function BrokenOrigami:ConvertDroppedRedHearts(_, entity)
    local heart = entity:ToPickup()
    if heart and (heart.SubType == HeartSubType.HEART_FULL or heart.SubType == HeartSubType.HEART_HALF or heart.SubType == HeartSubType.HEART_DOUBLEPACK) then
        heart:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, true, false, false)
    end
    
end


BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BrokenOrigami.ConvertDroppedRedHearts, PickupVariant.PICKUP_HEART)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useMidnightBite)
