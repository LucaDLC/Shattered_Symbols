local game = Game()
local OrigamiKolibriLocalID = Isaac.GetItemIdByName("Origami Kolibri")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(OrigamiKolibriLocalID, "{{ArrowUp}} Duplicate all charges gained of active item for the rest of the game #{{ArrowUp}} Charge all active items #{{ArrowDown}} Does not duplicate extra charges #{{ArrowDown}} Gives 3 Broken Hearts which does not replace Heart{{BrokenHeart}}")
end


function ShatteredSymbols:useOrigamiKolibri(player)
    local data = player:GetData()
    local OrigamiKolibriCounter = player:GetCollectibleNum(OrigamiKolibriLocalID)

    if not data.OrigamiKolibriChargeMemory then data.OrigamiKolibriChargeMemory = {} end
    if not data.OrigamiKolibriRelative then data.OrigamiKolibriRelative = 0 end
    if not data.OrigamiKolibriPreviousCounter then data.OrigamiKolibriPreviousCounter = 1 end

    if player:HasCollectible(OrigamiKolibriLocalID) then      
        
        if OrigamiKolibriCounter >= data.OrigamiKolibriPreviousCounter then
            data.OrigamiKolibriPreviousCounter = data.OrigamiKolibriPreviousCounter + 1
            data.OrigamiKolibriRelative = data.OrigamiKolibriRelative + 1
            player:AddBrokenHearts(3) 
        end

        for i = 0, 3 do 
            local activeItem = player:GetActiveItem(i)
            if activeItem ~= 0 then
                local currentCharge = player:GetActiveCharge(i)
                
                if data.OrigamiKolibriChargeMemory[i] == nil then
                    data.OrigamiKolibriChargeMemory[i] = currentCharge
                end
                
                local chargeGained = currentCharge - data.OrigamiKolibriChargeMemory[i]
                
                if chargeGained > 0 then
                    local maxCharge = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
                    local doubledCharge = math.min(currentCharge + chargeGained, maxCharge)
                    player:SetActiveCharge(doubledCharge, i)
                end
                
                data.OrigamiKolibriChargeMemory[i] = player:GetActiveCharge(i)
            else
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

