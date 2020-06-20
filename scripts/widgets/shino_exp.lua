local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local shino_exp = Class(Widget, function(self, owner)
    Widget._ctor(self, "shino_exp")
    self.owner = owner self:SetPosition(0, 0, 0) self:SetScale(1,1,1)
    self.num = self:AddChild(Text(BODYTEXTFONT, 33))
    self.num:SetHAlign(ANCHOR_MIDDLE)
    self.num:SetPosition(5, -50, 0)
    self.num:SetScale(.75,.75,.75)
    self.num:MoveToFront()
    self.num.current = owner.exp_current:value()
    self.num.max = owner.exp_max:value()
    self.num.level = owner.exp_level:value()
    self.percent = self.num.current/self.num.max
    self.anim = self:AddChild(UIAnim())
    self.anim:GetAnimState():SetBank("health")
    self.anim:GetAnimState():SetBuild("shino_exp")
    self.anim:GetAnimState():PlayAnimation("anim")
    self.anim:GetAnimState():SetPercent("anim", 1-self.percent)
    self.anim:SetClickable(true)
    self.num:SetString("level:"..tostring(self.num.level))
    owner:ListenForEvent("exp_maxdirty",function(owner,data)
        self.num.max = owner.exp_max:value()
        self.percent = self.num.current/self.num.max     end)
    owner:ListenForEvent("exp_leveldirty",function(owner,data)
        local level = owner.exp_level:value()
        self.num:SetString("level:"..tostring(level)) end)
    owner:ListenForEvent("exp_currentdirty",function(owner,data)
        self.num.current = owner.exp_current:value()
        self.percent = self.num.current/self.num.max end)
    self:StartUpdating()
end)

function shino_exp:OnUpdate(dt)
    self.anim:GetAnimState():SetPercent("anim", 1-self.percent)
end

return shino_exp