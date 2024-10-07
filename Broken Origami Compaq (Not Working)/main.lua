local BrokenOrigami = RegisterMod("Broken Origami", 1)
local sfx=SFXManager()
local Isaac.ConsoleOutput("\n".."... Broken Origami ...".."\n".."     Initializing".."\n")

local Item = {
    FIENDISH_SEED = Isaac.GetItemIdByName("Fiendish Seed"),
    SACRED_LANTERN = Isaac.GetItemIdByName("Sacred Lantern"),
    PAPER_SHURIKEN = Isaac.GetItemIdByName("Paper Shuriken"),
}
local Isaac.ConsoleOutput("        Loading".."\n")

local include("scripts/Script_Loader")

Isaac.ConsoleOutput("        Loaded".."\n")



-- samael example
local SCRIPTS = {
	"constants",
	"callbacks",
	"backdrop_data",
	"fade",
	"bag_o_bones",
	"death_pool",
	"mod_content",
	"active_item_rendering",
	
	"dss/dssmenu",
	"dss/changelogs",
	
	"fragment/fragment",
	"fragment/ferryman",
	"fragment/lost_soul",
	"fragment/custom_portal",
	"fragment/ferryman_room",
	
	--"special/teaser",
	
	"chars/samael",
	"chars/samael_ending",
	"chars/samael_birthright",
	"chars/memento_mori",
	"chars/memento_mori_emoji_glasses",
	
	"api_override",
	
	"items/denial",
	"items/anger",
	"items/bargaining",
	"items/depression",
	"items/acceptance",
	"items/punishment_of_the_grave",
	"items/remembrance_of_death",
	"items/remembrance_of_the_forgotten",
	"items/sigil_of_lilith",
	"items/sigil_of_samael",
	"items/soul_of_samael_and_reaper_bum",
	"items/thanatophilia_def",
	"items/thanatophilia",
	"items/thanatophobia",
	"items/thanatosis",
	"items/xiii",
	"items/xiii_reversed",
	"items/thanatos",
	"items/fragment_fragment",
	"items/jar_of_scythes",
	"items/wraith_skull",
	"items/trumpet_of_woe",
	
	"challenges/the_reaper",
	
	"extra_room_stuff",
}

lib.Log("Loading scripts...")
for _, script in ipairs(SCRIPTS) do
	include("samaelscripts/"..script)
end