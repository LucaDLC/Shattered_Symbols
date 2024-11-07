local game = Game()
local OrigamiCrowLocalID = Isaac.GetItemIdByName("Origami Crow")


if EID then
    EID:assignTransformation("collectible", OrigamiCrowLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiCrowLocalID, "{{ArrowUp}} Duplicate all charges gained of active item for the rest of the game #{{ArrowUp}} Charge all active items #{{ArrowDown}} Does not duplicate extra charges #{{ArrowDown}} Gives 3 Broken Hearts {{BrokenHeart}}")
end


function BrokenOrigami:useOrigamiCrow(player)
    -- Get the player's data table
    local data = player:GetData()
    if not data.chargeMemory then data.chargeMemory = {} end
    if not data.OrigamiCrowCounter then data.OrigamiCrowCounter = 0 end
    if not data.OrigamiCrowRelative then data.OrigamiCrowRelative = 0 end
    if not data.OrigamiCrowPreviousCounter then data.OrigamiCrowPreviousCounter = 1 end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiCrowLocalID) then
        -- Increase the counter
        data.OrigamiCrowCounter = player:GetCollectibleNum(OrigamiCrowLocalID)
        
        -- Apply the effect based on the number of items picked up
        if data.OrigamiCrowCounter >= data.OrigamiCrowPreviousCounter then
            data.OrigamiCrowPreviousCounter = data.OrigamiCrowPreviousCounter + 1
            data.OrigamiCrowRelative = data.OrigamiCrowRelative + 1
            player:AddBrokenHearts(3) -- Add 3 broken heart
        end

        for i = 0, 3 do -- Check all active item slots
            local activeItem = player:GetActiveItem(i)
            if activeItem ~= 0 then
                local currentCharge = player:GetActiveCharge(i)
                
                -- Memorizza la carica iniziale se non esiste già
                if data.chargeMemory[i] == nil then
                    data.chargeMemory[i] = currentCharge
                end
                
                -- Calcola la carica aggiuntiva ottenuta dall'ultimo ciclo
                local chargeGained = currentCharge - data.chargeMemory[i]
                
                -- Se è stata aggiunta carica, raddoppiala
                if chargeGained > 0 then
                    -- Calcola la nuova carica raddoppiata senza eccedere il limite massimo
                    local maxCharge = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
                    local doubledCharge = math.min(currentCharge + chargeGained, maxCharge)
                    player:SetActiveCharge(doubledCharge, i)
                end
                
                -- Aggiorna la carica memorizzata per il prossimo ciclo
                data.chargeMemory[i] = player:GetActiveCharge(i)
            else
                -- Resetta la memoria se lo slot non contiene oggetti
                data.chargeMemory[i] = nil
            end
        end

    else
        data.OrigamiCrowCounter = 0
        data.OrigamiCrowPreviousCounter = 1
    end
    if data.OrigamiCrowRelative > data.OrigamiCrowCounter then
        data.OrigamiCrowPreviousCounter = data.OrigamiCrowCounter +1
    end
end


BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiCrow)

