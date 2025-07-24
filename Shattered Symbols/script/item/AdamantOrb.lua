local game = Game()
local AdamantOrbLocalID = Isaac.GetItemIdByName("Adamant Orb")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(AdamantOrbLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{TimerSmall}} Restart the game with 50% of Passive Item you hold #{{BrokenHeart}} Give 1 Broken Heart for the new run of each player which does not replace Heart")
end

local function shuffle(tbl, rng)
    for i = #tbl, 2, -1 do
        local j = rng:RandomInt(i) + 1
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

function ShatteredSymbols:useAdamantOrb(_, rng, player)
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local selectedPlayer = Isaac.GetPlayer(playerIndex)
        local data = selectedPlayer:GetData()
        local collectibles = Isaac.GetItemConfig()
        local keptItems = {}

        if not data.AdamantOrbItems then data.AdamantOrbItems = {} end
        if not data.AdamantOrbRestarted then data.AdamantOrbRestarted = false end

        for i = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
            local cfg = Isaac.GetItemConfig():GetCollectible(i)
            if selectedPlayer:HasCollectible(i) and cfg.Type == ItemType.ITEM_PASSIVE then
                table.insert(keptItems, i)
            end
        end

        local half = math.floor(#keptItems / 2)
        
        rng:SetSeed(Random(), 1)
        shuffle(keptItems, rng)
        
        for i = 1, half do
            table.insert(data.AdamantOrbItems, keptItems[i])
        end
    
        data.AdamantOrbRestarted = true

    end
    
    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function ShatteredSymbols:adamantPostPlayerInit()

    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()

        if not data.AdamantOrbItems then data.AdamantOrbItems = {} end
        if not data.AdamantOrbRestarted then data.AdamantOrbRestarted = false end

        if data.AdamantOrbRestarted then

            for _, itemData in ipairs(data.AdamantOrbItems) do
                player:AddCollectible(itemData)
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
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.adamantPostPlayerInit)


