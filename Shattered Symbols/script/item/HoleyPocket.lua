local game = Game()
local HoleyPocketLocalID = Isaac.GetItemIdByName("Holey Pocket")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(HoleyPocketLocalID, "{{ArrowUp}} Drop active item holding CTRL button")
end


function ShatteredSymbols:useHoleyPocket()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local ctrlHoldTime = 0
        if Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, 0) and player:HasCollectible(HoleyPocketLocalID) then
            ctrlHoldTime = ctrlHoldTime + 1

            if ctrlHoldTime >= 180 then
                local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
                if activeItem > 0 then
                    local pos = player.Position
                    player:RemoveCollectible(activeItem, false, ActiveSlot.SLOT_PRIMARY)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, activeItem, pos, Vector(0, 0), nil)
                end
                ctrlHoldTime = 0 
            end
        else
            ctrlHoldTime = 0 
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.useHoleyPocket)
