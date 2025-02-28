
local game = Game()
local TornHookLocalID = Isaac.GetItemIdByName("Torn Hook")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(TornHookLocalID, "{{BrokenHeart}} Gives 1 Broken Hearts which does not replace Heart at every Floor #{{ArrowUp}} At every floor grants:#{{DamageSmall}} +0.2 Damage#{{SpeedSmall}} +0.1 Speed#{{RangeSmall}} +0.2 Range#{{TearsSmall}} +0.3 Tears#{{LuckSmall}} +0.2 Luck#{{LuckSmall}} You have same Chance as Luck to remove Torn Hooks on each floor, at the floor when Torn Hooks removed the effects not activate")
end

local statMultiplier = {
    damage = 0.2,  -- +0.2 Damage 
    speed = 0.1,   -- +0.1 Speed 
    range = 8,     -- +0.2 Range 
    tears = 0.3,   -- +0.3 Fire Rate 
    luck = 0.2,    -- +0.2 Luck 
}

function ShatteredSymbols:onTornHook()
    for playerIndex = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local data = player:GetData()

        if not data.TornHookCounter then data.TornHookCounter = 0 end

        if player:HasCollectible(TornHookLocalID) then
            local luck = math.max(player.Luck, 0)
            if math.random(1, 100) <= luck then
                for i = 1, player:GetCollectibleNum(TornHookLocalID) do
                    player:RemoveCollectible(TornHookLocalID)
                    SFXManager():Play(SoundEffect.SOUND_SATAN_HURT)
                end
            else
                local TornHooksNum = player:GetCollectibleNum(TornHookLocalID)
                player:AddBrokenHearts(1*TornHooksNum)
                data.TornHookCounter = data.TornHookCounter + (1 * player:GetCollectibleNum(TornHookLocalID))
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                player:AddCacheFlags(CacheFlag.CACHE_RANGE)
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                player:AddCacheFlags(CacheFlag.CACHE_LUCK)
                player:EvaluateItems()
            end
        end
    end
end

function ShatteredSymbols:onEvaluateCacheTornHook(player, cacheFlag)
    local data = player:GetData()
    if not data.TornHookCounter then data.TornHookCounter = 0 end
    if player:HasCollectible(TornHookLocalID) or data.TornHookCounter > 0 then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + (data.TornHookCounter * statMultiplier.damage)
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + (data.TornHookCounter * statMultiplier.speed)
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + (data.TornHookCounter * statMultiplier.range)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local newTears = (30.0 / (player.MaxFireDelay + 1)) + (data.TornHookCounter * statMultiplier.tears)
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + (data.TornHookCounter * statMultiplier.luck)
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.onTornHook)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheTornHook)
