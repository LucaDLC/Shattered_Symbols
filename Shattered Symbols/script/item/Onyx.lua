
local game = Game()
local OnyxLocalID = Isaac.GetItemIdByName("Onyx")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(OnyxLocalID, "{{Collectible}} On each floor, it mutates into a different collectible effect")
end

local function GetRandomPassiveItem()
    local passiveItems = {}
    for i = 1, Isaac.GetItemConfig():GetCollectibles().Size do
        local item = itemConfig:GetCollectible(i)
        if item and not item:HasTags(ItemConfig.TAG_QUEST) and item.Type == ItemType.ITEM_PASSIVE then
            table.insert(passiveItems, i)
        end
    end
    if #passiveItems > 0 then
        return passiveItems[math.random(#passiveItems)]
    else
    return nil
    end
end

-- Callback chiamato ad ogni nuovo piano: controlla tutti i giocatori e, se hanno Onyx, applica il nuovo effetto
function ShatteredSymbols:OnNewLevelOnyx()
    for pl = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(pl)
        local data = player:GetData()
        if not data.OnyxItemID then data.OnyxItemID = nil end
        if player:HasCollectible(onyxItemID) then

            local newItem = GetRandomPassiveItem()
            if newItem then
                data.OnyxItemID = newItem
                player:AddCollectible(newItem, 0, false)  --GetCollectibleEffect()
                showEffectTimer = 120
            end
        end
    end
end

function ShatteredSymbols:OnRenderOnyx()
    for pl = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(pl)
        local data = player:GetData()
        if data.OnyxItemID and showEffectTimer > 0 then
            showEffectTimer = showEffectTimer - 1
            local pos = Vector(Isaac.GetScreenWidth() / 2, Isaac.GetScreenHeight() / 4)
            local sprite = Sprite()
            sprite:Load("gfx/ui/itemportrait.anm2", true)
            sprite:SetFrame("Idle", 0)
            sprite:Render(pos, Vector(0,0), Vector(0,0))
            Isaac.RenderText("Onyx: " .. Isaac.GetItemConfig():GetCollectible(data.OnyxItemID).Name, pos.X - 40, pos.Y + 20, 1, 1, 1, 1)
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelOnyx)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_RENDER, ShatteredSymbols.OnRenderOnyx)