Metrostroi.DefineSystem("81_775_BKPU")
TRAIN_SYSTEM.DontAccelerateSimulation = true
local OutsideTempCV

function TRAIN_SYSTEM:Initialize()
	self.CurrentCab = false
	self.Trains = {}
	self.PVU = {}

	self.Power = 0
	self.OF = 0
	self.RU = 0

	self.CompressorCommand = false

	self.LPT = false

	self.Speed = 0

	self.PowerCommand = 0

	self.DoorLeft = 0
	self.DoorRight = 0
	self.Active = false
	self.FullActive = false
	self.Back = 0
	self.BOSD = 0

	self.ControllerPosition = 0
	self.KMFault = false
	self.KMMid = false

	self.DoorsClose = 0
	self.DoorsSelectLeft = 0
	self.DoorsSelectRight = 0
	self.DoorsOpenLeft = 0
	self.DoorsOpenRight = 0
	self.DoorBlockedLeft = false
	self.DoorBlockedRight = false
	self.V0 = 0

	self.ATC1Active = false
	self.ATC2Active = false

	self.NotWork = false

	self.DoorsLock = false
	self.DoorsRestoreTimer = nil
	self.DoorStartAttempt = false
	self.PadWarmup = false
	self.EDTReplace = false
	self.SlopeEnabled = false
	self.Slope = false
	self.SlopeDone = false
	self.SlopeTimer = 0
	self.SlopeAssembled = nil
end

function TRAIN_SYSTEM:Inputs()
	return {}
end

function TRAIN_SYSTEM:Outputs()
	return {
		"Power","State","Active","OF","RU","DoorsClose","DoorsSelectLeft","DoorsSelectRight","DoorsOpenLeft","DoorsOpenRight","V0",
	}
end

if TURBOSTROI or CLIENT then return end

local SLOPE_SPEED = 2
local SLOPE_HOLD_TIME = 1.0

function TRAIN_SYSTEM:CANReceive(source,sourceid,target,targetid,textdata,data)

	if textdata == "Init" then
		self.UnInitialized[sourceid] = data
		return
	end
	if not self.Trains[sourceid] then return end
	if textdata == "Get" then
		self.Reset = CurTime()
	elseif textdata == "BUKPWork" then
		self.LastBackBUKPAnswer = CurTime()
	elseif self.Trains[sourceid] then
		self.Trains[self.Trains[sourceid]][textdata] = data
	end
end

function TRAIN_SYSTEM:CState(name,value,target,bypass)
	local BUV = self.Train.BUV
	if self.Reset or self.States[name] ~= value or bypass then
		for i,t in ipairs(self.Trains) do
			self.Train:CANWrite("BKPU",BUV.TrainIndex,target or "BUV",t.ID,name,value)
		end
		self.States[name] = value
	end
end

function TRAIN_SYSTEM:CStateTarget(name,targetname,targetsys,targetid,value)
	local BUV = self.Train.BUV
	if self.Reset or self.States[name] ~= value or bypass then
		self.States[name] = value
		self.Train:CANWrite("BKPU",BUV.TrainIndex,targetsys,targetid,targetname,value)
	end
end

function TRAIN_SYSTEM:Think()
	self.NotWork = false
	local Train = self.Train
	local Electric = Train.Electric
	local BUV = Train.BUV
	self.Power = Electric.Power*(Train.SF5.Value+Train.SF6.Value)*(BUV.Voltage > 60 and 1 or 0)
	local Power = self.Power>0
	if self.State ~= Power then
		if Power then
			self.States = {}
			self.Trains = {}
			self.Prepared = CurTime()-9.5
			self.PantCmd = nil
			self.CheckTrain = nil
		else
			self.Prepared = false
			self.CheckTrain = false
			self.Active = false
			self.Back = 0
		end
		self.State = Power
	end
	if self.State and self.Prepared and self.Prepared ~=  true and CurTime()-self.Prepared > 10 then
		self.Prepared = CurTime()
		self.CheckTrain = CurTime()-0.8
		self.UnInitialized = {}
		self.BackCab = nil
		self.Trains = {}
		self.Strength = 0
		self.Train:CANWrite("BKPU",BUV.TrainIndex,"BUV",false,"Init")
	end
	if self.State then
		local RV = Train.RV
		local RR = (RV.KROPosition ~= 0 and Train.SF4.Value > 0) or RV.KRRPosition ~= 0
		local BadRR = RV.KROPosition ~= 0 and RV.KRRPosition ~= 0
		self.Active = (self.Back == 0 and self.Active or self.State and RR and Train.MFDU.Initialized and Train.MFDU.State > 2) and not BadRR
		self.FullActive = self.Active and RR and Train.MFDU.State >= 4
		Electric:TriggerInput("Active",self.Active and 1 or 0)
	end

	if self.CheckTrain and CurTime()-self.CheckTrain > 1 then

		local builded = false
		local curr,new = BUV.TrainIndex
		for i=1,9 do
			for k,t in pairs(self.UnInitialized) do
				if k == curr then
					self.Trains[curr] = table.insert(self.Trains,{Type=t.type,ID=curr})
					if i>1 and t.type==0 then
						builded = true
						break
					end
					if not t.front and not t.rear then
						break
					end
					if t.front and not self.Trains[t.front] then
						new = t.front
					elseif t.rear and not self.Trains[t.rear] then
						new = t.rear
					end
					self.UnInitialized[k] = nil
					break
				end
			end
			if not new or curr==new then
				break
			end
			curr=new
		end
		self.CheckTrain = false
		if builded then
			self.Prepared = true
			for i,t in ipairs(self.Trains) do
				self.Train:CANWrite("BKPU",BUV.TrainIndex,"BUV",t.ID,"Get")
				if t.Type == 0 and t.ID ~= BUV.TrainIndex then
					self.BackCab = t.ID
				end
				self.PVU[i] = {}
			end
		else
			self.Trains = {}
		end
	end
	local back
	if self.Prepared==true then
		Train:SetNW2Int("BKPU_WagNum", #self.Trains)
		self:CState("CabActive",self.Active,"BKPU")
		self:CState("CabFullActive",self.FullActive,"BKPU")
        for i,train in ipairs(self.Trains) do
			if train.OldBUVTimer ~= train.BUVTimer then
                train.BUVWork = CurTime()
                train.OldBUVTimer = train.BUVTimer
            end
            if train.BUVWork and CurTime()-train.BUVWork>3 then
                train.BUVWork = false
            end
			Train:CANWrite("BKPU",Train:GetWagonNumber(),"BUV",train.ID,"BKPUWork")
			if train.Type == 0 and train.ID ~= BUV.TrainIndex and train.CabFullActive then
                back = true
            end
		end
		self.Back = back and 1 or 0
	else
        self.Back = 0
	end
	if self.Prepared==true and self.Active then
		if not self.PVU.Sync then
			for i,t in ipairs(self.Trains) do
				for p=1,7 do
					self.PVU[i][p] = t["PVU"..p]
				end
				Train:CANWrite("BKPU",Train:GetWagonNumber(),"BUV",t.ID,"Orientate",i < #self.Trains/2)
			end
			self.PVU.Sync = true
		end
		for i,t in ipairs(self.Trains) do
			if (not t.BUVWork or CurTime()-t.BUVWork > 3 ) then
				t.BUVNotWork = true
			else
				t.BUVNotWork = nil
			end
		end

		for i,t in ipairs(self.Trains) do
            if self.PVU.Sync then
				for p=1,7 do
					self:CStateTarget("PVU"..i.."_"..p,"PVU"..p,"BUV",t.ID,self.PVU[i][p])
				end
			end

		end

		self.PantCmd = self.PantCmd or {}
		local pos = Train.PantBlock and Train.PantBlock.Value or 0
		local half = #self.Trains/2
		local standing = math.abs(Train.Speed) < 0.5
		for i,t in ipairs(self.Trains) do
			local want = pos == 3 or (pos == 1 and i <= half) or (pos == 2 and i > half)
			if standing or self.PantCmd[i] == nil then self.PantCmd[i] = want end
			self:CStateTarget("DisablePant"..i,"DisablePant","BUV",t.ID,self.PantCmd[i])
		end

		local RV = Train.RV
		local RR = (RV.KROPosition ~= 0 and Train.SF4.Value > 0) or RV.KRRPosition ~= 0

		self.OF = Train.SF3.Value*math.max(0,RV.KROPosition)*(self.FullActive and 1 or 0)
		self:CState("DF",RV.KROPosition==1)
		self:CState("DR",RV.KROPosition==-1)

		do
			local MF = Train.MFDU
			local leto = not MF or MF.CondLeto ~= false
			OutsideTempCV = OutsideTempCV or GetConVar("metrostroi_775_outside_temp")
			local cv = OutsideTempCV
			local tout = cv and cv:GetFloat() or -99
			if tout <= -98 then tout = leto and 24 or -5 end
			self:CState("CondOn", Train.SalonConditioner and Train.SalonConditioner.Value > 0.5 or false)
			self:CState("CondLeto", leto)
			self:CState("OutTemp", math.Round(tout,1))
		end

		local doorsOpen = false
		for i,t in ipairs(self.Trains) do
			if not t.BUVNotWork and not t.DoorsClosed then doorsOpen = true break end
		end
		if doorsOpen then
			self.DoorsLock = true
			self.DoorsRestoreTimer = nil
		elseif self.DoorsLock then
			if not self.DoorsRestoreTimer then
				self.DoorsRestoreTimer = CurTime() + 1 + math.random()*0.4
			elseif CurTime() >= self.DoorsRestoreTimer then
				self.DoorsLock = false
				self.DoorsRestoreTimer = nil
			end
		end
		local DoorsInterlock = self.DoorsLock and Train.DoorBlock.Value < 0.5

		local CommandBraking
		local low, ok, cnt = 0, 0, 0
		for _,t in ipairs(self.Trains) do
			if t.BLPressure and not t.BUVNotWork then
				cnt = cnt + 1
				if t.BLPressure < 2.65 then low = low + 1 end
				if t.BLPressure >= 2.9 then ok = ok + 1 end
			end
		end
		local BTBU = Train.BTBU
		if BTBU and BTBU.CabOn ~= true then self.SDArmed = false end
		if cnt >= 2 and ok*2 >= cnt then self.SDArmed = true end
		if BTBU and BTBU.ReserveLeak then self.SDArmed = false end
		self.SDLowCount = low
		local rgo = Train.Pneumatic.ReserveGoPressure or 5.0
		local rhold = Train.Pneumatic.ReserveHoldPressure or 4.7
		local full, hold = 0, 0
		for _,t in ipairs(self.Trains) do
			if t.BLPressure and not t.BUVNotWork then
				if t.BLPressure >= rgo then full = full + 1 end
				if t.BLPressure >= rhold then hold = hold + 1 end
			end
		end
		local tmMin = nil
		for _,t in ipairs(self.Trains) do
			if t.BLPressure and not t.BUVNotWork and (not tmMin or t.BLPressure < tmMin) then tmMin = t.BLPressure end
		end
		self.TMMin = tmMin
		self.TMAllFull = cnt > 0 and full == cnt
		if cnt > 0 and full == cnt then self.ReserveCharged = true
		elseif cnt == 0 or hold < cnt then self.ReserveCharged = false end
		self.SDTrip = self.SDArmed == true and low >= 2 and Train.EmerBlockSD.Value < 0.5
		self.ControllerPosition = math.Round(Train.Controller.Controller,1)
		do
			local km = Train.Controller.Controller
			local now = CurTime()
			local invalid = km ~= km or km > 1.001 or km < -1.101
			local mid = not invalid and ((km > 0.001 and km < 0.199) or (km < -0.001 and km > -0.199) or (km < -0.951 and km > -0.999))
			if mid then self.KMMidSince = self.KMMidSince or now else self.KMMidSince = nil end
			self.KMMid = self.KMMidSince ~= nil and now - self.KMMidSince > 1
			if invalid or (self.KMMidSince ~= nil and now - self.KMMidSince > 5) then self.KMFault = true end
			local bd = Train.SF32 and Train.SF32.Value > 0.5
			if bd then
				if self.KMFault and self.KMBDOffLong and not self.KMClearAt then self.KMClearAt = now + 15 end
				if self.KMBDOffSince then self.KMBDOffLong = self.KMBDOffLong or (now - self.KMBDOffSince >= 10) end
				self.KMBDOffSince = nil
				if self.KMClearAt and now >= self.KMClearAt and not mid and not invalid then
					self.KMFault = false
					self.KMClearAt = nil
					self.KMBDOffLong = false
				end
				if not self.KMFault then self.KMBDOffLong = false end
			else
				self.KMBDOffSince = self.KMBDOffSince or now
				self.KMBDOffLong = self.KMBDOffLong or (now - self.KMBDOffSince >= 10)
				self.KMClearAt = nil
			end
			if not bd then self.KMFault = true end
			if self.KMFault then self.ControllerPosition = 0 end
		end
        local pos = self.ControllerPosition
		local EDTEmergency = RR and Train.EmergencyBrake.Value > 0.5 and not (BTBU and BTBU.Blocked)
		if EDTEmergency then
			self.PowerCommand = 0
		elseif Train.ATC1.RVTB == 0 then
			if not self.PowerCommandLast then self.PowerCommandLast = self.PowerCommand end
			self.PowerCommand = -1
			CommandBraking = true
		elseif Train.ATC1.Brake > 0 then
			if not self.PowerCommandLast then self.PowerCommandLast = self.PowerCommand end
			self.PowerCommand = Train.ATC1.Brake2 > 0 and -0.9 or Train.ATC1.Brake > 0 and -0.5 or 0
			CommandBraking = true
		elseif self.PowerCommandLast and not Train.ATC1.RVTB and not Train.ATC1.Brake and not Train.ATC1.Brake2 then
			if self.PowerCommandLast < 0 and pos < 0 then
				self.PowerCommand = self.PowerCommandLast
			else
				self.PowerCommand = 0
			end
			self.PowerCommandLast = nil
		elseif Train.Prost_Kos.KosActive and Train.Prost_Kos.CommandKos then
			self.PowerCommand = -1
		elseif Train.Prost_Kos.ProstActive == 1 and Train.Prost_Kos.Command ~= 0 then
			self.PowerCommand = Train.Prost_Kos.Command*0.25
		elseif Train.ATC1.Speed < 1 and pos < 0 then
			self.PowerCommand = -0.5
		elseif Train.EmergencyBrake.Value < 0.5 or (BTBU and BTBU.Blocked) then
			if pos > 0 then
				self.PowerCommand = (Train.ATC1.DisableDrive or Train.ATC1.UOS and not Train.ATC1.KBUOS) and 0 or pos
			elseif pos == 0 then
				self.PowerCommand = 0
			elseif pos < 0 and pos > -11 then
				self.PowerCommand = pos
			else
				self.PowerCommand = -1
			end
		else
			self.PowerCommand = 0
		end

		if Train.RV.KRRPosition ~= 0 and Train.RV.KROPosition == 0 then
			self.PowerCommand = 0
			CommandBraking = false
		end

		local DoorsBrake = false
		if DoorsInterlock and self.PowerCommand > 0 then
			if Train.Speed < 1 then self.DoorStartAttempt = true end
			self.PowerCommand = 0
			DoorsBrake = self.DoorStartAttempt
		else
			self.DoorStartAttempt = false
		end

		self.PadWarmup = Train.Progrev.Value > 0.5 and self.PowerCommand == 0 and Train.Speed > 3

		local EDT_END_SPEED, EDT_HYST = 5, 1.5
		local ctrlBraking = pos < 0 and self.PowerCommand < 0 and not CommandBraking
		local edtEnded = Train.Speed <= EDT_END_SPEED
		if not edtEnded then
			for _,t in ipairs(self.Trains) do
				if t.AsyncEDone == true and not t.BUVNotWork then edtEnded = true break end
			end
		end
		if ctrlBraking and (edtEnded or (self.EDTReplace and Train.Speed <= EDT_END_SPEED+EDT_HYST)) then
			self.EDTReplace = true
		else
			self.EDTReplace = false
		end

		if BTBU and BTBU.VTBApplied and self.PowerCommand > 0 then self.PowerCommand = 0 end
        self.Braking = CommandBraking==true
		local tgt = math.min(self.PowerCommand,1)
		local now = CurTime()
		local sdt = math.Clamp(now - (self.SmoothTime or now), 0, 0.1)
		self.SmoothTime = now
		local cur = self.SmoothCommand or 0
		local function sgn(x) return x > 0 and 1 or x < 0 and -1 or 0 end
		local hardCut = EDTEmergency == true or CommandBraking == true or tgt <= -0.95
			or (DoorsInterlock and tgt <= 0) or (BTBU and BTBU.VTBApplied and tgt <= 0)
		if hardCut then
			cur = tgt
		else
			if tgt ~= 0 and sgn(cur) ~= 0 and sgn(tgt) ~= sgn(cur) then cur = 0 end
			local step = (self.SmoothRate or 1.0) * sdt
			cur = cur + math.Clamp(tgt - cur, -step, step)
		end
		cur = math.Round(cur, 3)
		self.SmoothCommand = cur
		local smoothBrake = cur < 0 or (cur == 0 and tgt < 0)
		self:CState("DriveStrength",math.Round(math.abs(cur),2))
		self:CState("Brake",smoothBrake)
		self:CState("EmerPN3",EDTEmergency == true or DoorsBrake)

		self.V0 = (Train.Speed < 3) and 1 or 0
		self:CState("V0",self.V0)
		if self.FullActive then
			self.DoorsClose = (Train.DoorClose.Value > 0.5) and 1 or 0
			self.DoorsSelectLeft = ((Train.DoorSelectLeft.Value-Train.DoorSelectRight.Value)>0.5) and 1 or 0
			self.DoorsSelectRight = ((Train.DoorSelectRight.Value-Train.DoorSelectLeft.Value)>0.5) and 1 or 0
			local pressLeft  = (Train.DoorOpenLeft.Value*(Train.DoorSelectLeft.Value-Train.DoorSelectRight.Value)) > 0.5
			local pressRight = (Train.DoorOpenRight.Value*(Train.DoorSelectRight.Value-Train.DoorSelectLeft.Value)) > 0.5
			local closing = Train.DoorClose.Value > 0.5
			local wantLeft  = pressLeft and not closing
			local wantRight = pressRight and not closing
			self.DoorsOpenLeft = (wantLeft and self.V0 > 0) and 1 or 0
			self.DoorsOpenRight = (wantRight and self.V0 > 0) and 1 or 0
			self.DoorBlockedLeft = pressLeft and (closing or self.V0 == 0)
			self.DoorBlockedRight = pressRight and (closing or self.V0 == 0)
		else
			self.DoorsClose = 0
			self.DoorsSelectLeft = 0
			self.DoorsSelectRight = 0
			self.DoorsOpenLeft = 0
			self.DoorsOpenRight = 0
			self.DoorBlockedLeft = false
			self.DoorBlockedRight = false
		end
		self:CState("DoorsClose", self.DoorsClose)
		self:CState("DoorsSelectLeft", self.DoorsSelectLeft)
		self:CState("DoorsSelectRight", self.DoorsSelectRight)
		self:CState("DoorsOpenLeft", self.DoorsOpenLeft)
		self:CState("DoorsOpenRight", self.DoorsOpenRight)
		self:CState("BVEnable", self.BVEnable)
		self:CState("BVDisable", self.BVDisable)

		if Train.BVEnable.Value > 0.5 then
			self:CState("BVDisable", false)
			self:CState("BVEnable", true)
		end
		if Train.BVDisable.Value > 0.5 then
			self:CState("BVEnable", false)
			self:CState("BVDisable", true)
		end

		do
			local want = Train.MFDU and Train.MFDU.StorageEnabled == true
			for i,t in ipairs(self.Trains) do
				self:CStateTarget("StorageMode"..i,"StorageMode","BUV",t.ID,(want and (i == 1 or (#self.Trains == 8 and i == #self.Trains))) and true or false)
			end
		end

		local slopeSpeed = math.max(Train.ATC1.Speed or 0, Train.Speed or 0)
		if not self.Active or Train.RV.KRRPosition ~= 0 then self.SlopeEnabled = false end
		if self.SlopeEnabled and slopeSpeed > SLOPE_SPEED then self.SlopeEnabled = false end
		local slopeRequest = self.SlopeEnabled and self.PowerCommand > 0
		if slopeRequest then
			if not self.Slope and not self.SlopeDone then
				self.Slope = true
				self.SlopeTimer = CurTime()
				self.SlopeAssembled = nil
			end
			if self.Slope then
				local motors,assembled = 0,0
				for i,t in ipairs(self.Trains) do
					if not t.BUVNotWork and t.Type and t.Type < 2 then
						motors = motors + 1
						if t.AsyncAssembly then assembled = assembled + 1 end
					end
				end
				if motors > 0 and assembled == motors then
					self.SlopeAssembled = self.SlopeAssembled or CurTime()
				else
					self.SlopeAssembled = nil
				end
				if (self.SlopeAssembled and CurTime() - self.SlopeAssembled >= SLOPE_HOLD_TIME) or CurTime() - self.SlopeTimer > 6 then
					self.Slope = false
					self.SlopeDone = true
				end
			end
		else
			self.Slope = false
			self.SlopeDone = false
			self.SlopeAssembled = nil
		end
		self:CState("Slope",Train.RV.KRRPosition == 0 and self.Slope)
		self:CState("SlopeHold",Train.RV.KROPosition ~= 0 and self.Slope == true)
		self:CState("SlopeSpeed",self.SlopeSpeed)
        self:CState("PN1",math.min(1,Train.ATC1.PN1+((self.PadWarmup or self.EDTReplace) and 1 or 0)))
		self:CState("EDTPN2", self.EDTReplace == true and self.PowerCommand < -0.6)
        local RVr = Train.RV
        local resHold = RVr.KRRPosition ~= 0 and RVr.KROPosition == 0 and (self.ReserveCharged ~= true or (Train.BTBU and Train.BTBU.ReserveLeak == true))
        self:CState("PN2",(resHold and 1) or math.min(1,Train.ATC1.PN2))
        self:CState("ReserveHold", resHold == true)

		self:CState("CompressorsCanWork", Train.MFDU.Initialized)
		self:CState("CompressorCommand", Train.DD1.Value > 0)

	else
		if self.PVU and self.PVU.Sync then
            self.PVU.Sync = false
        end
        self.PowerCommand = 0
		self.SmoothCommand = 0
		self.SmoothTime = nil
		self.SlopeEnabled = false
		self.Slope = false
	end
	 if not self.Active then
		 self.CompressorCommand = false
	 end

	if self.Reset and self.Reset ~= CurTime() then
		if self.PVU then self.PVU.Sync = false end
		self.Reset = nil
	end
	if not self.Active then
		self.OF = 0
		self.SDArmed = false
		self.SDTrip = false
	end
	Train:SetNW2Bool("CabActive",self.Active)
	Train:SetNW2Bool("CabFullActive",self.FullActive)
	Train:SetNW2Bool("BKPUNotWork",self.NotWork)
end
