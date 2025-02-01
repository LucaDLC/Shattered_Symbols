local game = Game()
local OrigamiKolibriLocalID = Isaac.GetItemIdByName("Origami Kolibri")


if EID then
    EID:assignTransformation("collectible", OrigamiKolibriLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiKolibriLocalID, "{{ArrowUp}} Duplicate all charges gained of active item for the rest of the game #{{ArrowUp}} Charge all active items #{{ArrowDown}} Does not duplicate extra charges #{{ArrowDown}} Gives 3 Broken Hearts which does not replace Heart{{BrokenHeart}}")
end


function ShatteredSymbols:useOrigamiKolibri(player)
    -- Get the player's data table
    local data = player:GetData()
    local OrigamiKolibriCounter = player:GetCollectibleNum(OrigamiKolibriLocalID)

    if not data.OrigamiKolibriChargeMemory then data.OrigamiKolibriChargeMemory = {} end
    if not data.OrigamiKolibriRelative then data.OrigamiKolibriRelative = 0 end
    if not data.OrigamiKolibriPreviousCounter then data.OrigamiKolibriPreviousCounter = 1 end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiKolibriLocalID) then      
        
        -- Apply the effect based on the number of items picked up
        if OrigamiKolibriCounter >= data.OrigamiKolibriPreviousCounter then
            data.OrigamiKolibriPreviousCounter = data.OrigamiKolibriPreviousCounter + 1
            data.OrigamiKolibriRelative = data.OrigamiKolibriRelative + 1
            player:AddBrokenHearts(3) -- Add 3 broken heart
        end

        for i = 0, 3 do -- Check all active item slots
            local activeItem = player:GetActiveItem(i)
            if activeItem ~= 0 then
                local currentCharge = player:GetActiveCharge(i)
                
                -- Memorizza la carica iniziale se non esiste già
                if data.OrigamiKolibriChargeMemory[i] == nil then
                    data.OrigamiKolibriChargeMemory[i] = currentCharge
                end
                
                -- Calcola la carica aggiuntiva ottenuta dall'ultimo ciclo
                local chargeGained = currentCharge - data.OrigamiKolibriChargeMemory[i]
                
                -- Se è stata aggiunta carica, raddoppiala
                if chargeGained > 0 then
                    -- Calcola la nuova carica raddoppiata senza eccedere il limite massimo
                    local maxCharge = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
                    local doubledCharge = math.min(currentCharge + chargeGained, maxCharge)
                    player:SetActiveCharge(doubledCharge, i)
                end
                
                -- Aggiorna la carica memorizzata per il prossimo ciclo
                data.OrigamiKolibriChargeMemory[i] = player:GetActiveCharge(i)
            else
                -- Resetta la memoria se lo slot non contiene oggetti
                data.OrigamiKolibriChargeMemory[i] = nil
            end
        end

    else
        OrigamiKolibriCounter = 0
        data.OrigamiKolibriPreviousCounter = 1
    end
    if data.OrigamiKolibriRelative > OrigamiKolibriCounter then
        data.OrigamiKolibriPreviousCounter = OrigamiKolibriCounter +1
    end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useOrigamiKolibri)

