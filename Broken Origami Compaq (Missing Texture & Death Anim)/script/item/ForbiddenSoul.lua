local game = Game()
local ForbiddenSoulLocalID = Isaac.GetItemIdByName("Forbidden Soul")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(ForbiddenSoulLocalID, "{{GoldenHeart}} Grant every room a Golden Heart if you don't have one #{{Player10}} {{Player31}} Give 1 Wisp every first visit in a room with 15% chance to inflicting Midas'Touch {{Collectible202}} effect")
end


-- Callback per applicare il golden heart all'inizio di ogni stanza
function BrokenOrigami:useForbidenSoul()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerType = player:GetPlayerType()
        if (playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B) and player:HasCollectible(ForbiddenSoulLocalID) then
            local level = game:GetLevel()
            local room = level:GetCurrentRoom()

            if room:IsFirstVisit() and player:HasCollectible(ForbiddenSoulLocalID) then
                local wisp = player:AddWisp(ForbiddenSoulLocalID, player.Position)
            end
        elseif player:GetGoldenHearts() < 1 and player:HasCollectible(ForbiddenSoulLocalID) then
            player:AddGoldenHearts(1)
        end
    end
end

function BrokenOrigami:BoxWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(ForbiddenSoulLocalID) then
		if wisp.SubType == ForbiddenSoulLocalID then
			wisp.SubType = 555
		end
	end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BrokenOrigami.useForbidenSoul)
BrokenOrigami:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, BrokenOrigami.BoxWispInit, FamiliarVariant.WISP)
