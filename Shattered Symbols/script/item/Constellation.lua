local game = Game()
local ConstellationLocalID = Isaac.GetItemIdByName("Constellation")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(ConstellationLocalID, "{{Warning}} SINGLE USE {{Warning}}#{{Planetarium}} Spawns a random item from Planetarium Pool or Zodiac Signs")
end

local zodiac_items = {
    CollectibleType.COLLECTIBLE_ARIES,
    CollectibleType.COLLECTIBLE_TAURUS,
    CollectibleType.COLLECTIBLE_GEMINI,
    CollectibleType.COLLECTIBLE_CANCER,
    CollectibleType.COLLECTIBLE_LEO,
    CollectibleType.COLLECTIBLE_VIRGO,
    CollectibleType.COLLECTIBLE_LIBRA,
    CollectibleType.COLLECTIBLE_SCORPIO,
    CollectibleType.COLLECTIBLE_SAGITTARIUS,
    CollectibleType.COLLECTIBLE_CAPRICORN,
    CollectibleType.COLLECTIBLE_AQUARIUS,
    CollectibleType.COLLECTIBLE_PISCES,
    CollectibleType.COLLECTIBLE_ZODIAC
}


function ShatteredSymbols:useConstellation(_, rng, player)
    local selectedItem
    if rng:RandomFloat() < 0.5 then
        selectedItem = game:GetItemPool():GetCollectible(ItemPoolType.POOL_PLANETARIUM, false, rng:Next())
    else
        selectedItem = zodiac_items[rng:RandomInt(#zodiac_items) + 1]
    end


    local spawnPosition = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, selectedItem, spawnPosition, Vector(0, 0), nil)
    
    SFXManager():Play(SoundEffect.SOUND_ANGEL_BEAM)

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function ShatteredSymbols:ConstellationWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(ConstellationLocalID) then
		if wisp.SubType == ConstellationLocalID then
			wisp.SubType = 158
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.ConstellationWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useConstellation, ConstellationLocalID)


