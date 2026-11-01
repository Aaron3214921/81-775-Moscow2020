Metrostroi.DefineSystem("775BNT")

TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	self.Last = 1
	self.First = 1
	self.Station = 1
	self.Path = 1
	self.Line = 1
	self.Arrived = true
	self.Depaeted = false
	self.Ay = 0
	self.Active = false
	self.Wagon = 11
	self.Sync = false

	self.LastDataUpdate = 0
	self.DataUpdateInterval = 0.1
	self.LastRenderTime = 0
	self.RenderInterval = 0.022
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:Outputs()
    return {}
end

function TRAIN_SYSTEM:TriggerInput(name,value)

end

if TURBOSTROI then return end

function TRAIN_SYSTEM:CANReceive(source,sourceid,target,targetid,textdata,numdata)
    if textdata == "Last" then self.Last = numdata end
    if textdata == "First" then self.First = numdata end
	if textdata == "Station" then self.Station = numdata end
	if textdata == "Line" then self.Line = numdata end
	if textdata == "Path" then self.Path = numdata  end
	if textdata == "Arrived" then self.Arrived = numdata  end
	if textdata == "Depaeted" then self.Depaeted = numdata  end
	if textdata == "Active" then self.Active = numdata  end
	if textdata == "Wagon" then self.Wagon = numdata  end
	if textdata == "Sync" then self.Sync = numdata  end
	if textdata == "Depart123" then self.Train:SetNW2Bool("Depart123", numdata)
	 end
end

if SERVER then
	function TRAIN_SYSTEM:Think()
		local Train = self.Train
		local Power = Train.Electric.Power*Train["45F7"].Value

		Train:SetNW2Int("BNT:Last",self.Last)
		Train:SetNW2Int("BNT:First",self.First)
		Train:SetNW2Int("BNT:Station",self.Station)
		Train:SetNW2Int("BNT:Path",self.Path)
		Train:SetNW2Int("BNT:Line",self.Line)
		Train:SetNW2Bool("BNT:Arrived",self.Arrived)
		Train:SetNW2Bool("BNT:Depaeted",self.Depaeted)
		Train:SetNW2Bool("BNT:Active",self.Active)
		Train:SetNW2Bool("BNT:Sync",self.Sync)
		Train:SetNW2Bool("BNT:Orientation",self.Train.BUV.Orientation)

		self.Ay = math.Clamp(self.Ay + (self.Arrived and 20 or -20),0,200)

		Train:SetNW2Int("BNT:Ay",self.Ay)

		Train:SetNW2Int("BNT:Power",Power)
		Train:SetNW2Int("BNT:Wagon",self.Wagon)

	end

end

if CLIENT then
	function TRAIN_SYSTEM:ClientInitialize()
		self.Map = Metrostroi.CurrentMap
		self.Sxpos = 100
		self.SD = 1
		self.FPSTimer = CurTime()
		self.sllr = 0
		self.ltx = 0
		self.sllc = 0
		self.Dy = 0
		self.Oyr = 0
		self.Oyl = 0
		self.Ayl = 0
		self.Oyr = 0
		self.Ayr = 0
		self.SlonA = 0
		self.ltrx = 0
		self.ftrx = 0
		self.flx = 0
		self.llx = 0

		self.LastDataUpdate = 0
		self.DataUpdateInterval = 0.1
		self.LastRenderTime = 0
		self.RenderInterval = 0.022
		self.CachedData = {}
	end

	local function createFont(name,font,size,weight)
		surface.CreateFont("Metrostroi_775D_"..name, {
			font = font,
			size = size,
			weight = weight or 400,
			blursize = 0,
			antialias = true,
			underline = false,
			italic = false,
			strikeout = false,
			symbol = false,
			rotary = false,
			shadow = false,
			additive = false,
			outline = false,
			extended = true,
		})
	end
	createFont("MS-10","Moscow Sans Regular",-10)
	createFont("MS10","Moscow Sans Regular",10)
	createFont("MS40","Moscow Sans Regular",40)
	createFont("MS50","Moscow Sans Regular",50)
	createFont("MS60","Moscow Sans Regular",60)
	createFont("MS75","Moscow Sans Regular",75)
	createFont("MS100","Moscow Sans Regular",100)
	createFont("MS150","Moscow Sans Regular",150)
	createFont("MS200","Moscow Sans Regular",200)
	createFont("MS0","Moscow Sans Regular",0)
	createFont("MSP50","moscowsans_pictogram_expanded",50)
	createFont("MSP75","moscowsans_pictogram_expanded",75)
	createFont("MSP100","moscowsans_pictogram_expanded",100)
	createFont("MSP150","moscowsans_pictogram_expanded",150)
	createFont("MSP255","moscowsans_pictogram_expanded",255)

	local W,H = 1920*2,238*2

	function TRAIN_SYSTEM:UpdateCachedData()
		self.CachedData = {
			power = self.Train:GetNW2Int("BNT:Power", 0),
			speed = self.Train:GetPackedRatio("Speed"),
			temp = 21,
			time = Metrostroi.GetSyncTime(),
			cs = self.Train:GetNW2Int("BNT:Station", 1),
			fs = self.Train:GetNW2Int("BNT:First", 1),
			ls = self.Train:GetNW2Int("BNT:Last", 8),
			path = self.Train:GetNW2Int("BNT:Path", 1),
			line = self.Train:GetNW2Int("BNT:Line", 1),
			arrived = self.Train:GetNW2Bool("BNT:Arrived"),
			depaeted = self.Train:GetNW2Bool("BNT:Depaeted"),
			active = self.Train:GetNW2Bool("BNT:Active"),
			sync = self.Train:GetNW2Bool("BNT:Sync"),
			ay = self.Train:GetNW2Int("BNT:Ay", 0),
			wagon = self.Train:GetNW2Int("BNT:Wagon", 11),
			orientation = self.Train:GetNW2Bool("BNT:Orientation")
		}
	end

	local optimizationCV
	function TRAIN_SYSTEM:ClientThink()
		optimizationCV = optimizationCV or GetConVar("775_optimization")
		local optimizationFlag = optimizationCV:GetInt()
    if optimizationFlag == 1 then
        return
    end

		local currentTime = CurTime()

		if currentTime - self.LastDataUpdate > self.DataUpdateInterval then
			self:UpdateCachedData()
			self.LastDataUpdate = currentTime
		end

		if not self.Train:ShouldDrawPanel("BNTS1") and not self.Train:ShouldDrawPanel("BNTS8") then return end
		if self.FPSTimer + self.RenderInterval > currentTime then return end

		local Orientation = self.CachedData.orientation

		render.PushRenderTarget(self.Train.BNTScr,0,0,W,H)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			render.SetScissorRect(0, 0, W,H, true)
			surface.SetDrawColor(0,0,0,0)
			surface.DrawRect(0,0,W,H)
			self:DrawPanel(self.Train,not Orientation)
			render.SetScissorRect(0, 0, 0, 0, false)
		cam.End2D()
		render.PopRenderTarget()

		render.PushRenderTarget(self.Train.BNTScr2,0,0,W,H)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			render.SetScissorRect(0, 0, W,H, true)
			surface.SetDrawColor(0,0,0,0)
			surface.DrawRect(0,0,W,H)
			self:DrawPanel(self.Train,not Orientation)
			render.SetScissorRect(0, 0, 0, 0, false)
		cam.End2D()
		render.PopRenderTarget()

		render.PushRenderTarget(self.Train.BNTScr3,0,0,W,H)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			render.SetScissorRect(0, 0, W,H, true)
			surface.SetDrawColor(0,0,0,0)
			surface.DrawRect(0,0,W,H)
			self:DrawPanel(self.Train,not Orientation)
			render.SetScissorRect(0, 0, 0, 0, false)
		cam.End2D()
		render.PopRenderTarget()

		render.PushRenderTarget(self.Train.BNTScr4,0,0,W,H)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			render.SetScissorRect(0, 0, W,H, true)
			surface.SetDrawColor(0,0,0,0)
			surface.DrawRect(0,0,W,H)
			self:DrawPanel(self.Train,not Orientation)
			render.SetScissorRect(0, 0, 0, 0, false)
		cam.End2D()
		render.PopRenderTarget()

		render.PushRenderTarget(self.Train.BNTScr5,0,0,W,H)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			render.SetScissorRect(0, 0, W,H, true)
			surface.SetDrawColor(0,0,0,0)
			surface.DrawRect(0,0,W,H)
			self:DrawPanel(self.Train,Orientation)
			render.SetScissorRect(0, 0, 0, 0, false)
		cam.End2D()
		render.PopRenderTarget()

		render.PushRenderTarget(self.Train.BNTScr6,0,0,W,H)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			render.SetScissorRect(0, 0, W,H, true)
			surface.SetDrawColor(0,0,0,0)
			surface.DrawRect(0,0,W,H)
			self:DrawPanel(self.Train,Orientation)
			render.SetScissorRect(0, 0, 0, 0, false)
		cam.End2D()
		render.PopRenderTarget()

		render.PushRenderTarget(self.Train.BNTScr7,0,0,W,H)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			render.SetScissorRect(0, 0, W,H, true)
			surface.SetDrawColor(0,0,0,0)
			surface.DrawRect(0,0,W,H)
			self:DrawPanel(self.Train,Orientation)
			render.SetScissorRect(0, 0, 0, 0, false)
		cam.End2D()
		render.PopRenderTarget()

		render.PushRenderTarget(self.Train.BNTScr8,0,0,W,H)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			render.SetScissorRect(0, 0, W,H, true)
			surface.SetDrawColor(0,0,0,0)
			surface.DrawRect(0,0,W,H)
			self:DrawPanel(self.Train,Orientation)
			render.SetScissorRect(0, 0, 0, 0, false)
		cam.End2D()
		render.PopRenderTarget()

		self.FPSTimer = currentTime

	end

	local function DrawBox(x,y,w,h,color)
		color = color or Color(255,0,0)
		surface.SetDrawColor(color.r,color.g,color.b,color.a)
		surface.DrawRect(x or 0,y or 0,w or 10,h or 10)
	end

	function TRAIN_SYSTEM:DrawStation(sname,station,color,f,l,sll,cs,cl,sllc,arrived,Ay,y,cf)
		local b = color == Color(0,0,0) and 1 or 0
		Ay = cs and Ay or 0
		draw.SimpleText(station.ename or "",cs and "Metrostroi_775D_MS50" or "Metrostroi_775D_MS40",sll-8-(cs and 30 or 6)-sllc,(cs and 130-70 or 180-40)+Ay+y,Color(255*b,255*b,255*b,sname and ((150-Ay)*1.7) or 0),0,1)
		local tx,_ = draw.SimpleText(station.fname or station.name,cs and "Metrostroi_775D_MS100" or "Metrostroi_775D_MS50",sll-15-(cs and 30 or 0)-sllc,(cs and 130 or 180)+Ay+y,Color(255*b,255*b,255*b,sname and ((150-Ay)*1.7) or 0),0,1)
		if cs and sname then
			DrawBox(40,20-200+Ay+y,tx+10,170,Color(color.r,color.g,color.b,Ay*1.7))
			draw.SimpleText(station.ename or "",cs and "Metrostroi_775D_MS50" or "Metrostroi_775D_MS40",sll-8-(cs and 30 or 6)-sllc,(cs and 130-70 or 170-40)-200+Ay+y,Color(255*b,255*b,255*b,sname and 255 or 0),0,1)
			draw.SimpleText(station.fname or station.name,cs and "Metrostroi_775D_MS100" or "Metrostroi_775D_MS50",sll-15-(cs and 30 or 0)-sllc,(cs and 130 or 170)-200+Ay+y,Color(255*b,255*b,255*b,sname and 255 or 0),0,1)
		end
		if cl then
			self.ltx = cl and 0 or tx
			self.ltrx = station.tr and tx or tx/2
		end
		if cf then
			self.ftrx = station.tr and 90 or tx/2
		end
		if cs then
			self.sllc = math.min(self.sllc+10,sll - 90)
		end
		local trx = 0
		if station.tr and not cs then
			for k, v in pairs(station.tr) do
				trx = trx + 10
				trx,_ = trx + draw.SimpleText(v.p,cs and "Metrostroi_775D_MSP150" or "Metrostroi_775D_MSP50",sll-15+tx+trx-sllc,(cs and 150+15 or 180+7.5)+y,Color(v.lc.r,v.lc.g,v.lc.b,sname and 255 or 0),0,1)
			end
		end
		if not sname then
			if not station.tr then
				DrawBox(sll-(cs and 90/2 or 0)+tx/2-20-sllc,H/2-20+y,10,(cl or cf) and 40 or 20,color)
				if cf then
					self.flx = sll-(cs and 90/2 or 0)+tx/2-20-sllc
				elseif cl then
					self.llx = sll-(cs and 90/2 or 0)+tx/2-20 - self.flx - sllc
				end
			else
				draw.RoundedBox(cs and 40 or 25,	cs and sll-35-sllc or sll-10-sllc,	H/2-(cs and 40 or 25)+y,	cs and 80 or 50,	cs and 80 or 50,	color)
				draw.RoundedBox(cs and 30 or 20,	cs and sll-25-sllc or sll-sllc,		H/2-(cs and 30 or 15)+y,	cs and 60 or 30,	cs and 60 or 30,	Color(255,255,255))
				if cf then
					self.flx = sll-sllc
				elseif cl then
					self.llx = sll-sllc- self.flx
				end
			end
		end
		return  tx + trx
	end


	function TRAIN_SYSTEM:drawLine(sname,map,fs,ls,cs,p,l,color,arrived,Ay,y)
		local css = math.floor(cs/2)+fs
		if css == nil then return end
		self.sll = 90
		if not sname then
		DrawBox(self.flx,H/2-5+y,self.llx,10,color)
		end
		for i = fs , ls do
			if i == ls then
											self:DrawStation(sname,map[i],color,css==fs,css==ls,self.sll,i==css,i == ls,self.sllc,arrived,Ay,y,i == fs)
			else
				self.sll = self.sll + 100 + self:DrawStation(sname,map[i],color,css==fs,css==ls,self.sll,i==css,i == ls,self.sllc,arrived,Ay,y,i == fs)
			end
		end
		self.sllr = self.sll
	end

	local function LeftExit(tbl,ys,map,cs)
		local tx = 0
		if tbl.t == 1 then
			Metrostroi.DrawLine(150+tx,H/2+90+ys,300+tx,H/2+90+ys,Color(0,0,0),2)
			Metrostroi.DrawLine(150+tx,H/2+150+ys,300+tx,H/2+150+ys,Color(0,0,0),2)
			for i = 0, 9 do
				Metrostroi.DrawLine(150+15*i+tx,H/2+90+ys,150+15*i+tx,H/2+150+ys,Color(0,0,0),2)
			end
			tx,_ = tx + 10 + draw.SimpleText("←","Metrostroi_775D_MS100",320+tx,H/2+120+ys,Color(0,0,0),0,1)
			tx,_ = tx + draw.SimpleText("a","Metrostroi_775D_MSP75",320+tx,H/2+120+ys,Color(0,0,0),0,1)
			Metrostroi.DrawLine(350+tx,H/2+70+ys,350+tx,H/2+170+ys,Color(0,0,0),2)
			tx = tx+30
		elseif tbl.t == 2 then
			Metrostroi.DrawRectOutline(150+tx,H/2+84+ys,150,7,Color(0,0,0),2)
			Metrostroi.DrawRectOutline(150+tx,H/2+116+ys,150,7,Color(0,0,0),2)
			Metrostroi.DrawRectOutline(150+tx,H/2+150+ys,150,7,Color(0,0,0),2)
			for i = 0, 9 do
				Metrostroi.DrawLine(150+15*i+tx,H/2+90+ys,150+15*i+tx,H/2+116+ys,Color(0,0,0),2)
				Metrostroi.DrawLine(150+15*i+tx,H/2+122+ys,150+15*i+tx,H/2+150+ys,Color(0,0,0),2)
			end
			tx,_ = tx + 10 + draw.SimpleText("←","Metrostroi_775D_MS100",320+tx,H/2+120+ys,Color(0,0,0),0,1)
			tx,_ = tx + draw.SimpleText("a","Metrostroi_775D_MSP75",320+tx,H/2+120+ys,Color(0,0,0),0,1)
			Metrostroi.DrawLine(350+tx,H/2+70+ys,350+tx,H/2+170+ys,Color(0,0,0),2)
			tx = tx+30
		end
		for i = 1, #tbl.e do
			local e = tbl.e[i]
			local w = 0
			if e.t == 1 then
				surface.SetFont("Metrostroi_775D_MS75")
				w = surface.GetTextSize(e.e)
				DrawBox(350+tx,H/2+120-35+ys,math.max(w+20,75),75,Color(0,0,0))
				draw.SimpleText(e.e,"Metrostroi_775D_MS75",350+tx+math.max(w+20,75)/2,H/2+120+ys,Color(249,207,9),1,1)
				tx = tx + math.max(w+20,75) + 15
			elseif e.t == 2 then
				tx = tx + draw.SimpleText(e.e,"Metrostroi_775D_MSP75",350+tx+math.max(w+20,75)/2,H/2+120+ys,e.c,1,1)
				tx = tx +  15
			elseif e.t == 3 or e.t == 4 then
				surface.SetFont("Metrostroi_775D_MS40")
				local w,h = surface.GetTextSize(e.e)
				draw.DrawText(e.e,e.t == 4 and "Metrostroi_775D_MS100" or "Metrostroi_775D_MS40",350+tx,H/2+120-h/2+ys-(e.t == 4 and 30 or 0),Color(0,0,0),0)
				tx = tx + w+50
			end
		end
	end
	local function CenterExit(tbl,ys,map,cs)
		ys = ys - 10
		local wx = W/2+tbl.x
		local tx = 0
		if tbl.t == 1 then
			Metrostroi.DrawLine(wx-150+tx,H/2+90+ys,wx-300+tx,H/2+90+ys,Color(0,0,0),2)
			Metrostroi.DrawLine(wx-150+tx,H/2+150+ys,wx-300+tx,H/2+150+ys,Color(0,0,0),2)
			for i = 0, 9 do
				Metrostroi.DrawLine(wx-150-15*i+tx,H/2+90+ys,wx-150-15*i+tx,H/2+150+ys,Color(0,0,0),2)
			end
			tx,_ = - 10 - tx - draw.SimpleText("→","Metrostroi_775D_MS100",wx-320+tx,H/2+120+ys,Color(0,0,0),2,1)
			tx,_ = tx - draw.SimpleText("a","Metrostroi_775D_MSP75",wx-320+tx,H/2+120+ys,Color(0,0,0),2,1)
			Metrostroi.DrawLine(wx-350+tx,H/2+70+ys,wx-350+tx,H/2+170+ys,Color(0,0,0),2)
			tx = tx-30
		elseif tbl.t == 2 then
			Metrostroi.DrawRectOutline(wx-150+tx,H/2+84+ys,-150,7,Color(0,0,0),2)
			Metrostroi.DrawRectOutline(wx-150+tx,H/2+116+ys,-150,7,Color(0,0,0),2)
			Metrostroi.DrawRectOutline(wx-150+tx,H/2+150+ys,-150,7,Color(0,0,0),2)
			for i = 0, 9 do
				Metrostroi.DrawLine(wx-150-15*i+tx,H/2+90+ys,W-150-15*i+tx,H/2+116+ys,Color(0,0,0),2)
				Metrostroi.DrawLine(wx-150-15*i+tx,H/2+122+ys,W-150-15*i+tx,H/2+150+ys,Color(0,0,0),2)
			end
			tx,_ = - 10 - tx - draw.SimpleText("→","Metrostroi_775D_MS100",wx-320+tx,H/2+120+ys,Color(0,0,0),2,1)
			tx,_ = tx - draw.SimpleText("a","Metrostroi_775D_MSP75",wx-320+tx,H/2+120+ys,Color(0,0,0),2,1)
			Metrostroi.DrawLine(wx-350+tx,H/2+70+ys,wx-350+tx,H/2+170+ys,Color(0,0,0),2)
			tx = tx-30
		end
		for i = 1, #tbl.e do
			local e = tbl.e[i]
			local w = 0
			if e.t == 1 then
				surface.SetFont("Metrostroi_775D_MS75")
				local w = surface.GetTextSize(e.e)
				DrawBox(wx-350+tx,H/2+120-35+ys,math.max(w+20,75)*-1,75,Color(0,0,0))
				draw.SimpleText(e.e,"Metrostroi_775D_MS75",wx-350+tx-math.max(w+20,75)/2,H/2+120+ys,Color(249,207,9),1,1)
				tx = tx - math.max(w+20,75) - 15
			elseif e.t == 2 then
				tx = tx - draw.SimpleText(e.e,"Metrostroi_775D_MSP75",wx-350+tx-math.max(w+20,75)/2,H/2+120+ys,e.c,1,1)
				tx = tx -  15
			elseif e.t == 3 or e.t == 4 then
				surface.SetFont("Metrostroi_775D_MS40")
				local w,h = surface.GetTextSize(e.e)
				draw.DrawText(e.e,e.t == 4 and "Metrostroi_775D_MS100" or "Metrostroi_775D_MS40",wx-350+tx,H/2+120-h/2+ys-(e.t == 4 and 30 or 0),Color(0,0,0),2)
				tx = tx - w-50
			elseif e.t == 5 then
				draw.SimpleText("↑","Metrostroi_775D_MS100",wx-320+tx-20,H/2+120+ys,Color(0,0,0),2,1)
				draw.SimpleText("↑","Metrostroi_775D_MS100",wx-320+tx-135,H/2+120+ys,Color(0,0,0),2,1)
				Metrostroi.DrawLine(wx-390+tx,H/2+70+ys,wx-390+tx,H/2+160+ys,Color(0,0,0),2)
				Metrostroi.DrawLine(wx-455+tx,H/2+70+ys,wx-455+tx,H/2+160+ys,Color(0,0,0),2)
				for i = 0, 5 do
					Metrostroi.DrawLine(wx-390+tx,H/2+70+ys+15*i,wx-455+tx,H/2+70+ys+15*i,Color(0,0,0),2)
				end
				tx = tx - 150
			end
		end
	end
	local function RightExit(tbl,ys,map,cs)
		local tx = 0
		if tbl.t == 1 then
			Metrostroi.DrawLine(W-150+tx,H/2+90+ys,W-300+tx,H/2+90+ys,Color(0,0,0),2)
			Metrostroi.DrawLine(W-150+tx,H/2+150+ys,W-300+tx,H/2+150+ys,Color(0,0,0),2)
			for i = 0, 9 do
				Metrostroi.DrawLine(W-150-15*i+tx,H/2+90+ys,W-150-15*i+tx,H/2+150+ys,Color(0,0,0),2)
			end
			tx,_ = - 10 - tx - draw.SimpleText("→","Metrostroi_775D_MS100",W-320+tx,H/2+120+ys,Color(0,0,0),2,1)
			tx,_ = tx - draw.SimpleText("a","Metrostroi_775D_MSP75",W-320+tx,H/2+120+ys,Color(0,0,0),2,1)
			Metrostroi.DrawLine(W-350+tx,H/2+70+ys,W-350+tx,H/2+170+ys,Color(0,0,0),2)
			tx = tx-30
		elseif tbl.t == 2 then
			Metrostroi.DrawRectOutline(W-150+tx,H/2+84+ys,-150,7,Color(0,0,0),2)
			Metrostroi.DrawRectOutline(W-150+tx,H/2+116+ys,-150,7,Color(0,0,0),2)
			Metrostroi.DrawRectOutline(W-150+tx,H/2+150+ys,-150,7,Color(0,0,0),2)
			for i = 0, 9 do
				Metrostroi.DrawLine(W-150-15*i+tx,H/2+90+ys,W-150-15*i+tx,H/2+116+ys,Color(0,0,0),2)
				Metrostroi.DrawLine(W-150-15*i+tx,H/2+122+ys,W-150-15*i+tx,H/2+150+ys,Color(0,0,0),2)
			end
			tx,_ = - 10 - tx - draw.SimpleText("→","Metrostroi_775D_MS100",W-320+tx,H/2+120+ys,Color(0,0,0),2,1)
			tx,_ = tx - draw.SimpleText("a","Metrostroi_775D_MSP75",W-320+tx,H/2+120+ys,Color(0,0,0),2,1)
			Metrostroi.DrawLine(W-350+tx,H/2+70+ys,W-350+tx,H/2+170+ys,Color(0,0,0),2)
			tx = tx-30
		end
		for i = 1, #tbl.e do
			local e = tbl.e[i]
			local w = 0
			if e.t == 1 then
				surface.SetFont("Metrostroi_775D_MS75")
				local w = surface.GetTextSize(e.e)
				DrawBox(W-350+tx,H/2+120-35+ys,math.max(w+20,75)*-1,75,Color(0,0,0))
				draw.SimpleText(e.e,"Metrostroi_775D_MS75",W-350+tx-math.max(w+20,75)/2,H/2+120+ys,Color(249,207,9),1,1)
				tx = tx - math.max(w+20,75) - 15
			elseif e.t == 2 then
				tx = tx - draw.SimpleText(e.e,"Metrostroi_775D_MSP75",W-350+tx-math.max(w+20,75)/2,H/2+120+ys,e.c,1,1)
				tx = tx -  15
			elseif e.t == 3 or e.t == 4 then
				surface.SetFont("Metrostroi_775D_MS40")
				local w,h = surface.GetTextSize(e.e)
				draw.DrawText(e.e,e.t == 4 and "Metrostroi_775D_MS100" or "Metrostroi_775D_MS40",W-350+tx,H/2+120-h/2+ys-(e.t == 4 and 30 or 0),Color(0,0,0),2)
				tx = tx - w-50
			end
		end
	end

	local function drawsinfo(ys,wagon,last,map,cs)
		local wagons = math.floor(wagon*0.1)
		wagon = wagon - wagons*10
		if not last then
			DrawBox(0,H/2+ys,W,H/2,Color(255,255,255))
		end
		ys = ys*1.6
		DrawBox(0,H/2+ys,W,H/2,Color(201,201,201))
		draw.RoundedBox(30,3723-30+5,313-30+ys,60,60,Color(255,255,255))
		draw.RoundedBox(30,113-30-5,403-30+ys,60,60,Color(255,255,255))
		draw.RoundedBoxEx(30,1917.5-3629/2,358-75+ys,3629,150,Color(255,255,255),true,false,false,true)
		surface.SetDrawColor(255,255,255,255)
		draw.NoTexture()
		surface.DrawPoly({
			{x=80,y=390+ys},
			{x=107,y=295+ys},
			{x=107,y=390+ys}
		})
		surface.DrawPoly({
			{x=3629+80+21,y=295+22+ys},
			{x=3629+98+21+10,y=295+22+ys},
			{x=3629+80+21,y=390+25+ys}
		})

		if map[cs].tre then
			if map[cs].tre.l then
				LeftExit(map[cs].tre.l,ys,map,cs)
			end
			if map[cs].tre.c then
				CenterExit(map[cs].tre.c,ys,map,cs)
			end
			if map[cs].tre.c2 then
				CenterExit(map[cs].tre.c2,ys,map,cs)
			end
			if map[cs].tre.c3 then
				CenterExit(map[cs].tre.c3,ys,map,cs)
			end
			if map[cs].tre.r then
				RightExit(map[cs].tre.r,ys,map,cs)
			end
		end

		for i = 1, wagons do
			local x = W/2-200*wagons+400*(i-1)
			draw.RoundedBox(16,x,406+ys,390,70,wagons-i+1 == wagon and Color(0,200,0) or Color(120,120,120))
			for i2 = 0, 3 do
				draw.RoundedBox(4,x+77+74*i2,420+ys,70,26,Color(255,255,255))
			end
			if i == wagons then
				draw.RoundedBox(10,x+390,456+ys,20,20,wagons-i+1 == wagon and Color(0,200,0) or Color(120,120,120))
				local c = wagons-i+1 == wagon
				surface.SetDrawColor(c and 0 or 120,c and 200 or 120,c and 0 or 120,255)
				draw.NoTexture()
				surface.DrawPoly({
					{x=x+400,y=476+ys},
					{x=x+370,y=476+ys},
					{x=x+387,y=412+ys},
					{x=x+409,y=462+ys}
				})
			end
			draw.SimpleText(wagons-i+1,"Metrostroi_775D_MS60",x+35,406+30+ys,Color(255,255,255),1,1)
		end
	end

	function TRAIN_SYSTEM:DrawPanel(Train,left)
		local data = self.CachedData

		local Power = data.power
		local speed = data.speed
		local temp = data.temp
		local time = data.time
		local CS = data.cs
		local FS = data.fs
		local LS = data.ls
		local path = data.path
		local line = data.line
		local arrived = data.arrived
		local depaeted = data.depaeted
		local active = data.active
		local sync = data.sync
		local Ay = data.ay
		local wagon = data.wagon

		local Map = path == 2 and table.Reverse(Metrostroi.ANNOUNCER_MAP_775[line].stations) or Metrostroi.ANNOUNCER_MAP_775[line].stations

		draw.RoundedBox(0,0,0,W,H,Power > 0 and Color(255,255,255) or Color(0,0,0))
		if Power > 0 then
			if not left and not active or not sync then
				draw.RoundedBox(0,0,0,W,H,Color(20,20,20))
				local w,h = draw.SimpleText( sync and not active and "БЛОК НЕАКТИВЕН" or "НЕТ СВЯЗИ","Metrostroi_775D_MS200",self.ActiveX,self.ActiveY,Color(255,255,255),1,1)

				self.ActiveX = self.ActiveX and (self.ActiveXD and self.ActiveX - 14 or self.ActiveX + 14 ) or 1920/2
				self.ActiveY = self.ActiveY and (self.ActiveYD and self.ActiveY - 7 or self.ActiveY + 7 ) or 238*2
				if self.ActiveX-w/2 < 0 then
					self.ActiveXD = false
				end
				if self.ActiveX+w/2 > 1920*2 then
					self.ActiveXD = true
				end
				if self.ActiveY-h/2 < 0 then
					self.ActiveYD = false
				end
				if self.ActiveY+h/2 > 238*2 then
					self.ActiveYD = true
				end
				return
			elseif not left and self.ActiveX then
				self.ActiveX = nil
				self.ActiveY = nil
			end
			if left and not active then
				draw.RoundedBox(0,0,0,W,H,Color(20,20,20))
				local w,h = draw.SimpleText("БЛОК НЕАКТИВЕН","Metrostroi_775D_MS200",self.ActiveLX,self.ActiveLY,Color(255,255,255),1,1)

				self.ActiveLX = self.ActiveLX and (self.ActiveLXD and self.ActiveLX + 12 or self.ActiveLX - 12 ) or 1920*2
				self.ActiveLY = self.ActiveLY and (self.ActiveLYD and self.ActiveLY - 9 or self.ActiveLY + 9 ) or 238/2
				if self.ActiveLX-w/2 < 0 then
					self.ActiveLXD = true
				end
				if self.ActiveLX+w/2 > 1920*2 then
					self.ActiveLXD = false
				end
				if self.ActiveLY-h/2 < 0 then
					self.ActiveLYD = false
				end
				if self.ActiveLY+h/2 > 238*2 then
					self.ActiveLYD = true
				end
				return
			elseif left and self.ActiveLX then
				self.ActiveLX = nil
				self.ActiveLY = nil
			end

			local IsLeft = left and not Map[math.floor(CS/2)+FS].right[path]
			local IsRight = not left and Map[math.floor(CS/2)+FS].right[path]

			if left then
				self.Oyl = math.Clamp(self.Oyl+((left and Map[math.floor(CS/2)+FS].right[path]) and 5 or -5),0,150)
				self.Ayl = math.Clamp(self.Ayl+((IsLeft and (depaeted and self.SlonA < 120)) and 5 or -5),0,150)
			else
				self.Oyr = math.Clamp(self.Oyr+((not left and not Map[math.floor(CS/2)+FS].right[path]) and 5 or -5),0,150)
				self.Ayr = math.Clamp(self.Ayr+((IsRight and (depaeted and self.SlonA < 120)) and 5 or -5),0,150)
			end

			draw.SimpleText(Format("%d км/ч",speed),"Metrostroi_775D_MS50",W/2-250,30,Color(150,150,150),1,1)
			draw.SimpleText(Format("%d °C",temp),"Metrostroi_775D_MS50",W/2+250,30,Color(150,150,150),1,1)
			draw.SimpleText(os.date("!%H:%M",time),"Metrostroi_775D_MS50",W/2,30,Color(150,150,150),1,1)

			local tw,_ = draw.SimpleText(Metrostroi.ANNOUNCER_MAP_775[line].fname,"Metrostroi_775D_MS50",W-50,30,Color(0,0,0),2,1)
			draw.SimpleText(Metrostroi.ANNOUNCER_MAP_775[line].pic,"Metrostroi_775D_MSP75",W-70-tw,35,Metrostroi.ANNOUNCER_MAP_775[line].color,2,1)
			local last = math.floor(CS/2)+FS == LS and arrived
			if last then
				DrawBox(0,0,W,H,Color(249,207,9))
			end
			local OAyl = math.Clamp((left and self.Oyl or self.Oyr)+(left and self.Ayl or self.Ayr),0,150)
			self:drawLine(true,Map,FS,LS,CS,path,line,Metrostroi.ANNOUNCER_MAP_775[line].color,arrived,Ay,OAyl)
			if last then
				local slon = surface.GetTextureID("dss/slon")
				surface.SetTexture(slon)
				surface.SetDrawColor(255,255,255)
				surface.DrawTexturedRect(W-750,H-512+60+150-(IsLeft and 165 or 0),1024-150-(IsLeft and 100 or 0),512-150-(IsLeft and 100 or 0))
				draw.SimpleText("Конечная","Metrostroi_775D_MS150",W/2,H/2-50+OAyl-125,Color(0,0,0),1,1)
				draw.SimpleText("Поезд дальше не идет, пожалуйста, выйдите из вагона","Metrostroi_775D_MS75",W/2,H/2+50+OAyl-125,Color(0,0,0),1,1)
			end
			drawsinfo(OAyl,wagon,last,Map,math.floor(CS/2)+FS)
				self:drawLine(false,Map,FS,LS,CS,path,line,Metrostroi.ANNOUNCER_MAP_775[line].color,arrived,Ay,OAyl)

			DrawBox(0,-150+(left and self.Oyl or self.Oyr),W,150,Color(200,200,200))
			draw.SimpleText("Выход из дверей напротив","Metrostroi_775D_MS75",W/2,-75+(left and self.Oyl or self.Oyr),Color(0,0,0),1,1)
			DrawBox(0,-150+(left and self.Ayl or self.Ayr),W,150,Color(249,207,9))
			draw.SimpleText("Осторожно, двери закрываются","Metrostroi_775D_MS75",W/4,-75+(left and self.Ayl or self.Ayr),Color(0,0,0),1,1)
			draw.SimpleText("Осторожно, двери закрываются","Metrostroi_775D_MS75",W/1.25,-75+(left and self.Ayl or self.Ayr),Color(0,0,0),1,1)
			self.SlonA = math.min(self.SlonA + 0.2,depaeted and 120 or -20)
			local SlonA = math.Round(self.SlonA)
			local slonic = surface.GetTextureID(Format("dss/81-775_v2/slon/slon_0000%.2d",SlonA < 0 and 0 or SlonA > 82 and 82 or SlonA))
			surface.SetTexture(slonic)
			surface.SetDrawColor(255,255,255)
			surface.DrawTexturedRect(W/2-2560/4.43/2,(left and self.Ayl or self.Ayr)-150-45,2560/4.43,864/4.43)

			local size = 30
			if RealTime() % 2.4 > 1.8 then
				draw.RoundedBox(0,W-size,H-size,size,size,Color(255,255,255))
			elseif RealTime() % 2 > 1.2 then
				draw.RoundedBox(0,W-size,H-size,size,size,Color(255,0,0))
			elseif RealTime() % 2 > 0.6 then
				draw.RoundedBox(0,W-size,H-size,size,size,Color(0,255,0))
			elseif RealTime() % 2 > 0 then
				draw.RoundedBox(0,W-size,H-size,size,size,Color(0,0,255))
			end

		end
	end
	matproxy.Add({
		name = "BNTSlon",
		init = function( self, mat, values )
			if values then self._MATresultVarF = values.resultvar end
		end,
		bind = function( self, mat, ent )
			mat:SetInt(self._MATresultVarF,50)
	 	end
	})
end
