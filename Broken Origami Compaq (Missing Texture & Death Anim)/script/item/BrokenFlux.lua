local game = Game()
local BrokenFluxLocalID = Isaac.GetItemIdByName("Broken Flux")
local OrigamiCrowExternalID = Isaac.GetItemIdByName("Origami Crow")

if EID then
    EID:addCollectible(BrokenFluxLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{UltraSecretRoom}} Teleport in Ultra Secret Room #{{BrokenHeart}} When you hold the item, after gaining Broken Heart, the item remove it for charging, every Broken Heart is equal to one charge #{{ArrowDown}} If the absorbed Broken Hearts have replaced Heart, these are not returned #{{ArrowUp}} Broken Flux share charges with all Broken Flux of the same player during the game ")
end


function BrokenOrigami:havingBrokenFlux(player)
    -- Get the player's data table
    local data = player:GetData()
    if not data.BrokenFluxPreviousBrokenHearts then data.BrokenFluxPreviousBrokenHearts = -1 end
    if not data.BrokenFluxCharge then data.BrokenFluxCharge = 0 end

    if player:HasCollectible(BrokenFluxLocalID) then

        for i = 0, 3 do -- Check all active item slots
            local activeItem = player:GetActiveItem(i)

            if activeItem ~= 0 and activeItem == BrokenFluxLocalID then

                local currentBrokenHearts = player:GetBrokenHearts()

                if data.BrokenFluxPreviousBrokenHearts == -1 then
                    data.BrokenFluxPreviousBrokenHearts = currentBrokenHearts
                end

                
                if currentBrokenHearts > data.BrokenFluxPreviousBrokenHearts and player:HasCollectible(BrokenFluxLocalID) and data.BrokenFluxCharge < 4 then
                    for Diff = 1, (currentBrokenHearts - data.BrokenFluxPreviousBrokenHearts) do
                        if data.BrokenFluxCharge < 4 then
                            data.BrokenFluxCharge = data.BrokenFluxCharge + 1
                            if player:HasCollectible(OrigamiCrowExternalID) then
                                data.BrokenFluxCharge = data.BrokenFluxCharge + 1
                            end
                            player:AddBrokenHearts(-1)
                        end
                    end
                end

                if player:HasCollectible(BrokenFluxLocalID) then
                    if data.BrokenFluxCharge > 4 then
                        data.BrokenFluxCharge = 4
                    end
                    player:SetActiveCharge(data.BrokenFluxCharge, i)
                end
                
                data.BrokenFluxPreviousBrokenHearts = currentBrokenHearts
            end
        end

    else
        data.BrokenFluxPreviousBrokenHearts = -1
    end
end

function BrokenOrigami:useBrokenFlux(_, rng, player)
    local data = player:GetData()
    if player:HasCollectible(BrokenFluxLocalID) then

        local targetRoomIndex = getRoomIndexByType(RoomType.ROOM_ULTRASECRET)
        if targetRoomIndex then
            game:StartRoomTransition(targetRoomIndex, -1, RoomTransitionAnim.TELEPORT)
        end
        data.BrokenFluxCharge = 0
    end

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function getRoomIndexByType(roomType)
    local rooms = game:GetLevel():GetRooms()
    for i = 0, rooms.Size - 1 do
        local roomDesc = rooms:Get(i)
        if roomDesc and roomDesc.Data and roomDesc.Data.Type == roomType then
            return roomDesc.SafeGridIndex -- Restituisce l'indice sicuro per il teletrasporto
        end
    end
    return nil
end

function BrokenOrigami:FluxWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(BrokenFluxLocalID) then
		if wisp.SubType == BrokenFluxLocalID then
			wisp.SubType = 580
		end
	end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, BrokenOrigami.FluxWispInit, FamiliarVariant.WISP)
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.havingBrokenFlux)
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useBrokenFlux, BrokenFluxLocalID)

