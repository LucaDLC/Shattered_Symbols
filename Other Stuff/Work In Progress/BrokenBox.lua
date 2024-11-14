local game = Game()
local BrokenBoxLocalID = Isaac.GetItemIdByName("Broken Box")


-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(BrokenBoxLocalID, "{{Warning}} SINGLE USE {{Warning}} #If empty, the box takes up to maximum of: #{{BrokenHeart}} 1 Broken Heart #{{Collectible}} 1 Item #{{Coin}} 10 Coins #{{Bomb}} 1 Bomb #{{Key}} 1 Key #If full, the box gives you everything it took before")
end


-- Funzione per gestire l'uso dell'oggetto "Wriggling Shadow"
function BrokenOrigami:useBrokenBox(_, rng, player)

    local SetterData = Isaac.GetPlayer(0)
    local data = SetterData:GetData()
    if not data.BrokenBoxHeartFlag then data.BrokenBoxHeartFlag = false end
    if not data.BrokenBoxItemFlag then data.BrokenBoxItemFlag = nil end
    if not data.BrokenBoxMoneyFlag then data.BrokenBoxMoneyFlag = 0 end
    if not data.BrokenBoxBombFlag then data.BrokenBoxBombFlag = 0 end
    if not data.BrokenBoxKeyFlag then data.BrokenBoxKeyFlag = 0 end
    if not data.BrokenBoxStatus then data.BrokenBoxStatus = false end

    if player:HasCollectible(BrokenBoxLocalID) and not data.BrokenBoxStatus then

        if player:GetBrokenHearts() > 0 then
            player:AddBrokenHearts(-1)
            data.BrokenBoxHeartFlag = true
        end

        if #player:GetCollectibles() > 0 then
            data.BrokenBoxItemFlag = player:GetCollectibles()[rng:RandomInt(#player:GetCollectibles()) + 1]
            player:RemoveCollectible(data.BrokenBoxItemFlag)
        end

        data.BrokenBoxMoneyFlag = math.min(player:GetNumCoins(), 10)
        player:AddCoins(-data.BrokenBoxMoneyFlag)

        data.BrokenBoxBombFlag = math.min(player:GetNumBombs(), 1)
        player:AddBombs(-data.BrokenBoxBombFlag)

        data.BrokenBoxKeyFlag = math.min(player:GetNumKeys(), 1)
        player:AddKeys(-data.BrokenBoxKeyFlag)

       
    else if player:HasCollectible(BrokenBoxLocalID) and data.BrokenBoxStatus then

        if data.BrokenBoxHeartFlag then
            player:AddBrokenHearts(1)
            data.BrokenBoxHeartFlag = false
        end

        if data.BrokenBoxItemFlag ~= nil then
            player:AddCollectible(data.BrokenBoxItemFlag)
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
        
    end

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useBrokenBox, BrokenBoxLocalID)
