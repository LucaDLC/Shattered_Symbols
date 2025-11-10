local game = Game()
local HoleyPocketLocalID = Isaac.GetItemIdByName("Holey Pocket")
local OrigamiCrowExternalID = Isaac.GetItemIdByName("Origami Crow")
local OrigamiKolibriExternalID = Isaac.GetItemIdByName("Origami Kolibri")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(HoleyPocketLocalID, "{{ArrowUp}} You can now drop the active item holding CTRL button #{{ArrowUp}} If you have the Origami Crow item, you drop the pocket item instead")
end

function ShatteredSymbols:useHoleyPocket()
    local currentFrame = game:GetFrameCount()
    local dataCharges = Isaac.GetPlayer(0):GetData()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()
        if not data.CtrlHoldTimeHoleyPocket then data.CtrlHoldTimeHoleyPocket = 0 end
        if not data.LastCtrlPressFrameHoleyPocket then data.LastCtrlPressFrameHoleyPocket = 0 end
        if not dataCharges.ChargesDroppedItems then dataCharges.ChargesDroppedItems = {} end

        if player:HasCollectible(HoleyPocketLocalID) then
            if Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, player.ControllerIndex) then
                data.LastCtrlPressFrameHoleyPocket = currentFrame
            end

            if currentFrame - data.LastCtrlPressFrameHoleyPocket < 3 then
                data.CtrlHoldTimeHoleyPocket = data.CtrlHoldTimeHoleyPocket + 1

                if data.CtrlHoldTimeHoleyPocket >= 30 and not player:HasCollectible(OrigamiCrowExternalID) then
                    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
                    if activeItem > 0 then
                        local itemCharge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
                        local level = game:GetLevel()
                        local stage = level:GetStage()

                        player:RemoveCollectible(activeItem, false, ActiveSlot.SLOT_PRIMARY)
                        local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, activeItem, player.Position + Vector(0, 50), Vector(0, 0), nil)
                        
                        table.insert(dataCharges.ChargesDroppedItems, {
                            ItemID = activeItem,
                            FloorID = stage,
                            Charge = itemCharge
                        })

                        SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN)
                        
                    end
                    data.CtrlHoldTimeHoleyPocket = 0
                elseif data.CtrlHoldTimeHoleyPocket >= 30 and player:HasCollectible(OrigamiCrowExternalID) then
                    local pocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
                    if pocketItem > 0 then
                        local pocketItemCharge = player:GetActiveCharge(ActiveSlot.SLOT_POCKET)
                        local level = game:GetLevel()
                        local stage = level:GetStage()

                        player:RemoveCollectible(pocketItem, false, ActiveSlot.SLOT_POCKET)
                        local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, pocketItem, player.Position + Vector(0, 50), Vector(0, 0), nil)
                        
                        table.insert(dataCharges.ChargesDroppedItems, {
                            ItemID = pocketItem,
                            FloorID = stage,
                            Charge = pocketItemCharge
                        })
                        
                        SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN)
                    end
                    data.CtrlHoldTimeHoleyPocket = 0
                end
            else
                data.CtrlHoldTimeHoleyPocket = 0
            end

            if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= nil or player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= nil then 
                for i, entry in ipairs(dataCharges.ChargesDroppedItems) do 
                    local level = game:GetLevel()
                    local stage = level:GetStage()
                    if player:HasCollectible(entry.ItemID) and entry.FloorID == stage then 
                        
                        local activeSlot = ActiveSlot.SLOT_PRIMARY 
                        if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= entry.ItemID and player:GetActiveItem(ActiveSlot.SLOT_POCKET) == entry.ItemID then 
                            activeSlot = ActiveSlot.SLOT_POCKET 
                        end 
                        player:SetActiveCharge(entry.Charge, activeSlot) 
                        table.remove(dataCharges.ChargesDroppedItems, i) 
                        
                        break 
                    end 
                end 
            end

        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.useHoleyPocket)
