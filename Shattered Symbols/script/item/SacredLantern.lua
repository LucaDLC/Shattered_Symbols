local game = Game()
local SacredLanternLocalID = Isaac.GetItemIdByName("Sacred Lantern")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(SacredLanternLocalID, "{{BrokenHeart}} Remove all your Broken Hearts #{{HalfSoulHeart}} For every Broken Heart removed you obtain an Half Soul Heart #{{Player14}} For every Broken Heart removed you obtain an Empty Coin Heart")
end

function ShatteredSymbols:useSacredLantern(_, rng, player)

    if player:HasCollectible(SacredLanternLocalID) then
        local brokenHearts = player:GetBrokenHearts() 
        local playerType = player:GetPlayerType()
        if brokenHearts > 0 then
            for i = 1, brokenHearts do
                player:AddBrokenHearts(-1) 
                if (playerType == PlayerType.PLAYER_KEEPER or playerType == PlayerType.PLAYER_KEEPER_B) then
                    player:AddMaxHearts(2)
                else
                    player:AddSoulHearts(1) 
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