local game = Game()
local HoleyPocketLocalID = Isaac.GetItemIdByName("Holey Pocket")
local OrigamiCrowExternalID = Isaac.GetItemIdByName("Origami Crow")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(HoleyPocketLocalID, "{{ArrowUp}} Drop active item holding CTRL button #{{ArrowUp}} If you have Origami Crow, drop pocket item holding CTRL button")
end

function ShatteredSymbols:useHoleyPocket()
    local currentFrame = game:GetFrameCount()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()
        if not data.CtrlHoldTimeHoleyPocket then data.CtrlHoldTimeHoleyPocket = 0 end
        if not data.LastCtrlPressFrameHoleyPocket then data.LastCtrlPressFrameHoleyPocket = 0 end

        if player:HasCollectible(HoleyPocketLocalID) then
            if Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, player.ControllerIndex) then
                data.LastCtrlPressFrameHoleyPocket = currentFrame
            end

            if currentFrame - data.LastCtrlPressFrameHoleyPocket < 3 then
                data.CtrlHoldTimeHoleyPocket = data.CtrlHoldTimeHoleyPocket + 1

                if data.CtrlHoldTimeHoleyPocket >= 30 and not player:HasCollectible(OrigamiCrowExternalID) then
                    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
                    if activeItem > 0 then
                        player:RemoveCollectible(activeItem, false, ActiveSlot.SLOT_PRIMARY)
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, activeItem, player.Position + Vector(0, 50), Vector(0, 0), nil)
                        SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN)
                    end
                    data.CtrlHoldTimeHoleyPocket = 0
                elseif data.CtrlHoldTimeHoleyPocket >= 30 and player:HasCollectible(OrigamiCrowExternalID) then
                    local pocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
                    if pocketItem > 0 then
                        player:RemoveCollectible(pocketItem, false, ActiveSlot.SLOT_POCKET)
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, pocketItem, player.Position + Vector(0, 50), Vector(0, 0), nil)
                        SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN)
                    end
                    data.CtrlHoldTimeHoleyPocket = 0
                end
            else
                data.CtrlHoldTimeHoleyPocket = 0
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.useHoleyPocket)
