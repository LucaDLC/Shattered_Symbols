local game = Game()
local RunicAltarLocalID = Isaac.GetItemIdByName("Runic Altar")

if EID then
    EID:addCollectible(RunicAltarLocalID, "{{Warning}} SINGLE USE {{Warning}} #{{UltraSecretRoom}} Teleport in Ultra Secret Room #{{BrokenHeart}} When you hold the item, after gaining Broken Heart, the item remove it for charging, every Broken Heart is equal to one charge #{{ArrowDown}} If the absorbed Broken Hearts have replaced Heart, these are not returned #{{ArrowUp}} Runic Altar share charges with all Runic Altar of the same player during the game ")
end

local funcion IsRune(card)
    local cardType = Isaac.GetItemConfig():GetCard(card)
    return cardType and cardType.CardType == ItemConfig.CARDTYPE_RUNE
end

function BrokenOrigami:havingRunicAltar(card, player, flags)
    -- Get the player's data table
    local data = player:GetData()
    if not data.RunicAltarEffects then data.RunicAltarEffects = {} end

    if player:HasCollectible(RunicAltarLocalID) and IsRune(card) and #data.RunicAltarEffects < 3 then
        table.insert(data.RunicAltarEffects, card)

        for i = 0, 3 do -- Check all active item slots
            local activeItem = player:GetActiveItem(i)

            if activeItem ~= 0 and activeItem == RunicAltarLocalID then
                player:SetActiveCharge(#data.RunicAltarEffects, i)
                end
            end
        end

    end
end

function BrokenOrigami:useRunicAltar(_, rng, player)
    local data = player:GetData()
    if player:HasCollectible(RunicAltarLocalID) then
        
        for _, RuneInAltar in ipairs(data.RunicAltarEffects or {}) do
            -- Attiva l'effetto della runa
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


function BrokenOrigami:AltarWispInit(wisp)
	if  wisp.Player and wisp.Player:HasCollectible(RunicAltarLocalID) then
		if wisp.SubType == RunicAltarLocalID then
			wisp.SubType = 263
		end
	end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, BrokenOrigami.AltarWispInit, FamiliarVariant.WISP)
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_CARD, BrokenOrigami.havingRunicAltar, ConsumableID)
BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.useRunicAltar, RunicAltarLocalID)

