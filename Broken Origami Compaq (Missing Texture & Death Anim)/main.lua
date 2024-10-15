BrokenOrigami = RegisterMod("Broken Origami", 1)

local Script = {
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
    'WrigglingShadow'
}

for i = 1, #Script do
	require (Script[i])
end
