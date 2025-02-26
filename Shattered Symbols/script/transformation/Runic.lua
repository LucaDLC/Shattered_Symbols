local game = Game()

local RUNIC_ITEMS = {
    CollectibleType.COLLECTIBLE_CLEAR_RUNE,
    CollectibleType.COLLECTIBLE_RUNE_BAG,
    Isaac.GetItemIdByName("Runic Geode"),
    Isaac.GetItemIdByName("Runic Altar"),
    Isaac.GetItemIdByName("Unstable Glyph")
}

-- EID (External Item Descriptions)
if EID then
    EID:createTransformation("RunicShattered", "Runic")
    for _, item in ipairs(RUNIC_ITEMS) do
        EID:assignTransformation("collectible", item, "RunicShattered")
    end
end

function table.contains(table, element)
    if not table or #table == 0 then
        return false
    end
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function HasRunicTransformation(player)
    local count = 0
    local data = player:GetData()
    for _, item in ipairs(RUNIC_ITEMS) do
        if player:HasCollectible(item) or table.contains(data.CapturedActiveItems, item) then
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
  
    if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 and not table.contains(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)) then
        table.insert(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_PRIMARY))
    end
    if player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) ~= 0 and not table.contains(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)) then
        table.insert(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_SECONDARY))
    end
    if player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= 0 and not table.contains(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_POCKET)) then
        table.insert(data.CapturedActiveItems, player:GetActiveItem(ActiveSlot.SLOT_POCKET))
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