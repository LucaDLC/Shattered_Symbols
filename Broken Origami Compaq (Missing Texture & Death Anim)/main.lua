BrokenOrigami = RegisterMod("Broken Origami", 1)

local Script = {'SacredLantern','FortuneTeller','OrigamiShuriken','OrigamiBoat','UpsideDownDeckofCard','Constellation','Meteor'}

for i = 1, #Script do
	require (Script[i])
end

local UpsideDownDeckofCardsID = Isaac.GetItemIdByName("Upside Down Deck of Cards")
local SacredLanternID = Isaac.GetItemIdByName("Sacred Lantern")
local OrigamiShurikenID = Isaac.GetItemIdByName("Origami Shuriken")
local OrigamiBoatID = Isaac.GetItemIdByName("Origami Boat")
local MeteorID = Isaac.GetItemIdByName("Meteor")
local FortuneTellerID = Isaac.GetItemIdByName("Fortune Teller")
local ConstellationID = Isaac.GetItemIdByName("Constellation")

function BrokenOrigami:UpsideDownDeckofCardsID()
	return {
        UpsideDownDeckofCardsID
    }
end

function BrokenOrigami:SacredLanternID()
	return {
        SacredLanternID
    }
end

function BrokenOrigami:OrigamiShurikenID()
	return {
        OrigamiShurikenID
    }
end

function BrokenOrigami:OrigamiBoatID()
	return {
        OrigamiBoatID
    }
end

function BrokenOrigami:MeteorID()
	return {
        MeteorID
    }
end

function BrokenOrigami:FortuneTellerID()
	return {
        FortuneTellerID
    }
end

function BrokenOrigami:ConstellationID()
	return {
        ConstellationID
    }
end