local game = Game()
local BrokenBoxLocalID = Isaac.GetItemIdByName("Broken Box")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(BrokenBoxLocalID, "{{Warning}} SINGLE USE {{Warning}} #If empty, the box takes up to maximum of: #{{BrokenHeart}} 1 Broken Heart #{{Collectible}} 1 Item #{{Coin}} 10 Coins #{{Bomb}} 1 Bomb #{{Key}} 1 Key #If full, the box gives you everything it took before")
end

-- Funzione per gestire l'uso dell'oggetto "Broken Box"
function BrokenOrigami:useBrokenBox(_, rng, player)
    local SetterData = Isaac.GetPlayer(0)
    local data = SetterData:GetData()
    
    -- Inizializza i flag se non già impostati
    if data.BrokenBoxHeartFlag == nil then data.BrokenBoxHeartFlag = false end
    if data.BrokenBoxItemFlag == nil then data.BrokenBoxItemFlag = nil end
    if data.BrokenBoxMoneyFlag == nil then data.BrokenBoxMoneyFlag = 0 end
    if data.BrokenBoxBombFlag == nil then data.BrokenBoxBombFlag = 0 end
    if data.BrokenBoxKeyFlag == nil then data.BrokenBoxKeyFlag = 0 end
    if data.BrokenBoxStatus == nil then data.BrokenBoxStatus = false end

    -- Se l'oggetto è usato la prima volta (vuoto)
    if player:HasCollectible(BrokenBoxLocalID) and not data.BrokenBoxStatus then
        if player:GetBrokenHearts() > 0 then
            player:AddBrokenHearts(-1)
            data.BrokenBoxHeartFlag = true
        end

        local collectibles = {}
        for i = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
            if player:HasCollectible(i) then
                table.insert(collectibles, i)
            end
        end

        if #collectibles > 0 then
            data.BrokenBoxItemFlag = collectibles[rng:RandomInt(#collectibles) + 1]
            player:RemoveCollectible(data.BrokenBoxItemFlag)
        end

        data.BrokenBoxMoneyFlag = math.min(player:GetNumCoins(), 10)
        player:AddCoins(-data.BrokenBoxMoneyFlag)

        data.BrokenBoxBombFlag = math.min(player:GetNumBombs(), 1)
        player:AddBombs(-data.BrokenBoxBombFlag)

        data.BrokenBoxKeyFlag = math.min(player:GetNumKeys(), 1)
        player:AddKeys(-data.BrokenBoxKeyFlag)

        data.BrokenBoxStatus = true  -- Imposta lo stato a pieno

    -- Se l'oggetto è usato di nuovo (pieno)
    elseif player:HasCollectible(BrokenBoxLocalID) and data.BrokenBoxStatus then
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

        data.BrokenBoxStatus = false  -- Reimposta lo stato a vuoto
    end

    -- Ritorna per rimuovere e scaricare l'oggetto
    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useBrokenBox, BrokenBoxLocalID)
