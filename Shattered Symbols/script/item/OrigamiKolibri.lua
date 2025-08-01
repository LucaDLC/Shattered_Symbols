local game = Game()
local OrigamiKolibriLocalID = Isaac.GetItemIdByName("Origami Kolibri")
local RunicAltarExternalID = Isaac.GetItemIdByName("Runic Altar")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(OrigamiKolibriLocalID, "{{Battery}} Duplicates all charges gained of active item for the rest of the game #{{Battery}} Does not duplicate extra charges #{{BrokenHeart}} Gives 2 Broken Hearts which replaces Hearts in this order {{Heart}}{{BoneHeart}}{{SoulHeart}}{{BlackHeart}}")
end

local function BrokenHeartRemovingSystem(player)
    local slotRemoved = false

    if player:GetMaxHearts() >= 2 and not slotRemoved then
        player:AddMaxHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBoneHearts() >= 1 then
        player:AddBoneHearts(-1) 
        slotRemoved = true
    end

    if not slotRemoved and player:GetSoulHearts() >= 2 then
        player:AddSoulHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBlackHearts() >= 2 then
        player:AddBlackHearts(-2)  
        slotRemoved = true
    end

    player:AddBrokenHearts(1)

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
            BrokenHeartRemovingSystem(player)
            BrokenHeartRemovingSystem(player) 
        end

        for i = 0, 3 do 
            local activeItem = player:GetActiveItem(i)
            if activeItem ~= 0 and activeItem ~= RunicAltarExternalID then
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

