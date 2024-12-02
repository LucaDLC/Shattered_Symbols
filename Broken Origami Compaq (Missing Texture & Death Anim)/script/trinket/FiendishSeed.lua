local game = Game()
local FiendishSeedLocalID = Isaac.GetItemIdByName("Fiendish Seed")

if EID then
    EID:addTrinket(FiendishSeedLocalID, "{{SoulHeart}} Convert dropped Soul Heart in Black Heart or Bone Heart")
end

-- Callback per quando il giocatore usa una runa
function BrokenOrigami:holdingFiendishSeed(entity)
    local soulHeart = entity:ToPickup()
    
    -- Controlla che l'entità sia valida e sia un pickup del tipo cuore
    if soulHeart and soulHeart.Variant == PickupVariant.PICKUP_HEART and player:HasTrinket(FiendishSeedLocalID) then
        -- Verifica se il tipo di cuore è tra quelli da trasformare
        if soulHeart.SubType == HeartSubType.HEART_SOUL or 
            soulHeart.SubType == HeartSubType.HEART_HALF_SOUL then
                if math.random(100) < 50 then
                    heart:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, true, false, false)
                else
                    heart:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE, true, false, false)
                end   
        end
    end

end



BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BrokenOrigami.holdingFiendishSeed, PickupVariant.PICKUP_HEART)
