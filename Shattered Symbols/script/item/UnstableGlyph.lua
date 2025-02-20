local game = Game()
local UnstableGlyphLocalID = Isaac.GetItemIdByName("Unstable Glyph")
local collectedItems = {}
local itemIgnoreList = {
    238, 239, 550, 551, 626, 627, 668
}

if EID then
    EID:addCollectible(UnstableGlyphLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{Collectible}} Reroll all items in the room into quality 4 items and triggers an explosion #{{BrokenHeart}} When you hold the item, after gaining Broken Heart, the item remove it for charging, every Broken Heart is equal to one charge #{{ArrowUp}} Unstable Glyph share charges with all Unstable Glyph of all players during the current game and next matches #{{ArrowDown}} If the absorbed Broken Hearts have replaced Hearts, these are not returned")
end

local function tablecontains(tbl, element)
    for _, value in ipairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

function ShatteredSymbols:havingUnstableGlyph(player)
    local SetterData = Isaac.GetPlayer(0)
    local data = SetterData:GetData()
    if not data.UnstableGlyphCharge then data.UnstableGlyphCharge = 0 end
    if not data.UnstableGlyphBrokenHearts then data.UnstableGlyphBrokenHearts = {} end

    if player:HasCollectible(UnstableGlyphLocalID) then

        for i = 0, 3 do -- Check all active item slots
            local activeItem = player:GetActiveItem(i)

            if activeItem ~= 0 and activeItem == UnstableGlyphLocalID then
                if data.UnstableGlyphBrokenHearts == {} then
                    for i = 0, game:GetNumPlayers() - 1 do
                        local selected = game:GetPlayer(i)
                        local selectedData = selected:GetData()
                        table.insert(data.UnstableGlyphBrokenHearts, selected:GetBrokenHearts())
                    end
                else
                    if data.UnstableGlyphCharge >= 7 then
                        data.UnstableGlyphCharge = 7
                    else
                        for i = 0, game:GetNumPlayers() - 1 do
                            local selected = game:GetPlayer(i)
                            local previousBroken = data.UnstableGlyphBrokenHearts[i+1] or 0
                            local currentBroken = selected:GetBrokenHearts()
                            if previousBroken < currentBroken then
                                local difference = currentBroken - previousBroken
                                selected:AddBrokenHearts(-difference)
                                data.UnstableGlyphCharge = data.UnstableGlyphCharge + difference
                                if data.UnstableGlyphCharge > 7 then
                                    data.UnstableGlyphCharge = 7
                                end
                                SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE)
                            elseif previousBroken > currentBroken then
                                data.UnstableGlyphBrokenHearts[i+1] = currentBroken
                            end
                            
                        end
                    end
                    player:SetActiveCharge(data.UnstableGlyphCharge, i)
                end
            end
        end
    else
        data.UnstableGlyphBrokenHearts = {}
    end
        
end

function ShatteredSymbols:useUnstableGlyph(_, rng, player)
    local tier4ItemPool = {}
    local SetterData = Isaac.GetPlayer(0)
    local data = SetterData:GetData()
    if not data.UnstableGlyphCharge then data.UnstableGlyphCharge = 0 end
    
    if player:HasCollectible(UnstableGlyphLocalID) then
        if REPENTOGON then
            ItemOverlay.Show(Isaac.GetGiantBookIdByName("Glyph"), 0 , player)
        end

        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION, 0, player.Position, Vector.Zero, player)

        local entities = Isaac.GetRoomEntities();

        for i = 1, #Isaac.GetItemConfig():GetCollectibles() do
            local itemConfig = Isaac.GetItemConfig():GetCollectible(i)
            if itemConfig and itemConfig.Quality == 4 and not tablecontains(collectedItems, itemConfig.ID) and not tablecontains(itemIgnoreList, itemConfig.ID) then
                table.insert(tier4ItemPool, i)
            end    
        end

        for _, entity in ipairs(entities) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SubType ~= 0 and entity.SubType ~= 668 then

                local currentItemQuality = Isaac.GetItemConfig():GetCollectible(entity.SubType)
                local randomCollectibleID = 0
                if currentItemQuality and currentItemQuality.Quality <= 4 then
                    if #tier4ItemPool == 0 then
                    else
                        local randomIndex = math.random(#tier4ItemPool)
                        randomCollectibleID = tier4ItemPool[randomIndex]
                        table.remove(tier4ItemPool, randomIndex)
                    end 
                end

                if randomCollectibleID == 0 then
                    entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Isaac.GetItemIdByName("Breakfast"), true)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, entity.Position, entity.Velocity, nil)    
                else
                    entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, randomCollectibleID, true)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, entity.Position, entity.Velocity, nil)
                end 
            end
        end
        
        data.UnstableGlyphCharge = 0
    end

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end


function ShatteredSymbols:GlyphWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(UnstableGlyphLocalID) then
		if wisp.SubType == UnstableGlyphLocalID then
			wisp.SubType = 263
		end
	end
end

function ShatteredSymbols:AddItemToListUnstableGlyph(pickup)
    if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and pickup.SubType ~= 0 and pickup.SubType ~= 668 then
        local itemID = pickup.SubType
        table.insert(collectedItems, itemID)
    end
end

function ShatteredSymbols:ClearListUnstableGlyph()
    collectedItems = {}
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.GlyphWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.havingUnstableGlyph)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useUnstableGlyph, UnstableGlyphLocalID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ShatteredSymbols.AddItemToListUnstableGlyph)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ShatteredSymbols.ClearListUnstableGlyph)

