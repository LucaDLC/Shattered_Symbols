local game = Game()
local OnyxLocalID = Isaac.GetItemIdByName("Onyx")

-- EID (se usi EID per la descrizione)
if EID then
    EID:addCollectible(OnyxLocalID, "{{Collectible}} On each floor, it mutates into a different collectible effect")
end

local function GetRandomPassiveItem()
    local passiveItems = {}
    for id = 1, Isaac.GetItemConfig():GetCollectibles().Size do
        local config = Isaac.GetItemConfig():GetCollectible(id)
        if config and config.Type == ItemType.ITEM_PASSIVE 
        and not config:HasTags(ItemConfig.TAG_QUEST)
        and id ~= OnyxLocalID then 
            table.insert(passiveItems, id)
        end
    end
    if #passiveItems >0 then return passiveItems[math.random(#passiveItems)] else return nil end
end

-- Callback chiamato ad ogni nuovo piano: controlla tutti i giocatori e, se hanno Onyx, applica il nuovo effetto
function ShatteredSymbols:OnNewLevelOnyx()
    for pl = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(pl)
        local data = player:GetData()
        if not data.OnyxItemEffectID then data.OnyxItemEffectID = nil end
        if player:HasCollectible(OnyxLocalID) then
            local newItemID = GetRandomPassiveItem()
            if newItemID then
                if OnyxItemEffectID == nil then
                    data.OnyxItemEffectID = newItemID
                    player:AddCollectibleEffect(newItemID, false, 1)
                else
                    player:RemoveCollectibleEffect(data.OnyxItemEffectID)
                    data.OnyxItemEffectID = newItemID
                    player:AddCollectibleEffect(newItemID, false, 1)
                end
            end
        end
    end
end

function ShatteredSymbols:OnRenderOnyx()
    for p = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        local data = player:GetData()
        
        if data.OnyxDisplayTimer and data.OnyxDisplayTimer > 0 then
            -- Calcola posizione
            local screenCenter = Vector(Isaac.GetScreenWidth()/2, Isaac.GetScreenHeight()/4)
            
            -- Mostra sprite
            local sprite = Sprite()
            sprite:Load("gfx/005.100_collectible.tex", true)
            sprite:ReplaceSpritesheet(0, "gfx/items/collectibles_"..data.OnyxDisplayItem..".png")
            sprite:LoadGraphics()
            sprite:Play("Idle", true)
            sprite:Render(screenCenter, Vector.Zero, Vector.Zero)
            
            -- Mostra nome
            local itemName = Isaac.GetItemConfig():GetCollectible(data.OnyxDisplayItem).Name
            Isaac.RenderText("Onyx Effect: "..itemName, screenCenter.X - 60, screenCenter.Y + 40, 1, 1, 1, 1)
            
            data.OnyxDisplayTimer = data.OnyxDisplayTimer - 1
        end
    end
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ShatteredSymbols.OnNewLevelOnyx)
ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_RENDER, ShatteredSymbols.OnRenderOnyx)
