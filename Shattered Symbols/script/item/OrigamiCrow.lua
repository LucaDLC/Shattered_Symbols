local game = Game()
local OrigamiCrowLocalID = Isaac.GetItemIdByName("Origami Crow")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(OrigamiCrowLocalID, "{{ArrowUp}} Moves the active item to the pocket item if you don't have one #{{ArrowUp}} If you have no active item, the first one you pick becomes the pocket item #{{BrokenHeart}} Gives 2 Broken Hearts which replaces Hearts in this order {{Heart}}{{BoneHeart}}{{SoulHeart}}{{BlackHeart}} #{{Warning}} Picking up an item that grants you a pocket item will overwrite your current one")
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

local function toPocket(player)
    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    local pocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)

    if activeItem ~= 0 and pocketItem == 0 and activeItem ~= CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES then
        player:SetPocketActiveItem(activeItem, ActiveSlot.SLOT_POCKET)
        player:RemoveCollectible(activeItem, true, ActiveSlot.SLOT_PRIMARY)
    end

end

function ShatteredSymbols:useOrigamiCrow(player)
    local data = player:GetData()
    local OrigamiCrowCounter = player:GetCollectibleNum(OrigamiCrowLocalID)

    if not data.OrigamiCrowRelative then data.OrigamiCrowRelative = 0 end
    if not data.OrigamiCrowPreviousCounter then data.OrigamiCrowPreviousCounter = 1 end

    if player:HasCollectible(OrigamiCrowLocalID) then
        
        if OrigamiCrowCounter >= data.OrigamiCrowPreviousCounter then
            data.OrigamiCrowPreviousCounter = data.OrigamiCrowPreviousCounter + 1
            data.OrigamiCrowRelative = data.OrigamiCrowRelative + 1
            BrokenHeartRemovingSystem(player) 
            BrokenHeartRemovingSystem(player)
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

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useOrigamiCrow)
