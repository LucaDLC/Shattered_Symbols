local game = Game()
local OrigamiCrowLocalID = Isaac.GetItemIdByName("Origami Crow")

-- EID (se usi EID per la descrizione)
if EID then
    EID:assignTransformation("collectible", OrigamiCrowLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiCrowLocalID, "{{ArrowUp}} Move primary active item to pocket item if you don't have one or if previous pocket item disappear #{{ArrowUp}} If you don't have active item, first one that you take become the pocket item #{{BrokenHeart}} Gives 2 Broken Hearts which does not replace Heart #{{Warning}} If you take item that give you pocket item, this one overwrite your pocket item that you have moved before")
end

local function toPocket(player)
    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    local pocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)

    if activeItem ~= 0 and pocketItem == 0 and activeItem ~= CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES then
        player:SetPocketActiveItem(activeItem, ActiveSlot.SLOT_POCKET)
        player:RemoveCollectible(activeItem, true, ActiveSlot.SLOT_PRIMARY)
    end

end

-- Function to handle item pickup
function BrokenOrigami:useOrigamiCrow(player)
    -- Get the player's data table
    local data = player:GetData()
    local OrigamiCrowCounter = player:GetCollectibleNum(OrigamiCrowLocalID)

    if not data.OrigamiCrowRelative then data.OrigamiCrowRelative = 0 end
    if not data.OrigamiCrowPreviousCounter then data.OrigamiCrowPreviousCounter = 1 end

    -- Check if the player has picked up the item
    if player:HasCollectible(OrigamiCrowLocalID) then
        
        -- Apply the effect based on the number of items picked up
        if OrigamiCrowCounter >= data.OrigamiCrowPreviousCounter then
            data.OrigamiCrowPreviousCounter = data.OrigamiCrowPreviousCounter + 1
            data.OrigamiCrowRelative = data.OrigamiCrowRelative + 1
            player:AddBrokenHearts(2) -- Add 1 broken heart 
        end
        toPocket(player)
    else
        OrigamiCrowCounter = 0
        data.OrigamiCrowPreviousCounter = 1
    end
    if data.OrigamiCrowRelative > OrigamiCrowCounter then
        data.OrigamiCrowPreviousCounter = OrigamiCrowCounter +1
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiCrow)
