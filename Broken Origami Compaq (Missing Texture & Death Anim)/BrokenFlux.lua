local game = Game()
local BrokenFluxLocalID = Isaac.GetItemIdByName("Broken Flux")

if EID then
    EID:assignTransformation("collectible", BrokenFluxLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(BrokenFluxLocalID, "Teleport in one of these different location: #{{UltraSecretRoom}} Ultra Secret Room at 40% chance #{{DevilRoom}} Devil Room at 25% chance #{{AngelRoom}} Angel Room at 20% chance #{{Planetarium}} Planetarium at 15% chance #{{BrokenHeart}} When you hold the item, after gaining Broken Heart, the item remove it for charging, every Broken Heart is equal to one charge #{{ArrowUp}} All Broken Flux of a player share charges ")
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
                    data.BrokenFluxCharge = data.BrokenFluxCharge + 1
                    player:AddBrokenHearts(-1)
                end

                if player:HasCollectible(BrokenFluxLocalID) and data.BrokenFluxCharge <= 4 then
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
        local randomLocation = math.random() * 100
        if randomLocation <= 40 then
            player:AnimateTeleport(true)
            --player:Teleport(0, RoomType.ROOM_ULTRASECRET)
        elseif randomLocation <= 65 then
            player:AnimateTeleport(true)
            --player:Teleport(0, RoomType.ROOM_DEVIL)
        elseif randomLocation <= 85 then
            player:AnimateTeleport(true)
            --player:Teleport(0, RoomType.ROOM_ANGEL)
        else
            player:AnimateTeleport(true)
            --player:Teleport(0, RoomType.ROOM_PLANETARIUM)
        end
        data.BrokenFluxCharge = 0
    end

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.havingBrokenFlux)
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useBrokenFlux, BrokenFluxLocalID)

