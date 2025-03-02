local game = Game()
local PallasLocalID = Isaac.GetItemIdByName("Pallas")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(PallasLocalID, "{{HolyMantleSmall}} Occasionally, Isaac nullifying all types of damage for 3 seconds and its frequency increasing with numbers of Pallas you have")
end

local function triggerInvincibility(player)
    local data = player:GetData()
    player:AddEntityFlags(EntityFlag.FLAG_INVINCIBLE)
    data.PallasTimer = game:GetFrameCount() + 180
    
end

function ShatteredSymbols:PallasEffect(player)
    local data = player:GetData()
    if not data.PallasTimer then data.PallasTimer = 0 end

    if player:HasCollectible(PallasLocalID) then

        local numberOfPallass = player:GetCollectibleNum(PallasLocalID)
        if numberOfPallass > 0 then
            if numberOfPallass > 5 then numberOfPallass = 5 end
            local randomValue = math.random(1, math.floor(1024 / 2^numberOfPallass))
        
            if randomValue == 1 then
                triggerInvincibility(player)  
            end
        end
    end
    if game:GetFrameCount() > data.PallasTimer and player:HasEntityFlags(EntityFlag.FLAG_INVINCIBLE) then
        data.PallasTimer = 0
        player:ClearEntityFlags(EntityFlag.FLAG_INVINCIBLE)
    end

end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.PallasEffect)

