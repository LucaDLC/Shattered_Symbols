local game = Game()
local MeteorLocalID = Isaac.GetItemIdByName("Meteor")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(MeteorLocalID, "{{BrokenHeart}} Remove 2 Broken Hearts #{{BlackHeart}} If you have fewer than 2 Broken Hearts, remove any you have, and for each one missing to reach 2 Broken Hearts you receive 2 Black Hearts")
end

function ShatteredSymbols:useMeteor(player)
    local data = player:GetData()
    local MeteorCounter = player:GetCollectibleNum(MeteorLocalID)
    
    if not data.MeteorRelative then data.MeteorRelative = 0 end
    if not data.MeteorPreviousCounter then data.MeteorPreviousCounter = 1 end

    if player:HasCollectible(MeteorLocalID) then
        
        if MeteorCounter >= data.MeteorPreviousCounter then
            data.MeteorPreviousCounter = data.MeteorPreviousCounter + 1
            data.MeteorRelative = data.MeteorRelative + 1
            if player:GetBrokenHearts() >= 2 then
                player:AddBrokenHearts(-2) 
            elseif player:GetBrokenHearts() == 1 then
                player:AddBrokenHearts(-1)
                player:AddBlackHearts(4)
            elseif player:GetBrokenHearts() == 0 then
                player:AddBlackHearts(8)
            end
        end
    else
        MeteorCounter = 0
        data.MeteorPreviousCounter = 1
    end
    if data.MeteorRelative > MeteorCounter then
        data.MeteorPreviousCounter = MeteorCounter +1
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.useMeteor)


