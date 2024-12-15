local game = Game()
local ForbiddenBodyLocalID = Isaac.GetItemIdByName("Forbidden Body")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(ForbiddenBodyLocalID, "{{EthernalHeart}} Half Eternal Heart count as 2 and can remove 1 Broken Heart")
end

function BrokenOrigami:useForbidenBody(pickup, collider)
    if collider:ToPlayer() then
        local player = collider:ToPlayer()
        if pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType == HeartSubType.HEART_ETERNAL and player:HasCollectible(ForbiddenSoulLocalID) then
            player:AddBrokenHearts(-1) -- Rimuovi un broken heart
            player:AddEternalHearts(1) -- Aggiungi un altro half Eternal Heart
        end
    end
end

-- Registra il callback per verificare l'ingresso nella Devil Room
BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, BrokenOrigami.useForbidenBody)
