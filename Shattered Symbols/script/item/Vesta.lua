local game = Game()
local VestaLocalID = Isaac.GetItemIdByName("Vesta")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(VestaLocalID, "{{BrokenHeart}} Every floor you have 20% chance to remove 1 Broken Heart and substitute it with an Empty Heart Container ##{{Player10}} Every floor you have 20% chance to give Holy Card effect #{{DeathMark}} Occasionally, the enemies in the room obtain these effects: #{{Burning}} Burn for 3 seconds #{{Freezing}} Freeze for 3 seconds #{{ArrowUp}} Both effects increasing with numbers of Vesta you have")
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
        if player:HasCollectible(VestaLocalID) then
            local numberOfVestas = player:GetCollectibleNum(VestaLocalID)
            if numberOfVestas > 0 then
                if numberOfVestas > 5 then numberOfVestas = 5 end
                if playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B then
                    player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
                    SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
                elseif math.random() < (0.2 * numberOfVestas) and player:GetBrokenHearts() > 0 then
                    player:AddBrokenHearts(-1)
                    player:AddMaxHearts(2)
                    SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
                end
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.VestaEffect)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.VestaFloor)


