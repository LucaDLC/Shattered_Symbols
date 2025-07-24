local game = Game()
local AdamantOrbLocalID = Isaac.GetItemIdByName("Adamant Orb")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(AdamantOrbLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{TimerSmall}} Restart the game with 50% of Passive Item you hold #{{BrokenHeart}} Give 1 Broken Heart for the new run of each player which does not replace Heart")
end

function ShatteredSymbols:useAdamantOrb(_, rng, player)
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local selectedPlayer = Isaac.GetPlayer(playerIndex)
        local data = selectedPlayer:GetData()
        local collectibles = Isaac.GetItemConfig()
        local keptItems = {}

        if not data.AdamantOrbItems then data.AdamantOrbItems = {} end
        if not data.AdamantOrbRestarted then data.AdamantOrbRestarted = false end

        -- Raccoglie tutti gli oggetti passivi
        for i = 1, CollectibleType.NUM_COLLECTIBLES - 1 do
            local count = selectedPlayer:GetCollectibleNum(i, false)
            if count > 0 and collectibles:GetCollectible(i).Type == ItemType.ITEM_PASSIVE then
                table.insert(keptItems, { id = i, count = count })
            end
        end

        local half = math.floor(#keptItems / 2)
        
        RNG.Shuffle(keptItems)
        
        for i = 1, half do
            table.insert(data.AdamantOrbItems, keptItems[i])
        end
    
        data.AdamantOrbRestarted = true

    end
    
        ShatteredSymbols:SavePlayerData()
        Game():StartNewGame()
    
        return {
            Discharge = true,
            Remove = true,
            ShowAnim = true
    }
end

function AdamantOrb:adamantPostPlayerInit(player)
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local selectedPlayer = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()

        if not data.AdamantOrbItems then data.AdamantOrbItems = {} end
        if not data.AdamantOrbRestarted then data.AdamantOrbRestarted = false end

        if data.AdamantOrbRestarted then
            for _, itemData in ipairs(data.AdamantOrbItems) do
                for _ = 1, itemData.count do
                    player:AddCollectible(itemData.id, 0, false)
                end
            end
            data.AdamantOrbItems = {}
            data.AdamantOrbRestarted = false
            player:AddBrokenHearts(1)
        end
    end
end

function ShatteredSymbols:AdamantOrbWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(AdamantOrbLocalID) then
		if wisp.SubType == AdamantOrbLocalID then
			wisp.SubType = 636
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.AdamantOrbWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useAdamantOrb, AdamantOrbLocalID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, ShatteredSymbols.adamantPostPlayerInit)


