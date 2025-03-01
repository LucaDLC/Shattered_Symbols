local game = Game()
local MeteorLocalID = Isaac.GetItemIdByName("Meteor")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(MeteorLocalID, "{{BrokenHeart}} Remove 2 Broken Hearts #{{BlackHeart}} If you have fewer than 2 Broken Hearts, remove any you have, and for each one missing to reach 2 Broken Hearts you receive 2 Black Hearts#{{DeathMark}} Occasionally, a meteor will strike an enemy in the room. If there are no enemies present, it will fall at a random location, with its frequency increasing with numbers of Meteor you have #{{Warning}} Meteors can also damage Isaac")
end

local function triggerCrackOfTheSky()
    local room = game:GetRoom()  
    local targets = {}  
    
    for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_PLAYER then  
            table.insert(targets, entity)
        end
    end
    
    local targetPosition
    if #targets > 0 then
        local target = targets[math.random(1, #targets)]
        targetPosition = target.Position
    else
        local randomX = math.random(room:GetTopLeftPos().X, room:GetBottomRightPos().X)
        local randomY = math.random(room:GetTopLeftPos().Y, room:GetBottomRightPos().Y)
        targetPosition = Vector(randomX, randomY)
    end
    
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, targetPosition, Vector(0,0), nil)
end

function ShatteredSymbols:meteorRain(player)
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

        local numberOfMeteors = player:GetCollectibleNum(MeteorLocalID)
        if numberOfMeteors > 0 then
            if numberOfMeteors > 5 then numberOfMeteors = 5 end
            local randomValue = math.random(1, math.floor(1024 / 2^numberOfMeteors))
        
            if randomValue == 1 then
                triggerCrackOfTheSky()  
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

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.meteorRain)

