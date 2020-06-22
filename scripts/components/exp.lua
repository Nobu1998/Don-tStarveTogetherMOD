local function onmax(self,max)
    self.inst.exp_max:set(max)
end

local function oncurrent(self,current)
    self.inst.exp_current:set(current)
end

local function onlevel(self,level)
    self.inst.exp_level:set(level)
end

local exp = Class(function(self, inst) self.inst = inst
    self.maxtimepiont = 20
    self.currenttimepiont = 0
    self.levelpoint = 0
end, nil, { maxtimepiont = onmax, currenttimepiont = oncurrent, levelpoint = onlevel, })

function exp:DoDelta(delta)
    local val = self.currenttimepiont + delta
    if self.levelpoint == TUNING.ESCTEMPLATE_MAXLEVEL then
        self.currenttimepiont = self.maxtimepiont
    end
    while val >=self.maxtimepiont do
        if self.levelpoint < TUNING.ESCTEMPLATE_MAXLEVEL then
            self:LevelUp()
        else
            self.currenttimepiont =
            self.maxtimepiont
            return
        end
        val = val - self.maxtimepiont
    end

    self.currenttimepiont = val
end

function exp:GetPercent()
    return self.currenttimepiont / self.maxtimepiont
end

function exp:ApplyUpgrades()
    local hunger_percent = self.inst.components.hunger:GetPercent()
    local health_percent = self.inst.components.health:GetPercent()
    local sanity_percent = self.inst.components.sanity:GetPercent()
    local regen_percent = self.levelpoint * 0.5
    self.inst.components.hunger.max = TUNING.ESCTEMPLATE_MIN_HUNGER + self.levelpoint * TUNING.ESCTEMPLATE_LEVELBUFF
    self.inst.components.health.maxhealth = TUNING.ESCTEMPLATE_MIN_HEALTH + self.levelpoint * TUNING.ESCTEMPLATE_LEVELBUFF
    self.inst.components.sanity.max = TUNING.ESCTEMPLATE_MIN_SANITY + self.levelpoint * TUNING.ESCTEMPLATE_LEVELBUFF
    self.inst.components.health:StartRegen(regen_percent, 10)
    self.inst.components.hunger:SetPercent(hunger_percent)
    self.inst.components.health:SetPercent(health_percent)
    self.inst.components.sanity:SetPercent(sanity_percent)
end

function exp:LevelUp()
    self.levelpoint = self.levelpoint + 1
    self.currenttimepiont = 0
    self.maxtimepiont = self.maxtimepiont + 10
    self.inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
    self:ApplyUpgrades()
end

function exp:OnSave()
    return  {
        currenttimepiont = self.currenttimepiont,
        maxtimepiont = self.maxtimepiont,
        levelpoint = self.levelpoint,
    }
end

function exp:OnLoad(data)
    self.currenttimepiont = data.currenttimepiont
    self.maxtimepiont = data.maxtimepiont
    self.levelpoint = data.levelpoint
end

return exp