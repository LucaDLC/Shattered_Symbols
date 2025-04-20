local game = Game()
local DystopicCrystalLocalID = Isaac.GetItemIdByName("Dystopic Crystal")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(DystopicCrystalLocalID, "{{ArrowUp}} After death, gain: #{{DamageSmall}} +1.2 Damage #{{SpeedSmall}} +0.5 Speed #{{RangeSmall}} +1.5 Range #{{TearsSmall}} +1 Tears #{{ShotspeedSmall}} +0.3 Shot Speed #{{LuckSmall}} +2 Luck #{{Collectible}} there is a 10% chance + 1% for every Luck point to upgrade another random item with quality 3 or lower into a random item with quality 4")
end

local statMultiplier = {
    damage = 1.2,  -- +1.2 Damage 
    speed = 0.5,   -- +0.5 Speed 
    range = 60,    -- +1.5 Range 
    tears = 1,     -- +1 Fire Rate
    shot = 0.3,    -- +0.3 Shot Speed
    luck = 2,      -- +2 Luck 
}


function ShatteredSymbols:useDystopicCrystal()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()
        if not data.DystopicCrystalDeathCounter then data.DystopicCrystalDeathCounter = 0 end
        if not data.DystopicCrystalIsDead then data.DystopicCrystalIsDead = false end
        if player:IsDead() and player:HasCollectible(DystopicCrystalLocalID) and not data.DystopicCrystalIsDead then
            data.DystopicCrystalDeathCounter = data.DystopicCrystalDeathCounter + 1
            data.DystopicCrystalIsDead = true
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:AddCacheFlags(CacheFlag.CACHE_RANGE)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
            player:AddCacheFlags(CacheFlag.CACHE_LUCK)
            player:EvaluateItems()
            if math.random() < (0.1 + ((math.max(player.Luck, 0))/100)) then
                local eligibleItems = {}
            
                for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
                    local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
                    if itemConfig and id ~= DystopicCrystalLocalID and not itemConfig:HasTags(ItemConfig.TAG_QUEST) and player:HasCollectible(id) then
                        if itemConfig.Quality >= 0 and itemConfig.Quality <= 3 then
                            table.insert(eligibleItems, id)
                        end
                    end
                end
            
                if #eligibleItems > 0 then
                
                    local oldItemID = eligibleItems[math.random(1, #eligibleItems)]
                    local pool = {}
                    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
                    
                    if activeItem == 0 or activeItem == CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES then
                        for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
                            local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
                            if itemConfig and not itemConfig:HasTags(ItemConfig.TAG_QUEST) and itemConfig.Quality == 4 then
                                table.insert(pool, id)
                            end
                        end
                    else
                        for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
                            local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
                            if itemConfig and not itemConfig:HasTags(ItemConfig.TAG_QUEST) and itemConfig.Quality == 4 and itemConfig.Type == ItemType.ITEM_PASSIVE then
                                table.insert(pool, id)
                            end
                        end
                    end
                    

                    if #pool > 0 then
                        local newItemID = pool[math.random(1, #pool)]
                    
                        player:RemoveCollectible(oldItemID)
                        player:AddCollectible(newItemID, 0, false)
                    
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector(0,0), player)
                        SFXManager():Play(SoundEffect.SOUND_1UP)
                    end
                end
            end
        end
        if not player:IsDead() then
            data.DystopicCrystalIsDead = false
        end
    end
end


function ShatteredSymbols:onEvaluateCacheDystopicCrystal(player, cacheFlag)
    local data = player:GetData()
    if not data.DystopicCrystalDeathCounter then data.DystopicCrystalDeathCounter = 0 end
    if player:HasCollectible(DystopicCrystalLocalID) or data.DystopicCrystalDeathCounter > 0 then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + (data.DystopicCrystalDeathCounter * statMultiplier.damage)
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + (data.DystopicCrystalDeathCounter * statMultiplier.speed)
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + (data.DystopicCrystalDeathCounter * statMultiplier.range)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            local newTears = (30.0 / (player.MaxFireDelay + 1)) + (data.DystopicCrystalDeathCounter * statMultiplier.tears)
            player.MaxFireDelay = (30.0 / newTears) - 1
        elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + (data.DystopicCrystalDeathCounter * statMultiplier.shot)
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + (data.DystopicCrystalDeathCounter * statMultiplier.luck)
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.useDystopicCrystal)
ShatteredSymbols:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ShatteredSymbols.onEvaluateCacheDystopicCrystal)
