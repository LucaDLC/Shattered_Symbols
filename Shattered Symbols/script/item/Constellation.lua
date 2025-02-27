local game = Game()
local ConstellationLocalID = Isaac.GetItemIdByName("Constellation")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(ConstellationLocalID, "{{Warning}} SINGLE USE {{Warning}}#Spawns a random item from Planetarium Pool or Zodiac Signs")
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

local planetarium_items = {
    CollectibleType.COLLECTIBLE_NEPTUNUS,
    CollectibleType.COLLECTIBLE_TERRA,
    CollectibleType.COLLECTIBLE_URANUS,
    CollectibleType.COLLECTIBLE_VENUS,
    CollectibleType.COLLECTIBLE_MARS,
    CollectibleType.COLLECTIBLE_JUPITER,
    CollectibleType.COLLECTIBLE_PLUTO,
    CollectibleType.COLLECTIBLE_MERCURIUS,
    CollectibleType.COLLECTIBLE_SOL,
    CollectibleType.COLLECTIBLE_SATURNUS,
    CollectibleType.COLLECTIBLE_LUNA,
    Isaac.GetItemIdByName("Meteor")
}

local Constellation_Table = {}


function ShatteredSymbols:useConstellation(_, rng, player)
    
    Constellation_Table = {}
    for _, v in pairs(zodiac_items) do
        table.insert(Constellation_Table, v)
    end
    for _, v in pairs(planetarium_items) do
        table.insert(Constellation_Table, v)
    end
    
    local selectedItem = Constellation_Table[rng:RandomInt(#Constellation_Table) + 1]


    local spawnPosition = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, selectedItem, spawnPosition, Vector(0, 0), nil)
    
    SFXManager():Play(SoundEffect.SOUND_ANGEL_BEAM)

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function ShatteredSymbols:onGameStartConstellation()
    local Constellation_Table = {}
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
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ShatteredSymbols.onGameStartConstellation)


