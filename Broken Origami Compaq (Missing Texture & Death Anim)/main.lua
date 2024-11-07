BrokenOrigami = RegisterMod("Broken Origami", 1)

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
    'BrokenFlux'
}

for Load = 1, #ItemScript do
	require("script.item." .. ItemScript[Load])
end


function BrokenOrigami:SavePlayerData()
    local player = Isaac.GetPlayer(0)
    AllPlayerDataToSave = player:GetData()
    BrokenOrigami:SaveData(JsonSaveFile.encode(AllPlayerDataToSave)) 
end


function BrokenOrigami:LoadPlayerData()
    if BrokenOrigami:HasData() then
        local player = Isaac.GetPlayer(0)
        AllPlayerDataToSave = JsonSaveFile.decode(BrokenOrigami:LoadData())
        
        for key, value in pairs(AllPlayerDataToSave) do
            player:GetData()[key] = value
        end
    end
end

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
end

--BrokenOrigami:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, BrokenOrigami.SavePlayerData)

--BrokenOrigami:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, BrokenOrigami.LoadPlayerData)

BrokenOrigami:AddCallback(ModCallbacks.MC_EXECUTE_CMD,BrokenOrigami.ExecuteConsoleCommand)