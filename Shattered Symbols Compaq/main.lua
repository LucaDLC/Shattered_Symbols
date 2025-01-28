ShatteredSymbols = RegisterMod("Shattered Symbols", 1)

---------------------------------------------------------
--/////////////////////////////////////////////////////--
----------------------Settings---------------------------
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
---------------------------------------------------------

if not REPENTOGON then
    print("")
    print("!                 WARNING                  !")
    print("!  SHATTERED SYMBOLS REQUIRED REPENTOGON   !")
    print("! FOLLOW REPENTOGON INSTALLATION GUIDELINE !")
    print("")
end

--------------------- Load Mod ---------------------

local JsonSaveFile = require("json")
local AllPlayerDataToSave = {}
local ItemScript = {
    'SacredLantern',
    'FortuneTeller',
    'OrigamiShuriken',
    'OrigamiBoat',
    'UpsideDownDeckofCard',
    'Constellation',
    'OrigamiSwan',
    'Meteor',
    'ShawtysLetter',
    'ShawtysEssence',
    'TornHook',
    'WrigglingShadow',
    'OrigamiKolibri',
    'OrigamiBat',
    'BrokenFlux',
    'OrigamiCrow',
    'BrokenBox',
    'MidnightBite',
    'ExtraDeckofCard',
    'AncientHook',
    'RunicGeode',
    'RunicAltar',
    'ForbiddenSoul',
    'ForbiddenMind',
    'ForbiddenBody'
}
local PocketItemScript = {
    'Glyph',
    'HexCrystal',
    'SacredDiceShard',
    'FiendishSeed',
    'TeaBag'
}


for LoadItem = 1, #ItemScript do
    require("script.item." .. ItemScript[LoadItem])
end

for LoadPocket = 1, #PocketItemScript do
    require("script.pickup." .. PocketItemScript[LoadPocket])
end
--------------------- Save Datas ---------------------

function ShatteredSymbols:SavePlayerData()
    local numPlayers = Game():GetNumPlayers()
    local allPlayersData = {}

    for i = 0, numPlayers - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()

        local playerDataToSave = {
            OrigamiSwanRelative = data.OrigamiSwanRelative or 0,
            OrigamiSwanPreviousCounter = data.OrigamiSwanPreviousCounter or 1,
            OrigamiShurikenRelative = data.OrigamiShurikenRelative or 0,
            OrigamiShurikenPreviousCounter = data.OrigamiShurikenPreviousCounter or 1,
            OrigamiShurikenDamageBoost = data.OrigamiShurikenDamageBoost or 0,
            OrigamiBatRelative = data.OrigamiBatRelative or 0,
            OrigamiBatPreviousCounter = data.OrigamiBatPreviousCounter or 1,
            OrigamiBatTearsCount = data.OrigamiBatTearsCount or 0,
            OrigamiBatSpeedBoost = data.OrigamiBatSpeedBoost or 0,
            OrigamiBatLimit = data.OrigamiBatLimit or 0,
            OrigamiKolibriChargeMemory = data.OrigamiKolibriChargeMemory or {},
            OrigamiKolibriRelative = data.OrigamiKolibriRelative or 0,
            OrigamiKolibriPreviousCounter = data.OrigamiKolibriPreviousCounter or 1,
            OrigamiBoatBrokenHeartsCount = data.OrigamiBoatBrokenHeartsCount or 0,
            OrigamiBoatHoldingItemforStats = data.OrigamiBoatHoldingItemforStats or false,
            MeteorRelative = data.MeteorRelative or 0,
            MeteorPreviousCounter = data.MeteorPreviousCounter or 1,
            FortuneTellerRelative = data.FortuneTellerRelative or 0,
            FortuneTellerPreviousCounter = data.FortuneTellerPreviousCounter or 1,
            FortuneTellerLuckBoost = data.FortuneTellerLuckBoost or 0,
            BrokenFluxPreviousBrokenHearts = data.BrokenFluxPreviousBrokenHearts or -1,
            BrokenFluxCharge = data.BrokenFluxCharge or 0,
            OrigamiCrowRelative = data.OrigamiCrowRelative or 0,
            OrigamiCrowPreviousCounter = data.OrigamiCrowPreviousCounter or 1,
            AncientHookCounter = data.AncientHookCounter or 0,
            RunicAltarEffects = data.RunicAltarEffects or {},
        }

        -- Specifiche per il giocatore 0
        if i == 0 then
            playerDataToSave.BrokenBoxHeartFlag = data.BrokenBoxHeartFlag or false
            playerDataToSave.BrokenBoxItemFlag = data.BrokenBoxItemFlag or nil
            playerDataToSave.BrokenBoxMoneyFlag = data.BrokenBoxMoneyFlag or 0
            playerDataToSave.BrokenBoxBombFlag = data.BrokenBoxBombFlag or 0
            playerDataToSave.BrokenBoxKeyFlag = data.BrokenBoxKeyFlag or 0
            playerDataToSave.BrokenBoxStatus = data.BrokenBoxStatus or false
        end

        table.insert(allPlayersData, playerDataToSave)
    end

    ShatteredSymbols:SaveData(JsonSaveFile.encode(allPlayersData))
end

--------------------- Load Saves ---------------------

function ShatteredSymbols:LoadPlayerData()
    local numPlayers = Game():GetNumPlayers()

    if ShatteredSymbols:HasData() and (Game():GetFrameCount() > 0) then
        local allPlayersData = JsonSaveFile.decode(ShatteredSymbols:LoadData())

        for i = 0, numPlayers - 1 do
            local player = Isaac.GetPlayer(i)
            local data = player:GetData()
            local playerDataToLoad = allPlayersData[i + 1] or {}

            data.OrigamiSwanRelative = playerDataToLoad.OrigamiSwanRelative or 0
            data.OrigamiSwanPreviousCounter = playerDataToLoad.OrigamiSwanPreviousCounter or 1
            data.OrigamiShurikenRelative = playerDataToLoad.OrigamiShurikenRelative or 0
            data.OrigamiShurikenPreviousCounter = playerDataToLoad.OrigamiShurikenPreviousCounter or 1
            data.OrigamiShurikenDamageBoost = playerDataToLoad.OrigamiShurikenDamageBoost or 0
            data.OrigamiBatRelative = playerDataToLoad.OrigamiBatRelative or 0
            data.OrigamiBatPreviousCounter = playerDataToLoad.OrigamiBatPreviousCounter or 1
            data.OrigamiBatTearsCount = playerDataToLoad.OrigamiBatTearsCount or 0
            data.OrigamiBatSpeedBoost = playerDataToLoad.OrigamiBatSpeedBoost or 0
            data.OrigamiBatLimit = playerDataToLoad.OrigamiBatLimit or 0
            data.OrigamiKolibriChargeMemory = playerDataToLoad.OrigamiKolibriChargeMemory or {}
            data.OrigamiKolibriRelative = playerDataToLoad.OrigamiKolibriRelative or 0
            data.OrigamiKolibriPreviousCounter = playerDataToLoad.OrigamiKolibriPreviousCounter or 1
            data.OrigamiBoatBrokenHeartsCount = playerDataToLoad.OrigamiBoatBrokenHeartsCount or 0
            data.OrigamiBoatHoldingItemforStats = playerDataToLoad.OrigamiBoatHoldingItemforStats or false
            data.MeteorRelative = playerDataToLoad.MeteorRelative or 0
            data.MeteorPreviousCounter = playerDataToLoad.MeteorPreviousCounter or 1
            data.FortuneTellerRelative = playerDataToLoad.FortuneTellerRelative or 0
            data.FortuneTellerPreviousCounter = playerDataToLoad.FortuneTellerPreviousCounter or 1
            data.FortuneTellerLuckBoost = playerDataToLoad.FortuneTellerLuckBoost or 0
            data.BrokenFluxPreviousBrokenHearts = playerDataToLoad.BrokenFluxPreviousBrokenHearts or -1
            data.BrokenFluxCharge = playerDataToLoad.BrokenFluxCharge or 0
            data.OrigamiCrowRelative = playerDataToLoad.OrigamiCrowRelative or 0
            data.OrigamiCrowPreviousCounter = playerDataToLoad.OrigamiCrowPreviousCounter or 1
            data.AncientHookCounter = playerDataToLoad.AncientHookCounter or 0
            data.RunicAltarEffects = playerDataToLoad.RunicAltarEffects or {}

            -- Specifiche per il giocatore 0
            if i == 0 then
                data.BrokenBoxHeartFlag = playerDataToLoad.BrokenBoxHeartFlag or false
                data.BrokenBoxItemFlag = playerDataToLoad.BrokenBoxItemFlag or nil
                data.BrokenBoxMoneyFlag = playerDataToLoad.BrokenBoxMoneyFlag or 0
                data.BrokenBoxBombFlag = playerDataToLoad.BrokenBoxBombFlag or 0
                data.BrokenBoxKeyFlag = playerDataToLoad.BrokenBoxKeyFlag or 0
                data.BrokenBoxStatus = playerDataToLoad.BrokenBoxStatus or false
            end
        end

    elseif ShatteredSymbols:HasData() and (Game():GetFrameCount() == 0) then
        local allPlayersData = JsonSaveFile.decode(ShatteredSymbols:LoadData())
        local playerDataToLoad = allPlayersData[1] or {}

        local player = Isaac.GetPlayer(0)
        local data = player:GetData()

        data.BrokenBoxHeartFlag = playerDataToLoad.BrokenBoxHeartFlag or false
        data.BrokenBoxItemFlag = playerDataToLoad.BrokenBoxItemFlag or nil
        data.BrokenBoxMoneyFlag = playerDataToLoad.BrokenBoxMoneyFlag or 0
        data.BrokenBoxBombFlag = playerDataToLoad.BrokenBoxBombFlag or 0
        data.BrokenBoxKeyFlag = playerDataToLoad.BrokenBoxKeyFlag or 0
        data.BrokenBoxStatus = playerDataToLoad.BrokenBoxStatus or false

    else
        ShatteredSymbols:RemoveData()
    end
end


--------------------- Console Command ---------------------

function ShatteredSymbols:ExecuteConsoleCommand(_, Command) 
    if Command == "Launch" then 
        for Load = 1, #ItemScript do
            require("script.item." .. ItemScript[Load])
        end
        print("Shattered Symbols: Scripts Launched")
    end
    if Command == "Script" then 
        for Load = 1, #ItemScript do
            print("script.item." .. ItemScript[Load])
        end
    end
    if Command == "Erase" then
        local room = Game():GetRoom()
        if room:GetType() == RoomType.ROOM_NULL then
            ShatteredSymbols:RemoveData()
            print("Data Erased")
        else
            print("For using this command, you must be not in game")
        end
    end

end

ShatteredSymbols:AddCallback(ModCallbacks.MC_EXECUTE_CMD,ShatteredSymbols.ExecuteConsoleCommand)

ShatteredSymbols:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, ShatteredSymbols.SavePlayerData)

ShatteredSymbols:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, ShatteredSymbols.LoadPlayerData)


---------------------------------------------------------
--/////////////////////////////////////////////////////--
--------------------Integrations-------------------------
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
---------------------------------------------------------

--------------------- Deck of Card ---------------------

local function isDeckofCard(descObj)
    if descObj.ObjType == 5 and descObj.ObjVariant == 100 and descObj.ObjSubType == 85 then return true end
end

local function mutableDeckofCard(descObj)
 EID:appendToDescription(descObj, "#After use it, have 5% chance to mutate into Extra Deck and 5% chance to mutate into Upside Down Deck")
    return descObj
end

function ShatteredSymbols:mutateDeck(_, rng, player)
    local mutateValue = rng:RandomFloat()
    if mutateValue < 0.05 then
        local ExtraDeckID = Isaac.GetItemIdByName("Extra Deck of Cards")
        for i = 0, 3 do
            local activeItem = player:GetActiveItem(i)
            if activeItem == DeckofCardID then
                player:RemoveCollectible(DeckofCardID, false, i)
                player:AddCollectible(ExtraDeckID, 0, false, i)
            end
        end
    elseif mutateValue > 0.95 then
        local UpsideDownDeckofCardsID = Isaac.GetItemIdByName("Upside Down Deck of Cards")
        for i = 0, 3 do
            local activeItem = player:GetActiveItem(i)
            if activeItem == DeckofCardID then
                player:RemoveCollectible(DeckofCardID, false, i)
                player:AddCollectible(UpsideDownDeckofCardsID, 0, false, i)
            end
        end
    end
end


if EID then
    EID:addDescriptionModifier("MutableDeckofCard", isDeckofCard, mutableDeckofCard)
end

ShatteredSymbols:AddCallback(ModCallbacks.MC_USE_ITEM, ShatteredSymbols.mutateDeck, DeckofCardID)



