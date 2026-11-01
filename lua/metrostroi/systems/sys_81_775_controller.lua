Metrostroi.DefineSystem("81_775_Controller")

TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
    self.Controller = 0
    self.EmergencyBrake = false

    self.Speed = 90
    self.DeltaController = 0
end

function TRAIN_SYSTEM:Inputs()
    return { "KVUp", "KVDown", "KVEmergencyBrake", "KV1","KV2", "KV3", "KV4", "KV5","KV6", "KV7", "KV8" }
end

function TRAIN_SYSTEM:Outputs()
    return { "Controller", "EmergencyBrake" }
end

function TRAIN_SYSTEM:TriggerInput(name, val)
    if name == "KVUp" then
        if val == 1 then
            self.DeltaController = self.Speed/100

            if self.Controller == -0.2 then
                self.Controller = 0
                self.DeltaController = 0
            end
        else
            self.DeltaController = 0
        end
    end

    if name == "KVDown" then
        if val == 1 then
            self.DeltaController = -self.Speed/100

            if self.Controller == 0.2 then
                self.Controller = 0
                self.DeltaController = 0
            end
        else
            self.DeltaController = 0
        end
    end

    if name == "KV4" then
        self.Controller = 0
    end
    if name == "KV1" then
        self.Controller = 0.20
    end
    if name == "KV2" then
        self.Controller = 0.50
    end
    if name == "KV3" then
        self.Controller = 1
    end
    if name == "KV5" then
        self.Controller = -0.20
    end
    if name == "KV6" then
        self.Controller = -0.50
    end
    if name == "KV7" then
        self.Controller = -0.95
    end
    if name == "KV8" then
        self.Controller = -1
    end
end

local function Clamp(x, min, max)
    return math.min(math.max(x,min),max)
end

function TRAIN_SYSTEM:Think(dT)
    local pos = self.Controller

    self.Controller = Clamp(self.Controller + self.DeltaController*dT, -1.1, 1)

    if pos ~= 0 and pos > 0 then
        self.Controller = Clamp(self.Controller, 0.2, 1)
    end

    if pos ~= 0 and pos < 0 then
        self.Controller = Clamp(self.Controller, -1, -0.2)
        self.EmergencyBrake = self.Controller == -1
    end

end
