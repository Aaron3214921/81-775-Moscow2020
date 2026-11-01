Metrostroi.DefineSystem("81_775_CPanel")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	self.Power = false
	self.MS = 0
	self.S = 0
	self.CL = 1
	self.PL = 0
	self.CabPower = false
	self.PFlash1 = 0
	self.PFlash2 = 0
end

function TRAIN_SYSTEM:Outputs()
    return { }
end

function TRAIN_SYSTEM:Inputs()
    return { "ShtoraUp","ShtoraDown","CabLight1","CabLight2","CabLight","PultLight","PultLight1","PultLight2"}
end
function TRAIN_SYSTEM:TriggerInput(name,value)
	if name == "ShtoraUp" or name == "ShtoraDown" then
		if not self.Power then return end
	elseif not self.CabPower then return end
	if name == "ShtoraUp" then
		self.MS = value*-1
	end
	if name == "ShtoraDown" then
		self.MS = value
	end
	if name == "CabLight1" and value > 0.5 and self.CL == 2 then
		self.CL = 1
	end
	if name == "CabLight2" and value > 0.5 and self.CL == 1 then
		self.CL = 2
	end
	if name == "CabLight" and value > 0.5 then
		self.CL = self.CL > 0 and 0 or 1
	end
	if name == "PultLight1" and value > 0.5 and self.PL > 0 then
		self.PL = 1
		self.PFlash1 = CurTime() + 0.5
	end
	if name == "PultLight2" and value > 0.5 and self.PL > 0 then
		self.PL = 2
		self.PFlash2 = CurTime() + 0.5
	end
	if name == "PultLight" and value > 0.5 then
		self.PL = self.PL > 0 and 0 or 2
	end
end

function TRAIN_SYSTEM:Think()
	local Train = self.Train
    local Panel = Train.Panel
	Panel.CabLight = self.CL
	self.Power = self.Train.Electric.Power > 0
	self.CabPower = self.Power or (self.Train.EmerPower and self.Train.EmerPower.Value > 0) or false
	self.S = math.Clamp(self.S+self.MS*0.005,0,1)
	self.Train:SetPackedRatio("Shtora",self.S)
	self.Train:SetPackedRatio("PultLight",(self.PL or 0)/2)
	if not self.CabPower then
		self.CL = 1
		self.PL = 0
	end

	local cl = self.CL
	if not self.Power then cl = self.CabPower and math.min(cl,1) or 0 end
	local pl = self.CabPower and self.PL or 0
	local now = CurTime()
	Train:SetPackedBool("CabLightLamp",  cl > 0)
	Train:SetPackedBool("CabLight1Lamp", cl > 0)
	Train:SetPackedBool("CabLight2Lamp", cl > 1)
	Train:SetPackedBool("PultLightLamp", pl > 0)
	Train:SetPackedBool("PultLight1Lamp", pl > 0 and now < (self.PFlash1 or 0))
	Train:SetPackedBool("PultLight2Lamp", pl > 0 and now < (self.PFlash2 or 0))
end

function TRAIN_SYSTEM:ClientThink(dT)

end
