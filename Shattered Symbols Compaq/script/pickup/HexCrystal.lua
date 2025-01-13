local game = Game()
local HexCrystalLocalID = Isaac.GetCardIdByName("Hex Crystal")

if EID then
    EID:addCard(HexCrystalLocalID, "Adds effects at the enemy in the room: #{{BleedingOut}} Bleeding Out #{{Weakness}} Weakness ")
end

-- Callback per quando il giocatore usa una runa
function ShatteredSymbols:useHexCrystal(card, player, useFlags)
    if REPENTOGON then
		ItemOverlay.Show(Isaac.GetGiantBookIdByName("Hex"), 0 , player)
    end
    local room = game:GetRoom()
    local entities = Isaac.GetRoomEntities()

    for _, entity in ipairs(entities) do
        if entity:IsActiveEnemy(false) then
            -- Applica lo stato BleedingOut
            entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)

            -- Applica lo stato Weakness
            entity:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
        end
    end
    player:AddBrokenHearts(1)
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.useHexCrystal, HexCrystalLocalID)