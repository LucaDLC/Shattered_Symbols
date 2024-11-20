local game = Game()
local OrigamiNightingaleLocalID = Isaac.GetItemIdByName("Origami Nightingale")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", OrigamiNightingaleLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiNightingaleLocalID, "#{{BrokenHeart}} Gives 1 Broken Hearts")
end

-- Function to handle item pickup
function BrokenOrigami:useOrigamiNightingale(player)
    -- Get the player's data table
    local data = player:GetData()
    local OrigamiNightingaleCounter = player:GetCollectibleNum(OrigamiNightingaleLocalID)

    if not data.OrigamiNightingaleRelative then data.OrigamiNightingaleRelative = 0 end
    if not data.OrigamiNightingalePreviousCounter then data.OrigamiNightingalePreviousCounter = 1 end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiNightingaleLocalID) then
        
        -- Apply the effect based on the number of items picked up
        if OrigamiNightingaleCounter >= data.OrigamiNightingalePreviousCounter then
            data.OrigamiNightingalePreviousCounter = data.OrigamiNightingalePreviousCounter + 1
            data.OrigamiNightingaleRelative = data.OrigamiNightingaleRelative + 1
            player:AddBrokenHearts(1) -- Add 1 broken heart 
        end
        toPocket(player, data)
    else
        OrigamiNightingaleCounter = 0
        data.OrigamiNightingalePreviousCounter = 1
    end
    if data.OrigamiNightingaleRelative > OrigamiNightingaleCounter then
        data.OrigamiNightingalePreviousCounter = OrigamiNightingaleCounter +1
    end
end

-- Funzione per assegnare l'attivo al pocket slot
local function toPocket(player, data)
    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    local pocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)

    if activeItem ~= 0 and pocketItem == 0 then
        player:SetPocketActiveItem(activeItem, ActiveSlot.SLOT_POCKET)
        player:RemoveCollectible(activeItem, true, ActiveSlot.SLOT_PRIMARY)
    end

end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiNightingale)
