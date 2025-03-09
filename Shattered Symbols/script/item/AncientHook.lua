
local game = Game()
local AncientHookLocalID = Isaac.GetItemIdByName("Ancient Hook")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(AncientHookLocalID, "{{BrokenHeart}} Gives 1 Broken Hearts at every Floor which does not replace Heart until all available slots for new Hearts are used #{{Collectible628}} Every floor you have 15% of chance for each Ancient Hook of spawn Death Certificate #{{LuckSmall}} You have same Chance as Luck to remove Ancient Hooks on each floor, at the floor when Ancient Hooks removed the effects not activate")
end

function ShatteredSymbols:onAncientHook()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        if player:HasCollectible(AncientHookLocalID) then
            local luck = math.max(player.Luck, 0)
            if math.random(1, 100) <= luck then
                for i = 1, player:GetCollectibleNum(AncientHookLocalID) do
                    player:RemoveCollectible(AncientHookLocalID)
                    SFXManager():Play(SoundEffect.SOUND_SATAN_HURT)
                end
            else
                local AncientHooksCounter = player:GetCollectibleNum(AncientHookLocalID)
                player:AddBrokenHearts(1*AncientHooksCounter)
                local AncientHookChance = 0
                AncientHookChance = AncientHooksCounter * 0.15
                if math.random() < AncientHookChance then
                    local pocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
                    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
                    if pocketItem == 0 then
                        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, ActiveSlot.SLOT_POCKET)
                    elseif activeItem == 0 then
                        player:AddCollectible(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, 1, false)
                    else
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, player.Position + Vector(0, 50), Vector(0,0), nil)
                    end
                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                end
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.onAncientHook)
