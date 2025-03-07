local game = Game()
local OrigamiSwanLocalID = Isaac.GetItemIdByName("Origami Swan")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(OrigamiSwanLocalID, "{{Trinket}} All trinket you take become instantanely a permanent item #{{BrokenHeart}} Gives 2 Broken Hearts which does replace Heart in this order {{Heart}}{{BoneHeart}}{{SoulHeart}}{{BlackHeart}}")
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
            BrokenHeartRemovingSystem(player)
            BrokenHeartRemovingSystem(player)
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