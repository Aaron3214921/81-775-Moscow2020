Metrostroi.DefineSystem("81_775_Prost_Kos")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	self.ProstActive = 0
	self.KosActive = 0
	self.Prost = true
	self.Kos = true
	self.Command = 0
	self.EmergencyBrake = 0
	self.CommandKos = false
	self.ProstManual = false
	self.TractionDenied = false
	self.Stop = false
	self.Stop1 = false
	self.Metka = {}

	self.BlockDoorsL = true
	self.BlockDoorsR = true

	self.Timer1 = CurTime()
	self.Metka1 = false
	self.WrongDir = false

	self.sum = 0
	self.dist2 = 350
	self.v0 = 0
end

function TRAIN_SYSTEM:Inputs()
	return { }
end

function TRAIN_SYSTEM:Outputs()
	return { "Command","Metka","ProstActive","EmergencyBrake","BlockDoorsL","BlockDoorsR","PrKos" }
end

function TRAIN_SYSTEM:Think(dT)
	local Train = self.Train
	local Tspeed = math.Round(Train.Speed,2)
	local power = Train.Electric.Power > 0
	local RV = ((1-Train.RV["KRO5-6"]) > 0 or Train.RV["KRR15-16"] > 0) and 1 or 0

	self.Prost = power and Train.MFDU.Prost and Train.MFDU.State == 4 and  RV > 0
	self.Kos = power and Train.MFDU.Kos and Train.MFDU.State == 4 and RV > 0

	if not power and (self.Metka1 or self.BlockDoorsL or self.BlockDoorsR) then
		self.BlockDoorsL = false
		self.BlockDoorsR = false
		self.Metka1 = false
	end

    self.PrevTime = self.PrevTime or CurTime()
    self.DeltaTime = (CurTime() - self.PrevTime)
    self.PrevTime = CurTime()

	if self.Prost then
		if self.Metka[4] or self.Metka[2] or self.Metka[1] then
			self.sum = (self.sum + (self.v0+math.Round(Train.Speed,2)*Train.SpeedSign)*self.DeltaTime/7.2)
		else
			self.sum = 0
		end
		if self.Metka[4] then
			self.dist2 = 350-self.sum
		elseif self.Metka[2] then
			self.dist2 = 54-self.sum
		elseif self.Metka[1] then
			self.dist2 = 43-self.sum
		else
			self.dist2 = 350
		end
		if self.dist2 < -10 then
			self.dist2 = 350
		end
		local dist1 = self.dist2-200
		local dist3 = self.dist2
		local dist2 = self.dist2
		if dist1 and dist2 then
			if self.Metka[3] or self.Metka[4] then
				self.DistToSt = math.max(0,dist1)
			else
				self.DistToSt = 0
			end
		end

		if self.Metka[3] and not self.Metka[4] or self.Metka[4] and not self.Metka[3] and dist1 < -10 then
			self.ProstActive = false
			for k,v in pairs(self.Metka) do
				self.Metka[k] = false
			end
		end
		local Sensor = Train.ProStSensor
		if not IsValid(Sensor) then return end

		local command
		local Programm

		for k,v in ipairs(Sensor.Commands) do
			if v.PlateType == 760 then
				Programm = v.Linked or v
				command = v.Mode
			end
		end

		if Programm and not self.Metka1 then self.Metka1 = true end
		self.Programm = Programm

		local KM = Train.Controller.Controller
		if KM >= 0 then
			self.Command = 0
			if dist2 < 200 and (self.Metka[3] or self.Metka[2]) and self.ProstActive == 1 then
				local targetSpeed = (70.5*(math.max(0.0,math.min(1.0,(dist2)/240))^0.54))+0.4*(dist2 < 48 and 1 or 0)
				if   Train:GetClass()[19] == "a" and #Train.WagonList > 3 then
					if Tspeed+1 > targetSpeed then
						if Tspeed-targetSpeed < 0.38 or Tspeed < 7 then
							self.Command = -2
						else
							self.Command = -3
						end
					elseif Tspeed < targetSpeed-4.5 then
						self.Command = 0
					else
						self.Command = -1
					end
				else
					if Tspeed+1 > targetSpeed then
						if Tspeed-targetSpeed < 2 or Tspeed < 7 then
							self.Command = -2
						else
							self.Command = -3
						end
					elseif Tspeed < targetSpeed-2.75 then
						self.Command = 0
					else
						self.Command = -1
					end
				end
				if Tspeed < 0.1 then
					self.Command = 0
					self.ProstActive = 0
					self.CommandStop = false
				end
			end
		end
		if KM ~= 0 then
			if dist2 >= 350 then
				for k,v in pairs(self.Metka) do
					self.Metka[k] = false
				end
				self.Distance = nil
				self.sum = 0
			end
			if KM < 0 then self.Command = 0 end
		end
		if Programm then
			self.Metk = command
			local find = false
			for k,v in pairs(self.Metka) do
				if Programm == v then
					find = true
				end
			end
			if not find then
				self.Metka[self.Metk] = Programm
			end
			if self.Metka[1] == Programm then
				self.RightDoors = Programm.RightDoors or false
			end
			if Train.Controller.Controller == 0 and not self.Metka[3] and self.Metka[2] == Programm and not self.Metka[1] or self.Metk > 2 then
				self.ProstActive = 1
			end
		elseif dist1 > 0 and Programm then

		end
		if self.Metka[1] and math.abs(dist2) < 3 then
			self.BlockDoorsL = self.RightDoors
			self.BlockDoorsR = not self.RightDoors
		elseif (not self.BlockDoorsL or not self.BlockDoorsR) and self.Metka1 then
			self.BlockDoorsL = true
			self.BlockDoorsR = true
		end
		if dist2 < 350 then
			if not self.Timer2 then self.Timer2 = CurTime()+2 end
			if self.Timer2 and CurTime()-self.Timer2 > 0 then
				self.prevdist3 = dist3
				self.Timer2 = CurTime()+2
			end
		elseif (self.prevdist3 or self.Timer2) then
			self.prevdist3 = nil
			self.Timer2 = nil
		end
		if dist2 < 350 and self.prevdist3 and dist3-1 > self.prevdist3 then
			self.WrongDir = true
		end
		if dist2 >= 350 and self.WrongDir then
			self.WrongDir = false
		end
		if dist2 < 200 and KM < 0 and (self.Metka[3] or self.Metka[2]) then
			if self.ProstActive == 1 then self.ProstManual = true end
			self.ProstActive = 0
		end
		if KM >= 0 or dist2 >= 200 or not (self.Metka[3] or self.Metka[2]) then self.ProstManual = false end
		self.TractionDenied = self.ProstActive == 1 and KM > 0 and (self.Command or 0) < 0
		if dist2 >= 350 and (self.ProstActive == 1 and not self.Metka[2]) or self.WrongDir then
			self.ProstActive = 0
			self.Distance = nil
			self.Dist = nil
			self.DistToSt = 0
		elseif dist2 < 350 then
			self.Dist = dist2
		end
	else
		self.Dist = nil
		self.Command = 0
		self.DistToSt = 0
		self.WrongDir = false
		self.ProstManual = false
		self.TractionDenied = false
		if Train.BKL and not Train.BUKP.Ovr then
			self.BlockDoorsL = false
			self.BlockDoorsR = false
		end
		if RV > 0 and power and Train.MFDU.State == 4  then
			if not self.Kos then
				if self.Metka[4] or self.Metka[2] then
					self.sum = (self.sum + (self.v0+math.Round(Train.Speed,2)*Train.SpeedSign)*self.DeltaTime/7.2)
				else
					self.sum = 0
				end
				if self.Metka[4] then
					self.dist2 = 350-self.sum
				elseif self.Metka[2] then
					self.dist2 = 54-self.sum
				else
					self.dist2 = 350
				end
			end

			local dist2 = self.dist2

			local Sensor = Train.ProStSensor
			if not IsValid(Sensor) then return end

			local command
			local Programm

			for k,v in ipairs(Sensor.Commands) do
				if v.PlateType == 760 then
					Programm = v.Linked or v
					command = v.Mode
				end
			end

			if Programm and not self.Metka1 then self.Metka1 = true end
			self.Programm = Programm
			if Programm and command == 1 and not self.Metka[1] then
				self.Metka[1] = Programm
				self.RightDoors = Programm.RightDoors or false
			end
			if Programm and command == 2 and not self.Metka[2] then
				self.Metka[2] = Programm
			end
			if self.Metka[1] and dist2 and math.abs(dist2) < 3 then
				self.BlockDoorsL = self.RightDoors
				self.BlockDoorsR = not self.RightDoors
			elseif (not self.BlockDoorsL or not self.BlockDoorsR) and self.Metka1 then
				self.BlockDoorsL = true
				self.BlockDoorsR = true
			end

		else
			self.Programm = false
		end
	end
	if self.Kos then
		if not self.Prost then
			if self.Metka[4] or self.Metka[2] or self.Metka[1] then
				self.sum = (self.sum + (self.v0+math.Round(Train.Speed,2)*Train.SpeedSign)*self.DeltaTime/7.2)
			else
				self.sum = 0
			end
			if self.Metka[4] then
				self.dist2 = 350-self.sum
			elseif self.Metka[2] then
				self.dist2 = 54-self.sum
			elseif self.Metka[1] then
				self.dist2 = 43-self.sum
			else
				self.dist2 = 350
			end
			if self.dist2 < -10 then
				self.dist2 = 350
			end
		end

		local dist1 = self.dist2-200
		local dist2 = self.dist2

		local Sensor = Train.ProStSensor
		if not IsValid(Sensor) then return end
		local command
		local Programm

		for k,v in ipairs(Sensor.Commands) do
			if v.PlateType == 760 then
				Programm = v.Linked or v
				command = v.Mode
			end
		end

		if Programm then
			self.Metk = command
			local find = false
			for k,v in pairs(self.Metka) do
				if Programm == v then
					find = true
				end
			end
			if not find then
				self.Metka[self.Metk] = Programm
			end
			if Tspeed > 2.3 then
				if self.Metka[2] == Programm and self.Metka[1] then
					self.CommandKos = true
					self.WrongPath = true
				end
				if self.Metka[1] == Programm and not self.Metka[2] then
					self.CommandKos = true
					self.WrongPath = true
				end

			end
		end
		if Programm then
			if self.Metka[2] == Programm and Tspeed > 40 then
				self.CommandKos = true
			end
			if self.Metka[1] == Programm and Tspeed > 20 then
				self.CommandKos = true
			end
		end
		if dist1 < 0 and Tspeed < 1 and not self.Stop then
			self.Stop = true
		end
		if self.Metka[1] and dist2 < -3 and not self.Stop1 and self.PrKos and not self.WrongPath then
			self.CommandKos = true
			if Tspeed > 10 then
			end
			self.PrKos = false
		end
		if not self.Metka[1] and not self.Metka[2] and not self.Metka[3] and not self.Metka[4] and not self.PrKos then
			self.PrKos = true
		end
		if not self.Metka[2] and not self.Metka[1] and self.Stop then
			self.Stop = false
		end
		if self.Metka[1] and Tspeed < 1 and math.abs(dist2) < 3 and not self.Stop1 then
			self.Stop1 = true
		end
		if not self.Metka[2] and not self.Metka[1] and self.Stop1 then
			self.Stop1 = false
		end
		if not self.Metka[2] and not self.Metka[1] and self.WrongPath then
			self.WrongPath = false
		end
		if (RV == 0 or Train.Controller.Controller < -0.5) and self.CommandKos then
			self.CommandKos = false
			self.KosTimer = nil
			self.EmergencyBrake = 0
			self.Stop = false
			self.PrevSpeed = nil
		end
		if self.CommandKos and not self.KosTimer then
			self.KosTimer = CurTime()+1
		end
		if self.CommandKos and CurTime()-self.KosTimer > 0 then
			self.PrevSpeed = Tspeed
			self.KosTimer = CurTime()+1
		end
		if self.CommandKos and Tspeed < 8 and Train.Pneumatic.EmerBrakeWork then
		end
	else
		self.CommandKos = false
		self.Stop = false
		self.Stop1 = false
		self.EmergencyBrake = 0
		if not self.Prost then
		end
	end
	self.v0 = math.Round(Train.Speed,2)*Train.SpeedSign
end
