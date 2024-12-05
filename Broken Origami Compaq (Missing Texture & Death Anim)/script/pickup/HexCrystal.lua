local game = Game()
local HexCrystalLocalID = Isaac.GetCardIdByName("Hex Crystal")

if EID then
    EID:addCard(HexCrystalLocalID, "Adds effects at the enemy in the room: #{{Slow}} Slow for 5 seconds #{{Confusion}} Confusion for 5 seconds #{{Burning}} Burning for 5 seconds #{{BleedingOut}} Bleeding Out permanently #{{Weakness}} Weakness permanently")
end

-- Callback per quando il giocatore usa una runa
function BrokenOrigami:useHexCrystal(card, player, useFlags)
    local room = game:GetRoom()
    local entities = Isaac.GetRoomEntities()

    for _, entity in ipairs(entities) do
        if entity:IsActiveEnemy(false) then
            -- Applica lo stato Slow
            entity:AddSlowing(EntityRef(player), 150, 0.5, Color(0.5, 0.5, 1, 1, 0, 0, 0)) -- 150 frame = 5 secondi

            -- Applica lo stato Confusion
            entity:AddConfusion(EntityRef(player), 150, false)

            -- Applica lo stato Burning
            entity:AddBurn(EntityRef(player), 150, player.Damage)

            -- Applica lo stato BleedingOut
            entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)

            -- Applica lo stato Weakness
            entity:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
        end
    end
    player:AddBrokenHearts(1)
end

BrokenOrigami:AddCallback(ModCallbacks.MC_USE_CARD, BrokenOrigami.useHexCrystal, HexCrystalLocalID)