local game = Game()
local OrigamiSwanLocalID = Isaac.GetItemIdByName("Origami Swan")
local SwanFlag = false

if EID then
    EID:assignTransformation("collectible", OrigamiSwanLocalID, EID.TRANSFORMATION["ORIGAMI"])
    EID:addCollectible(OrigamiSwanLocalID, "{{ArrowUp}} All trinket you take become instantanely a permanent item #{{ArrowDown}} Gives 2 Broken Hearts {{BrokenHeart}} #{{ColorRed}}It's not cumulative with other Origami Swan{{CR}}")
end


function BrokenOrigami:useOrigamiSwan()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(OrigamiSwanLocalID) then
        for i = 0, 1 do  -- Controlla entrambi gli slot dei trinket
            local trinketID = player:GetTrinket(i)
            if trinketID ~= 0 then  -- Se c'è un trinket nello slot
                player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, false, false)  -- Effetto Smelter senza usarlo direttamente
            end
        end
    end
end

-- Registra la funzione che si attiva continuamente
BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BrokenOrigami.useOrigamiSwan)