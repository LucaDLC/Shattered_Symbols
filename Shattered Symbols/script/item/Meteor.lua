local game = Game()
local MeteorLocalID = Isaac.GetItemIdByName("Meteor")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(MeteorLocalID, "{{ArrowUp}} Remove 2 Broken Hearts {{BrokenHeart}} #{{ArrowUp}} If you have 1 Broken Hearts {{BrokenHeart}} remove it and gain 1 Black Heart {{BlackHeart}} #{{ArrowUp}} If you don't have Broken Hearts {{BrokenHeart}} gain 3 Black Heart {{BlackHeart}}")
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
                player:AddBlackHearts(2)
            elseif player:GetBrokenHearts() == 0 then
                player:AddBlackHearts(6)
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


