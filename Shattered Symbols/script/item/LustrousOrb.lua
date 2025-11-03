local game = Game()
local LustrousOrbLocalID = Isaac.GetItemIdByName("Lustrous Orb")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(LustrousOrbLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{CurseMazeSmall}} Shuffles all gained passive items between Players #{{BrokenHeart}} Removes 1 Broken Heart to each player")
end

function ShatteredSymbols:useLustrousOrb(_, rng, player)
    
    local allItems = {}
    local playerCount = game:GetNumPlayers()

    for i = 0, playerCount - 1 do
        local p = Isaac.GetPlayer(i)
        for itemID = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
            local cfg = Isaac.GetItemConfig():GetCollectible(itemID)
            if cfg and cfg.Type == ItemType.ITEM_PASSIVE then
                local count = p:GetCollectibleNum(itemID, false)
                for j = 1, count do
                    table.insert(allItems, itemID)
                    p:RemoveCollectible(itemID, true)
                end
            end
        end
    end

    for i = #allItems, 2, -1 do
        local j = math.random(i)
        allItems[i], allItems[j] = allItems[j], allItems[i]
    end

    local distribuzione = {}
    for i = 0, playerCount - 1 do
        distribuzione[i] = {}
    end

    for i, itemID in ipairs(allItems) do
        local playerIndex = (i - 1) % playerCount
        table.insert(distribuzione[playerIndex], itemID)
    end

    -- Dai gli oggetti redistribuiti
    for i = 0, playerCount - 1 do
        local p = Isaac.GetPlayer(i)
        for _, itemID in ipairs(distribuzione[i]) do
            p:AddCollectible(itemID, 0, true)
        end
        if p:GetBrokenHearts() > 0 then
            p:AddBrokenHearts(-1)
        end
    end

    SFXManager():Play(Isaac.GetSoundIdByName("Space"))

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function ShatteredSymbols:LustrousOrbWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(LustrousOrbLocalID) then
		if wisp.SubType == LustrousOrbLocalID then
			wisp.SubType = 127
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.LustrousOrbWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useLustrousOrb, LustrousOrbLocalID)


