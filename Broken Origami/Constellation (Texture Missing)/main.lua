-- Inizializza la mod
local constellation = RegisterMod("Constellation", 1)
local game = Game()
local constellationId = Isaac.GetItemIdByName("Constellation")

--EID
if EID then
    EID:addCollectible(constellationId, "{{Warning}} SINGLE USE {{Warning}}#Spawns a random item from planetarium pool or zodiac signs")
end

-- Liste degli oggetti zodiacali e del planetario
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
    CollectibleType.COLLECTIBLE_LUNA
}

local Fortune_Teller_Table = {}

-- Funzione per gestire l'uso dell'oggetto "Fortune Teller"
function constellation:onUseconstellation(_, rng, player)
    -- Svuota la tabella ogni volta che l'oggetto viene usato
    Fortune_Teller_Table = {}
    for _, v in pairs(zodiac_items) do
        table.insert(Fortune_Teller_Table, v)
    end
    for _, v in pairs(planetarium_items) do
        table.insert(Fortune_Teller_Table, v)
    end
    -- Scegli un oggetto casuale dalla lista combinata
    local selectedItem = Fortune_Teller_Table[rng:RandomInt(#Fortune_Teller_Table) + 1]

    -- Spawna l'oggetto scelto nella stanza
    local spawnPosition = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, selectedItem, spawnPosition, Vector(0, 0), nil)
    

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

-- Funzione di inizializzazione della mod
function constellation:OnGameStart()
    local Fortune_Teller_Table = {}
end

constellation:AddCallback(ModCallbacks.MC_USE_ITEM, constellation.onUseconstellation, constellationId)
constellation:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, constellation.OnGameStart)


