local game = Game()
local RunicGeodeLocalID = Isaac.GetItemIdByName("Runic Geode")

if EID then
	EID:addCollectible(RunicGeodeLocalID, "{{Rune}} Spawns 1 Rune or Soul Stone ") --#{{Collectible584}} Spawns purple-glowing rune wisps on the middle ring that spawn Runes/Soul Stones when destroyed, when enemies killed by the wisps' tears have a 15% chance to drop a Rune/Soul Stone.
end

local function IsRune(card)
    local cardType = Isaac.GetItemConfig():GetCard(card)
    return cardType and cardType.CardType == ItemConfig.CARDTYPE_RUNE
end

function ShatteredSymbols:UseGeode(_, rng, player)
	local rune
	repeat
		rune = Game():GetItemPool():GetCard(rng:Next(), false, true, true)
	until IsRune(rune) and Isaac.GetItemConfig():GetCard(rune).IsRune
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

