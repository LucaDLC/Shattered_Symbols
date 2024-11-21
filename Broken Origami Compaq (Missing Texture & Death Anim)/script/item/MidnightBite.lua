local game = Game()
local MidnightBiteLocalID = Isaac.GetItemIdByName("Midnight Bite")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(MidnightBiteLocalID, "{{RottenHeart}} Relpace all Red Heart with Rotten Heart during the rest of the game #{{HalfHeart}} Every Half Heart in the Slots count as Rotten Heart meanwhile all types of spawned Heart become a single Rotten Heart")
end

-- Function to handle item pickup
function BrokenOrigami:useMidnightBite(player)
    
    if player:HasCollectible(MidnightBiteLocalID) then
        local rottenHearts = player:GetRottenHearts()      
        local allHearts = player:GetHearts()              

        -- Calcola i Red Hearts reali (totale cuori meno i Rotten Hearts)
        local pureRedHearts = allHearts - (rottenHearts * 2)

        -- Trasforma i Red Hearts in Rotten Hearts
        if pureRedHearts > 0 then
            -- Rimuovi un cuore rosso (mezzo cuore alla volta) e aggiungi un Rotten Heart
            player:AddHearts(-1)
            player:AddRottenHearts(2)
        end
    end
end

function BrokenOrigami:ConvertDroppedRedHearts(entity)
    local heart = entity:ToPickup()
    
    -- Controlla che l'entità sia valida e sia un pickup del tipo cuore
    if heart and heart.Variant == PickupVariant.PICKUP_HEART then
        -- Verifica se il tipo di cuore è tra quelli da trasformare
        if heart.SubType == HeartSubType.HEART_FULL or 
           heart.SubType == HeartSubType.HEART_HALF or 
           heart.SubType == HeartSubType.HEART_DOUBLEPACK then
            -- Trasforma il cuore in un Rotten Heart
            heart:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, true, false, false)
        end
    end
end



BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BrokenOrigami.ConvertDroppedRedHearts, PickupVariant.PICKUP_HEART)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useMidnightBite)
