local game = Game()
local ForbiddenSoulLocalID = Isaac.GetItemIdByName("Forbidden Soul")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(ForbiddenSoulLocalID, "{{GoldenHeart}} Grant every room a Golden Heart if you don't have one #{{EthernalHeart}} Half Eternal Heart count as 2 and can remove 1 Broken Heart")
end


-- Callback per applicare il golden heart all'inizio di ogni stanza
function BrokenOrigami:useForbidenSoul()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B and player:HasCollectible(ForbiddenSoulLocalID) then
            local level = game:GetLevel()
            local room = level:GetCurrentRoom()

            if room:IsFirstVisit() then
                local wisp = player:AddWisp(ForbiddenSoulLocalID, player.Position)
                if wisp.SubType == ForbiddenSoulLocalID then
                    wisp.SubType = 719
                end
            end
        end

        elseif player:GetGoldenHearts() < 1 and player:HasCollectible(ForbiddenSoulLocalID) then
            player:AddGoldenHearts(1)
        end
    end
end

-- Callback per gestire la raccolta di half Eternal Heart
function BrokenOrigami:passiveForbidenSoul(pickup, collider)
    if collider:ToPlayer() then
        local player = collider:ToPlayer()
        if pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType == HeartSubType.HEART_ETERNAL and player:HasCollectible(ForbiddenSoulLocalID) then
            player:AddEternalHearts(1) -- Aggiungi un altro half Eternal Heart
            player:AddBrokenHearts(-1) -- Rimuovi un broken heart
        end
    end
end



BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, BrokenOrigami.passiveForbidenSoul)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BrokenOrigami.useForbidenSoul)