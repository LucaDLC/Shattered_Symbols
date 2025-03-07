local game = Game()
local ForbiddenBodyLocalID = Isaac.GetItemIdByName("Forbidden Body")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(ForbiddenBodyLocalID, "Allows purchasing Devil Deal items with Broken Hearts if available. If not enough Broken Hearts are present, the remaining cost is paid with normal health.")
end

-- Funzione per cambiare la valuta nella Devil Room
function BrokenOrigami:HandleForbiddenBody()
    local player = Isaac.GetPlayer(0)
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()

    -- Controlla se siamo nella Devil Room
    if room:GetType() == RoomType.ROOM_DEVIL and player:HasCollectible(ForbiddenBodyLocalID) then
        for i, entity in ipairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                local pickup = entity:ToPickup()
                local itemCost = room:GetDevilPrice(pickup.SubType)

                if itemCost > 0 then
                    local brokenHearts = player:GetBrokenHearts()

                    if brokenHearts >= itemCost then
                        -- Imposta il costo a Broken Hearts
                        room:SetDevilPrice(pickup.SubType, 0)
                        pickup.Price = PickupPrice.PRICE_SPIKES
                    elseif brokenHearts > 0 then
                        -- Usa tutti i Broken Hearts disponibili e aggiungi il resto come normale
                        local remainingCost = itemCost - brokenHearts
                        room:SetDevilPrice(pickup.SubType, remainingCost)
                        pickup.Price = PickupPrice.PRICE_HEALTH
                    end
                end
            end
        end
    end
end

-- Registra il callback per verificare l'ingresso nella Devil Room
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BrokenOrigami.HandleForbiddenBody)
