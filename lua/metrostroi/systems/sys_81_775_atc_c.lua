Metrostroi.DefineSystem("81_775_ATC_C")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize(parameters)
	self.Set = parameters

	self.Active = 0

	self.SpeedLimit = 0
	self.NextLimit = 0

	self.Ring = 0
	self.Overspeed = false

	self.Brake = 0
	self.Brake2 = 0
	self.Drive = 0
	self.Braking = false
	self.LN = false
	self.PN1 = 0
	self.PN2 = 0
	self.BTB = 0
	self.BTBReady = 0
	self.RVTB = 0
	self.BINoFreq = 0
	self.RVTBResetTimer = CurTime()
	self.RVTBReset = true
	self.KBApply = false
	self.OverTimer = nil
	self.OverAcked = false
	self.OverLatch = false
	self.AB = false
	self.NextNoFreq = false
	self.Speed1 = 0
	self.TwoToSix = false

	self.LastUpdate = CurTime()
end

function TRAIN_SYSTEM:Outputs()
    return {"Set","Active","Ring","Brake","Brake2","Drive","PN1","PN2","UOS", "SpeedLimit", "BTB","BINoFreq","UOS","AB","NextNoFq","BadFq"}
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:TriggerInput(name,value)
end

function TRAIN_SYSTEM:Think(dT)
    local Train = self.Train
    local ALS = Train.ALSCoil

	local ALSVal = Train.ALSDecoder.Value*(Train.ALSVal == 2 and 1 or 0)*Train.SF6.Value

	local Power = (Train.Electric.Power*Train["SF"..(self.Set==1 and 5 or 6)].Value)>0

	local ATCB = Train.ATSBlock.Value
	local Active = Power and ((self.Set==1 and ATCB ~= 1) or (self.Set==2 and ATCB ~= 2)) and ATCB ~= 3

	local UOS = (ATCB == 3) and (Train.RV.KROPosition ~= 0 or Train.RV.KRRPosition ~= 0)

	local DAU = Train.ALSFreq.Value  == 0
	local TwoToSix = Train.ALSFreq.Value  > 0
	local EnableALS = Train.Electric.Power > 0 and Train.RV.KROPosition ~= 0 or Train.RV.KRRPosition ~= 0
	if EnableALS ~= (ALS.Enabled==1) then
		ALS:TriggerInput("Enable",EnableALS and 1 or 0)
	end

	if Power and self.LastUpdate+0.1 <= CurTime() then

		self.NoFreq = not self.AB and ALS.NoFreq > 0
		self.BINoFreq = not self.AB and 0 or ALS.NoFreq

		self.F1 = ALS.F1 > 0 and not self.NoFreq
		self.F2 = ALS.F2 > 0 and not self.NoFreq
		self.F3 = ALS.F3 > 0 and not self.NoFreq
		self.F4 = ALS.F4 > 0 and not self.NoFreq
		self.F5 = ALS.F5 > 0 and not self.NoFreq
		self.F6 = ALS.F6 > 0 and not self.NoFreq
		self.RealF5 = self.F5 and not self.F4 and not self.F3 and not self.F2 and not self.F1

		self.NoFreq = self.NoFreq or not self.AB and (not self.F1 and not self.F2 and not self.F3 and not self.F4 and not self.F5)

		self.UOS = false
		self.UOSActive = false
		self.UOSP = ATCB == 3
		self.KBUOS = (Train.PB.Value > 0.5 or Train.Attention.Value > 0.5) and UOS

		local speed = 3
		if Train.MFDU.State > 0 then
			self.Speed1 = math.Round(ALS.Speed*10)/10
			speed = self.Speed1
		elseif Train.MFDU.State == -1 then
			speed = 99
			self.Speed1 = 99
		elseif self.Speed1 > 2 then
			speed = self.Speed1
		end

		self.Speed = speed

		if ALSVal ~= self.PrevALS then
			if ALSVal == 0 then
				if self.Speed < self.SpeedLimit+0.2 then
					self.Ready = true
					self.ReadyTimer = nil
				end
			end
			self.PrevALS = ALSVal
		end

		self.KB = (Train.PB.Value > 0.5 or Train.Attention.Value > 0.5) and self.Active
		self.KVT = (Train.AttentionBrake.Value > 0.5)
		if self.KVT then
			self.KVTTimer = CurTime()+1
		end
		if self.KVTTimer and CurTime()-self.KVTTimer > 0 then self.KVTTimer = false end
		local Active = Power
		if self.BTB == 0 then
			self.RVTB = 0
		end
		local Emer = Train.RV["KRR15-16"] > 0
		local KMState = Train.BKPU.ControllerPosition*10
		local BUPKMState = Train.BKPU.PowerCommand*10
		if Emer then
			KMState = (Train.EmerX1.Value > 0 or Train.EmerX2.Value > 0) and 1 or 0
			BUPKMState = (Train.EmerX1.Value > 0 or Train.EmerX2.Value > 0) and 1 or 0
		end

		if EnableALS and Train.BKPU.Active then

			local Vlimit = 20
			local VLimit2
			if self.F5 then Vlimit = 0 end
			if self.F4 then Vlimit = 40 end
			if self.F3 then Vlimit = 60 end
			if self.F2 then Vlimit = 70 end
			if self.F1 or self.AB then Vlimit = 80 end

			self.SpeedLimit = VLimit2 or Vlimit+0.5
			self.NextLimit = VLimit2 or Vlimit
			local count = 0
			if self.F1 then self.NextLimit = 80 count = count + 1 end
			if self.F2 then self.NextLimit = 70 count = count + 1 end
			if self.F3 then self.NextLimit = 60 count = count + 1 end
			if self.F4 then self.NextLimit = 40 count = count + 1 end
			if self.F5 then self.NextLimit = 20 count = count + 1 end
			if self.AB then self.NextLimit = 80 count = count + 1 end
			if self.F6 then count = count + 1 end
			self.NextNoFq = not self.AB and (DAU or ((not self.F1 and not self.F2 and not self.F3 and not self.F4 and not self.F5) or TwoToSix and self.LN and count == 1) and not ALS.AO or ALS.AO and not self.F5)
			if TwoToSix and self.F6 and self.SpeedLimit > 21 then self.NextNoFq = false end

			if not TwoToSix and (self.NextLimit ~= math.max(20,Vlimit) or self.F6) and not self.AB then
				self.SpeedLimit = 0
				self.NextLimit = self.SpeedLimit
				self.NoFreq = true
				self.BINoFreq = 1
			end
			if TwoToSix and self.F4 and self.F6 then
				self.LN = true
			end
			self.BadFq = (ALS.OneFreq == 1 or ALS.TwoFreq == 1 and not self.LN or self.NoFreq) and TwoToSix and not ALS.AO
			if self.BadFq and (self.F4 or self.F3 or self.F2 or self.F1) then
				self.SpeedLimit = self.LN and 40 or (self.KB and 20 or 0)
			end
			if self.SpeedLimit < 20 and self.KB then
				self.SpeedLimit = 20
			end

			if self.NextLimit > self.SpeedLimit then
				self.NextLimit = self.SpeedLimit
			end
			if DAU or Train.BKL and not TwoToSix then
				self.NextLimit = nil
			end

		else
			self.SpeedLimit = 0
			self.NextLimit = 0
		end
		if Active and Train.BKPU.Active and not UOS then
			if Emer then
				if self.Speed < 1.8 then
					self.BTB = (Train:ReadTrainWire(45)+Train:ReadTrainWire(19) > 0 and 1 or 0)
				else
					self.BTB = 1
				end
			elseif self.Speed <= 0.1 then
				self.BTB = 1
			end
			local Drive = self.Drive > 0
			local Brake = self.Brake > 0
			local SpeedLimit = self.SpeedLimit
			if TwoToSix and (not self.LN or self.NextLimit == math.max(20,SpeedLimit) and self.F6 == 0) then
				SpeedLimit = math.min(40,SpeedLimit)
			end

			if self.KB and Train.RV.KRRPosition == 0 then SpeedLimit = 20 end
			if self.Speed > SpeedLimit
				 or (self.NoFreq or self.RealF5) and not self.KB and self.Speed > 0.1
				 or self.Braking and not Brake or ALS.AO and KMState > 0 and self.KB then
				 if not Brake and (SpeedLimit > 20 or self.Speed > 0) then
					 self.Braking = CurTime()
					 self.PN1Timer = CurTime()
				 end
				 if not Brake and (SpeedLimit > 20 or self.Speed > 0 or ALS.AO) then self.Ringing = true end
				 Brake = true
			elseif self.Speed < SpeedLimit and not self.Braking and KMState <= 0 then
				Brake = false
			end
			if (self.Ringing or self.Braking) and self.KVT then
				self.Braking = false
				self.Ringing = false
			end
			if (BUPKMState > 0 and self.Drive > 0) and self.PN2 > 0 then
				if not self.Starting  then
					self.Starting = CurTime()
				end
				self.PN2 = 0
			end
			if self.Speed < 1.8 and KMState <= 0 then
				self.RollingBraking = CurTime()
			elseif KMState > 0 then
				self.RollingBraking = nil
			end
			if self.RollingTimer and CurTime()-self.RollingTimer > 1 and not self.RollingBraking then
				self.RollingBraking = CurTime()
				self.RollingTimer = nil
			end
			if self.RollingBraking and KMState > 0 or Train.Speedometer.State <= 0 then self.RollingBraking = CurTime() end
			if self.Starting and CurTime() - self.Starting > 6 then
				if self.Speed < 1.5 then self.RollingBraking = CurTime() end
				self.Starting = nil
			end
			if Brake and Train.Acceleration < -0.6 and self.Speed > 0 then self.BrakeEfficiency = CurTime() end
			if (not Brake or math.Round(self.Speed) == 0) and self.BrakeEfficiency then self.BrakeEfficiency = nil end
			if self.BrakeEfficiency and KMState <= 0 and self.Speed < 0.1 then self.BrakeEfficiency = nil end
			if self.PN1Timer and (CurTime()-self.PN1Timer > 1.5 or not Brake) then self.PN1Timer = nil end
			if self.Speed > SpeedLimit-1.1 and KMState > 0 and not Emer then
				self.DisableDrive = true
				self.ControllerInDrive = KMState > 0
			end
			if self.Speed < SpeedLimit-3 and KMState <= 0 or Emer then
				self.DisableDrive = false
				self.ControllerInDrive = false
			end
			if self.ControllerInDrive and (not self.DisableDrive or KMState <= 0) then self.ControllerInDrive = false end
			if self.DisableDrive and not self.ControllerInDrive and KMState > 0 and Train.Speedometer.State > 0 then
				if not self.Braking then self.Braking = CurTime() end
				if not self.PN1Timer then self.PN1Timer = CurTime() end
				self.Ringing = true
				Brake = true
			end
			if not (Train.Speedometer.State > 0) then
				Brake = false
				self.DisableDrive = true
				self.Ringing = false
			end
			if self.Speed < 5 and not self.PN1Timer and (BUPKMState < 0 or self.Drive == 0) and not self.NoFreq then
				self.PN1Timer = CurTime()
				self.Starting = nil
			end
			if self.Speed < 1 and not self.PN2Timer and (BUPKMState < 0 or self.Drive == 0) and not self.NoFreq then
				self.PN2Timer = CurTime()
				self.Starting = nil
			end
			if ALS.AO then
				self.NoFreq = not DAU and (ALS.F5 == 0)
				if Train.BKL and self.KVT and self.RingingAO then
					self.RingingAO = false
				end
				self.Ringing = self.RingingAO
			elseif not self.RingingAO then
				self.RingingAO = true
				self.Ringing = false
			end
			Drive = not self.DisableDrive and (
												(self.NoFreq or self.RealF5) and self.KB
												or not self.NoFreq and not self.RealF5
											) and not Brake and not Brake2
			self.PN1 = (ALS.AO or self.PN1Timer) and 1 or 0
			self.PN2 = (ALS.AO or self.PN2Timer) and 1 or 0
			self.Ring = self.Ringing and 1 or 0
			self.Brake = Brake and 1 or 0
			self.Brake2 = Brake2 and 1 or 0
			self.Drive = Drive and 1 or 0

			if Train.Pneumatic.RVTBLeak == 0 then
			self.RVTB = 1
			end
			if     Train.MFDU.State <= 3 then
			self.RVTB = 0
			end
			if self.BrakeEfficiency and CurTime()-self.BrakeEfficiency >= 3.6 then
			self.RVTB = 0
			end

			if (Train.BKPU.State and 1 or 0)*Train.SF9.Value == 1 then
				if self.BUKPState ~= 5 then
					self.RVTB = 1
					self.BUKPState = 5
				end
				if not Emer then
					if (self.NoFreq or self.SpeedLimit < 21) and not self.KB and KMState > 0 and self.KBApply then
						self.DisableDrive = true
						self.ControllerInDrive = true
					end
					if (self.NoFreq or self.SpeedLimit < 21) and KMState > 0   and self.KB and not self.KBApply then self.KBApply = true end
					if (self.NoFreq or self.SpeedLimit < 21) and KMState <=0 and (self.KBApply or self.KBApplyTimer) then self.KBApply = false self.KBApplyTimer = nil end
					if (self.NoFreq or self.SpeedLimit < 21) and not self.KB and KMState > 0 and Train.MFDU.State == 4 and not self.KBApply then
						if not self.KBApplyTimer then
							self.KBApplyTimer = CurTime()+5
						end
						self.PN1 = 1
						if not self.PN2Timer then self.PN2Timer = CurTime() end
					end
					if self.KBApplyTimer and CurTime()-self.KBApplyTimer > 0 and (self.NoFreq or self.SpeedLimit < 21) then
						self.RVTB = 0
					elseif self.KBApplyTimer and not (self.NoFreq or self.SpeedLimit <21) then
						self.KBApplyTimer = nil
					end
				end
				if Train.Electric.LSD == 0 and (KMState > 0) and Train.DoorBlock.Value == 0 then
					self.RVTB = 0
				end
				if Train.BKPU.Error == 2 then
					self.BTB = 0
				end
			elseif self.BUKPState ~= 0 then
				self.BUKPState = 0
			end
			if   (Train.MFDU.State == 4 and KMState <= 0 and ((not self.RollingBraking or CurTime()-self.RollingBraking == 0 or Emer) and self.NoFreq or self.SpeedLimit < 21)) then
				self.RVTB = 1
			end
			if self.RollingBraking and CurTime()-self.RollingBraking > 0 and not Emer then
				self.RVTB = 0
			end
			if Train.SF9.Value == 0 and Train.RV.KROPosition ~= 0 then
				self.PN2 = 1
			end
			if Train.MFDU.State == 4 then
				if Emer then
					if self.Brake > 0 or self.RollingBraking and CurTime()-self.RollingBraking > 0 then
					end
					if self.Speed < 0.5 and KMState > 0 then
						self.RVTB = 1
					elseif self.Speed < 0.5 then
						self.RVTB = 0
						self.PN1 = 1
					end

					if (self.NoFreq or self.SpeedLimit < 21) and KMState <=0 then self.KBApply = self.KB end
					if self.SpeedLimit <= 21 and (not self.KBApply and KMState > 0 or not self.KB) then
						self.Drive = 0
						self.RVTB = 0
						self.PN1 = 1
					else
						self.Drive = 1
					end
					self.DisableDrive = false
					self.ControllerInDrive = false
					if self.PN1+self.PN2 > 0 and self.Speed < 0.5 then
						self.RVTB = 0
					end
					if self.Brake > 0 then
						self.RVTB = 0
						self.PN1 = 1
						self.Ring = 1
					end
				end
				if Train.BKL then
					if not Emer then
						if self.Brake > 0 and not self.RVTBTimer then
							self.RVTBTimer = CurTime()+5
						end
						if self.RVTBTimer and self.Brake == 0 then self.RVTBTimer = nil end
						if self.RVTBTimer and CurTime()-self.RVTBTimer > 0 then
							self.RVTB = 0
						end
					end
					if ALS.NoFreq == 1 and EnableALS then
						if not self.ABPressed1 and Train.AB.Value > 0 then self.ABPressed1 = CurTime() end
						if not self.ABPressed2 and self.KVT then self.ABPressed2 = CurTime() end
						if self.ABPressed1 and self.ABPressed2 and math.abs(self.ABPressed1-self.ABPressed2) < 1 then
							self.AB = true
						end
					end
					if ALS.NoFreq == 0 or Train.AB.Value == 0 then self.ABPressed1 = nil end
					if ALS.NoFreq == 0 or not self.KVT then self.ABPressed2 = nil end
					if self.AB and EnableALS and ALS.F1+ALS.F2+ALS.F3+ALS.F4+ALS.F5+ALS.F6 > 0 then
						self.AB = false
					end
				end
			end
			if self.RVTBReset then
				self.RVTB = 1
				self.RVTBReset = false
			end
		else
			if self.RVTB == 0 and not self.RVTBReset then
				if not self.RVTBResetTimer then self.RVTBResetTimer = CurTime() end
			end
			if self.RVTBTimer then self.RVTBTimer = nil end
			if not UOS and self.RollingBraking then self.RollingBraking = nil end
			self.BrakeEfficiency = nil
			if (not self.RVTBReset and self.RVTB == 1 or self.RVTBResetTimer and CurTime()-self.RVTBResetTimer > 3) then
				self.RVTBReset = true
				self.RVTBResetTimer = nil
			end
			self.RVTB = (self.KVT or ALSVal > 0.5) and 1 or 0
			if ALSVal > 0 and Train.MFDU.State == 4 and not UOS then
				self.PN1 = 0
				self.PN2 = 0
				self.Ring = 0
				self.Brake = 0
				self.Brake2 = 0
				self.Drive = 1

				self.BTB = 1
				self.DisableDrive = false
			elseif UOS then
				self.UOS = true

				self.BTB = 1
				local Speed = self.Speed
				if Train.RV["KRO9-10"] > 0.5 then
					self.BTB = self.KB and 1 or 0
					if self.KB then
						self.UOSActive = true
						self.SpeedLimit = 35.5
						self.NoFreq = false
						if TwoToSix then
							self.SpeedLimit = 35.5
							self.NoFreq = false
							self.NextLimit = 0
						else
							self.SpeedLimit = 35.5
							self.NoFreq = false
						end
					end
					if ALSVal == 0 then
						if Speed > self.SpeedLimit and not self.UOSBraking then
							self.UOSBraking = true
						elseif Speed == 0 and self.UOSBraking then
							self.UOSBraking = false
						end
					elseif self.UOSBraking then
						self.UOSBraking = false
					end
					if Train.RV.KROPosition > 0 then
						if Speed < 1.8 and KMState <= 0 then
							self.RollingBraking = CurTime()
						elseif KMState > 0 then
							self.RollingBraking = nil
						end
						if self.RollingBraking and KMState > 0 then self.RollingBraking = CurTime() end
					elseif self.RollingBraking then
						self.RollingBraking = nil
					end
					self.Drive = (self.KB and (ALSVal == 1 or Speed < 35.5)) and 1 or 0
					self.RVTB = (Train.SF4.Value+Train.SF5.Value == 0 or self.RollingBraking and CurTime()-self.RollingBraking > 0 or self.UOSBraking) and 0 or 1
				elseif Train.RV["KRR15-16"] > 0.5 then
					if not self.KB then
						self.BTB = 0
					end
					self.UOSActive = false
					self.RVTB = (self.KB and 1 or 0)
					self.Drive = 1
				end
				self.PN1 = 0
				self.PN2 = 0
				self.Brake = 0

			elseif ALSVal > 0 then
				self.PN2 = 1
			else
				self.BTB = 0
				self.Brake = 0
				self.Drive = 0
				self.Ring = 0
				self.PN1 = 0
				self.PN2 = 0
			end
			self.Starting = nil
			self.Braking = false
			self.Ringing = false
			self.Ring = 0
			self.RingingAO = true
			self.LN = Train.MFDU.State > 0 and self.LN
			self.BINoFreq = 1
		end
		if not self.UOS then
			if Train.MFDU.State < 4 or (not Power or Train.MFDU.State < 4) then
				self.BTB = (not UOS and (ALSVal == 1)) and 1 or self.BTB
				self.Ready = false
				self.PN2Timer = nil
				self.ReadyTimer = nil
			end
			if Power and not self.Ready and Train.BKPU.Active and Train.MFDU.State == 4 and not self.ReadyTimer then
				self.ReadyTimer = CurTime()
			end
			if self.ReadyTimer and CurTime()-self.ReadyTimer > 0 then
				self.RVTB = 0
			end
				if Power and Train.MFDU.State > 0 and KMState <=0 and self.Speed < 1.8 then
					self.PN1 = 1

					if not self.PN2Timer then self.PN2Timer = CurTime() end
					self.Ready = true
					if self.ReadyTimer and CurTime()-self.ReadyTimer == 0 then self.ReadyTimer = nil end
					self.PN1T = true
				end
				if Power ~= self.PrevPower and Train.MFDU.State == 4 and KMState <=0 and self.Speed < 1.8 then
					self.PN2Timer = CurTime()-2
					self.PrevPower = Power
				end

				if Power and Train.MFDU.State == 4 and KMState > 0 and self.PN1T then self.PN1T = false self.PN2Timer = nil end
				if Power and Train.MFDU.State == 4 and KMState <=0 and self.PN1T then
					self.PN1 = 1
				end
				if Power and self.PN2Timer and CurTime()-self.PN2Timer > 2.5 then
					self.PN2 = 1
				end

		end
		if Power and Train.RV.KROPosition ~= 0 and (Train.SF4.Value == 0 or Train.SF6.Value == 0 or Train.SF3.Value == 0) then
			self.RVTB = 0
		end
		self.RVTB = (Train.Electric.V2 == 0 and 1 or self.RVTB)

		if Power and self.Brake > 0 and self.Speed >= 1.8 then
			if self.KVT then
				self.OverTimer = nil
				self.OverAcked = true
			elseif not self.OverAcked then
				self.OverTimer = self.OverTimer or CurTime()
			end
			if self.OverTimer and CurTime()-self.OverTimer >= 4 then self.OverLatch = true end
		else
			self.OverTimer = nil
			self.OverAcked = false
		end
		if self.OverLatch then
			self.RVTB = 0
			if (KMState <= 0 and self.KVT) or (Train.RV.KROPosition == 0 and Train.RV.KRRPosition == 0) then self.OverLatch = false end
		end
		if not Power then self.OverLatch = false end

		self.TwoToSix = TwoToSix and not DAU

		self.LastUpdate = CurTime()
	end

	self.Active = Active
	self.Power = Power
end
