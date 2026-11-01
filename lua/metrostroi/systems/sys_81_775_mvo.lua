Metrostroi.DefineSystem("81_775_MVO")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	self.State = -1
	self.selected = 0

	self.Timer = CurTime()

	self.CamsStates = {
		[1] = {{false,true},{false,false}},
		[2] = {{true,false},{false,true}},
		[3] = {{true,false},{false,true}},
		[4] = {{true,false},{false,true}},
		[5] = {{true,false},{false,true}},
		[6] = {{true,false},{false,true}}
	}
	self.StateTimer = CurTime()
	self.LastEntered = 0
	self.CamsState = 1
end

function TRAIN_SYSTEM:Outputs()
end

function TRAIN_SYSTEM:Inputs()
	return {}
end
if TURBOSTROI then return end

function TRAIN_SYSTEM:Touch(value,x,y)
	if not value then self.selected = 0 end
	if value then
		if y > 528 and y < 562 then
			if x > 290 and x < 320 then
				self.selected = 1
			end
			if x > 350 and x < 380 then
				self.selected = 2
			end
			if x > 410 and x < 440 then
				self.selected = 3
			end
			if x > 470 and x < 500 then
				self.selected = 4
			end
			if x > 530 and x < 560 then
				self.selected = 5
			end
			if x > 590 and x < 620 then
				self.selected = 6
			end
			if x > 650 and x < 680 then
				self.selected = 7
			end
		end
	end
end
if SERVER then
	function TRAIN_SYSTEM:Trigger(name,value)
    end
	function TRAIN_SYSTEM:Think()
		local Train = self.Train
		self.Power = Train.SF24.Value*Train.Electric.Power > 0.5
		local Power = self.Power
	    if not Power and self.State ~= 0 then
	        self.State = 0
			self.Brightness = 0
			self.MVOTimer = nil
	    end

		if Power and self.State == 0 then
			self.State = -1
			self.MVOTimer = CurTime()+math.Rand(1.5,2.0)
			self.MVOTime2 = self.MVOTimer-CurTime()
		end
		if self.State == -1 and CurTime()>self.MVOTimer then
		  self.State = -2
		  self.MVOTimer = CurTime()+math.Rand(0.2,1)
		  self.MVOTime2 = self.MVOTimer-CurTime()
		end
		if self.State == -2 and CurTime()>self.MVOTimer then
		  self.State = -3
		  self.MVOTimer = CurTime()+math.Rand(1,3)
		  self.MVOTime2 = self.MVOTimer-CurTime()
		  self.MVOTimeS1 = math.Rand(3,5)
		end
		if self.State == -3 then
		  if CurTime()>self.MVOTimer then
			  self.MVOTimer = nil
			  self.MVOTime2 = nil
			  self.MVOTimeS1 = nil
			  self.State = 1
		  end
		end

		self.CamsStates = {
			[1] = {{true,true},{false,false}},
			[2] = {{true,false},{false,true}},
			[3] = {{true,true},{true,false}},
			[4] = {{false,true},{false,false}},
			[5] = {true,true},
			[6] = {true,false}
		}

		if self.selected > 0 and self.selected < 8 then
			self.CamsState = self.selected
		end
		if self.CamsState < 5 then
			Train:SetNW2Bool(	"MVO_Cam1C",true)
			Train:SetNW2Entity(	"MVO_Cam1E",self.CamsStates[self.CamsState][1][1] and Train or Train.WagonList[#Train.WagonList])
			Train:SetNW2Bool(	"MVO_Cam1Pos",self.CamsStates[self.CamsState][1][2])
			Train:SetNW2Bool(	"MVO_Cam2C",true)
			Train:SetNW2Entity(	"MVO_Cam2E",self.CamsStates[self.CamsState][2][1] and Train or Train.WagonList[#Train.WagonList])
			Train:SetNW2Bool(	"MVO_Cam2Pos",self.CamsStates[self.CamsState][2][2])
		elseif self.CamsState == 7 then
			Train:SetNW2Bool(	"MVO_Cam1C",false)
			Train:SetNW2Bool(	"MVO_Cam2C",false)
			Train:SetNW2Bool(	"MVO_Cam4C",true)
			Train:SetNW2Entity(	"MVO_Cam4E",Train.WagonList[#Train.WagonList])
			Train:SetNW2Bool(	"MVO_Cam4Pos",true)
			Train:SetNW2Bool(	"MVO_Cam5C",true)
			Train:SetNW2Entity(	"MVO_Cam5E",Train.WagonList[#Train.WagonList])
			Train:SetNW2Bool(	"MVO_Cam5Pos",false)
			Train:SetNW2Bool(	"MVO_Cam6C",true)
			Train:SetNW2Entity(	"MVO_Cam6E",Train)
			Train:SetNW2Bool(	"MVO_Cam6Pos",true)
			Train:SetNW2Bool(	"MVO_Cam7C",true)
			Train:SetNW2Entity(	"MVO_Cam7E",Train)
			Train:SetNW2Bool(	"MVO_Cam7Pos",false)
		else
			Train:SetNW2Bool(	"MVO_Cam1C",true)
			Train:SetNW2Entity(	"MVO_Cam1E",self.CamsStates[self.CamsState][1] and Train or Train.WagonList[#Train.WagonList])
			Train:SetNW2Bool(	"MVO_Cam1Pos",self.CamsStates[self.CamsState][2])
			Train:SetNW2Bool(	"MVO_Cam2C",false)
		end

		Train:SetNW2Int("MVO_State",self.State)
		Train:SetNW2Int("MVO_CState",self.CamsState)
		Train:SetNW2Int("MVO_Selected",self.Selected)
		Train:SetNW2Int("MVO_LastSelected",self.LastSelected or 0)
		Train:SetNW2Int("MVO_LastEntered",self.LastEntered or 0)
		Train:SetNW2Int("MVO_Timer",self.StateTimer and (CurTime()-self.StateTimer)*20 or 0)
	end
else
	local function createFont(name,font,size,weight,blur,scanlines,underline)
		surface.CreateFont("Metrostroi_775_"..name, {
			font = font,
			size = size,
			weight = weight or 400,
			blursize = blur or false,
			antialias = true,
			underline = underline,
			italic = false,
			strikeout = false,
			symbol = false,
			rotary = false,
			shadow = false,
			additive = false,
			outline = false,
			extended = true,
			scanlines = scanlines or false,
		})
	end
	createFont("CAMS","Arial",38,0,0,0,false)

	local function DrawBox(x,y,w,h,color)
		surface.SetDrawColor(color.r,color.g,color.b,color.a)
		surface.DrawRect(x,y,w,h)
	end
	local CamRT = surface.GetTextureID( "pp/rt" )
    local CamRTM = Material( "pp/rt" )
    local CamsPos = Vector(477,34,-14)
	function TRAIN_SYSTEM:ClientInitialize()
        self.Cam1 = self.Train:CreateRT("775CAMSC1",800,600,true)
        self.Cam2 = self.Train:CreateRT("775CAMSC2",400,600,true)
        self.Cam3 = self.Train:CreateRT("775CAMSC3",400,600,true)

		self.Cam4 = self.Train:CreateRT("775CAMSC4",400,300,true)
		self.Cam5 = self.Train:CreateRT("775CAMSC5",400,300,true)
		self.Cam6 = self.Train:CreateRT("775CAMSC6",400,300,true)
		self.Cam7 = self.Train:CreateRT("775CAMSC7",400,300,true)
    end

	function TRAIN_SYSTEM:ClientThink()
        if not self.Train:ShouldDrawPanel("MVO") then return end
		if not self.DrawTimer then
			render.PushRenderTarget(self.Train.MVO,0,0,800,600)
            render.Clear(0, 0, 0, 0)
            render.PopRenderTarget()
        end

        local train = self.Train
        local state = train:GetNW2Int("MVO_State",0)

		local Cam1,Cam1E,Cam1Pos = train:GetNW2Bool("MVO_Cam1C"),train:GetNW2Entity("MVO_Cam1E"),train:GetNW2Bool("MVO_Cam1Pos",false)
		local Cam2,Cam2E,Cam2Pos = train:GetNW2Bool("MVO_Cam2C"),train:GetNW2Entity("MVO_Cam2E"),train:GetNW2Bool("MVO_Cam2Pos",false)
		local Cam4,Cam4E,Cam4Pos = train:GetNW2Bool("MVO_Cam4C"),train:GetNW2Entity("MVO_Cam4E"),train:GetNW2Bool("MVO_Cam4Pos",false)
		local Cam5,Cam5E,Cam5Pos = train:GetNW2Bool("MVO_Cam5C"),train:GetNW2Entity("MVO_Cam5E"),train:GetNW2Bool("MVO_Cam5Pos",false)
		local Cam6,Cam6E,Cam6Pos = train:GetNW2Bool("MVO_Cam6C"),train:GetNW2Entity("MVO_Cam6E"),train:GetNW2Bool("MVO_Cam6Pos",false)
		local Cam7,Cam7E,Cam7Pos = train:GetNW2Bool("MVO_Cam7C"),train:GetNW2Entity("MVO_Cam7E"),train:GetNW2Bool("MVO_Cam7Pos",false)
		if Cam1 and not Cam2 then
			Metrostroi.RenderCamOnRT(train,CamsPos,"Cam1",0,self.Cam1,Cam1E,Vector(435,0,30)+(Cam1Pos and Vector(0,74,0) or Vector(0,-74,0)),Angle(0,180,0),800,600,1,1,1)
		elseif Cam1 and Cam2 then
			Metrostroi.RenderCamOnRT(train,CamsPos,"Cam2",0,self.Cam2,Cam1E,Vector(435,0,26)+(Cam1Pos and Vector(0,74,0) or Vector(0,-74,0)),Angle(0,180,0),400,600,1,1,1)
			Metrostroi.RenderCamOnRT(train,CamsPos,"Cam3",0,self.Cam3,Cam2E,Vector(435,0,26)+(Cam2Pos and Vector(0,74,0) or Vector(0,-74,0)),Angle(0,180,0),400,600,1,1,1)
		else
			Metrostroi.RenderCamOnRT(train,CamsPos,"Cam4",0,self.Cam4,Cam4E,Vector(435,5,30)+(Cam4Pos and Vector(0,74,0) or Vector(0,-74,0)),Angle(0,180,0),400,300,1,1,1)
			Metrostroi.RenderCamOnRT(train,CamsPos,"Cam5",0,self.Cam5,Cam5E,Vector(435,-5,30)+(Cam5Pos and Vector(0,74,0) or Vector(0,-74,0)),Angle(0,180,0),400,300,1,1,1)
			Metrostroi.RenderCamOnRT(train,CamsPos,"Cam6",0,self.Cam6,Cam6E,Vector(435,5,30)+(Cam6Pos and Vector(0,74,0) or Vector(0,-74,0)),Angle(0,180,0),400,300,1,1,1)
			Metrostroi.RenderCamOnRT(train,CamsPos,"Cam7",0,self.Cam7,Cam7E,Vector(435,-5,26)+(Cam7Pos and Vector(0,74,0) or Vector(0,-74,0)),Angle(0,180,0),400,300,1,1,1)
		end

        if self.state ~= -3 then
			local RW,RH = ScrW(),ScrH()
			render.SetColorMaterial(0,0,0)
			render.PushRenderTarget(self.Train.MVO,0,0,800,600)
			render.Clear(0, 0, 0, 0)
			cam.Start2D()
				if state ~= -4 then
					if state == -2 then
						surface.SetDrawColor(255,255,255)
					else
						surface.SetDrawColor(0,0,0)
					end
					surface.DrawRect(1,0,800,600)
				end
				self:CAMS(self.Train,RW,RH)
			cam.End2D()
			render.PopRenderTarget()
		end

		self.state = state

	end


	function TRAIN_SYSTEM:CAMS(Train,RW,RH)
		local state = Train:GetNW2Int("MVO_State",0)
		local cstate = Train:GetNW2Int("MVO_CState",0)
		if state < 1 then
			return
		end
		local Cam1,Cam1E,Cam1Pos = Train:GetNW2Bool("MVO_Cam1C"),Train:GetNW2Entity("MVO_Cam1E"),Train:GetNW2Bool("MVO_Cam1Pos",false)
		local Cam2,Cam2E,Cam2Pos = Train:GetNW2Bool("MVO_Cam2C"),Train:GetNW2Entity("MVO_Cam2E"),Train:GetNW2Bool("MVO_Cam2Pos",false)
		local Cam4,Cam4E = Train:GetNW2Bool("MVO_Cam4C"),Train:GetNW2Entity("MVO_Cam4E")
		local Cam5,Cam5E = Train:GetNW2Bool("MVO_Cam5C"),Train:GetNW2Entity("MVO_Cam5E")
		local Cam6,Cam6E = Train:GetNW2Bool("MVO_Cam6C"),Train:GetNW2Entity("MVO_Cam6E")
		local Cam7,Cam7E = Train:GetNW2Bool("MVO_Cam7C"),Train:GetNW2Entity("MVO_Cam7E")
		if Cam1 and not Cam2 then
			render.DrawTextureToScreenRect(self.Cam1,RW,	0,			-RW,	RH*0.875)
		elseif Cam1 and Cam2 then
			render.DrawTextureToScreenRect(self.Cam2,RW/2,	0,			-RW/2,	RH*0.875)
			render.DrawTextureToScreenRect(self.Cam3,RW,	0,			-RW/2,	RH*0.875)
		else
			render.DrawTextureToScreenRect(self.Cam4,RW/2,	0,			-RW/2,	RH*0.875/2)
			render.DrawTextureToScreenRect(self.Cam5,RW,	0,			-RW/2,	RH*0.875/2)
			render.DrawTextureToScreenRect(self.Cam6,RW/2,	RH*0.875/2,	-RW/2,	RH*0.875/2)
			render.DrawTextureToScreenRect(self.Cam7,RW,	RH*0.875/2,	-RW/2,	RH*0.875/2)
		end
		DrawBox(0,600-75,800,75,Color(0,0,50))
		for i = 1, 7 do
			local t = surface.GetTextureID("dss/81-775/screens/icons/cams"..i)
			surface.SetTexture(t)
			surface.SetDrawColor(i == cstate and Color(0,255,255) or Color(255,255,255))
			surface.DrawTexturedRect(290+60*(i-1),600-70,30,30)
		end
		local t = surface.GetTextureID("dss/81-775/screens/icons/caml")
		surface.SetTexture(t)
		surface.SetDrawColor(Color(255,255,255))
		surface.DrawTexturedRect(200,600-32,30,30)
		local t = surface.GetTextureID("dss/81-775/screens/icons/camr")
		surface.SetTexture(t)
		surface.DrawTexturedRect(750,600-32,30,30)
		for i = 1, 4 do
			local t = surface.GetTextureID("dss/81-775/screens/icons/cam"..i)
			surface.SetTexture(t)
			surface.DrawTexturedRect(10+45*(i-1),600-35,30,30)
		end
		draw.RoundedBox(10,20,600-72,179,35,Color(50,50,70))
		local t = surface.GetTextureID("dss/81-775/screens/icons/camglaz")
		surface.SetTexture(t)
		surface.SetDrawColor(Color(0,255,255))
		surface.DrawTexturedRect(30,600-95,80,80)
		local t = surface.GetTextureID("dss/81-775/screens/icons/camcam")
		surface.SetTexture(t)
		surface.SetDrawColor(Color(255,255,255))
		surface.DrawTexturedRect(115,600-90,70,70)

		Metrostroi.DrawLine(40,600-35,780,600-35,Color(175,175,175),2)
	end

end
