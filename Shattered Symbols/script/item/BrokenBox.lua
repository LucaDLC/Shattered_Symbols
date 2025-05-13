local game = Game()
local BrokenBoxLocalID = Isaac.GetItemIdByName("Broken Box")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(BrokenBoxLocalID, "{{Warning}} SINGLE USE {{Warning}} #If empty, the box takes up to maximum of: #{{BrokenHeart}} 1 Broken Heart #{{Collectible}} 1 Item #{{Coin}} 15 Coins #{{Bomb}} 3 Bombs #{{Key}} 3 Keys #If full, the box gives you everything it took before #{{ArrowDown}} If you don't have nothing to take, the box vanish and it's considered like empty")
end


function ShatteredSymbols:useBrokenBox(_, rng, player)
    local SetterData = Isaac.GetPlayer(0)
    local data = SetterData:GetData()
    
    -- Inizializza i flag se non già impostati
    if data.BrokenBoxHeartFlag == nil then data.BrokenBoxHeartFlag = false end
    if data.BrokenBoxItemFlag == nil then data.BrokenBoxItemFlag = nil end
    if data.BrokenBoxMoneyFlag == nil then data.BrokenBoxMoneyFlag = 0 end
    if data.BrokenBoxBombFlag == nil then data.BrokenBoxBombFlag = 0 end
    if data.BrokenBoxKeyFlag == nil then data.BrokenBoxKeyFlag = 0 end
    if data.BrokenBoxStatus == nil then data.BrokenBoxStatus = false end

    -- Empty Box
    if player:HasCollectible(BrokenBoxLocalID) and not data.BrokenBoxStatus then
        if player:GetBrokenHearts() > 0 then
            player:AddBrokenHearts(-1)
            data.BrokenBoxHeartFlag = true
        end

        local collectibles = {}
        for i = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
            if player:HasCollectible(i) and i ~= BrokenBoxLocalID then
                table.insert(collectibles, i)
            end
        end

        if #collectibles > 0 then
            data.BrokenBoxItemFlag = collectibles[rng:RandomInt(#collectibles) + 1]
            player:RemoveCollectible(data.BrokenBoxItemFlag)
        end

        collectibles = {}
        
        data.BrokenBoxMoneyFlag = math.min(player:GetNumCoins(), 15)
        player:AddCoins(-data.BrokenBoxMoneyFlag)

        data.BrokenBoxBombFlag = math.min(player:GetNumBombs(), 3)
        player:AddBombs(-data.BrokenBoxBombFlag)

        data.BrokenBoxKeyFlag = math.min(player:GetNumKeys(), 3)
        player:AddKeys(-data.BrokenBoxKeyFlag)

        if data.BrokenBoxItemFlag ~= nil or data.BrokenBoxMoneyFlag > 0 or data.BrokenBoxBombFlag > 0 or data.BrokenBoxKeyFlag > 0 then
            data.BrokenBoxStatus = true  
        else
            data.BrokenBoxStatus = false
        end

        SFXManager():Play(SoundEffect.SOUND_DOOR_HEAVY_CLOSE)

    -- Full Box
    elseif player:HasCollectible(BrokenBoxLocalID) and data.BrokenBoxStatus then
        if data.BrokenBoxHeartFlag then
            player:AddBrokenHearts(1)
            data.BrokenBoxHeartFlag = false
        end

        if data.BrokenBoxItemFlag ~= nil then
            if Isaac.GetItemConfig():GetCollectibles().Size - 1 >= data.BrokenBoxItemFlag then
                player:AddCollectible(data.BrokenBoxItemFlag)
            else
                player:AddCollectible(rng:RandomInt(Isaac.GetItemConfig():GetCollectibles().Size - 1) + 1)
            end
            data.BrokenBoxItemFlag = nil
        end

        if data.BrokenBoxMoneyFlag > 0 then
            player:AddCoins(data.BrokenBoxMoneyFlag)
            data.BrokenBoxMoneyFlag = 0
        end

        if data.BrokenBoxBombFlag > 0 then
            player:AddBombs(data.BrokenBoxBombFlag)
            data.BrokenBoxBombFlag = 0
        end

        if data.BrokenBoxKeyFlag > 0 then
            player:AddKeys(data.BrokenBoxKeyFlag)
            data.BrokenBoxKeyFlag = 0
        end

        data.BrokenBoxStatus = false  
    end

    SFXManager():Play(SoundEffect.SOUND_DOOR_HEAVY_OPEN)

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function ShatteredSymbols:BoxWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(BrokenBoxLocalID) then
		if wisp.SubType == BrokenBoxLocalID then
			wisp.SubType = 719
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useBrokenBox, BrokenBoxLocalID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.BoxWispInit, FamiliarVariant.WISP)

