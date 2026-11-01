Metrostroi.DefineSystem("81_775_Electric_new")

TRAIN_SYSTEM.T775 = 0
TRAIN_SYSTEM.T776 = 1
TRAIN_SYSTEM.T777 = 2

local function Rand(a,b)
	return a+(b-a)*math.random()
end

local function Clamp(val,min,max)
	return math.max(min,math.min(max,val))
end

function TRAIN_SYSTEM:Initialize()
	self.Type = self.Type or self.T775
	self.HaveBUKP = 0
	self.HaveAsyncInverter = 0

	self.PV1 = 0
	self.PV2 = 0
	self.Power = 0
	self.V1 = 0
	self.Main750V = 0.0
	self.Aux750V = 0.0
	self.KTI = 0
	self.C1 = 0

	self.PSN = 0
	self.MK = 0

    self.AsyncEmer = 0
    self.AsyncActive = 0
    self.Reverser = 0

    self.Recurperation = 0
    self.Iexit = 0
    self.Chopper = 0
    self.ChopperTimeout = 0

    self.CabActive = 0
	self.Active = 0

	self.ElectricEnergyUsed = 0
	self.ElectricEnergyDissipated = 0
	self.EnergyChange = 0

	self.DoorClose = false
	self.DoorSelectLeft = false
	self.DoorSelectRight = false
	self.DoorOpenLeft = false
	self.DoorOpenRight = false
	self.V0 = false

	self.BUFT = 0

    self.V1 = 0

	self.Train:LoadSystem("Battery","81_775_Battery")
	self.PsnRand = nil
	self.AKB = 0
	self.Train:LoadSystem("K2","Relay","")
    self.Train:LoadSystem("K2On","Relay",nil,{bass=true,open_time=0,close_time=Rand(0.01,0.1)})
    self.Train:LoadSystem("K2Off","Relay",nil,{bass=true,open_time=0,close_time=Rand(60,70)/10})
	self.Train:LoadSystem("KN", "Relay","")
	self.Train:LoadSystem("BV", "Relay","")
	self.Train:LoadSystem("GV", "Relay", "GV_10ZH", {bass=true})
	self.Train:LoadSystem("FU1","Relay","Switch",{bass = true,normally_closed = true})
	self.Train:LoadSystem("FU2","Relay","Switch",{bass = true,normally_closed = true})
	self.Train:LoadSystem("FU3","Relay","Switch",{bass = true,normally_closed = true})
	self.Train:LoadSystem("FU4","Relay","Switch",{bass = true,normally_closed = true})
	self.Train:LoadSystem("FU5","Relay","Switch",{bass = true,normally_closed = true})

end

function TRAIN_SYSTEM:Inputs()
		return {"Type","Active",}
end

function TRAIN_SYSTEM:Outputs()
	return {
		"Main750V",
		"Aux750V",
		"PSN",
		"MK",
		"Power",
		"Type",
		"KTI",
		"AsyncEmer","AsyncActive","Reverser",
		"CabActive","Active",
		"PV1","PV2",
		"Recurperation","Iexit","Chopper","ElectricEnergyUsed","ElectricEnergyDissipated","EnergyChange","Itotal",
		"BUFT",
		"AKB",
		"V1",
		"HaveAsyncInverter","HaveBUKP",
	}
end

local function C(x) return x and 1 or 0 end
local function IsOn(v) return v == true or (type(v) == "number" and v > 0) end

local TractionFade = {{0,1},{50,1},{60,0.94},{70,0.875},{80,0.81},{90,0.75},{100,0.69},{120,0.58}}
local function TractionFadeAt(v)
	for i = 1, #TractionFade-1 do
		local a, b = TractionFade[i], TractionFade[i+1]
		if v <= b[1] then return a[2] + (b[2]-a[2])*Clamp((v-a[1])/(b[1]-a[1]),0,1) end
	end
	return TractionFade[#TractionFade][2]
end


function TRAIN_SYSTEM:TriggerInput(name,value)
	if name == "Type" then
		self.Type = value
		self.HaveBUKP = self.Type==self.T775 and 1 or 0
		self.HaveAsyncInverter = self.Type<self.T777 and 1 or 0
	else
		self[name] = value
	end
end
local S = {}
local min = math.min

local wires = {
	1,
	2,
	5,
	6,
	7,
	8,
	14,
	15,
	16,
	17,
	18,
	19,
	21,
	22,
	23,
	31,
	41,
	42,
	43,
	44,
	45,
	46,
	51,
	52,
	53,
	54,
	55,
	56,
	57,
	61,
	62,
	63,
	64,
	65,
	66,
}

function TRAIN_SYSTEM:Think(dT)
	local Train = self.Train
	local Panel = Train.Panel
	local RawBUV = Train.BUV
	local BUV = setmetatable({},{__index=function(_,k) local v = RawBUV[k] if v == nil and k ~= "State" then return 0 end return v end})
	dT = dT or Train.DeltaTime or 0.05

	local W  = Train.TrainWires
	if not W then
		W = {}
		for _,v in ipairs(wires) do W[v] = 0 end
		Train.TrainWires = W
	end
	for _,v in ipairs(wires) do W[v] = min(Train:ReadTrainWire(v),1) end

	local ishead = self.HaveBUKP > 0
	local hasengine = self.HaveAsyncInverter > 0

	self.Main750V = Train.TR.Main750V
	self.Aux750V = self.Main750V
	self.Power = Train.K2.Value

	local PSN = self.Aux750V*Train.FU2.Value
	if hasengine then
		local KTI = self.Main750V*Train.FU1.Value*Train.GV.Value
		self.KTI = KTI
	end
	if ishead then
	end

	local OB = self.Power

	local Battery = Train.Battery
	local Ubat = Battery.Voltage
	if not self.PsnRand then self.PsnRand = Rand(81.0,82.9) end
	self.PsnRand = self.PsnRand + (Rand(Rand(78,80.5),Rand(83.4,85.0)) - self.PsnRand)*dT
	Battery:TriggerInput("Charge", self.PSN > 550 and self.PsnRand or 0)
	local AKB = C(Ubat > 61)
	local AKBLive = C(Ubat > 49)
	self.AKB = AKBLive
	local BSDead = Ubat <= 49 and self.PSN <= 550

	local RV = Train.RV

	if ishead then
		local BS = AKB*Train.SF1.Value


		S["RV"]=OB*Train.SF3.Value
		S["RU"]=OB*Train.SF2.Value

		Train:WriteTrainWire(16,S["RU"]*C(RV.KRRPosition==1))
		Train:WriteTrainWire(17,S["RU"]*C(RV.KRRPosition==-1))

		self.CabActive = S["RV"]*self.Active+S["RU"]*C(RV.KRRPosition~=0)*C(RV.KROPosition==0)

		Train:WriteTrainWire(6,BS*Train.EnableBS.Value)
		Train:WriteTrainWire(5,BS*Train.DisableBS.Value)

		Train:WriteTrainWire(2,(S["RV"]+S["RU"])*self.CabActive)
		Train:WriteTrainWire(1,0)

		Train:WriteTrainWire(15,S["RV"]*C(RV.KROPosition~=0))
		Train:WriteTrainWire(14,S["RU"]*C(RV.KRRPosition~=0))

		local ab = Train.ATSBlock.Value
		local function arsAllow(i,atc) if ab == i or ab == 3 then return 1 end return math.min(1,atc.Drive) end
		local EmerXPower = S["RU"]*C(RV.KRRPosition~=0)*math.min(arsAllow(1,Train.ATC1),arsAllow(2,Train.ATC2))

		Train:WriteTrainWire(19,EmerXPower*Train.EmerX1.Value)
		Panel.EmerX1 = EmerXPower*Train.EmerX1.Value
		Train:WriteTrainWire(18,EmerXPower*Train.EmerX2.Value)
		Panel.EmerX2 = EmerXPower*Train.EmerX2.Value

		Panel.PowerOnl = BS*(W[7]+Train.EnableBS.Value)
		Panel.PowerOffl = BS*math.min(1,W[8])*Panel.PowerOnl

		Panel.HVoltage = W[22]
		Panel.ChargeAKBl = BS*Train.ChargeAKB.Value
		Train:WriteTrainWire(21,Train.ChargeAKB.Value)

		Train:WriteTrainWire(23,W[22]*Train.EmergencyCompressor.Value)

		Train:WriteTrainWire(41,OB*Train.SF10.Value*self.CabActive*Train.ParkingBrake.Value)
		Train:WriteTrainWire(42,OB*Train.SF10.Value*self.CabActive*(1-Train.ParkingBrake.Value))

		Panel.EmerBrake = W[46]
		local KTRPower = OB*C(self.CabActive > 0)
		Train:WriteTrainWire(43,KTRPower*Train.EmerBrakeRelease.Value)
		Train:WriteTrainWire(44,KTRPower*Train.EmerBrakeAdd.Value)
		Train:WriteTrainWire(45,KTRPower*Train.EmerBrake.Value)

		Panel.DoorLS = OB*Train.DoorSelectLeft.Value
		Panel.DoorRS = OB*Train.DoorSelectRight.Value
		Panel.DoorOL = OB*math.max(0,Train.DoorSelectLeft.Value-Train.DoorSelectRight.Value)
		Panel.DoorOR = OB*math.max(0,Train.DoorSelectRight.Value-Train.DoorSelectLeft.Value)
		Panel.DoorClose = OB*Train.DoorClose.Value
		Panel.DoorBlock = OB*Train.DoorBlock.Value*self.CabActive

		local EDP = OB*Train.SF13.Value*S["RU"]*C(RV.KRRPosition~=0)*math.min(1,(Train.BKPU.V0 or 0)+Train.ParkingBrake.Value)
		local KRUon = C(RV.KRRPosition~=0)*C(RV.KROPosition==0)
		local DC = KRUon > 0 and S["RU"] or S["RV"]
		local aodL, aodR = Train.EmerLDOp.Value, Train.EmerRDOp.Value
		if KRUon > 0 and ((self.PrevAODL or 0) > aodL or (self.PrevAODR or 0) > aodR) then self.AODClose = true end
		if aodL > 0 or aodR > 0 or (Train.BKPU.DoorsOpenLeft or 0) > 0 or (Train.BKPU.DoorsOpenRight or 0) > 0 or KRUon == 0 then self.AODClose = false end
		self.PrevAODL, self.PrevAODR = aodL, aodR
		Train:WriteTrainWire(61,DC*(Train.BKPU.DoorsSelectRight or 0)*(1-aodR)+EDP*aodR)
		Train:WriteTrainWire(62,DC*(Train.BKPU.DoorsOpenRight or 0)*(1-aodR)+EDP*aodR)
		Train:WriteTrainWire(63,DC*(Train.BKPU.DoorsClose or 0)*(1-aodL)*(1-aodR)+S["RU"]*KRUon*C(self.AODClose == true))
		Train:WriteTrainWire(64,S["RV"]*(Train.BKPU.V0 or 0)*C(RV.KRRPosition==0)+EDP)
		Train:WriteTrainWire(65,DC*(Train.BKPU.DoorsSelectLeft or 0)*(1-aodL)+EDP*aodL)
		Train:WriteTrainWire(66,DC*(Train.BKPU.DoorsOpenLeft or 0)*(1-aodL)+EDP*aodL)
		local KROon = C(RV.KROPosition~=0)
		local cabOnDoors = math.min(1, KROon + KRUon)
		Train:WriteTrainWire(69, OB*cabOnDoors*math.min(1,(1-Train.SF12.Value) + KROon*(1-Train.SF3.Value)))

		Panel.HL1 = OB*Train.SF22.Value*((Train.BKPU.OF or 0)+S["RU"]*C(RV.KRRPosition~=0))*(C(Train.HeadlightsSwitch.Value>0)+S["RU"]*C(RV.KRRPosition>0))
		Panel.HL2 = OB*Train.SF22.Value*((Train.BKPU.OF or 0)+S["RU"]*C(RV.KRRPosition~=0))*C(Train.HeadlightsSwitch.Value>1)
		Panel.RL = OB*Train.SF22.Value*(1-(Train.BKPU.OF or 0)+S["RU"]*C(RV.KRRPosition~=0))+AKBLive*Train.SF18.Value*Train.NightStay.Value
		Panel.WL = OB*Train.SF22.Value*((Train.BKPU.OF or 0))

		self.V1 = OB*Train.SF29.Value*Train.HornB.Value
		Train:WriteTrainWire(70, OB*Train.Ring.Value)
	end
	Train.K2On:TriggerInput((W[6]+Train.K2.Value)>0 and "Close" or "Open",1)
	Train.K2Off:TriggerInput(W[5]>0 and "Close" or "Open",1)
	Train.K2:TriggerInput("Close",BSDead and 0 or Train.K2On.Value-Train.K2Off.Value)
	Train.K2:TriggerInput("Open",(Train.K2Off.Value>0 or BSDead) and 1 or 0)
	Train:WriteTrainWire(7,Train.K2On.Value+Train.K2.Value)
	Train:WriteTrainWire(8,(1-Train.K2On.Value))

	Train:WriteTrainWire(22,OB*C(self.Aux750V>550))
	if hasengine then
		local KN = OB*BUV.KN
		Train.KN:TriggerInput(KN>0 and "Close" or "Open",1)

        local Async = Train.BUTP
		self.Reverser = W[16]+BUV.DF+(W[17]+BUV.DR)*-1
		self.AsyncEmer = W[14]
		self.AsyncActive = W[15]+self.AsyncEmer

		Async:TriggerInput("Power",OB*Train["23F4"].Value*(1-BUV.DisableTP)*(1-BUV.DisableBV)*self.AsyncActive)

		local storage = (BUV.KN or 0) > 0 and Train.KN.Value > 0
		Async:TriggerInput("NT750V",storage and (BUV.StorageVoltage or 0) or 0)
		Async:TriggerInput("Storage",storage and 1 or 0)

		local command = 0
        if self.AsyncEmer > 0 then
            command = self.AsyncEmer*math.min(1,W[19]*0.5+W[18])
            if Train:ReadTrainWire(67) > 0 or Train:ReadTrainWire(68) <= 0 or not IsOn(Train.Pneumatic.ReserveReady) then command = 0 end
            Async:TriggerInput("Drive",C(command>0))
            Async:TriggerInput("Brake",0)
        else
            Async:TriggerInput("Drive",BUV.Drive)
            Async:TriggerInput("Brake",storage and 0 or BUV.Brake)
            command = (BUV.Strength/100)*(BUV.Drive-(storage and 0 or BUV.Brake))
        end
		local speed = math.abs(Async.Speed)
        if command > 0 then
            local shape = (1.0+Clamp(speed/15,0,1))*TractionFadeAt(speed)*(1+(Train.Pneumatic.WeightLoadRatio or 0)*0.3)
            local tq = (math.abs(command)^0.75)*shape
            Async:TriggerInput("TargetTorque",tq)
        elseif command < 0 then
            Async:TriggerInput("TargetTorque",Clamp((speed-2)/6,0,1)*math.abs(command)*2.4*(1+(Train.Pneumatic.WeightLoadRatio or 0)*0.3))
        else
            Async:TriggerInput("TargetTorque",0)
        end

		self.EnergyChange = Async.Mode>0 and (Async.Current^2)*2.8 or 0
        self.Itotal = Async.Current

		if Async.Mode<0 and Async.State>0 then
			local recAllowed = RawBUV.Recurperation
			if recAllowed == nil then recAllowed = 1 end
			self.Recurperation = C(self.Main750V>749 and self.Main750V<921)*recAllowed
			self.Iexit = self.Iexit+(-Async.Current*2*self.Recurperation-self.Iexit)*dT*2
			local chopperWork = C(self.Main750V>=921 or self.Main750V<550) + (1-self.Recurperation)
			if chopperWork > 0 and CurTime() >= self.ChopperTimeout then self.ChopperTimeout = CurTime()+Rand(1,5) end
			self.Chopper = (chopperWork > 0 or CurTime() < self.ChopperTimeout) and 1 or 0
		else
			self.Recurperation = 0
			self.Iexit = 0
			self.Chopper = 0
		end
		self.ElectricEnergyUsed = self.ElectricEnergyUsed + math.max(0,self.EnergyChange)*dT
		self.ElectricEnergyDissipated = self.ElectricEnergyDissipated + math.max(0,-self.EnergyChange)*dT

	end

	self.BUFT = OB*Train["22F1"].Value

	self.PSN = OB*PSN*C(Train.BUV.PSN)+(1-OB)*PSN*W[21]
	if hasengine then
		self.MK = self.PSN*Train["30F4"].Value*math.max(Train.BUV.CompressorSignal or 0, W[23])
	end

	local load = 220*math.max(0.1,OB) + (BUV.State and 160 or 0) + OB*180
	load = load + OB*(180 + 560)
	if ishead then
		local cl = Panel.CabLight or 0
		load = load
			+ (cl < 1 and 0 or cl < 2 and 14 or 32)
			+ Panel.HL1*100 + Panel.HL2*75
			+ math.min(1,Panel.HL1+Panel.HL2+Panel.RL)*34
			+ (Train.BKPU.Power or 0)*150
	end
	Battery:TriggerInput("Load", load)
	Battery:TriggerInput("SetInfinite", 0)

end
