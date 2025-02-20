local game = Game()

if EID then
    EID:createTransformation("Runic", "Runic")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_CLEAR_RUNE, 5, "Runic")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_RUNE_BAG, 5, "Runic")
    EID:assignTransformation(CollectibleType.COLLECTIBLE_MOMS_RING, 5, "Runic")
end

-- Lista degli oggetti che compongono l'evoluzione
local RUNIC_ITEMS = {
    CollectibleType.COLLECTIBLE_CLEAR_RUNE,
    CollectibleType.COLLECTIBLE_RUNE_BAG,
    CollectibleType.COLLECTIBLE_MOMS_RING
}


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
            player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
        end
    end
end

-- Assegna le funzioni agli eventi
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, ShatteredSymbols.RunicTransformation)
