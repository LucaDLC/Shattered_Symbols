local game = Game()
local BrokenFluxLocalID = Isaac.GetItemIdByName("Broken Flux")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(BrokenFluxLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{UltraSecretRoom}} Teleports you to the Ultra Secret Room #{{BrokenHeart}} While holding this item, each Broken Heart gained is consumed to charge the item, with every Broken Heart counting as one charge.")
end

function ShatteredSymbols:havingBrokenFlux(player)
    local data = player:GetData()
    if not data.BrokenFluxPreviousBrokenHearts then data.BrokenFluxPreviousBrokenHearts = -1 end
    if not data.BrokenFluxPreviousHearts then
        data.BrokenFluxPreviousHearts = {red = 0, bone = 0, soul = 0, black = 0}
    end

    if player:HasCollectible(BrokenFluxLocalID) then
        for i = 0, 3 do 
            local activeItem = player:GetActiveItem(i)
            if activeItem ~= 0 and activeItem == BrokenFluxLocalID then
                local currentBrokenHearts = player:GetBrokenHearts()
                
                if data.BrokenFluxPreviousBrokenHearts == -1 then
                    data.BrokenFluxPreviousBrokenHearts = currentBrokenHearts
                    data.BrokenFluxPreviousHearts.red = player:GetMaxHearts()
                    data.BrokenFluxPreviousHearts.bone = player:GetBoneHearts()
                    data.BrokenFluxPreviousHearts.soul = player:GetSoulHearts()
                    data.BrokenFluxPreviousHearts.black = player:GetBlackHearts()
                end
                
                if currentBrokenHearts > data.BrokenFluxPreviousBrokenHearts then
                    for Diff = 1, (currentBrokenHearts - data.BrokenFluxPreviousBrokenHearts) do
                        if player:GetActiveCharge(i) < 3 then
                            player:AddBrokenHearts(-1)
                            player:SetActiveCharge(player:GetActiveCharge(i) + 1, i)
                            
                            local currentRed = player:GetMaxHearts()
                            local currentBone = player:GetBoneHearts()
                            local currentSoul = player:GetSoulHearts()
                            local currentBlack = player:GetBlackHearts()

                            if currentRed < data.BrokenFluxPreviousHearts.red then
                                player:AddMaxHearts(2)
                                player:AddHearts(2)
                            elseif currentBone < data.BrokenFluxPreviousHearts.bone then
                                player:AddBoneHearts(1)
                            elseif currentSoul < data.BrokenFluxPreviousHearts.soul then
                                player:AddSoulHearts(2)
                            elseif currentBlack < data.BrokenFluxPreviousHearts.black then
                                player:AddBlackHearts(2)
                            end

                        else  
                            player:SetActiveCharge(3, i)
                        end
                    end
                    SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE)
                end
                
                data.BrokenFluxPreviousBrokenHearts = currentBrokenHearts
                data.BrokenFluxPreviousHearts.red = player:GetMaxHearts()
                data.BrokenFluxPreviousHearts.bone = player:GetBoneHearts()
                data.BrokenFluxPreviousHearts.soul = player:GetSoulHearts()
                data.BrokenFluxPreviousHearts.black = player:GetBlackHearts()
            end
        end
    else
        data.BrokenFluxPreviousBrokenHearts = -1
        data.BrokenFluxPreviousHearts = {red = 0, bone = 0, soul = 0, black = 0}
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
