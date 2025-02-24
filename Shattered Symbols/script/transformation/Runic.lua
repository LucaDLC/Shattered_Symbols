local game = Game()

-- Lista degli oggetti che compongono l'evoluzione
local RUNIC_ITEMS = {
    CollectibleType.COLLECTIBLE_CLEAR_RUNE,
    CollectibleType.COLLECTIBLE_RUNE_BAG,
    Isaac.GetItemIdByName("Runic Geode"),
    Isaac.GetItemIdByName("Runic Altar"),
    Isaac.GetItemIdByName("Unstable Glyph")
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

function ShatteredSymbols:RunicTransformation(player)
    local data = player:GetData()
    if not data.RunicTransformation then data.RunicTransformation = false end
    if not data.RunicTransformation and HasRunicEvolution(player) then
        Game():GetHUD():ShowItemText("Runic!")
        SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
        player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
        data.RunicTransformation = true
        player:EvaluateItems()
    elseif data.RunicTransformation and not HasRunicEvolution(player) then
        player.TearFlags = player.TearFlags & ~TearFlags.TEAR_HOMING
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
        data.RunicTransformation = false
        player:EvaluateItems()
    end
        
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.RunicTransformation)