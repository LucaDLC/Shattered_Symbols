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
                
                -- Memorizza la carica iniziale se non esiste già
                chargeMemory[i] = chargeMemory[i] or currentCharge
                
                -- Calcola la carica aggiuntiva ottenuta dall'ultimo ciclo
                local chargeGained = currentCharge - chargeMemory[i]
                
                -- Se è stata aggiunta carica, raddoppiala
                if chargeGained > 0 then
                    -- Calcola la nuova carica senza limitazioni
                    local doubledCharge = currentCharge + chargeGained
                    player:SetActiveCharge(doubledCharge, i)
                end
                
                -- Aggiorna la carica memorizzata per il prossimo ciclo
                chargeMemory[i] = player:GetActiveCharge(i)
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

