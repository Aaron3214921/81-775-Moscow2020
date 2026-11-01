Metrostroi.DefineSystem("81_775_BTBU")
TRAIN_SYSTEM.DontAccelerateSimulation = true

local W_BLOCK, W_ARMED, W_SUPPLY, W_BREAK, W_INIT = 55, 56, 57, 58, 59
local W_CRANE = 60
local W_RESLEAK = 67
local W_RESCHG = 68

TRAIN_SYSTEM.ResetTime       = 2
TRAIN_SYSTEM.BreakerResetTime = 10
TRAIN_SYSTEM.MovingSpeed     = 1.8
TRAIN_SYSTEM.StopResetWindow = 20
TRAIN_SYSTEM.StopResetDischarge = 1.0
TRAIN_SYSTEM.InitBreaksLoop  = true
TRAIN_SYSTEM.NeedBlockConfirm = true

function TRAIN_SYSTEM:Initialize()
	if self.Train.K35 and not self.Train.Stopkran then self.Train:LoadSystem("Stopkran","Relay","Switch") end
	self.CabKey = false
	self.CabOn = false
	self.Standby = false
	self.LoopBroken = false
	self.ARSOK = true
	self.Supply = false
	self.Blocked = false
	self.BlockConfirmed = not self.NeedBlockConfirm
	self.VTBApplied = false
	self.RVTBCmd = false
	self.RVTBLatched = false
	self.RVTBVent = false
	self.CraneToBC = false
	self.ReserveLeak = false
	self.ReserveNoCharge = false
	self.CraneDumpMask = false
	self.CycleDone = false
	self.WasOffSinceLatch = false
	self.RVTBLoopCause = false
	self.PrevStandby = false
	self.KeyOffTimer = nil
	self.StopResetUntil = nil
	self.PrevButton = false
	self.SKTripped = false
	self.SKCause = false
	self.K35Closed = false
	self.LocalBreak = false
	self.OffTimer = nil
end

function TRAIN_SYSTEM:Inputs() return {} end
function TRAIN_SYSTEM:Outputs()
	return {"Standby","LoopBroken","ARSOK","Supply","Blocked","VTBApplied","RVTBCmd","RVTBLatched","RVTBVent","CabOn","CabKey","CraneToBC","ReserveLeak","ReserveNoCharge"}
end
function TRAIN_SYSTEM:TriggerInput(name,value) end

function TRAIN_SYSTEM:ConfirmBlock() self.BlockConfirmed = true end

function TRAIN_SYSTEM:Think(dT)
	local Train = self.Train
	local Pneu = Train.Pneumatic
	local isHead = Train.BKPU ~= nil and Train.K35 ~= nil
	local RV = Train.RV

	local localBreak = false
	if isHead then
		self.SKTripped = Pneu.EmergencyValve == true
		self.K35Closed = Train.K35.Value < 0.5
		local shunt = Train.VTBBlock.Value == 1
		localBreak = self.SKTripped and not shunt
		local ebv = Train.EmergencyBrakeValve
		if ebv ~= nil and ebv.Value > 0.5 then localBreak = true end
		if Pneu.DriverValvePosition == 7 then localBreak = true end
	end
	self.LocalBreak = localBreak
	Train:WriteTrainWire(W_BREAK, localBreak and 1 or 0)

	if isHead then
		local Electric = Train.Electric
		local RR = RV.KROPosition ~= 0 or RV.KRRPosition ~= 0
		local BadRR = RV.KROPosition ~= 0 and RV.KRRPosition ~= 0
		local cabKey = Electric.Power > 0 and RR and not BadRR
		local cabOn = cabKey and Train.SF9.Value > 0
		self.CabKey, self.CabOn = cabKey, cabOn

		if cabOn then
			self.OffTimer = nil
		else
			if not self.OffTimer then self.OffTimer = CurTime() end
			local need = cabKey and self.BreakerResetTime or self.ResetTime
			if self.Standby and CurTime() - self.OffTimer >= need then self.Standby = false self.SKCause = false end
		end

		local button = Train.EmergencyBrake.Value > 0.5
		local crane7 = Pneu.DriverValvePosition == 7
		local k29Open = Train.KPRRKM ~= nil and Train.KPRRKM.Value < 0.5
		self.CraneDumpMask = false
		local sd = Train.BKPU.SDTrip == true
		local remote = Train:ReadTrainWire(W_BREAK) > 0
		local broken = button or crane7 or sd or remote
		self.LoopBroken = broken

		local ebv = Train.EmergencyBrakeValve
		local sk = Train.Stopkran or Train.stopkran
		local cockOpen = (ebv ~= nil and ebv.Value > 0.5) or (sk ~= nil and sk.Value > 0.5)
		if cockOpen then
			self.StopOpened = true
		elseif self.StopOpened then
			self.StopOpened = false
			self.StopResetUntil = CurTime()
		end
		if button and not self.PrevButton then self.StopResetUntil = nil self.StopMinTM = nil end
		self.PrevButton = button
		if not cabOn then self.StopOpened = false self.StopResetUntil = nil self.StopMinTM = nil end
		local nominal = Pneu.ReserveGoPressure or 5.0
		if cockOpen or self.StopResetUntil then
			local tmMin = Train.BKPU.TMMin
			if tmMin and (not self.StopMinTM or tmMin < self.StopMinTM) then self.StopMinTM = tmMin end
		end
		local discharged = self.StopMinTM ~= nil and self.StopMinTM <= nominal - (self.StopResetDischarge or 1.0)
		local recharged = Train.BKPU.TMAllFull == true
		if self.StopResetUntil and self.Standby and not self.SKCause and not cockOpen and not broken and discharged and recharged then
			self.Standby = false
			self.StopResetUntil = nil
			self.StopMinTM = nil
		end
		local absd = Train.EmerBlockSD ~= nil and Train.EmerBlockSD.Value > 0.5
		local otherBreak = button or crane7 or remote
		if self.Standby and self.SDCause and not self.SKCause and absd and cabOn and not broken then
			self.Standby = false
			self.SDCause = false
			self.RVTBLoopCause = false
			self.StopResetUntil = nil
			self.StopMinTM = nil
		end
		if cabOn and self.SKTripped then self.SKCause = true end
		if self.SKCause and self.K35Closed and cabOn and not (button or crane7) and not self.SKTripped then
			self.Standby = false
			self.SKCause = false
			self.SDCause = false
			self.RVTBLoopCause = false
			self.StopResetUntil = nil
			self.StopMinTM = nil
			if Train.BKPU then Train.BKPU.SDArmed = false Train.BKPU.SDTrip = false end
			sd = false
			broken = button or crane7 or remote
			self.LoopBroken = broken
		end
		if cabOn and broken then
			if not self.Standby then
				self.SDCause = sd and not otherBreak
			elseif otherBreak then
				self.SDCause = false
			end
			self.Standby = true
		end
		if not self.Standby then self.SDCause = false end

		if not self.Standby then
			self.RVTBLoopCause = false
		elseif sd and Pneu.RVTBLeak == 1 and not (button or crane7 or remote) then
			self.RVTBLoopCause = true
		end
		if button or crane7 or remote then self.RVTBLoopCause = false end
		if self.Standby and self.RVTBLoopCause and not self.SKCause and cabOn and Pneu.RVTBLeak == 0
			and Train.BKPU.TMAllFull == true and not broken then
			self.Standby = false
			self.RVTBLoopCause = false
			self.StopResetUntil = nil
			self.StopMinTM = nil
		end

		local ATSB = Train.ATSBlock.Value
		local speed = math.abs(Train.Speed or 0)
		local ms = Train.MFDU.State or 0
		local init = self.InitBreaksLoop and ms > 0 and ms < 4
		local relevant = speed >= self.MovingSpeed or init
		local function key(i, atc, sf)
			if ATSB == 3 then
				if RV.KRRPosition ~= 0 then return true end
				local pedal = Train.PB.Value > 0.5 or Train.Attention.Value > 0.5
				return (pedal and not atc.UOSBraking) or not relevant
			end
			if ATSB == i then return true end
			if sf.Value <= 0 then return false end
			if atc.OverLatch then return false end
			return atc.RVTB ~= 0 or not relevant
		end
		self.ARSOK = key(1, Train.ATC1, Train.SF5) and key(2, Train.ATC2, Train.SF6)

		local upiOK = Train.SF4.Value > 0 or RV.KROPosition == 0
		self.Supply = cabOn and not self.Standby and self.ARSOK and upiOK
		local want = cabKey and Train.VTBBlock.Value == 2 and Train.SF10.Value > 0
		self.Blocked = want and self.BlockConfirmed
		if not want then self.BlockConfirmed = not self.NeedBlockConfirm end

		local rvtbTrip = cabKey and (Train.SF8.Value <= 0 or not self.ARSOK)
		self.RVTBCmd = rvtbTrip

		local V4 = Train:GetNW2Bool("V4")
		local initPhase = ms > 0 and ms < 4
		if cabKey then
			if self.KeyOffTimer then
				if CurTime() - self.KeyOffTimer >= self.ResetTime then self.CycleDone = true end
				self.KeyOffTimer = nil
			end
			if rvtbTrip and V4 and not initPhase then
				if not self.RVTBLatched then self.CycleDone = false end
				self.RVTBLatched = true
			end
			if self.RVTBLatched and not rvtbTrip and (self.CycleDone or not self.WasOffSinceLatch) then
				self.RVTBLatched = false
				self.WasOffSinceLatch = false
			end
		else
			if not self.KeyOffTimer then self.KeyOffTimer = CurTime() end
			if self.RVTBLatched then self.WasOffSinceLatch = true end
		end
		self.RVTBVent = self.RVTBLatched or (rvtbTrip and V4)

		local reserve   = cabKey and RV.KRRPosition ~= 0 and RV.KROPosition == 0
		local needVigil = Train.ATSBlock.Value == 3
		local vigilance = (Train.PB.Value > 0.5 or Train.Attention.Value > 0.5) or not needVigil
		local hod       = Train.EmerX1.Value > 0.5 or Train.EmerX2.Value > 0.5
		local k9open = Train.KRRH3 == nil or Train.KRRH3.Value > 0.5
		reserve = reserve and k9open
		self.ReserveNoCharge = (reserve and not (vigilance and hod)) and true or false
		local moving = speed >= self.MovingSpeed
		self.ReserveLeak = (reserve and not (vigilance and (hod or moving))) and true or false
		Train:WriteTrainWire(W_RESLEAK, self.ReserveLeak and 1 or 0)
		Train:WriteTrainWire(W_RESCHG, (Train.BKPU.ReserveCharged == true) and 1 or 0)

		Train:WriteTrainWire(W_ARMED,  cabKey and 1 or 0)
		Train:WriteTrainWire(W_INIT,   (cabKey and ms >= 4) and 1 or 0)
		Train:WriteTrainWire(W_SUPPLY, self.Supply and 1 or 0)
		Train:WriteTrainWire(W_BLOCK,  self.Blocked and 1 or 0)

		self.CraneToBC = cabKey and self.Standby and k29Open and self.Blocked and Pneu.CraneActive == true and true or false
		Train:WriteTrainWire(W_CRANE, self.CraneToBC and 1 or 0)
	end

	local armed   = Train:ReadTrainWire(W_ARMED)  > 0
	local supply  = Train:ReadTrainWire(W_SUPPLY) > 0
	local blocked = Train:ReadTrainWire(W_BLOCK)  > 0
	self.BlockWire = blocked
	self.VTBApplied = armed and not supply and not blocked
end
