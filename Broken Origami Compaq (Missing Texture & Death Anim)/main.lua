BrokenOrigami = RegisterMod("Broken Origami", 1)

---------------------------------------------------------
--/////////////////////////////////////////////////////--
----------------------Settings---------------------------
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
---------------------------------------------------------

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
    'Girlfriend',
    'TornHook',
    'WrigglingShadow',
    'OrigamiCrow',
    'OrigamiKolibri',
    'BrokenFlux',
    'OrigamiNightingale',
    'BrokenBox',
    'MidnightBite',
    'ExtraDeckofCard',
    'AncientHook'
}

for Load = 1, #ItemScript do
    require("script.item." .. ItemScript[Load])
end

--------------------- Save Datas ---------------------

function BrokenOrigami:SavePlayerData()
    local player = Isaac.GetPlayer(0)
    local data = player:GetData()

    AllPlayerDataToSave = {
        OrigamiSwanRelative = data.OrigamiSwanRelative or 0,
        OrigamiSwanPreviousCounter = data.OrigamiSwanPreviousCounter or 1,
        OrigamiShurikenRelative = data.OrigamiShurikenRelative or 0,
        OrigamiShurikenPreviousCounter = data.OrigamiShurikenPreviousCounter or 1,
        OrigamiShurikenDamageBoost = data.OrigamiShurikenDamageBoost or 0,
        OrigamiKolibriRelative = data.OrigamiKolibriRelative or 0,
        OrigamiKolibriPreviousCounter = data.OrigamiKolibriPreviousCounter or 1,
        OrigamiKolibriTearsCount = data.OrigamiKolibriTearsCount or 0,
        OrigamiKolibriSpeedBoost = data.OrigamiKolibriSpeedBoost or 0,
        OrigamiKolibriLimit = data.OrigamiKolibriLimit or 0,
        OrigamiCrowChargeMemory = data.OrigamiCrowChargeMemory or {},
        OrigamiCrowRelative = data.OrigamiCrowRelative or 0,
        OrigamiCrowPreviousCounter = data.OrigamiCrowPreviousCounter or 1,
        OrigamiBoatBrokenHeartsCount = data.OrigamiBoatBrokenHeartsCount or 0,
        OrigamiBoatHoldingItemforStats = data.OrigamiBoatHoldingItemforStats or false,
        MeteorRelative = data.MeteorRelative or 0,
        MeteorPreviousCounter = data.MeteorPreviousCounter or 1,
        FortuneTellerRelative = data.FortuneTellerRelative or 0,
        FortuneTellerPreviousCounter = data.FortuneTellerPreviousCounter or 1,
        FortuneTellerLuckBoost = data.FortuneTellerLuckBoost or 0,
        BrokenFluxPreviousBrokenHearts = data.BrokenFluxPreviousBrokenHearts or -1,
        BrokenFluxCharge = data.BrokenFluxCharge or 0,
        OrigamiNightingaleRelative = data.OrigamiNightingaleRelative or 0,
        OrigamiNightingalePreviousCounter = data.OrigamiNightingalePreviousCounter or 1,
        BrokenBoxHeartFlag = data.BrokenBoxHeartFlag or false,
        BrokenBoxItemFlag = data.BrokenBoxItemFlag or nil,
        BrokenBoxMoneyFlag = data.BrokenBoxMoneyFlag or 0,
        BrokenBoxBombFlag = data.BrokenBoxBombFlag or 0,
        BrokenBoxKeyFlag = data.BrokenBoxKeyFlag or 0,
        BrokenBoxStatus = data.BrokenBoxStatus or false,
        AncientHookCounter= data.AncientHookCounter or 0,
    }

    BrokenOrigami:SaveData(JsonSaveFile.encode(AllPlayerDataToSave))
    AllPlayerDataToSave = {}

end

--------------------- Load Saves ---------------------

function BrokenOrigami:LoadPlayerData()
    local player = Isaac.GetPlayer(0)
    local data = player:GetData()

    if BrokenOrigami:HasData() and (Game():GetFrameCount() > 0) then

        AllPlayerDataToSave = JsonSaveFile.decode(BrokenOrigami:LoadData())

        data.OrigamiSwanRelative = AllPlayerDataToSave.OrigamiSwanRelative or 0
        data.OrigamiSwanPreviousCounter = AllPlayerDataToSave.OrigamiSwanPreviousCounter or 1
        data.OrigamiShurikenRelative = AllPlayerDataToSave.OrigamiShurikenRelative or 0
        data.OrigamiShurikenPreviousCounter = AllPlayerDataToSave.OrigamiShurikenPreviousCounter or 1
        data.OrigamiShurikenDamageBoost = AllPlayerDataToSave.OrigamiShurikenDamageBoost or 0
        data.OrigamiKolibriRelative = AllPlayerDataToSave.OrigamiKolibriRelative or 0
        data.OrigamiKolibriPreviousCounter = AllPlayerDataToSave.OrigamiKolibriPreviousCounter or 1
        data.OrigamiKolibriTearsCount = AllPlayerDataToSave.OrigamiKolibriTearsCount or 0
        data.OrigamiKolibriSpeedBoost = AllPlayerDataToSave.OrigamiKolibriSpeedBoost or 0
        data.OrigamiKolibriLimit = AllPlayerDataToSave.OrigamiKolibriLimit or 0
        data.OrigamiCrowChargeMemory = AllPlayerDataToSave.OrigamiCrowChargeMemory or {}
        data.OrigamiCrowRelative = AllPlayerDataToSave.OrigamiCrowRelative or 0
        data.OrigamiCrowPreviousCounter = AllPlayerDataToSave.OrigamiCrowPreviousCounter or 1
        data.OrigamiBoatBrokenHeartsCount = AllPlayerDataToSave.OrigamiBoatBrokenHeartsCount or 0
        data.OrigamiBoatHoldingItemforStats = AllPlayerDataToSave.OrigamiBoatHoldingItemforStats or false
        data.MeteorRelative = AllPlayerDataToSave.MeteorRelative or 0
        data.MeteorPreviousCounter = AllPlayerDataToSave.MeteorPreviousCounter or 1
        data.FortuneTellerRelative = AllPlayerDataToSave.FortuneTellerRelative or 0
        data.FortuneTellerPreviousCounter = AllPlayerDataToSave.FortuneTellerPreviousCounter or 1
        data.FortuneTellerLuckBoost = AllPlayerDataToSave.FortuneTellerLuckBoost or 0
        data.BrokenFluxPreviousBrokenHearts = AllPlayerDataToSave.BrokenFluxPreviousBrokenHearts or -1
        data.BrokenFluxCharge = AllPlayerDataToSave.BrokenFluxCharge or 0
        data.OrigamiNightingaleRelative = AllPlayerDataToSave.OrigamiNightingaleRelative or 0
        data.OrigamiNightingalePreviousCounter = AllPlayerDataToSave.OrigamiNightingalePreviousCounter or 1
        data.BrokenBoxHeartFlag = AllPlayerDataToSave.BrokenBoxHeartFlag or false
        data.BrokenBoxItemFlag = AllPlayerDataToSave.BrokenBoxItemFlag or nil
        data.BrokenBoxMoneyFlag = AllPlayerDataToSave.BrokenBoxMoneyFlag or 0
        data.BrokenBoxBombFlag = AllPlayerDataToSave.BrokenBoxBombFlag or 0
        data.BrokenBoxKeyFlag = AllPlayerDataToSave.BrokenBoxKeyFlag or 0
        data.BrokenBoxStatus = AllPlayerDataToSave.BrokenBoxStatus or false
        data.AncientHookCounter = AllPlayerDataToSave.AncientHookCounter or 0

    elseif BrokenOrigami:HasData() and (Game():GetFrameCount() == 0) then
        
        AllPlayerDataToSave = JsonSaveFile.decode(BrokenOrigami:LoadData())

        data.BrokenBoxHeartFlag = AllPlayerDataToSave.BrokenBoxHeartFlag or false
        data.BrokenBoxItemFlag = AllPlayerDataToSave.BrokenBoxItemFlag or nil
        data.BrokenBoxMoneyFlag = AllPlayerDataToSave.BrokenBoxMoneyFlag or 0
        data.BrokenBoxBombFlag = AllPlayerDataToSave.BrokenBoxBombFlag or 0
        data.BrokenBoxKeyFlag = AllPlayerDataToSave.BrokenBoxKeyFlag or 0
        data.BrokenBoxStatus = AllPlayerDataToSave.BrokenBoxStatus or false
        
    else
        BrokenOrigami:RemoveData()
    end

    AllPlayerDataToSave = {}
    
end

--------------------- Console Command ---------------------

function BrokenOrigami:ExecuteConsoleCommand(_, Command) 
    if Command == "Launch" then 
        for Load = 1, #ItemScript do
            require("script.item." .. ItemScript[Load])
        end
        print("Broken Origami: Scripts Launched")
    end
    if Command == "Script" then 
        for Load = 1, #ItemScript do
            print("script.item." .. ItemScript[Load])
        end
    end
    if Command == "Erase" then
        local room = Game():GetRoom()
        if room:GetType() == RoomType.ROOM_NULL then
            BrokenOrigami:RemoveData()
            print("Data Erased")
        else
            print("For using this command, you must be not in game")
        end
    end

end

BrokenOrigami:AddCallback(ModCallbacks.MC_EXECUTE_CMD,BrokenOrigami.ExecuteConsoleCommand)

BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, BrokenOrigami.SavePlayerData)

BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, BrokenOrigami.LoadPlayerData)


---------------------------------------------------------
--/////////////////////////////////////////////////////--
--------------------Integrations-------------------------
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
---------------------------------------------------------

--------------------- Deck of Card ---------------------

if EID then
    EID:addDescriptionModifier("MutableDeckofCard", isDeckofCard, mutableDeckofCard)
end

local function isDeckofCard(descObj)
    if descObj.ObjType == 5 and descObj.ObjVariant == 100 and descObj.ObjSubType == 85 then return true end
end
local function mutableDeckofCard(descObj)
 EID:appendToDescription(descObj, "#After use have 7.5% chance to mutate into Extra Deck and 7.5% chance to mutate into Upside Down Deck")
    return descObj
end

function BrokenOrigami:mutateDeck(_, rng, player)
    local mutateValue = rng:RandomFloat()
    if mutateValue < 0.075 then
        for i = 0, 3 do
            local activeItem = player:GetActiveItem(i)
            if activeItem == DeckofCardID then
                player:RemoveCollectible(DeckofCardID, false, i)
                player:AddCollectible(ExtraDeckLocalID, 0, false, i)
            end
        end
    elseif mutateValue > 0.925 then
        for i = 0, 3 do
            local activeItem = player:GetActiveItem(i)
            if activeItem == DeckofCardID then
                player:RemoveCollectible(DeckofCardID, false, i)
                player:AddCollectible(UpsideDownDeckofCardsLocalID, 0, false, i)
            end
        end
    end
end

BrokenOrigami:AddCallback(ModCallbacks.MC_USE_ITEM, BrokenOrigami.mutateDeck, DeckofCardID)



