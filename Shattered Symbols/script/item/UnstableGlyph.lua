local game = Game()
local UnstableGlyphLocalID = Isaac.GetItemIdByName("Unstable Glyph")
local collectedItems = {}
local itemIgnoreList = {
    238, 239, 550, 551, 626, 627, 668
}

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(UnstableGlyphLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{Collectible}} Rerolls all items in the room into Quality 4 items and triggers an explosion, granting: #{{GoldenBomb}} Golden Bomb #{{GoldenKey}} Golden Key #{{BrokenHeart}} While holding this item, each Broken Heart gained is consumed to charge it; one Broken Heart equals one charge. #{{Battery}} Shares charges with all Unstable Glyphs across players and runs.")
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
    if not data.UnstableGlyphHeartsTracking then data.UnstableGlyphHeartsTracking = {} end

    if player:HasCollectible(UnstableGlyphLocalID) then

        for i = 0, 3 do -- Check all active item slots
            local activeItem = player:GetActiveItem(i)

            if activeItem ~= 0 and activeItem == UnstableGlyphLocalID then

                if next(data.UnstableGlyphHeartsTracking) == nil then

                    for i = 0, game:GetNumPlayers() - 1 do

                        local selected = game:GetPlayer(i)
                        table.insert(data.UnstableGlyphHeartsTracking, {red = selected:GetMaxHearts(), bone = selected:GetBoneHearts(), soul = selected:GetSoulHearts(), black = selected:GetBlackHearts()})

                    end

                end
                
                if next(data.UnstableGlyphBrokenHearts) == nil then

                    for i = 0, game:GetNumPlayers() - 1 do

                        local selected = game:GetPlayer(i)
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

                                if difference > 7 - data.UnstableGlyphCharge then
                                    difference = 7 - data.UnstableGlyphCharge
                                end

                                selected:AddBrokenHearts(-difference)
                                data.UnstableGlyphCharge = data.UnstableGlyphCharge + difference

                                local currentRed = selected:GetMaxHearts()
                                local currentBone = selected:GetBoneHearts()
                                local currentSoul = selected:GetSoulHearts()
                                local currentBlack = selected:GetBlackHearts()

                                for j = 1, difference do
                                    if currentRed < data.UnstableGlyphHeartsTracking[i+1].red then
                                        selected:AddMaxHearts(2)
                                        selected:AddHearts(2)
                                    elseif currentBone < data.UnstableGlyphHeartsTracking[i+1].bone then
                                        selected:AddBoneHearts(1)
                                    elseif currentSoul < data.UnstableGlyphHeartsTracking[i+1].soul then
                                        selected:AddSoulHearts(2)
                                    elseif currentBlack < data.UnstableGlyphHeartsTracking[i+1].black then
                                        selected:AddBlackHearts(2)
                                    end
                                    currentRed = selected:GetMaxHearts()
                                    currentBone = selected:GetBoneHearts()
                                    currentSoul = selected:GetSoulHearts()
                                    currentBlack = selected:GetBlackHearts()
                                end

                                if data.UnstableGlyphCharge > 7 then
                                    data.UnstableGlyphCharge = 7
                                end

                                SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE)


                            elseif previousBroken > currentBroken then

                                data.UnstableGlyphBrokenHearts[i+1] = currentBroken

                            end

                            data.UnstableGlyphHeartsTracking[i+1] = {red = selected:GetMaxHearts(), bone = selected:GetBoneHearts(), soul = selected:GetSoulHearts(), black = selected:GetBlackHearts()}
                        
                        end
                    end
                    player:SetActiveCharge(data.UnstableGlyphCharge, i)
                end
            end
        end

    else
        local someoneHaveGlyph = false
        for i = 0, game:GetNumPlayers() - 1 do
            local selected = game:GetPlayer(i)
            if selected:HasCollectible(UnstableGlyphLocalID) then
                someoneHaveGlyph = true
            end
        end

        if someoneHaveGlyph == false then
            data.UnstableGlyphHeartsTracking = {}
            data.UnstableGlyphBrokenHearts = {}
        end

    end
        
end

function ShatteredSymbols:useUnstableGlyph(_, rng, player)
    local tier4ItemPool = {}
    local SetterData = Isaac.GetPlayer(0)
    local data = SetterData:GetData()
    if not data.UnstableGlyphCharge then data.UnstableGlyphCharge = 0 end
    if not data.UnstableGlyphBrokenHearts then data.UnstableGlyphBrokenHearts = {} end
    if not data.UnstableGlyphHeartsTracking then data.UnstableGlyphHeartsTracking = {} end
    
    if player:HasCollectible(UnstableGlyphLocalID) then
        if REPENTOGON then
            ItemOverlay.Show(Isaac.GetGiantBookIdByName("Glyph"), 0 , player)
        end
        
        SFXManager():Play(SoundEffect.SOUND_STATIC)
        local room = game:GetRoom()
        room:MamaMegaExplosion(player.Position)

        player:AddGoldenKey()  -- Golden Key
        player:AddGoldenBomb() -- Golden Bomb 
        SFXManager():Play(SoundEffect.SOUND_GOLDENKEY)
        
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

