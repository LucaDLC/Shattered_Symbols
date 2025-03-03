local game = Game()
local PallasLocalID = Isaac.GetItemIdByName("Pallas")
local MutableOnyxExternalID = Isaac.GetItemIdByName("Mutable Onyx")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(PallasLocalID, "{{Room}} Every room you have 5% of chance to substitute a not volatile Item with an Mutable Onyx #{{Rune}} Occasionally, active effects of a rune #{{ArrowUp}} Both effects increasing with numbers of Vesta you have")
end

local itemIgnoreList = {
    238, 239, 550, 551, 626, 627, 668
}

local itemIgnoreSet = {}
for _, v in ipairs(itemIgnoreList) do
    itemIgnoreSet[v] = true
end
local function IsRune(card)
    local cardType = Isaac.GetItemConfig():GetCard(card)
    return cardType and cardType.CardType == ItemConfig.CARDTYPE_RUNE
end

local function triggerPallas(player)
    local rune
	repeat
		rune = Game():GetItemPool():GetCard(RNG():Next(), false, true, true)
	until IsRune(rune) and Isaac.GetItemConfig():GetCard(rune).IsRune
	player:UseActiveItem(rune)
end

function ShatteredSymbols:PallasEffect(player)
    local data = player:GetData()

    if player:HasCollectible(PallasLocalID) then

        local numberOfPallass = player:GetCollectibleNum(PallasLocalID)
        if numberOfPallass > 0 then

            if numberOfPallass > 5 then numberOfPallass = 5 end
            local randomValue = math.random(1, math.floor(1024 / 2^numberOfPallass))
        
            if randomValue == 1 then
                triggerPallas(player)  
            end
        end
    end

end

function ShatteredSymbols:PallasRoomEffect()
    for p = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        if player:HasCollectible(PallasLocalID) and (math.random() < (0.05 * player:GetCollectibleNum(PallasLocalID))) then
            local eligibleItems = {}

            for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
                local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
                if itemConfig and id ~= PallasLocalID and id ~= MutableOnyxExternalID and not itemIgnoreSet[id] and player:HasCollectible(id) then
                    table.insert(eligibleItems, id)
                end
            end

            if #eligibleItems > 0 then
                    
                player:RemoveCollectible(eligibleItems[math.random(1, #eligibleItems)])
                player:AddCollectible(MutableOnyxExternalID, 0, false)
                    
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector(0,0), player)
                SFXManager():Play(SoundEffect.SOUND_1UP)
            
            end
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ShatteredSymbols.PallasEffect)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ShatteredSymbols.PallasRoomEffect)
