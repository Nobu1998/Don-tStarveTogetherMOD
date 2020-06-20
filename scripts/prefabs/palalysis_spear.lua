local assets =
{
    Asset("ANIM", "anim/spear.zip"),
    Asset("ANIM", "anim/swap_spear.zip"),
    Asset("ANIM", "anim/floating_items.zip"),

    Asset("ANIM", "anim/palalysisspear.zip"),
    Asset("ANIM", "anim/palalysis_spear.zip"),
    Asset("ATLAS", "images/inventoryimages/palalysis_spear.xml"),
}

local function onattack_doffyparasite(target, inst)
    local percent = math.random(1, 10)
    inst.components.health:DoDelta(100)
    if target and target.brain and target.dosfleurstun ~= true then
        target.dosfleurstun = true
        target.brain:Stop()
        if target.components.locomotor then
            target.components.locomotor:Stop()
        end
        target:DoTaskInTime(4, function()
            target.brain:Start()
            target.dosfleurstun = nil
        end)
    end
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_spear", inst.GUID, "swap_spear")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spear")
    inst.AnimState:SetBuild("swap_spear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(onattack_doffyparasite)
    inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE)


    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)

    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "Palalysis Spear"
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