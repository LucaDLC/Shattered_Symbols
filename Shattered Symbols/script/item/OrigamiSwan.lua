local game = Game()
local OrigamiSwanLocalID = Isaac.GetItemIdByName("Origami Swan")

if EID then
    EID:assignTransformation("collectible", OrigamiSwanLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiSwanLocalID, "{{ArrowUp}} All trinket you take become instantanely a permanent item #{{ArrowDown}} Gives 2 Broken Hearts which does not replace Heart{{BrokenHeart}}")
end


function ShatteredSymbols:useOrigamiSwan(player)
    local data = player:GetData()
    local OrigamiSwanCounter = player:GetCollectibleNum(OrigamiSwanLocalID) 

    if not data.OrigamiSwanRelative then data.OrigamiSwanRelative = 0 end
    if not data.OrigamiSwanPreviousCounter then data.OrigamiSwanPreviousCounter = 1 end

    if player:HasCollectible(OrigamiSwanLocalID) then
        for i = 0, 1 do  -- Controlla entrambi gli slot dei trinket
            local trinketID = player:GetTrinket(i)
            if trinketID ~= 0 then  -- Se c'è un trinket nello slot
                player:AddSmeltedTrinket(trinketID)
                player:TryRemoveTrinket(trinketID)
            end
        end
        if OrigamiSwanCounter >= data.OrigamiSwanPreviousCounter then
            data.OrigamiSwanPreviousCounter = data.OrigamiSwanPreviousCounter + 1
            data.OrigamiSwanRelative = data.OrigamiSwanRelative + 1
            player:AddBrokenHearts(2)
        end
    else
        OrigamiSwanCounter = 0
        data.OrigamiSwanPreviousCounter = 1
    end
    if data.OrigamiSwanRelative > OrigamiSwanCounter then
        data.OrigamiSwanPreviousCounter = OrigamiSwanCounter +1
    end
end

-- Registra la funzione che si attiva continuamente
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useOrigamiSwan)