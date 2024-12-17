local game = Game()
local ForbiddenBodyLocalID = Isaac.GetItemIdByName("Forbidden Body")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(ForbiddenBodyLocalID, "{{EthernalHeart}} Half Eternal Heart count as 2 and can remove 1 Broken Heart #{{BossRoom}} When you enter in the Boss Room for the first time you have 20% to obtain an Half Eternal Heart")
end

function BrokenOrigami:useForbidenBody(player)
    if player:GetEternalHearts() == 1 and player:HasCollectible(ForbiddenBodyLocalID) then
        player:AddBrokenHearts(-1) -- Rimuovi un broken heart
        player:AddEternalHearts(1) -- Aggiungi un altro half Eternal Heart
    end

end

function BrokenOrigami:holdingForbidenBody(pickup, collider)
    if collider:ToPlayer() then
        local player = collider:ToPlayer()
        if pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType == HeartSubType.HEART_ETERNAL and player:HasCollectible(ForbiddenBodyLocalID) then
            player:AddBrokenHearts(-1) -- Rimuovi un broken heart
            player:AddEternalHearts(1) -- Aggiungi un altro half Eternal Heart
        end
    end
end

function BrokenOrigami:onBossRoomForbidenBody()
    local room = game:GetRoom()

    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if room:GetType() == RoomType.ROOM_BOSS and room:IsFirstVisit() and player:HasCollectible(ForbiddenBodyLocalID) then
            if math.random() <= 0.20 then 
                player:AddEternalHearts(1) 
            end
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useForbidenBody)
BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, BrokenOrigami.holdingForbidenBody)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BrokenOrigami.onBossRoomForbidenBody)
