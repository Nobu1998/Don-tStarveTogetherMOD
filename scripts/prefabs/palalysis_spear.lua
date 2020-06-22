local assets =
{
    Asset("ANIM", "anim/goldenspear.zip"),
    Asset("ANIM", "anim/gold_spear.zip"),
    Asset("IMAGE", "images/inventoryimages/palalysis_spear.tex"),
    Asset("ATLAS", "images/inventoryimages/palalysis_spear.xml"),
}

local function onattack_parasite(data, inst)
    local percent = math.random(1, 10)
    inst.components.health:DoDelta(100)
    if data and data.brain and data.dosfleurstun ~= true then
        inst.components.health:DoDelta(100)
        data.dosfleurstun = true
        data.brain:Stop()
        if data.components.locomotor then
            data.components.locomotor:Stop()
        end
        data:DoTaskInTime(4, function()
            data.brain:Start()
            data.dosfleurstun = nil
        end)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "gold_spear", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spear")
    inst.AnimState:SetBuild("goldenspear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    if not TheWorld.ismastersim then
        return inst
    end

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(onattack_parasite)
    inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE)


    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)

    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/palalysis_spear.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

STRINGS.NAMES.PALALYSISSPEAR = "Palalysis Spear"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PALALYSISSPEAR = "It's Power is..... ?????"

return Prefab("common/inventory/palalysis_spear", fn, assets)