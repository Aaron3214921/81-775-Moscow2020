Metrostroi.DefineSystem("81_775_Speedometer")
local JSONCache = setmetatable({}, {__mode = "k"})
local function CachedJSON(ent, key, s)
	local c = JSONCache[ent]
	if not c then c = {} JSONCache[ent] = c end
	local e = c[key]
	if e and e[1] == s then return e[2] end
	local t = util.JSONToTable(s)
	c[key] = {s, t}
	return t
end
local function NWJSON(ent, key, def)
	return CachedJSON(ent, key, ent:GetNW2String(key, def))
end
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	self.State = 0
	self.StSl = 0
	self.RNEnter = false
	self.RNEntering = false
	self.RN = "000"
end

local function inrange(posx, posy, x1, y1, x2, y2)
	return posx > x1 and posy > y1 and posx < x2 and posy < y2
end

local PRESS_TIME = 0.3

local function SetPress(self,id)
	self.Press = id
	self.PressTimer = CurTime() + PRESS_TIME
end

function TRAIN_SYSTEM:Touch(value,x,y)
	if not value then return end
	if self.State > 0 then
		if self.RNEnter then
			local action
			if inrange(x, y, 128, 143, 224, 185) then action = "1" end
			if inrange(x, y, 252, 143, 370, 185) then action = "2" end
			if inrange(x, y, 376, 143, 495, 185) then action = "3" end
			if inrange(x, y, 128, 195, 224, 239) then action = "4" end
			if inrange(x, y, 252, 195, 370, 239) then action = "5" end
			if inrange(x, y, 376, 195, 495, 239) then action = "6" end
			if inrange(x, y, 128, 248, 224, 292) then action = "7" end
			if inrange(x, y, 252, 248, 370, 292) then action = "8" end
			if inrange(x, y, 376, 248, 495, 292) then action = "9" end
			if inrange(x, y, 128, 301, 224, 345) then action = "C" end
			if inrange(x, y, 252, 301, 370, 345) then action = "0" end
			if inrange(x, y, 376, 301, 495, 345) then action = "A" end
			if not action then return end
			SetPress(self,"k"..action)
			if action == "A" then
				self.RN = self.RN == "" and (self.OldRN or "000") or Format("%03d",tonumber(self.RN))
				self.RNEnter = false
				self.Train.CIK.Route = tonumber(self.RN) or 0
				return
			elseif action == "C" then
				self.RN = ""
				return
			elseif #self.RN < 3 or not self.RNEntering then
				self.RN = self.RNEntering and self.RN..action or action
				self.RNEntering = true
			end

		else
			if inrange(x, y, 3, 144, 80, 185) then
				SetPress(self,"rn")
				self.RNEnter = true
				self.RNEntering = false
				self.OldRN = self.RN
			end
			if inrange(x, y, 91, 144, 172, 185) then
				SetPress(self,"path")
				self.Train.CIK:RouteSetup(true)
			end
			if inrange(x, y, 180, 144, 260, 185) then
				SetPress(self,"zero")
				self.Train.CIK:SetZero()
			end
			if inrange(x, y, 268, 144, 350, 185) then
				SetPress(self,"ad")
				self.Train.CIK.AutoD = not self.Train.CIK.AutoD
			end
			if inrange(x, y, 356, 144, 436, 185) then
				SetPress(self,"aa")
				self.Train.CIK.AutoA = not self.Train.CIK.AutoA
			end

			if inrange(x, y, 445, 195, 526, 240) then SetPress(self,"up") end
			if inrange(x, y, 445, 248, 526, 293) then SetPress(self,"down") end
			if inrange(x, y, 445, 301, 526, 346) then SetPress(self,"enter") end
			local cik = self.Train.CIK
			if cik and cik.State and cik.State > 1 and cik.Stations then
				local maxStation = math.max(1, table.maxn(cik.Stations) - 1)
				if inrange(x, y, 445, 195, 526, 240) then
					cik.Station = math.max(1, cik.Station - 1)
				end
				if inrange(x, y, 445, 248, 526, 293) then
					cik.Station = math.min(maxStation, cik.Station + 1)
				end
				if inrange(x, y, 445, 301, 526, 346) then
					cik:Trigger("R_Program1", true)
				end
			end
		end
	end
end

function TRAIN_SYSTEM:Think()
	local Train = self.Train

	local Speedometer_Power = Train.Electric.Power*Train.SF5.Value > 0.5

	local BKPU = Train.BKPU
	local trains = BKPU.Trains
	local wag_num = #trains

	if Speedometer_Power and self.State == 0 and not self.EnableDisplay then
		self.EnableDisplay = CurTime() + 22
		self.State = 100
	end

	if self.EnableDisplay and CurTime()-self.EnableDisplay > 0 then
		self.State = 1
		self.EnableDisplay = nil
	end

	if not Speedometer_Power then
		self.State = 0
		self.EnableDisplay = nil
	end

	if self.State == 1 then

		local ATC = Train.ATC1
		Train:SetNW2Int("C:MFDUSpeedLimit",ATC.SpeedLimit)
		Train:SetNW2Bool("C:MFDUUOS",ATC.UOSP)
		Train:SetNW2Bool("C:MFDUUOSActive",ATC.UOSActive)
		Train:SetNW2Int("C:MFDUSpeed",ATC.Speed)
		Train:SetNW2Bool("C:MFDUBINoFreq",ATC.BINoFreq)
		Train:SetNW2Bool("C:MFDUNextNoFq",ATC.NextNoFq)
		Train:SetNW2Bool("C:MFDUNoFreq",ATC.NoFreq)
		Train:SetNW2Bool("C:MFDULN",ATC.LN)
		Train:SetNW2Bool("C:MFDUBadFq",ATC.BadFq)
		Train:SetNW2Bool("C:MFDUALSFreq",Train.ALSFreq.Value > 0)
		Train:SetNW2Bool("C:MFDUAAO",Train.ALSCoil.AO)
		Train:SetNW2Bool("C:MFDUAKB",ATC.KB)
		Train:SetNW2Bool("C:MFDUAKBUOS",ATC.KBUOS)
		Train:SetNW2Int("C:MFDUSpeedLimitNext",ATC.NextNoFq and -1 or (ATC.NextLimit or 0))
		Train:SetNW2Int("C:MFDU:ATC1",Train.ATC1.Power and (Train.ATC1.Active and (((Train.ATC1.Brake and Train.ATC1.Brake>0) or (Train.ATC1.PN2 > 0.5))  and 1 or (Train.ATC1.Drive>0 and 3 or 2)) or 0) or 0)
		Train:SetNW2Int("C:MFDU:ATC2",Train.ATC2.Power and (Train.ATC2.Active and (((Train.ATC2.Brake and Train.ATC2.Brake>0) or (Train.ATC2.PN2 > 0.5))  and 1 or (Train.ATC2.Drive>0 and 3 or 2)) or 0) or 0)
		Train:SetNW2Bool("C:MFDU:BOSD",Train.Panel.DoorBlock>0)

		local rvOn = Train.RV.KROPosition ~= 0 or Train.RV.KRRPosition ~= 0
		for i = 1, wag_num do
			Train:SetNW2Int('C:MFDU:ID'..i,trains[i]["ID"])
			Train:SetNW2Int('C:MFDU:st'..i,4)
			Train:SetNW2Bool('C:MFDU:Or'..i,trains[i]["Orientation"])
			local emer = (trains[i].BCPressure or 0) >= (trains[i].Pn3Pressure or 2.2) - 0.15
			local ptOn = Train.MFDU and Train.MFDU.MsgRowPT == true and (trains[i].BCPressure or 0) > 0.1
			Train:SetNW2Bool('C:MFDU:EB'..i, rvOn and not trains[i].BUVNotWork and (emer or ptOn))
			if not trains[i].BUVNotWork then
				for d = 1, 8 do
					Train:SetNW2Int('C:MFDU:W'..i..'D'..d,trains[i]["Door"..d.."Closed"] and 4 or trains[i]["Door"..d.."Stack"] and 2 or 1)
				end
			end
		end
		Train:SetNW2Bool('C:MFDU:AutoDep',Train.CIK.AutoD)
		Train:SetNW2Bool('C:MFDU:AutoArr',Train.CIK.AutoA)
		Train:SetNW2Int("C:MFDU:StationSlide",self.StSl)
		if not self.RNEnter and Train.CIK and Train.CIK.Route then
			self.RN = Format("%03d", tonumber(Train.CIK.Route) or 0)
		end
		Train:SetNW2String("C:MFDU:RN",self.RN)
		Train:SetNW2Bool("C:MFDU:RNE",self.RNEnter)
		Train:SetNW2Bool("C:MFDU:RNE2",self.RNEntering)
	end

	if self.Press and CurTime() > (self.PressTimer or 0) then self.Press = nil end
	Train:SetNW2String("C:MFDU:Press", self.Press or "")

	Train:SetNW2Int("Speedometer_State", self.State)
end

if TURBOSTROI then return end

if CLIENT then

	local function createFont(name, font, size, weight)
		surface.CreateFont("Metrostroi_775_"..name, {
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

	createFont("DSFont", "CrystalRevived Normal", 156)

	createFont("App20","Apparat Medium",20)
	createFont("App24","Apparat Medium",24)
	createFont("App29","Apparat Medium",29)
	createFont("App34","Apparat Medium",34)
	createFont("App39","Apparat Medium",39)

	local color_gray = Color(123, 123, 123)
	local color_gray_box = Color(60, 60, 60)

	local scr_w = 2048
	local scr_h = 350


	function TRAIN_SYSTEM:ClientInitialize()
		local images = {
			"speed",
			"sound"
		}

		self.Images = {}

		self.State = 1

		for k, v in pairs(images) do
			local path = "models/metrostroi_train/81-775/mfdu/"
			self.Images[v] = surface.GetTextureID(path .. v)
		end

		self.LastChangeState = CurTime()
		self.LastState = 0

		self.DisplayLight = true
		self.FPSTimer = CurTime()
	end

	local function DrawRBT(x,y,w,h,r,text1,BColor,TColor,fsize,bs,bsr,bColor,text2,ti)
		bs = bs or 0
		bColor = bColor or Color(255,255,255)
		ti = ti or 1
		draw.RoundedBox(r,x,y,w,h,bColor)
		draw.RoundedBox(bsr,x+bs,y+bs,w-bs*2,h-bs*2,BColor)
		if text2 == "" or text2 == nil then
			draw.SimpleText(text1,'Metrostroi_775_App'..fsize,x+w/2,y+h/2,TColor, 1, 1)
		else
			draw.SimpleText(text1,'Metrostroi_775_App'..fsize,x+w/2,y+h/2-h/4+ti,TColor, 1, 1)
			draw.SimpleText(text2,'Metrostroi_775_App'..fsize,x+w/2,y+h/2+h/4-ti,TColor, 1, 1)
		end

	end

	local function drawBox(x, y, w, h, box_color,r,tl,tr,bl,br)
		if tl == nil then
			draw.RoundedBox(r or 0, x, y, w, h, box_color)
		else
			draw.RoundedBoxEx(r or 0,x,y,w,h,box_color,tl,tr,bl,br)
		end
	end

	local function capPoly(xin, y0, wd, h, dir, ry)
		ry = math.min(ry, h/2)
		local function dxAt(t)
			local e = 1
			if t < ry then e = math.sqrt(math.max(0, 1-((ry-t)/ry)^2))
			elseif t > h-ry then e = math.sqrt(math.max(0, 1-((t-(h-ry))/ry)^2)) end
			return wd*e
		end
		local curve = {}
		for t = 0, h, 2 do curve[#curve+1] = {x = xin + dir*dxAt(t), y = y0 + t} end
		if curve[#curve].y < y0 + h then curve[#curve+1] = {x = xin + dir*dxAt(h), y = y0 + h} end
		local poly = {}
		if dir > 0 then
			poly[1] = {x = xin, y = y0}
			for k = 1, #curve do poly[#poly+1] = curve[k] end
			poly[#poly+1] = {x = xin, y = y0 + h}
		else
			poly[1] = {x = xin, y = y0 + h}
			for k = #curve, 1, -1 do poly[#poly+1] = curve[k] end
			poly[#poly+1] = {x = xin, y = y0}
		end
		return poly
	end
	local function drawCabNose(xin, y0, wd, h, dir, col, thick)
		local ry = 28
		draw.NoTexture()
		surface.SetDrawColor(col.r, col.g, col.b, col.a)
		surface.DrawPoly(capPoly(xin, y0, wd, h, dir, ry))
		if thick and thick > 0 then
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawPoly(capPoly(xin - dir, y0 + thick, wd - thick + 1, h - 2*thick, dir, math.max(2, ry - thick)))
		end
	end

	local DoorsStates = {
		[0] = Color(0,0,0),
		[1] = Color(255,0,0),
		[2] = Color(255,255,0),
		[3] = Color(255,255,255),
		[4] = Color(165,165,165),
	}
	local WagColor = Color(131,131,131)
	local WagEmerColor = Color(255,60,60)

	local function DrawWagons(Train,data1,data2)

		local Wagons = Train:GetNW2Int("BKPU_WagNum", 0)

		if Wagons < 1 then return end

		local midlx = 1354/2
		local w = Wagons == 8 and 169 or 193
		local startx = math.floor( Wagons > 6 and 0 or midlx-(w*(Wagons))/2)
		local dx = Wagons > 6 and 0 or 12

		for i = 1, Wagons do
			local wc = Train:GetNW2Bool('C:MFDU:EB'..i) and WagEmerColor or WagColor
			local function DSc(v) if v == 4 then return wc end return DoorsStates[v] end
			if i==1 then
				drawCabNose(startx+20,17,20,110,-1,wc,8)
				drawBox(startx+20,13,w-20,11,	DSc(Train:GetNW2Int('C:MFDU:st'..i,0)))
				drawBox(startx+20,119,w-20,11,	DSc(Train:GetNW2Int('C:MFDU:st'..i,0)))
				drawBox(startx+w-8,13,8,117,	DSc(Train:GetNW2Int('C:MFDU:st'..i,0)))
				drawBox(startx+w-18,36,18,71,	DSc(Train:GetNW2Int('C:MFDU:st'..i,0)),12,true,false,true )
				drawBox(startx+w-9,48,9,47,Color(0,0,0),4,true,false,true)
				drawBox(startx+dx+21,7,130,10,Color(0,0,0),4)
				drawBox(startx+dx+21,127,130,10,Color(0,0,0),4)
				drawBox(startx+dx+23,119,30,8,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D1',0)],2)
				drawBox(startx+dx+55,119,30,8,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D2',0)],2)
				drawBox(startx+dx+87,119,30,8,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D3',0)],2)
				drawBox(startx+dx+119,119,30,8,DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D4',0)],2)
				drawBox(startx+dx+23,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D5',0)],2)
				drawBox(startx+dx+55,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D6',0)],2)
				drawBox(startx+dx+87,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D7',0)],2)
				drawBox(startx+dx+119,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D8',0)],2)
			elseif i < Wagons then
				drawBox(startx+w*(i-1),13,w,11,wc)
				drawBox(startx+w*(i-1),119,w,11,wc)
				drawBox(startx+w*(i-1),13,8,117,wc)
				drawBox(startx+w*(i-1),36,18,71,wc,12,false,true,false,true)
				drawBox(startx+w*(i-1),48,9,47,Color(0,0,0),4,false,true,false,true)
				drawBox(startx+w*i-8,13,8,117,wc)
				drawBox(startx+w*i-18,36,18,71,wc,12,true,false,true)
				drawBox(startx+w*i-9,48,9,47,Color(0,0,0),4,true,false,true)
				drawBox(startx+dx+w*(i-1)+21,7,130,10,Color(0,0,0),4)
				drawBox(startx+dx+w*(i-1)+21,127,130,10,Color(0,0,0),4)
				drawBox(startx+dx+w*(i-1)+23,119,30,8,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D1',0)],2)
				drawBox(startx+dx+w*(i-1)+55,119,30,8,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D2',0)],2)
				drawBox(startx+dx+w*(i-1)+87,119,30,8,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D3',0)],2)
				drawBox(startx+dx+w*(i-1)+119,119,30,8,DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D4',0)],2)
				drawBox(startx+dx+w*(i-1)+23,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D5',0)],2)
				drawBox(startx+dx+w*(i-1)+55,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D6',0)],2)
				drawBox(startx+dx+w*(i-1)+87,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D7',0)],2)
				drawBox(startx+dx+w*(i-1)+119,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D8',0)],2)
			else
				drawCabNose(startx+w*i-20,17,20,110,1,wc,8)
				drawBox(startx+w*(i-1),13,w-20,11,wc)
				drawBox(startx+w*(i-1),119,w-20,11,wc)
				drawBox(startx+w*(i-1),13,7,117,wc)
				drawBox(startx+w*(i-1),36,18,71,wc,12,false,true,false,true)
				drawBox(startx+w*(i-1),48,9,47,Color(0,0,0),4,false,true,false,true)
				drawBox(startx+dx+w*(i-1)+21,7,130,10,Color(0,0,0),4)
				drawBox(startx+dx+w*(i-1)+21,127,130,10,Color(0,0,0),4)
				drawBox(startx+dx+w*(i-1)+23,119,30,8,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D1',0)],2)
				drawBox(startx+dx+w*(i-1)+55,119,30,8,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D2',0)],2)
				drawBox(startx+dx+w*(i-1)+87,119,30,8,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D3',0)],2)
				drawBox(startx+dx+w*(i-1)+119,119,30,8,DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D4',0)],2)
				drawBox(startx+dx+w*(i-1)+23,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D5',0)],2)
				drawBox(startx+dx+w*(i-1)+55,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D6',0)],2)
				drawBox(startx+dx+w*(i-1)+87,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D7',0)],2)
				drawBox(startx+dx+w*(i-1)+119,17,30,7,	DoorsStates[Train:GetNW2Int('C:MFDU:W'..i..'D8',0)],2)
			end
			draw.SimpleText(Train:GetNW2Int('C:MFDU:ID'..i,75000),'Metrostroi_775_App20',startx+w*(i-1)+w/2,13+116/2,Color(200,200,200), 1, 1)
			local orent = Train:GetNW2Bool('C:MFDU:Or'..i)
			draw.SimpleText(orent and "П" or "О",'Metrostroi_775_App20',startx+w*(i-1)+w/2,13+116/1.4,orent and Color(0,255,0) or Color(255,255,0), 1, 1)
		end
		local trainW = w*Wagons
		drawBox(startx,7,trainW,10,Color(0,0,0))
		drawBox(startx,127,trainW,10,Color(0,0,0))
	end

	local function DrawInformator(Train)

		local Line = Train:GetNW2Int("CIK:Line",1)
		local station =	Train:GetNW2Int("CIK:Station",1)
		local stsl = Train:GetNW2Int("C:MFDU:StationSlide",0)
		local RN = Train:GetNW2String("C:MFDU:RN","000")
		local stationsTBL = NWJSON(Train,"CIK:Stations","[]")
		local stations = Metrostroi.ANNOUNCER_MAP_775[Line].stations
		local RNE = Train:GetNW2Bool("C:MFDU:RNE")
		local RNE2 = Train:GetNW2Bool("C:MFDU:RNE2")
		local pressed = Train:GetNW2String("C:MFDU:Press","")
		local function BC(id)
			return pressed == id and Color(0,170,255) or Color(125,125,125)
		end

		if not RNE then
			if station-stsl > 0 and station-stsl < 5 then
				drawBox(0,194+38*(station-1)-38*stsl,439,38,Color(200,200,200))
			end
			local cnt = table.maxn(stationsTBL)
			for i = 1, math.min(4,cnt-1,cnt-stsl-1) do
				local dep = tobool(stsl%2) and (not tobool(i%2)and "отпр." or "") or (tobool(i%2) and "отпр." or "")
				draw.SimpleText(Format("%s %s",stations[stationsTBL[i+1+stsl]].name,dep),'Metrostroi_775_App20',439/2,194+38/2+38*(i-1),color_gray, 1, 1)
			end
		end

		if RNE then
			DrawRBT(0,	142,120,47,8,"",	Color(125,125,125),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(126,142,120,47,8,"1",	BC("k1"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(251,142,120,47,8,"2",	BC("k2"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(376,142,120,47,8,"3",	BC("k3"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(126,194,120,47,8,"4",	BC("k4"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(251,194,120,47,8,"5",	BC("k5"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(376,194,120,47,8,"6",	BC("k6"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(126,247,120,47,8,"7",	BC("k7"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(251,247,120,47,8,"8",	BC("k8"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(376,247,120,47,8,"9",	BC("k9"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(126,300,120,47,8,"C",	BC("kC"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(251,300,120,47,8,"0",	BC("k0"),Color(200,200,200),34,2,8,Color(200,200,200))
			DrawRBT(376,300,120,47,8,"OK",	BC("kA"),Color(200,200,200),34,2,8,Color(200,200,200))
			surface.SetFont("Metrostroi_775_App34")
			local w = surface.GetTextSize(RN)
			if not RNE2 then
				drawBox(34,150,26+w/2+2,30,Color(0,255,255))
			end
			draw.SimpleText(RN,"Metrostroi_775_App34",60,166,RNE2 and Color(0,255,255) or Color(0,0,0),1,1)
			drawBox(62+w/2,150,2,30,Color(0,255,255, math.floor(CurTime()/0.3)%2==0 and 266 or 0))
		else
			local a,d = Train:GetNW2Bool("C:MFDU:AutoArr"),Train:GetNW2Bool("C:MFDU:AutoDep")
			DrawRBT(0,	142,83,47,8,RN,		BC("rn"),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(90,	142,83,47,8,"",		BC("path"),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(179,142,83,47,8,">0<",	BC("zero"),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(267,142,83,47,8,"AUTO",	BC("ad"),Color(200,200,200),24,2,8,Color(200,200,200),"отпр.",4)
			DrawRBT(355,142,83,47,8,"AUTO",	BC("aa"),Color(200,200,200),24,2,8,Color(200,200,200),"приб.",4)
			DrawRBT(444,142,83,47,8,"",		Color(125,125,125),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(532,142,83,47,8,"F1",	Color(125,125,125),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(444,194,83,47,8,"▲",	BC("up"),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(532,194,83,47,8,"F2",	Color(125,125,125),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(444,247,83,47,8,"▼",	BC("down"),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(532,247,83,47,8,"F3",	Color(125,125,125),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(444,300,83,47,8,"Enter",BC("enter"),Color(200,200,200),24,2,8,Color(200,200,200))
			DrawRBT(532,300,83,47,8,"",		Color(125,125,125),Color(200,200,200),24,2,8,Color(200,200,200))
		end
	end

	function TRAIN_SYSTEM:DrawMain(train, state)
		local Train = self.Train

		if not Train:GetNW2Bool("CabActive") then
			draw.SimpleText("НЕАКТИВНАЯ",'Metrostroi_775_Calibri80',scr_w/2-160*2,50*2,color_gray, 1, 1)
			draw.SimpleText("КАБИНА",'Metrostroi_775_Calibri80',scr_w/2-160*2,120*2,color_gray, 1, 1)
		else
			DrawInformator(Train)
			DrawWagons(Train)
		end
	end

	local function DrawRI(x,y,w,h,r,text,type,fsize)
		local bColor = color_gray_box
		local TColor = type == 0 and Color(200,200,200) or Color(0,0,0)
		if type == 1 then
			bColor = Color(255,0,0)
		elseif type == 2 then
			bColor = Color(255,255,0)
		elseif type == 3 then
			bColor = Color(0,255,0)
		elseif type == 4 then
			bColor = Color(255,255,255)
		end
		draw.RoundedBox(r,x,y,w,h,bColor)
		draw.SimpleText(text,'Metrostroi_775_App'..fsize,x+w/2,y+h/2,TColor, 1, 1)

	end

	local function DrawSpeedArc(speed)
		if speed < 1 then return end

		local x0 = 1702
		local y0 = 346
		local r1x = 334-20
		local r1y = 319-20
		local r2x = 334-40
		local r2y = 319-40
		local arc1 = {{x = x0, y = y0}}
		local arc2 = {{x = x0, y = y0}}

		for i = 0, 90 do
			local s = math.pi+(math.pi/90)*i
			local x2 = x0+r2x*math.cos(s)
			local y2 = y0+r2y*math.sin(s)
			table.insert(arc2,{x = x2, y = y2})
			if i <= speed then
				local x1 = x0+r1x*math.cos(s)
				local y1 = y0+r1y*math.sin(s)
				table.insert(arc1,{x = x1, y = y1})
			end
		end
		surface.SetDrawColor(0,255,0,150)
		draw.NoTexture()
		surface.DrawPoly(arc1)
		surface.SetDrawColor(0,0,0)
		surface.DrawPoly(arc2)

	end

	local function DrawSpeedLimitArc(speed)
		if speed > 89 then return end

		local x0 = 1702
		local y0 = 346
		local r1x = 334-20
		local r1y = 319-20
		local r2x = 334-40
		local r2y = 319-40
		local arc1 = {{x = x0, y = y0}}
		local arc2 = {{x = x0, y = y0}}

		for i = 0, 90 do
			local s = math.pi+(math.pi/90)*i
			local x2 = x0+r2x*math.cos(s)
			local y2 = y0+r2y*math.sin(s)
			table.insert(arc2,{x = x2, y = y2})
			if i >= speed then
				local x1 = x0+r1x*math.cos(s)
				local y1 = y0+r1y*math.sin(s)
				table.insert(arc1,{x = x1, y = y1})
			end
		end
		surface.SetDrawColor(255,0,0,150)
		draw.NoTexture()
		surface.DrawPoly(arc1)
		surface.SetDrawColor(0,0,0)
		surface.DrawPoly(arc2)

	end

	local function DrawSpeedLimitNextArc(speed)
		if speed > 89 then return end

		local x0 = 1702
		local y0 = 346
		local r1x = 334
		local r1y = 319
		local r2x = 334-20
		local r2y = 319-20
		local arc1 = {{x = x0, y = y0}}
		local arc2 = {{x = x0, y = y0}}

		for i = 0, 90 do
			local s = math.pi+(math.pi/90)*i
			local x2 = x0+r2x*math.cos(s)
			local y2 = y0+r2y*math.sin(s)
			table.insert(arc2,{x = x2, y = y2})
			if i >= speed then
				local x1 = x0+r1x*math.cos(s)
				local y1 = y0+r1y*math.sin(s)
				table.insert(arc1,{x = x1, y = y1})
			end
		end
		surface.SetDrawColor(255,255,0,150)
		draw.NoTexture()
		surface.DrawPoly(arc1)
		surface.SetDrawColor(0,0,0)
		surface.DrawPoly(arc2)

	end

	local function Draw0Arc()

		local x0 = 1702
		local y0 = 346
		local r1x = 334-47
		local r1y = 319-47
		local arc1 = {{x = x0, y = y0}}

		for i = 0, 90 do
			local s = math.pi+(math.pi/90)*i
			local x1 = x0+r1x*math.cos(s)
			local y1 = y0+r1y*math.sin(s)
			table.insert(arc1,{x = x1, y = y1})
		end
		surface.SetDrawColor(255,0,0,150)
		draw.NoTexture()
		surface.DrawPoly(arc1)

	end

	local function DrawSpeedometer2(Speed,SpeedLimit,SpeedLimitNext,ALSFreq)

		local tt = math.floor(CurTime()/0.8)%2==0
		if ALSFreq and SpeedLimit > 20 then
			DrawSpeedLimitNextArc(SpeedLimitNext)
		end
		DrawSpeedArc(math.min(Speed,SpeedLimit))
		DrawSpeedLimitArc(SpeedLimit)

		if Speed >= SpeedLimit then
			draw.SimpleText(Speed,"Metrostroi_775_DSFont",1700,210,Color(255,0,0),1,1)
		elseif ALSFreq and SpeedLimit > 20 and Speed >= SpeedLimitNext then
			draw.SimpleText(Speed,"Metrostroi_775_DSFont",1700,210, Color(255,255,0),1,1)
		else
			draw.SimpleText(Speed,"Metrostroi_775_DSFont",1700,210, Color(0,255,0),1,1)
		end
		draw.SimpleText("км/ч",'Metrostroi_775_App29',1700,336,Color(255,255,255), 1, 1)

		if SpeedLimit < 21 and tt then
			Draw0Arc()
		end

		local x0 = 1702
		local y0 = 346
		local r1x = 334
		local r1y = 319
		local r2x = 334-52
		local r2y = 319-52
		local r3x = 334-33
		local r3y = 319-33
		local r4x = 334-20
		local r4y = 319-20
		for i = 0, 90 do

			local s = math.pi+(math.pi/90)*i
			local x1 = x0+r1x*math.cos(s)
			local y1 = y0+r1y*math.sin(s)
			local x2 = i%5==0 and (i%10==0 and x0+r2x*math.cos(s) or x0+r3x*math.cos(s)) or x0+r4x*math.cos(s)
			local y2 = i%5==0 and (i%10==0 and y0+r2y*math.sin(s) or y0+r3y*math.sin(s)) or y0+r4y*math.sin(s)
			Metrostroi.DrawLine(x1,y1,x2,y2,Color(255,255,255),2)
		end

	end

	local function DrawSpeedometer1(Train)

		local SpeedLimit = Train:GetNW2Int("C:MFDUSpeedLimit",0)
		local SpeedLimitNext = Train:GetNW2Int("C:MFDUSpeedLimitNext",-1) == 20 and 0 or Train:GetNW2Int("C:MFDUSpeedLimitNext",-1)
		local ALSFreq = Train:GetNW2Bool("C:MFDUALSFreq",false)
		local AO = Train:GetNW2Bool("C:MFDUAAO",false)
		local NF = Train:GetNW2Bool("C:MFDUNoFreq",false)
		local LN = Train:GetNW2Bool("C:MFDULN",false)
		local KB = Train:GetNW2Bool("C:MFDUAKB",false)
		local KBUOS = Train:GetNW2Bool("C:MFDUAKBUOS",false)
		local UOS = Train:GetNW2Bool("C:MFDUUOS",false)
		local UOSA = Train:GetNW2Bool("C:MFDUUOSActive",false)
		local Speed = Train:GetNW2Int("C:MFDUSpeed",0)

		SpeedLimit = SpeedLimit < 21 and KB and 20 or  SpeedLimit > 20 and SpeedLimit or 0

		draw.SimpleText("Режим "..((UOS and UOSA) and "УОС" or (UOS and not UOS) and "" or ALSFreq and  "2/6" or "1/5"),"Metrostroi_775_App29",1723, 18, Color(255,255,255),1,1)


		DrawRI(1447,1,104,37,8,UOS and "УОС" or (not Train:GetNW2Bool("BKPUNotWork") and Train:GetNW2Bool("CabActive")) and "ШТАТ" or"Блокиратор",(not Train:GetNW2Bool("BKPUNotWork") and Train:GetNW2Bool("CabActive")) and 3 or 1,20)
		if UOS then
			local pbc = not KBUOS and RealTime()*3 % 2 < 0.5 and 1 or KBUOS and 3 or 0
			DrawRI(1447,39,87,37,8,"ПБ",pbc,20)
		end

		DrawRI(1359,1,87,37,8,"АРС1",Train:GetNW2Bool("CabActive") and Train:GetNW2Int("C:MFDU:ATC1",0) or 4,20)

		DrawRI(1359,39,87,37,8,"АРС2",Train:GetNW2Bool("CabActive") and Train:GetNW2Int("C:MFDU:ATC2",0) or 4,20)

		DrawRI(1359,77,87,37,8,"БОСД",Train:GetNW2Bool("C:MFDU:BOSD",false) and 1 or 0,20)

		DrawRI(1359,115,58,37,8,"НД",not ALSFreq and 0 or LN and 4 or 1,20)

		DrawRI(1900,	32,	71,57,8,"0",SpeedLimit == 0 and not NF and  1 or 0,39)
		DrawRI(1973,	32,	71,57,8,"АО",AO and 1 or 0,39)
		DrawRI(1973,	91,	71,57,8,"ОЧ",NF and 1 or 0,39)

		DrawSpeedometer2(Speed,SpeedLimit,SpeedLimitNext,ALSFreq)

		local time = Metrostroi.GetSyncTime()
		draw.SimpleText(os.date("!%H:%M:%S",time),"Metrostroi_775_App29",1970, 18, Color(255,255,255),1,1)
	end

	function TRAIN_SYSTEM:DrawLoading(train)
		local time = CurTime() - self.LastChangeState

		self.DisplayLight = false

		if time > 2.2 and time < 2.4 then
			self.DisplayLight = true
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawRect(0, 0, scr_w, scr_h)
		elseif time > 4.4 then
			self.DisplayLight = true
		end
	end

	function TRAIN_SYSTEM:DrawSpeedometer(train)
		local state = train:GetNW2Int("Speedometer_State", 0)

		if state == 1 then
			self:DrawMain(train, state)
			DrawSpeedometer1(train)
		elseif state == 100 then
			self:DrawLoading(train)
		end

		if state ~= 0 and self.DisplayLight then
			surface.SetDrawColor(65,70,95, 5)
			surface.DrawRect(0,0,scr_w+10,scr_h+10)
		end
	end

	function TRAIN_SYSTEM:ClientThink(dT)
		local state = self.Train:GetNW2Int("Speedometer_State", 0)

		if self.LastState ~= state then
			self.LastState = state

			self.LastChangeState = CurTime()
		end

		if not self.Train:ShouldDrawPanel("Speedometer") then return end
		if self.FPSTimer+0.020 > CurTime() then return end
		render.PushRenderTarget(self.Train.Speedometer,0,0,scr_w,scr_h)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			surface.SetDrawColor(0,0,0)
			surface.DrawRect(0,0,scr_w,scr_h)
			self:DrawSpeedometer(self.Train,dT)

		cam.End2D()
		render.PopRenderTarget()
		self.FPSTimer = CurTime()
	end

end
