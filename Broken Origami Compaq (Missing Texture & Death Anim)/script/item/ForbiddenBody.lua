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
function BrokenOrigami:OnDevilDeal(player)
    if not player:HasCollectible(forbiddenBodyItemID) then
        return
    end

    local level = Game():GetLevel()
    local devilDealRoom = level:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX, 0)

    if devilDealRoom and devilDealRoom:IsDevilRoom() then
        for _, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                local itemCost = entity:ToPickup().Price
                if itemCost <= player:GetBrokenHearts() then
                    RemoveBrokenHearts(player, itemCost)
                    entity:ToPickup().Price = 0
                elseif itemCost > player:GetBrokenHearts()  then
                    RemoveBrokenHearts(player, itemCost)
                    entity:ToPickup().Price = (itemCost - player:GetBrokenHearts())
                end
            end
        end
    end
end

-- Registrare il callback
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_UPDATE, BrokenOrigami.OnDevilDeal)
