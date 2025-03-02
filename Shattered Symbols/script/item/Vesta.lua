local game = Game()
local VestaLocalID = Isaac.GetItemIdByName("Vesta")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(VestaLocalID, "{{Burning}} Occasionally, the enemies in the room start to burn for 3 seconds and its frequency increasing with numbers of Vesta you have")
end

local function triggerBurn(player)
    local room = game:GetRoom()    
    
    for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_PLAYER then  
            entity:AddBurn(EntityRef(player), 90, player.Damage)
        end
    end
    
end

function ShatteredSymbols:VestaEffect(player)
    local data = player:GetData()

    if player:HasCollectible(VestaLocalID) then

        local numberOfVestas = player:GetCollectibleNum(VestaLocalID)
        if numberOfVestas > 0 then
            if numberOfVestas > 5 then numberOfVestas = 5 end
            local randomValue = math.random(1, math.floor(1024 / 2^numberOfVestas))
        
            if randomValue == 1 then
                triggerBurn(player)  
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.VestaEffect)

