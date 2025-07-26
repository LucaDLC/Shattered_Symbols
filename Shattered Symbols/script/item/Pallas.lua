local game = Game()
local PallasLocalID = Isaac.GetItemIdByName("Pallas")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(PallasLocalID, "{{Room}} After clearing a room spawn 1-3 Minisaac #{{BrokenHeart}} The maximum number of Minisaac it can spawn increases with the number of Broken Heart you have")
end


function ShatteredSymbols:PallasRoomEffect()
    for p = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        local data = player:GetData()
        if player:HasCollectible(PallasLocalID) then
            local randomReward = math.random(1, (2 + player:GetBrokenHearts()))
            for i = 1, randomReward do
                player:AddMinisaac(player.Position, true)
                SFXManager():Play(SoundEffect.SOUND_BABY_HURT)
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, ShatteredSymbols.PallasRoomEffect)
