Metrostroi.DefineSystem("81_775_Panel")
TRAIN_SYSTEM.DontAccelerateSimulation = false

function TRAIN_SYSTEM:Initialize()
	for i=1, 32 do
		self.Train:LoadSystem("SF" .. i, "Relay", "Switch", {bass=true, normally_closed=true})
	end
	self.Train:LoadSystem("ATSBlock", "Relay", "Switch", {maxvalue=3,defaultvalue=0,bass=true})
	self.Train:LoadSystem("ALSFreq", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("NightStay", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("TLBL", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("VTBBlock", "Relay", "Switch", {maxvalue=2,defaultvalue=0,bass=true})
	self.Train:LoadSystem("PantBlock", "Relay", "Switch", {maxvalue=3,defaultvalue=0,bass=true})
	self.Train:LoadSystem("EmerLDOp", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("EmerRDOp", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("ParkingBrake", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("RPDPPower", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("SalonConditioner", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("EmerPower", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("PB", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("KAH", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("Wiper", "81_775_Relay", "Switch", {bass=true})
	self.Train:LoadSystem("Washer", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("EmergencyCompressor", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("EmerX1", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("EmerX2", "Relay", "Switch", {bass=true})

	self.Train:LoadSystem("BVDisable", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("BVEnable", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("DoorSelectLeft", "81_775_Relay", "Switch", {bass=true})
	self.Train:LoadSystem("DoorBlock", "81_775_Relay", "Switch", {bass=true})
	self.Train:LoadSystem("DoorBlockk", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("DoorSelectRight", "81_775_Relay", "Switch", {bass=true})

	self.Train:LoadSystem("EmerBlockSD", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("EmerBlockSDk", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("Autodrive", "81_775_Relay", "Switch", {bass=true})
	self.Train:LoadSystem("Autodrivek", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("HeadlightsSwitch", "Relay", "Switch", {maxvalue=2,defaultvalue=0,bass=true})
	self.Train:LoadSystem("Ring", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("Antison", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("Progrev", "81_775_Relay", "Switch", {bass=true})
	self.Train:LoadSystem("DoorOpenLeft", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("DoorClose", "81_775_Relay", "Switch", {bass=true})
	self.Train:LoadSystem("DoorOpenRight", "Relay", "Switch", {bass=true})

	self.Train:LoadSystem("KRRk", "Relay", "Switch", {bass=true, normally_closed=true})

	self.Train:LoadSystem("EmerBrake", "81_775_Relay"," Switch", {bass=true})
	self.Train:LoadSystem("EmerBrakeAdd", "Relay"," Switch", {bass=true})
	self.Train:LoadSystem("EmerBrakeRelease", "Relay"," Switch", {bass=true})

	self.Train:LoadSystem("LinkSC", "Relay"," Switch", {bass=true})
	self.Train:LoadSystem("HornB", "Relay"," Switch", {bass=true})
	self.Train:LoadSystem("AttentionMessage", "Relay"," Switch", {bass=true})
	self.Train:LoadSystem("Attention", "Relay"," Switch", {bass=true})
	self.Train:LoadSystem("AttentionBrake", "Relay"," Switch", {bass=true})

	self.Train:LoadSystem("Microphone", "Relay"," Switch", {bass=true})
	self.Train:LoadSystem("R_Program1", "Relay"," Switch", {bass=true})
	self.Train:LoadSystem("CPanelCabLight", "Relay"," Switch", {bass=true})
	self.Train:LoadSystem("EmergencyBrake", "81_775_Relay", "Switch", {bass=true})

	self.Train:LoadSystem("EmergencyEmerBrake", "Relay", "Switch", {bass=true})

	self.Train:LoadSystem("ChargeAKB", "81_775_Relay", "Switch", {bass=true})
	self.Train:LoadSystem("EnableBS", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("DisableBS", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("ALSDecoder", "81_775_Relay", "Switch", {bass=true})
	self.Train:LoadSystem("_Rezerv", "Relay", "Switch", {bass=true})

	self.Train:LoadSystem("StartBAP", "Relay", "Switch", {bass=true})
	self.Train:LoadSystem("StartBAPk", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("TestBAP", "Relay", "Switch", {bass=true})

	self.Train:LoadSystem("KRRH3","Relay","Switch", { normally_closed = true})
	self.Train:LoadSystem("KPRRKM","Relay","Switch",{ normally_closed = true})
	self.Train:LoadSystem("K27","Relay","Switch", { normally_closed = true})
	self.Train:LoadSystem("K35","Relay","Switch", { normally_closed = true})
	self.Train:LoadSystem("23F5", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("23F6", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("30F4", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("45F14", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("95F1", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("22F1", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("23F4", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("23F12", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("23F11", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("23F13", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("23F25", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("23F26", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("23F27", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("30F3", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("90F1", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("45F2", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("45F7", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("45F8", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("45F9", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("45F1", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("45F4", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("52F1", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("52F4", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("52F5", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("52F3", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("80F2", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("80F13", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("80F12", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("80F14", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("70F4", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("70F6", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("21F1", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("61F4", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("61F3", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("61F1", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("61F2", "Relay", "Switch", {bass=true, normally_closed=true})
	self.Train:LoadSystem("95F2", "Relay", "Switch", {bass=true, normally_closed=true})

	self.HVoltage = 0
	self.DoorsClosed = 0

	self.CabLight = 1

	self.PowerOnl = 0
	self.PowerOffl = 1

	self.HL1 = 0
	self.HL2 = 0
	self.RL = 0
	self.WL = 0

	self.EmerX1 = 0
	self.EmerX2 = 0
	self.Progrev = 0

	self.ChargeAKBl = 0

	self.EmerBrake = 0

	self.DoorLS = 0
	self.DoorRS = 0
	self.DoorOL = 0
	self.DoorOR = 0
	self.DoorClose = 0
	self.DoorBlock = 0
end

function TRAIN_SYSTEM:Outputs()
	return {
		"HVoltage",
		"DoorsClosed",

		"CabLight",

		"PowerOnl",
		"PowerOffl",

		"Progrev",

		"ChargeAKBl",

		"HL1","HL2","RL","WL",
		"EmerX1","EmerX2","EmerBrake",

		"DoorLS","DoorRS","DoorOL","DoorOR","DoorClose","DoorBlock",
	}
end
