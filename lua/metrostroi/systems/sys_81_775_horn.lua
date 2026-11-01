Metrostroi.DefineSystem("81_775_Horn")
TRAIN_SYSTEM.DontAccelerateSimulation = true

local HORN_SOUND     = "horn1"
local DEBOUNCE_TIME  = 0.04
local MIN_ON_TIME    = 0.16
local MIN_AIR        = 0.08
local MIN_PITCH      = 0.6

function TRAIN_SYSTEM:Initialize()
    self.Active = false
    self.ActiveA = false
    self.ActiveR = false
end

function TRAIN_SYSTEM:Outputs()
    return { "Active" }
end

function TRAIN_SYSTEM:Inputs()
    return { "Engage","EngageR" }
end

function TRAIN_SYSTEM:TriggerInput(name,value)
    if name == "Engage" then
        self.Active = value > 0.5
        self.ActiveA = value > 0.5
    end
    if name == "EngageR" then
        self.ActiveR = value > 0.5
    end
end

function TRAIN_SYSTEM:Think()
    local Train = self.Train
    local power = (Train.Electric.Power or 0) > 0
    Train:SetPackedBool("HornPedalR",self.ActiveR)
    Train:SetPackedBool("HornPedal",self.ActiveA)
    Train:SetNW2Bool("HornState",((self.Active and power) or self.ActiveR or (Train.Electric.V1 or 0) > 0) and true or false)
end

function TRAIN_SYSTEM:ClientInitialize()
    self.HornOn      = false
    self.RawState    = false
    self.RawSince    = CurTime()
    self.OnSince     = 0
    self.Volume      = 0
    self.Pitch       = 1
end

function TRAIN_SYSTEM:ClientThink(dT)
    local Train = self.Train
    if self.HornOn == nil then self:ClientInitialize() end
    local now = CurTime()
    dT = dT or 0.05

    local raw = Train:GetNW2Bool("HornState",false)
    local tl  = Train:GetPackedRatio("TL")

    if raw ~= self.RawState then
        self.RawState = raw
        self.RawSince = now
    end
    local want = self.HornOn
    if now - self.RawSince >= DEBOUNCE_TIME then want = self.RawState end

    if tl < MIN_AIR then want = false end

    if want and not self.HornOn then
        self.HornOn = true
        self.OnSince = now
        self.Volume = 1 - math.exp(-4*math.max(tl,MIN_AIR))
        self.Pitch  = math.max(MIN_PITCH,1 - math.exp(-10*math.max(tl,MIN_AIR)))
    elseif not want and self.HornOn and (now - self.OnSince) >= MIN_ON_TIME then
        self.HornOn = false
    end

    if self.HornOn then
        local tv = 1 - math.exp(-4*tl)
        local tp = math.max(MIN_PITCH,1 - math.exp(-10*tl))
        local k = math.min(1,dT*8)
        self.Volume = self.Volume + (tv - self.Volume)*k
        self.Pitch  = self.Pitch  + (tp - self.Pitch)*k
        Train:SetSoundState(HORN_SOUND,self.Volume,self.Pitch,nil,1.09)
    else
        Train:SetSoundState(HORN_SOUND,0,1,nil,1.09)
    end
end
