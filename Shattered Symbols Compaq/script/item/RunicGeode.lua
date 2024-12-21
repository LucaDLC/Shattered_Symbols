local game = Game()
local RunicGeodeLocalID = Isaac.GetItemIdByName("Runic Geode")

if EID then
	EID:addCollectible(RunicGeodeLocalID, "{{Rune}}Spawns 1 Rune or Soul Stone #{{Collectible584}} Spawns purple-glowing rune wisps on the middle ring that spawn Runes/Soul Stones when destroyed, when enemies killed by the wisps' tears have a 15% chance to drop a Rune/Soul Stone.")
end


function ShatteredSymbols:UseGeode(geode, rng, player, flags, slot, data)
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

function ShatteredSymbols:GeodeWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(RunicGeodeLocalID) then
		if wisp.SubType == RunicGeodeLocalID then
			wisp.SubType = 263
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.GeodeWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.UseGeode, RunicGeodeLocalID)

