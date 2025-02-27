local game = Game()
local OrigamiSwanLocalID = Isaac.GetItemIdByName("Origami Swan")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(OrigamiSwanLocalID, "{{Trinket}} All trinket you take become instantanely a permanent item #{{BrokenHeart}} Gives 2 Broken Hearts which does not replace Heart")
end


function ShatteredSymbols:useOrigamiSwan(player)
    local data = player:GetData()
    local OrigamiSwanCounter = player:GetCollectibleNum(OrigamiSwanLocalID) 

    if not data.OrigamiSwanRelative then data.OrigamiSwanRelative = 0 end
    if not data.OrigamiSwanPreviousCounter then data.OrigamiSwanPreviousCounter = 1 end

    if player:HasCollectible(OrigamiSwanLocalID) then
        for i = 0, 1 do  
            local trinketID = player:GetTrinket(i)
            if trinketID ~= 0 then  
                player:TryRemoveTrinket(trinketID)
                player:AddSmeltedTrinket(trinketID)
                SFXManager():Play(SoundEffect.SOUND_VAMP_GULP)
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

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useOrigamiSwan)