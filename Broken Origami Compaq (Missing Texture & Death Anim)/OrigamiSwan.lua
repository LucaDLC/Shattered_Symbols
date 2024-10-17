local game = Game()
local OrigamiSwanLocalID = Isaac.GetItemIdByName("Origami Swan")

if EID then
    EID:assignTransformation("collectible", OrigamiSwanLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiSwanLocalID, "{{ArrowUp}} All trinket you take become instantanely a permanent item #{{ArrowDown}} Gives 2 Broken Hearts {{BrokenHeart}}")
end


function BrokenOrigami:useOrigamiSwan()
    local player = Isaac.GetPlayer(0)
    local data = player:GetData()
    
    -- Initialize the OrigamiSwanCounter if it doesn't exist
    if not data.OrigamiSwanCounter then
        data.OrigamiSwanCounter = 0
        data.OrigamiSwanRelative = 0
        data.OrigamiSwanPreviousCounter = 1
    end

    if player:HasCollectible(OrigamiSwanLocalID) then
        data.OrigamiSwanCounter = player:GetCollectibleNum(OrigamiSwanLocalID)
        for i = 0, 1 do  -- Controlla entrambi gli slot dei trinket
            local trinketID = player:GetTrinket(i)
            if trinketID ~= 0 then  -- Se c'è un trinket nello slot
                player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, false, false)  -- Effetto Smelter senza usarlo direttamente
            end
        end
        if data.OrigamiSwanCounter >= data.OrigamiSwanPreviousCounter then
            data.OrigamiSwanPreviousCounter = data.OrigamiSwanPreviousCounter + 1
            data.OrigamiSwanRelative = data.OrigamiSwanRelative + 1
            player:AddBrokenHearts(2)
        end
    else
        data.OrigamiSwanCounter = 0
        data.OrigamiSwanPreviousCounter = 1
    end
    if data.OrigamiSwanRelative > data.OrigamiSwanCounter then
        data.OrigamiSwanPreviousCounter = data.OrigamiSwanCounter +1
    end
end

-- Registra la funzione che si attiva continuamente
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiSwan)