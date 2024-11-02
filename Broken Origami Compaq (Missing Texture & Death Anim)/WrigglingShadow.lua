local game = Game()
local WrigglingShadowLocalID = Isaac.GetItemIdByName("Wriggling Shadow")
local TornHookExternalID = Isaac.GetItemIdByName("Torn Hook")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(WrigglingShadowLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{Warning}} WORKS ONLY IF YOU HAVE TORN HOOK #{{ArrowUp}} Remove all Torn Hooks and spawn 2 Death Certificate #{{ArrowUp}} Remove 1 Broken Heart {{BrokenHeart}} #{{ArrowUp}} Add 1 Heart {{Heart}}")
end

-- Funzione per gestire l'uso dell'oggetto "Wriggling Shadow"
function BrokenOrigami:useWrigglingShadow(_, rng, player)
    if player:HasCollectible(TornHookExternalID) then
        -- Rimuove 1 Broken Heart e aggiunge 2 Heart
        player:AddBrokenHearts(-1)
        player:AddMaxHearts(2)
        player:AddHearts(2)

        -- Rimuove tutti gli oggetti Torn Hook
        for i = 1, player:GetCollectibleNum(TornHookExternalID) do
            player:RemoveCollectible(TornHookExternalID)
        end

        -- Calcola le posizioni per i due Death Certificate
        local positionLeft = game:GetRoom():FindFreePickupSpawnPosition(player.Position + Vector(-20, 0), 30, true)
        local positionRight = game:GetRoom():FindFreePickupSpawnPosition(player.Position + Vector(30, 0), 30, true)

        -- Spawna i due Death Certificate nelle posizioni calcolate
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, positionLeft, Vector(0, 0), player)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, positionRight, Vector(0, 0), player)
    end

    -- Rimuove l'oggetto Wriggling Shadow dopo l'uso
    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true
    }
end

BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useWrigglingShadow, WrigglingShadowLocalID)
