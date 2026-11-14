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
	"Wiper", "Washer", "EmergencyCompressor", "EmerX1", "EmerX2",

	"BVDisable", "BVEnable", "DoorSelectLeft", "DoorBlock", "DoorBlockk", "DoorSelectRight","SalonConditioner",
	"EmerBlockSD", "EmerBlockSDk", "Autodrive", "Autodrivek", "Ring", "Antison", "Progrev", "DoorOpenLeft", "DoorClose", "DoorOpenRight",

	"KRRk", "EmerBrake", "EmerBrakeAdd", "EmerBrakeRelease","KRRH3","KPRRKM","K35",
	"LinkSC", "HornB", "AttentionMessage", "Attention", "AttentionBrake",
	"ALSFreq","RPDPPower","NightStay","TLBL","VTBBlock","EmerLDOp","EmerRDOp","ParkingBrake","EmerPower","PantBlock",
	"Microphone", "R_Program1", "EmergencyBrake",
	"K40","K41","K53","K31","K40_cap","K41_cap","K53_cap","K18","K19","K23","K22",
	"SF1","SF2","SF3","SF4","SF5","SF6","SF7","SF8","SF9","SF10","SF11","SF12","SF13","SF14",
	"SF15","SF16","SF17","SF18","SF19","SF20","SF21","SF22","SF23","SF24","SF25","SF26","SF27","SF28",
	"SF29","SF30",
	"SF31","SF32","SF33","SF34","SF36","SF37","SF38","SF39","SF40","SF41","SF42","SF57",
	"SF43","SF44","SF45","SF46","SF47","SF48","SF49","SF50","SF51","SF52","SF53","SF54","SF55","SF56",

	"23F5", "23F6", "30F4", "45F14", "95F1", "22F1", "23F4", "23F12", "23F11", "23F13", "23F25", "23F26", "23F27",
	"30F3", "90F1", "45F2", "45F7", "45F8", "45F9", "45F1", "45F4", "52F1", "52F4", "52F5", "52F3", "80F2","80F13",
	"80F12", "80F14", "70F4", "70F6", "21F1", "61F4", "61F3", "61F1", "61F2", "95F2",

	"FrontBrakeLineIsolation","RearBrakeLineIsolation","FrontTrainLineIsolation","RearTrainLineIsolation","K27","GV",

	"R_ASNPMenu","R_ASNPUp","R_ASNPDown","R_ASNPOn","R_Program1",

	"EmergencyBrakeValve",

	"Stopkran",

	"ChargeAKB", "EnableBS", "DisableBS", "ALSDecoder", "_Rezerv",

	"DLDoor1","DLDoor2","DLDoor3","DLDoor4",
	"DRDoor1","DRDoor2","DRDoor3","DRDoor4",
	"DLDoor1k","DLDoor2k","DLDoor3k","DLDoor4k",
	"DRDoor1k","DRDoor2k","DRDoor3k","DRDoor4k",

	"R_0","R_GGO","R_Direction","R_Enter",
	"CoupleCenteringF",
}

local NewMetrostroi = Metrostroi.Version >= 1623941696

function ENT:Initialize()
	local a = game.GetIPAddress()
	if a == "185.97.255.43:27882" or a == "185.97.255.43:27578" then
		return
	end
	self:SetModel("models/metrostroi_train/81-775/775_body.mdl")
	self.BaseClass.Initialize(self)
	self.Plombs = self.Plombs or {}
	for i = 1, 8 do
		self:LoadSystem("AODSeal"..i, "Relay", "Switch", {bass = true})
		self.Plombs["AODSeal"..i] = true
	end
	self.Plombs.PantBlock = true
	self.Plombs.ATSBlock = true
	self.Plombs.VTBBlock = true
	self.Plombs.TLBL = true
	self.Plombs.K35 = true
	self.Plombs.KRRH3 = true
	self.Plombs.DoorBlockk = true
	self.Plombs.EmerBlockSDk = true
	self.Plombs.Init = true
	self:SetPos(self:GetPos() + Vector(0,0,100))

	self.DriverSeat = self:CreateSeat("driver",Vector(438.2,16,-28))
	self.InstructorsSeat = self:CreateSeat("instructor",Vector(410,45,-40),Angle(0,90,0),"models/vehicles/prisoner_pod_inner.mdl")
	self.InstructorsSeat2 = self:CreateSeat("instructor",Vector(445,-30,-40),Angle(0,90,0),"models/vehicles/prisoner_pod_inner.mdl")
	self.InstructorsSeat3 = self:CreateSeat("instructor",Vector(400,-45,-30))

	self.DriverSeat:SetRenderMode(RENDERMODE_NONE)
	self.DriverSeat:SetColor(Color(0,0,0,0))
	self.DriverSeat:SetNoDraw(true)
	self.InstructorsSeat:SetRenderMode(RENDERMODE_NONE)
	self.InstructorsSeat:SetColor(Color(0,0,0,0))
	self.InstructorsSeat2:SetRenderMode(RENDERMODE_NONE)
	self.InstructorsSeat2:SetColor(Color(0,0,0,0))
	self.InstructorsSeat3:SetRenderMode(RENDERMODE_NONE)
	self.InstructorsSeat3:SetColor(Color(0,0,0,0))

	self.CardInserted = false
    self.PrevReverserState = 0

	local front_bogey_x = 330
	local rear_bogey_x = -334

	self.FrontBogey = self:CreateBogey(Vector(front_bogey_x,0,-68.3),Angle(0,180,0),true,"760F")
	self.RearBogey = self:CreateBogey(Vector(rear_bogey_x,0,-68.3),Angle(0,0,0),false,"760")

	self.FrontBogey:SetNWBool("Async",true)
	self.RearBogey:SetNWBool("Async",true)
	self.FrontBogey:SetNWInt("MotorSoundType",MSMP and 4 or 2)
	self.RearBogey:SetNWInt("MotorSoundType",MSMP and 4 or 2)
	self.FrontBogey:SetNWFloat("SqualPitch",0.75)
	self.RearBogey:SetNWFloat("SqualPitch",0.75)

	self.FrontCouple = self:CreateCouple(Vector(front_bogey_x+110,0,-65),Angle(0,0,0),true,"763")
	self.RearCouple  = self:CreateCouple(Vector(rear_bogey_x-120,0,-65),Angle(0,180,0),false,"763")

    self.FrontCouple:SetModel("models/metrostroi_train/81760/81_763a_couple_ekk.mdl")

	self:SetNW2Entity("FrontBogey",self.FrontBogey)
	self:SetNW2Entity("RearBogey",self.RearBogey)
	self:SetNW2Entity("FrontCouple",self.FrontCouple)
	self:SetNW2Entity("RearCouple",self.RearCouple)

	self.KeyMap = {
		[KEY_W] = "ControllerKVUp",
		[KEY_S] = "ControllerKVDown",

		[KEY_1] = "ControllerKV1",
		[KEY_2] = "ControllerKV2",
		[KEY_3] = "ControllerKV3",
		[KEY_4] = "ControllerKV4",
		[KEY_5] = "ControllerKV5",
		[KEY_6] = "ControllerKV6",
		[KEY_7] = "ControllerKV8",
		[KEY_8] = "ControllerKV8",
		[KEY_9] = "KRO-",
		[KEY_0] = "KRO+",

		[KEY_A] = "DoorLeft",
		[KEY_D] = "DoorRight",
		[KEY_V] = "DoorClose",
		[KEY_G] = "BVEnableSet",
		[KEY_SPACE] = "PBSet",

		[KEY_P] = "ParkingBrakeToggle",

		[KEY_EQUAL] = "R_Program1Set",
		[KEY_RBRACKET] = "R_Program1Set",
		[KEY_MINUS] = "Micro",

		[KEY_B] = "AttentionMessageSet",
		[KEY_M] = "AttentionBrakeSet",
		[KEY_N] = "AttentionSet",
		[KEY_H] = "ProgrevToggle",

		[KEY_K] = "MFDUCard",

		[KEY_LSHIFT] = {

			[KEY_SPACE] = "AttentionBrakeSet",
			[KEY_9] = "KRR-",
			[KEY_0] = "KRR+",
			[KEY_2] = "RingSet",
			[KEY_S] = "ControllerKV7",
			[KEY_L] = "HornEngage",
			[KEY_8] = "KRRk"
		},
		[KEY_LALT] = {
			[KEY_V] = "DoorCloseToggle",
			[KEY_SPACE] = "AttentionMessageSet",
			[KEY_L] = "HornEngageR",
		},
		[KEY_PAD_PLUS] = "EmerBrakeAddSet",
		[KEY_PAD_MINUS] = "EmerBrakeReleaseSet",
		[KEY_F] = "PneumaticBrakeUp",
		[KEY_R] = "PneumaticBrakeDown",
		[KEY_PAD_1] = "PneumaticBrakeSet1",
		[KEY_PAD_2] = "PneumaticBrakeSet2",
		[KEY_PAD_3] = "PneumaticBrakeSet3",
		[KEY_PAD_4] = "PneumaticBrakeSet4",
		[KEY_PAD_5] = "PneumaticBrakeSet5",
		[KEY_PAD_6] = "PneumaticBrakeSet6",
		[KEY_PAD_7] = "PneumaticBrakeSet7",

		[KEY_PAD_DIVIDE] = "EmerX1Set",
		[KEY_PAD_MULTIPLY] = "EmerX2Set",
		[KEY_PAD_9] = "EmerBrakeToggle",

		[KEY_BACKSPACE] = {"EmergencyBrakeToggle",helper="EmergencyBrakeValveToggle"},
		[KEY_L] = "HornBSet",
	}

	self.KeyMap[KEY_RALT] = self.KeyMap[KEY_LALT]
	self.KeyMap[KEY_RSHIFT] = self.KeyMap[KEY_LSHIFT]
	self.KeyMap[KEY_RCONTROL] = self.KeyMap[KEY_LCONTROL]

	self.TrainWireCrossConnections = {
		[1] = 2,
		[16] = 17,
		[61] = 65,
		[62] = 66,
	}

	if not NewMetrostroi then
		self.Lights = {
			[21] = { "light",Vector(488,-60,0), Angle(0,0,0), Color(200,240,255), brightness = 0.5, scale = 2.5},
            [22] = { "light",Vector(488,60,0), Angle(0,0,0), Color(200,240,255), brightness = 0.5, scale = 2.5},

			[11] = { "dynamiclight",Vector(340,0,30),Angle(0,0,0),Color(255,236,200),brightness = 1.3,distance = 512},
			[12] = { "dynamiclight",Vector(180,0,30),Angle(0,0,0),Color(255,236,200),brightness = 1.3,distance = 512},
			[13] = { "dynamiclight",Vector(15,0,30),Angle(0,0,0),Color(255,236,200),brightness = 1.3,distance = 512},
			[14] = { "dynamiclight",Vector(-150,0,30),Angle(0,0,0),Color(255,236,200),brightness = 1.3,distance = 512},
			[15] = { "dynamiclight",Vector(-300,0,30),Angle(0,0,0),Color(255,236,200),brightness = 1.3,distance = 512},
			[16] = { "dynamiclight",Vector(-435,0,30),Angle(0,0,0),Color(255,236,200),brightness = 1.3,distance = 512},
		}
	end
	self.Lights = self.Lights or {}
	self.Lights[10] = nil
	for i,x in ipairs({290,-50,-410}) do
		self.Lights[10+i] = { "dynamiclight",Vector(x,0,105),Angle(0,0,0),Color(255,236,200),brightness = 1.53,distance = 720}
	end
	self.Lights[14] = nil
	self.Lights[15] = nil
	self.Lights[16] = nil
	self.InteractionZones = {
		{
			Pos = Vector(494, 63, 49),
			Radius = 32,
			ID = "CabinLeftDoor"
		},
		{
			Pos = Vector(494, -63, 49),
			Radius = 32,
			ID = "CabinRightDoor"
		},
	}

	self.BARSBlockAnim = -0.1
	self.PassengerDoor = false
	self.K35Closet = false
	self.CabinDoorLeft = false
	self.CabinDoorRight = false
	self.Chair = false
	self.SpeedTimer = CurTime()
	self.WrenchMode = 0
	self.ALSVal = 0
	self.cab_cap1 = false
	self.cab_cap2 = false
	self.cab_cap3 = false
	self.PVZDoor = false

	self.K40_cap = false
	self.K41_cap = false
	self.K53_cap = false

	self.WiperValue = 0

	for i=1,4 do
        self["ChangeDoorsL"..i] = false
        self["ChangeDoorsL"..i.."Dir"] = false
        self["ChangeDoorsR"..i] = false
        self["ChangeDoorsR"..i.."Dir"] = false
    end
	self:TrainSpawnerUpdate()
end

function ENT:NonSupportTrigger()
	self.ALSVal = 2
	self.ALSDecoder:TriggerInput("Set",1)
	self.ATSBlock:TriggerInput("Set",3)
end

function ENT:SetLightPower(index,power,brightness)
	local lightData = self.Lights[index]
	if not lightData then return end
	self.GlowingLights = self.GlowingLights or {}
	self.LightBrightness = self.LightBrightness or {}
	brightness = brightness or 1

	if (power and (self.GlowingLights[index])) and
	   (brightness == self.LightBrightness[index]) then return end

	if (power and (self.GlowingLights[index])) and
	   (brightness ~= self.LightBrightness[index]) then
		local light = self.GlowingLights[index]
		if (lightData[1] == "glow") or (lightData[1] == "light") then
			local brightness = brightness * (lightData.brightness or 0.5)
			light:SetKeyValue("rendercolor",
				Format("%i %i %i",
					lightData[4].r*brightness,
					lightData[4].g*brightness,
					lightData[4].b*brightness
				)
			)
		end
		if (lightData[1] == "headlight") then
			local brightness = brightness * (lightData.brightness or 1.25)
			light:SetKeyValue("lightcolor",
				Format("%i %i %i 255",
					lightData[4].r*brightness,
					lightData[4].g*brightness,
					lightData[4].b*brightness
				)
			)
		end
		if (lightData[1] == "dynamiclight") then
			light:SetKeyValue("_light",
				Format("%i %i %i",
					lightData[4].r*brightness,
					lightData[4].g*brightness,
					lightData[4].b*brightness
				)
			)

		end
		self.LightBrightness[index] = brightness
		return
	end

	SafeRemoveEntity(self.GlowingLights[index])
	self.GlowingLights[index] = nil
	self.LightBrightness[index] = brightness

	if (lightData[1] == "headlight") and (power) then
		local light = ents.Create("env_projectedtexture")
		light.DormantFix1 = true
		light:SetTransmitWithParent(true)
		light:SetParent(self)
		light:SetPos(self:LocalToWorld(lightData[2]))
		light:SetAngles(self:LocalToWorldAngles(lightData[3]))

		light:SetKeyValue("enableshadows", lightData.shadows or 1)
		light:SetKeyValue("farz", lightData.farz or 2048)
		light:SetKeyValue("nearz", lightData.nearz or 16)
		light:SetKeyValue("lightfov", lightData.fov or 120)

		local brightness = brightness * (lightData.brightness or 1.25)
		light:SetKeyValue("lightcolor",
			Format("%i %i %i 255",
				lightData[4].r*brightness,
				lightData[4].g*brightness,
				lightData[4].b*brightness
			)
		)

		light:Spawn()
		light:Input("SpotlightTexture",nil,nil,lightData.texture or "effects/flashlight001")
		self.GlowingLights[index] = light
	end
	if (lightData[1] == "glow") and (power) then
		local light = ents.Create("env_sprite")
		light.DormantFix1 = true
		light:SetTransmitWithParent(true)
		light:SetParent(self)
		light:SetLocalPos(lightData[2])
		light:SetLocalAngles(lightData[3])

		local brightness = brightness * (lightData.brightness or 0.5)
		light:SetKeyValue("rendercolor",
			Format("%i %i %i",
				lightData[4].r*brightness,
				lightData[4].g*brightness,
				lightData[4].b*brightness
			)
		)
		light:SetKeyValue("rendermode", lightData.type or 3)
		light:SetKeyValue("renderfx", 14)
		light:SetKeyValue("model", lightData.texture or "sprites/glow1.vmt")
		light:SetKeyValue("scale", lightData.scale or 1.0)
		light:SetKeyValue("spawnflags", 1)

		light:Spawn()
		self.GlowingLights[index] = light
	end
    if (lightData[1] == "light") and (power) then
        local light = ents.Create("env_sprite")
        light.DormantFix1 = true
        light:SetTransmitWithParent(true)
        light:SetParent(self)
        light:SetLocalPos(lightData[2])
        light:SetLocalAngles(lightData[3])

        local brightness = brightness * (lightData.brightness or 0.5)
        light:SetKeyValue("rendercolor",
            Format("%i %i %i",
                lightData[4].r*brightness,
                lightData[4].g*brightness,
                lightData[4].b*brightness
            )
        )
        light:SetKeyValue("rendermode", lightData.type or 9)
        light:SetKeyValue("renderfx", 14)
        light:SetKeyValue("model", lightData.texture or "sprites/light_glow02.vmt")
        light:SetKeyValue("scale", lightData.scale or 1.0)
        light:SetKeyValue("spawnflags", 1)

        light:Spawn()
        light:Fire("TurnOn","","0")

		if index == 21 or index == 22 then
        self:SetNW2Entity("GlowingLights"..index, light)
		self.GlowingLights[index] = light
    end

	end
	if (lightData[1] == "dynamiclight") and (power) then
		local light = ents.Create("light_dynamic")
		light:SetParent(self)

		light:SetLocalPos(lightData[2])
		light:SetLocalAngles(lightData[3])

		light:SetKeyValue("_light",
			Format("%i %i %i",
				lightData[4].r*brightness,
				lightData[4].g*brightness,
				lightData[4].b*brightness
			)
		)
		light:SetKeyValue("style", 0)
		light:SetKeyValue("distance", lightData.distance or 300)
		light:SetKeyValue("brightness", (lightData.brightness or 2))

		light:Spawn()
		light:Fire("TurnOn","","0")
		self.GlowingLights[index] = light
	end
end
function ENT:TriggerLightSensor(coil,plate)
end
function ENT:RemoveSprings(isfront, coupling)
	local couple = isfront and self.FrontCouple or self.RearCouple
	if not IsValid(couple) or not couple.Centered then return end
	if IsValid(couple.Centered) then couple.Centered:Remove() end
	constraint.RemoveConstraints(couple, "NoCollide")
	if not coupling then
		couple:SetPos(self:LocalToWorld(couple.SpawnPos))
		couple:SetAngles(self:GetAngles() + couple.SpawnAng)
	end
	constraint.AdvBallsocket(self, couple, 0, 0, couple.SpawnPos, Vector(0, 0, 0), 1, 1, -2, -2, -15, 2, 2, 15, 0.1, 0.1, 1)
	constraint.NoCollide(isfront and self.FrontBogey or self.RearBogey, couple, 0, 0)
	constraint.NoCollide(self, couple, 0, 0)
	couple.Centered = false
end

function ENT:SetSprings(isfront, force)
	if not isfront then return end
	if self.CoupleCenteringF and self.CoupleCenteringF.Value > 0 then return end
	if self.FrontCoupledBogey then return end
	local couple = self.FrontCouple
	if not IsValid(couple) or not force and couple.Centered then return end
	constraint.RemoveAll(couple)
	couple:SetPos(self:LocalToWorld(couple.SpawnPos))
	couple:SetAngles(self:GetAngles() + couple.SpawnAng)
	couple.Centered = constraint.Weld(self, couple, 0, 0)
	constraint.NoCollide(self.FrontBogey, couple, 0, 0)
	constraint.NoCollide(self, couple, 0, 0)
end

function ENT:TrainSpawnerUpdate()
	if not IsValid(self.ProStSensor) then
		self.ProStSensor = self:AddLightSensor(Vector(17,65,39.5),Angle(0,0,-90),"models/metrostroi_train/81-717/dkp_reader.mdl")
	end

	timer.Simple(0, function()
		if not IsValid(self) then return end
		self:SetSprings(true, true)
		timer.Simple(3, function()
			if not IsValid(self) then return end
			self:RemoveSprings(true)
			self:SetSprings(true, true)
		end)
	end)
end
function ENT:Think()
	local retVal = self.BaseClass.Think(self)

	if self.CardInserted and self.MFDU then
        local currentReverser = self.RV.KROPosition ~= 0 or self.RV.KRRPosition ~= 0
        local prevReverser = self.PrevReverserState

        if not prevReverser and currentReverser then
            if self.MFDU.State == 1.5 or self.MFDU.State == 2 then
                self.MFDU.Initialized = true
                self.MFDU.State = 4
                self.MFDU.Window = 0
            end
        end

        self.PrevReverserState = currentReverser
    else
        self.PrevReverserState = false
    end
	self:SetPackedBool("CardInserted", self.CardInserted)
	local fB = self.FrontBogey
	local rB = self.RearBogey

	local Panel = self.Panel
	local MFDU = self.MFDU
	if not NewMetrostroi then
	end

	local state = math.abs(self.BUTP.InverterFrequency/(11+self.BUTP.State*5))
    self:SetPackedRatio("asynccurrent", math.Clamp(state*(state+self.BUTP.State/1),0,1)*math.Clamp(self.Speed/6,0,1))
    self:SetPackedRatio("asyncstate", math.Clamp(self.BUTP.State/0.2*math.abs(self.BUTP.Current)/100,0,1))
	do
		local E = self.Electric
		local lvl = 0
		if E.Chopper > 0 and math.abs(self.Speed) > 10 then lvl = math.Clamp(math.max(E.Iexit/100, 0.5),0,1) end
		self:SetPackedRatio("chopper", lvl)
	end

	self:SetPackedRatio("Controller", self.Controller.Controller)
	self:SetPackedRatio("Speed", self.Speed)
	self:SetPackedRatio("VTBBlock",self.VTBBlock.Value/2)
	self:SetPackedRatio("ATSBlock",self.ATSBlock.Value/3)
	self:SetPackedRatio("PantBlock",self.PantBlock.Value/3)
	self:SetPackedRatio("HeadlightsSwitch", self.HeadlightsSwitch.Value/3)

	self:SetPackedBool("DoorOpenLeftLamp", false)

	self:SetPackedRatio("KRO",(self.RV.KROPosition+1)/2)
	self:SetPackedRatio("KRR",(self.RV.KRRPosition+1)/2)

	self:SetPackedBool("PassengerDoor",self.PassengerDoor)
	self:SetPackedBool("K35Closet",self.K35Closet == true)
	self:SetPackedBool("CabinDoorLeft",self.CabinDoorLeft)
	self:SetPackedBool("CabinDoorRight",self.CabinDoorRight)

	self:SetPackedBool("cab_cap1",self.cab_cap1)
	self:SetPackedBool("cab_cap2",self.cab_cap2)
	self:SetPackedBool("cab_cap3",self.cab_cap3)
	self:SetPackedBool("PVZDoor",self.PVZDoor)

	self:SetPackedBool("HelperSeat",self.Chair)

	self:SetPackedBool("CompressorWork",self.Pneumatic.Compressor and CurTime()-self.Pneumatic.Compressor > 0)

	self:SetPackedBool("PB",self.PB.Value)

	self:SetPackedBool("EnableBSLamp", Panel.PowerOnl)
	self:SetPackedBool("DisableBSLamp", Panel.PowerOffl)
	local emerWork = self.Pneumatic.EmerBrakeWork == true or self.Pneumatic.EmerBrakeWork == 1
	self:SetPackedBool("EmerBrakeLamp", self.Electric.Power > 0 and (emerWork or (Panel.EmerBrake or 0) > 0))
	self:SetPackedBool("EmergencyBrakeLamp", self.Electric.Power > 0 and self.EmergencyBrake.Value > 0.5)
	self:SetPackedBool("EmerX1Lamp", Panel.EmerX1)
	self:SetPackedBool("EmerX2Lamp", Panel.EmerX2)
	local bsPower = self.Electric.Power > 0
	local cabLevel = Panel.CabLight or 0
	if not bsPower then
		cabLevel = self.EmerPower.Value > 0 and math.min(cabLevel,1) or 0
	end

	self:SetPackedBool("BVEnableLamp", self.BUV.BVEnable)
	self:SetPackedBool("BVDisableLamp", self.BUV.BVDisable)
	self:SetPackedBool("ProgrevLamp", Panel.Progrev)
	self:SetPackedBool("LinkSCLamp", self.Electric.Power > 0 and self.LinkSC.Value > 0.5)
	self:SetPackedBool("MicrophoneLamp", self.Electric.Power > 0 and self.Microphone.Value > 0.5)
	self:SetPackedBool("CabLight1", cabLevel>0)
	self:SetPackedBool("CabLight2", cabLevel>1)

	self.DriverSeat:SetAngles(self:LocalToWorldAngles(Angle(0,-90,0)))

	if Panel.DoorLS>0 and Panel.DoorRS>0 then
		self:SetPackedBool("DoorOpenLeftLamp",CurTime()%1.4>0.7)
		self:SetPackedBool("DoorOpenRightLamp",CurTime()%1.4<0.7)
	elseif Panel.DoorClose==0 and self.BKPU.V0 then
		self:SetPackedBool("DoorOpenLeftLamp", Panel.DoorOL)
		self:SetPackedBool("DoorOpenRightLamp", Panel.DoorOR)
	else
		self:SetPackedBool("DoorOpenLeftLamp", false)
		self:SetPackedBool("DoorOpenRightLamp", false)
	end
	self:SetPackedBool("DoorSelectLeftLamp",Panel.DoorLS)
	self:SetPackedBool("DoorSelectRightLamp",Panel.DoorRS)
	if Panel.DoorLS==0 and Panel.DoorRS==0 and Panel.DoorClose==0 and self.Electric.Power>0 and self.RV.KROPosition~=0 then
		self:SetPackedBool("DoorCloseLamp", CurTime()%1.4>0.7)
	else
		self:SetPackedBool("DoorCloseLamp", Panel.DoorClose)
	end
	self:SetPackedBool("DoorBlockLamp", Panel.DoorBlock)

	self:SetPackedBool("ChargeAKBLamp", Panel.ChargeAKBl)

	self:SetPackedBool("HVoltage", Panel.HVoltage)
	self:SetPackedBool("DoorsClosed", MFDU.DoorsClosedMFDU == true and (self.Electric.Power * self.SF5.Value) > 0.5)

	self:SetPackedBool("K40_cap",self.K40_cap)
	if (self.K40.Value == 0 or self.K31.Value == 0) and not self.K40_cap then
		self.K40_cap = true
	end

	if self:GetNW2Bool("MFDU_DoorsClosed") and MFDU.State == 4 then

		self:CANWrite("CIK",self:GetWagonNumber(),"BNT",nil,"Depart123",false)
	end
	self:SetPackedBool("K41_cap",self.K41_cap)
	if self.K41.Value == 0 and not self.K41_cap then
		self.K41_cap = true
	end

	self:SetPackedBool("K53_cap",self.K53_cap)
	if self.K53.Value == 0 and not self.K53_cap then
		self.K53_cap = true
	end
	self:SetPackedBool("MFDU_Work", self.MFDU.State ~= 0)
	self:SetPackedBool("Speedometer_Work", self.Speedometer.State ~= 0)
	self:SetPackedBool("MVO_Work", self.MVO.State ~= 0)
	self:SetPackedBool("BortPower", self.Electric.Power > 0)
	self:SetPackedBool("RadioLit", self.Electric.Power > 0 or self.EmerPower.Value > 0)

	do
		local atc1, atc2 = self.ATC1, self.ATC2
		local ring = (atc1.Active and (atc1.Ring or 0) > 0) or (atc2.Active and (atc2.Ring or 0) > 0)
		self:SetPackedBool("RingEnabled", ring and self.BKPU.Active and self.Electric.Power > 0 or false)
	end
	self:SetPackedBool("CallRing", self.Electric.Power > 0 and self:ReadTrainWire(70) > 0 and self.Ring.Value < 0.5)

	local power = self.Electric.Power > 0

	self:SetPackedBool("redlight", Panel.RL>0)
	self:SetPackedBool("headlight1", Panel.HL1>0)
	self:SetPackedBool("headlight2", Panel.HL2>0)
	self:SetPackedBool("headlight3", Panel.WL>0)
	local headlightsPower = (self:GetPackedBool("headlight1") or self:GetPackedBool("headlight2")) and 1 or 0
	self:SetLightPower(21, headlightsPower > 0)
    self:SetLightPower(22, headlightsPower > 0)

	self:SetPackedRatio("AKBVoltage", power and self.BUV.Voltage or 0)
	self:SetPackedRatio("HVVoltage", (power and self.Electric.Main750V >= 20) and self.Electric.Main750V or 0)

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

	local lightsBlocked = self.BUV and self.BUV.DisableLights == 1
	local lightMain = bsPower and BRK(self,"52F1") and not lightsBlocked
	local lightEmer = bsPower and BRK(self,"52F3")
	local salon_1 = (lightMain or lightEmer) and 1 or 0
	local salon_2 = lightMain and 1 or 0
	self:SetPackedBool("BSPower", bsPower)
	self:SetPackedBool("SalonLighting1", salon_1 > 0)
	self:SetPackedBool("SalonLighting2", salon_2 > 0)
	self:SetPackedBool("SalonEmer", salon_1 > 0 and salon_2 == 0)
	self:SetPackedBool("DoorLightL", bsPower and BRK(self,"52F5"))
	self:SetPackedBool("DoorLightR", bsPower and BRK(self,"52F4"))
	self.FireSystemOn = bsPower and BRK(self,"90F1")
	self:SetPackedBool("SalonHV", self.Electric.Main750V >= 550)

	local passlight = salon_1*0.25+salon_2*0.75
	local passl = passlight > 0
	local hvK = (self.Electric.Main750V >= 550) and 1 or 0.3
	for i=11,13 do self:SetLightPower(i,passl, passlight*hvK) end


	if self.Autodrive.Value*self.Electric.CabActive == 1 then
		self:SetPackedBool("AutodriveLamp", 1)
	else
		self:SetPackedBool("AutodriveLamp", 0)
	end

	if self.Progrev.Value*self.Electric.CabActive == 1 then
		self:SetPackedBool("ProgrevLamp", 1)
	else
		self:SetPackedBool("ProgrevLamp", 0)
	end

	self.BUTP:TriggerInput("Speed",self.Speed)
	if IsValid(fB) and IsValid(rB) and not self.IgnoreEngine then
		local A = self.BUTP.Torque
		local add = 1
		if math.abs(self:GetAngles().pitch) > 4 then
			add = math.min((math.abs(self:GetAngles().pitch)-4)/2,1)
		end
		fB.MotorForce = (40000+5000*(A < 0 and 1 or 0))*add
		fB.Reversed = (self.Electric.Reverser < 0)
		rB.MotorForce  = (40000+5000*(A < 0 and 1 or 0))*add
		rB.Reversed = (self.Electric.Reverser > 0)

		local P = math.max(0,0.04449 + 1.06879*math.abs(A) - 0.465729*A^2)
		if math.abs(A) > 0.4 then P = math.abs(A) end
		if math.abs(A) < 0.05 then P = 0 end
		if self.Speed < 10 then P = P*(1.0 + 0.6*(10.0-self.Speed)/10.0) end
		rB.MotorPower  = P*0.5*((A > 0) and 1 or -1)
		fB.MotorPower = P*0.5*((A > 0) and 1 or -1)

		local bc = self.Pneumatic.BrakeCylinderPressure
		local x = bc > 0 and (1.5 - bc + self.Pneumatic.WeightLoadRatio * 0.8) / bc or 0
		local auxF = (x < 0 or x > 1) and 0 or (1 / (1 + math.exp(-40 * (x - 0.173))) - 1 / (1 + math.exp(-35 * (x - 0.24))))
		local brake_force = (50000.0 + auxF * 13000) * (BRK(self,"23F25") and 1 or ANTISLIP_OFF_K)

		fB.PneumaticBrakeForce = brake_force
		fB.BrakeCylinderPressure = self.Pneumatic.FrontBogeyBrakeCylinderPressure
		fB.ParkingBrakePressure = math.max(0,4.4-self.Pneumatic.ParkingBrakePressure)
		fB.BrakeCylinderPressure_dPdT = self.Pneumatic.BrakeCylinderPressure_dPdT * (self.K40.Value > 0.5 and 1 or 0)
		fB.DisableContacts = self.BUV.Pant
		rB.PneumaticBrakeForce = brake_force
		rB.BrakeCylinderPressure = self.Pneumatic.RearBogeyBrakeCylinderPressure
		rB.ParkingBrakePressure =  math.max(0,4.4-self.Pneumatic.ParkingBrakePressure)
		rB.BrakeCylinderPressure_dPdT = self.Pneumatic.BrakeCylinderPressure_dPdT * (self.K41.Value > 0.5 and 1 or 0)
		rB.DisableContacts = self.BUV.Pant
	end

	self:SetNW2Bool("FrontCoupled", self.FrontCoupledBogey ~= nil)
	if IsValid(self.FrontCouple) and self.CoupleCenteringF then
		if self.FrontCoupledBogey and self.CoupleCenteringF.Value > 0 then
			self.CoupleCenteringF:TriggerInput("Set", 0)
		end
		if self.CoupleCenteringF.Value > 0 and self.FrontCouple.Centered then
			self:RemoveSprings(true)
		end
		if not self.FrontCoupledBogey and self.CoupleCenteringF.Value == 0 and not self.FrontCouple.Centered then
			self:SetSprings(true)
		end
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

	if not isfront then
		local ent = train:GetNW2Entity("TrainEntity")
		local s = (train ~= ent.RearCouple and "Fence1" or "Fence")
		local a2 = train ~= ent.RearCouple and -1 or 1
		if not IsValid(self.Fence) and not IsValid(ent[s]) and ent:GetClass():find("77") and (not ent:GetClass():find("775") or a2 == 1) then
			local pos1,pos2 = self:GetPos(),ent:GetPos()
			local b1,b2 = -self:GetForward(),-ent:GetForward()*a2
			local min = 3
			local pos
			for i=475,490,0.001 do
				if (pos1+b1*i):Distance(pos2+b2*i) < min then
					min = (pos1+b1*i):Distance(pos2+b2*i)
					pos = pos1+b1*i
				end
			end
			pos = pos and self:WorldToLocal(pos)
			self.Fence = self:CreateFence(Vector(pos,0,0),Angle(0,0,0),-1)
			ent[s] = self.Fence
			table.insert(ent.TrainEntities,ent[s])
			local bone1,bone2 = 0,1
			local bonen1,bonen2 = self.Fence:GetPhysicsObjectNum(bone1),self.Fence:GetPhysicsObjectNum(bone2)
			bonen1:SetPos(ent:LocalToWorld(Vector(a2 == -1 and 464 or -464,0,-12)))
			bonen2:SetPos(self:LocalToWorld(Vector(-491.07,0,-2)))
			bonen1:SetAngles(ent:LocalToWorldAngles( Angle(0,90*(1-a2+90),90)))
			bonen2:SetAngles(self:LocalToWorldAngles(Angle(0,0,90)))
			constraint.Weld( self.Fence,self, bone2, 0, 0, 1, false )
			constraint.Weld( self.Fence,ent , bone1, 0, 0, 1, false )
		end
	end
	self.BaseClass.OnCouple(self,train,isfront)

	if isfront then self:RemoveSprings(true, train) end
end

function ENT:OnDecouple(isfront)
	if isfront then
		self.FrontCoupledBogey = nil
	else
		self.RearCoupledBogey = nil
	end
	if isfront then self:SetSprings(true) end
	self:OnConnectDisconnect()
	if self.OnDecoupled then self:OnDecoupled() end

	if not isfront and IsValid(self.Fence) then
		self.Fence:Remove()
	end
end

function ENT:OnButtonPress(button,ply)

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

	if button == "MFDUCard" then
        self.CardInserted = not self.CardInserted
        return
    end

	if string.find(button,"PneumaticBrakeSet") then
		self.Pneumatic:TriggerInput("BrakeSet",tonumber(button:sub(-1,-1)))
		return
	end
	local cabDoorsLocked = math.abs(self.Speed or 0) > 15
	if button == "CabinRightDoor" and not self.cab_cap1 and (self.CabinDoorRight or not cabDoorsLocked) then self.CabinDoorRight = not self.CabinDoorRight end
	if button == "CabinLeftDoor" and not self.cab_cap3 and (self.CabinDoorLeft or not cabDoorsLocked) then self.CabinDoorLeft = not self.CabinDoorLeft end
	if button == "CabinPassDoor" and not self.cab_cap2 then self.PassengerDoor = not self.PassengerDoor end
	if button == "K35Closet" then self.K35Closet = not self.K35Closet end

	if button == "cab_cap1" and not self.CabinDoorRight then self.cab_cap1 = not self.cab_cap1 end
	if button == "cab_cap2" and not self.PassengerDoor then self.cab_cap2 = not self.cab_cap2 end
	if button == "cab_cap3" and not self.CabinDoorLeft then self.cab_cap3 = not self.cab_cap3 end
	if button == "PVZDoor" then self.PVZDoor = not self.PVZDoor end
	if button == "DoorLeft" then
		self.DoorSelectLeft:TriggerInput("Set",1)
		self.DoorSelectRight:TriggerInput("Set",0)
		if self.DoorClose.Value == 0 then
			self.DoorOpenLeft:TriggerInput("Set",1)
		end
	end
	if button == "DoorRight" then
		self.DoorSelectLeft:TriggerInput("Set",0)
		self.DoorSelectRight:TriggerInput("Set",1)
		if self.DoorClose.Value == 0 then
		  self.DoorOpenRight:TriggerInput("Set",1)
		end
	end
	if button == "DoorClose" then
		self.DoorClose:TriggerInput("Toggle",1)
	end
	if button == "DoorCloseMToggle" then
			self.DoorClose:TriggerInput("Toggle",1)

	end
	if button == "KRO+" then
			self.RV:TriggerInput("KROSet",self.RV.KROPosition+1)
	end
	if button == "KRO-" then
			self.RV:TriggerInput("KROSet",self.RV.KROPosition-1)
	end
	if button == "KRRk" then
		self.KRRk:TriggerInput("Toggle",1)
	end
	if button == "KRR+" and self.KRRk.Value == 0 then
		self.RV:TriggerInput("KRRSet",self.RV.KRRPosition+1)
	end
	if button == "KRR-" and self.KRRk.Value == 0 then
		self.RV:TriggerInput("KRRSet",self.RV.KRRPosition-1)
	end

	if button == "EmergencyBrakeValveToggle"   then
		self:SetPackedRatio("EmerValve",CurTime()+3.8)
	end

	if button == "ALSDecoderToggle" then
		if self.ALSDecoder.Value*self.SF6.Value == 1 then
			if self.ALSVal == 2 then
				self.ALSVal = 0
			else
				self.ALSVal = self.ALSVal + 1
			end
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
		if self.K40.Value == 1 and self.K31.Value == 1 then
			self.K40_cap = not self.K40_cap
		end
	end
	if button == "EmergencyBrakeValveToggle"   then
		self:PlayOnce("valve_brake_close","",1,1)
	end
	if button == "K41_cap" then
		if self.K41.Value == 1 then
			self.K41_cap = not self.K41_cap
		end
	end

	if button == "K53_cap" then
		if self.K53.Value == 1 then
			self.K53_cap = not self.K53_cap
		end
	end

	if button == "DoorLeft" then
		self.DoorOpenLeft:TriggerInput("Set",0)
	end

	if button == "DoorRight" then
		self.DoorOpenRight:TriggerInput("Set",0)
	end

	if button == "DoorClose" then
		self.DoorClose:TriggerInput("Toggle",0)
	end
	if button == "DoorCloseMToggle" then
		self.DoorClose:TriggerInput("Toggle",0)
	end
end

function ENT:TriggerTurbostroiInput(sys,name,val)
	if name == "Value" then
		if self.SyncTable and table.HasValue(self.SyncTable,sys) and self[sys]._base ~= "81_775_Relay" then
			self:SetPackedBool(sys,val > 0)
		end
	end
	if name == "AnimValue" then
		if self.SyncTable and table.HasValue(self.SyncTable,sys) and self[sys]._base == "81_775_Relay" then
			self:SetPackedRatio(sys,val)
		end
	end
end

function ENT:GenerateWagonNumber(i,ws)
	if not ws then return end
	local WNumber = 75000
	if i == 1 then
		local Trains = ents.FindByClass("gmod_subway_81-775")
		local WN = math.random(75001,75290)
		for k, v in ipairs(Trains) do
			if v:GetWagonNumber() == WN then
				WN = math.random(75001,75330)
			end
		end
		WNumber = WN%2==0 and WN-1 or WN
		Metrostroi.Trains775[1] = WNumber
	else
		local fn = Metrostroi.Trains775[1]
		WNumber = fn + 1
		timer.Simple(1,function()
			Metrostroi.Trains775[1] = nil
		end)
	end

	self.WagonNumber = WNumber
	self:SetNW2Int("WagonNumber",self.WagonNumber)
	self:UpdateWagonNumber()
end

local function JoystickRegister()
    Metrostroi.RegisterJoystickInput("met_775controller",true,"Controller (775)",-10,10)
    Metrostroi.RegisterJoystickInput("met_775pb",false,"PB Set")
    Metrostroi.RegisterJoystickInput("met_775h1",false,"Horn 1 Engage")
    Metrostroi.JoystickSystemMap["met_775controller"] = "ControllerJSet"
    Metrostroi.JoystickSystemMap["met_775pb"] = "PBSet"
    Metrostroi.JoystickSystemMap["met_775h1"] = "HornEngage"
end

hook.Add("JoystickInitialize","metroistroi_cabin_775",JoystickRegister)
