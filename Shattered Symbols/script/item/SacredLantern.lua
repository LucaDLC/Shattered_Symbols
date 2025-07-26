local game = Game()
local SacredLanternLocalID = Isaac.GetItemIdByName("Sacred Lantern")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(SacredLanternLocalID, "{{BrokenHeart}} Remove all your Broken Hearts #{{SoulHeart}} For every Broken Heart removed you obtain an Soul Heart #{{Player14}} For every Broken Heart removed you obtain an Empty Coin Heart #{{Burning}} Burns all enemies in the room for a number of seconds equal to the Broken Hearts removed")
end

local function triggerBurn(player)
    local room = game:GetRoom()    
    local damageTime = 30 * player:GetBrokenHearts()
    for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and entity.Type ~= EntityType.ENTITY_PLAYER then  
            entity:AddBurn(EntityRef(player), damageTime, player.Damage)
        end
    end
end

function ShatteredSymbols:useSacredLantern(_, rng, player)

    if player:HasCollectible(SacredLanternLocalID) then
        local brokenHearts = player:GetBrokenHearts() 
        local playerType = player:GetPlayerType()
        if brokenHearts > 0 then
            triggerBurn(player)
            for i = 1, brokenHearts do
                player:AddBrokenHearts(-1) 
                if (playerType == PlayerType.PLAYER_KEEPER or playerType == PlayerType.PLAYER_KEEPER_B) then
                    player:AddMaxHearts(2)
                else
                    player:AddSoulHearts(2) 
                end         
            end
        end
        
    end

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
    
end

function ShatteredSymbols:LanternWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(SacredLanternLocalID) then
		if wisp.SubType == SacredLanternLocalID then
			wisp.SubType = 160
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.LanternWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useSacredLantern, SacredLanternLocalID)