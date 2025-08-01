local game = Game()
local CeresLocalID = Isaac.GetItemIdByName("Ceres")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(CeresLocalID, "{{BrokenHeart}} Replaces hearts in this order with 1 Broken Heart:{{Heart}}{{BoneHeart}}{{SoulHeart}}{{BlackHeart}} #{{Heart}} Heals all empty containers each floor #{{DeathMark}} Occasionally, an asteroid strikes a random enemy in the room; if no enemies are present, it falls at a random location. The frequency increases with the number of Broken Hearts you have #{{Warning}} Asteroids can also damage Isaac.")
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
            
            player:AddBrokenHearts(1) 
            
        end

        local numberOfCeresEffect = player:GetBrokenHearts() + 1
        local randomValue = math.random(1, math.floor(2200 / (2*numberOfCeresEffect)))
        
        if randomValue == 1 then
            triggerCrackOfTheSky()  
        end

    else
        CeresCounter = 0
        data.CeresPreviousCounter = 1
    end
    if data.CeresRelative > CeresCounter then
        data.CeresPreviousCounter = CeresCounter +1
    end
end

function ShatteredSymbols:CeresFloor()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if player:HasCollectible(CeresLocalID) then
            local max = player:GetEffectiveMaxHearts()       
            local current = player:GetHearts()               
            local missing = max - current
            if missing > 0 then
                player:AddHearts(missing)
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.CeresRain)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.CeresFloor)

