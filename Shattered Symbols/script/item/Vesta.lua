local game = Game()
local VestaLocalID = Isaac.GetItemIdByName("Vesta")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(VestaLocalID, "{{BrokenHeart}} Every floor if you don't have Broken Heart, you gain the Holy Card Effect #{{DeathMark}} Occasionally, the enemies in the room obtain these effects: #{{Burning}} Burn for 3 seconds #{{Freezing}} Freeze for 3 seconds #{{ArrowUp}} Freezing and Burning effects increasing frequencies with the numbers of Broken Heart you have #{{Player10}} Every floor you gain the Holy Card Effect")
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
        local numberOfVestasEffect = player:GetBrokenHearts() + 1
        local randomValue = math.random(1, math.floor(1700 / (2*numberOfVestasEffect)))
            
        if randomValue == 1 then
            triggerBurn(player)  
        end

    end
end

function ShatteredSymbols:VestaFloor()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if player:HasCollectible(VestaLocalID) then
            
            local playerType = player:GetPlayerType()
            if playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B or player:GetBrokenHearts() == 0 then
                player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
                SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
            end
                
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.VestaEffect)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.VestaFloor)
