Metrostroi.DefineSystem("81_775_Pneumatic")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	self.DriverValvePosition = 2
	self.RealDriverValvePosition = self.DriverValvePosition

	self.ParkingBrakePressure = 10
	self.AirDistributorPressure = 0
	self.ReservoirPressure = 0.0
	self.TrainLinePressure = 8.0
	self.TLPressure = 8.0
	self.BrakeLinePressure = 5
	self.FrontBogeyBrakeCylinderPressure = 0.0
	self.RearBogeyBrakeCylinderPressure = 0.0
	self.BrakeCylinderPressure = 0.0

	self.Train:LoadSystem("AK","Relay","AK-11B")

	self.Train:LoadSystem("UAVA","Relay","Switch")
	self.Train:LoadSystem("EmergencyBrakeValve","Relay","Switch")
	self.Train:LoadSystem("Stopkran","Relay","Switch")
	self.Train.stopkran = self.Train.Stopkran

	self.Train:LoadSystem("DriverValveTLDisconnect","Relay","Switch", { normally_closed = true})
	self.Train:LoadSystem("DriverValveBLDisconnect","Relay","Switch")

	self.Train:LoadSystem("K18", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("K19", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("K22", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("K53", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("K31", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("K40", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("K41", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("K23","Relay","Switch", {normally_closed = true})
	self.Train:LoadSystem("SD2","Relay","Switch")

	self.Train:LoadSystem("DD1","Relay","Switch")

	self.V4 = 0
	self.V6 = false

	self.K1 = false
	self.K2 = false
	self.EmerBrake = 0
	self.Train:LoadSystem("FrontBrakeLineIsolation","Relay","Switch", { normally_closed = true, bass = true})
	self.Train:LoadSystem("RearBrakeLineIsolation","Relay","Switch", { normally_closed = true, bass = true})
	self.Train:LoadSystem("FrontTrainLineIsolation","Relay","Switch", { normally_closed = true, bass = true})
	self.Train:LoadSystem("RearTrainLineIsolation","Relay","Switch", { normally_closed = true, bass = true})

	self.BrakeCylinderValve = 0

	self.TrainLineOverpressureValve = false

	self.Compressor = false

	self.DriverValveDisconnectPrevious = 0
	self.EPKPrevious = 0

	self.V4Previous = false

	self.PlayOpen = 1e9
	self.PlayClosed = 1e9
	self.TrainLineOpen = false

	self.ParkingBrake = false

	self.EmergencyValve = false
	self.EmergencyValveEPK = false
	self.OldValuePos = self.DriverValvePosition
	self.CompressorVal = 1
	self.MaxPosition = 7

	self.RVTBLeak = 0
	self.ReserveGoPressure   = 5.0
	self.ReserveHoldPressure = 4.7
	self.ReserveReady = false
	self.DisconnectType = false
	self.PrevLeak = 0

	self.WeightLoadRatio = 0
	self.EmerBrakeWork = false
	self.BrakeCylinderRegulationError = (math.random()>0.5 and 1 or -1)*math.random()*0.09
end

function TRAIN_SYSTEM:Inputs()
	return { "BrakeUp", "BrakeDown", "BrakeSet", "Autostop","DisconnectType","MaxPosition","CompressorSignal" }
end

function TRAIN_SYSTEM:Outputs()
	return { "BrakeLinePressure", "BrakeCylinderPressure", "DriverValvePosition","EmerBrakeWork",
			 "ReservoirPressure", "TrainLinePressure", "DoorLinePressure", "WeightLoadRatio", "ReserveReady"}
end

function TRAIN_SYSTEM:TriggerInput(name,value)
	if name == "BrakeSet" then
		self.DriverValvePosition = math.floor(value)
		if self.DriverValvePosition < 1 then self.DriverValvePosition = 1 end
		if self.DriverValvePosition > self.MaxPosition then self.DriverValvePosition = self.MaxPosition end
	elseif name == "DisconnectType" then
		self.DisconnectType = (value > 0.5)
	elseif (name == "BrakeUp") and (value > 0.5) then
			self:TriggerInput("BrakeSet",math.min(self.DriverValvePosition+1,self.MaxPosition))
	elseif (name == "BrakeDown") and (value > 0.5) then
			self:TriggerInput("BrakeSet",math.max(0,self.DriverValvePosition-1))
	elseif name == "Autostop" then
		if self.Train.K35 and self.Train.K35.Value < 0.5 then return end
		if value > 0 and self.Train.UAVA.Value == 0 then self.EmergencyValve = true end
		if self.EmergencyValve and value > 0 then RunConsoleCommand("say","Autostop braking",self.Train:GetDriverName()) end
	end
end

function TRAIN_SYSTEM:equalizeCouplePressure(dT,pressure,train,valve_status,rate,close_rate)
	if not valve_status then return 0 end
	local other
	if IsValid(train) then other = train.Pneumatic end

	local P2 = 0
	if other then P2 = other[pressure] end
	if (not other) and (valve_status) then
		self.TrainLineOpen = (pressure == "TrainLinePressure")
		rate = close_rate or rate
	end

	local dPdT = rate * (P2 - self[pressure])
	local dP = dPdT*dT
	if other and other.ReadOnly then
		dP = dP/250
	end
	local P0 = (P2 + self[pressure]) / 2
	if dP > 0 then
		self[pressure] = math.min(P0,self[pressure] + dP)
		if other and not other.ReadOnly then
			other[pressure] = math.max(P0,other[pressure] - dP)
		end
	else
		self[pressure] = math.max(P0,self[pressure] + dP)
		if other and not other.ReadOnly then
			other[pressure] = math.min(P0,other[pressure] - dP)
		end
	end
	if self.TrainLineOpen and (pressure == "TrainLinePressure") then
		self[pressure.."_dPdT"] = (self[pressure.."_dPdT"] or 0) + dPdT
	end
	return dP
end
function TRAIN_SYSTEM:UpdatePressures(Train,dT)
	local frontBrakeOpen
	local frontTrainOpen
	if Train:GetClass():find("775") then
		frontBrakeOpen = Train.FrontBrakeLineIsolation.Value == 0 or (Train.TLBL.Value*Train.Electric.Power) == 1
		frontTrainOpen = Train.FrontTrainLineIsolation.Value == 0 or (Train.TLBL.Value*Train.Electric.Power) == 1
	else
		frontBrakeOpen = Train.FrontBrakeLineIsolation.Value == 0
		frontTrainOpen = Train.FrontTrainLineIsolation.Value == 0
	end
	local rearBrakeOpen = Train.RearBrakeLineIsolation.Value == 0
	local rearTrainOpen = Train.RearTrainLineIsolation.Value == 0

	local Ft = IsValid(Train.FrontTrain) and Train.FrontTrain
	local Rt = IsValid(Train.RearTrain) and Train.RearTrain
	local Fc, Rc = Train.FrontCouple or Train.FrontBogey, Train.RearCouple or Train.RearBogey
	local Fb,Rb
	if IsValid(Fc) and Fc.DepotPneumo then Fb = Fc.DepotPneumo end
	if IsValid(Rc) and Rc.DepotPneumo then Rb = Rc.DepotPneumo end

	local frontBrakeLeak = false
	local rearBrakeLeak = false
	local frontTrainLeak = false
	local rearTrainLeak = false

	if Ft and Ft.FrontBrakeLineIsolation then
		if Ft.FrontTrain == Train then
			frontBrakeLeak = frontBrakeOpen and Ft.FrontBrakeLineIsolation.Value==1 and 0.08
			frontTrainLeak = frontTrainOpen and Ft.FrontTrainLineIsolation.Value==1 and 0.08
		else
			frontBrakeLeak = frontBrakeOpen and Ft.RearBrakeLineIsolation.Value==1 and 0.08
			frontTrainLeak = frontTrainOpen and Ft.RearTrainLineIsolation.Value==1 and 0.08
		end
	else
		frontBrakeLeak = frontBrakeOpen and 0.7
		frontTrainLeak = frontTrainOpen and not Fb and 0.3
	end
	if Rt and Rt.FrontBrakeLineIsolation then
		if Rt.FrontTrain == Train then
			rearBrakeLeak = rearBrakeOpen and Rt.FrontBrakeLineIsolation.Value==1 and 0.08
			rearTrainLeak = rearTrainOpen and Rt.FrontTrainLineIsolation.Value==1 and 0.08
		else
			rearBrakeLeak = rearBrakeOpen and Rt.RearBrakeLineIsolation.Value==1 and 0.08
			rearTrainLeak = rearTrainOpen and Rt.RearTrainLineIsolation.Value==1 and 0.08
		end
	else
		rearBrakeLeak = rearBrakeOpen and 0.7
		rearTrainLeak = rearTrainOpen and not Rb and 0.3
	end

	local Fl=math.min(0,self:equalizeCouplePressure(dT,"BrakeLinePressure",frontBrakeLeak==false and Ft,frontBrakeOpen,100,frontBrakeLeak or 0.08)*3)*(frontBrakeLeak and 1 or 0)
	local Rl=math.min(0,self:equalizeCouplePressure(dT,"BrakeLinePressure",rearBrakeLeak==false and Rt,rearBrakeOpen,100,rearBrakeLeak or 0.08)*3)*(rearBrakeLeak and 1 or 0)

	Fl=Fl+math.min(0,self:equalizeCouplePressure(dT,"TrainLinePressure",frontTrainLeak==false and Ft or Fb,frontTrainOpen,100,frontTrainLeak or 0.08)*10)*(frontTrainLeak and 1 or 0)
	Rl=Rl+math.min(0,self:equalizeCouplePressure(dT,"TrainLinePressure",rearTrainLeak==false and Rt or Rb,rearTrainOpen,100,rearTrainLeak or 0.08)*10)*(rearTrainLeak and 1 or 0)

	self.TrainLineOpen=frontTrainLeak or rearTrainLeak
	self.BraieLineOpen=frontBrakeLeak or rearBrakeLeak
	Train:SetPackedRatio("FrontLeak",Fl)
	Train:SetPackedRatio("RearLeak",Rl)
end

function TRAIN_SYSTEM:equalizePressure(dT,pressure,target,rate,fill_rate,no_limit,smooth)
	if fill_rate and (target > self[pressure]) then rate = fill_rate end

	local dPdT = rate
	if target < self[pressure] then dPdT = -dPdT end
	local dPdTramp = math.min(1.0,math.abs(target - self[pressure])*(smooth or 0.5))

	dPdT = dPdT*dPdTramp

	self[pressure] = self[pressure] + dT * dPdT
	self[pressure] = math.max(0.0,math.min(16.0,self[pressure]))
	self[pressure.."_dPdT"] = (self[pressure.."_dPdT"] or 0) + dPdT
	if no_limit ~= true then
		if self[pressure] == 0.0  then self[pressure.."_dPdT"] = 0 end
		if self[pressure] == 16.0 then self[pressure.."_dPdT"] = 0 end
	end
	return dPdT
end

function TRAIN_SYSTEM:Think(dT)
	local Train = self.Train
	local RR = (Train.RV and (Train.RV.KROPosition ~= 0 or Train.RV.KRRPosition ~= 0))
	self.WeightLoadRatio = math.max(0,math.min(1,(Train:GetNW2Float("PassengerCount")/200)))

	Train:SetNW2Bool("V4", Train.BKPU and (Train:GetNW2Int("MFDU_State") == 40 or Train:GetNW2Int("MFDU_State") == 30))
	if Train:GetNW2Int("MFDU_State") == 40 and not RR then
		self.Train:SetNW2Bool("V4", false)
	end
	self.TrainLinePressure_dPdT = 0.0
	self.BrakeLinePressure_dPdT = 0.0
	self.EPKPressure_dPdT = 0.0
	self.ReservoirPressure_dPdT = 0.0
	self.BrakeCylinderPressure_dPdT = 0.0
	self.ParkingBrakePressure_dPdT = 0.0

    self.TrainToBrakeReducedPressure = math.min(5.1,self.TrainLinePressure)

	local trainLineConsumption_dPdT = 0.0

	if self.BrakeLinePressure >= self.ReserveGoPressure then
		self.ReserveReady = true
	elseif self.BrakeLinePressure < self.ReserveHoldPressure then
		self.ReserveReady = false
	end

	local wagc = Train:GetWagonCount()
    local pr_speed = 1.25*wagc
    if self.Leak or self.BraieLineOpen then pr_speed = pr_speed*0.4 end

	if Train.BKPU then
		local kaetOpen = Train.EmergencyBrakeValve.Value > 0.5
		local V5 = Train.KPRRKM.Value == 0 or (Train.Electric.CabActive>0 and Train.SF11.Value>0 and not kaetOpen)
		self.CraneActive = V5
		local dumping = self.RVTBLeak ~= 0 or (Train.BTBU and Train.BTBU.ReserveLeak == true) or self.EmergencyValve == true
		local noCharge = Train.BTBU and Train.BTBU.ReserveNoCharge == true
		local reduced = self.TrainToBrakeReducedPressure
		local craneTargets = {
			[1] = self.TrainLinePressure,
			[2] = 1.01*math.min(5.1,reduced),
			[3] = 1.01*math.min(4.3,reduced),
			[4] = 1.01*math.min(4.0,reduced),
			[5] = 1.01*math.min(3.7,reduced),
			[6] = 1.01*math.min(3.0,reduced),
			[7] = 0,
		}
		local target = craneTargets[self.DriverValvePosition]
		if V5 and target then
			local pos = self.DriverValvePosition
			if pos == 7 then
				self:equalizePressure(dT,"BrakeLinePressure", target, pr_speed)
				trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0,self.BrakeLinePressure_dPdT)
			elseif not dumping and (target < self.BrakeLinePressure or not noCharge) then
				self:equalizePressure(dT,"BrakeLinePressure", target, pr_speed)
				trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0,self.BrakeLinePressure_dPdT)
			end
		end

		self.Leak = false
		local leak = 0
        if self.EmergencyValve and Train.K35 and Train.K35.Value < 0.5 then self.EmergencyValve = false end
        if self.EmergencyValve then
            local leakst = 1.45*wagc
            leak = self:equalizePressure(dT,"BrakeLinePressure", 0.0,leakst,false,false,0.4)
            if (Train.UAVA.Value > 0 or self.BrakeLinePressure < 0.6) then
                self.EmergencyValve = false
            end
            self.Leak = true
        end
        self.Train:SetPackedRatio("EmergencyValve_dPdT", -leak)

		local BTBU = Train.BTBU
		local rl = 0
		if BTBU and BTBU.RVTBVent and Train.KRRH3.Value > 0.5 then
			self.RVTBLeak = 1
			rl = self:equalizePressure(dT,"BrakeLinePressure", 0.0, 3*wagc, false, false, 1.0)
			local hiss = -0.08*math.min(1, self.BrakeLinePressure*2)
			if rl > hiss then self.BrakeLinePressure_dPdT = self.BrakeLinePressure_dPdT + (hiss - rl) end
			rl = math.min(rl, hiss)
			self.Leak = true
		else
			self.RVTBLeak = 0
		end
		if BTBU and BTBU.ReserveLeak and self.RVTBLeak == 0 then
			rl = self:equalizePressure(dT,"BrakeLinePressure", 0.0, 1.5*wagc, false, false, 1.0)
			local hiss = -0.08*math.min(1, self.BrakeLinePressure*2)
			if rl > hiss then self.BrakeLinePressure_dPdT = self.BrakeLinePressure_dPdT + (hiss - rl) end
			rl = math.min(rl, hiss)
			self.Leak = true
		end
		self.Train:SetPackedRatio("EmergencyValveEPK_dPdT", -rl)
	end

    local leak = 0
	if (self.Train.EmergencyBrakeValve.Value) > 0.5 then
		leak = self:equalizePressure(dT,"BrakeLinePressure", 0.0,2.2*wagc,false,false,1)
        self.Leak = true
	end

    self.Train:SetPackedRatio("EmergencyBrakeValve_dPdT", -leak)
    leak = 0
    if self.Train.Stopkran and self.Train.Stopkran.Value > 0.5 then
        leak = self:equalizePressure(dT,"BrakeLinePressure", 0.0,2.2*wagc,false,false,1)
        self.Leak = true
    end
    self.Train:SetPackedRatio("stopkran_dPdT", -leak)
    self.Train:SetPackedRatio("Crane_dPdT", self.BrakeLinePressure_dPdT )
    trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0,self.BrakeLinePressure_dPdT)

    local targetPressure = 0

    local PMPressure = 0
    local EPMPressure = 0
    local Power = Train.Electric.BUFT > 0
	if Power ~= self.Power then
		self.Power = Power
		if self.Power then
			self.CompressorVal = 0
		end
	end

	self.EmergencyBrakeActive = 0
	local BTBU = Train.BTBU
	self.VTBApplied = BTBU and BTBU.VTBApplied or false
	self.VTBBlocked = BTBU and BTBU.BlockWire or false
	self.VTBPressure = 2.3+self.BrakeCylinderRegulationError+self.WeightLoadRatio*1.3

	self.CraneToBC = Train:ReadTrainWire(60) > 0

	local kpuStart, kpuFull = 4.8, 3.2
	self:equalizePressure(dT,"AirDistributorPressure", math.Clamp(((kpuStart-self.BrakeLinePressure)/(kpuStart-kpuFull)),0,1)*(2.3+self.BrakeCylinderRegulationError+self.WeightLoadRatio*1.3), 2.50, 2.50, nil, 1.3)

	self.BTBReady = self.AirDistributorPressure > (2.3+self.BrakeCylinderRegulationError+self.WeightLoadRatio*1.3)-0.05

	PMPressure = self.AirDistributorPressure
	if Power then
        if self.CraneToBC and self.BrakeCylinderPressure < self.AirDistributorPressure and self.AirDistributorPressure-self.BrakeCylinderPressure > 0.1 then
            self:equalizePressure(dT,"AirDistributorPressure",0, (self.AirDistributorPressure-self.BrakeCylinderPressure)*1, (self.AirDistributorPressure-self.BrakeCylinderPressure)*1, nil, 2)
        end
	end

	local emerBraking = Train:ReadTrainWire(44) > 0
	local emerRelease = Train:ReadTrainWire(43) > 0

	self.EmerBrakeWork = Train:ReadTrainWire(45) > 0

	self.EmergencyBrakeActive = Train:ReadTrainWire(25)*Train:ReadTrainWire(26) == 0
	if self.EmergencyBrakeActive or self.EmerBrake == 3 then
		PMPressure = self.AirDistributorPressure
		if self.CraneToBC and self.BrakeCylinderPressure < self.AirDistributorPressure and self.AirDistributorPressure-self.BrakeCylinderPressure > 0.1 then
			self:equalizePressure(dT,"AirDistributorPressure",0, (self.AirDistributorPressure-self.BrakeCylinderPressure)*1, (self.AirDistributorPressure-self.BrakeCylinderPressure)*1, nil, 2)
		end
	end

	if emerBraking and self.EmerBraking ~= emerBraking and self.EmerBrake < 3 then self.EmerBrake = self.EmerBrake + 1 end
	if emerRelease and self.EmerRelease ~= emerRelease and self.EmerBrake > 0 then self.EmerBrake = self.EmerBrake - 1 end
	self.EmerBraking = emerBraking
	self.EmerRelease = emerRelease
	self.Pn3Pressure = 2.2+self.BrakeCylinderRegulationError+self.WeightLoadRatio*0.6
	self.ReverserOff = (Train:ReadTrainWire(14) + Train:ReadTrainWire(15)) == 0
	self.NotInitialized = Train:ReadTrainWire(59) == 0
	if not Power then
		EPMPressure = self.Pn3Pressure
	elseif self.NotInitialized then
		EPMPressure = self.Pn3Pressure
	end
	if Power and not self.NotInitialized then
		if self.ReverserOff then
			EPMPressure = self.Pn3Pressure
		elseif Train.BUV.EmerPN3 and not self.VTBBlocked then
			EPMPressure = self.Pn3Pressure
		elseif self.EmerBrakeWork then
				if self.EmerBrake > 2 then
					EPMPressure = 1.9+self.BrakeCylinderRegulationError+(Train.BUTP and self.WeightLoadRatio*1.2 or 0)
				elseif self.EmerBrake > 1 then
					EPMPressure = 1.5+self.BrakeCylinderRegulationError+(Train.BUTP and self.WeightLoadRatio*0.4 or 0)
				elseif self.EmerBrake > 0 then
					EPMPressure = 0.8+self.BrakeCylinderRegulationError+(Train.BUTP and self.WeightLoadRatio*0.3 or 0)
				end
				if Train.BUV.ReserveHold then
					EPMPressure = math.max(EPMPressure, self.Pn3Pressure)
				end
			elseif self.EmerBrake > 0 then
				self.EmerBrake = 0
		else
			if self.EmerBrake > 0 then self.EmerBrake = 0 end
			if Train.BUV.PN5 then
				EPMPressure = 2.2+self.BrakeCylinderRegulationError+self.WeightLoadRatio*1.5
			elseif Train.BUV.PN4 then
				EPMPressure = 1.9+self.BrakeCylinderRegulationError+self.WeightLoadRatio*1.2
			elseif Train.BUV.PN3 then
				EPMPressure = 1.5+self.BrakeCylinderRegulationError+self.WeightLoadRatio*1.2
			elseif Train.BUV.PN2 then
				EPMPressure = 1.2+self.BrakeCylinderRegulationError+self.WeightLoadRatio*0.4
			elseif Train.BUV.PN1 then
				EPMPressure = 0.8+self.BrakeCylinderRegulationError+self.WeightLoadRatio*0.6
			end
		end
	end
	if Power and self.VTBApplied then
		EPMPressure = math.max(EPMPressure, self.VTBPressure)
	end
	Train:WriteTrainWire(46,self.EmerBrakeWork and 1 or 0)

	if self.CraneToBC then
		EPMPressure = 0
	end

	if EPMPressure > PMPressure then
		targetPressure = EPMPressure
	else
		targetPressure = PMPressure
	end

	if Train.K31.Value == 1 then
        if math.abs(self.BrakeCylinderPressure - targetPressure) > 0.150 then
            self.BrakeCylinderValve = 1
        end
        if math.abs(self.BrakeCylinderPressure - targetPressure) < 0.001 then
            self.BrakeCylinderValve = 0
        end
        local pneumaticValveConsumption_dPdT = 0
        trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0,pneumaticValveConsumption_dPdT)
        if self.BrakeCylinderValve == 1 then
            self:equalizePressure(				dT,	"BrakeCylinderPressure",	math.min(4,targetPressure),	3,		2.5,		nil,		self.BrakeCylinderPressure > targetPressure and 0.3+math.Clamp((self.BrakeCylinderPressure-0.0)/4,0,0.6) or 0.9)
        end
    else
        self.BTOVentRate = math.max(0,-self:equalizePressure(dT,"BrakeCylinderPressure", 0.0, 2.00))
    end

	self.FrontVentRate = 0
	self.RearVentRate = 0
	if Train.K31.Value == 1 or self.BrakeCylinderPressure < 0.01 then self.BTOVentRate = 0 end
	self.Train:SetPackedRatio("BTOVentRate", math.min(1,self.BTOVentRate or 0))
	if Train.K40.Value > 0.5 then
		self.FrontBogeyBrakeCylinderPressure = self.BrakeCylinderPressure
	else
		self.FrontVentRate = math.max(0,-self:equalizePressure(dT,"FrontBogeyBrakeCylinderPressure", 0.0, 2.00))
	end
	if Train.K41.Value > 0.5 then
		self.RearBogeyBrakeCylinderPressure = self.BrakeCylinderPressure
	else
		self.RearVentRate = math.max(0,-self:equalizePressure(dT,"RearBogeyBrakeCylinderPressure", 0.0, 2.00))
	end
	if self.FrontBogeyBrakeCylinderPressure < 0.01 then self.FrontVentRate = 0 end
	if self.RearBogeyBrakeCylinderPressure < 0.01 then self.RearVentRate = 0 end
	self.Train:SetPackedRatio("FrontVentRate", math.min(1,self.FrontVentRate))
	self.Train:SetPackedRatio("RearVentRate", math.min(1,self.RearVentRate))

	if (Train:ReadTrainWire(42)>0 or Train.K53.Value < 0.5) and Train.K23.Value > 0.5 then
		self:equalizePressure(dT,"ParkingBrakePressure", self.TrainLinePressure, 0.5,0.5,nil,1.3)
	end
	if Train:ReadTrainWire(41)>0 and Train.K53.Value > 0.5 then
		local rate = self.ParkingBrakePressure > 4.5 and 0.5 or self.ParkingBrakePressure > 0.4 and 0.33 or 0.6
		self:equalizePressure(dT,"ParkingBrakePressure", 0,rate,rate,nil,1.3)
	end

	Train:SetPackedRatio("ParkingBrakePressure_dPdT",self.ParkingBrakePressure_dPdT+0.02)
    trainLineConsumption_dPdT = trainLineConsumption_dPdT + math.max(0,self.BrakeCylinderPressure_dPdT + self.ParkingBrakePressure_dPdT)
    self.Train:SetPackedRatio("BrakeCylinderPressure_dPdT", self.BrakeCylinderPressure_dPdT * ((Train.K40.Value > 0.5 and 1 or 0) + (Train.K41.Value > 0.5 and 1 or 0)) / 2)

	self:UpdatePressures(Train,dT)

	if Train.SD2 then
		Train.SD2:TriggerInput("Close", self.BrakeLinePressure < 2.6)
		Train.SD2:TriggerInput("Open", self.BrakeLinePressure > 2.8)
	end

	if Train.BUTP then

		if Train.Electric.MK ~= self.PrevCompressor then
			self.PrevCompressor = Train.Electric.MK
			self.CompressorVal = 1
		end

		if self.Compressor ~= (Train.Electric.PSN>0 and self.CompressorVal == 1 and Train.Electric.MK > 0) then
			local val = Train.Electric.PSN>0 and self.CompressorVal == 1 and Train.Electric.MK > 0
			if val and not self.Compressor then
				self.Compressor = CurTime()+(Train:ReadTrainWire(23) > 0.5 and 0.3 or 5)
			elseif not val and self.Compressor then
				self.Compressor = nil
			end
			if self.Compressor and CurTime()-self.Compressor > 0 and not self.CompressorOver1 then
				self.CompressorOver1 = self.CompressorOver
			end
			if not self.Compressor and self.CompressorOver1 and self.CompressorOver > 0.04 and (self.CompressorOver -(self.CompressorOver1 or 0) < 0 or self.CompressorOver -(self.CompressorOver1 or 0) > 0.04) then
				Train:PlayOnce("compressor_pn"..math.random(1,2),"cabin",1,1)
				self.CompressorOver1 = nil
			end
		end
		self.CompressorOver = self.CompressorOver or 0
		if self.Compressor and CurTime()-self.Compressor > 0 then
			self.CompressorOver = self.CompressorOver + math.random(0.0215,0.0235)*dT
			if self.CompressorOver >= 1 then
				self.CompressorOver = 0
				Train:PlayOnce("compressor_pn"..math.random(1,2),"cabin",1,1)
			end
		end
	end

	self.TrainLinePressure = self.TrainLinePressure - 0.05*trainLineConsumption_dPdT*dT
	if self.Compressor and CurTime()-self.Compressor > 0 then self:equalizePressure(dT,"TrainLinePressure", 10.0, 0.039) end
	self:equalizePressure(dT,"TrainLinePressure", 0,0.001)

	if self.TrainLinePressure > 9.5 then self.TrainLineOverpressureValve = true end
	if self.TrainLineOverpressureValve then
		self:equalizePressure(dT,"TrainLinePressure", 0.0, self.TrainLinePressure < 5.3 and 0.02 or 0.05)
		self.TrainLineOpen = true
		if self.TrainLinePressure < 4.5 then self.TrainLineOverpressureValve = false end
	end

	if Power then
		Train.AK:TriggerInput( "Open", self.TrainLinePressure > 8.0)
		Train.AK:TriggerInput( "Close",self.TrainLinePressure < 6.5)
		Train.DD1:TriggerInput("Open", self.TrainLinePressure > 8.2)
		Train.DD1:TriggerInput("Close",self.TrainLinePressure < 6.3)
	end
	self.CraneClickTimer = self.CraneClickTimer or CurTime()
	if (CurTime() - self.CraneClickTimer > 0.10) and (self.DriverValvePosition ~= self.RealDriverValvePosition) then
		self.CraneClickTimer = CurTime()
		self.Train:PlayOnce("br_013","cabin")
		self.RealDriverValvePosition = self.RealDriverValvePosition + (self.DriverValvePosition > self.RealDriverValvePosition and 1 or -1)
	end

	if self.V4Previous ~= Train:GetNW2Bool("V4") then
		self.V4Previous = Train:GetNW2Bool("V4")
		if not Train:GetNW2Bool("V4") then
			self.V4OffTimer = CurTime()
			self.Train:PlayOnce("pneumo_disconnect_close","cabin")
		else
			self.V4OffTimer = nil
			self.Train:PlayOnce("pneumo_disconnect_open","cabin")
		end
	end
	if self.V4OffTimer then
        if CurTime()-self.V4OffTimer < 0.45 then
            local pr_speed = 1.25*wagc
            self:equalizePressure(dT,"BrakeLinePressure", 0,pr_speed)
        else
            self.V4OffTimer = nil
        end
	end

end
