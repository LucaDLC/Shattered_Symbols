local game = Game()
local ForbiddenBodyLocalID = Isaac.GetItemIdByName("Forbidden Soul")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(ForbiddenBodyLocalID, "{{GoldenHeart}} Grant every room a Golden Heart if you don't have one #{{EthernalHeart}} Half Eternal Heart count as 2 and can remove 1 Broken Heart")
end

local function RemoveBrokenHearts(player, amount)
    for i = 1, amount do
        player:AddBrokenHearts(-1)
    end
end

-- Callback per applicare il golden heart all'inizio di ogni stanza
local function HandleDevilDeal(player)
    local room = game:GetRoom()

    -- Controlla se è una Devil Room
    if room:GetType() == RoomType.ROOM_DEVIL then
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                local pickup = entity:ToPickup()
                local itemCost = pickup.Price

                -- Verifica se l'oggetto ha un costo in cuori rossi
                if itemCost > 0 and player:HasCollectible(ForbiddenBodyLocalID) then
                    local brokenHearts = player:GetBrokenHearts()

                    if brokenHearts >= itemCost then
                        -- Usa solo Broken Hearts
                        player:AddBrokenHearts(-itemCost)
                        pickup.Price = 0
                    elseif brokenHearts > 0 then
                        -- Usa i Broken Hearts rimanenti e sottrai il resto dai cuori normali
                        player:AddBrokenHearts(-brokenHearts)
                        pickup.Price = itemCost - brokenHearts
                    end
                end
            end
        end
    end
end


BrokenOrigami:AddCallback(ModCallbacks.MC_POST_UPDATE, BrokenOrigami.OnDevilDeal)
