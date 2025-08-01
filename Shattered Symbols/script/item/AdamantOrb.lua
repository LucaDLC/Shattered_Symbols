local game = Game()
local AdamantOrbLocalID = Isaac.GetItemIdByName("Adamant Orb")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(AdamantOrbLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{TimerSmall}} Restarts the game, keeping 50% of your passive items #{{BrokenHeart}} Each player's Broken Heart is set 1 which replaces Hearts in this order: {{Heart}}{{BoneHeart}}{{SoulHeart}}{{BlackHeart}}") 
end

local function shuffle(tbl, rng)
    for i = #tbl, 2, -1 do
        local j = rng:RandomInt(i) + 1
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
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

function ShatteredSymbols:useAdamantOrb(_, rng, player)
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local selectedPlayer = Isaac.GetPlayer(playerIndex)
        local data = selectedPlayer:GetData()
        local collectibles = Isaac.GetItemConfig()
        local keptItems = {}

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
            selectedPlayer:RemoveCollectible(keptItems[i])
        end

        local brokenHearts = selectedPlayer:GetBrokenHearts()
        selectedPlayer:AddBrokenHearts(-brokenHearts)
        BrokenHeartRemovingSystem(selectedPlayer)
        
    end
    
    Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY, UseFlag.USE_NOANIM)
    SFXManager():Play(Isaac.GetSoundIdByName("Time"))

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
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

