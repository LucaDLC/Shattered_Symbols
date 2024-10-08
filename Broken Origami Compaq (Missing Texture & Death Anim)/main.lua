BrokenOrigami = RegisterMod("Broken Origami", 1)

local Script = {'SacredLantern','FortuneTeller','OrigamiShuriken','OrigamiBoat','UpsideDownDeckofCard','Constellation','Meteor'}

for i = 1, #Script do
	require (Script[i])
end

UpsideDownDeckofCardsID = Isaac.GetItemIdByName("Upside Down Deck of Cards")
SacredLanternID = Isaac.GetItemIdByName("Sacred Lantern")
OrigamiShurikenID = Isaac.GetItemIdByName("Origami Shuriken")
OrigamiBoatID = Isaac.GetItemIdByName("Origami Boat")
MeteorID = Isaac.GetItemIdByName("Meteor")
FortuneTellerID = Isaac.GetItemIdByName("Fortune Teller")
ConstellationID = Isaac.GetItemIdByName("Constellation")
