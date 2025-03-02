local game = Game()
local HexCrystalLocalID = Isaac.GetCardIdByName("Hex Crystal")

-- EID (External Item Descriptions)
if EID then
    EID:addCard(HexCrystalLocalID, "Adds effects at the enemy in the room: #{{BleedingOut}} Bleeding Out #{{Weakness}} Weakness ")
end


function ShatteredSymbols:useHexCrystal(card, player, useFlags)
    if REPENTOGON then
		ItemOverlay.Show(Isaac.GetGiantBookIdByName("Hex"), 0 , player)
    end
    local room = game:GetRoom()
    local entities = Isaac.GetRoomEntities()

    for _, entity in ipairs(entities) do
        if entity:IsActiveEnemy(false) then
            -- Bleeding Out
            entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)

            -- Weakness
            entity:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
        end
    end
    player:AddBrokenHearts(1)
    SFXManager():Play(SoundEffect.SOUND_ANGEL_BEAM)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, player.Position, Vector(0,0), player)
    for i = 1, 30 do 
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DIAMOND_PARTICLE, 0, player.Position + Vector(0, -15) , Vector(0,0), player)
    end
    
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.useHexCrystal, HexCrystalLocalID)