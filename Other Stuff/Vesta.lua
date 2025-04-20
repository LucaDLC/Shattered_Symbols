local game = Game()
local VestaLocalID = Isaac.GetItemIdByName("Vesta")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(VestaLocalID, "{{BrokenHeart}} Every floor you have 25% chance to remove 1 Broken Heart and substitute it with an Empty Heart Container #{{HolyMantleSmall}} If you don't have Broken Hearts, you gain the Holy Mantle Effect #{{DeathMark}} Occasionally, the enemies in the room obtain these effects: #{{Burning}} Burn for 3 seconds #{{Freezing}} Freeze for 3 seconds #{{ArrowUp}} Both effects increasing with the numbers of Vesta you have")
end

local function triggerBurn(player)
    local room = game:GetRoom()    
    
    for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_PLAYER then  
            entity:AddBurn(EntityRef(player), 90, player.Damage)
            entity:AddFreeze(EntityRef(player), 90)
        end
    end
end

function ShatteredSymbols:VestaEffect(player)
    if player:HasCollectible(VestaLocalID) then
        local numberOfVestas = player:GetCollectibleNum(VestaLocalID)
        if numberOfVestas > 0 then
            local randomValue = math.random(1, math.floor(1700 / (2*numberOfVestas)))
            
            if randomValue == 1 then
                triggerBurn(player)  
            end
        end
    end
end

function ShatteredSymbols:VestaFloor()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()
        local playerType = player:GetPlayerType()
        local currentStage = game:GetLevel():GetStage()
        
        if not data.VestaMantleCounter then data.VestaMantleCounter = 0 end
        if not data.VestaMantlePreviousCounter then data.VestaMantlePreviousCounter = 0 end
        if not data.LastVestaStage then data.LastVestaStage = nil end

        if player:HasCollectible(VestaLocalID) then
            local numberOfVestas = player:GetCollectibleNum(VestaLocalID)
            if numberOfVestas > 0 then
                if numberOfVestas > 5 then numberOfVestas = 5 end
                if math.random() < (0.25 * numberOfVestas) then
                    if playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B then
                        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
                        data.VestaMantleCounter = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                        SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
                    elseif player:GetBrokenHearts() > 0 then
                        player:AddBrokenHearts(-1)
                        player:AddMaxHearts(2)
                        SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
                    elseif player:GetBrokenHearts() == 0 then
                        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
                        data.VestaMantleCounter = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                        SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
                    end
                end
            end
            local currentMantle = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
            if currentMantle < data.VestaMantleCounter then
                data.VestaMantlePreviousCounter = data.VestaMantleCounter
                data.VestaMantleCounter = currentMantle
            end
            if currentStage ~= data.LastVestaStage then
                data.LastVestaStage = currentStage
                for i = 1, data.VestaMantlePreviousCounter - player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE) do
                    player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
                end
                data.VestaMantleCounter = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.VestaEffect)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.VestaFloor)


