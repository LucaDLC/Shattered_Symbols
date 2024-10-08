BrokenOrigami = RegisterMod("Broken Origami", 1)

local Item = {'SacredLantern','FortuneTeller','OrigamiShuriken','OrigamiBoat','UpsideDownDeckofCard','Constellation','Meteor'}


for i = 1, #Item do
	require (Item[i])
end





