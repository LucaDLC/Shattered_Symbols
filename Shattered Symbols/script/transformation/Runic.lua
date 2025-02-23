local game = Game()

-- Lista degli oggetti che compongono l'evoluzione
local RUNIC_ITEMS = {
    CollectibleType.COLLECTIBLE_CLEAR_RUNE,
    CollectibleType.COLLECTIBLE_RUNE_BAG,
    CollectibleType.COLLECTIBLE_MOMS_RING,
    Isaac.GetItemIdByName("Runic Geode"),
    Isaac.GetItemIdByName("Runic Altar"),
    Isaac.GetItemIdByName("Unstable Glyph"),
    Isaac.GetItemIdByName("Onyx")
}

if EID then
    EID:createTransformation("RunicShattered", "Runic")
    for _, item in ipairs(RUNIC_ITEMS) do
        EID:assignTransformation("collectible", item, "RunicShattered")
    end
end

local function HasRunicTransformation(player)
    local count = 0
    for _, item in ipairs(RUNIC_ITEMS) do
        if player:HasCollectible(item) then
            count = count + 1
        end
    end
    return count >= 3
end

-- Evento di inizio transizione tra i piani
function ShatteredSymbols:RunicTransformation()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if HasRunicTransformation(player) then
            Game():GetHUD():ShowItemText("Runic!")
            SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
            player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
        end
    end
end

-- Assegna le funzioni agli eventi
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, ShatteredSymbols.RunicTransformation)
