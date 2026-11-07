AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local function BRK(ent,id)
	local r = ent[id]
	return (not r) or (r.Value or 1) > 0.5
end
local ANTISLIP_OFF_K = 0.85

ENT.BogeyDistance = 650
ENT.SyncTable = {
	"SF31","SF32","SF33","SF34","SF36","SF37","SF38","SF39","SF40","SF41","SF42","SF57",
	"SF43","SF44","SF45","SF46","SF47","SF48","SF49","SF50","SF51","SF52","SF53","SF54","SF55","SF56",
	"K40","K41","K53","K31","K40_cap","K41_cap","K53_cap","K18","K19","K23","K22",
	"RearBrakeLineIsolation","RearTrainLineIsolation",
	"FrontBrakeLineIsolation","FrontTrainLineIsolation",
	"23F6", "30F4", "45F14", "95F1", "22F1", "23F4", "23F12", "23F11", "23F13", "23F25", "23F26", "23F27",
	"30F3", "90F1", "45F2", "45F7", "45F8", "45F9", "45F1", "45F4", "52F1", "52F4", "52F5", "52F3", "80F2","80F13",
	"80F12", "80F14", "70F4", "70F6", "21F1", "61F4", "61F3", "61F1", "61F2", "95F2",
	"GV","K31","Battery","K23","DriverValveTLDisconnect","DriverValveBLDisconnect","EmergencyBrakeValve","stopkran",
}
function ENT:Initialize()

	self:SetModel("models/metrostroi_train/81-775/776_body.mdl")
	self.BaseClass.Initialize(self)
	self.Plombs = self.Plombs or {}
	for i = 1, 8 do
		self:LoadSystem("AODSeal"..i, "Relay", "Switch", {bass = true})
		self.Plombs["AODSeal"..i] = true
	end
	self.Plombs.Init = true
	self:SetPos(self:GetPos() + Vector(0,0,140))

	local phys = self:GetPhysicsObject()

	if phys then
		self.NormalMass = 19000
	end

	local front_bogey_x = 320
	local rear_bogey_x = -324

	self.FrontBogey = self:CreateBogey(Vector(front_bogey_x,0,-78.3),Angle(0,180,0),true,"763")
	self.RearBogey = self:CreateBogey(Vector(rear_bogey_x,0,-78.3),Angle(0,0,0),false,"763")

	self.FrontBogey:SetNWBool("Async",true)
	self.RearBogey:SetNWBool("Async",true)
	self.FrontBogey:SetNWInt("MotorSoundType",MSMP and 4 or 2)
	self.RearBogey:SetNWInt("MotorSoundType",MSMP and 4 or 2)
	self.FrontBogey:SetNWFloat("SqualPitch",0.75)
	self.RearBogey:SetNWFloat("SqualPitch",0.75)

	self.FrontCouple = self:CreateCouple(Vector(front_bogey_x+100,0,-75),Angle(0,0,0),true,"763")
	self.RearCouple  = self:CreateCouple(Vector(rear_bogey_x-100,0,-75),Angle(0,180,0),false,"763")

	self:SetNW2Entity("FrontBogey",self.FrontBogey)
	self:SetNW2Entity("RearBogey",self.RearBogey)
	self:SetNW2Entity("FrontCouple",self.FrontCouple)
	self:SetNW2Entity("RearCouple",self.RearCouple)

	self.TrainWireCrossConnections = {
		[1] = 2,
		[16] = 17,
		[61] = 65,
		[62] = 66,
	}

	self.Lights = self.Lights or {}
	self.Lights[11] = { "dynamiclight",Vector(380,0,60),Angle(0,0,0),Color(255,236,200),brightness = 1.1475,distance = 512}
	self.Lights[12] = { "dynamiclight",Vector(125,0,60),Angle(0,0,0),Color(255,236,200),brightness = 1.1475,distance = 512}
	self.Lights[13] = { "dynamiclight",Vector(-125,0,60),Angle(0,0,0),Color(255,236,200),brightness = 1.1475,distance = 512}
	self.Lights[14] = { "dynamiclight",Vector(-380,0,60),Angle(0,0,0),Color(255,236,200),brightness = 1.1475,distance = 512}

	self.BARSBlockAnim = -0.1
	self.PassengerDoor = false
	self.CabinDoorLeft = false
	self.CabinDoorRight = false
	self.RearDoor = false
	self.PVZDoor = false
	self.Chair = false
	self.SpeedTimer = CurTime()

	self.K40_cap = false
	self.K41_cap = false
	self.K53_cap = false

	self:TrainSpawnerUpdate()
end

function ENT:TrainSpawnerUpdate()
end
function ENT:Think()
	local retVal = self.BaseClass.Think(self)

	local fB = self.FrontBogey
	local rB = self.RearBogey


	local bsPower = self.Electric.Power > 0
	local lightsBlocked = self.BUV and self.BUV.DisableLights == 1
	local lightMain = bsPower and BRK(self,"52F1") and not lightsBlocked
	local lightEmer = bsPower and BRK(self,"52F3")
	local salonOn = lightMain or lightEmer
	local hvK = (self.Electric.Main750V >= 550) and 1 or 0.3
	for i=11,14 do self:SetLightPower(i,salonOn,hvK*(lightMain and 1 or 0.3)) end
	self:SetPackedBool("BSPower", bsPower)
	self:SetPackedBool("SalonLighting1", salonOn)
	self:SetPackedBool("SalonLighting2", lightMain)
	self:SetPackedBool("SalonEmer", salonOn and not lightMain)
	self:SetPackedBool("DoorLightL", bsPower and BRK(self,"52F5"))
	self:SetPackedBool("DoorLightR", bsPower and BRK(self,"52F4"))
	self.FireSystemOn = bsPower and BRK(self,"90F1")
	self:SetPackedBool("PVZDoor", self.PVZDoor)
	self:SetPackedBool("SalonHV", self.Electric.Main750V >= 550)

	self:SetPackedRatio("Speed", self.Speed)

	if self.FrontTrain ~= self.PrevFrontTrain then
		self:SetNW2Entity("FrontTrain",self.FrontTrain)
		self.PrevFrontTrain = self.FrontTrain
	end
	if self.RearTrain ~= self.PrevRearTrain then
		self:SetNW2Entity("RearTrain",self.RearTrain)
		self.PrevRearTrain = self.RearTrain
	end

	self:SetPackedRatio("Crane", self.Pneumatic.DriverValvePosition)
	self:SetPackedRatio("BL", self.Pneumatic.BrakeLinePressure/16.0)
	self:SetPackedRatio("TL", self.Pneumatic.TrainLinePressure/16.0)
	local bcF, bcR = self.Pneumatic.FrontBogeyBrakeCylinderPressure, self.Pneumatic.RearBogeyBrakeCylinderPressure
	self:SetPackedRatio("BC", math.min(3.8,bcF)/6.0)
	for i=1,4 do
		self:SetPackedBool("TR"..i, self.BUV.Pant and true or false)
	end
	for i=1,8 do
		local bcp = i < 5 and bcF or bcR
		if i==1 or i==4 or i==5 or i==8 then
			self:SetPackedBool("BC"..i, math.max(bcp,(i < 5 and (validfB and fB.DisableParking and 0 or 1) or i > 4 and (validrB and rB.DisableParking and 0 or 1))*(4.4-self.Pneumatic.ParkingBrakePressure)/2)<=0.1)
			self:SetPackedRatio("DPBTPressure"..i, math.max(bcp,(i < 5 and (validfB and fB.DisableParking and 0 or 1) or i > 4 and (validrB and rB.DisableParking and 0 or 1))*(4.4-self.Pneumatic.ParkingBrakePressure)/2))
		else
			self:SetPackedBool("BC"..i,bcp<=0.1)
			self:SetPackedRatio("DPBTPressure"..i,bcp)
		end
	end

	self:SetPackedBool("K40_cap",self.K40_cap)
	if self.K40.Value == 0 and not self.K40_cap then
		self.K40_cap = true
	end

	self:SetPackedBool("K41_cap",self.K41_cap)
	if (self.K41.Value == 0 or self.K31.Value == 0) and not self.K41_cap then
		self.K41_cap = true
	end

	self:SetPackedBool("K53_cap",self.K53_cap)
	if self.K53.Value == 0 and not self.K53_cap then
		self.K53_cap = true
	end

	if IsValid(fB) and IsValid(rB) and not self.IgnoreEngine then
		local brake_force = 100000 * (BRK(self,"23F25") and 1 or ANTISLIP_OFF_K)

		fB.PneumaticBrakeForce = brake_force
		fB.BrakeCylinderPressure = self.Pneumatic.FrontBogeyBrakeCylinderPressure
		fB.ParkingBrakePressure = math.max(0,4.4-self.Pneumatic.ParkingBrakePressure)
		fB.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT * (self.K40.Value > 0.5 and 1 or 0)
		fB.DisableContacts = self.BUV.Pant
		rB.PneumaticBrakeForce = brake_force
		rB.BrakeCylinderPressure = self.Pneumatic.RearBogeyBrakeCylinderPressure
		rB.ParkingBrakePressure = math.max(0,4.4-self.Pneumatic.ParkingBrakePressure)
		rB.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT * (self.K41.Value > 0.5 and 1 or 0)
		rB.DisableContacts = self.BUV.Pant
	end

	return retVal
end

function ENT:CreateFence(pos,ang,a)
	local ent = ents.Create("prop_ragdoll")
	if not IsValid(ent) then return end
	ent:SetModel("models/metrostroi_train/81-775/776_mejvag.mdl")
	ent:SetPos(self:LocalToWorld(pos))
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:SetOwner(self:GetOwner())
	ent:SetCollisionGroup( COLLISION_GROUP_WORLD )

	if CPPI and IsValid(self:CPPIGetOwner()) then ent:CPPISetOwner(self:CPPIGetOwner()) end

	ent:GetPhysicsObject():SetMass(1)

	table.insert(self.TrainEntities,ent)
	return ent
end
function ENT:OnCouple(train,isfront)
	if isfront and self.FrontAutoCouple then
		self.FrontBrakeLineIsolation:TriggerInput("Open",1.0)
		self.FrontTrainLineIsolation:TriggerInput("Open",1.0)
		self.FrontAutoCouple = false
	elseif not isfront and self.RearAutoCouple then
		self.RearBrakeLineIsolation:TriggerInput("Open",1.0)
		self.RearTrainLineIsolation:TriggerInput("Open",1.0)
		self.RearAutoCouple = false
	end

	local ent = train:GetNW2Entity("TrainEntity")
	local a,a2 = isfront and -1 or 1,train ~= ent.RearCouple and -1 or 1
	local fence = isfront and "Fence1" or "Fence"
	local s = (train ~= ent.RearCouple and "Fence1" or "Fence")

	if not IsValid(self[fence]) and not IsValid(ent[s]) and ent:GetClass():find("77") and not ent:GetClass():find("775") then
		local pos1,pos2 = self:GetPos(),ent:GetPos()
		local b1,b2 = -self:GetForward()*a,-ent:GetForward()*a2
		local min = 1
		local pos
		for i=475,490,0.001 do
			if (pos1+b1*i):Distance(pos2+b2*i) < min then
				min = (pos1+b1*i):Distance(pos2+b2*i)
				pos = pos1+b1*i
			end
		end
		pos = pos and self:WorldToLocal(pos)
		self[fence] = self:CreateFence(Vector(pos,0,0),Angle(0,0,0),-a)
		ent[s] = self[fence]
		table.insert(ent.TrainEntities,ent[s])
		local bone1,bone2 = 0,1
		local bonen1,bonen2 = self[fence]:GetPhysicsObjectNum(bone1),self[fence]:GetPhysicsObjectNum(bone2)

		bonen1:SetPos(ent:LocalToWorld(Vector(a2 == -1 and 464.37 or -464.07,0,-12)))
		bonen2:SetPos(self:LocalToWorld(Vector(a == -1 and 464.37 or -464.07,0,-12)))
		bonen1:SetAngles(ent:LocalToWorldAngles( a*Angle(0,90*(1-a2+90),90*a)))
		bonen2:SetAngles(self:LocalToWorldAngles(a*Angle(0,90*(1-a),90*a)))
		constraint.Weld( self[fence],self, bone2, 0, 0, 1, false )
		constraint.Weld( self[fence],ent , bone1, 0, 0, 1, false )
		constraint.Weld( self[fence],self, bone2, 0, 0, 1, false )
		constraint.Weld( self[fence],ent , bone1, 0, 0, 1, false )
	end

	self.BaseClass.OnCouple(self,train,isfront)

end
function ENT:OnDecouple(isfront)
	if isfront then
		self.FrontCoupledBogey = nil
	else
		self.RearCoupledBogey = nil
	end
	self:OnConnectDisconnect()
	if self.OnDecoupled then self:OnDecoupled() end

	local fence = isfront and "Fence1" or "Fence"
	if IsValid(self[fence]) then
		self[fence]:Remove()
	end
end

function ENT:OnButtonPress(button,ply)
	if button == "PVZDoor" then self.PVZDoor = not self.PVZDoor end
	do
		local act, sd, k = string.match(button, "^AODDoor(%a+)(%a)(%d)$")
		if act then
			self.AODPush = self.AODPush or {}
			self.AODPush[act..sd..k] = true
			return
		end
	end

	do
		local n = string.match(button, "^AODSeal(%d)Pl$")
		n = tonumber(n)
		if n and n >= 1 and n <= 8 then
			self.AODStage = self.AODStage or {}
			if (self.AODStage[n] or 0) == 0 then
				self.AODStage[n] = 1
				self:SetNW2Int("AOD"..n, 1)
			end
			return false
		end
	end
	do
		local kind, num = string.match(button, "^AOD(%a+)(%d+)$")
		num = tonumber(num)
		if kind and num and num >= 1 and num <= 8 then
			self.AODStage = self.AODStage or {}
			local st = self.AODStage[num] or 0
			if kind == "Cover" then
				if st == 1 then st = 2 elseif st == 2 then st = 1 end
			elseif kind == "Handle" then
				if st == 2 then st = 3 elseif st == 3 then st = 2 end
			end
			self.AODStage[num] = st
			self:SetNW2Int("AOD"..num, st)
			return
		end
	end

end

function ENT:OnButtonRelease(button,ply)
	do
		local act, sd, k = string.match(button, "^AODDoor(%a+)(%a)(%d)$")
		if act then
			self.AODPush = self.AODPush or {}
			self.AODPush[act..sd..k] = nil
			return
		end
	end

	if button == "K40_cap" then
		if self.K40.Value == 1 then
			self.K40_cap = not self.K40_cap
		end
	end

	if button == "K41_cap" then
		if self.K41.Value == 1 and self.K31.Value == 1 then
			self.K41_cap = not self.K41_cap
		end
	end

	if button == "K53_cap" then
		if self.K53.Value == 1 then
			self.K53_cap = not self.K53_cap
		end
	end

end

function ENT:GenerateWagonNumber(i,ws)
	if not ws then return end
	local fn = Metrostroi.Trains775[1]
	local WNumber = 77000
	local T = fn-75000
	if ws < 5 then
		WNumber = WNumber + T
	else
		WNumber = WNumber + T + (i == ws - 1 and 1 or 0)
	end
	self.WagonNumber = WNumber
	self:SetNW2Int("WagonNumber",self.WagonNumber)
	self:UpdateWagonNumber()
end
