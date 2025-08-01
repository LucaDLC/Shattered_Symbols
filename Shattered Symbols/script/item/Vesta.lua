local game = Game()
local VestaLocalID = Isaac.GetItemIdByName("Vesta")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(VestaLocalID, "{{BrokenHeart}} If you have no Broken Hearts, gain the Holy Card effect at the start of each floor #{{DeathMark}} Occasionally, enemies in the room are affected by: #{{Burning}} Burning for 3 seconds #{{Freezing}} Freezing for 3 seconds #{{ArrowUp}} The frequency of Burning and Freezing increases with the number of Broken Hearts you have #{{Player10}} Grants the Holy Card effect at the start of every floor.")
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
        local randomValue = math.random(1, math.floor(2200 / (2*numberOfVestasEffect)))
            
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
