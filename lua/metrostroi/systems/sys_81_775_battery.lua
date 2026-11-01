Metrostroi.DefineSystem("81_775_Battery")
TRAIN_SYSTEM.DontAccelerateSimulation = false

local function clamp(x, min, max)
    return math.min(max or 1, math.max(min or 0, x))
end

function TRAIN_SYSTEM:Initialize()
    self.FactoryCapacity = 120 * 3600
    self.Capacity = self.FactoryCapacity
    self.PsnMaxCurrent = 150
    self.InternalResist = 0.04
    self.ChargeSumResist = 0.32
    self.FactoryChargedVoltage = 77
    self.RuinedVoltage = 40

    self.Load = 0
    self.ChargeVoltage = 0
    self.ChargeMaxCurrent = 30

    self.Charge = self.Capacity
    self.Voltage = 80
    self.LoadCurrent = 0
    self.Current = 0
    self.Value = 1

    self.Infinite = false

    self.TimeScale = 10
end

function TRAIN_SYSTEM:Inputs()
    return { "SetInfinite", "SetTimeScale", "Load", "Charge", "Current", "SetCapacity", "SetLevel", "Set", "Open", "Close" }
end

function TRAIN_SYSTEM:Outputs()
    return { "FactoryCapacity", "Capacity", "Load", "ChargeVoltage", "Charge", "Voltage", "Current", "LoadCurrent", "Value" }
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if name == "SetInfinite" then self.Infinite = value > 0 end
    if name == "SetTimeScale" and value then self.TimeScale = math.max(1, value) end

    if not value then return end
    if name == "Set" or name == "Open" or name == "Close" then return end

    if name == "Load" then
        self.Load = value
    elseif name == "Charge" then
        self.ChargeVoltage = value
    elseif name == "ChargeMaxCurrent" then
        self.ChargeMaxCurrent = value

    elseif name == "Current" then
        self.Current = value

    elseif name == "SetCapacity" then
        local k = math.min(1, self.Charge / self.Capacity)
        self.Capacity = value
        self.Charge = value * k
    elseif name == "SetLevel" then
        self.Charge = value * self.Capacity
    end
end

local S = {}
function TRAIN_SYSTEM:Think(dT)
    S.ChrgK = self.Charge / self.Capacity
    S.Ubias = math.pow(clamp(self.Capacity / self.FactoryCapacity), 0.125) * (self.FactoryChargedVoltage - self.RuinedVoltage)
    S.Ubase = self.RuinedVoltage + S.Ubias * math.pow(S.ChrgK, .65)

    S.Iload = self.Load / S.Ubase
    S.Ubat = S.Ubase - S.Iload * self.InternalResist

    self.Voltage = math.max(S.Ubat + 0.3 * (S.Ubase - S.Ubat), self.ChargeVoltage)
    S.Iload = self.Load / math.max(1, self.Voltage)

    S.Icharge = clamp((self.ChargeVoltage - S.Ubat) / self.ChargeSumResist, 0, self.ChargeMaxCurrent)
    S.Icharge = S.Icharge * math.pow(1 - clamp((self.Charge / self.Capacity - 0.95) / 0.05), 2)
    S.Ioverload = math.max(0, S.Iload - (self.ChargeVoltage >= S.Ubat and (self.PsnMaxCurrent - S.Icharge) or 0))

    self.LoadCurrent = S.Iload
    self.Current = S.Icharge - S.Ioverload
    self.Value = self.Voltage > 55 and 1 or 0
    if not self.Infinite then
        self.Charge = math.min(self.Capacity, math.max(0, self.Charge + self.Current * dT * (self.TimeScale or 1)))
    end
end
