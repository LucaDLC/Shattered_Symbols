local game = Game()
local HexCrystalLocalID = Isaac.GetCardIdByName("Hex Crystal")

-- EID (External Item Descriptions)
if EID then
    EID:addCard(HexCrystalLocalID, "{{BrokenHeart}} Gives 1 Broken Heart which replaces Hearts in this order {{Heart}}{{BoneHeart}}{{SoulHeart}}{{BlackHeart}} #{{ArrowUp}} Inflicts permanently the following effects to the enemies in the room: #{{BleedingOut}} Bleeding Out #{{Weakness}} Weakness ")
end

local function BrokenHeartRemovingSystem(player)
    local slotRemoved = false

    if player:GetMaxHearts() >= 2 and not slotRemoved then
        player:AddMaxHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBoneHearts() >= 1 then
        player:AddBoneHearts(-1) 
        slotRemoved = true
    end

    if not slotRemoved and player:GetSoulHearts() >= 2 then
        player:AddSoulHearts(-2)  
        slotRemoved = true
    end

    if not slotRemoved and player:GetBlackHearts() >= 2 then
        player:AddBlackHearts(-2)  
        slotRemoved = true
    end

    player:AddBrokenHearts(1)

end

function ShatteredSymbols:useHexCrystal(card, player, useFlags)
    if REPENTOGON then
		--ItemOverlay.Show(Isaac.GetGiantBookIdByName("Hex"), 0 , player)
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
    BrokenHeartRemovingSystem(player)
    SFXManager():Play(SoundEffect.SOUND_ANGEL_BEAM)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, player.Position, Vector(0,0), player)
    for i = 1, 30 do 
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DIAMOND_PARTICLE, 0, player.Position + Vector(0, -15) , Vector(0,0), player)
    end
    
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.useHexCrystal, HexCrystalLocalID)