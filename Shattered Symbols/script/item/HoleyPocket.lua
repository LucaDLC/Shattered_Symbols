local game = Game()
local HoleyPocketLocalID = Isaac.GetItemIdByName("Holey Pocket")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(HoleyPocketLocalID, "{{ArrowUp}} Drop active item holding CTRL button")
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

                if data.CtrlHoldTimeHoleyPocket >= 60 then
                    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
                    if activeItem > 0 then
                        local pos = player.Position
                        player:RemoveCollectible(activeItem, false, ActiveSlot.SLOT_PRIMARY)
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, activeItem, pos, Vector(0, 0), nil)
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
