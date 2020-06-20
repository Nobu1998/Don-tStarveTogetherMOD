local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

local start_inv = {
    "flint",
    "flint",
    "twigs",
    "twigs",
    "spear",
}

local BEAVERVISION_COLOURCUBES = { night = "images/colour_cubes/beaver_vision_cc.tex", }

--攻撃時に呼び出し
local function onattack(inst, data)
    local victim = data.target
    local exp = victim.components.health:GetMaxWithPenalty() * 0.02
    inst.components.exp:DoDelta(exp)
end

--被攻撃時に呼び出し
local function OnAttacked(inst, data)
    inst.components.sanity:DoDelta(-5)
    data.attacker.components.health:DoDelta(-50)
end

local function onkill(inst)
    inst.components.health:DoDelta(15)
    inst.components.sanity:DoDelta(15)
end

local function onload(inst)
    if inst.components and inst.components.exp then
        inst.components.exp:ApplyUpgrades()
    end
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst)
    inst:AddTag("woodcutter")
    inst:AddTag("shino")
    -- Minimap icon
    inst.MiniMapEntity:SetIcon( "esctemplate.tex" )
    inst.soundsname = "willow"
    if inst:HasTag("nightvision") then
        inst.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
    end
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- Stats
	inst.components.health:SetMaxHealth(TUNING.ESCTEMPLATE_MIN_HEALTH)
	inst.components.hunger:SetMax(TUNING.ESCTEMPLATE_MIN_HUNGER)
	inst.components.sanity:SetMax(TUNING.ESCTEMPLATE_MIN_SANITY)
    inst.components.health:StartRegen(0.5, 0.5)

    --被攻撃時に呼び出し
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("killed", onkill)
    inst:ListenForEvent("onattackother", onattack)
    inst.OnLoad = onload

	inst.components.hunger.hungerrate = 0.5
end

return MakePlayerCharacter("esctemplate", prefabs, assets, common_postinit, master_postinit, start_inv)
