local game = Game()
local RunicBookLocalID = Isaac.GetItemIdByName("Runic Book")

-- EID (External Item Descriptions)
if EID then
    EID:addCollectible(RunicBookLocalID, "{{Rune}} While holding this item, using a Rune or Soul Stone charges it #{{Rune}} When used, repeats the effects of the absorbed runes used to charge it")
end

local function IsRune(card)
    local cardType = Isaac.GetItemConfig():GetCard(card)
    return cardType and cardType.CardType == ItemConfig.CARDTYPE_RUNE
end

function ShatteredSymbols:havingRunicBook(card, player, flags)
    local data = player:GetData()
    if not data.RunicBookEffects then data.RunicBookEffects = {} end

    if player:HasCollectible(RunicBookLocalID) and IsRune(card) and #data.RunicBookEffects < 3 then
        table.insert(data.RunicBookEffects, card)

        for i = 0, 3 do 
            local activeItem = player:GetActiveItem(i)

            if activeItem ~= 0 and activeItem == RunicBookLocalID then
                player:SetActiveCharge(#data.RunicBookEffects, i)
                
            end
        end

    end
end

function ShatteredSymbols:useRunicBook(_, rng, player)
    local data = player:GetData()
    if player:HasCollectible(RunicBookLocalID) then
        
        for _, RuneInAltar in ipairs(data.RunicBookEffects or {}) do
            player:UseCard(RuneInAltar, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
        end
        
        data.RunicBookEffects = {}
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end


function ShatteredSymbols:AltarWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(RunicBookLocalID) then
		if wisp.SubType == RunicBookLocalID then
			wisp.SubType = 263
		end
	end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, ShatteredSymbols.AltarWispInit, FamiliarVariant.WISP)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_CARD, ShatteredSymbols.havingRunicBook, ConsumableID)
ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.useRunicBook, RunicBookLocalID)

