local game = Game()

-- Lista degli oggetti che compongono l'evoluzione
local CLAIRVOYANT_ITEMS = {
    CollectibleType.COLLECTIBLE_DECK_OF_CARDS,
    CollectibleType.COLLECTIBLE_BOOSTER_PACK,
    CollectibleType.COLLECTIBLE_STARTER_DECK,
    CollectibleType.COLLECTIBLE_TAROT_CLOTH,
    CollectibleType.COLLECTIBLE_BLANK_CARD,
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL
}

if EID then
    EID:createTransformation("ClairvoyantShattered", "Clairvoyant")
    for _, item in ipairs(CLAIRVOYANT_ITEMS) then
        EID:assignTransformation("collectible", item, "ClairvoyantShattered")
    end
end

-- Funzione per contare quanti oggetti Clairvoyant possiede il giocatore
local function HasClairvoyantTransformation(player)
    local count = 0
    for _, item in ipairs(CLAIRVOYANT_ITEMS) do
        if player:HasCollectible(item) then
            count = count + 1
        end
    end
    return count >= 3
end

-- Evento di inizio transizione tra i piani
function ShatteredSymbols:ClairvoyantTransformation()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if HasClairvoyantTransformation(player) then
            Game():GetHUD():ShowItemText("Clairvoyant!")
            SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
            game:ShowHallucination(2, BackdropType.NUM_BACKDROPS)
            player:AddSoulHearts(1)
        end
    end
end

-- Assegna le funzioni agli eventi
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.ClairvoyantTransformation)
