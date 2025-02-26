local game = Game()
local RunicAltarLocalID = Isaac.GetItemIdByName("Runic Altar")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(RunicAltarLocalID, "{{Rune}} When you hold the item, after using Rune or Soul Stone, the item charging #{{Rune}} At the Use, repeat effects of absorbed runes used to charging it")
end

local function IsRune(card)
    local cardType = Isaac.GetItemConfig():GetCard(card)
    return cardType and cardType.CardType == ItemConfig.CARDTYPE_RUNE
end

function ShatteredSymbols:havingRunicAltar(card, player, flags)
    local data = player:GetData()
    if not data.RunicAltarEffects then data.RunicAltarEffects = {} end

    if player:HasCollectible(RunicAltarLocalID) and IsRune(card) and #data.RunicAltarEffects < 3 then
        table.insert(data.RunicAltarEffects, card)

        for i = 0, 3 do 
            local activeItem = player:GetActiveItem(i)

            if activeItem ~= 0 and activeItem == RunicAltarLocalID then
                player:SetActiveCharge(#data.RunicAltarEffects, i)
                
            end
        end

    end
end

function ShatteredSymbols:useRunicAltar(_, rng, player)
    local data = player:GetData()
    if player:HasCollectible(RunicAltarLocalID) then
        
        for _, RuneInAltar in ipairs(data.RunicAltarEffects or {}) do
            player:UseCard(RuneInAltar, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
        end
        
        data.RunicAltarEffects = {}
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end


function ShatteredSymbols:AltarWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(RunicAltarLocalID) then
		if wisp.SubType == RunicAltarLocalID then
			wisp.SubType = 263
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.AltarWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.havingRunicAltar, ConsumableID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useRunicAltar, RunicAltarLocalID)

