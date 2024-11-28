local game = Game()
local OrigamiNightingaleLocalID = Isaac.GetItemIdByName("Origami Nightingale")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", OrigamiNightingaleLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiNightingaleLocalID, "{{ArrowUp}} Move primary active item to pocket item if you don't have one or if previous pocket item disappear #{{ArrowUp}} If you don't have active item, first one that you take become the pocket item #{{BrokenHeart}} Gives 2 Broken Hearts which does not replace Heart #{{Warning}} If you take item that give you pocket item, this one overwrite your pocket item that you have moved before")
end

local function toPocket(player)
    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    local pocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)

    if activeItem ~= 0 and pocketItem == 0 then
        player:SetPocketActiveItem(activeItem, ActiveSlot.SLOT_POCKET)
        player:RemoveCollectible(activeItem, true, ActiveSlot.SLOT_PRIMARY)
    end

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
            player:AddBrokenHearts(2) -- Add 1 broken heart 
        end
        toPocket(player)
    else
        OrigamiNightingaleCounter = 0
        data.OrigamiNightingalePreviousCounter = 1
    end
    if data.OrigamiNightingaleRelative > OrigamiNightingaleCounter then
        data.OrigamiNightingalePreviousCounter = OrigamiNightingaleCounter +1
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiNightingale)
