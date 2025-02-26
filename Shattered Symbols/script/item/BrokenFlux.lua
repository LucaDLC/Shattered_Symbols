local game = Game()
local BrokenFluxLocalID = Isaac.GetItemIdByName("Broken Flux")
local OrigamiCrowExternalID = Isaac.GetItemIdByName("Origami Crow")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(BrokenFluxLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{UltraSecretRoom}} Teleport in Ultra Secret Room #{{BrokenHeart}} When you hold the item, after gaining Broken Heart, the item remove it for charging, every Broken Heart is equal to one charge #{{ArrowDown}} If the absorbed Broken Hearts have replaced Hearts, these are not returned")
end

function ShatteredSymbols:havingBrokenFlux(player)
    local data = player:GetData()
    if not data.BrokenFluxPreviousBrokenHearts then data.BrokenFluxPreviousBrokenHearts = -1 end

    if player:HasCollectible(BrokenFluxLocalID) then
        for i = 0, 3 do 
            local activeItem = player:GetActiveItem(i)
            if activeItem ~= 0 and activeItem == BrokenFluxLocalID then
                local currentBrokenHearts = player:GetBrokenHearts()
                if data.BrokenFluxPreviousBrokenHearts == -1 then
                    data.BrokenFluxPreviousBrokenHearts = currentBrokenHearts
                end
                
                if currentBrokenHearts > data.BrokenFluxPreviousBrokenHearts then
                    for Diff = 1, (currentBrokenHearts - data.BrokenFluxPreviousBrokenHearts) do
                        if player:GetActiveCharge(i) < 3 then
                            player:AddBrokenHearts(-1)
                            player:SetActiveCharge(player:GetActiveCharge(i) + 1, i)
                        else  
                            player:SetActiveCharge(3, i)
                        end
                    end
                    SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE)
                end
                
                data.BrokenFluxPreviousBrokenHearts = currentBrokenHearts
            end
        end
    else
        data.BrokenFluxPreviousBrokenHearts = -1
    end
end

function ShatteredSymbols:useBrokenFlux(_, rng, player)
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
            return roomDesc.SafeGridIndex 
        end
    end
    return nil
end

function ShatteredSymbols:FluxWispInit(wisp)
    if wisp.Player and wisp.Player:HasCollectible(BrokenFluxLocalID) then
        if wisp.SubType == BrokenFluxLocalID then
            wisp.SubType = 580
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.FluxWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.havingBrokenFlux)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useBrokenFlux, BrokenFluxLocalID)
