local game = Game()
local OrigamiCrowdLocalID = Isaac.GetItemIdByName("Origami Crowd")
local chargeMemory = {}

if EID then
    EID:assignTransformation("collectible", OrigamiCrowdLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiCrowdLocalID, "Duplicate all charge of active item")
end


function BrokenOrigami:useOrigamiCrowd(player)
    -- Get the player's data table
    local data = player:GetData()
    
    -- Initialize the OrigamiCrowdCounter if it doesn't exist
    if not data.OrigamiCrowdCounter then
        data.OrigamiCrowdCounter = 0
        data.OrigamiCrowdRelative = 0
        data.OrigamiCrowdPreviousCounter = 1
    end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiCrowdLocalID) then
        -- Increase the counter
        data.OrigamiCrowdCounter = player:GetCollectibleNum(OrigamiCrowdLocalID)
        
        -- Apply the effect based on the number of items picked up
        if data.OrigamiCrowdCounter >= data.OrigamiCrowdPreviousCounter then
            data.OrigamiCrowdPreviousCounter = data.OrigamiCrowdPreviousCounter + 1
            data.OrigamiCrowdRelative = data.OrigamiCrowdRelative + 1
            player:AddBrokenHearts(2) -- Add 2 broken heart
        end

        for i = 0, 3 do -- Check all active item slots
            local activeItem = player:GetActiveItem(i)
            if activeItem ~= 0 then
                local currentCharge = player:GetActiveCharge(i)
                
                -- Retrieve the previous charge or set it to the current charge if first time
                local previousCharge = chargeMemory[i] or currentCharge
                chargeMemory[i] = currentCharge -- Update previous charge for the next cycle
                
                -- Calculate the charge difference
                local chargeGained = currentCharge - previousCharge
                
                -- Double only the new charge gained
                if chargeGained > 0 then
                    player:SetActiveCharge(currentCharge + chargeGained, i) -- Double new charge only
                end
            end
        end

    else
        data.OrigamiCrowdCounter = 0
        data.OrigamiCrowdPreviousCounter = 1
    end
    if data.OrigamiCrowdRelative > data.OrigamiCrowdCounter then
        data.OrigamiCrowdPreviousCounter = data.OrigamiCrowdCounter +1
    end
end


BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiCrowd)

