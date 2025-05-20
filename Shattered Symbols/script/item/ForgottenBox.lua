local game = Game()
local ForgottenBoxLocalID = Isaac.GetItemIdByName("Forgotten Box")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(ForgottenBoxLocalID, "{{Warning}} SINGLE USE {{Warning}} #If empty, the box takes up to maximum of: #{{BrokenHeart}} 1 Broken Heart #{{Collectible}} 1 Item #{{Coin}} 15 Coins #{{Bomb}} 3 Bombs #{{Key}} 3 Keys #{{ArrowDown}} If you don't have nothing to take, the box vanish and it's considered like empty #If full, the box gives you everything it took before")
end


function ShatteredSymbols:useForgottenBox(_, rng, player)
    local SetterData = Isaac.GetPlayer(0)
    local data = SetterData:GetData()
    
    if data.ForgottenBoxHeartFlag == nil then data.ForgottenBoxHeartFlag = false end
    if data.ForgottenBoxItemFlag == nil then data.ForgottenBoxItemFlag = nil end
    if data.ForgottenBoxMoneyFlag == nil then data.ForgottenBoxMoneyFlag = 0 end
    if data.ForgottenBoxBombFlag == nil then data.ForgottenBoxBombFlag = 0 end
    if data.ForgottenBoxKeyFlag == nil then data.ForgottenBoxKeyFlag = 0 end
    if data.ForgottenBoxStatus == nil then data.ForgottenBoxStatus = false end

    -- Empty Box
    if player:HasCollectible(ForgottenBoxLocalID) and not data.ForgottenBoxStatus then
        if player:GetBrokenHearts() > 0 then
            player:AddBrokenHearts(-1)
            data.ForgottenBoxHeartFlag = true
        end

        local collectibles = {}
        for i = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
            if player:HasCollectible(i) and i ~= ForgottenBoxLocalID then
                table.insert(collectibles, i)
            end
        end

        if #collectibles > 0 then
            data.ForgottenBoxItemFlag = collectibles[rng:RandomInt(#collectibles) + 1]
            player:RemoveCollectible(data.ForgottenBoxItemFlag)
        end

        collectibles = {}
        
        data.ForgottenBoxMoneyFlag = math.min(player:GetNumCoins(), 15)
        player:AddCoins(-data.ForgottenBoxMoneyFlag)

        data.ForgottenBoxBombFlag = math.min(player:GetNumBombs(), 3)
        player:AddBombs(-data.ForgottenBoxBombFlag)

        data.ForgottenBoxKeyFlag = math.min(player:GetNumKeys(), 3)
        player:AddKeys(-data.ForgottenBoxKeyFlag)

        if data.ForgottenBoxItemFlag ~= nil or data.ForgottenBoxMoneyFlag > 0 or data.ForgottenBoxBombFlag > 0 or data.ForgottenBoxKeyFlag > 0 then
            data.ForgottenBoxStatus = true  
        else
            data.ForgottenBoxStatus = false
        end

        SFXManager():Play(SoundEffect.SOUND_DOOR_HEAVY_CLOSE)

    -- Full Box
    elseif player:HasCollectible(ForgottenBoxLocalID) and data.ForgottenBoxStatus then
        if data.ForgottenBoxHeartFlag then
            player:AddBrokenHearts(1)
            data.ForgottenBoxHeartFlag = false
        end

        if data.ForgottenBoxItemFlag ~= nil then
            if Isaac.GetItemConfig():GetCollectibles().Size - 1 >= data.ForgottenBoxItemFlag then
                player:AddCollectible(data.ForgottenBoxItemFlag)
            else
                player:AddCollectible(rng:RandomInt(Isaac.GetItemConfig():GetCollectibles().Size - 1) + 1)
            end
            data.ForgottenBoxItemFlag = nil
        end

        if data.ForgottenBoxMoneyFlag > 0 then
            player:AddCoins(data.ForgottenBoxMoneyFlag)
            data.ForgottenBoxMoneyFlag = 0
        end

        if data.ForgottenBoxBombFlag > 0 then
            player:AddBombs(data.ForgottenBoxBombFlag)
            data.ForgottenBoxBombFlag = 0
        end

        if data.ForgottenBoxKeyFlag > 0 then
            player:AddKeys(data.ForgottenBoxKeyFlag)
            data.ForgottenBoxKeyFlag = 0
        end

        data.ForgottenBoxStatus = false  
    end

    SFXManager():Play(SoundEffect.SOUND_DOOR_HEAVY_OPEN)

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

function ShatteredSymbols:BoxWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(ForgottenBoxLocalID) then
		if wisp.SubType == ForgottenBoxLocalID then
			wisp.SubType = 719
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useForgottenBox, ForgottenBoxLocalID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.BoxWispInit, FamiliarVariant.WISP)

