
local game = Game()
local AncientHookLocalID = Isaac.GetItemIdByName("Ancient Hook")
local globalHookTimer = nil

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(AncientHookLocalID, "{{BrokenHeart}} Gives 1 Broken Heart on every Floor which does not replaces Hearts until there are no more unused slots #{{Collectible628}} On first visit to a room, you have a 3% chance per Ancient Hook to enter the Death Certificate room #{{LuckSmall}} Your Luck stat determines the chance to remove Ancient Hooks each floor; on the floor Ancient Hooks are removed, their effects do not activate")
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
            end
        end
    end
end

function ShatteredSymbols:useAncientHook()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local level = game:GetLevel()
        local room = level:GetCurrentRoom()
        local AncientHooksCounter = player:GetCollectibleNum(AncientHookLocalID)
        if player:HasCollectible(AncientHookLocalID) then
            local AncientHookChance = 0
            AncientHookChance = AncientHooksCounter * 0.03
            if math.random() < AncientHookChance and room:IsFirstVisit() then
                globalHookTimer = 10
            end
        end
    end

end

function ShatteredSymbols:updateAncientHook()
    if globalHookTimer then
        globalHookTimer = globalHookTimer - 1
        if globalHookTimer <= 0 then
            for playerIndex = 0, game:GetNumPlayers() - 1 do
                local player = Isaac.GetPlayer(playerIndex)
                if player:HasCollectible(AncientHookLocalID) then
                    player:UseActiveItem(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, UseFlag.USE_NOANIM)
                end
            end
            globalHookTimer = nil
        end
    end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.onAncientHook)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ShatteredSymbols.useAncientHook)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.updateAncientHook)
