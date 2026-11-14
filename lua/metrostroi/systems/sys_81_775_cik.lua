Metrostroi.DefineSystem("81_775_CIK")
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
	self.Train:LoadSystem("R_0","Relay","Switch",{bass = true})
	self.Train:LoadSystem("R_GGO","Relay","Switch",{bass = true})
	self.Train:LoadSystem("R_Direction","Relay","Switch",{bass = true})
	self.Train:LoadSystem("R_Enter","Relay","Switch",{bass = true})

	self.DoorAlarm = false
	self.RouteNumber = 0
	self.Selected = 0
	self.FirstStation = 1
	self.Station = 1
	self.LastStation = 3
	self.Line = 1
	self.Path = 1
	self.SFirstStation = 1
	self.SLastStation = 3
	self.SLine = 1
	self.SPath = 1
	self.StationSlide = 0
	self.MsgSel = 0
	self.MenuTab = 1
	self.Menu1Pos = 1
	self.Timer = false
	self.Line = Metrostroi.ASNPSetup and Metrostroi.ASNPSetup[1] and 1 or -2
	self.Reserve = false
	self.Adverts = {}
	self.VolumeCab = 1000
	self.VolumePass = 100
	self.VolumeSalon = 100
	self.State = 0
	self.Page = 1
	self.Route = math.random(1, 99)
	self.TriggerNames = {
		"R_Program1",
		"R_0",
		"R_GGO",
		"R_Direction",
		"R_Enter"
	}
	self.Triggers = {}
	for k,v in pairs(self.TriggerNames) do
		if self.Train[v] then self.Triggers[v] = self.Train[v].Value > 0.5 end
	end
	self.Schedule = {}
	self.Playing = false
	self.OutLine = false
	self.RecordTimer = nil

	self.AutoA = false
	self.AutoD = false
	self.Arrived = false
	self.Depaeted = false
end

function TRAIN_SYSTEM:Inputs()
	return {}
end

function TRAIN_SYSTEM:Outputs()
	return {}
end

if TURBOSTROI then return end

local function Rand(a,b)
	return a+(b-a)*math.random()
end

local MESSAGES = {
	{"Поезд скоро отправится", "C.spec_attention_train_depart"},
	{"Поезд дальше не идёт"},
	{"Побыстрее выходите из вагонов", "C.spec_attention_train_fast"},
}
local MSG_MIN_TIME = 0.5

if SERVER then
	if TURBOSTROI then return end

	function TRAIN_SYSTEM:CANReceive(source,sourceid,target,targetid,textdata,numdata)
		if sourceid == self.Train:GetWagonNumber() then return end
		if textdata == "Route" then
			self.Route = numdata
			self.Train.RouteNumber = {RouteNumber = self.Route}
		end
	end

	function TRAIN_SYSTEM:RouteSetup(CahngePath)
		if CahngePath then
			self.Path = self.Path == 1 and 2 or 1
		else
			self.Line = self.SLine
			self.FirstStation = self.SFirstStation
			self.LastStation = self.SLastStation
			self.Path = self.SPath
		end
		self.Station = 1
		self.StationSlide = 0
		self.Arrived = true
		self.Depaeted = false

		self.Stations = {}
		local map = {}
		for i=1, #Metrostroi.ANNOUNCER_MAP_775[self.Line].stations do
			table.insert(map,i,i)
		end
		if self.Path == 2 then
			map = table.Reverse(map)
		end
		for i=1, #map do
			if i >= self.FirstStation and i <= self.LastStation then
				if i == self.FirstStation then
					table.insert(self.Stations,2,map[i])
				elseif i == self.LastStation then
					table.insert(self.Stations,map[i])
				else
					table.insert(self.Stations,map[i])
					table.insert(self.Stations,map[i])
				end
			end
		end
		self.Train:SetNW2String("CIK:Stations",util.TableToJSON(self.Stations,false))
		self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Line",self.Line)
		self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Path",self.Path)
		self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"First",self.FirstStation)
		self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Last",self.LastStation)
		self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Station",self.Station)
		self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Arrived",self.Arrived)
		self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Depaeted",self.Depaeted)
	end

	local function inrange(posx, posy, x1, y1, x2, y2)
		return posx > x1 and posy > y1 and posx < x2 and posy < y2
	end

	local function GetMaxSlide(self)
		if not self.Stations then return 0 end
		return math.max(0, table.maxn(self.Stations) - 11)
	end

	local function SetSlideFromY(self,y)
		local maxSlide = GetMaxSlide(self)
		if maxSlide <= 0 then self.StationSlide = 0 return end
		local inner = 505-12
		local thumbH = math.max(40, inner*10/(maxSlide+10))
		local frac = (y*2 - 435 - 6 - thumbH/2)/(inner - thumbH)
		self.StationSlide = math.Clamp(math.Round(frac*maxSlide), 0, maxSlide)
	end

	function TRAIN_SYSTEM:Touch(value,x,y)
		if not value then self.SliderDrag = false return end
		if self.State > 1 then
			if inrange(x, y, 20, 4, 160, 56) then
				self.State = 2
			end
			if inrange(x, y, 170, 4, 470, 56) then
				self.State = 3
			end
			if inrange(x, y, 480, 4, 700, 56) then
				self.State = 4
			end
		end
		if self.State == 4 then
			if not self.MsgTimer and inrange(x, y, 0, 105, 840, 105+35*#MESSAGES) then
				local k = math.floor((y-105)/35)+1
				if MESSAGES[k] then self.MsgSel = k end
			end
			if self.MsgSel > 0 and not self.MsgTimer and inrange(x, y, 270, 440, 819, 478) then
				local m = MESSAGES[self.MsgSel]
				local dur = MSG_MIN_TIME
				if m and m[2] then
					local snd = Metrostroi.ANNOUNCER_MAP_775.Sounds[string.sub(m[2],3)]
					if snd and snd[2] then dur = math.max(dur,snd[2]) end
					self:AnnQueue(m[2])
				end
				self.MsgTimer = CurTime() + dur
			end
		end
		if self.State == 2 then
			if inrange(x, y, 417, 174, 795, 507) then
				self.Station = math.floor((y-174)/37)+1+self.StationSlide
			end
			if inrange(x, y, 798, 178, 834, 213) then
				self.StationSlide = math.max(0,self.StationSlide-1)
			end
			if inrange(x, y, 798, 474, 834, 509) then
				self.StationSlide = math.min(GetMaxSlide(self),self.StationSlide+1)
			end
			if inrange(x, y, 798, 217, 834, 471) then
				self.SliderDrag = true
			end
			if self.SliderDrag then
				SetSlideFromY(self,math.Clamp(y,217,471))
			end
		end
		if self.State == 3 then
			if inrange(x, y, 0, 105, 278, 430) then
				local s = math.floor((y-105)/30)+1
				if not Metrostroi.ANNOUNCER_MAP_775[s] then return end
				self.SLine = s
				self.SLastStation = #Metrostroi.ANNOUNCER_MAP_775[self.SLine].stations
			end
			if inrange(x, y, 279, 105, 559, 430) then
				local s = math.floor((y-105)/30)+1
				if self.SLastStation > s then self.SFirstStation = s end
			end
			if inrange(x, y, 560, 105, 840, 430) then
				local s = math.floor((y-105)/30)+1
				if self.SFirstStation < s and s <= #Metrostroi.ANNOUNCER_MAP_775[self.SLine].stations then self.SLastStation = s end
			end
			if inrange(x, y, 4, 434, 127, 486) then
				self.SPath = 1
			end
			if inrange(x, y, 134, 434, 255, 486) then
				self.SPath = 2
			end
			if inrange(x, y, 270, 440, 819, 478) and not self.RecordTimer then
				self:Reset()
				self:RouteSetup()
				self.RecordTimer = CurTime() + 0.5
			end
		end
	end

	function TRAIN_SYSTEM:InitMaps()
		local Maps = {
			["gm_zamoscvorescya_line_do_orehovo"] = 1,
			["gm_metro_kaluzhskaya_line6"] = 2,
			["gm_metro_tkl_v1"] = 3,
			["gm_metro_kalinin_v3"] = 4,
			["gm_metro_mosldl_v1"] = 5,
			["gm_metro_mosldl_v1m"] = 5,
    		["gm_metro_nekrasovskaya_line_v6"] = 6,
		}
		local map = game.GetMap()
		self.SLine = Maps[map] or 7
		self.SFirstStation = 1
		self.SLastStation = table.maxn(Metrostroi.ANNOUNCER_MAP_775[self.SLine].stations)
		self.SPath = 1
		self:RouteSetup()
	end
	function TRAIN_SYSTEM:RemoveMaps()
		self.Line = 1
		self.FirstStation = 1
		self.LastStation = 8
		self.SLine = 1
		self.SFirstStation = 1
		self.SLastStation = 8
	end
	function TRAIN_SYSTEM:SetZero()
		self.Station = 1
		self.Arrived = true
		self.Depaeted = false
		self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Arrived",self.Arrived)
		self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Depaeted",self.Depaeted)
	end

	util.AddNetworkString("metrostroi_announcer_775")

	function TRAIN_SYSTEM:Reset()
		if #self.Schedule > 0 then
			self.Schedule = {}
			self.AnnounceTimer = nil
			self.OutLine = false
		end
		self:WriteMessage("_STOP")
	end
	function TRAIN_SYSTEM:WriteMessage(msg)
		for i = 1, #self.Train.WagonList do
			net.Start("metrostroi_announcer_775", true)
				local train = self.Train.WagonList[i]
				net.WriteEntity(train)
				net.WriteString(msg)
			net.Broadcast()
		end
	end

	function TRAIN_SYSTEM:Queue(tbl)
		if TURBOSTROI then return end
		for k, v in pairs(tbl) do
			local v = string.Explode(".",v)
			if self.OutLine then return end
			local tbl = v[1] == "C" and Metrostroi.ANNOUNCER_MAP_775.Sounds or v[1] == "S" and Metrostroi.ANNOUNCER_MAP_775[self.Line].stations[tonumber(v[2])].snd or false
			if not tbl then goto cont end
			local sndz
			if v[1] == "S" then
				snd = tbl[tonumber(v[3])][tonumber(v[4])]
				self.OutLine = true
			else
				snd = tbl[v[2]]
			end
			if v~=-2 then
				table.insert(self.Schedule, snd)
			else
				self:Reset()
			end
			::cont::
		end
	end

	function TRAIN_SYSTEM:AnnQueue(msg)
		if msg and type(msg) ~= "table" then
			self:Queue{msg}
		else
			self:Queue(msg)
		end
	end

	function TRAIN_SYSTEM:AnnLogic()
		local Train = self.Train
		if #self.Schedule > 0 and not self.Playing then
			for i = 1, #Train.WagonList do
				Train.WagonList[i]:SetNW2Bool("AnnouncerPlaying", true)
			end
			self.Playing = true
		elseif #self.Schedule == 0 and self.Playing and not self.AnnounceTimer then
			for i = 1, #Train.WagonList do
				Train.WagonList[i]:SetNW2Bool("AnnouncerPlaying", false)
			end
			self.Playing = false
		end
		while #self.Schedule > 0 and (not self.AnnounceTimer or CurTime() - self.AnnounceTimer > 0) do
			local tbl = table.remove(self.Schedule, 1)
			self:WriteMessage(tbl[1])
			self.AnnounceTimer = CurTime() + tbl[2]
		end
		if #self.Schedule == 0 and self.AnnounceTimer and CurTime() - self.AnnounceTimer > 0 then
			self.AnnounceTimer = nil
			if self.OutLine then
				self.Station = self.Station < #self.Stations-1 and self.Station + 1 or self.Station
				self.OutLine = false
			end
		end
		if not self.Arrived and self.OutLine and (self.Station)%2 == 0 then
			self.Arrived = true
			self.toArrived = true
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Arrived",self.Arrived)
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Depart123",false)
		end
		if self.Arrived and self.toArrived and not self.OutLine then
			self.toArrived = false
		end
		if self.Arrived and not self.toArrived and self.OutLine and ((self.Station)%2 == 1 or Train.BKPU.DoorsClosed) then
			self.Arrived = false
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Arrived",self.Arrived)

		end
		if not self.Depaeted and self.OutLine and (self.Station)%2 == 1 then
			self.Depaeted = true
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Depaeted",self.Depaeted)
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Depart123",true)
			if not self.DoorCloseSoundPlaying then
            self.DoorCloseSoundPlaying = true
            self.LastDoorSoundTime = CurTime()

        end

    end

		if self.Depaeted and not self.OutLine and ((self.Station)%2 == 1 or Train.BKPU.DoorsClosed) then
			self.Depaeted = false
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Depaeted",self.Depaeted)
		end
		if (not self.OldStation or self.Station ~= self.OldStation) and self.Stations then
			Train.Speedometer.StSl = math.Clamp(self.Station-2,0,math.max(0,table.maxn(self.Stations)-5))
			self.OldStation = self.Station
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Station",self.Station)
		end

		if self.AutoA and Train.Prost_Kos.Prost and Train.Prost_Kos.ProstActive > 0 and (self.Station)%2 == 0 and not self.OutLine and Train.Prost_Kos.dist2 < 10 then
			self:Trigger("R_Program1",true)
		end
		if self.AutoA and (not Train.Prost_Kos.Prost or Train.Prost_Kos.ProstActive == 0) and (self.Station)%2 == 0 and not self.OutLine and ((Train.BKPU.OpenLeft and Train.BKPU.BlockDoorL) or (Train.BKPU.OpenRight and Train.BKPU.BlockDoorR)) and Train.BKPU.DoorsClosed and not self.Arrived then
			self:Trigger("R_Program1",true)
		end
		if self.AutoD and Train.BUV.ACD and (self.Station)%2 == 1 and not self.OutLine and not Train.BKPU.DoorsClosed then
			self:Trigger("R_Program1",true)
		end

	end

	function TRAIN_SYSTEM:Trigger(name,value)
		if self.State > 1 then
			if (name:find("R_Program1")) and value then
				local s = table.concat({"S",self.Stations[self.Station+1],self.Path,(self.Station+1)%2+1},".")
				self:AnnQueue(s)
			end
			if (name:find("R_0")) and value then
				self:SetZero()
			end
			if (name:find("R_Direction")) and value then
				self:RouteSetup(true)
			end
		end
	end

	function TRAIN_SYSTEM:Think(dT)

		local Train = self.Train

		self.Power = Train.SF23.Value*Train.Electric.Power

		local BKPU = Train.BKPU

		if self.Power == 0 and self.State ~= 0 then
			self.RecordTimer = nil
			self:Reset()
			self.State = 0
			self:RemoveMaps()
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Sync",false)
		end
		if self.Power == 1 and self.State == 0 and not self.Timer then
			self.State = -1
			self.Timer = CurTime()+Rand(2.8,3.2)
		end
		if self.State == -1 and CurTime()>self.Timer then
			self.State = -2
			self.Timer = CurTime()+Rand(0.2,0.5)
			self:InitMaps()
		end
		if self.State == -2 and CurTime()>self.Timer then
			self.State = -3
			self.Timer = CurTime()+Rand(4,8)
		end
		if self.State == -3 and CurTime()>self.Timer then
			self.State = 1
			self.Timer = nil
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Sync",true)
		end
		if self.Power == 1 and self.State == 1 and BKPU.Active then
			timer.Simple(0.1,function()
				self.State = 2
				self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Active",true)
				local trains = self.Train.BKPU.Trains
				for k, v in ipairs(trains) do
					self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",v.ID,"Wagon",k+#trains*10)
				end
			end)
		end
		if self.Power == 1 and self.State > 1 and not BKPU.Active then
			self:Reset()
			self.State = 1
			self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"BNT",nil,"Active",false)
		end
		if self.State > 1 then
			for k,v in pairs(self.TriggerNames) do
				if Train[v] and (Train[v].Value > 0.5) ~= self.Triggers[v] then
					self:Trigger(v,Train[v].Value > 0.5)
					self.Triggers[v] = Train[v].Value > 0.5
				end
			end
			self:AnnLogic()
			if not Train.RouteNumber or Train.RouteNumber.RouteNumber ~= self.Route then
				Train.RouteNumber = {RouteNumber = self.Route}
				self.Train:CANWrite("CIK",self.Train:GetWagonNumber(),"CIK",nil,"Route",self.Route)
			end
		end

		if self.RecordTimer and CurTime() >= self.RecordTimer then
			self.RecordTimer = nil
			if self.State == 3 then self.State = 2 end
		end
		Train:SetNW2Bool("CIK:RecordFlash",self.RecordTimer ~= nil)
		Train:SetNW2Int("CIK:Line",self.Line)
		Train:SetNW2Int("CIK:Station",self.Station)
		Train:SetNW2Int("CIK:FirstStation",self.FirstStation)
		Train:SetNW2Int("CIK:LastStation",self.LastStation)
		Train:SetNW2Int("CIK:Path",self.Path)
		Train:SetNW2Int("CIK:SLine",self.SLine)
		Train:SetNW2Int("CIK:SFirstStation",self.SFirstStation)
		Train:SetNW2Int("CIK:SLastStation",self.SLastStation)
		Train:SetNW2Int("CIK:SPath",self.SPath)
		if self.MsgTimer and CurTime() >= self.MsgTimer then
			self.MsgTimer = nil
			self.MsgSel = 0
			if self.State == 4 then self.State = 2 end
		end
		Train:SetNW2Bool("CIK:MsgFlash",self.MsgTimer ~= nil)
		Train:SetNW2Int("CIK:Msg",self.MsgSel)
		Train:SetNW2Int("CIK:StationSlide",self.StationSlide)
		Train:SetNW2Bool("CIK:Power",self.Power)
		Train:SetNW2Int("RouteNumber",self.Route)
		Train:SetNW2Int("CIK:Route",self.Route)

		Train:SetNW2Int("CIK:Page",self.Page)
		Train:SetNW2Int("CIK:State",self.State)

	end

else


	local color_gray = Color(123, 123, 123)

	local scr_w = 1680-5
	local scr_h = 1200-174
	local CIK_RENDER_INTERVAL = 0.03



	function TRAIN_SYSTEM:ClientInitialize()
		self.LastChangeState = CurTime()
		self.LastState = 0

		self.DisplayLight = true
	end
	local function DrawBox(x,y,w,h,color)
		surface.SetDrawColor(color.r,color.g,color.b,color.a)
		surface.DrawRect(x,y,w,h)
	end

	function TRAIN_SYSTEM:DrawNA(Train)
		draw.SimpleText("БЛОК","Metrostroi_775_Calibri150",scr_w/2, scr_h/2-280,color_gray,1,1)
		draw.SimpleText("НЕАКТИВЕН","Metrostroi_775_Calibri150",scr_w/2, scr_h/2-60,color_gray,1,1)
	end
	local function TopBtns(state)
		DrawBox(0,0,scr_w,64+16,Color(0,0,130))
		DrawBox(0,64,scr_w,16,Color(0,0,90))
		DrawBox(0,64+16,scr_w,16,Color(0,0,50))
		draw.SimpleText("Главная","Metrostroi_775_Calibri40",60,60,state == 2 and Color(150,150,0) or Color(200,200,200),0,1)
		draw.SimpleText("Редактор маршрута","Metrostroi_775_Calibri40",370,60,state == 3 and Color(150,150,0) or Color(200,200,200),0,1)
		draw.SimpleText("Сообщения","Metrostroi_775_Calibri40",975,60,state == 4 and Color(150,150,0) or Color(200,200,200),0,1)
		draw.SimpleText("Настройки","Metrostroi_775_Calibri40",1650,60,state == 5 and Color(150,150,0) or Color(200,200,200),2,1)
	end
	local function asps(Train)
		local x = (scr_w-8)/8
		Metrostroi.DrawLine(2,130,		scr_w-3,130,Color(0,150,225),3)
		Metrostroi.DrawLine(2,130+64,	scr_w-3,130+64,Color(0,150,225),3)
		Metrostroi.DrawLine(2,130+128,	scr_w-3,130+128,Color(0,150,225),3)
		for i = 0, 8 do
			if i == 1 or i == 8 then
				Metrostroi.DrawLine(4+x*i-x/2,130,4+x*i-x/2,130+64,Color(0,150,225),3)
			end
			Metrostroi.DrawLine(4+x*i,130,4+x*i,130+128,Color(0,150,225),3)
			local Wagons = Train:GetNW2Int('C:MFDU:ID'..i+1,0)
			draw.SimpleText(Format("%05d",Wagons),"Metrostroi_775_Calibri40",4+x*i+x/2,226,Color(200,200,200),1,1)
		end
	end

	local function MainScr(Train)
		local Train = Train
		local Line = Train:GetNW2Int("CIK:Line",1)
		local station =	Train:GetNW2Int("CIK:Station",1)
		local lss =	Train:GetNW2Int("CIK:LastStation",8)
		local path = Train:GetNW2Int("CIK:Path",1)
		local stsl = Train:GetNW2Int("CIK:StationSlide",0)
		local stationsTBL = NWJSON(Train,"CIK:Stations","[]")
		asps(Train)

		local stations = Metrostroi.ANNOUNCER_MAP_775[Line].stations

		local y = (scr_h-375)/9
		if station-stsl > 0 and station-stsl < 11 then
			DrawBox(scr_w/2,350+y*(station-1)-y*stsl,scr_w/2-84,y,Color(225,225,0))
		end
		local cnt = table.maxn(stationsTBL)
		for i = 1, math.min(10,cnt-1,cnt-stsl-1) do
			local dep = tobool(stsl%2) and (not tobool(i%2)and "отпр." or "") or (tobool(i%2) and "отпр." or "")
			draw.SimpleText(Format("%s %s",stations[stationsTBL[i+1+stsl]].name,dep),"Metrostroi_775_Calibri40",scr_w/2+10,350+y*(i-1)+y/2,Color(255,255,255),0,1)
		end
		DrawBox(0,270,scr_w/2-4,80,Color(0,150,225))
		DrawBox(scr_w/2,270,scr_w/2,80,Color(0,150,225))
		DrawBox(0,550,scr_w/2-4,80,Color(0,150,225))
		DrawBox(0,740,scr_w/2-4,80,Color(0,150,225))
		Metrostroi.DrawRectOutline(2,350,scr_w/2-2,200,Color(0,150,225),4)
		Metrostroi.DrawRectOutline(2,630,scr_w/2-2,110,Color(0,150,225),4)
		Metrostroi.DrawRectOutline(2,820,scr_w/2-2,204,Color(0,150,225),4)
		draw.SimpleText("ЛИНИЯ",			"Metrostroi_775_Calibri40",	scr_w/4,270+40,Color(0,0,0),1,1)
		draw.SimpleText("СТАНЦИЯ",			"Metrostroi_775_Calibri40",	scr_w/1.34,270+40,Color(0,0,0),1,1)
		draw.SimpleText("ПУТЬ",				"Metrostroi_775_Calibri40",	scr_w/4,550+40,Color(0,0,0),1,1)
		draw.SimpleText("СТАНЦИЯ ОБОРОТА",	"Metrostroi_775_Calibri40",	scr_w/4,740+40,Color(0,0,0),1,1)

		draw.SimpleText(Metrostroi.ANNOUNCER_MAP_775[Line].name,"Metrostroi_775_Calibri40",scr_w/2-20,350+100,Color(255,255,255),2,1)
		draw.SimpleText(path,									"Metrostroi_775_Calibri40",scr_w/2-20,630+55,Color(255,255,255),2,1)
		draw.SimpleText(stations[lss].name,						"Metrostroi_775_Calibri40",scr_w/2-20,820+102,Color(255,255,255),2,1)

		Metrostroi.DrawRectOutline(scr_w-80,355,75,75,Color(150,150,150),4)
		Metrostroi.DrawRectOutline(scr_w-80,355+80,75,scr_h-355-160-6,Color(150,150,150),4)
		Metrostroi.DrawRectOutline(scr_w-80,scr_h-80,75,75,Color(150,150,150),4)

		local inner = scr_h-355-160-6-12
		local maxSlide = math.max(0,table.maxn(stationsTBL)-11)
		local thumbH = maxSlide > 0 and math.max(40,inner*10/(maxSlide+10)) or inner
		local frac = maxSlide > 0 and math.Clamp(stsl/maxSlide,0,1) or 0
		DrawBox(scr_w-80+6,355+80+6+(inner-thumbH)*frac,75-12,thumbH,Color(255,255,255))
	end

	local function Msgs(Train)
		local sel = Train:GetNW2Int("CIK:Msg",0)
		DrawBox(0,130,scr_w,80,Color(0,150,225))
		draw.SimpleText("СООБЩЕНИЯ","Metrostroi_775_Calibri40",scr_w/2,170,Color(0,0,0),1,1)
		for k, m in ipairs(MESSAGES) do
			local y = 210+70*(k-1)
			if k == sel then DrawBox(0,y,scr_w,70,Color(225,225,0)) end
			draw.SimpleText(m[1],"Metrostroi_775_Calibri38",20,y+35,k == sel and Color(0,0,0) or Color(255,255,255),0,1)
			DrawBox(0,y+68,scr_w,2,Color(0,150,225))
		end
		Metrostroi.DrawRectOutline(2,210,scr_w-4,70*#MESSAGES,Color(0,150,225),4)
		if sel > 0 then
			local flash = Train:GetNW2Bool("CIK:MsgFlash",false)
			DrawBox(540,880,1100,80,flash and Color(225,225,0) or Color(0,0,130))
			Metrostroi.DrawRectOutline(540,880,1100,80,Color(200,200,200),3)
			draw.SimpleText("ВОСПРОИЗВЕСТИ","Metrostroi_775_Calibri38",540+550,915,flash and Color(0,0,0) or Color(200,200,200),1,1)
		end
	end

	local function RouteEditor(Train)
		local Line = Train:GetNW2Int("CIK:SLine",1)
		local fss =	Train:GetNW2Int("CIK:SFirstStation",1)
		local lss =	Train:GetNW2Int("CIK:SLastStation",8)
		local path = Train:GetNW2Int("CIK:SPath",1)

		DrawBox(0,130,scr_w/3-2,80,Color(0,150,225))
		DrawBox(scr_w/3+2,130,scr_w/3-2,80,Color(0,150,225))
		DrawBox(scr_w/1.5+5,130,scr_w/3-2,80,Color(0,150,225))
		draw.SimpleText("ЛИНИЯ","Metrostroi_775_Calibri35",scr_w/3/2,170,Color(0,0,0),1,1)
		draw.SimpleText("НАЧАЛО МАРШРУТА","Metrostroi_775_Calibri35",scr_w/2,170,Color(0,0,0),1,1)
		draw.SimpleText("СТАНЦИЯ ОБОРОТА","Metrostroi_775_Calibri35",scr_w/1.2,170,Color(0,0,0),1,1)
		DrawBox(0,210+60*(Line-1),scr_w/3,60,Color(225,225,0))
		DrawBox(scr_w/3,210+60*(fss-1),scr_w/3,60,Color(225,225,0))
		DrawBox(scr_w/1.5+2,210+60*(lss-1),scr_w/3,60,Color(225,225,0))
		Metrostroi.DrawLine(scr_w/3,210,scr_w/3,210+650,Color(0,150,225),4)
		Metrostroi.DrawLine(scr_w/1.5+3,210,scr_w/1.5+3,210+650,Color(0,150,225),4)

		for k, v in pairs(Metrostroi.ANNOUNCER_MAP_775) do
			if type(k) ~= "number" then goto cont2 end
			draw.SimpleText(v.name,"Metrostroi_775_Calibri38",10,235+60*(k-1),k == Line and Color(0,0,0) or Color(255,255,255),0,1)
			::cont2::
		end

		local stations = path == 2 and table.Reverse(Metrostroi.ANNOUNCER_MAP_775[Line].stations) or Metrostroi.ANNOUNCER_MAP_775[Line].stations

		for k, v in pairs(stations) do
			draw.SimpleText(v.name,"Metrostroi_775_Calibri38",scr_w/3+10,235+60*(k-1),k == fss and Color(0,0,0) or Color(255,255,255),0,1)
		end

		for k, v in pairs(stations) do
			draw.SimpleText(v.name,"Metrostroi_775_Calibri38",scr_w/1.5+10,235+60*(k-1),k == lss and Color(0,0,0) or Color(255,255,255),0,1)
		end

		DrawBox(10,870,240,100,path == 1 and Color(0,150,225) or Color(150,150,150))
		DrawBox(270,870,240,100,path == 2 and Color(0,150,225) or Color(150,150,150))
		draw.SimpleText("ПУТЬ 1","Metrostroi_775_Calibri38",10,870+45,Color(0,0,0),0,1)
		draw.SimpleText("ПУТЬ 2","Metrostroi_775_Calibri38",270,870+45,Color(0,0,0),0,1)
		local flash = Train:GetNW2Bool("CIK:RecordFlash",false)
		DrawBox(540,880,1100,80,flash and Color(225,225,0) or Color(0,0,130))
		Metrostroi.DrawRectOutline(540,880,1100,80,Color(200,200,200),3)
		draw.SimpleText("ЗАПИСЬ","Metrostroi_775_Calibri38",540+550,915,flash and Color(0,0,0) or Color(200,200,200),1,1)
	end

	function TRAIN_SYSTEM:ClientThink(dT)
		local state = self.Train:GetNW2Int("CIK_State", 0)
		if self.LastState ~= state then
			self.LastState = state

			self.LastChangeState = CurTime()
		end

		if not self.Train:ShouldDrawPanel("CIK") then return end
		local currentTime = CurTime()
		if self.LastRenderTime and currentTime - self.LastRenderTime < CIK_RENDER_INTERVAL then return end
		self.LastRenderTime = currentTime
		render.PushRenderTarget(self.Train.CIK,0,0,2048,1024)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()

			surface.SetDrawColor(0,0,0)
			surface.DrawRect(0,0,scr_w,scr_h)
			self:CIKMonitor(self.Train,dT)

		cam.End2D()
		render.PopRenderTarget()
	end

	function TRAIN_SYSTEM:CIKMonitor(Train,dt)
		local state = Train:GetNW2Int("CIK:State",0)
		local page = Train:GetNW2Int("CIK:Page",1)
		if state ~= 0 then
			draw.RoundedBox(0,0,0,scr_w,scr_h,state == -2 and Color(255, 255, 255, 255) or Color(65,70,95, 5))
		end

		if state == 1 then
			draw.SimpleText("НЕАКТИВНАЯ","Metrostroi_775_Calibri255",scr_w/2,scr_h/2-100,Color(255,255,255),1,1)
			draw.SimpleText("КАБИНА","Metrostroi_775_Calibri255",scr_w/2,scr_h/2+100,Color(255,255,255),1,1)
		end
		if state > 1 then
			TopBtns(state)
		end
		if state == 2 then
			MainScr(Train)
		end
		if state == 3 then
			RouteEditor(Train)
		end
		if state == 4 then
			Msgs(Train)
		end
		if state == 5 then
			if page == 1 then
				SoundSet(Train)
			end
			if page == 5 then
				Service(Train)
			end
			LowerBtns(page)
		end
	end

	net.Receive("metrostroi_announcer", function(len, pl)
		local train = net.ReadEntity()
		if not IsValid(train) or not train.RenderClientEnts then return end
		local snd = net.ReadString()

		if train.AnnouncerPositions then
			for k, v in ipairs(train.AnnouncerPositions) do
				train:PlayOnceFromPos("announcer" .. k, snd, v[3] or 1, 1, v[2] or 400, 1e9, v[1])
			end
		else
			train:PlayOnceFromPos("announcer", snd, 1, 1, 600, 1e9, Vector(0, 0, 0))
		end
	end)
end
