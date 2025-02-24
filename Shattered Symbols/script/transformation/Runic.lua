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
        if player:HasCollectible(item) or table.contains(player:GetData().CapturedActiveItems, item) then
            count = count + 1
        end
    end
    return count >= 3
end

function ShatteredSymbols:RunicTransformation(player)
    local data = player:GetData()
    if not data.RunicTransformation then data.RunicTransformation = false end
    if not data.CapturedActiveItems then data.CapturedActiveItems = {} end

    if not data.RunicTransformation and HasRunicTransformation(player) then
        data.RunicTransformation = true
        Game():GetHUD():ShowItemText("Runic!")
        SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
        player:EvaluateItems()
    elseif data.RunicTransformation and not HasRunicTransformation(player) then
        data.RunicTransformation = false
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
        player:EvaluateItems()
    end
  
    if player:GetActiveItem() > 0 and not table.contains(data.CapturedActiveItems, player:GetActiveItem()) then
        table.insert(data.CapturedActiveItems, player:GetActiveItem())
    end
    if GetSecondaryActiveItem() > 0 and not table.contains(data.CapturedActiveItems, GetSecondaryActiveItem()) then
        table.insert(data.CapturedActiveItems, GetSecondaryActiveItem())
    end
    if player:GetPocketItem() > 0 and not table.contains(data.CapturedActiveItems, player:GetPocketItem()) then
        table.insert(data.CapturedActiveItems, player:GetPocketItem())
    end
        
end

function ShatteredSymbols:OnCacheRunic(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_TEARFLAG then
        local data = player:GetData()
        if data.RunicTransformation then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
        end
    end
end

function ShatteredSymbols:OnTearRunic(tear)

    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()
        
        if data.RunicTransformation then
            tear:SetColor(Color(128/255, 0, 128/255, 1), 0, 0, false, false)
        else
            tear:SetColor(Color(1, 1, 1, 1), 0, 0, false, false)
        end
    end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, ShatteredSymbols.OnTearRunic)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.OnCacheRunic)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.RunicTransformation)