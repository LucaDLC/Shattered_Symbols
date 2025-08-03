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
    'Ceres',
    'ShawtysLetter',
    'ShawtysEssence',
    'TornHook',
    'WrigglingShadow',
    'OrigamiKolibri',
    'OrigamiBat',
    'BrokenFlux',
    'OrigamiCrow',
    'ForgottenBox',
    'MidnightBite',
    'ExtraDeckofCard',
    'AncientHook',
    'RunicGeode',
    'RunicBook',
    'ForbiddenSoul',
    'ForbiddenMind',
    'ForbiddenBody',
    'JadeIvoryMask',
    'Pyrite',
    'MutableOnyx',
    'UnstableGlyph',
    'Vesta',
    'Pallas',
    'HoleyPocket',
    'DystopicFaith',
    'DystopicCrystal',
    'ShatteredHeart',
    'LustrousOrb',
    'AdamantOrb'
}
local PocketItemScript = {
    'Glyph',
    'HexCrystal',
    'SacredDiceShard',
    'FiendishSeed',
    'TeaBag',
    'QueenOfSpades'
}

local TransformationScript = {
    'Runic',
    'Paper',
    'Clairvoyant'
}


for LoadItem = 1, #ItemScript do
    require("script.item." .. ItemScript[LoadItem])
end

for LoadPocket = 1, #PocketItemScript do
    require("script.pickup." .. PocketItemScript[LoadPocket])
end

for LoadTransformation = 1, #TransformationScript do
    require("script.transformation." .. TransformationScript[LoadTransformation])
end
--------------------- Save Datas ---------------------

function ShatteredSymbols:SavePlayerData()
    local numPlayers = Game():GetNumPlayers()
    local allPlayersData = {}

    for i = 0, numPlayers - 1 do
        local player = Isaac.GetPlayer(i)
        local data = player:GetData()

        --Specific Player Data
        local playerDataToSave = {
            CapturedActiveItems = data.CapturedActiveItems or {},
            RunicTransformation = data.RunicTransformation or false,
            PaperTransformation = data.PaperTransformation or false,
            ClairvoyantTransformation = data.ClairvoyantTransformation or false, 
            OrigamiSwanRelative = data.OrigamiSwanRelative or 0,
            OrigamiSwanPreviousCounter = data.OrigamiSwanPreviousCounter or 1,
            OrigamiShurikenRelative = data.OrigamiShurikenRelative or 0,
            OrigamiShurikenPreviousCounter = data.OrigamiShurikenPreviousCounter or 1,
            OrigamiShurikenDamageBoost = data.OrigamiShurikenDamageBoost or 0,
            OrigamiBatRelative = data.OrigamiBatRelative or 0,
            OrigamiBatPreviousCounter = data.OrigamiBatPreviousCounter or 1,
            OrigamiBatTearsCount = data.OrigamiBatTearsCount or 0,
            OrigamiBatTearsBoost = data.OrigamiBatTearsBoost or 0,
            OrigamiBatLimit = data.OrigamiBatLimit or 0,
            OrigamiKolibriChargeMemory = data.OrigamiKolibriChargeMemory or {},
            OrigamiKolibriRelative = data.OrigamiKolibriRelative or 0,
            OrigamiKolibriPreviousCounter = data.OrigamiKolibriPreviousCounter or 1,
            OrigamiBoatBrokenHeartsCount = data.OrigamiBoatBrokenHeartsCount or 0,
            OrigamiBoatHoldingItemforStats = data.OrigamiBoatHoldingItemforStats or false,
            CeresRelative = data.CeresRelative or 0,
            CeresPreviousCounter = data.CeresPreviousCounter or 1,
            FortuneTellerRelative = data.FortuneTellerRelative or 0,
            FortuneTellerPreviousCounter = data.FortuneTellerPreviousCounter or 1,
            FortuneTellerLuckBoost = data.FortuneTellerLuckBoost or 0,
            BrokenFluxPreviousBrokenHearts = data.BrokenFluxPreviousBrokenHearts or -1,
            BrokenFluxPreviousHearts = data.BrokenFluxPreviousHearts or {red = 0, bone = 0, soul = 0, black = 0},
            OrigamiCrowRelative = data.OrigamiCrowRelative or 0,
            OrigamiCrowPreviousCounter = data.OrigamiCrowPreviousCounter or 1,
            OrigamiCrowPocket = data.OrigamiCrowPocket or 0,
            TornHookCounter = data.TornHookCounter or 0,
            RunicBookEffects = data.RunicBookEffects or {},
            OnyxItemEffectID = data.OnyxItemEffectID or {},
            CtrlHoldTimeHoleyPocket = data.CtrlHoldTimeHoleyPocket or 0,
            LastCtrlPressFrameHoleyPocket = data.LastCtrlPressFrameHoleyPocket or 0,
            DystopicCrystalDeathCounter = data.DystopicCrystalDeathCounter or 0,
            DystopicCrystalIsDead = data.DystopicCrystalIsDead or false,
            ForbiddenBodyMantleCounter = data.ForbiddenBodyMantleCounter or 0,
            ForbiddenBodyMantlePreviousCounter = data.ForbiddenBodyMantlePreviousCounter or 0,
            LastForbiddenBodyStage = data.LastForbiddenBodyStage or nil,
            IsDeadDystopicFaith = data.IsDeadDystopicFaith or false,
        }

        -- Shared Data
        if i == 0 then
            playerDataToSave.ForgottenBoxHeartFlag = data.ForgottenBoxHeartFlag or false
            playerDataToSave.ForgottenBoxItemFlag = data.ForgottenBoxItemFlag or nil
            playerDataToSave.ForgottenBoxMoneyFlag = data.ForgottenBoxMoneyFlag or 0
            playerDataToSave.ForgottenBoxBombFlag = data.ForgottenBoxBombFlag or 0
            playerDataToSave.ForgottenBoxKeyFlag = data.ForgottenBoxKeyFlag or 0
            playerDataToSave.ForgottenBoxStatus = data.ForgottenBoxStatus or false
            playerDataToSave.UnstableGlyphCharge = data.UnstableGlyphCharge or 0
            playerDataToSave.UnstableGlyphBrokenHearts = data.UnstableGlyphBrokenHearts or {}
            playerDataToSave.UnstableGlyphHeartsTracking = data.UnstableGlyphHeartsTracking or {}
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

            -- Specific Player Data
            data.CapturedActiveItems = playerDataToLoad.CapturedActiveItems or {}
            data.RunicTransformation = playerDataToLoad.RunicTransformation or false
            data.PaperTransformation = playerDataToLoad.PaperTransformation or false
            data.ClairvoyantTransformation = playerDataToLoad.ClairvoyantTransformation or false
            data.OrigamiSwanRelative = playerDataToLoad.OrigamiSwanRelative or 0
            data.OrigamiSwanPreviousCounter = playerDataToLoad.OrigamiSwanPreviousCounter or 1
            data.OrigamiShurikenRelative = playerDataToLoad.OrigamiShurikenRelative or 0
            data.OrigamiShurikenPreviousCounter = playerDataToLoad.OrigamiShurikenPreviousCounter or 1
            data.OrigamiShurikenDamageBoost = playerDataToLoad.OrigamiShurikenDamageBoost or 0
            data.OrigamiBatRelative = playerDataToLoad.OrigamiBatRelative or 0
            data.OrigamiBatPreviousCounter = playerDataToLoad.OrigamiBatPreviousCounter or 1
            data.OrigamiBatTearsCount = playerDataToLoad.OrigamiBatTearsCount or 0
            data.OrigamiBatTearsBoost = playerDataToLoad.OrigamiBatTearsBoost or 0
            data.OrigamiBatLimit = playerDataToLoad.OrigamiBatLimit or 0
            data.OrigamiKolibriChargeMemory = playerDataToLoad.OrigamiKolibriChargeMemory or {}
            data.OrigamiKolibriRelative = playerDataToLoad.OrigamiKolibriRelative or 0
            data.OrigamiKolibriPreviousCounter = playerDataToLoad.OrigamiKolibriPreviousCounter or 1
            data.OrigamiBoatBrokenHeartsCount = playerDataToLoad.OrigamiBoatBrokenHeartsCount or 0
            data.OrigamiBoatHoldingItemforStats = playerDataToLoad.OrigamiBoatHoldingItemforStats or false
            data.CeresRelative = playerDataToLoad.CeresRelative or 0
            data.CeresPreviousCounter = playerDataToLoad.CeresPreviousCounter or 1
            data.FortuneTellerRelative = playerDataToLoad.FortuneTellerRelative or 0
            data.FortuneTellerPreviousCounter = playerDataToLoad.FortuneTellerPreviousCounter or 1
            data.FortuneTellerLuckBoost = playerDataToLoad.FortuneTellerLuckBoost or 0
            data.BrokenFluxPreviousBrokenHearts = playerDataToLoad.BrokenFluxPreviousBrokenHearts or -1
            data.BrokenFluxPreviousHearts = playerDataToLoad.BrokenFluxPreviousHearts or {red = 0, bone = 0, soul = 0, black = 0}
            data.OrigamiCrowRelative = playerDataToLoad.OrigamiCrowRelative or 0
            data.OrigamiCrowPreviousCounter = playerDataToLoad.OrigamiCrowPreviousCounter or 1
            data.OrigamiCrowPocket = playerDataToLoad.OrigamiCrowPocket or 0
            data.TornHookCounter = playerDataToLoad.TornHookCounter or 0
            data.RunicBookEffects = playerDataToLoad.RunicBookEffects or {}
            data.OnyxItemEffectID = playerDataToLoad.OnyxItemEffectID or {}
            data.CtrlHoldTimeHoleyPocket = playerDataToLoad.CtrlHoldTimeHoleyPocket or 0
            data.LastCtrlPressFrameHoleyPocket = playerDataToLoad.LastCtrlPressFrameHoleyPocket or 0
            data.DystopicCrystalDeathCounter = playerDataToLoad.DystopicCrystalDeathCounter or 0
            data.DystopicCrystalIsDead = playerDataToLoad.DystopicCrystalIsDead or false
            data.ForbiddenBodyMantleCounter = playerDataToLoad.ForbiddenBodyMantleCounter or 0
            data.ForbiddenBodyMantlePreviousCounter = playerDataToLoad.ForbiddenBodyMantlePreviousCounter or 0
            data.LastForbiddenBodyStage = playerDataToLoad.LastForbiddenBodyStage or nil
            data.IsDeadDystopicFaith = playerDataToLoad.IsDeadDystopicFaith or false

            -- Shared Data
            if i == 0 then
                data.ForgottenBoxHeartFlag = playerDataToLoad.ForgottenBoxHeartFlag or false
                data.ForgottenBoxItemFlag = playerDataToLoad.ForgottenBoxItemFlag or nil
                data.ForgottenBoxMoneyFlag = playerDataToLoad.ForgottenBoxMoneyFlag or 0
                data.ForgottenBoxBombFlag = playerDataToLoad.ForgottenBoxBombFlag or 0
                data.ForgottenBoxKeyFlag = playerDataToLoad.ForgottenBoxKeyFlag or 0
                data.ForgottenBoxStatus = playerDataToLoad.ForgottenBoxStatus or false
                data.UnstableGlyphCharge = playerDataToLoad.UnstableGlyphCharge or 0
                data.UnstableGlyphBrokenHearts = playerDataToLoad.UnstableGlyphBrokenHearts or {}
                data.UnstableGlyphHeartsTracking = playerDataToLoad.UnstableGlyphHeartsTracking or {}
            end
        end

    elseif ShatteredSymbols:HasData() and (Game():GetFrameCount() == 0) then
        local allPlayersData = JsonSaveFile.decode(ShatteredSymbols:LoadData())
        local playerDataToLoad = allPlayersData[1] or {}

        local player = Isaac.GetPlayer(0)
        local data = player:GetData()

        data.ForgottenBoxHeartFlag = playerDataToLoad.ForgottenBoxHeartFlag or false
        data.ForgottenBoxItemFlag = playerDataToLoad.ForgottenBoxItemFlag or nil
        data.ForgottenBoxMoneyFlag = playerDataToLoad.ForgottenBoxMoneyFlag or 0
        data.ForgottenBoxBombFlag = playerDataToLoad.ForgottenBoxBombFlag or 0
        data.ForgottenBoxKeyFlag = playerDataToLoad.ForgottenBoxKeyFlag or 0
        data.ForgottenBoxStatus = playerDataToLoad.ForgottenBoxStatus or false
        data.UnstableGlyphCharge = playerDataToLoad.UnstableGlyphCharge or 0

    else
        ShatteredSymbols:RemoveData()
    end
end


--------------------- Console Command ---------------------

function ShatteredSymbols:ExecuteConsoleCommand(_, Command) 
    if Command == "Launch" then 
        for Load1 = 1, #ItemScript do
            require("script.item." .. ItemScript[Load1])
        end
        for Load2 = 1, #PocketItemScript do
            require("script.pickup." .. PocketItemScript[Load2])
        end
        for Load3 = 1, #TransformationScript do
            require("script.transformation." .. TransformationScript[Load3])
        end
        print("Shattered Symbols: Scripts Launched")
    end
    if Command == "Script" then 
        for Load1 = 1, #ItemScript do
            print("script.item." .. ItemScript[Load1])
        end
        for Load2 = 1, #PocketItemScript do
            print("script.pickup." .. PocketItemScript[Load2])
        end
        for Load3 = 1, #TransformationScript do
            print("script.transformation." .. TransformationScript[Load3])
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



