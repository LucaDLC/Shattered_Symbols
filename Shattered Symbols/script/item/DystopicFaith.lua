local game = Game()
local DystopicFaithLocalID = Isaac.GetItemIdByName("Dystopic Faith")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(DystopicFaithLocalID, "{{HolyMantleSmall}} After death, it become Holy Mantle and Fate")
end


function ShatteredSymbols:useDystopicFaith()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()
        if not data.IsDeadDystopicFaith then data.IsDeadDystopicFaith = false end --variabile da mettere nel main 
        if player:IsDead() and player:HasCollectible(DystopicFaithLocalID) then  
            data.IsDeadDystopicFaith = true
        end
        if not player:IsDead() data.IsDeadDystopicFaith and player:HasCollectible(DystopicFaithLocalID) then
            data.IsDeadDystopicFaith = false
            player:RemoveCollectible(DystopicFaithLocalID)
            player:AddCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE, 1, false)
            player:AddCollectible(CollectibleType.COLLECTIBLE_FATE, 1, false)
            SFXManager():Play(SoundEffect.SOUND_HOLY)
        end
    end
end


ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_UPDATE, ShatteredSymbols.useDystopicFaith)
