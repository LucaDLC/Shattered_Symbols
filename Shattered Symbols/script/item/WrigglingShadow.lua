local game = Game()
local WrigglingShadowLocalID = Isaac.GetItemIdByName("Wriggling Shadow")
local TornHookExternalID = Isaac.GetItemIdByName("Torn Hook")
local AncientHookExternalID = Isaac.GetItemIdByName("Ancient Hook")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(WrigglingShadowLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{ArrowUp}} Remove all Hooks, remove 1 Broken Heart and give 1 Full Heart for each Hook #{{ArrowDown}} If you don't have any hooks, it gives you one")
end

-- Funzione per gestire l'uso dell'oggetto "Wriggling Shadow"
function ShatteredSymbols:useWrigglingShadow(_, rng, player)
    if (player:HasCollectible(TornHookExternalID) or player:HasCollectible(AncientHookExternalID)) and player:HasCollectible(WrigglingShadowLocalID) then

        -- Rimuove tutti gli oggetti Torn Hook
        for i = 1, player:GetCollectibleNum(TornHookExternalID) do
            player:RemoveCollectible(TornHookExternalID)
            player:AddBrokenHearts(-1)
            player:AddMaxHearts(2)
            player:AddHearts(2)
        end

        for i = 1, player:GetCollectibleNum(AncientHookExternalID) do
            player:RemoveCollectible(AncientHookExternalID)
            player:AddBrokenHearts(-1)
            player:AddMaxHearts(2)
            player:AddHearts(2)
        end

        SFXManager():Play(SoundEffect.SOUND_SATAN_HURT)

    elseif (not player:HasCollectible(TornHookExternalID) and not player:HasCollectible(AncientHookExternalID)) and player:HasCollectible(WrigglingShadowLocalID) then
        local hookProb = math.random(0, 1)
        if hookProb == 0 then
            player:AddCollectible(TornHookExternalID)
        else
            player:AddCollectible(AncientHookExternalID)
        end
    end

    -- Rimuove l'oggetto Wriggling Shadow dopo l'uso
    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useWrigglingShadow, WrigglingShadowLocalID)
