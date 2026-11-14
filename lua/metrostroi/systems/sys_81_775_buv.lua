Metrostroi.DefineSystem("81_775_BUV")

local BV_TRIP_CURRENT = 1500
local BV_TRIP_VOLTAGE = 975
local BV_TRIP_ON_SAG  = false
local BV_TRIP_WINDOW = 30
local BV_MAX_RECLOSE = 3
local BV_MAX_ATTEMPTS = 3
local STORAGE_MAX_TIME = 300
TRAIN_SYSTEM.DontAccelerateSimulation = true

local function Rand(a,b)
	return a+(b-a)*math.random()
end

function TRAIN_SYSTEM:Initialize()
	self.Power = 0
	self.Commands = {}
	self.States = {}

	self.State = 0

	self.Reverser = 0
	self.Drive = 0
	self.Brake = 0
	self.Strength = 0

	self.PowerOff = 0

	self.BatteryCapacity = 120 * 3600
	self.BatteryCharge = self.BatteryCapacity
	self.BatteryCurrent = 0

	self.Voltage = 0
	self.Main750VcheckMistake = Rand(1,8)

	self.PSN = false
	self.PSNVoltage = 85
	self.PSNFullCharge = false

	self.BVSignal = 0
	self.BVState = 0

	self.CompressorsCanWork = 0
	self.CompressorSignal = 0

	self.BVprotectiveShutdown = 0
	self.BVattempt2Enable = 0
	self.BVdisableByOwnProtection = false

	self.DisableDoors = 0
	self.DisableMK = 0
	self.DisableLights = 0
	self.DisableTR = 0
	self.DisablePVU4 = 0
	self.DisableTP = 0
	self.DisablePSN = 0
	self.DisableBV = 0

	self.EnableLights = 0
	self.EnableMK = 0
	self.VentMode = 0

	self.DF = 0
	self.DR = 0
	self.Orientation = false

	self.KN = 0
	self.StorageVoltage = 0
	self.StorageActive = false
	self.StorageTime = 0
	self.StorageLocked = false
end

function TRAIN_SYSTEM:Inputs()
	return {}
end

function TRAIN_SYSTEM:Outputs()
	return {
		"State", "AKBVoltage", "Voltage", "PowerOff", "PSN", "CompressorsCanWork","CompressorSignal","BVSignal",
		"Drive","Brake","Strength","KN","DisableLights","DisablePSN","DisableMK","DisableBV","DisableTP","EnableLights","EnableMK",
		"DF","DR","Orientation","StorageVoltage",
	}
end

if TURBOSTROI then return end

function TRAIN_SYSTEM:CState(name,value)
	if self.CurrentBUP and  (self.Reset or self.States[name] ~= value) then
		self.States[name] = value
		self.Train:CANWrite("BUV",self.TrainIndex,"BKPU",self.CurrentBUP or false,name,value)
	end
end

function TRAIN_SYSTEM:CANReceive(source,sourceid,target,targetid,textdata,numdata)
	if textdata == "Init" and not numdata then
		local Train = self.Train
		self.Commands[sourceid] = {}
		Train:CANWrite("BUV",self.TrainIndex,"BKPU",sourceid,"Init",{
			front=Train.FrontTrain and Train.FrontTrain.BUV and Train.FrontTrain.BUV.TrainIndex,
			rear=Train.RearTrain and Train.RearTrain.BUV and Train.RearTrain.BUV.TrainIndex,
			type=Train.Electric.Type
		})
	elseif textdata == "Get" then
		self.Reset = CurTime()
	elseif textdata == "Orientate" then
		self.OrientateBUP = sourceid
		self.FirstHalf = numdata
		self.FirstGroup = numdata
		self.Reset = CurTime()
	elseif textdata == "BKPUWork" and sourceid == self.CurrentBUP then
		self.LastBUKVWork = CurTime()
	elseif self.CurrentBUP then
		if not self.Commands[sourceid] then self.Commands[sourceid] = {} end
		self.Commands[sourceid][textdata] = numdata
	end
end

function TRAIN_SYSTEM:Get(id)
	local Commands = self.Commands[self.CurrentBUP]
	if Commands then
		if type(id) == "string" and string.sub(id,1,3) == "PVU" and self.Train:ReadTrainWire(14) > 0 then
			return nil
		end
		return Commands[id]
	end
end

function TRAIN_SYSTEM:GetAKBVoltage(dT)
	local Battery = self.Train.Battery
	if not Battery then return 0 end

	self.BatteryCapacity = Battery.Capacity
	self.BatteryCharge = Battery.Charge
	self.BatteryCurrent = Battery.Current

	local target = Battery.Voltage
	self.TrueAKB = self.TrueAKB or target
	local dU = target - self.TrueAKB
	local sign = dU > 0 and 1 or dU < 0 and -1 or 0
	local new = self.TrueAKB + math.max(1,math.abs(dU))*sign*dT*4
	if (target-new)*dU < 0 then new = target end
	self.TrueAKB = new

	return new
end

local COND_SET = { salon = {leto = 23, zima = 20}, cab = {leto = 23, zima = 22} }
local COND_RATE = 0.06
local COND_DRIFT = 900
function TRAIN_SYSTEM:ThinkClimate(dT)
	local Train = self.Train
	local leto = self:Get("CondLeto") ~= false
	local otv = self:Get("OutTemp")
	local tout = otv and tonumber(otv) or 20
	local HV = Train.Electric.Main750V > 550
	local on = self:Get("CondOn") == true and HV
	local head = Train.Electric.Type == 0

	self.TSalon = self.TSalon or 22
	self.TCab = self.TCab or 22
	local setS = leto and COND_SET.salon.leto or COND_SET.salon.zima
	local setC = leto and COND_SET.cab.leto or COND_SET.cab.zima

	local function step(T, set, hyst)
		T = T + (tout - T) * math.min(1, dT / COND_DRIFT)
		local cool, heat = false, false
		if on then
			if leto then
				cool = hyst.cool and T > set - 0.3 or T > set + 0.8
			else
				heat = hyst.heat and T < set + 0.3 or T < set - 0.8
			end
			if cool or heat then
				local d = set - T
				T = T + math.Clamp(d, -COND_RATE * dT, COND_RATE * dT)
			end
		end
		hyst.cool, hyst.heat = cool, heat
		return T
	end
	self.CondHystS = self.CondHystS or {}
	self.CondHystC = self.CondHystC or {}
	self.TSalon = step(self.TSalon, setS, self.CondHystS)
	local cool, heat = self.CondHystS.cool, self.CondHystS.heat
	if head then self.TCab = step(self.TCab, setC, self.CondHystC) end

	self:CState("Cond1", on)
	self:CState("Cond2", on)
	self:CState("CondK", on and head)
	self:CState("CondLetoMode", leto)
	self:CState("CondCool", cool and true or false)
	self:CState("CondHeat", heat and true or false)
	self:CState("CondVent", on and not cool and not heat)
	self:CState("TSalon", math.Round(self.TSalon, 1))
	self:CState("TSalonSet", setS)
	self:CState("TCab", math.Round(self.TCab, 1))
	self:CState("TCabSet", setC)
	self:CState("OutTemp", math.Round(tout, 1))
	self:CState("SalonLight", Train:GetPackedBool("SalonLighting1") or Train:GetPackedBool("SalonLighting2"))
end

function TRAIN_SYSTEM:Think(dT)
	local Train = self.Train
	local Electric = Train.Electric

	self.TrainIndex = Train:GetWagonNumber()

	self.AKBDischarge = 0

	self.AKBVoltage = self:GetAKBVoltage(dT)

	self.Voltage = self.AKBVoltage

	self.State = (Electric.Power*(self.Voltage > 49 and 1 or 0)*Train["23F27"].Value) > 0
	if not self.State then self.EncoderFOk, self.EncoderROk, self.HullTimer = true, true, nil end

	self.OpenLeft = false
	self.OpenRight = false
	self.CloseDoors = false

	self.PSNSignal = false
	self.ChargeAKB = Train:ReadTrainWire(30) > 0.5

	if self.State then
		if not self.States.BUVTimer then
			self.Train:CANWrite("BUV",Train:GetWagonNumber(),"BKPU",nil,"Get",1)
		end
		if self.CurrentBUP and self.LastBUKVWork then
			self.BUKPWork = not (CurTime() - self.LastBUKVWork>0.2)
		end
		self:CState("WagNOrientated", self.Orientation  == self.RevOrientation)
		self:CState("Orientation", self.Orientation)
		self:CState("PSNState", self.PSN)
		if Train.Electric.Main750V > 10 then
			local maxJump,minJump
			if CurTime()%2 > 1 then
				if not maxJump then maxJump = Rand(0,2) end
				if not minJump then minJump = Rand(0,2) end
			end
		end
		self:CState("HighVoltageMin", Train.Electric.Main750V+(minJump or 0))
		self:CState("HighVoltageMax", Train.Electric.Main750V+self.Main750VcheckMistake+(maxJump or 0))
		self:CState("LowVoltage", self.AKBVoltage)
		self:CState("BadCombination", (Train:ReadTrainWire(2)*Train:ReadTrainWire(1)) > 0)

		if Train.BUTP then

			local AsyncInverter = Train.BUTP
			self:CState("Current", math.Round(AsyncInverter.Current,1))
			self:CState("DTorque", math.max(0,math.Round(AsyncInverter.Torque,1)))
			self:CState("BTorque", math.max(0,-math.Round(AsyncInverter.Torque,1)))

			self:CState("AsyncOverheat", false)
			self:CState("AsyncAssembly", AsyncInverter.Mode~=0 and (AsyncInverter.Mode==self.Drive*(1-self.Brake) or AsyncInverter.Mode*(-1)==self.Brake*(1-self.Drive)))
			self:CState("AsyncFail", AsyncInverter.Mode==0 and (self.Drive>0 and self.Brake>0) or AsyncInverter.Power == 0)
			self:CState("AsyncEFail", (AsyncInverter.Mode==0 or AsyncInverter.EDone > 0) and self.Brake>0)
			self:CState("AsyncEFault", self.Brake>0 and AsyncInverter.EDone == 0 and AsyncInverter.Mode ~= -1)
			self:CState("AsyncProtection",  AsyncInverter.Power == 0)
			self:CState("BVState", Train.BV.Value > 0)
			self:CState("AsyncEDone", AsyncInverter.EDone>0)

			self:CState("MKWork", self.CompressorSignal>0 or Train.Electric.MK > 0)
			self:CState("MKCmd", self.CompressorSignal>0)
			self:CState("MKCur", Train.Electric.MK > 0)
		end

		self:CState("WagType", Train.Electric.Type)
		self:ThinkClimate(dT)
		self:CState("PneumaticBrakeApply", math.max(Train.Pneumatic.FrontBogeyBrakeCylinderPressure or 0, Train.Pneumatic.RearBogeyBrakeCylinderPressure or 0) > 0.3)
		self:CState("ParkingBrakeApply", Train.Pneumatic.ParkingBrakePressure < 4.3)

		local BUFTPower = true
		local Pneumatic = Train.Pneumatic
		local BTBU = Train.BTBU
		if BTBU then
			self:CState("VTBApplied", BTBU.VTBApplied == true)
			self:CState("RVTBLeak", Pneumatic.RVTBLeak == 1)
			self:CState("SKTripped", BTBU.SKTripped == true)
			self:CState("K35Closed", BTBU.K35Closed == true)
		end

		self:CState("BLPressure", not BUFTPower and self.States["BLPressure"] or math.Round(Pneumatic.BrakeLinePressure,1))
		self:CState("TLPressure", not BUFTPower and self.States["TLPressure"] or math.Round(Pneumatic.TrainLinePressure,1))
		self:CState("Pn3Pressure", math.Round(Pneumatic.Pn3Pressure or 2.2,1))
		self:CState("BCPressure", not BUFTPower and self.States["BCPressure"] or math.Round((Pneumatic.FrontBogeyBrakeCylinderPressure+Pneumatic.RearBogeyBrakeCylinderPressure)/2,1))
		self:CState("SKPressure", not BUFTPower and self.States["SKPressure"] or math.Round(Pneumatic.AirDistributorPressure,1))
		self:CState("PBPressure", not BUFTPower and self.States["PBPressure"] or math.Round(Pneumatic.ParkingBrakePressure,1))
		self:CState("WeightLoad", not BUFTPower and self.States["WeightLoad"] or math.Round(Pneumatic.WeightLoadRatio,2))
		for i=1,8 do
			self:CState("DPBT"..i,Train:GetPackedBool("BC"..i))
		end
		local Train = self.Train
		local closed = true
		for i=1,4 do
			if self.Orientation then
				local j = 5 - i
				self:CState("Door"..i.."Closed", Train.BUD.RightDoorState[j] == 0)
				self:CState("Door"..(i+4).."Closed", Train.BUD.LeftDoorState[j] == 0)
				self:CState("Door"..i.."Stack", Train.BUD.RightDoorStucked[j])
				self:CState("Door"..i.."Reverse", ((Train.BUD.AutoReverse or {})[j+4] or 9) < 4)
				self:CState("Door"..(i+4).."Reverse", ((Train.BUD.AutoReverse or {})[j] or 9) < 4)
				self:CState("Door"..(i+4).."Stack", Train.BUD.LeftDoorStucked[j])
			else
				self:CState("Door"..i.."Closed", Train.BUD.LeftDoorState[i] == 0)
				self:CState("Door"..(i+4).."Closed", Train.BUD.RightDoorState[i] == 0)
				self:CState("Door"..i.."Stack", Train.BUD.LeftDoorStucked[i])
				self:CState("Door"..i.."Reverse", ((Train.BUD.AutoReverse or {})[i] or 9) < 4)
				self:CState("Door"..(i+4).."Reverse", ((Train.BUD.AutoReverse or {})[i+4] or 9) < 4)
				self:CState("Door"..(i+4).."Stack", Train.BUD.RightDoorStucked[i])
			end
			do
				local j = self.Orientation and 5 - i or i
				local aR = ((Train.AODStage or {})[2*(j-1)+1] or 0) >= 3
				local aL = ((Train.AODStage or {})[2*(j-1)+2] or 0) >= 3
				self:CState("Door"..i.."Aod", self.Orientation and aR or aL)
				self:CState("Door"..(i+4).."Aod", self.Orientation and aL or aR)
			end
			if closed and (Train.BUD.LeftDoorState[i] ~= 0 or Train.BUD.RightDoorState[i] ~= 0) then closed = false end
			local aod = Train.AODStage or {}
			if (aod[2*(i-1)+1] or 0) >= 3 or (aod[2*(i-1)+2] or 0) >= 3 then closed = false end
		end
		local doorCtrl = Train:ReadTrainWire(69) <= 0
		self:CState("DoorsClosed",closed and doorCtrl and ((not Train["80F2"] or Train["80F2"].Value > 0.5) or self.DisableDoors == 1))
		self:CState("AntiskidOff", Train["23F25"] ~= nil and Train["23F25"].Value < 0.5)

		local KP = Metrostroi775Kp
		if KP then
			local wF = IsValid(Train.FrontBogey) and Train.FrontBogey.Wheels
			local wR = IsValid(Train.RearBogey) and Train.RearBogey.Wheels
			local puWork = not (Train["23F25"] and Train["23F25"].Value < 0.5)
			if puWork then
				if self.EncoderFOk == nil then self.EncoderFOk = true end
				if self.EncoderROk == nil then self.EncoderROk = true end
				if KP.EncoderOk(wF) then self.EncoderFOk = true elseif Train.Speed >= 1.8 then self.EncoderFOk = false end
				if KP.EncoderOk(wR) then self.EncoderROk = true elseif Train.Speed >= 1.8 then self.EncoderROk = false end
			else
				self.EncoderFOk, self.EncoderROk = true, true
			end
			self:CState("EncoderOk", self.EncoderFOk and self.EncoderROk)

			if not KP.WheelsOk(wF) or not KP.WheelsOk(wR) then
				if not self.HullTimer then self.HullTimer = CurTime() + math.Rand(0.6, 1.7) end
			else
				self.HullTimer = nil
			end
			self:CState("HullOk", (Train.Hull775Result or 0) < 1 and not (self.HullTimer and CurTime() >= self.HullTimer))
		end

		if Train.BKPU then
			self:CState("DoorCabLeft",	Train.CabinDoorLeft)
			self:CState("DoorCabRight",	Train.CabinDoorRight)
			self:CState("DoorCabPass",	Train.PassengerDoor)

			self:CState("SF01",1+Train.SF17.Value*Train.SF30.Value*Train.SF29.Value*Train.SF28.Value)
			self:CState("SF02",1+Train.SF12.Value*Train.SF13.Value)
			self:CState("SF03",1+Train.SF27.Value*Train.SF26.Value*Train.SF25.Value)
			self:CState("SF04",1+Train.SF24.Value*Train.SF20.Value*Train.SF23.Value*Train.SF21.Value)
			self:CState("SF05",1+Train.SF22.Value*Train.SF18.Value*Train.SF19.Value)
			self:CState("SF06",1+Train.SF3.Value)
			self:CState("SF07",1+Train.SF7.Value*Train.SF16.Value)
			self:CState("SF08",1+Train.SF8.Value*Train.SF11.Value*Train.SF9.Value*Train.SF10.Value)
			self:CState("SF09",1+Train.SF2.Value)
		end
		self:CState("SF1",1+Train["23F4"].Value)
		self:CState("SF2",1+Train["23F6"].Value*Train["23F11"].Value*Train["23F12"].Value)
		self:CState("SF3",1+Train["23F25"].Value)
		if Train.BUTP then
			self:CState("SF4",1+Train["30F4"].Value*Train["30F3"].Value)
		else
			self:CState("SF4",1+Train["30F4"].Value)
		end
		self:CState("SF5",1+Train["23F13"].Value)
		self:CState("SF6",1+Train["21F1"].Value)
		self:CState("SF7",1+Train["70F6"].Value*Train["70F4"].Value*Train["52F5"].Value*Train["52F4"].Value*Train["52F1"].Value*Train["52F3"].Value)
		self:CState("SF8",1+Train["80F2"].Value*Train["80F12"].Value*Train["80F13"].Value*Train["80F14"].Value)
		self:CState("SF9",1+Train["45F9"].Value*Train["45F8"].Value*Train["45F7"].Value)
		self:CState("SF9",1+Train["45F9"].Value*Train["45F8"].Value*Train["45F7"].Value)
		self:CState("SF10",1+Train["61F4"].Value*Train["61F3"].Value*Train["61F2"].Value*Train["61F1"].Value)
		self:CState("SF11",1+Train["95F2"].Value)

		self:CState("PSN",Train.Electric.PSN>550)

		self:CState("PVU1", self.DisableDoors==1)
		self:CState("PVU2", self.DisableMK==1)
		self:CState("PVU3", self.DisableLights==1)
		self:CState("PVU4", self.DisablePVU4==1)
		self:CState("TRDown", self.Pant == true)
		self:CState("PVU5", self.DisableTP==1)
		self:CState("PVU6", self.DisablePSN==1)
		self:CState("PVU7", self.DisableBV==1)

	    self:CState("BUVTimer", math.floor((CurTime()*2)%10))

	elseif self.States.BUVTimer then
		for k,v in pairs(self.Commands) do
			self.Commands[k] = false
		end
		for k,v in pairs(self.States) do
			self.States[k] = false
		end
	end

	if self.Reset and self.Reset ~= CurTime() then
		self.Reset = nil
	end

	if self:Get("Slope") then self.Slope = CurTime() end
	if not self:Get("Slope") and self.Slope and (Train.Pneumatic.BrakeCylinderPressure < 0.5 or CurTime() - self.Slope > 5) then self.Slope = false end

	local PTReplace = self.States.AsyncEFail
    if PTReplace and not self.PTReplace and Train.Electric.HaveAsyncInverter>0 then
        self.PTReplace =  CurTime()
        if self.States.AsyncProtection == 0 or self:Get("PVU5") or self:Get("PVU6") then
            self.PTReplace = self.PTReplace - 1.2
        elseif self.States.AsyncAssembly then
            self.PTReplace = self.PTReplace + 1.3
        end
    end
    if not PTReplace and self.PTReplace then self.PTReplace = nil end
    local PN =  self.PTReplace and CurTime()-self.PTReplace > 1.2 or self.States.AsyncEDone
    self.PN1 = self:Get("PN1") or PN and (self:Get("DriveStrength") and self:Get("DriveStrength") > 0) or self:Get("ARSBrake") and (Train.Electric.Type>1 or not self.States.AsyncAssembly)
    self.PN2 = self:Get("PN2") or PN and (self:Get("DriveStrength") and (not self.States.AsyncEDone and self:Get("DriveStrength") > 0.2 or self:Get("BrakeTPlus")))

	local brakeEP = self:Get("Brake")
	self.EmerPN3 = self:Get("EmerPN3") == true
	self.ReserveHold = self:Get("ReserveHold") == true
	self.PN1 = (self:Get("PN1") and self:Get("PN1") > 0) or (Train.Electric.Type>1 and brakeEP and self:Get("DriveStrength") > 0.75) or (Train.Electric.Type<2 and brakeEP and self:Get("DriveStrength") > 0 and (self.States.AsyncProtection == 0 or self:Get("PVU5") or self:Get("PVU7")))
	self.PN2 = (Train.Electric.Type>1 and brakeEP and self:Get("DriveStrength") > 0.95) or (Train.Electric.Type<2 and brakeEP and self:Get("DriveStrength") > 0.35 and (self.States.AsyncProtection == 0 or self:Get("PVU5") or self:Get("PVU7"))) or self:Get("SlopeHold") == true or self:Get("EDTPN2") == true
	self.PN3 = (self:Get("PN2") and self:Get("PN2") > 0) or (Train.Electric.Type<2 and brakeEP and self:Get("DriveStrength") > 0.55 and (self.States.AsyncProtection == 0 or self:Get("PVU5") or self:Get("PVU7")))
	self.PN4 = (Train.Electric.Type<2 and brakeEP and self:Get("DriveStrength") > 0.75 and (self.States.AsyncProtection == 0 or self:Get("PVU5") or self:Get("PVU7")))
	self.PN5 = (Train.Electric.Type<2 and brakeEP and self:Get("DriveStrength") > 0.95 and (self.States.AsyncProtection == 0 or self:Get("PVU5") or self:Get("PVU7")))

	self.DisableDoors = self:Get("PVU1") and 1 or 0
	self.DisableLights = self:Get("PVU3") and 1 or 0
	self.DisablePSN = self:Get("PVU6") and 1 or 0
	self.DisablePVU4 = self:Get("PVU4") and 1 or 0
	self.DisableTR = (self:Get("DisablePant") or self:Get("PVU4")) and 1 or 0
	if self.CurrentBUP and self.Commands[self.CurrentBUP] and self.Commands[self.CurrentBUP]["DisablePant"] ~= nil and Train["21F1"].Value > 0.5 then
		local want = self.DisableTR == 1
		if not (want and not self.Pant and Train.Pneumatic.TrainLinePressure < 3) then
			self.Pant = want
		end
	end

	if Train.BUTP then
		self.DisableMK = self:Get("PVU2") and 1 or 0
		self.DisableBV = self:Get("PVU7") and 1 or 0
		self.DisableTP = self:Get("PVU5") and 1 or 0
		if self.BUKPWork then
			self.EnableMK = (self.DisableMK==0 and self:Get("Compressor")) and 1 or 0
		else
			local Pneumatic = Train.Pneumatic
			if Train.Electric.BUFT > 0 then
				local TL = Pneumatic.TrainLinePressure
				self.EnableMK = (self.EnableMK==1 and TL<8.2) and 1 or TL<6.5 and 1 or 0
			end
		end
	end

	if Train.BUTP then
		local hv = Electric.Main750V or 0
		local want = self.State and self:Get("StorageMode") == true and self.DisableBV ~= 1 and self.DisableTP ~= 1 and not self.StorageLocked
		local active = false
		if want then
			if self.StorageActive == true then active = hv < 600 else active = hv < 550 end
		end
		if active then
			self.StorageTime = (tonumber(self.StorageTime) or 0) + dT
			if self.StorageTime >= STORAGE_MAX_TIME then
				self.StorageLocked = true
				active = false
			end
		end
		self:CState("StorageLocked", self.StorageLocked == true)
		self.StorageActive = active
		self.StorageVoltage = active and 400 or 0
		self.KN = active and 1 or 0
	end

	if Train.BUTP then
		local now = CurTime()
		local ctrlPower = self.State and Train["23F4"].Value > 0 and self.Voltage > 54
		local overCurrent = math.abs(Train.BUTP.Current) > BV_TRIP_CURRENT
		local overVoltage = Train.Electric.Main750V > BV_TRIP_VOLTAGE
		local undervoltageWithCurrent = BV_TRIP_ON_SAG and Train.Electric.Main750V > 20 and Train.Electric.Main750V < 530 and Train.BUTP.Current > 100
		local shutdownConditions = overCurrent or overVoltage or undervoltageWithCurrent
		local driverOff = self:Get("BVDisable") == true and Train:ReadTrainWire(14) <= 0
		local resetCount = self:Get("BVEnable")
		if type(resetCount) == "number" then
			if type(self.BVResetSeen) == "number" and resetCount > self.BVResetSeen then
				self.BVprotectiveShutdown = 0
				self.BVattempt2Enable = 0
				self.BVdisableByOwnProtection = false
				self.BVTrips = {}
			end
			self.BVResetSeen = resetCount
		end
		self.BVTrips = self.BVTrips or {}
		for k = #self.BVTrips, 1, -1 do
			if now - self.BVTrips[k] > BV_TRIP_WINDOW then table.remove(self.BVTrips, k) end
		end
		local BV = Train.BV.Value > 0.5
		if not ctrlPower then
			if BV then Train.BV:TriggerInput("Open", 1) end
			self.BVCloseTimer = nil
			self.BVprotectiveShutdown = 0
			self.BVattempt2Enable = 0
			self.BVdisableByOwnProtection = false
			self.BVTrips = {}
		elseif BV then
			self.BVCloseTimer = nil
			self.BVattempt2Enable = 0
			if self.DisableBV == 1 or driverOff then
				Train.BV:TriggerInput("Open", 1)
			elseif shutdownConditions then
				Train.BV:TriggerInput("Open", 1)
				self.BVdisableByOwnProtection = true
				table.insert(self.BVTrips, now)
				if #self.BVTrips > BV_MAX_RECLOSE then self.BVprotectiveShutdown = 1 end
			end
		else
			local want = self.DisableBV == 0 and not driverOff and self.BVprotectiveShutdown == 0
			if want then
				if not self.BVCloseTimer then
					local retry = self.BVdisableByOwnProtection or self.BVattempt2Enable > 0
					self.BVCloseTimer = now + (retry and Rand(4.5,5.5) or Rand(5,10))
				elseif now >= self.BVCloseTimer then
					self.BVCloseTimer = nil
					if shutdownConditions then
						self.BVattempt2Enable = self.BVattempt2Enable + 1
						if self.BVattempt2Enable >= BV_MAX_ATTEMPTS then self.BVprotectiveShutdown = 1 end
					else
						Train.BV:TriggerInput("Close", 1)
						self.BVdisableByOwnProtection = false
					end
				end
			else
				self.BVCloseTimer = nil
			end
		end
		self:CState("BVBlocked", self.BVprotectiveShutdown == 1)
	end

	self.PSN = self.DisablePSN == 0
	self.Orientation = Train:ReadTrainWire(1) > 0
	self.RevOrientation = Train:ReadTrainWire(2) > 0
	local BadOrientation = false
	if self.Orientation and self.Orientation  == self.RevOrientation then
		self.Orientation = false
		self.RevOrientation = false
		BadOrientation = true
	end
	if self.State and self.Orientation ~= self.RevOrientation then
		if not self.BadOrientation and self.OrientateBUP and (not self.Commands[self.OrientateBUP] or self.Orientation and self.Commands.Forward ~= self.OrientateBUP or self.RevOrientation and self.Commands.Back ~= self.OrientateBUP) then
			if self.Orientation then self.Commands.Forward = self.OrientateBUP else self.Commands.Back = self.OrientateBUP end
			self.OrientateBUP = nil
		elseif BadOrientation then
			self.OrientateBUP = nil
		end
	elseif not self.State then self.OrientateBUP = nil end
	local ReOrientation = self.State and (self.Orientation or self.RevOrientation) and (self.Orientation ~= self.PrevOrientation or self.RevOrientation ~= self.PrevRevOrientation or self.CurrentBUP ~= (self.Orientation and self.Commands.Forward or self.Commands.Back))
	if ReOrientation then
		self.CurrentBUP = self.Orientation and self.Commands.Forward or self.Commands.Back
		self.Reset = CurTime()
		if self.CurrentBUP then
			self.Commands[self.CurrentBUP]  = {}
			Train:CANWrite("BUV",Train:GetWagonNumber(),"BKPU",self.CurrentBUP,"Get")
		end
	end
	self.BadOrientation = BadOrientation
	self.PrevOrientation = self.State and self.Train:ReadTrainWire(1) > 0
	self.PrevRevOrientation = self.State and self.Train:ReadTrainWire(2) > 0

	local brake = self:Get("Brake") and 1 or 0
	local strength = (self.Slope or brake>0 and Train.Pneumatic.BrakeCylinderPressure < 1.5 or brake==0 and Train.Pneumatic.BrakeCylinderPressure < 0.5) and self:Get("DriveStrength") or 0
	self.Drive = (1-brake)*(strength>0 and 1 or 0)
	self.Brake = brake*(strength>0 and 1 or 0)
	local BCPressure = self.States.BCPressure or 0
	strength = strength*100
	if self.Brake>0 and BCPressure < 1.5 or self.Drive>0 and (BCPressure < 0.5 or self.Slope) then
		self.Strength = math.floor(strength+0.5)
	else
		self.Strength = 0
	end
	if self.Orientation then
		self.DF = self:Get("DR") and 1 or 0
		self.DR = self:Get("DF") and 1 or 0
	else
		self.DF = self:Get("DF") and 1 or 0
		self.DR = self:Get("DR") and 1 or 0
	end

	self.CompressorsCanWork = (self:Get("CompressorsCanWork") and not self:Get("PVU2")) and 1 or 0
	self.CompressorSignal = (self:Get("CompressorCommand") and 1 or 0)*self.CompressorsCanWork
end
