local game = Game()
local CeresLocalID = Isaac.GetItemIdByName("Ceres")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(CeresLocalID, "{{BrokenHeart}} Remove 3 Broken Hearts #{{BlackHeart}} If you have fewer than 3 Broken Hearts, remove any you have, and for each one missing to reach 3 Broken Hearts you receive 1 -> 2 -> 4 Black Hearts#{{DeathMark}} Occasionally, an asteroid will strike an enemy in the room. If there are no enemies present, it will fall at a random location, with its frequency increasing with numbers of Ceres you have #{{Warning}} Asteroids can also damage Isaac")
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

function ShatteredSymbols:CeresRain(player)
    local data = player:GetData()
    local CeresCounter = player:GetCollectibleNum(CeresLocalID)
    
    if not data.CeresRelative then data.CeresRelative = 0 end
    if not data.CeresPreviousCounter then data.CeresPreviousCounter = 1 end

    if player:HasCollectible(CeresLocalID) then
        
        if CeresCounter >= data.CeresPreviousCounter then
            data.CeresPreviousCounter = data.CeresPreviousCounter + 1
            data.CeresRelative = data.CeresRelative + 1
            if player:GetBrokenHearts() >= 3 then
                player:AddBrokenHearts(-3) 
            elseif player:GetBrokenHearts() == 2 then
                player:AddBrokenHearts(-2)
                player:AddBlackHearts(2)
            elseif player:GetBrokenHearts() == 1 then
                player:AddBrokenHearts(-1)
                player:AddBlackHearts(4)
            elseif player:GetBrokenHearts() == 0 then
                player:AddBlackHearts(8)
            end
        end

        local numberOfCeress = player:GetCollectibleNum(CeresLocalID)
        if numberOfCeress > 0 then
            local randomValue = math.random(1, math.floor(1024 / 2*numberOfCeress))
        
            if randomValue == 1 then
                triggerCrackOfTheSky()  
            end
        end

    else
        CeresCounter = 0
        data.CeresPreviousCounter = 1
    end
    if data.CeresRelative > CeresCounter then
        data.CeresPreviousCounter = CeresCounter +1
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.CeresRain)

