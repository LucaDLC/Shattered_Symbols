local game = Game()
local RunicGeodeID = Isaac.GetItemIdByName("Runic Geode")

if EID then
	EID:addCollectible(RunicGeodeID, "{{Rune}}Spawns 1 Rune or Soul Stone #{{Collectible584}} Spawns purple-glowing rune wisps on the middle ring that spawn Runes/Soul Stones when destroyed, when enemies killed by the wisps' tears have a 15% chance to drop a Rune/Soul Stone.")
end


function BrokenOrigami:UseGeode(geode, rng, player, flags, slot, data)
	local seed = rng:Next()
	local rune = Game():GetItemPool():GetCard(seed, false, true, true)
	player:AddCard(rune)
	player:AnimateCard(rune, "Pickup")
	return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

function BrokenOrigami:RunicWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(RunicGeodeID) then
		if wisp.SubType == RunicGeodeID then
			wisp.SubType = 263
		end
	end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.UseGeode, RunicGeodeID)
BrokenOrigami:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, BrokenOrigami.RunicWispInit, FamiliarVariant.WISP)
