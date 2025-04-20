local game = Game()
local ShatteredHeartLocalID = Isaac.GetItemIdByName("Shattered Heart")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(ShatteredHeartLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{BrokenHeart}} Remove 1 Broken Heart and gain an Empty Heart Container ")
end

function ShatteredSymbols:useShatteredHeart(_, rng, player)
    if player:HasCollectible(ShatteredHeartLocalID) then
        player:AddBrokenHearts(-1)
        player:AddMaxHearts(2)
    end
    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function ShatteredSymbols:ShatteredHeartWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(ShatteredHeartLocalID) then
		if wisp.SubType == ShatteredHeartLocalID then
			wisp.SubType = 45
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.ShatteredHeartWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useShatteredHeart, ShatteredHeartLocalID)


