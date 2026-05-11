local game = Game()
local HoleyPocketLocalID = Isaac.GetItemIdByName("Holey Pocket")
local OrigamiCrowExternalID = Isaac.GetItemIdByName("Origami Crow")
local OrigamiKolibriExternalID = Isaac.GetItemIdByName("Origami Kolibri")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(HoleyPocketLocalID, "{{ArrowUp}} You can now drop the active item holding CTRL button, the items that you drop discharge themself #{{ArrowUp}} If you have the Origami Crow item, you drop the pocket item instead #{{ArrowUp}} If you have the Origami Kolibri, you can save charges instead")
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

                        local seedKey = tostring(pickup.InitSeed)
                        dataCharges.ChargesDroppedItems[seedKey] = {
                            ItemID = activeItem,
                            FloorID = stage,
                            Charge = itemCharge
                        }

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
                        
                        local seedKey = tostring(pickup.InitSeed)
                        dataCharges.ChargesDroppedItems[seedKey] = {
                            ItemID = pocketItem,
                            FloorID = stage,
                            Charge = pocketItemCharge
                        }
                        
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

-- When the player touches a collectible pedestal, check if it's a Holey Pocket drop
-- and annotate which seed is about to be picked up
function ShatteredSymbols:holeyPocketPickupCollision(pickup, collider, _)
    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
    if collider.Type ~= EntityType.ENTITY_PLAYER then return end

    local dataCharges = Isaac.GetPlayer(0):GetData()
    if not dataCharges.ChargesDroppedItems then return end

    local seedKey = tostring(pickup.InitSeed)
    if dataCharges.ChargesDroppedItems[seedKey] then
        local player = collider:ToPlayer()
        if player then
            local data = player:GetData()
            data.PendingHoleyRestore = seedKey
        end
    end
end

-- REPENTOGON: When a collectible is added to inventory, restore the saved charge
-- MC_POST_ADD_COLLECTIBLE args: (CollectibleType, Charge, FirstTime, Slot, VarData, Player)
function ShatteredSymbols:holeyPocketRestoreCharge(collectibleType, charge, firstTime, slot, varData, player)
    if not player then return end

    local data = player:GetData()
    local dataCharges = Isaac.GetPlayer(0):GetData()

    if not data.PendingHoleyRestore then return end
    if not dataCharges.ChargesDroppedItems then return end

    local seedKey = data.PendingHoleyRestore
    local entry = dataCharges.ChargesDroppedItems[seedKey]

    if entry and entry.ItemID == collectibleType then
        local level = game:GetLevel()
        local stage = level:GetStage()

        if entry.FloorID == stage then
            if player:HasCollectible(OrigamiKolibriExternalID) then
                player:SetActiveCharge(entry.Charge, slot)
            else
                player:SetActiveCharge(0, slot)
            end
        end

        dataCharges.ChargesDroppedItems[seedKey] = nil
    end

    data.PendingHoleyRestore = nil
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.useHoleyPocket)
ShatteredSymbols:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, ShatteredSymbols.holeyPocketPickupCollision)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, ShatteredSymbols.holeyPocketRestoreCharge)
