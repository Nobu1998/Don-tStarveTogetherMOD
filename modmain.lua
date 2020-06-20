PrefabFiles = {
	"esctemplate",
	"esctemplate_none",
    "palalysis_spear",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/esctemplate.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/esctemplate.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/esctemplate.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/esctemplate.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/esctemplate_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/esctemplate_silho.xml" ),

    Asset( "IMAGE", "bigportraits/esctemplate.tex" ),
    Asset( "ATLAS", "bigportraits/esctemplate.xml" ),
	
	Asset( "IMAGE", "images/map_icons/esctemplate.tex" ),
	Asset( "ATLAS", "images/map_icons/esctemplate.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_esctemplate.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_esctemplate.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_esctemplate.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_esctemplate.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_esctemplate.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_esctemplate.xml" ),
	
	Asset( "IMAGE", "images/names_esctemplate.tex" ),
    Asset( "ATLAS", "images/names_esctemplate.xml" ),
	
	Asset( "IMAGE", "images/names_gold_esctemplate.tex" ),
    Asset( "ATLAS", "images/names_gold_esctemplate.xml" ),

    Asset("ATLAS", "images/inventoryimages/palalysis_spear.xml"),
}

AddMinimapAtlas("images/map_icons/esctemplate.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- Your character's stats
TUNING.ESCTEMPLATE_MIN_HEALTH = 90
TUNING.ESCTEMPLATE_MIN_HUNGER = 150
TUNING.ESCTEMPLATE_MIN_SANITY = 150
TUNING.ESCTEMPLATE_REGENE = 0.5
TUNING.ESCTEMPLATE_DAMAGE = 50
TUNING.ESCTEMPLATE_MAXLEVEL = 20
TUNING.ESCTEMPLATE_LEVELBUFF = 5

local shino_exp = require("widgets/shino_exp")

local function AddExp(self)
    if self.owner and self.owner:HasTag("shino") then
        self.shino_exp = self.status:AddChild(shino_exp(self.owner))
        self.shino_exp:SetPosition(-80,-40,0)
    end
end
AddClassPostConstruct("widgets/controls", AddExp)
AddPlayerPostInit(function(inst)
    if inst:HasTag("shino") then
        inst.exp_max = GLOBAL.net_shortint(inst.GUID, "exp_max", "exp_maxdirty")
        inst.exp_current = GLOBAL.net_shortint(inst.GUID, "exp_current", "exp_currentdirty")
        inst.exp_level = GLOBAL.net_shortint(inst.GUID, "exp_level", "exp_leveldirty")
        if GLOBAL.TheWorld.ismastersim then
            inst:AddComponent("exp")
        end
    end
end)

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local TECH = GLOBAL.TECH

STRINGS.NAMES.PALALYSISSPEAR = "Palalysis Spear"
STRINGS.RECIPE_DESC.GOLDENSPEAR = "Be a God Amongst Mortals"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDENSPEAR = "It's Power is..... ?????"

AddRecipe("palalysis_spear", {
    Ingredient("spear", 1),
    Ingredient("monstermeat", 10),
},
        RECIPETABS.WAR,
        TECH.SCIENCE_TWO,
        nil, nil, nil, nil, nil,
        "images/inventoryimages/palalysis_spear.xml", "palalysis_spear.tex"
)

-- The character select screen lines
STRINGS.CHARACTER_TITLES.esctemplate = "The Sample Character"
STRINGS.CHARACTER_NAMES.esctemplate = "Esc"
STRINGS.CHARACTER_DESCRIPTIONS.esctemplate = "*Perk 1\n*Perk 2\n*Perk 3"
STRINGS.CHARACTER_QUOTES.esctemplate = "\"Quote\""
STRINGS.CHARACTER_SURVIVABILITY.esctemplate = "Slim"

-- Custom speech strings
STRINGS.CHARACTERS.ESCTEMPLATE = require "speech_esctemplate"

-- The character's name as appears in-game 
STRINGS.NAMES.ESCTEMPLATE = "Esc"
STRINGS.SKIN_NAMES.esctemplate_none = "Esc"

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("esctemplate", "FEMALE", skin_modes)
