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
    local player = Isaac.GetPlayer(0)
    local data = player:GetData()

    AllPlayerDataToSave = {
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
        BrokenBoxHeartFlag = data.BrokenBoxHeartFlag or false,
        BrokenBoxItemFlag = data.BrokenBoxItemFlag or nil,
        BrokenBoxMoneyFlag = data.BrokenBoxMoneyFlag or 0,
        BrokenBoxBombFlag = data.BrokenBoxBombFlag or 0,
        BrokenBoxKeyFlag = data.BrokenBoxKeyFlag or 0,
        BrokenBoxStatus = data.BrokenBoxStatus or false,
        AncientHookCounter = data.AncientHookCounter or 0,
        RunicAltarEffects = data.RunicAltarEffects or {},
    }

    ShatteredSymbols:SaveData(JsonSaveFile.encode(AllPlayerDataToSave))
    AllPlayerDataToSave = {}

end

--------------------- Load Saves ---------------------

function ShatteredSymbols:LoadPlayerData()
    local player = Isaac.GetPlayer(0)
    local data = player:GetData()

    if ShatteredSymbols:HasData() and (Game():GetFrameCount() > 0) then

        AllPlayerDataToSave = JsonSaveFile.decode(ShatteredSymbols:LoadData())

        data.OrigamiSwanRelative = AllPlayerDataToSave.OrigamiSwanRelative or 0
        data.OrigamiSwanPreviousCounter = AllPlayerDataToSave.OrigamiSwanPreviousCounter or 1
        data.OrigamiShurikenRelative = AllPlayerDataToSave.OrigamiShurikenRelative or 0
        data.OrigamiShurikenPreviousCounter = AllPlayerDataToSave.OrigamiShurikenPreviousCounter or 1
        data.OrigamiShurikenDamageBoost = AllPlayerDataToSave.OrigamiShurikenDamageBoost or 0
        data.OrigamiBatRelative = AllPlayerDataToSave.OrigamiBatRelative or 0
        data.OrigamiBatPreviousCounter = AllPlayerDataToSave.OrigamiBatPreviousCounter or 1
        data.OrigamiBatTearsCount = AllPlayerDataToSave.OrigamiBatTearsCount or 0
        data.OrigamiBatSpeedBoost = AllPlayerDataToSave.OrigamiBatSpeedBoost or 0
        data.OrigamiBatLimit = AllPlayerDataToSave.OrigamiBatLimit or 0
        data.OrigamiKolibriChargeMemory = AllPlayerDataToSave.OrigamiKolibriChargeMemory or {}
        data.OrigamiKolibriRelative = AllPlayerDataToSave.OrigamiKolibriRelative or 0
        data.OrigamiKolibriPreviousCounter = AllPlayerDataToSave.OrigamiKolibriPreviousCounter or 1
        data.OrigamiBoatBrokenHeartsCount = AllPlayerDataToSave.OrigamiBoatBrokenHeartsCount or 0
        data.OrigamiBoatHoldingItemforStats = AllPlayerDataToSave.OrigamiBoatHoldingItemforStats or false
        data.MeteorRelative = AllPlayerDataToSave.MeteorRelative or 0
        data.MeteorPreviousCounter = AllPlayerDataToSave.MeteorPreviousCounter or 1
        data.FortuneTellerRelative = AllPlayerDataToSave.FortuneTellerRelative or 0
        data.FortuneTellerPreviousCounter = AllPlayerDataToSave.FortuneTellerPreviousCounter or 1
        data.FortuneTellerLuckBoost = AllPlayerDataToSave.FortuneTellerLuckBoost or 0
        data.BrokenFluxPreviousBrokenHearts = AllPlayerDataToSave.BrokenFluxPreviousBrokenHearts or -1
        data.BrokenFluxCharge = AllPlayerDataToSave.BrokenFluxCharge or 0
        data.OrigamiCrowRelative = AllPlayerDataToSave.OrigamiCrowRelative or 0
        data.OrigamiCrowPreviousCounter = AllPlayerDataToSave.OrigamiCrowPreviousCounter or 1
        data.BrokenBoxHeartFlag = AllPlayerDataToSave.BrokenBoxHeartFlag or false
        data.BrokenBoxItemFlag = AllPlayerDataToSave.BrokenBoxItemFlag or nil
        data.BrokenBoxMoneyFlag = AllPlayerDataToSave.BrokenBoxMoneyFlag or 0
        data.BrokenBoxBombFlag = AllPlayerDataToSave.BrokenBoxBombFlag or 0
        data.BrokenBoxKeyFlag = AllPlayerDataToSave.BrokenBoxKeyFlag or 0
        data.BrokenBoxStatus = AllPlayerDataToSave.BrokenBoxStatus or false
        data.AncientHookCounter = AllPlayerDataToSave.AncientHookCounter or 0
        data.RunicAltarEffects = AllPlayerDataToSave.RunicAltarEffects or {}

    elseif ShatteredSymbols:HasData() and (Game():GetFrameCount() == 0) then
        
        AllPlayerDataToSave = JsonSaveFile.decode(ShatteredSymbols:LoadData())

        data.BrokenBoxHeartFlag = AllPlayerDataToSave.BrokenBoxHeartFlag or false
        data.BrokenBoxItemFlag = AllPlayerDataToSave.BrokenBoxItemFlag or nil
        data.BrokenBoxMoneyFlag = AllPlayerDataToSave.BrokenBoxMoneyFlag or 0
        data.BrokenBoxBombFlag = AllPlayerDataToSave.BrokenBoxBombFlag or 0
        data.BrokenBoxKeyFlag = AllPlayerDataToSave.BrokenBoxKeyFlag or 0
        data.BrokenBoxStatus = AllPlayerDataToSave.BrokenBoxStatus or false
        
    else
        ShatteredSymbols:RemoveData()
    end

    AllPlayerDataToSave = {}
    
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
 EID:appendToDescription(descObj, "#After use it, have 7.5% chance to mutate into Extra Deck and 7.5% chance to mutate into Upside Down Deck")
    return descObj
end

function ShatteredSymbols:mutateDeck(_, rng, player)
    local mutateValue = rng:RandomFloat()
    if mutateValue < 0.075 then
        local ExtraDeckID = Isaac.GetItemIdByName("Extra Deck of Cards")
        for i = 0, 3 do
            local activeItem = player:GetActiveItem(i)
            if activeItem == DeckofCardID then
                player:RemoveCollectible(DeckofCardID, false, i)
                player:AddCollectible(ExtraDeckID, 0, false, i)
            end
        end
    elseif mutateValue > 0.925 then
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



