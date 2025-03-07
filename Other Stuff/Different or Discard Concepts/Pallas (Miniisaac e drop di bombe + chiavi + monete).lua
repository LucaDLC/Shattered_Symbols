local game = Game()
local PallasLocalID = Isaac.GetItemIdByName("Pallas")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(PallasLocalID, "{{Room}} After clearing a room you have 50% of chance to give these pickup: #{{Bomb}} 1-3 Bomb #{{Key}} 1-3 Key #{{Coin}} 3-5 Coins #{{Crown}} Occasionally, spawn a Minisaac #{{ArrowUp}} Both effects increasing with numbers of Pallas you have")
end


local function triggerPallas(player)
    
    player:AddMinisaac(player.Position, true)
    SFXManager():Play(SoundEffect.SOUND_BABY_HURT)
    
end

function ShatteredSymbols:PallasEffect(player)
    local data = player:GetData()

    if player:HasCollectible(PallasLocalID) then
        local numberOfPallas = player:GetCollectibleNum(PallasLocalID)
        if numberOfPallas > 0 then
            local randomValue = math.random(1, math.floor(1700 / (2*numberOfPallas)))
        
            if randomValue == 1 then
                triggerPallas(player)  
            end
        end
    end
end

function ShatteredSymbols:PallasRoomEffect()
    for p = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        local data = player:GetData()
        if player:HasCollectible(PallasLocalID) and math.random() < 0.5  then
            local randomReward = math.random(1, (2 + player:GetCollectibleNum(PallasLocalID)))
            player:AddBombs(randomReward)
            player:AddKeys(randomReward)
            player:AddCoins(2 + randomReward)
            SFXManager():Play(SoundEffect.SOUND_LUCKYPICKUP)
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.PallasEffect)
ShatteredSymbols:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, ShatteredSymbols.PallasRoomEffect)
