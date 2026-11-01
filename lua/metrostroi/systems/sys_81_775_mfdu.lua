Metrostroi.DefineSystem("81_775_MFDU")
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

function TRAIN_SYSTEM:Outputs()
	return {
		"State",
		"Initialized",
		}
end


function TRAIN_SYSTEM:Initialize()
	self.State = 0
	self.State2 = 0
	self.Window = 0
	self.StateDepot = 0
	self.CondLeto = true
	self.RecupEnabled = true
	self.StorageEnabled = false

	self.Password = "7777"
	self.CurrentPassword = "7777"
	self.MapPassword = "21012"
	self.MapCurrentPassword = ""

	self.PasswordSelected = false
	self.PasswordStartType = false

	self.Errors = {}
	self.Log = {}
	self.JNew = 0
	self.JTop = 1
	self.JSel = 1
	self.ErrorTimers = {}

	self.DoorsClosedMFDU = true

	self.Prost = true
	self.Kos = true

	self.CardInserted = false
    self.PrevReverserState = false

	self.LastThinkTime = 0
	self.ThinkInterval = 0
	self.DataCache = {}
	self.LastWindow = -1

end

if TURBOSTROI then return end

local JMAX = 500
local function JInit(self)
	local T = self.Train
	local S = T.MFDUJStore
	if not S then S = {J = {}, A = {}} T.MFDUJStore = S end
	if self.Journal ~= S.J then
		self.Journal = S.J
		self.JActive = S.A
	end
	self.JNew = self.JNew or 0
	self.JTop = self.JTop or 1
	self.JSel = self.JSel or 1
end
local function JSkip(text)
	return string.find(text, "Двери не закрыты", 1, true) == 1
end

TRAIN_SYSTEM.ErrorsTbl = {
	[1] = {	"Сбой РВ",						1	},
}

TRAIN_SYSTEM.ErrorsHelp = {
	[1] = "Ты ебобо",
}

if SERVER then
	function TRAIN_SYSTEM:GetError(ID)
		if not ID then return false end
		for k, v in ipairs(self.Errors) do
			if v[1] == ID then
				return k
			end
		end
		return false
	end

	function TRAIN_SYSTEM:Error(ErrID,WagID,status)
		local err = self:GetError(ErrID)
		if not err then
			local logID = table.insert(self.Log,{ErrID,WagID,Metrostroi.GetSyncTime()})
			self.Errors[ErrID] = {logID}
			local Wagons = type(WagID) == "table" and table.concat(WagID,", ") or type(WagID) == "number" and WagID or 1
			table.insert(self.Errors,1,{ErrID,logID,Wagons})
		end
	end
end

local function inrange(posx, posy, x1, y1, x2, y2)
	return posx > x1 and posy > y1 and posx < x2 and posy < y2
end

function TRAIN_SYSTEM:TTS(state,time)
	if not self.toState then
		self.toState = {state,time}
	elseif self.State == state then
		self.toState = nil
	end
end

local keyboard = {
	{"1","2","3"},
	{"4","5","6"},
	{"7","8","9"},
	{"C","0","OK"},
}

function TRAIN_SYSTEM:Touch(value, x, y)
    if not value then return end

    local state = self.State

    if state == 1.5 and inrange(x, y, 270, 160, 525, 470) then
        if self.Initialized then
            self:TTS(4,0.2)
        else
            self.CurrentPassword = "7777"
            self.PasswordSelected = false
            self.PasswordStartType = false
            self:TTS(2,0.2)
        end
    end

	if state == 2 then
		local action = ""
		local butt_size = 150/2
		local sy = 300 - (butt_size+14)*2

		for iy = 1, 4 do
			for ix = 1, 3 do
				local pos_x, pos_y = 490 + (ix-1) * (butt_size+14), sy + (iy-1) * (butt_size+14)
				if inrange(x, y, pos_x, pos_y, pos_x+butt_size, pos_y+butt_size) then
					action = keyboard[iy][ix]
				end
			end
		end

		if action == "OK" then
			if self.CurrentPassword == self.Password then
				self:TTS(3,0.5)
				self.StateDepot = 0
				self.Initialized = true
				return
			end
		end

		local new_pass = self.CurrentPassword

		if action == "X" then
			local RR = (Train.RV and (Train.RV.KROPosition ~= 0 or Train.RV.KRRPosition ~= 0)) or false
			self:TTS(RR and 1.5 or 1,0)
			return
		end

		if self.PasswordStartType and action ~= "" then
			if tonumber(action) then
				if self.PasswordSelected then
					new_pass = action
				else
					new_pass = new_pass .. action
				end
			end

			if action == "C" then
				new_pass = ""
			end

			self.PasswordSelected = false
		end

		if inrange(x, y, 150, 135, 240, 160) and not self.PasswordStartType then
			self.PasswordSelected = true
			self.PasswordStartType = true
		end

		new_pass = new_pass:sub(1, 4)
		self.CurrentPassword = new_pass
	end

	if state == 3 then
		if self.StateDepot ~= 2 and self.StateDepot < 7 then
			if inrange(x, y, 2, 62, 600, 473) and ((y-62))%69 < 65 and ((y-62))%69 > 0 then
				if (math.floor((y-62)/69)+1) == 6 and self.StateDepot ~= 6 then
					self.MapCurrentPassword = ""
				end
				self.StateDepot = math.floor((y-62)/69)+1
			end
			if self.StateDepot < 6 and inrange(x, y, 700, 533, 798, 553+63)then
				self.Window = 0
				self:TTS(4,0.5)
			end
			if self.StateDepot == 1 and inrange(x, y, 608, 62, 796, 130) then
				if (math.floor((x-608)/62)) == 1 then
					self.StateDepot = 0
				end
			end
			if self.StateDepot == 6 then
				if inrange(x, y, 2, 533, 798, 553+63) then
					local c = math.floor((x-2)/66)+1
					local new_pass = self.MapCurrentPassword
					if c < 11 then
						c = c == 10 and "0" or tostring(c)
						new_pass = new_pass..c
					elseif c == 11 then
						new_pass = new_pass:sub(1, #new_pass-1)
					elseif c == 12 then
						if #new_pass == 5 and new_pass == self.MapPassword then
							self.StateDepot = 7
						else
							self.StateDepot = 0
						end
					end
					new_pass = new_pass:sub(1, 5)
					self.MapCurrentPassword = new_pass
				end
			end
		else
			if inrange(x, y, 700, 533, 798, 553+63) then
				self.StateDepot = 0
			end
		end
	end

	if state == 4 then
		if self.VTBDialog then
			if inrange(x, y, 166, 260, 296, 380) then
				if self.Train.BTBU then self.Train.BTBU:ConfirmBlock() end
				self.VTBDialog = false
				self.Train:SetNW2Bool("MFDU:VTBDialog", false)
			elseif inrange(x, y, 498, 260, 628, 380) then
				self.VTBDismissed = true
				self.VTBDialog = false
				self.Train:SetNW2Bool("MFDU:VTBDialog", false)
			end
			return
		end
		local state2 = self.State2
		if state2 ~= 1 and (self.MsgCount or 0) > 1 then
			local idx = self.MsgIdx or 1
			if inrange(x, y, 150, 484, 184, 515) then
				idx = math.max(1, idx-1)
			elseif inrange(x, y, 150, 516, 184, 547) then
				idx = math.min(self.MsgCount, idx+1)
			end
			if idx ~= (self.MsgIdx or 1) then
				self.MsgIdx = idx
				self.Train:SetNW2Int("MFDU:MsgIdx", idx)
			end
		end
		if self.Window == 81 then
			JInit(self)
			local n = #self.Journal
			local sel = math.Clamp(self.JSel or 1, 1, math.max(1,n))
			local top = self.JTop or 1
			if inrange(x, y, 0, 540, 80, 600) then sel = 1
			elseif inrange(x, y, 80, 540, 160, 600) then sel = n
			elseif inrange(x, y, 320, 540, 400, 600) then sel = sel - 1
			elseif inrange(x, y, 400, 540, 480, 600) then sel = sel + 1 end
			sel = math.Clamp(sel, 1, math.max(1,n))
			if sel < top then top = sel elseif sel > top + 17 then top = sel - 17 end
			self.JSel = sel
			self.JTop = math.Clamp(top, 1, math.max(1, n-17))
		end
		if state2 == 0 then
			local offset = 80
			for i = 1,9 do
				if i == 1 and self.Window > 10 and self.Window < 20 then
					if inrange(x, y, -80+i*offset, 548, 0+i*offset-offset/2, 600) then
						self.Window = self.Window < 16 and self.Window +1 or 11
					end
					if inrange(x, y, -80+i*offset+offset/2, 548, 0+i*offset, 600) then
						self.Window = self.Window > 11 and self.Window -1 or 16
					end
				else
					if inrange(x, y, -80+i*offset, 548, 0+i*offset, 600) then
						if (self.Window == 51 and i == 5) or (self.Window == 61 and i == 6) or (self.Window == 71 and i == 7) then
							self.Window = self.Window+1
						else
							self.Window = i*10+1
						end
					end
				end
			end
			if self.Window == 0 and (inrange(x, y, 207, 85, 337, 152) or inrange(x, y, 621, 462, 659, 500)) then
				local BKPU = self.Train.BKPU
				if BKPU.Active and self.Train.RV.KRRPosition == 0 then
					if BKPU.SlopeEnabled then
						BKPU.SlopeEnabled = false
					elseif math.max(self.Train.ATC1.Speed or 0, self.Train.Speed or 0) <= 2 then
						BKPU.SlopeEnabled = true
					end
				end
			end
			if self.Window == 31 and inrange(x, y, 600, 103, 725, 166) then
				self.RecupEnabled = not self.RecupEnabled
				self.Train:SetNW2Bool("MFDU:Recup", self.RecupEnabled)
			end
			if self.Window == 31 and self.StorageAvail == true and inrange(x, y, 598, 166, 730, 232) then
				self.StorageEnabled = not self.StorageEnabled
				self.Train:SetNW2Bool("MFDU:Storage", self.StorageEnabled)
			end
			if self.Window == 61 and inrange(x, y, 280, 362, 565, 400) then
				self.CondLeto = not (self.CondLeto ~= false)
				self.Train:SetNW2Bool("MFDU:CondLeto", self.CondLeto)
			end
			if self.Window == 71 then
				if inrange(x, y, 330, 297, 453, 354) then self.Kos = false end
				if inrange(x, y, 460, 297, 583, 354) then self.Kos = true end
				if inrange(x, y, 330, 363, 453, 420) then self.Prost = false end
				if inrange(x, y, 460, 363, 583, 420) then self.Prost = true end
			end
			if self.Window ~= 1 and inrange(x, y, 729, 386, 796, 433) then
				self.Window = 1
			end
			if self.Window == 1 and inrange(x, y, 67, 75, 724, 430) then
				local BKPU = self.Train.BKPU
				if x-67 < #BKPU.Trains*82 and (x-67)%82 > 2 and (x-67)%82 < 80 and (y-75)%51 > 1 and (y-75)%51 < 49 then
					local pvu = BKPU.PVU[math.floor((x-67)/82)+1][math.floor((y-75)/51)+1]
					BKPU.PVU[math.floor((x-67)/82)+1][math.floor((y-75)/51)+1] = not pvu
				end
			end
		end
		if self.Window < 90 and inrange(x, y, -80+10*80, 548, 0+10*80, 600) then
			self.Window = 0
		elseif self.Window > 90 then
			local offset = 80
			for i = 0,9 do
				if inrange(x, y, offset*i+1, 550, offset*i+1+offset, 600) then
					if i < 9 then
						self.Window = 91+i
					else
						self.Window = 0
					end
				end
			end
		end
	end
end

local function GetInfo(train,data,a,b)
	return train.BUVNotWork and 0 or (type(train[data]) == "boolean" and (train[data] and a or b) or train[data] or 0)
end

local function AsmState(t)
	return t.BUVNotWork and 0 or ((t.AsyncAssembly == true and t.AsyncEDone ~= true) and 2 or 1)
end

local function WP(a,b,c,d)
	local s = b and 0 or 1000
	if c[a] ~= nil and c[a][d] ~= nil then
		s = c[a][d] or c[a+1][d] or c[a-1][d]
	end
	return s
end

function TRAIN_SYSTEM:UpdateWindowData(window, Train, wag_num, trains)
	if window == 11 then
		for i = 1, wag_num do
			local t = trains[i]
			local nolink = t.BUVNotWork
			local function G(ok) return nolink and 0 or (ok and 2 or 1) end
			Train:SetNW2Int('MFDU:11:'..i..':BUKS',G(true))
			Train:SetNW2Int('MFDU:11:'..i..':MK',t.WagType == 2 and 3 or nolink and 0 or t.PSN and (t.MKCur and 2 or t.MKCmd and 1 or 3) or 1)
			Train:SetNW2Int('MFDU:11:'..i..':Lights',G(not t.PVU3))
			Train:SetNW2Int('MFDU:11:'..i..':TKPR',G(not t.TRDown))
			Train:SetNW2Int('MFDU:11:'..i..':UKS',G((t.HighVoltageMin or 0) > 550))
			Train:SetNW2Int('MFDU:11:'..i..':PSN',G(t.PSN))
			Train:SetNW2Int('MFDU:11:'..i..':Res',G(true))
			Train:SetNW2Int('MFDU:11:'..i..':BUPU',G(true))
			Train:SetNW2Int('MFDU:11:'..i..':BUD',G(true))
			Train:SetNW2Int('MFDU:11:'..i..':AKB',G((t.LowVoltage or 0) > 30))
		end
	elseif window == 12 or window == 15 then
		for i = 1, wag_num do
			local v = trains[i].BUVNotWork and 0 or 2
			for k = 1, 8 do
				Train:SetNW2Int('MFDU:'..window..':'..i..':'..k,v)
			end
		end
	elseif window == 13 then
		for i = 1, wag_num do
			local t = trains[i]
			if t.BUVNotWork then
				for k = 1, 8 do Train:SetNW2Int('MFDU:13:'..i..':'..k,0) end
				goto dpbt_next
			end
			Train:SetNW2Int('MFDU:13:'..i..':1',t.DPBT1 and 2 or 1)
			Train:SetNW2Int('MFDU:13:'..i..':2',t.DPBT2 and 2 or 1)
			Train:SetNW2Int('MFDU:13:'..i..':3',t.DPBT3 and 2 or 1)
			Train:SetNW2Int('MFDU:13:'..i..':4',t.DPBT4 and 2 or 1)
			Train:SetNW2Int('MFDU:13:'..i..':5',t.DPBT5 and 2 or 1)
			Train:SetNW2Int('MFDU:13:'..i..':6',t.DPBT6 and 2 or 1)
			Train:SetNW2Int('MFDU:13:'..i..':7',t.DPBT7 and 2 or 1)
			Train:SetNW2Int('MFDU:13:'..i..':8',t.DPBT8 and 2 or 1)
			::dpbt_next::
		end
	elseif window == 14 then
		for i = 1, wag_num do
			local v = trains[i].BUVNotWork and 0 or (trains[i].TRDown and 1 or 2)
			for k = 1, 4 do Train:SetNW2Int('MFDU:14:'..i..':'..k,v) end
		end
	elseif window == 16 then
		for i = 1, wag_num do
			if i == 1 then
				for k = 1,9 do
					Train:SetNW2Int('MFDU:16:0:'..k,GetInfo(trains[i],"SF0"..k))
				end
			end
			for k = 1,11 do
				Train:SetNW2Int('MFDU:16:'..i..':'..k,GetInfo(trains[i],"SF"..k))
			end
		end
	elseif window == 21 then
		local doorsclosed = true
		for i = 1, wag_num do
			if not trains[i].BUVNotWork then
				if trains[i].WagType == 0 then
					Train:SetNW2Int('MFDU:21:'..i..':1',trains[i].DoorCabLeft and 1 or 4)
					Train:SetNW2Int('MFDU:21:'..i..':6',trains[i].DoorCabPass and 1 or 4)
					Train:SetNW2Int('MFDU:21:'..i..':11',trains[i].DoorCabRight and 1 or 4)
				end
				for d = 1, 8 do
					Train:SetNW2Int('MFDU:21:'..i..':'..(d<5 and d+1 or d+2),trains[i]["Door"..d.."Aod"] == true and 5 or trains[i]["Door"..d.."Reverse"] == true and 2 or trains[i]["Door"..d.."Closed"] and 4 or trains[i]["Door"..d.."Stack"] and 2 or 1)
				end
			end
			doorsclosed = doorsclosed and trains[i]["DoorsClosed"]
		end
		if doorsclosed and self.AutoW21 and self.AutoW21+2 < CurTime() then
			self.Window = 0
			self.AutoW21 = nil
		end
	elseif window == 31 then
		local data = {}
		local now = CurTime()
		self.TPTimers = self.TPTimers or {}
		for i = 1, wag_num do
			if trains[i]["WagType"] < 2 then
				local tm = self.TPTimers[i]
				if not tm then tm = {} self.TPTimers[i] = tm end
				local asmState = AsmState(trains[i])
				if trains[i].AsyncEFault == true then
					tm.et = tm.et or now
				else
					tm.et = nil
				end
				local etState = trains[i].BUVNotWork and 0 or ((tm.et and now - tm.et >= 1) and 1 or 2)
				data[i] = {
					asmState,
					GetInfo(trains[i],"BVState",2,1),
					GetInfo(trains[i],"AsyncFail",1,2),
					GetInfo(trains[i],"AsyncProtection",1,2),
					trains[i].BUVNotWork and 0 or 2,
					etState,
					trains[i]["DTorque"]*10,
					trains[i]["BTorque"]*10,
					trains[i]["HighVoltageMin"]>550 and 1 or 0,
				}
			end
		end
		data['r'] = 0
		data['n'] = 0
		data['p'] = 0
		data['g'] = 0
		Train:SetNW2String("MFDU_P31D",util.TableToJSON(data,false))
	elseif window == 41 then
		for i = 1, wag_num do
			local t = trains[i]
			Train:SetNW2Int('MFDU:41:'..i..':UKS',t.HighVoltageMin)
			Train:SetNW2Int('MFDU:41:'..i..':UBS',t.LowVoltage)
			Train:SetNW2Int('MFDU:41:'..i..':UZU',t.LowVoltage)
			local imk = 0
			if t.MKCur and not t.BUVNotWork then
				local ct = CurTime()
				imk = math.Clamp(math.Round(13.5 + 1.0*math.sin(ct*3.1+i*2.1) + 0.5*math.sin(ct*7.3+i*0.9)),12,15)
			end
			Train:SetNW2Int('MFDU:41:'..i..':IMK',imk)
			Train:SetNW2Int('MFDU:41:'..i..':ITP',t.Current)
			Train:SetNW2Int('MFDU:41:'..i..':IZU',0)
			Train:SetNW2Int('MFDU:41:'..i..':IVO',0)
			Train:SetNW2Int('MFDU:41:'..i..':IAKB',0)
			Train:SetNW2Int('MFDU:41:'..i..':UAKB',t.LowVoltage)
			Train:SetNW2Int('MFDU:41:'..i..':UADUV',0)
		end
	elseif window == 51 then
		for i = 1, wag_num do
			local t = trains[i]
			Train:SetNW2Int('MFDU:51:'..i..':Emer',t.BUVNotWork and 0 or (t.BCPressure or 0)>2.2 and 1 or 2)
			Train:SetNW2Int('MFDU:51:'..i..':PT',t.BUVNotWork and 0 or (t.BCPressure or 0)>0.1 and 1 or 2)
			Train:SetNW2Int('MFDU:51:'..i..':PB',GetInfo(t,"ParkingBrakeApply",1,2))
			Train:SetNW2Int('MFDU:51:'..i..':DPBT',GetInfo(t,"DPBT1",2,1))
			Train:SetNW2Int('MFDU:51:'..i..':SK',t.SKPressure > 0 and 2 or 1)
			Train:SetNW2Int('MFDU:51:'..i..':TO',0)
			Train:SetNW2Int('MFDU:51:'..i..':BCp',(t.BCPressure or 0)*10)
			Train:SetNW2Int('MFDU:51:'..i..':TLp',t.TLPressure*10)
			Train:SetNW2Int('MFDU:51:'..i..':BLp',t.BLPressure*10)
			Train:SetNW2Int('MFDU:51:'..i..':PBp',t.PBPressure*10)
			Train:SetNW2Int('MFDU:51:'..i..':SKp',t.SKPressure*10)
		end
	elseif window == 52 then
		for i = 1, wag_num do
			local t = trains[i]
			Train:SetNW2Int('MFDU:52:'..i..':R1',0)
			Train:SetNW2Int('MFDU:52:'..i..':R2',0)
			Train:SetNW2Int('MFDU:52:'..i..':R3',0)
			Train:SetNW2Int('MFDU:52:'..i..':R4',0)
			Train:SetNW2Int('MFDU:52:'..i..':WL',t.WeightLoad*100)
		end
	elseif window == 61 or window == 62 then
		local anyCool, anyHeat, anyOn, out = false, false, false, nil
		for i = 1, wag_num do
			local t = trains[i]
			local nw = t.BUVNotWork
			local function C(v) return nw and 0 or (v and 2 or 1) end
			local head = t.WagType == 0
			if window == 61 then
				Train:SetNW2Int('MFDU:61:'..i..':1',C(t.Cond1))
				Train:SetNW2Int('MFDU:61:'..i..':2',C(t.Cond2))
				Train:SetNW2Int('MFDU:61:'..i..':3',head and C(t.CondK) or 0)
				local function T(v) return (nw or v == nil) and -999 or math.floor(v + 0.5) end
				Train:SetNW2Int('MFDU:61:'..i..':4',head and T(t.TCab) or -999)
				Train:SetNW2Int('MFDU:61:'..i..':5',head and T(t.TCabSet) or -999)
				Train:SetNW2Int('MFDU:61:'..i..':6',T(t.TSalon))
				Train:SetNW2Int('MFDU:61:'..i..':7',T(t.TSalonSet))
			else
				local lt = t.CondLetoMode
				local pw = t.Cond1
				Train:SetNW2Int('MFDU:62:'..i..':1',C(lt))
				Train:SetNW2Int('MFDU:62:'..i..':2',C(pw and t.CondVent))
				Train:SetNW2Int('MFDU:62:'..i..':3',C(pw and t.CondHeat))
				Train:SetNW2Int('MFDU:62:'..i..':4',C(pw and t.CondCool))
				Train:SetNW2Int('MFDU:62:'..i..':5',C(true))
				Train:SetNW2Int('MFDU:62:'..i..':6',C(true))
				Train:SetNW2Int('MFDU:62:'..i..':7',C(true))
				Train:SetNW2Int('MFDU:62:'..i..':8',C(true))
				Train:SetNW2Int('MFDU:62:'..i..':9',C(t.SalonLight ~= false))
				Train:SetNW2Int('MFDU:62:'..i..':10',head and C(true) or 0)
			end
			if not nw then
				if t.CondCool then anyCool = true end
				if t.CondHeat then anyHeat = true end
				if t.Cond1 then anyOn = true end
				out = out or t.OutTemp
			end
		end
		Train:SetNW2Int('MFDU:61:Act', anyCool and 2 or anyHeat and 3 or anyOn and 1 or 0)
		Train:SetNW2Int('MFDU:61:Out', out and math.floor(out + 0.5) or -999)
	elseif window == 71 then
		Train:SetNW2Bool('MFDU:71:0',true)
		Train:SetNW2Bool('MFDU:71:1',false)
		Train:SetNW2Bool('MFDU:71:2',self.Kos)
		Train:SetNW2Bool('MFDU:71:3',self.Prost)
	elseif window == 1 then
		for i = 1, wag_num do
			local t = trains[i]
			Train:SetNW2Int('MFDU:1:'..i..':1',t["PVU1"] and 3 or 0)
			Train:SetNW2Int('MFDU:1:'..i..':2',t["PVU2"] and 3 or 0)
			Train:SetNW2Int('MFDU:1:'..i..':3',t["PVU3"] and 3 or 0)
			Train:SetNW2Int('MFDU:1:'..i..':4',t["PVU4"] and 3 or 0)
			Train:SetNW2Int('MFDU:1:'..i..':5',t["PVU5"] and 3 or 0)
			Train:SetNW2Int('MFDU:1:'..i..':6',t["PVU6"] and 3 or 0)
			Train:SetNW2Int('MFDU:1:'..i..':7',t["PVU7"] and 3 or 0)
		end
	end
end

function TRAIN_SYSTEM:Think(dT)
    local Train = self.Train
    local currentTime = CurTime()

    self.MFDUTimer = self.MFDUTimer or 0

    if currentTime - self.LastThinkTime < self.ThinkInterval then
        return
    end
    self.LastThinkTime = currentTime

    local BKPU = Train.BKPU
    local trains = BKPU and BKPU.Trains or {}
    local wag_num = #trains

    local MFDU_Power = (Train.Electric and Train.Electric.Power or 0) * (Train.SF6 and Train.SF6.Value or 0) > 0.5
    local RR = (Train.RV and (Train.RV.KROPosition ~= 0 or Train.RV.KRRPosition ~= 0)) or false

    if not MFDU_Power and self.State ~= 0 then
        self.State = 0
        self.Initialized = false
        self.MFDUTimer = 0
        self.CardInserted = false
        self.Prost = true
        self.Kos = true
        self.StorageEnabled = false
    end

    if MFDU_Power and self.State == 0 then
        self.State = -1
        self.MFDUTimer = currentTime + 3.3 + math.random() * 0.2
    end

    if self.State == -1 and currentTime > (self.MFDUTimer or 0) then
        self.State = -2
        self.MFDUTimer = currentTime + 0.2 + math.random() * 0.3
    end

    if self.State == -2 and currentTime > (self.MFDUTimer or 0) then
        self.State = -3
        self.MFDUTimer = currentTime + 11 + math.random() * 5
    end

    if self.State == -3 and currentTime > (self.MFDUTimer or 0) then
        self.MFDUTimer = 0
        self.State = 1
    end

    if self.State > 0 and BKPU and BKPU.NotWork then
        self.State = -4
    end

    if not (BKPU and BKPU.NotWork) and self.State == -4 then
        self.State = 1
    end

    if Train.CardInserted ~= nil then
        self.CardInserted = Train.CardInserted
    end

    if self.State == 1 and self.CardInserted and RR and not self.PrevReverserState then
        self.Initialized = true
        self.State = 4
        self.Window = 0
    end

    if self.State == 1 and RR then
        self:TTS(1.5, currentTime)
    end

    if self.State == 1.5 and not RR then
        self:TTS(1, currentTime)
    end

    self.PrevReverserState = RR

    if self.State > 0 and self.State ~= 1.7 and BKPU and BKPU.Back > 0 then
        self:TTS(1.7, currentTime)
    elseif (BKPU and BKPU.Back == 0) and self.State == 1.7 then
        if not RR then
            self:TTS(1, currentTime)
        elseif self.toState and self.toState[1] == 1 then
            self:TTS(4, currentTime)
        end
    end

    if self.State > 0 and self.toState then
        if (self.toState[2] or 0) < currentTime then
            self.State = self.toState[1] or self.State
            self.toState = nil
        end
    end
	if self.State == 4 then
		if not RR then
			self:TTS(1,currentTime+3)
		elseif self.toState and self.toState[1] == 1 then
			self:TTS(4,currentTime)
		end

		self.State2 = self.Window == 81 and 1 or self.Window > 100 and 2 or 0

		do
			local btbu = Train.BTBU
			local swVTB = Train.VTBBlock ~= nil and Train.VTBBlock.Value == 2
			if not swVTB then self.VTBDismissed = false end
			self.VTBDialog = swVTB and btbu ~= nil and btbu.NeedBlockConfirm and btbu.CabKey == true
				and not btbu.BlockConfirmed and not self.VTBDismissed or false
			Train:SetNW2Bool("MFDU:VTBDialog", self.VTBDialog)
		end

		JInit(self)
		if self.State2 <= 1 then
			local BV = false
			local PVU = false
			for i = 1, wag_num do
				BV = BV or (trains[i]["WagType"] or 1)<2 and not trains[i]["BVState"] or trains[i].BUVNotWork
				PVU = PVU or trains[i]["PVU1"] or trains[i]["PVU2"] or trains[i]["PVU3"] or trains[i]["PVU4"] or trains[i]["PVU5"] or trains[i]["PVU6"] or trains[i]["PVU7"]
			end
			Train:SetNW2Int('MFDU:0:ATC1',Train.ATC1.Power and (Train.ATC1.Active and ((Train.ATC1.Brake>0 or (Train.ATC1.PN2 > 0.5)) and 1 or (Train.ATC1.Drive>0 and 2 or 3)) or ((Train.ATSBlock.Value == 1 or Train.ATSBlock.Value == 3) and 0 or 4)) or 0)
			Train:SetNW2Int('MFDU:0:ATC2',Train.ATC2.Power and (Train.ATC2.Active and ((Train.ATC2.Brake>0 or (Train.ATC2.PN2 > 0.5)) and 1 or (Train.ATC2.Drive>0 and 2 or 3)) or ((Train.ATSBlock.Value == 2 or Train.ATSBlock.Value == 3) and 0 or 4)) or 0)

			Train:SetNW2Int('MFDU:0:RVTB',(Train.ATC1.RVTB == 1 and not (Train.BTBU and (Train.BTBU.VTBApplied or Train.BTBU.RVTBCmd))) and 2 or 1)

			do
				self.CondSince = self.CondSince or {}
				local function Hold(key, cond, secs)
					if cond then
						local since = self.CondSince[key]
						if not since then since = currentTime self.CondSince[key] = since end
						return currentTime - since >= secs
					end
					self.CondSince[key] = nil
					return false
				end
				local linked, noHV = 0, 0
				for i = 1, wag_num do
					local t = trains[i]
					if t and not t.BUVNotWork then
						linked = linked + 1
						if (t.HighVoltageMin or 0) <= 550 then noHV = noHV + 1 end
					end
				end
				local noKS = Hold("noks", linked > 0 and noHV == linked, 5)
				local function ArsYellow(a)
					return a and a.Power and a.Active and not ((a.Brake or 0) > 0 or (a.PN2 or 0) > 0.5) and (a.Drive or 0) == 0 or false
				end
				local atsBlk = Train.ATSBlock and Train.ATSBlock.Value or 0
				local ok1 = Train.ATC1.Power == true and atsBlk ~= 1 and atsBlk ~= 3
				local ok2 = Train.ATC2.Power == true and atsBlk ~= 2 and atsBlk ~= 3
				local arsBoth = Hold("arsB", atsBlk ~= 3 and not ok1 and not ok2, 2)
				local ars1    = Hold("ars1", atsBlk == 0 and not Train.ATC1.Power and ok2, 2)
				local ars2    = Hold("ars2", atsBlk == 0 and not Train.ATC2.Power and ok1, 2)
				local function SFOff(t)
					for k = 1, 10 do if t["SF"..k] == 1 then return true end end
					return false
				end
				do
					local anyPT, anyAsm = false, false
					for i = 1, wag_num do
						local t = trains[i]
						if t and not t.BUVNotWork then
							if (t.BCPressure or 0) > 0.1 then anyPT = true end
							if (t.WagType or 1) < 2 and AsmState(t) == 1 then anyAsm = true end
						end
					end
					if not anyPT then self.MsgRowPT = false end
					if not anyAsm then self.MsgRowAsm = false end
				end
				local Prost = Train.Prost_Kos
				local MsgDefs = {
					{1, "Сбой КМ.",                 function(t,i) return i == 1 and BKPU.KMFault == true end, nil},
					{1, "Нет связи с БУВ",         function(t) return t.BUVNotWork end,                          "на %d вагоне", nil, "Отсутствует связь с БУВ"},
					{1, "Вагон не ориентирован",   function(t,i) return Hold("noor"..i, not t.BUVNotWork and t.WagNOrientated == true, 3) end, nil, nil, "Вагоны не ориентированы", "Вагон %d не ориентирован"},
					{1, "ДС не в норме",            function(t) return not t.BUVNotWork and t.EncoderOk == false end, "на %d вагоне"},
					{1, "Отказ АРС. Переведи блокиратор в положение АТС1.", function(t,i) return i == 1 and ars1 end, nil},
					{1, "Отказ АРС. Переведи блокиратор в положение АТС2.", function(t,i) return i == 1 and ars2 end, nil},
					{1, "Отказ АРС. Перейди на УОС.", function(t,i) return i == 1 and arsBoth end, nil},
					{1, "Запрет ТР АРС.",           function(t,i) return i == 1 and (ArsYellow(Train.ATC1) or ArsYellow(Train.ATC2)) end, nil},
					{1, "Экстренное торможение",   function(t) return not t.BUVNotWork and (t.BCPressure or 0) >= (t.Pn3Pressure or 2.2) - 0.15 end, nil},
					{1, "Стояночный тормоз прижат", function(t) return t.ParkingBrakeApply end,                  "на %d вагоне"},
					{1, "Двери не закрыты",         function(t)
						if t.BUVNotWork then return false end
						if t.DoorsClosed == false then return true end
						for d = 1, 8 do if t["Door"..d.."Closed"] == false then return true end end
						return false
					end, "на %d вагоне"},
					{1, "Пневмотормоз включен",     function(t) return self.MsgRowPT == true and not t.BUVNotWork and (t.BCPressure or 0) > 0.1 end, "на %d вагоне"},
					{1, "КМ находится в промежуточном положении.", function(t,i) return i == 1 and BKPU.KMMid == true end, nil},
					{1, "Сработал РВТБ",            function(t,i) return i == 1 and t.RVTBLeak == true end,        nil},
					{1, "Сработал срывной клапан в головной кабине", function(t,i) return i == 1 and t.SKTripped == true end, nil},
					{1, "Сработал срывной клапан в хвостовой кабине", function(t,i,n) return n > 1 and i == n and t.SKTripped == true end, nil},
					{1, "Низкое давление в ТМ.",    function(t) return (t.BLPressure or 9) < 2.65 end,            nil, 2},
					{1, "Низкое давление в НМ.",    function(t) return (t.TLPressure or 9) < 6 end,               nil, 2},
					{1, "Проверь автомат групп БУФТ (РВТБ, КМ, БТБУ, СТ).", function(t,i) return i == 1 and t.SF08 == 1 end, nil},
					{1, "Блокировка ВТБ включена. Торможение только от крана машиниста", function(t,i) return i == 1 and Train.BTBU and Train.BTBU.Blocked == true end, nil},
					{2, "Кузов не в норме",         function(t) return not t.BUVNotWork and t.HullOk == false end, "на %d вагоне"},
					{2, "ТКПР отжаты",              function(t) return not t.BUVNotWork and t.TRDown == true end, "на %d вагоне"},
					{2, "Правые двери заблокированы.", function(t,i) return i == 1 and BKPU.DoorBlockedRight == true end, nil},
					{2, "Левые двери заблокированы.",  function(t,i) return i == 1 and BKPU.DoorBlockedLeft == true end,  nil},
					{2, "Открыта хвостовая кабина.", function(t,i,n) return n > 1 and i == n and not t.BUVNotWork and (t.DoorCabLeft == true or t.DoorCabRight == true or t.DoorCabPass == true) end, nil},
					{2, "Торможение КОС.",          function(t,i) return i == 1 and Prost and Prost.Kos and Prost.CommandKos == true end, nil},
					{2, "БВ отключен",              function(t) return (t.WagType or 1) < 2 and not t.BVState end, "на %d вагоне"},
					{2, "Напряжение КС.",           function(t,i) return i == 1 and noKS end, nil},
					{2, "Нет сбора схемы",          function(t) return self.MsgRowAsm == true and (t.WagType or 1) < 2 and AsmState(t) == 1 end, "на %d вагоне"},
					{3, "Отключен ПСН",             function(t,i)
						if t.BUVNotWork then return false end
						if self.PSNLowSince and self.PSNLowSince[i] and currentTime - self.PSNLowSince[i] >= 30 then return true end
						return Hold("psn"..i, (t.HighVoltageMin or 0) > 550 and t.PSN == false, 3)
					end, "на %d вагоне"},
					{3, "ТКПР только ручное отжатие.", function(t,i) return i == 1 and not t.BUVNotWork and (t.TLPressure or 9) < 3 end, nil},
					{3, "Включи автомат",           function(t) return not t.BUVNotWork and SFOff(t) end, "на %d вагоне"},
					{3, "Отключен МК",              function(t,i) return (t.WagType or 1) < 2 and not t.BUVNotWork and not t.PVU2 and Hold("mk"..i, t.MKCmd == true and t.MKCur ~= true and (t.HighVoltageMin or 0) > 550, 3) end, "на %d вагоне"},
					{3, "Запрет ТР ПРОСТ.",         function(t,i) return i == 1 and Prost and Prost.TractionDenied == true end, nil},
				}
				local msgs = {}
				local jactive = {}
				for _, d in ipairs(MsgDefs) do
					local list = {}
					for i = 1, wag_num do
						if trains[i] and d[3](trains[i], i, wag_num) then list[#list+1] = i end
					end
					local need = d[5] or 1
					if #list >= need then
						local text = d[2]
						if #list == 1 then
							if d[7] then text = Format(d[7], list[1])
							elseif d[4] then text = text.." "..Format(d[4], list[1]) end
						elseif d[6] then
							text = d[6]
						end
						msgs[#msgs+1] = {text, d[1]}
						jactive[text] = d[1]
					end
				end
				local J = self.Journal
				local nowT = os.time()
				if not self.JPurged then
					self.JPurged = true
					for i = #J, 1, -1 do if JSkip(J[i][3]) then table.remove(J, i) end end
				end
				for text, typ in pairs(jactive) do
					if not self.JActive[text] and not JSkip(text) then
						table.insert(J,1,{nowT,typ,text})
						if #J > JMAX then table.remove(J) end
					end
				end
				for text in pairs(self.JActive) do
					if not jactive[text] then
						for _, e in ipairs(J) do
							if e[3] == text and not e[4] then e[4] = nowT break end
						end
					end
				end
				self.JActive = jactive
				self.Train.MFDUJStore.A = jactive
				local json = util.TableToJSON(msgs)
				if self.LastMsgJSON ~= json then
					self.LastMsgJSON = json
					Train:SetNW2String('MFDU:Msgs', json)
					self.MsgIdx = 1
					Train:SetNW2Int('MFDU:MsgIdx', 1)
				end
				self.MsgCount = #msgs
			end
			Train:SetNW2Int('MFDU:0:BV',BV and 1 or 2)
			Train:SetNW2Int('MFDU:0:KTR',Train.Pneumatic.EmerBrakeWork and 2 or 0)
			Train:SetNW2Int('MFDU:0:ALS',Train.ATC1.PrevALS==1 and 2 or 0)
			Train:SetNW2Int('MFDU:0:BOSD',Train.Panel.DoorBlock>0 and 1 or 0)
			Train:SetNW2Int('MFDU:0:PVU',PVU and 3 or 0)

local PB = false
local PT = false
local PTRear = false
local BUVNotWork = false
local EB = false
local UZOff = false
local PUBad = false

Train:SetNW2Bool("DoorsClosedMFDU", self.DoorsClosedMFDU)

for i = 1, wag_num do
    local t = trains[i]
    if t then
        PB = PB or (t.ParkingBrakeApply or false)
        if not t.BUVNotWork then
            if t.PneumaticBrakeApply then
                PT = true
                if i == wag_num then PTRear = true end
            end
        end
        BUVNotWork = BUVNotWork or (t.BUVNotWork or false)
        EB = EB or ((t.BCPressure or 0) > 2.2)
        UZOff = UZOff or (not t.BUVNotWork and t.AntiskidOff == true)
        PUBad = PUBad or (not t.BUVNotWork and t.EncoderOk == false)
    end
end

			local metka = Train.Prost_Kos.Metka[4] or Train.Prost_Kos.Metka[3] or Train.Prost_Kos.Metka[2] or Train.Prost_Kos.Metka[1]
			local metka2 = Train.Prost_Kos.Metka[3] or Train.Prost_Kos.Metka[2] or Train.Prost_Kos.Metka[1]

			Train:SetNW2Int('MFDU:0:UZ',PUBad and 1 or UZOff and 4 or 0)
			Train:SetNW2Int('MFDU:0:PB',BUVNotWork and 4 or PB and 3 or 0)
			Train:SetNW2Int('MFDU:0:PT',PT and 2 or 0)
			Train:SetNW2Int('MFDU:0:PTh',PTRear and 2 or 0)
			Train:SetNW2Int('MFDU:0:EB',BUVNotWork and 4 or EB and 1 or 0)
			Train:SetNW2Int('MFDU:0:AD',0)
			local prostManual = Train.Prost_Kos.ProstManual == true or (Train.Prost_Kos.ProstActive == 1 and BKPU.ControllerPosition < 0)
			Train:SetNW2Int('MFDU:0:Prost',Train.Prost_Kos.Prost and (prostManual and metka and 3 or Train.Prost_Kos.ProstActive == 1 and metka and (metka2 and currentTime%1>0.4 and 4 or 3) or 4) or 0)
			Train:SetNW2Int('MFDU:0:Kos',Train.Prost_Kos.Kos and (Train.Prost_Kos.KosActive and metka and (Train.Prost_Kos.CommandKos and 1 or 3) or 4) or 0)
			Train:SetNW2Int('MFDU:0:RV',(Train.RV.KRRPosition ~= 0 and Train.SF4.Value > 0) and 3 or 0)
			Train:SetNW2Int('MFDU:0:Up',Train.BKPU.SlopeEnabled and 3 or 0)
			Train:SetNW2Bool("MFDU:Podyem", Train.BKPU.SlopeEnabled == true)

			if not self.DataCache.Speed or self.DataCache.Speed ~= Train.ATC1.Speed then
				Train:SetNW2Int("MFDU_Speed",Train.ATC1.Speed)
				self.DataCache.Speed = Train.ATC1.Speed
			end

			Train:SetNW2Bool("MFDU:TwoToSix",Train.ATC1.TwoToSix)
			Train:SetNW2Int("MFDU:SpeedLimit",Train.ATC1.SpeedLimit)
			Train:SetNW2Int("MFDU:NextLimit",Train.ATC1.NextNoFq and -1 or (Train.ATC1.NextLimit or 0))
			Train:SetNW2Bool("MFDU:UOS",Train.ATC1.UOS)
			Train:SetNW2Bool("MFDU:UOSActive",Train.ATC1.UOSActive)
			Train:SetNW2Bool("MFDU:BINoFreq",Train.ATC1.BINoFreq)
			Train:SetNW2Bool("MFDU:NextNoFq",Train.ATC1.NextNoFq)
			Train:SetNW2Bool("MFDU:NoFreq",Train.ATC1.NoFreq)
			Train:SetNW2Bool("MFDU:LN",Train.ATC1.LN)
			Train:SetNW2Bool("MFDU:BadFq",Train.ATC1.BadFq)
			Train:SetNW2Bool("MFDU:AO",Train.ALSCoil.AO)
			Train:SetNW2Bool("MFDU:KB",Train.ATC1.KB)

			Train:SetPackedRatio("MFDU_PowerCommand", BKPU.PowerCommand)
			Train:SetNW2Bool("MFDU_Braking", BKPU.Braking)

			local BCmax = math.max(WP(1,true ,trains,"BCPressure"),WP(2,true ,trains,"BCPressure"),WP(3,true ,trains,"BCPressure"),WP(4,true ,trains,"BCPressure"),WP(5,true ,trains,"BCPressure"),WP(6,true ,trains,"BCPressure"),WP(7,true ,trains,"BCPressure"),WP(8,true ,trains,"BCPressure"))
			local BCmin = math.min(WP(1,false,trains,"BCPressure"),WP(2,false,trains,"BCPressure"),WP(3,false,trains,"BCPressure"),WP(4,false,trains,"BCPressure"),WP(5,false,trains,"BCPressure"),WP(6,false,trains,"BCPressure"),WP(7,false,trains,"BCPressure"),WP(8,false,trains,"BCPressure"))
			Train:SetNW2Int("MFDU_BCmax",BCmax*10)
			Train:SetNW2Int("MFDU_BCmin",BCmin*10)

			Train:SetNW2Float("MFDU_TLPressure", Train.Pneumatic.TrainLinePressure)
			Train:SetNW2Float("MFDU_BLPressure", Train.Pneumatic.BrakeLinePressure)
		end

		if self.Window ~= self.LastWindow or currentTime % 0.5 < 0.1 then
			self:UpdateWindowData(self.Window, Train, wag_num, trains)
			self.LastWindow = self.Window
		end

		if self.Window > 90 and self.State2 == 0 then
			for i, t in ipairs(Train.WagonList) do
				if t.Electric.Type ~= 0 then goto cont end
				local debugSYS = t.Prost_Kos
				local debugIn = {
					"ProstActive",
					"KosActive",
					"Prost",
					"Kos",
					"Command",
					"EmergencyBrake",
					"CommandKos",
					"Stop",
					"Stop1",
					"BlockDoorsL",
					"BlockDoorsR",
					"Timer1",
					"Metka1",
					"WrongDir",
					"sum",
					"dist2",
					"v0",
				}
				local debugOut = {}
				for k, v in ipairs(debugIn) do
					debugOut[v] = type(debugSYS[v]) == "boolean" and (debugSYS[v] and 1 or 0) or debugSYS[v]
				end
				Train:SetNW2String("MFDU_DeBug"..i,util.TableToJSON(debugOut,false))
				::cont::
			end
		end

		local doorsclosed = true
		for i = 1, wag_num do
			Train:SetNW2Int("MFDU_WagonNumber"..i,trains[i]["ID"])
			Train:SetNW2Bool("MFDU_Orientation" .. i, trains[i]["Orientation"])
			Train:SetNW2Int("MFDU_WagType_" .. i, trains[i]["WagType"])
			Train:SetNW2Bool("MFDU_BUVNotWork" .. i, trains[i]["BUVNotWork"])
			doorsclosed = doorsclosed and trains[i]["DoorsClosed"]
		end
		Train:SetNW2Bool("MFDU_DoorsClosed",doorsclosed)
		self.DoorsClosedMFDU = doorsclosed and true or false
		Train:SetNW2Bool("MFDU:Recup", self.RecupEnabled ~= false)
		Train:SetNW2Bool("MFDU:Storage", self.StorageEnabled == true)
		Train:SetNW2Bool("MFDU:CondLeto", self.CondLeto ~= false)

		local eeTotal, eeLive = 0, 0
		for i = 1, wag_num do
			local t = trains[i]
			if t and not t.BUVNotWork then
				eeTotal = eeTotal + 1
				if (t.HighVoltageMin or 0) > 550 then eeLive = eeLive + 1 end
			end
		end
		Train:SetNW2Int("MFDU_EEState", (eeTotal == 0 or eeLive == 0) and 0 or (eeLive < eeTotal and 1 or 2))

		local avail = false
		for i = 1, wag_num do
			local t = trains[i]
			if (i == 1 or (wag_num == 8 and i == wag_num)) and t and not t.BUVNotWork and not t.StorageLocked and (t.HighVoltageMin or 0) <= 550 then
				avail = true
			end
		end
		self.StorageAvail = avail
		if not avail then self.StorageEnabled = false end
		Train:SetNW2Bool("MFDU:StorageAvail", avail)
		Train:SetNW2Bool("MFDU:Storage", self.StorageEnabled == true)

		if self.Window == 0 then
			local st ={false, false, false, false, false, false}

			if BKPU.DoorsOpenLeft>0 or BKPU.DoorsOpenRight>0 then
				self.Window = 21
				self.AutoW21 = currentTime
			end

			local kmp = BKPU.ControllerPosition
			local asmCheck = kmp ~= 0 and kmp > -1 and math.abs(Train.Speed or 0) > 7
			if not asmCheck and self.AssemblyTimer then self.AssemblyTimer = nil end
			if kmp > 0 or asmCheck then
				local NoAsyncAssembly = false
				local PT = false
				for i = 1, wag_num do
					NoAsyncAssembly = asmCheck and (NoAsyncAssembly or (trains[i]["WagType"] or 1)<2 and AsmState(trains[i]) == 1)
					PT = PT or (trains[i].BCPressure or 0)>0.1
				end
				if kmp <= 0 then PT = false end
				if NoAsyncAssembly and not self.AssemblyTimer then
					self.AssemblyTimer = currentTime+5
				end
				if not NoAsyncAssembly and self.AssemblyTimer then
					self.AssemblyTimer = nil
				end
				if PT and not self.PTTimer then
					self.PTTimer = currentTime+3
				end
				if not PT and self.PTTimer then
					self.PTTimer = nil
				end
			else
				self.PTTimer = nil
				self.AssemblyTimer = nil
			end

			for i = 1, wag_num do
				Train:SetNW2Int('MFDU:0:'..(wag_num-(i-1))..':1',GetInfo(trains[i],"DoorsClosed",2,1))
				Train:SetNW2Int('MFDU:0:'..(wag_num-(i-1))..':2',AsmState(trains[i]))
				Train:SetNW2Int('MFDU:0:'..(wag_num-(i-1))..':3',GetInfo(trains[i],"BVState",2,1))
				Train:SetNW2Int('MFDU:0:'..(wag_num-(i-1))..':4',(trains[i].BUVNotWork or false) and 0 or ((trains[i].BCPressure or 0) > 0.1 and 1 or 2))
				Train:SetNW2Int('MFDU:0:'..(wag_num-(i-1))..':5',GetInfo(trains[i],"ParkingBrakeApply",1,2))
				Train:SetNW2Int('MFDU:0:'..(wag_num-(i-1))..':6',GetInfo(trains[i],"PSN",2,1))
				Train:SetNW2Int('MFDU:0:'..(wag_num-(i-1))..':7',trains[i].BUVNotWork and 0 or 2)
				st[1] = st[1] or not trains[i]["DoorsClosed"] or trains[i].BUVNotWork
				st[2] = st[2] or trains[i].BUVNotWork
				st[3] = st[3] or (trains[i]["WagType"] or 1)<2 and not trains[i]["BVState"] or trains[i].BUVNotWork
				st[4] = st[4] or trains[i].BUVNotWork
				st[5] = st[5] or trains[i]["ParkingBrakeApply"] or trains[i].BUVNotWork
				local lowAkb = not trains[i].BUVNotWork and (trains[i].LowVoltage or 99) < 73
				self.PSNLowSince = self.PSNLowSince or {}
				if lowAkb then self.PSNLowSince[i] = self.PSNLowSince[i] or currentTime else self.PSNLowSince[i] = nil end
				st[6] = st[6] or (self.PSNLowSince[i] ~= nil and currentTime - self.PSNLowSince[i] >= 30) or trains[i].BUVNotWork
				st[7] = st[7] or false or trains[i].BUVNotWork
			end
			local sts = false
			local asmRow = self.AssemblyTimer and self.AssemblyTimer < currentTime and true or false
			local ptRow = self.PTTimer and self.PTTimer < currentTime and true or false
			st[2] = st[2] or asmRow
			st[4] = st[4] or ptRow
			self.MsgRowAsm = asmRow
			self.MsgRowPT = ptRow
			for i = 1, 7 do
				Train:SetNW2Bool('MFDU:0:0:'..i,st[i])
				sts = sts or st[i]
			end
			Train:SetNW2Bool('MFDU:0:0:0',sts)

			local UBSmax = math.max(WP(1,true ,trains,"LowVoltage"),WP(2,true ,trains,"LowVoltage"),WP(3,true ,trains,"LowVoltage"),WP(4,true ,trains,"LowVoltage"),WP(5,true ,trains,"LowVoltage"),WP(6,true ,trains,"LowVoltage"),WP(7,true ,trains,"LowVoltage"),WP(8,true ,trains,"LowVoltage"))
			local UBSmin = math.min(WP(1,false,trains,"LowVoltage"),WP(2,false,trains,"LowVoltage"),WP(3,false,trains,"LowVoltage"),WP(4,false,trains,"LowVoltage"),WP(5,false,trains,"LowVoltage"),WP(6,false,trains,"LowVoltage"),WP(7,false,trains,"LowVoltage"),WP(8,false,trains,"LowVoltage"))
			Train:SetNW2Int("MFDU_UBSmax",UBSmax)
			Train:SetNW2Int("MFDU_UBSmin",UBSmin)
			local HVmax = math.max(WP(1,true ,trains,"HighVoltageMax"),WP(2,true ,trains,"HighVoltageMax"),WP(3,true ,trains,"HighVoltageMax"),WP(4,true ,trains,"HighVoltageMax"),WP(5,true ,trains,"HighVoltageMax"),WP(6,true ,trains,"HighVoltageMax"),WP(7,true ,trains,"HighVoltageMax"),WP(8,true ,trains,"HighVoltageMax"))
			local HVmin = math.min(WP(1,false,trains,"HighVoltageMin"),WP(2,false,trains,"HighVoltageMin"),WP(3,false,trains,"HighVoltageMin"),WP(4,false,trains,"HighVoltageMin"),WP(5,false,trains,"HighVoltageMin"),WP(6,false,trains,"HighVoltageMin"),WP(7,false,trains,"HighVoltageMin"),WP(8,false,trains,"HighVoltageMin"))
			Train:SetNW2Int("MFDU_HVmax",HVmax)
			Train:SetNW2Int("MFDU_HVmin",HVmin)
		end
	end

	if self.State == 1.7 then
		Train:SetNW2Int("MFDU_Speed",Train.ATC1.Speed)
		Train:SetNW2Int("MFDU_HV",Train.Electric.Main750V)
		Train:SetNW2Int("MFDU_UBS",Train.BUV.Voltage)

		Train:SetNW2Float("MFDU_TLPressure", Train.Pneumatic.TrainLinePressure)
		Train:SetNW2Float("MFDU_BLPressure", Train.Pneumatic.BrakeLinePressure)
	end

	if self.State == 2 then
		Train:SetNW2String("MFDU_CurrentPassword", self.CurrentPassword)
		Train:SetNW2Bool("MFDU_PasswordSelected", self.PasswordSelected)
		Train:SetNW2Bool("MFDU_PasswordStartType", self.PasswordStartType)
	end

	if self.State == 3 then
		Train:SetNW2Int("MFDU_StateDepot", self.StateDepot)
		Train:SetNW2String("MFDU_MapCurrentPassword", self.MapCurrentPassword)
	end

	do
		local RVs = Train.RV
		local prio = 0
		if self.State >= 1 then
			if RVs and RVs.KROPosition ~= 0 and (RVs.KRRPosition ~= 0 or Train.SF4.Value <= 0) then
				prio = 2
			elseif self.State == 1.7 and RR then
				prio = 1
			end
		end
		Train:SetNW2Int("MFDU:Prio", prio)
	end

	Train:SetNW2Int("MFDU_State", self.State*10)
	Train:SetNW2Int("MFDU_State2", self.State2)
	do
		JInit(self)
		local J = self.Journal
		local n = #J
		local top = math.Clamp(self.JTop or 1, 1, math.max(1, n))
		local sel = math.Clamp(self.JSel or 1, 1, math.max(1, n))
		self.LastJRow = self.LastJRow or {}
		for k = 1, 18 do
			local e = J[top + k - 1]
			local row = e and util.TableToJSON(e) or ""
			if self.LastJRow[k] ~= row then
				self.LastJRow[k] = row
				Train:SetNW2String("MFDU:JRow"..k, row)
			end
		end
		Train:SetNW2Int("MFDU:JCount", n)
		Train:SetNW2Int("MFDU:JSel", sel - top + 1)
		local act = 0
		for i = 1, n do if not J[i][4] then act = act + 1 end end
		Train:SetNW2Int("MFDU:JournalNew", math.min(act, 99))
	end
	Train:SetNW2Int("MFDU_Window", self.Window)
end

if CLIENT then
	local function createFont(name, font, size, weight)
		surface.CreateFont("Metrostroi_775_"..name, {
			font = font,
			size = size*2,
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

	createFont("Calibri255", "Calibri", 255)
	createFont("Calibri150", "Calibri", 150)
	createFont("Calibri90", "Calibri", 90)
	createFont("Calibri80", "Calibri", 80)
	createFont("Calibri70b", "Calibri Light", 70, 800)
	createFont("Calibri70", "Calibri", 70)
	createFont("Calibri40", "Calibri", 40)
	createFont("Calibri38", "Calibri", 38)
	createFont("Calibri35", "Calibri", 35)
	createFont("Calibri30", "Calibri", 30)
	createFont("Calibri30b", "Calibri", 30, 800)
	createFont("Calibri28", "Calibri", 28)
	createFont("Calibri26", "Calibri", 26)
	createFont("Calibri25", "Calibri", 25)
	createFont("Calibri23", "Calibri", 23)
	createFont("Calibri22", "Calibri Light", 22)
	createFont("Calibri22b", "Calibri Light", 22,800)
	createFont("Calibri24b", "Calibri", 24, 800)
	createFont("Calibri20", "Calibri Light", 20)
	createFont("Calibri19", "Calibri", 19)
	createFont("Calibri18", "Calibri", 18)
	createFont("Calibri18l", "Calibri Light", 18)
	createFont("Calibri16", "Calibri Light", 16)
	createFont("Calibri15", "Calibri", 15)
	createFont("Calibri14", "Calibri", 14)
	createFont("Calibri13", "Calibri", 13)
	createFont("Calibri15b", "Calibri", 15, 800)
	createFont("Calibri20b", "Calibri", 20, 800)
	createFont("Calibri22b", "Calibri", 22, 800)
	createFont("Calibri14", "Calibri Light", 14)
	createFont("Calibri12", "Calibri Light", 12)
	createFont("Calibri10", "Calibri", 10)
	createFont("Calibri10b", "Calibri", 10, 800)

	createFont("Roboto18r", "Roboto", 18)
	createFont("Roboto24r", "Roboto", 24)
	createFont("Roboto26r", "Roboto", 26)
	createFont("Roboto25r", "Roboto", 25)
	createFont("Roboto32b", "Roboto Bold", 32)
	createFont("Roboto28b", "Roboto Bold", 28)
	createFont("Roboto26b", "Roboto Bold", 26)
	createFont("Roboto22b", "Roboto Bold", 22)

	createFont("Primus", "Calibri", 36, 100)
	createFont("Primus26", "Calibri", 26, 500)

	function TRAIN_SYSTEM:ClientInitialize()
		local images = {
			"state5_1", "state5_2", "state5_3", "state5_4", "state5_5", "state5_6", "state5_7", "state5_8", "state5_9",
			"home", "speaker", "pyu", "parking_brake", "wheel", "rear_wheel", "emer_brake", "autodrive", "prost", "kos",
			"rv_res", "accel", "shutdown", "moscow_logo"
		}

		self.Images = {}
		for k, v in pairs(images) do
			local path = "models/metrostroi_train/81-775/mfdu/"
			self.Images[v] = surface.GetTextureID(path .. v)
		end

		self.LastChangeState = CurTime()
		self.LastState = 0
		self.DisplayLight = true
		self.PowerCommand = 0
		self.FPSTimer = CurTime()
		self.LastRenderTime = 0
		self.RenderInterval = 0.1
	end

	function TRAIN_SYSTEM:SetTexture(name)
		surface.SetTexture(self.Images[name])
	end

	function TRAIN_SYSTEM:DrawTexture(x, y, w, h, notcenter)
		if not notcenter then
			surface.DrawTexturedRectRotated(x + w/2, y + h/2, w, h, 0)
		else
			surface.DrawTexturedRectRotated(x, y, w, h, 0)
		end
	end

	local scr_w = 800*2
	local scr_h = 600*2



	local color_black = Color(0, 0, 0)
	local color_gray = Color(100, 100, 100)
	local color_gray2 = Color(50, 50, 50)
	local color_gray3 = Color(200, 200, 200)
	local color_gray4 = Color(150, 150, 150)
	local color_light_blue = Color(60, 220, 230)
	local color_gray_text = Color(100, 100, 100)
	local color_gray_butt2 = Color(115, 115, 115)
	local color_gray_butt = Color(230, 230, 230)
	local color_red = Color(215, 0, 0, 255)
	local color_green = Color(0, 200, 0, 255)

	local function DrawBox(x, y, w, h, color_in, color_out,r1,r2)
		r1 = r1 or 0
		r2 = r2 or 0
		color_out = color_out or color_gray
		color_in = color_in or color_black
		draw.RoundedBox(r1, x, y, w, h, color_out)
		draw.RoundedBox(r2, x+2, y+2, w-4, h-4,color_in)
	end

	local function DrawButton(x, y, w, h,t,f,c,cb,cbb)
		draw.RoundedBox(16, x, y, w, h,cbb or color_gray_butt)
		draw.RoundedBox(16, x+4, y+4, w-8, h-8,cb or color_gray_butt2)
		if t then
			if t:find("|") then
				t = string.Explode("|",t)
				draw.SimpleText(t[1],f,x+w/2,y+h/3,c,1,1)
				draw.SimpleText(t[2],f,x+w/2,y+h/1.5,c,1,1)
			else
				draw.SimpleText(t,f,x+w/2,y+h/2,c,1,1)
			end
		end
	end

	local IC = {
		[0] = Color(255,255,255),
		[1] = Color(255,0,0),
		[2] = Color(0,255,0),
		[3] = Color(255,255,0),
	}

	function TRAIN_SYSTEM:DrawMainBox(input_data, train, state,window,dT)
		Metrostroi.DrawRectOutline(2,2,198*2,76,color_gray,2)
		Metrostroi.DrawRectOutline(198*2+4,2,802,76,color_gray,2)
		Metrostroi.DrawRectOutline(198*2+808,2,198*2,76,color_gray,2)

		if input_data[1]:find(" ") then
			input_data[1] = string.Explode(" ",input_data[1])
			draw.SimpleText(input_data[1][1],"Metrostroi_775_Calibri16",200,76/3.5,color_gray_text,1,1)
			draw.SimpleText(input_data[1][2],"Metrostroi_775_Calibri16",200,76/1.5,color_gray_text,1,1)
		else
			draw.SimpleText(input_data[1],"Metrostroi_775_Calibri16",200,76/2,color_gray_text,1,1)
		end

		draw.SimpleText(input_data[2],"Metrostroi_775_Calibri30b",800,76/2,color_gray_text,1,1)

		local date = os.date("%d.%m.%Y")
		local time = os.date("%X")

		draw.SimpleText(date,"Metrostroi_775_Calibri18",1400,76/3.5,color_gray_text,1,1)
		draw.SimpleText(time,"Metrostroi_775_Calibri18",1400,76/1.33,color_gray_text,1,1)

		Metrostroi.DrawRectOutline(132,80,1326,786,color_gray,2)

		local statesText = {
			"АРС 1",
			"АРС 2",
			"БТБ",
			"БВ",
			"КТР",
			"АЛС",
			"БОСД",
			"ПВУ"
		}

		local data =  {
			train:GetNW2Int('MFDU:0:ATC1',0),
			train:GetNW2Int('MFDU:0:ATC2',0),
			train:GetNW2Int('MFDU:0:RVTB',0),
			train:GetNW2Int('MFDU:0:BV',0),
			train:GetNW2Int('MFDU:0:KTR',0),
			train:GetNW2Int('MFDU:0:ALS',0),
			train:GetNW2Int('MFDU:0:BOSD',0),
			train:GetNW2Int('MFDU:0:PVU',0),
		}

		for i = 1, 8 do
			surface.SetTextColor(0, 0, 0, 255)

			local color = Color(255, 0, 255)
			local state = data[i]
			local text = statesText[i]
			local textcolor = color_gray_text

			if state == 0 then
				color = Color(40, 40, 40)
				textcolor = Color(90, 90, 90, 255)
			elseif state == 1 then
				color = Color(255, 0, 0)
				textcolor = Color(100, 0, 0, 255)
			elseif state == 2 then
				color = Color(0, 255, 0)
				textcolor = Color(0, 100, 0, 255)
			elseif state == 3 then
				color = Color(255, 255, 0)
				textcolor = Color(100, 100, 0, 255)
			elseif state == 4 then
				color = Color(255, 255, 255)
				textcolor = Color(100, 100, 100, 255)
			end

			DrawBox(4 + 712*2 + 16*2, 4 + 40*2 + (49.1 * (i-1))*2, (83-14)*2, 48*2, color)

			draw.SimpleText(text,"Metrostroi_775_Calibri22b",2 + 712*2 + 16*2 + (83-14),2 + 40*2 + (49 * (i-1))*2 + 48,textcolor,1,1)
		end

		local power_line_height = 330*2
		local power_line_x = 38*2
		local power_line_y = 70*2

		local Active = train:GetNW2Bool("CabActive")
		local PCmd = train:GetPackedRatio("MFDU_PowerCommand",0)

		surface.SetDrawColor(color_gray2)
		surface.DrawRect(power_line_x, power_line_y, 29*2-4, power_line_height)

		if not Active and self.PowerCommand ~= 0 then self.PowerCommand = 0 end
		if (PCmd < 0 and self.PowerCommand > 0) or (PCmd > 0 and self.PowerCommand < 0) or train:GetNW2Bool("MFDU_PowerCommandReset") then
			self.PowerCommand = 0
		end
		self.PowerCommand = PCmd
		if Active and -0.01 > self.PowerCommand or self.PowerCommand > 0.01 then
			surface.SetDrawColor(self.PowerCommand < 0 and 255 or 0,255,0)
			surface.DrawRect(power_line_x+2,power_line_y+power_line_height/2,30*2-7,math.Clamp(self.PowerCommand*-power_line_height/2,-power_line_height/2,power_line_height/2))
		end

		surface.SetDrawColor(color_gray)
		surface.DrawRect(power_line_x, power_line_y, 2, power_line_height)

		for i = 1, 20 do
			local step = power_line_height/20

			local x = power_line_x
			local y = power_line_y + (step*(i-1))

			local size = 16

			if i % 2 == 0 then
				size = 12
			end

			surface.DrawRect(x - size, y, size, 2)
		end

		surface.DrawRect(power_line_x - 8, power_line_y + power_line_height - 2, 8, 2)

		for i = 0, 10 do
			local step = power_line_height/10

			local x = power_line_x - 24
			local y = power_line_y + (step*(i))

			draw.SimpleText(100-20*i,"Metrostroi_775_Calibri14",x,y,color_gray,2,1)
		end

		surface.DrawRect(power_line_x, power_line_y + power_line_height / 2, 30*2-4, 2)

		local power_percent_positive_color = Color(0, 150, 0)
		local power_percent_negative_color = Color(150, 150, 0)

		local power_percent_positive = math.floor(math.abs(math.max(PCmd,0))*100)
		local power_percent_negative = math.floor(math.abs(math.min(PCmd,0))*100)

		draw.SimpleText(Format("%d%%",power_percent_positive),"Metrostroi_775_Calibri12",power_line_x + 27*2,power_line_y + 85*2 + 1,power_percent_positive_color,2,1)

		draw.SimpleText(Format("%d%%",power_percent_negative),"Metrostroi_775_Calibri12",power_line_x + 27*2,power_line_y + 255*2 + 1,power_percent_negative_color,2,1)

		draw.SimpleText("ХОД","Metrostroi_775_Calibri15",32*2,55*2,color_gray,1,1)
		draw.SimpleText("ТОРМОЗ","Metrostroi_775_Calibri15",34*2,416*2,color_gray,1,1)

		Metrostroi.DrawRectOutline(2,436*2,296,220,color_gray4,2)
		Metrostroi.DrawRectOutline(300,436*2,1000,220,color_gray4,2)
		Metrostroi.DrawRectOutline(1600-296-2,436*2,296,220,color_gray4,2)

		local count = 10

		local doorClosed = train:GetNW2Bool("MFDU_DoorsClosed")
		local summer = train:GetNW2Bool("MFDU:CondLeto", true)

		local step = scr_w/count
		local size = scr_w/count-2

		local eeState = train:GetNW2Int("MFDU_EEState", 0)
		local eeColor = eeState == 2 and color_green or eeState == 1 and Color(255,255,0) or color_red

		local windowBtns = {
			{"ВО"		,2,	"state5_1",36,color_green},
			{"Двери"	,6,	"state5_2",20,doorClosed and color_green or color_red},
			{"ТП"		,4,	"state5_3",28,color_green},
			{"ЭЭ"		,4,	"state5_4",24,eeColor},
			{"ПНМ"		,8,	"state5_5",25},
			{"Климат"	,5,	summer and "state5_6" or "state5_8",28,summer and Color(250,255,0) or Color(255,255,255)},
			{"АВП"		,8,	"autodrive",27},
			{"Журнал"	,4,	"state5_9",26},
			{"Диаг"		,10,"state5_7",26}
		}

		local windowNamesOffset = {
			2,
			6,
			4,
			4,
			8,
			5,
			8,
			4,
			10,
		}

		for i = 1, 9 do
			local x = 2 + (i - 1)*step
			local n = math.floor(window/10) == i
			Metrostroi.DrawRectOutline(x,548*2,size,100,n and color_light_blue or color_gray4,2)

			if not (i == 1 and (window >10 and window < 20)) then
				local c = windowBtns[i][5] or Color(180, 180, 180)
				surface.SetDrawColor(c.r, c.g, c.b, 255)
				self:SetTexture(windowBtns[i][3])
				self:DrawTexture(27*2+x-2, 567*2, windowBtns[i][4]*2, windowBtns[i][4]*2, true)
				draw.SimpleText(windowBtns[i][1],"Metrostroi_775_Calibri16",x + 74*2 - windowBtns[i][2],589*2,color_white,2,1)
			else
				Metrostroi.DrawRectOutline(x+4,548*2+4,size/2-6,100-8,color_gray4,2)
				Metrostroi.DrawRectOutline(x+2+size/2,548*2+4,size/2-6,100-8,color_gray4,2)
				draw.SimpleText("↑","Metrostroi_775_Calibri26",x+4+(size/2-6)/2,548*2+50,color_gray4,1,1)
				draw.SimpleText("↓","Metrostroi_775_Calibri26",x+2+size/2+(size/2-6)/2,548*2+50,color_gray4,1,1)
			end

		end

		if window > 0 then
			local i = 10
			local icon_size = 28*2
			Metrostroi.DrawRectOutline(2 + (i - 1)*step,548*2,size,100,window == i*10 and color_light_blue or color_gray4,2)
			surface.SetDrawColor(color_green)
			self:SetTexture("home")
			self:DrawTexture(760*2, 573*2, icon_size, icon_size, true)
		end

		draw.SimpleText(train:GetNW2Int("MFDU:JournalNew",0),"Metrostroi_775_Calibri16",624*2,555*2,Color(10, 255, 255, 255),1,1)

		local icon_size = 45*2
		local small_icon_size = icon_size - 7*2
		local yOffset = 462*2
		local xOffset = 49*2

		local data = {
			train:GetNW2Int('MFDU:0:UZ',0),
			train:GetNW2Int('MFDU:0:PB',0),
			train:GetNW2Int('MFDU:0:PT',0),
			train:GetNW2Int('MFDU:0:PTh',0),
			train:GetNW2Int('MFDU:0:EB',0),
			train:GetNW2Int('MFDU:0:AD',0),
			train:GetNW2Int('MFDU:0:Prost',0),
			train:GetNW2Int('MFDU:0:Kos',0),
			train:GetNW2Int('MFDU:0:RV',0),
			train:GetNW2Int('MFDU:0:Up',0),
		}

		local col = {
			[0] = {60, 60, 60},
			[1] = {255, 60, 60},
			[2] = {255, 255, 60},
			[3] = {60, 255, 60},
			[4] = {255, 255, 255},
			[5] = {60, 60, 255},
		}

		local signs = {"pyu","parking_brake","wheel","rear_wheel","emer_brake","autodrive","prost","kos","rv_res","accel"}
		for i = 1,#signs do
			local d = data[i]
			surface.SetDrawColor(col[d][1], col[d][2], col[d][3], 255)
			self:SetTexture(signs[i])
			self:DrawTexture(131*2+xOffset*i, yOffset, i == 1 and icon_size or small_icon_size, i == 1 and icon_size or small_icon_size, true)
		end

		if window ~= 81 then
			local msgs = NWJSON(train,"MFDU:Msgs","[]") or {}
			if #msgs > 0 then
				local idx = math.Clamp(train:GetNW2Int("MFDU:MsgIdx",1), 1, #msgs)
				local m = msgs[idx]
				local c = m[2] == 1 and Color(255,60,60) or m[2] == 2 and Color(255,255,60) or Color(80,200,255)
				local fx = #msgs > 1 and 368 or 300
				local fcx = (fx + 1300) / 2
				Metrostroi.DrawRectOutline(fx,970,1300-fx,122,c,4)
				if #msgs > 1 then
					local upc = idx > 1 and color_white or color_gray4
					local dnc = idx < #msgs and color_white or color_gray4
					Metrostroi.DrawRectOutline(300,970,fx-300,59,upc,2)
					Metrostroi.DrawRectOutline(300,1033,fx-300,59,dnc,2)
					draw.SimpleText("↑","Metrostroi_775_Calibri26",(300+fx)/2,1000,upc,1,1)
					draw.SimpleText("↓","Metrostroi_775_Calibri26",(300+fx)/2,1063,dnc,1,1)
				end
				local line1,line2 = string.match(m[1],"^(.-%.)%s+(.+)$")
				if line1 then
					draw.SimpleText(line1,"Metrostroi_775_Calibri22",fcx,1004,color_white,1,1)
					draw.SimpleText(line2,"Metrostroi_775_Calibri22",fcx,1046,color_white,1,1)
				else
					draw.SimpleText(m[1],"Metrostroi_775_Calibri26",fcx,1025,color_white,1,1)
				end
				local qcx,qcy,qr = 1300-4-8-28-10, 1031, 28
				draw.RoundedBox(qr, qcx-qr, qcy-qr, qr*2, qr*2, color_white)
				draw.RoundedBox(qr-3, qcx-qr+3, qcy-qr+3, (qr-3)*2, (qr-3)*2, color_black)
				draw.SimpleText("?","Metrostroi_775_Calibri30b",qcx,qcy,color_white,1,1)
				if #msgs > 1 then
					draw.SimpleText(idx.."/"..#msgs,"Metrostroi_775_Calibri16",1276,1140,color_gray,2,1)
				end
			end
		end
	end

	local function MainWindow(train)
		local decoder = train:GetNW2Bool("MFDU:TwoToSix")
		local speed = train:GetNW2Int("MFDU_Speed")

		local SpeedLimit = train:GetNW2Int(		"MFDU:SpeedLimit",0)
		local SpeedLimitNext = train:GetNW2Int(	"MFDU:NextLimit",-1) == 20 and 0 or train:GetNW2Int("MFDU:NextLimit",-1)
		local NextNoFq = train:GetNW2Bool(		"MFDU:NextNoFq")
		local KB = train:GetNW2Bool(			"MFDU:KB")
		local UOS = train:GetNW2Bool(			"MFDU:UOS")
		local UOSA = train:GetNW2Bool(			"MFDU:UOSActive")
		local NoFreq = train:GetNW2Bool(		"MFDU:NoFreq")

		local podyem = train:GetNW2Bool("MFDU:Podyem")

		if podyem then
			surface.SetDrawColor(Color(0, 255, 0, 255))
			surface.DrawRect(207*2, 85*2, 130*2, 67*2)
		end
		Metrostroi.DrawRectOutline(207*2, 85*2, 130*2, 67*2,color_gray4,4)

		draw.SimpleText("Вкл","Metrostroi_775_Calibri30b",(207+65)*2, 89*2,podyem and color_black or color_gray,1,0)
		draw.SimpleText("подъем","Metrostroi_775_Calibri30b",(207+65)*2, (89+25)*2,podyem and color_black or color_gray,1,0)

		draw.SimpleText("Режим "..((UOS and UOSA) and "УОС" or (UOS and not UOSA) and "" or decoder and  "2/6" or "1/5"),"Metrostroi_775_Calibri22",144*2,70*2,color_gray,1,1)

		draw.SimpleText("км/ч","Metrostroi_775_Calibri30",144*2,170*2,color_white,1,1)

		draw.SimpleText(math.floor(speed),"Metrostroi_775_Calibri90",144*2,120*2,Color(0, 255, 0, 255),1,1)

		draw.SimpleText("V доп","Metrostroi_775_Calibri30",144*2,215*2,Color(255, 0, 0, 255),1,1)
		if NoFreq then
			draw.SimpleText(KB and SpeedLimit or "ОЧ","Metrostroi_775_Calibri70b",144*2,250*2,Color(255, 0, 0, 255),1,1)
		else
			draw.SimpleText(SpeedLimit,"Metrostroi_775_Calibri70b",144*2,250*2,Color(255, 0, 0, 255),1,1)
		end
		if decoder then
			draw.SimpleText("V пред","Metrostroi_775_Calibri30",144*2,320*2,Color(255, 255, 0, 255),1,1)
			if SpeedLimitNext < 21 then
				draw.SimpleText(NextNoFq and "ОЧ" or "0","Metrostroi_775_Calibri70b",144*2,360*2,Color(255, 255, 0, 255),1,1)
			else
				draw.SimpleText(SpeedLimitNext,"Metrostroi_775_Calibri70b",144*2,360*2,Color(255, 255, 0, 255),1,1)
			end
		end

		local wag_num = train:GetNW2Int("BKPU_WagNum", 0)

		local step = 31*2

		local data = NWJSON(train,"MFDU_P0D","[]")
		if not data then return end
		for i = 1, wag_num do

			local pos = 710*2 - (i-1)*step
			local offsetY = 40*2

			if train:GetNW2Bool('MFDU:0:0:0') then
				draw.SimpleText(wag_num-i+1,"Metrostroi_775_Calibri26",pos,60*2,color_white,1,1)
			end

			if train:GetNW2Bool('MFDU:0:0:1') then
				draw.SimpleText("Двери","Metrostroi_775_Calibri26",710*2-28 - (wag_num-1)*step,60*2+offsetY,color_white,2,1)
				draw.RoundedBox(8, pos-28, 40*2+offsetY, 29*2, 38*2, IC[train:GetNW2Int('MFDU:0:'..i..':1',0)])
			end

			if train:GetNW2Bool('MFDU:0:0:4') then
				draw.SimpleText("ПТ вкл.","Metrostroi_775_Calibri26",710*2-28 - (wag_num-1)*step,60*2+offsetY*4,color_white,2,1)
				draw.RoundedBox(8, pos-28, 40*2+offsetY*4, 29*2, 38*2, IC[train:GetNW2Int('MFDU:0:'..i..':4',0)])
			end

			if train:GetNW2Bool('MFDU:0:0:5') then
				draw.SimpleText("СТ тормоз","Metrostroi_775_Calibri26",710*2-28 - (wag_num-1)*step,60*2+offsetY*5,color_white,2,1)
				draw.RoundedBox(8, pos-28, 40*2+offsetY*5, 29*2, 38*2, IC[train:GetNW2Int('MFDU:0:'..i..':5',0)])
			end

			if train:GetNW2Bool('MFDU:0:0:6') then
				draw.SimpleText("ПСН","Metrostroi_775_Calibri26",710*2-28 - (wag_num-1)*step,60*2+offsetY*6,color_white,2,1)
				draw.RoundedBox(8, pos-28, 40*2+offsetY*6, 29*2, 38*2, IC[train:GetNW2Int('MFDU:0:'..i..':6',0)])
			end

			if train:GetNW2Bool('MFDU:0:0:7') then
				draw.SimpleText("Рессора","Metrostroi_775_Calibri26",710*2-28 - (wag_num-1)*step,60*2+offsetY*7,color_white,2,1)
				draw.RoundedBox(8, pos-28, 40*2+offsetY*7, 29*2, 38*2, IC[train:GetNW2Int('MFDU:0:'..i..':7',0)])
			end

			if train:GetNW2Int("MFDU_WagType_" .. (wag_num-i+1), 0) == 2 then goto cont end

			if train:GetNW2Bool('MFDU:0:0:2') then
				draw.SimpleText("Несбор схемы","Metrostroi_775_Calibri26",710*2-28 - (wag_num-1)*step,60*2+offsetY*2,color_white,2,1)
				draw.RoundedBox(8, pos-28, 40*2+offsetY*2, 29*2, 38*2, IC[train:GetNW2Int('MFDU:0:'..i..':2',0)])
			end

			if train:GetNW2Bool('MFDU:0:0:3') then
				draw.SimpleText("БВ","Metrostroi_775_Calibri26",710*2-28 - (wag_num-1)*step,60*2+offsetY*3,color_white,2,1)
				draw.RoundedBox(8, pos-28, 40*2+offsetY*3, 29*2, 38*2, IC[train:GetNW2Int('MFDU:0:'..i..':3',0)])
			end

			::cont::
		end
	end

	local function DoorsWindow(train)


		local int_cars = 36.6
		draw.SimpleText("Левые","Metrostroi_775_Calibri26",222*2,50*2+35,color_white,1,1)
		draw.RoundedBox(16,275*2, 50*2,65*2, 35*2,color_green)
		draw.SimpleText("Б","Metrostroi_775_Calibri20",275*2+65, 50*2+35,Color(0,0,0),1,1)
		draw.SimpleText("Правые","Metrostroi_775_Calibri26",638*2,50*2+35,color_white,1,1)
		draw.RoundedBox(16,510*2, 50*2,65*2, 35*2,color_green)
		draw.SimpleText("Б","Metrostroi_775_Calibri20",510*2+65, 50*2+35,Color(0,0,0),1,1)

		local wag_num = train:GetNW2Int("BKPU_WagNum", 0)

		for i = 1,wag_num do

			draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..i,0)),"Metrostroi_775_Calibri26",116*2,(110+i*int_cars)*2,color_white,1,1)

			for d = 1,11 do
				if train:GetNW2Int("MFDU_WagType_" .. i, 0) ~= 0 and (d == 1 or d == 6 or d == 11) then goto cont end


				local door_state = train:GetNW2Int('MFDU:21:'..i..':'..d,0)

				local color = color_white

				if door_state == 1 then
					color = color_red
				elseif door_state == 2 then
					color = Color(255, 255, 0)
				elseif door_state == 4 then
					color = color_green
				elseif door_state == 5 then
					color = color_red
				end

				draw.RoundedBox(16,(102+d*51)*2, (96+i*int_cars)*2,(50.5-4.5)*2, 31*2,color)
				if door_state == 5 then
					draw.SimpleText("А","Metrostroi_775_Calibri26",(102+d*51+23)*2,(96+i*int_cars+15.5)*2,Color(0,0,0),1,1)
				end

				::cont::
			end
		end
		local tableDoorTypes = {"М","1","2","3","4","Т","5","6","7","8","М"}
		for i = 1,#tableDoorTypes do
			draw.SimpleText(tableDoorTypes[i],"Metrostroi_775_Calibri28",(125+i*51)*2,107*2,color_gray4,1,1)
		end

	end

	local tp = {
		"СБОР СХЕМЫ",
		"БВ",
		"Отказ ИНВ",
		"Защита ИНВ",
		"Перег. ИНВ",
		"Отказ ЭТ"
	}

	local function TPWindow(train)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)
		local power_line_height = 330*2
		local power_line_x = 38*2
		local power_line_y = 70*2
		local w = 24*2
		local data = NWJSON(train,"MFDU_P31D","[]") or {}
		local Z = {0,0,0,0,0,0,0,0,0}
		for i=0,Wagons-1 do
			if train:GetNW2Int("MFDU_WagType_" .. i+1, 0) ~= 2 then
				draw.RoundedBox(0,power_line_x+w*i+58,power_line_y,w-2, power_line_height,Color(75,75,75))
				local p = (data[i+1] or Z)[7] > 0 and (data[i+1] or Z)[7] or (data[i+1] or Z)[8] > 0 and (data[i+1] or Z)[8]*-1 or 0
				surface.SetDrawColor(p < 0 and 255 or 0,255,0)
				surface.DrawRect(power_line_x+w*i+58,power_line_y+power_line_height/2,w-6,math.Clamp(p/21*-power_line_height/2,(power_line_height*-1)/2,power_line_height/2))
				Metrostroi.DrawRectOutline(power_line_x+w*i+58,power_line_y,w-2,power_line_height,Color(175,175,175),4)
				Metrostroi.DrawLine(power_line_x+w*i+58,power_line_y+power_line_height/2+1,power_line_x+w*i+58+w-2,power_line_y+power_line_height/2+1,Color(175,175,175),2)
				draw.RoundedBox(16,power_line_x+w*i+58+2,power_line_y+power_line_height+2,w-6,w+12,(data[i+1] or Z)[9] < 1 and Color(255,0,0) or Color(0,255,0))
				draw.SimpleText(i+1,'Metrostroi_775_Calibri26',power_line_x+w*i+58+w/2,power_line_y+power_line_height+(w+12)/2,Color(0,0,0), 1, 1)
				draw.SimpleText(0,'Metrostroi_775_Calibri22',power_line_x+w*i+58+w/2,power_line_y-30,Color(255,200,0), 1, 1)
			end
		end
		local th,tw = 786/8,50
		local x = 132+1326-250-32-tw*8
		for i = 1, 6 do
			draw.SimpleText(tp[i],'Metrostroi_775_Calibri15b',x,80+th*i+th/2,color_white, 2, 1)
		end
		for k = 1, Wagons do
			if train:GetNW2Int("MFDU_WagType_" .. k, 0) ~= 2 then
				draw.SimpleText(k,'Metrostroi_775_Calibri20b',x+tw*k-tw/2,80+th/2,color_white, 1, 1)
				for i = 1, 6 do
					draw.RoundedBox(16,x+tw*(k-1)+2,80+8+th*i,tw-4,th-16,IC[(data[k] or Z)[i]])
				end
			end
		end

		Metrostroi.DrawLine(power_line_x+w*Wagons+58,power_line_y,power_line_x+w*Wagons+58,power_line_y+power_line_height,Color(175,175,175),2)
		for i = 0, 10 do
			local y = power_line_y + (power_line_height/10)*i
			Metrostroi.DrawLine(power_line_x+w*Wagons+58-1,y,power_line_x+w*Wagons+58+20,y,Color(175,175,175),2)
			if i < 10 then
				Metrostroi.DrawLine(power_line_x+w*Wagons+58-1,y+((power_line_height/10)/3),power_line_x+w*Wagons+58+10,y+((power_line_height/10)/3),Color(175,175,175),2)
				Metrostroi.DrawLine(power_line_x+w*Wagons+58-1,y+((power_line_height/10)/1.5),power_line_x+w*Wagons+58+10,y+((power_line_height/10)/1.5),Color(175,175,175),2)
			end
			draw.SimpleText(100-i*20,'Metrostroi_775_Calibri14',power_line_x+w*Wagons+58+25,y,Color(175,175,175), 0, 1)

		end

		local btn_w = 250
		local btn_h = 780/6

		local recup = train:GetNW2Bool("MFDU:Recup", true)
		DrawButton(132+1326-btn_w-8, 80+btn_h*1-4, btn_w,btn_h-8,recup and "Рекуперация|включена" or "Рекуперация|отключена","Metrostroi_775_Calibri20b",recup and color_gray or color_gray3,recup and color_light_blue or color_gray2,recup and color_light_blue or color_gray)
		local storage = train:GetNW2Bool("MFDU:Storage", false)
		DrawButton(132+1326-btn_w-8, 80+btn_h*2-4, btn_w,btn_h-8,storage and "Откл работу|от накопителя" or "Вкл работу|от накопителя","Metrostroi_775_Calibri20b",storage and color_gray or color_gray3,storage and color_light_blue or color_gray2,storage and color_light_blue or color_gray)
		DrawButton(132+1326-btn_w-8, 80+btn_h*3-4, btn_w,btn_h-8,"Вкл режим|\"Плохая погода\"","Metrostroi_775_Calibri20b",data.p == 1 and  color_gray or color_gray3,data.p == 1 and  color_light_blue or color_gray2,data.p == 1 and  color_light_blue or color_gray)
		DrawButton(132+1326-btn_w-8, 80+btn_h*5-4, btn_w,btn_h-8,"Вкл. кон.|негаб. тележки","Metrostroi_775_Calibri20b",data.g == 1 and  color_gray or color_gray3,data.g == 1 and  color_light_blue or color_gray2,data.g == 1 and  color_light_blue or color_gray)
	end

	local vo = {
		[0] = "Параметр",
		"БУКСЫ",
		"МК",
		"Освещение",
		"ТКПР",
		"Напряжение КС",
		"ПСН",
		"Рессора",
		"БУПУ",
		"БУД",
		"АКБ",
		"Ориентация",
	}

	local VOst = {
		[0] = Color(255,255,255),
		[1] = Color(255,0,0),
		[2] = Color(0,255,0),
		[3] = Color(0,0,0,0),
	}

	local function VOWindow(train)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)

		local y = 62
		local x = 1002/8

		for i = 0, 11 do
			if i%2 == 0 then
				draw.RoundedBox(0,132+8,80+9+y*i,290,y,color_gray2)
			end
			local s = i == 1 or i == 4 or i == 8 or i == 9
			draw.SimpleText(vo[i],'Metrostroi_775_Calibri24b',132+290,80+8+y/2+y*i,s and color_light_blue or color_white, 2, 1)
			if i < 11 then
				Metrostroi.DrawLine(132+8,80+8+y*(i+1),132+8+290,80+8+y*(i+1),color_gray,2)
			end

			for k = 1, Wagons do
				local data = {
					train:GetNW2Int('MFDU:11:'..k..':BUKS',0),
					train:GetNW2Int('MFDU:11:'..k..':MK',0),
					train:GetNW2Int('MFDU:11:'..k..':Lights',0),
					train:GetNW2Int('MFDU:11:'..k..':TKPR',0),
					train:GetNW2Int('MFDU:11:'..k..':UKS',0),
					train:GetNW2Int('MFDU:11:'..k..':PSN',0),
					train:GetNW2Int('MFDU:11:'..k..':Res',0),
					train:GetNW2Int('MFDU:11:'..k..':BUPU',0),
					train:GetNW2Int('MFDU:11:'..k..':BUD',0),
					train:GetNW2Int('MFDU:11:'..k..':AKB',0),
				}
				if i == 0 then
					draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..k,0)),'Metrostroi_775_Calibri24b',132+316+x*(k-1)+62,80+10+y*i+y/2,color_white, 1, 1)
				elseif i < 11 then
					draw.RoundedBox(8,132+316+x*(k-1)+20,80+10+y*i,82,y-4,VOst[data[i]])
				else
					local orientate = train:GetNW2Bool("MFDU_Orientation" .. k)
					draw.SimpleText(orientate and "П" or "О",'Metrostroi_775_Calibri24b',132+316+x*(k-1)+62,80+10+y*i+y/2,orientate and Color(0,255,0) or Color(255,255,0), 1, 1)
				end
				if k < Wagons then
					Metrostroi.DrawLine(132+316+x*k,80+8,132+316+x*k,80+8+786-16,color_gray,2)
				end
			end
		end

		Metrostroi.DrawRectOutline(132+8,80+8,290,786-16,color_gray,2)
		Metrostroi.DrawRectOutline(132+316,80+8,x*Wagons,786-16,color_gray,2)
	end

	local function VO2Window(train,p)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)

		local pr = p%2==0 and 9 or 5
		local x = 1326/8
		local y = 780/math.max(6,pr)

		for k = 1, Wagons do
			for i = 1, pr do
				if i == 1 then
					draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..k,0)),'Metrostroi_775_Calibri30b',132-x/2+x*k,80+y-y/2,color_white, 1, 1)
				else
					local data = train:GetNW2Int('MFDU:1'..(p+1)..':'..k..':'..(i-1),0)
					draw.RoundedBox(16,132+x*(k-1)+40,75+y*(i-1),x-80,y-4,VOst[data] or Color(255,255,255))
				end
			end
		end
	end

	local vo2 = {
		[0] = "Параметр",
		"Всп. оборудование",
		"Двери",
		"Конд/ЭПРА каб.",
		"ЦИК/БВТ",
		"Освещение",
		"Управление осн.",
		"Антисон",
		{"РВТБ/КМ","БТБУ/СТ"},
		"Управ. резерв.",
	}
	local vo3 = {
		[0] = "Параметр",
		"Инвертор",
		"Управ. рез.",
		"Противоюз",
		"ПСН,Осушитель",
		"Счетчик",
		"ТКПР,БККЗ",
		"Подсвет. дверей",
		"Двери",
		"ЦИК",
		"ЭПРА",
		"Автоматы АКБ",
	}

	local function VO3Window(train)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)

		local y = 754/10
		local x = 1002/8

		for i = 0, 9 do
			if i%2 == 0 then
				draw.RoundedBox(0,132+8,80+9+y*i,290,y,color_gray2)
			end
			if i == 8 then
				draw.SimpleText(vo2[i][1],'Metrostroi_775_Calibri20b',132+290+6,80+8+y/4.5+y*i,color_white, 2, 1)
				draw.SimpleText(vo2[i][2],'Metrostroi_775_Calibri20b',132+290+6,80+8+y/1.4+y*i,color_white, 2, 1)
			else
				draw.SimpleText(vo2[i],'Metrostroi_775_Calibri20b',132+290+6,80+8+y/2+y*i,color_white, 2, 1)
			end
			if i < 9 then
				Metrostroi.DrawLine(132+8,80+8+y*(i+1),132+8+290,80+8+y*(i+1),color_gray,2)
			end

			if i == 0 then
			else
				draw.RoundedBox(16,132+308+11,80+10+y*i,y-8,y-4,IC[train:GetNW2Int('MFDU:16:0:'..i,0)])
			end
		end

		Metrostroi.DrawRectOutline(132+8,80+8,290,786-16,color_gray,2)
		Metrostroi.DrawRectOutline(132+308+4,80+8,y+15-8,786-16,color_gray,2)

		local y2 = 754/12
		local x2 = (1002-388)/8

		for i = 0, 11 do
			if i%2 == 0 then
				draw.RoundedBox(0,132+308+y+15+8,80+9+y2*i,290,y2,color_gray2)
			end
			draw.SimpleText(vo3[i],'Metrostroi_775_Calibri20b',132+308+x-30+290,80+8+y2/2+y2*i,color_white, 2, 1)
			if i < 11 then
				Metrostroi.DrawLine(132+308+y+15+8,80+8+y2*(i+1),132+308+y+15+8+290,80+8+y2*(i+1),color_gray,2)
			end

			for k = 1, Wagons do
				if i == 0 then
					draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..k,0)),'Metrostroi_775_Calibri16',132+308+306+y+15-x2/2+x2*k,80+10+y2*i+y2/2,color_white, 1, 1)
				else
					draw.RoundedBox(16,132+308+306+y+15+14+x2*(k-1),80+10+y2*i,y2-14,y2-4,IC[train:GetNW2Int('MFDU:16:'..k..':'..i,0)])
				end
				if k < Wagons then
					Metrostroi.DrawLine(132+308+306+y+15+x2*k,80+8,132+308+306+y+15+x2*k,80+8+786-16,color_gray,2)
				end
			end
		end

		Metrostroi.DrawRectOutline(132+308+y+15+8,80+8,290,786-16,color_gray,2)
		Metrostroi.DrawRectOutline(132+308+306+y+15,80+8,x2*Wagons,786-16,color_gray,2)

	end

	local pn = {
		[0] = "Параметр",
		"Экстрен. тормоз",
		"ПТ вкл.",
		"Ст. тормоз",
		"ДПБТ",
		"Скач. камера",
		"Торм. оборуд.",
		"Pтц1, Атм",
		"Pтц2, Атм",
		"Pнм, Атм",
		"Pтм, Атм",
		"Pст, Атм",
		"Pск, Атм",
	}

	local function PN1Window(train)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)

		local y = (786-32)/13
		local x = 1002/8

		for i = 0, 12 do
			if i%2 == 0 then
				draw.RoundedBox(0,132+8,80+9+y*i,290,y,color_gray2)
			end
			draw.SimpleText(pn[i],'Metrostroi_775_Calibri24b',132+290,80+8+y/2+y*i,i==4 and color_light_blue or color_white, 2, 1)
			if i < 11 then
				Metrostroi.DrawLine(132+8,80+8+y*(i+1),132+8+290,80+8+y*(i+1),color_gray,2)
			end

			for k = 1, Wagons do
				local data = {
					train:GetNW2Int('MFDU:51:'..k..':Emer',0),
					train:GetNW2Int('MFDU:51:'..k..':PT',0),
					train:GetNW2Int('MFDU:51:'..k..':PB',0),
					train:GetNW2Int('MFDU:51:'..k..':DPBT',0),
					train:GetNW2Int('MFDU:51:'..k..':SK',0),
					train:GetNW2Int('MFDU:51:'..k..':TO',0),
					train:GetNW2Int('MFDU:51:'..k..':BCp',0)/10,
					train:GetNW2Int('MFDU:51:'..k..':BCp',0)/10,
					train:GetNW2Int('MFDU:51:'..k..':TLp',0)/10,
					train:GetNW2Int('MFDU:51:'..k..':BLp',0)/10,
					train:GetNW2Int('MFDU:51:'..k..':PBp',0)/10,
					train:GetNW2Int('MFDU:51:'..k..':SKp',0)/10,
				}
				if i == 0 then
					draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..k,0)),'Metrostroi_775_Calibri24b',132+316+x*(k-1)+62,80+10+y*i+y/2,color_white, 1, 1)
				elseif i < 7 then
					draw.RoundedBox(8,132+316+x*(k-1)+20,80+15+y*i,82,y-15,IC[(i == 5 or i == 6) and 2 or data[i]])
				else
					if train:GetNW2Bool("MFDU_BUVNotWork" .. k) then
						draw.SimpleText("-",'Metrostroi_775_Calibri24b',132+316+x*(k-1)+62,80+10+y*i+y/2, (i == 9 or i == 10) and Color(255,0,0) or Color(0,255,0), 1, 1)
					else
						draw.SimpleText(Format("%.1f",data[i]),'Metrostroi_775_Calibri24b',132+316+x*(k-1)+62,80+10+y*i+y/2, (((i == 9 and data[i] < 6) or (i == 10 and data[i] < 3)) and  Color(255,0,0)) or Color(0,255,0), 1, 1)
					end
				end
				if k < Wagons then
					Metrostroi.DrawLine(132+316+x*k,80+8,132+316+x*k,80+8+786-16,color_gray,2)
				end
			end
		end

		Metrostroi.DrawRectOutline(132+8,80+8,290,786-16,color_gray,2)
		Metrostroi.DrawRectOutline(132+316,80+8,x*Wagons,786-16,color_gray,2)
	end

	local pn2 = {
		[0] = "Параметр",
		"Pавто1,АТМ",
		"Pавто2,АТМ",
		"Pавто3,АТМ",
		"Pавто4,АТМ",
		"Загрузка,%"
	}

	local function PN2Window(train)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)

		local line_height = 720
		local line_x = 140-6
		local line_y = 82
		for k = 1, Wagons do
			surface.SetDrawColor(color_gray2)
			surface.DrawRect(line_x+52*(k-1), line_y, 50, line_height)
			surface.SetDrawColor(255,255,0)
			surface.DrawRect(line_x+52*(k-1), line_y+line_height, 50, (line_height/100)*train:GetNW2Int('MFDU:52:'..k..':WL',0)*-1)
			draw.SimpleText(k,'Metrostroi_775_Calibri18',132+25+52*(k-1),line_y+line_height+30,color_white, 1, 1)
			if k < Wagons then
				Metrostroi.DrawLine(133+52*k,80,133+52*k,80+786,color_gray,2)
			end
		end
		Metrostroi.DrawLine(132+52*Wagons+6,90,132+52*Wagons+6,80+line_height,color_gray,2)
		local yo = (line_height-10)/10
		for i = 0, 10 do
			Metrostroi.DrawLine(132+52*Wagons+5,90+yo*i,132+52*Wagons+6+16,90+yo*i,color_gray,2)
			draw.SimpleText(100-10*i,'Metrostroi_775_Calibri10',132+52*Wagons+6+16,90+yo*i-2,color_gray, 0, 1)
			if i < 10 then
				Metrostroi.DrawLine(132+52*Wagons+5,90+yo*i+yo/3,132+52*Wagons+6+10,90+yo*i+yo/3,color_gray,2)
				Metrostroi.DrawLine(132+52*Wagons+5,90+yo*i+yo/1.5,132+52*Wagons+6+10,90+yo*i+yo/1.5,color_gray,2)
			end
		end

		local y = (786-32)/8
		local x = 650/8

		for i = 0, 5 do
			if i%2 == 0 then
				draw.RoundedBox(0,132+408+y-20,80+9+y*i,170,y,color_gray2)
				draw.RoundedBox(0,132+408+y-20+170+16,80+9+y*i,x*Wagons,y,color_gray2)
			end
			draw.SimpleText(pn2[i],'Metrostroi_775_Calibri18',132+408+y-22+170,80+8+y/2+y*i,color_white, 2, 1)
			Metrostroi.DrawLine(132+408+y-20,80+8+y*(i+1),132+408+y-20+170,80+8+y*(i+1),color_gray,2)

			for k = 1, Wagons do
				local data = {
					train:GetNW2Int('MFDU:52:'..k..':R1',0),
					train:GetNW2Int('MFDU:52:'..k..':R2',0),
					train:GetNW2Int('MFDU:52:'..k..':R3',0),
					train:GetNW2Int('MFDU:52:'..k..':R4',0),
					train:GetNW2Int('MFDU:52:'..k..':WL',0),
				}
				if i == 0 then
					draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..k,0)),'Metrostroi_775_Calibri18',132+408+y-20+170+16+x*(k-1)+x/2,80+10+y*i+y/2,color_white, 1, 1)
				else
					draw.SimpleText(Format(i==5 and "%d" or "%.1f",data[i]),'Metrostroi_775_Calibri18',132+408+y-20+170+16+x*(k-1)+x/2,80+10+y*i+y/2,Color(0,255,0), 1, 1)
				end
				if k < Wagons then
					Metrostroi.DrawLine(132+408+y-20+170+16+x*k,80+8,132+408+y-20+170+16+x*k,80+8+786-16,color_gray,2)
				end
			end
		end

		Metrostroi.DrawRectOutline(132+408+y-20,80+8,170,786-16,color_gray,2)
		Metrostroi.DrawRectOutline(132+408+y-20+170+16,80+8,x*Wagons,786-16,color_gray,2)
	end

	local ee = {
		[0] = "Параметр",
		"Uкс,В",
		"Uбс,В",
		"Uзу,В",
		"Iмк,А",
		"Iтп,А",
		"Iзу,А",
		"Iво,А",
		"Iакб,А",
		"Uакб,В",
		"Iво(Адув),В",
	}

	local function EEWindow(train)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)

		local y = (786-32)/11
		local x = 1002/8

		for i = 0, 10 do
			if i%2 == 0 then
				if i < 10 then
					draw.RoundedBox(0,132+8,80+9+y*i,290,y,color_gray2)
				end
			else
				draw.RoundedBox(0,132+316,80+9+y*i,x*Wagons,y,color_gray2)
			end
			draw.SimpleText(ee[i],'Metrostroi_775_Calibri24b',132+290,80+8+y/2+y*i,color_white, 2, 1)
			if i < 10 then
				Metrostroi.DrawLine(132+8,80+8+y*(i+1),132+8+290,80+8+y*(i+1),color_gray,2)
			end

			for k = 1, Wagons do
				local data = {
					train:GetNW2Int('MFDU:41:'..k..':UKS',0),
					train:GetNW2Int('MFDU:41:'..k..':UBS',0),
					train:GetNW2Int('MFDU:41:'..k..':UZU',0),
					train:GetNW2Int('MFDU:41:'..k..':IMK',0),
					train:GetNW2Int('MFDU:41:'..k..':ITP',0),
					train:GetNW2Int('MFDU:41:'..k..':IZU',0),
					train:GetNW2Int('MFDU:41:'..k..':IVO',0),
					train:GetNW2Int('MFDU:41:'..k..':IAKB',0),
					train:GetNW2Int('MFDU:41:'..k..':UAKB',0),
					train:GetNW2Int('MFDU:41:'..k..':UADUV',0),
				}
				if i == 0 then
					draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..k,0)),'Metrostroi_775_Calibri24b',132+316+x*(k-1)+62,80+10+y*i+y/2,color_white, 1, 1)
				elseif i == 1 and train:GetNW2Int("MFDU_WagType_" .. k, 0) == 2 then
					draw.RoundedBox(0,132+316+x*(k-1),80+9+y*i,x,y,Color(0,0,0))
					draw.RoundedBox(0,132+316+x*(k-1),80+9+y*i,x,y,Color(82,89,137, 5))
					draw.RoundedBox(8,132+316+x*(k-1)+20,80+16+y*i,82,y-16,Color(data[i] < 550 and 255 or 0,data[i] >= 550 and 255 or 0,0))
				elseif train:GetNW2Int("MFDU_WagType_" .. k, 0) == 2 and (i == 5 or i == 4) then
					draw.RoundedBox(0,132+316+x*(k-1),80+9+y*i,x,y,Color(0,0,0))
					draw.RoundedBox(0,132+316+x*(k-1),80+9+y*i,x,y,Color(82,89,137, 5))
				elseif train:GetNW2Bool("MFDU_BUVNotWork" .. k) then
					draw.SimpleText("-",'Metrostroi_775_Calibri24b',132+316+x*(k-1)+62,80+10+y*i+y/2,Color(0,255,0), 1, 1)
				else
					draw.SimpleText(Format(i==9 and "%.1f" or "%d",data[i] or 0),'Metrostroi_775_Calibri24b',132+316+x*(k-1)+62,80+10+y*i+y/2,Color(0,255,0), 1, 1)
				end
				if k < Wagons then
					Metrostroi.DrawLine(132+316+x*k,80+8,132+316+x*k,80+8+786-16,color_gray,2)
				end
			end
		end

		Metrostroi.DrawRectOutline(132+8,80+8,290,786-16,color_gray,2)
		Metrostroi.DrawRectOutline(132+316,80+8,x*Wagons,786-16,color_gray,2)
	end

	local kl1 = {
		[0] = "Параметр",
		"Кондиционер 1",
		"Кондиционер 2",
		"Кондиционер К",
		"Фактическая К t, °C",
		"Заданная К t, °C",
		"Фактическая С t, °C",
		"Заданная С t, °C",
	}
	local climGreen, climRed = Color(30,235,30), Color(255,70,20)
	local climBand = Color(32,38,60)

	local function Kl1Window(train, mfdu)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)

		local y = ((786-50)/2)/8
		local x = 1002/8

		for i = 0, 7 do
			if i%2 == 0 then
				draw.RoundedBox(0,132+8,80+9+y*i,290,y,color_gray2)
			end
			draw.SimpleText(kl1[i],'Metrostroi_775_Calibri20b',132+290,80+8+y/2+y*i,color_white, 2, 1)
			if i < 7 then
				Metrostroi.DrawLine(132+8,80+8+y*(i+1),132+8+290,80+8+y*(i+1),color_gray,2)
			end

			for k = 1, Wagons do
				local cx = 132+316+x*(k-1)
				if i == 0 then
					draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..k,0)),'Metrostroi_775_Calibri24b',cx+62,80+10+y*i+y/2,color_white, 1, 1)
				else
					local v = train:GetNW2Int("MFDU:61:"..k..":"..i, i < 4 and 0 or -999)
					if i < 4 then
						if v > 0 then
							draw.RoundedBox(8,cx+20,80+10+y*i+6,82,y-14,v == 2 and climGreen or climRed)
						end
					else
						if (i == 5 or i == 7) and v ~= -999 then
							draw.RoundedBox(0,cx+2,80+9+y*i,x-4,y,climBand)
						end
						if v ~= -999 then
							draw.SimpleText(Format("%d",v),'Metrostroi_775_Calibri24b',cx+62,80+10+y*i+y/2,Color(0,255,0), 1, 1)
						end
					end
				end
				if i == 0 and k < Wagons then
					Metrostroi.DrawLine(132+316+x*k,80+8,132+316+x*k,80+8+(786-20)/2,color_gray,2)
				end
			end
		end

		local out = train:GetNW2Int("MFDU:61:Out", -999)
		local cx = 132+1326/2
		draw.SimpleText(out == -999 and "Внешняя температура - °C" or Format("Внешняя температура %d °C",out),'Metrostroi_775_Calibri30b',cx,80+560,color_white, 1, 1)

		local leto = train:GetNW2Bool("MFDU:CondLeto", true)
		local act = train:GetNW2Int("MFDU:61:Act", 0)
		local label = leto and (act == 2 and "Лето охлаждение" or act == 1 and "Лето вентиляция" or "Лето")
		                    or (act == 3 and "Зима обогрев" or "Зима")
		draw.SimpleText("Режим :",'Metrostroi_775_Calibri30b',cx-30,80+680,Color(170,200,255), 2, 1)
		surface.SetDrawColor(255,255,255,255)
		mfdu:SetTexture(leto and "state5_6" or "state5_8")
		mfdu:DrawTexture(cx+10,80+680,58,58,true)
		draw.SimpleText(label,'Metrostroi_775_Calibri30b',cx+50,80+680,Color(170,200,255), 0, 1)

		Metrostroi.DrawRectOutline(132+8,80+8,290,(786-20)/2,color_gray,4)
		Metrostroi.DrawRectOutline(132+316,80+8,x*Wagons,(786-20)/2,color_gray,4)
	end

	local kl2 = {
		[0] = "Параметр",
		"Лето",
		"Вентиляция",
		"Обогрев",
		"Охлаждение",
		"Ошибка вентиляции",
		"Ошибка обогрева",
		"Ошибка охлаждения",
		"Отказ",
		"Эпра(ваг.)",
		"Эпра(каб.)",
	}

	local function Kl2Window(train, mfdu)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)

		local y = (786-40)/11
		local x = 984/8

		for i = 0, 10 do
			if i%2 == 0 then
				draw.RoundedBox(0,132+8,80+9+y*i,310,y,color_gray2)
			end
			draw.SimpleText(kl2[i],'Metrostroi_775_Calibri20b',132+313,80+8+y/2+y*i,color_white, 2, 1)
			if i < 10 then
				Metrostroi.DrawLine(132+8,80+8+y*(i+1),132+8+310,80+8+y*(i+1),color_gray,2)
			end

			for k = 1, Wagons do
				local cx = 132+334+x*(k-1)
				if i == 0 then
					draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..k,0)),'Metrostroi_775_Calibri24b',cx+62,80+10+y*i+y/2,color_white, 1, 1)
				else
					local v = train:GetNW2Int("MFDU:62:"..k..":"..i, 0)
					if v > 0 then
						local c = v == 2 and climGreen or climRed
						if i == 10 then
							draw.RoundedBox(10,cx+20-4,80+10+y*i+6,82+8,y-14,c)
						else
							draw.RoundedBox(10,cx+20-4,80+10+y*i+6,82/2,y-14,c)
							draw.RoundedBox(10,cx+20+82/2+4,80+10+y*i+6,82/2,y-14,c)
						end
					end
				end
				if i == 0 and k < Wagons then
					Metrostroi.DrawLine(132+334+x*k,80+8,132+334+x*k,80+8+786-16,color_gray,2)
				end
			end
		end

		Metrostroi.DrawRectOutline(132+8,80+8,310,786-16,color_gray,4)
		Metrostroi.DrawRectOutline(132+334,80+8,x*Wagons,786-16,color_gray,4)
	end

	local awp = {
		[0] = "Параметр",
		"Сообщение 1",
		"Сообщение 2",
		"Сообщение 3",
	}
	local awp2 = {
		[0] = "Состояние режима АВП:",
		"Режимы АВП:",
		"Режим КОС:",
		"Режим ПРОСТ:",
	}

	local cmds = {}
	for y = 1, 3 do
		cmds[y] = {}
		for x = 1, 8 do
			cmds[y][x] = math.random(0,255)
		end
	end
	local function AWPWindow(train)
		local Wagons = train:GetNW2Int("BKPU_WagNum", 0)
		local y = ((786-20)/3.5)/4
		local x = 1084/8
		for i = 0, 3 do
			if i%2 == 0 then
				draw.RoundedBox(0,132+8,80+9+y*i,210,y,color_gray2)
				draw.RoundedBox(0,132+234,80+9+y*i,x*8,y,color_gray2)
			end
			draw.SimpleText(awp[i],'Metrostroi_775_Calibri20b',132+210,80+8+y/2+y*i,color_white, 2, 1)
			if i < 3 then
				Metrostroi.DrawLine(132+8,80+8+y*(i+1),132+8+210,80+8+y*(i+1),color_gray,2)
				Metrostroi.DrawLine(132+234,80+8+y*(i+1),132+234+x*8,80+8+y*(i+1),color_gray,2)
			end
			for k = 1, Wagons do
				if i == 0 then
					draw.SimpleText(k,'Metrostroi_775_Calibri24b',132+234+x*(k-1)+62,80+10+y*i+y/2,color_white, 1, 1)
				else
					draw.SimpleText(Format("%02x",cmds[i][k]),'Metrostroi_775_Calibri24b',132+234+x*(k-1)+62,80+10+y*i+y/2,color_white, 1, 1)
				end
				if k < Wagons then
					Metrostroi.DrawLine(132+234+x*k,80+8,132+234+x*k,80+8+(786-20)/3.5,color_gray,2)
				end
			end
		end

		local y2 = (786-(786-20)/3.5-40)/4
		for i = 0, 1 do
			for k = 0, 3 do
				if k > 0 then
					local s = train:GetNW2Bool('MFDU:71:'..k)
					draw.RoundedBox(s and 16 or 0,132+1326/2.5+(256+4)*i,80+8+(786-20)/3.5+25+y2*k,512/2-8,y2-16,s and  ((i == 0 and k ~=1) and color_red or color_green) or color_gray2)
					draw.SimpleText(k == 1 and (i == 0 and "норма" or "нагон") or (i == 0 and "выкл" or "вкл"),'Metrostroi_775_Calibri20b',132+1326/2.5+(256+4)*i+(512/2-8)/2,80+8+(786-20)/3.5+25+y2*k+(y2-16)/2,s and color_black or color_white, 1, 1)
				else
					draw.RoundedBox(16,132+1326/2.5-8,80+8+(786-20)/3.5+20,512+16,y2,color_gray2)
					draw.SimpleText("активен",'Metrostroi_775_Calibri24b',132+1326/2.5+256,80+8+(786-20)/3.5+20+y2/2,color_white, 1, 1)
				end
				if i == 0 then
					draw.SimpleText(awp2[k],'Metrostroi_775_Calibri22',132+1326/2.5-8,80+8+(786-20)/3.5+25+y2*k+y2/2,color_white, 2, 1)
				end
			end
		end

		Metrostroi.DrawRectOutline(132+8,80+8,210,(786-20)/3.5,color_gray,2)
		Metrostroi.DrawRectOutline(132+234,80+8,x*8,(786-20)/3.5,color_gray,2)
	end

	local function ShWindow(train)
		local y = (778-124)/17
		for i = 1, 16 do
			Metrostroi.DrawLine(132+16,80+16+y*i,132+1326-16,80+16+y*i,color_gray3,4)
		end
		local x1,x2,x3,x4 = y,430,750,1000
		draw.SimpleText("Станция","Metrostroi_775_Calibri20b",132+16+x2-x2/2+y,80+16+y-y/2,color_gray3,1,1)
		draw.SimpleText("Время отравления","Metrostroi_775_Calibri20b",132+16+x3-x2/2+y*1.5,80+16+y-y/2,color_gray3,1,1)
		draw.SimpleText("Время стоянки","Metrostroi_775_Calibri20b",132+16+x4-x2/2+y*2.25,80+16+y-y/2,color_gray3,1,1)
		draw.SimpleText("Дополнительно","Metrostroi_775_Calibri20b",132+16+x4+(1326-32-x4)/2,80+16+y-y/2,color_gray3,1,1)
		Metrostroi.DrawLine(132+16+x1,80+16,132+16+x1,80+16+y*17,color_gray3,4)
		Metrostroi.DrawLine(132+16+x2,80+16,132+16+x2,80+16+y*17,color_gray3,4)
		Metrostroi.DrawLine(132+16+x3,80+16,132+16+x3,80+16+y*17,color_gray3,4)
		Metrostroi.DrawLine(132+16+x4,80+16,132+16+x4,80+16+y*17,color_gray3,4)
		Metrostroi.DrawRectOutline(132+16,80+16,1326-32,778-124,color_gray3,4)
		local y2 =(1326-8)/6
		for i = 1, 4 do
			Metrostroi.DrawRectOutline(132+16+y2*i,80+778-30-32,y2-4,64,color_gray3,4)
			local t = i == 1 and "Начало" or i == 2 and "↑" or i == 3 and "↓" or "Конец"
			draw.SimpleText(t,"Metrostroi_775_Calibri20b",132+16+y2*i+y2/2,80+778-30,color_gray3,1,1)
		end
	end
	local function debugWindow(train)
		for i = 1, 6 do
			local tbl = NWJSON(train,"MFDU_DeBug"..i,"[]")
			local y = 0
			for k, v in pairs(tbl) do
				draw.SimpleText(Format("%s: %s",k,v),"Metrostroi_775_Calibri14",150+200*(i-1),100+y,Color(255,255,255),0,1)
				y = y + 30
			end
		end
	end

	local PVUs = {
		"Двери",
		"МК",
		"Свет",
		"ТкПр",
		"ТП",
		"ПСН",
		"БВ"
	}

	local PVSst = {
		[0] = {color_gray,color_white},
		[1] = {color_gray,color_green},
		[2] = {color_gray,color_red},
		[3] = {color_red,color_white},
		[4] = {color_red,color_green},
		[5] = {color_red,color_red},
	}

	local function drawPVUBtn(x,y,s,w,h,wt)
		if wt == 2 and (y == 1 or y == 4 or y == 6) then return end
		Metrostroi.DrawRectOutline(135+(w+2)*x,150+(h+2)*y,w,h,PVSst[s][1],s < 3 and 3 or 12)
		draw.SimpleText(PVUs[y+1],"Metrostroi_775_Calibri22b",135+(w+2)*x+w/2,150+(h+2)*y+h/2,PVSst[s][2],1,1)
	end

local function PVUWindow(train)
    local Wagons = train:GetNW2Int("BKPU_WagNum", 0)
    local w,h = 163,100
    for x = 0, Wagons-1 do
        local wagonIndex = x + 1
        draw.SimpleText(Format("%05d",train:GetNW2Int("MFDU_WagonNumber"..wagonIndex,0)),'Metrostroi_775_Calibri24b',135+(w+2)*x+w/2,120,color_white, 1, 1)
        for y = 0, 6 do
            local pvuState = train:GetNW2Int('MFDU:1:'..wagonIndex..':'..(y+1), 0)
            drawPVUBtn(x, y, pvuState, w, h, train:GetNW2Int("MFDU_WagType_" .. wagonIndex, 0))
        end
    end
end

	function TRAIN_SYSTEM:DrawMainMenu(train, state, window)

		if window == 0 then
			MainWindow(train)
		elseif window == 1 then
			PVUWindow(train)
		elseif window == 11 then
			VOWindow(train)
		elseif window == 12 then
			VO2Window(train,1)
		elseif window == 13 then
			VO2Window(train,2)
		elseif window == 14 then
			VO2Window(train,3)
		elseif window == 15 then
			VO2Window(train,4)
		elseif window == 16 then
			VO3Window(train)
		elseif window == 21 then
			DoorsWindow(train)
		elseif window == 31 then
			TPWindow(train)
		elseif window == 41 then
			EEWindow(train)
		elseif window == 51 then
			PN1Window(train)
		elseif window == 52 then
			PN2Window(train)
		elseif window == 61 then
			Kl1Window(train, self)
		elseif window == 62 then
			Kl2Window(train, self)
		elseif window == 71 then
			AWPWindow(train)
		elseif window == 72 then
			ShWindow(train)
		else
			debugWindow(train)
		end

		local decoder = self.Train:GetNW2Bool("MFDU:TwoToSix")
		local speed = train:GetNW2Int("MFDU_Speed",0)
		local speed_limit = self.Train:GetNW2Int("MFDU:SpeedLimit")
		local speed_limit_next = self.Train:GetNW2Int("MFDU:NextLimit")
		local Och = self.Train:GetNW2Bool("MFDU:Och")
		local Zero = self.Train:GetNW2Bool("MFDU:Zero")
		if window == 0 then
			draw.SimpleText("U бс min","Metrostroi_775_Calibri20b",38*2,448*2,color_white,1,1)
			draw.SimpleText("U бс max","Metrostroi_775_Calibri20b",112*2,448*2,color_white,1,1)
			draw.SimpleText("U кс min","Metrostroi_775_Calibri20b",38*2,488*2,color_white,1,1)
			draw.SimpleText("U кс max","Metrostroi_775_Calibri20b",112*2,488*2,color_white,1,1)

			local bs_min = self.Train:GetNW2Int("MFDU_UBSmin")
			local bs_max = self.Train:GetNW2Int("MFDU_UBSmax")

			local ks_min = self.Train:GetNW2Int("MFDU_HVmin")
			local ks_max = self.Train:GetNW2Int("MFDU_HVmax")

			local c = (bs_min < 63 or bs_max < 63) and Color(255, 0, 0, 255) or Color(255, 255, 0, 255)
			draw.SimpleText(bs_min,"Metrostroi_775_Calibri24b",38*2,468*2,c,1,1)
			draw.SimpleText(bs_max,"Metrostroi_775_Calibri24b",112*2,468*2,c,1,1)
			draw.SimpleText(ks_min,"Metrostroi_775_Calibri24b",38*2,508*2,Color(255, 255, 0, 255),1,1)
			draw.SimpleText(ks_max,"Metrostroi_775_Calibri24b",112*2,508*2,Color(255, 255, 0, 255),1,1)

			draw.SimpleText("В","Metrostroi_775_Calibri22b",38*2,530*2,color_white,1,1)
			draw.SimpleText("В","Metrostroi_775_Calibri22b",112*2,530*2,color_white,1,1)
		else

			draw.SimpleText("V доп","Metrostroi_775_Roboto18r",28*2,490*2,Color(255, 0, 0, 255),1,1)
			draw.SimpleText((Och or Zero) and "ОЧ" or speed_limit,"Metrostroi_775_Calibri26",28*2,525*2,Color(255, 0, 0, 255),1,1)
			if decoder then
				draw.SimpleText("V пред","Metrostroi_775_Roboto18r",120*2,490*2,Color(255, 255, 0, 255),1,1)

				draw.SimpleText((Och or Zero) and "ОЧ" or speed_limit_next,"Metrostroi_775_Calibri26",125*2,525*2,Color(255, 255, 0, 255),1,1)
			end

			draw.SimpleText("км/ч","Metrostroi_775_Calibri22",75*2,525*2,Color(220,220,220),1,1)

			draw.SimpleText(decoder and "Режим  2/6" or "Режим  1/5","Metrostroi_775_Roboto18r",80*2,458*2,color_gray4,1,1)
			draw.SimpleText(math.floor(speed),"Metrostroi_775_Calibri26",75*2,490*2,Color(0, 255, 0, 255),1,1)
		end

		draw.SimpleText("P нм","Metrostroi_775_Calibri20b",690*2,448*2,color_white,1,1)
		draw.SimpleText("P тм","Metrostroi_775_Calibri20b",760*2,448*2,color_white,1,1)
		draw.SimpleText("P тц min","Metrostroi_775_Calibri20b",690*2,488*2,color_white,1,1)
		draw.SimpleText("P тц max","Metrostroi_775_Calibri20b",760*2,488*2,color_white,1,1)

		local p_nm = train:GetNW2Float("MFDU_TLPressure")
		local p_tm = train:GetNW2Float("MFDU_BLPressure")
		local tc_min = train:GetNW2Int("MFDU_BCmin",0)/10
		local tc_max = train:GetNW2Int("MFDU_BCmax",0)/10

		draw.SimpleText(Format("%.1f",p_nm),"Metrostroi_775_Calibri24b",690*2,468*2,Color(10, 255, 255, 255),1,1)
		draw.SimpleText(Format("%.1f",p_tm),"Metrostroi_775_Calibri24b",760*2,468*2,Color(10, 255, 255, 255),1,1)
		draw.SimpleText(Format("%.1f",tc_min),"Metrostroi_775_Calibri24b",690*2,508*2,Color(10, 255, 255, 255),1,1)
		draw.SimpleText(Format("%.1f",tc_max),"Metrostroi_775_Calibri24b",760*2,508*2,Color(10, 255, 255, 255),1,1)

		draw.SimpleText("АТМ","Metrostroi_775_Calibri22b",690*2,530*2,color_white,1,1)
		draw.SimpleText("АТМ","Metrostroi_775_Calibri22b",760*2,530*2,color_white,1,1)
	end
	local windows = {
		[0] = "Основной экран",
		[1] = "Повагонное управление",
		[11] = "Вагонное оборудование",
		[12] = "УККЗ",
		[13] = "ДПБТ",
		[14] = "Токоприемники",
		[15] = "Буксы",
		[16] = "Автоматы",
		[21] = "Двери",
		[31] = "Тяговый привод",
		[41] = "Электрическая энергия",
		[51] = "Пневматическая система",
		[52] = "Пневматическая система",
		[61] = "Климатическая система",
		[62] = "Климатическая система",
		[71] = "Автоведение",
		[72] = "Расписание",
		[91] = "Диагностика",
		[92] = "Диагностика(Ethernet)",
		[93] = "БУД",
		[94] = "БУПУ",
		[95] = "Выбор теста",
		[96] = "Состояние АСОТП(Игла)",
		[97] = "Экран ЗУНЭТ",
		[98] = "Информация от ЭЭ",
		[99] = "Информация от БУТП",
	}
	local fb = {
		[0]="Начало",
		"Конец",
		nil,
		nil,
		"▲",
		"▼",
		nil,
		nil,
		nil,
		"Обратно"
	}
	function TRAIN_SYSTEM:Failures(Train)
		local x = (scr_w)/10
		for i = 0, 9 do
			if fb[i] then
				DrawButton(x*i+1, 533*2, x-2, 63*2,fb[i],i>3 and i<6 and "Metrostroi_775_Calibri40" or "Metrostroi_775_Calibri24b",color_white,color_gray,color_gray3)
			end
		end
		local rows = {}
		for k = 1, 18 do
			local row = Train:GetNW2String("MFDU:JRow"..k, "")
			if row == "" then break end
			local e = CachedJSON(Train, k, row)
			if not e then break end
			rows[k] = e
		end
		local selRow = math.Clamp(Train:GetNW2Int("MFDU:JSel", 1), 1, math.max(1,#rows))
		local e = rows[selRow]
		local cGreen, cRed = Color(0,225,0), Color(255,40,40)
		if e then
			draw.SimpleText("Возник:",'Metrostroi_775_Calibri30',300,1016,Color(225,225,225), 2, 1)
			draw.SimpleText(os.date("%X", e[1]),'Metrostroi_775_Calibri30',308,1016,e[4] and cGreen or cRed, 0, 1)
			if e[4] then
				draw.SimpleText("Устранен:",'Metrostroi_775_Calibri30',970,1016,Color(225,225,225), 2, 1)
				draw.SimpleText(os.date("%X", e[4]),'Metrostroi_775_Calibri30',986,1016,cGreen, 0, 1)
			else
				draw.SimpleText("Не устранен",'Metrostroi_775_Calibri30',980,1016,cRed, 1, 1)
			end
		else
			draw.SimpleText("Журнал пуст",'Metrostroi_775_Calibri30',980,1016,Color(225,225,225), 1, 1)
		end

		draw.SimpleText("Дата",					'Metrostroi_775_Calibri20b',70,		24,Color(255,255,255), 1, 1)
		draw.SimpleText("Время",				'Metrostroi_775_Calibri20b',140+75,	24,Color(255,255,255), 1, 1)
		draw.SimpleText("Тип",					'Metrostroi_775_Calibri20b',330,	24,Color(255,255,255), 1, 1)
		draw.SimpleText("Описание сообщения",	'Metrostroi_775_Calibri20b',1000,	24,Color(255,255,255), 1, 1)
		local y = (scr_h-225-48)/18

		for i = 0, 17 do
			local e = rows[i+1]
			if not e then break end
			local c = e[2] == 1 and Color(255,60,60) or e[2] == 2 and Color(255,255,60) or Color(80,200,255)
			local yy = 48+y/2+y*i
			local isSel = (i+1) == selRow
			if isSel then
				surface.SetDrawColor(30,180,210,255)
				surface.DrawRect(8, 48+y*i+3, scr_w-16, y-4)
				c = Color(0,0,0)
			end
			draw.SimpleText(os.date("%d.%m.%y", e[1]),'Metrostroi_775_Calibri20b',70,yy,isSel and c or Color(255,255,255), 1, 1)
			draw.SimpleText(os.date("%X", e[1]),'Metrostroi_775_Calibri20b',140+75,yy,isSel and c or Color(255,255,255), 1, 1)
			draw.SimpleText(({"А","Б","В"})[e[2]] or "",'Metrostroi_775_Calibri20b',330,yy,c, 1, 1)
			draw.SimpleText(e[3],'Metrostroi_775_Calibri20b',364,yy,isSel and c or (e[4] and color_gray or Color(255,255,255)), 0, 1)
		end

		Metrostroi.DrawLine(6,	48,	1594,	48,	color_gray3,6)
		Metrostroi.DrawLine(140,4,	140,	976,color_gray3,6)
		Metrostroi.DrawLine(300,4,	300,	976,color_gray3,6)
		Metrostroi.DrawLine(360,4,	360,	976,color_gray3,6)
		Metrostroi.DrawRectOutline(2,2,scr_w-4,scr_h-225,color_gray3,6)
	end

	local lb = {
		[0]="Диаг.",
		"Диаг.(Eth.)",
		"БУД",
		"БУПУ",
		"Тест",
		"АСОТП",
		"НЭ",
		"ЭЭ",
		"БУТП",
		"Обратно"
	}

	function TRAIN_SYSTEM:Diagnostic(Train,window)
		local x = (scr_w)/10
		for i = 0, 9 do
			DrawButton(x*i+1, 550*2, x-2, 48*2,lb[i],"Metrostroi_775_Calibri16",color_white,color_gray,color_gray3)
		end

		draw.SimpleText(windows[window],"Metrostroi_775_Roboto32b",800,28*2,Color(255,255,255),1,1)
		Metrostroi.DrawRectOutline(2,2,1598,100,Color(255,255,255),2)

	end

	function TRAIN_SYSTEM:DrawMain(train, state,dT)

		local window = train:GetNW2Int("MFDU_Window",0)
		local line = tostring(Metrostroi.ANNOUNCER_MAP_775[train:GetNW2Int("BNT:Line")].fname)

		local state2 = train:GetNW2Int("MFDU_State2", 0)
		if state2 == 0 then
			self:DrawMainBox({line,windows[window]}, train, state,window,dT)
			self:DrawMainMenu(train, state,window)
		elseif state2 == 1 then
			self:Failures(train)
		else
			self:Diagnostic(train,window)
		end
	end

	local function pawd(pwd)
		pwd =  #pwd == 0 and "00000" or #pwd == 1 and pwd.."0000" or #pwd == 2 and pwd.."000" or #pwd == 3 and pwd.."00" or #pwd == 4 and pwd.."0" or pwd
		return pwd
	end

	local keyboard = {
		{"1","2","3"},
		{"4","5","6"},
		{"7","8","9"},
		{"C","0","OK"},
	}
	local function Depot(train)
		local state = train:GetNW2Int("MFDU_StateDepot",0)
		if state ~= 2 and state < 7 then
			draw.SimpleText("РЕЖИМ ДЕПО","Metrostroi_775_Roboto32b",340*2,28*2,Color(255,255,255),1,1)
			local time = os.date("!%X", Metrostroi.GetSyncTime())
			local date = os.date("!%d.%m.%Y", Metrostroi.GetSyncTime())

			draw.SimpleText(time,"Metrostroi_775_Roboto28b",270*2,507*2+8,color_white,1,1)
			draw.SimpleText(date,"Metrostroi_775_Roboto28b",604*2,507*2+8,color_white,1,1)

			if state == 6 then
				DrawButton((4+66*0)*2, 	533*2, 64*2, 63*2,"1","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*1)*2, 	533*2, 64*2, 63*2,"2","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*2)*2, 	533*2, 64*2, 63*2,"3","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*3)*2, 	533*2, 64*2, 63*2,"4","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*4)*2, 	533*2, 64*2, 63*2,"5","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*5)*2, 	533*2, 64*2, 63*2,"6","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*6)*2, 	533*2, 64*2, 63*2,"7","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*7)*2, 	533*2, 64*2, 63*2,"8","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*8)*2, 	533*2, 64*2, 63*2,"9","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*9)*2, 	533*2, 64*2, 63*2,"0","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*10)*2, 533*2, 64*2, 63*2,"C","Metrostroi_775_Calibri26",color_white)
				DrawButton((4+66*11)*2, 533*2, 64*2, 63*2,"OK","Metrostroi_775_Calibri26",color_white)
			else
				DrawButton(702*2, 533*2, 96*2, 63*2,"Далее","Metrostroi_775_Calibri26",color_white)
			end
			local names = {
				"Число вагонов в составе",
				"Ввод номеров вагонов",
				"Диаметр бандажа КП",
				"Версии ПО",
				"Пульты",
				"Выбор линии"
			}
			local height = 68.5*2
			for i=1, 6 do
				local color = i%2~=0 and Color(0, 0, 0,0) or color_gray_butt2
				local y = 62*2 + (i-1)*height

				surface.SetDrawColor(color)
				surface.DrawRect(4, y, 600*2, height)

				surface.SetDrawColor(color)
				surface.DrawRect(610*2, y, 190*2, height)
				if i~=1 then
					surface.SetDrawColor(color_gray)
					surface.DrawRect(4, y, 600*2, 2)

					surface.SetDrawColor(color_gray)
					surface.DrawRect(610*2, y, 190*2, 2)
				end

				draw.SimpleText(Format("%d. %s",i,names[i]),"Metrostroi_775_Roboto22b",6,y + height/2,color_white,0,1)

				if i == 1 then
					local wag_num = train:GetNW2Int("BKPU_WagNum")
					if state ~= 1 then
						draw.SimpleText(wag_num,"Metrostroi_775_Primus",700*2,y + height/2-5,color_white,1,1)
					else
						draw.SimpleText("←     "..wag_num.."     →","Metrostroi_775_Primus",700*2,y + height/2-5,color_light_blue,1,1)
					end
				else
					if i == 6 and state == 6 then
						draw.SimpleText(pawd(train:GetNW2String("MFDU_MapCurrentPassword","00000")),"Metrostroi_775_Primus",700*2,y + height/2-5,color_light_blue,1,1)
					else
						local icon = surface.GetTextureID("dss/81-775/screens/icons/mfdud"..i)
						surface.SetTexture(icon)
						surface.SetDrawColor(255,255,255)
						surface.DrawTexturedRect(1340,y,128,128)
					end
					Metrostroi.DrawLine(6,y,600*2,y,Color(255,255,255),2)
					Metrostroi.DrawLine(610*2,y,610*2+190*2,y,Color(255,255,255),2)
				end
			end
			Metrostroi.DrawRectOutline(2,2,1598,100,Color(255,255,255),2)
			Metrostroi.DrawRectOutline(2,124,600*2+2,850,Color(255,255,255),2)
			Metrostroi.DrawRectOutline(610*2,124,190*2,850,Color(255,255,255),2)
			Metrostroi.DrawRectOutline(2,988,1598,68,Color(255,255,255),2)
		end

		if state == 2 then
			draw.SimpleText("Ввод заводских номеров вагонов","Metrostroi_775_Roboto32b",340*2,28*2,Color(255,255,255),1,1)
			Metrostroi.DrawRectOutline(2,2,1598,100,Color(255,255,255),2)
			local butt_size = 150
			local sy = 650 - (butt_size+14)*2
			for iy = 1, 4 do
				for ix = 1, 3 do
					local pos_x, pos_y = 300*2 + (ix-1) * (butt_size+14), sy + (iy-1) * (butt_size+14)
					DrawButton(pos_x, pos_y, butt_size, butt_size,keyboard[iy][ix],"Metrostroi_775_Calibri20",color_gray_butt)
				end
			end
			DrawButton(702*2, 533*2, 96*2, 63*2,"Обратно","Metrostroi_775_Calibri26",color_white)
		end
		if state == 7 then
			draw.SimpleText("Выбор линии","Metrostroi_775_Roboto32b",800,28*2,Color(255,255,255),1,1)
			Metrostroi.DrawRectOutline(2,2,1598,100,Color(255,255,255),2)

			DrawButton(702*2-97*2, 533*2, 96*2, 63*2,"Обратно","Metrostroi_775_Calibri26",color_white)
			DrawButton(702*2, 533*2, 96*2, 63*2,"Выбрать","Metrostroi_775_Calibri26",color_white)
		end
	end

	function TRAIN_SYSTEM:DrawMFDU(train,dT)
		local state = train:GetNW2Int("MFDU_State", 0)/10
		if state ~= 0 then
			draw.RoundedBox(0,0,0,scr_w,scr_h,state == -2 and Color(255, 255, 255, 255) or Color(65,70,95, 5))
		end
		local prio = train:GetNW2Int("MFDU:Prio", 0)
		if prio > 0 and state >= 1 then
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(0, 0, scr_w, scr_h)
			draw.SimpleText(prio == 2 and "Сбой РВ" or "Включены 2 РВ","Metrostroi_775_Calibri80",800,340,Color(230,44,49),1,1)
			surface.SetDrawColor(255, 255, 255, 255)
			self:SetTexture("moscow_logo")
			self:DrawTexture(scr_w/2, 700, 560, 560, true)
			draw.SimpleText(os.date("%H:%M:%S"),"Metrostroi_775_Calibri40",340,1040,color_white,1,1)
			draw.SimpleText(os.date("%d.%m.%Y"),"Metrostroi_775_Calibri40",1260,1040,color_white,1,1)
			return
		end
		if state >= 1 and state < 2 then
			if state == 1.5 then
				draw.SimpleText("Для штатной активации вставьте карту доступа в устройство УКД","Metrostroi_775_Calibri26",800, 160,Color(255, 255, 255, 255),1,1)
				draw.SimpleText("Для резервной активации нажмите на логотип Московского метрополитена","Metrostroi_775_Calibri26",800, 160+60,Color(255, 255, 255, 255),1,1)
			end
			if state == 1.7 then
				draw.SimpleText("Хвостовая кабина",'Metrostroi_775_Calibri80',800,140,Color(255,255,255), 1, 1)
				draw.SimpleText(train:GetNW2Int("MFDU_Speed",0),'Metrostroi_775_Calibri70',800,350,Color(0,255,0), 1, 1)
				draw.SimpleText("КМ/Ч",'Metrostroi_775_Calibri26',800,450,Color(255,255,255), 1, 1)

				draw.SimpleText("P",'Metrostroi_775_Calibri26',12+200,600,Color(255,255,255), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText("нм",'Metrostroi_775_Calibri26',40+200,600,Color(255,255,255), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(Format("%.1f",train:GetNW2Float("MFDU_TLPressure")),'Metrostroi_775_Calibri26',45+200,600+44,Color(0,255,255), 1, TEXT_ALIGN_BOTTOM)

				draw.SimpleText("P",'Metrostroi_775_Calibri26',12+600,600,Color(255,255,255), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText("тм",'Metrostroi_775_Calibri26',40+600,600,Color(255,255,255), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(Format("%.1f",train:GetNW2Float("MFDU_BLPressure")),'Metrostroi_775_Calibri26',45+600,600+44,Color(0,255,255), 1, TEXT_ALIGN_BOTTOM)

				draw.SimpleText("Атм",'Metrostroi_775_Calibri26',45+200,600+76,Color(255,255,255), 1, TEXT_ALIGN_BOTTOM)
				draw.SimpleText("Атм",'Metrostroi_775_Calibri26',45+600,600+76,Color(255,255,255), 1, TEXT_ALIGN_BOTTOM)

				draw.SimpleText("U",'Metrostroi_775_Calibri26',1600-40-650,600,Color(255,255,255), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText("бс",'Metrostroi_775_Calibri26',1600-12-650,600,Color(255,255,255), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(train:GetNW2Int("MFDU_UBS"),'Metrostroi_775_Calibri26',1600-45-615,600+44,Color(255,255,0), 1, TEXT_ALIGN_BOTTOM)

				draw.SimpleText("U",'Metrostroi_775_Calibri26',1600-40-250,600,Color(255,255,255), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText("кс",'Metrostroi_775_Calibri26',1600-12-250,600,Color(255,255,255), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(train:GetNW2Int("MFDU_HV",0),'Metrostroi_775_Calibri26',1600-45-215,600+44,Color(255,255,0), 1, TEXT_ALIGN_BOTTOM)

				draw.SimpleText("В",'Metrostroi_775_Calibri26',1600-200-58,600+76,Color(255,255,255), 1, TEXT_ALIGN_BOTTOM)
				draw.SimpleText("В",'Metrostroi_775_Calibri26',1600-600-58,600+76,Color(255,255,255), 1, TEXT_ALIGN_BOTTOM)

				surface.SetDrawColor(255, 255, 255, 255)
				self:SetTexture("moscow_logo")
				self:DrawTexture(scr_w/2-10, scr_h/1.25-10, 400, 400, true)
			else
				surface.SetDrawColor(255, 255, 255, 255)
				self:SetTexture("moscow_logo")
				self:DrawTexture(scr_w/2-10, scr_h/2-10, 800, 800, true)
			end
		end
		if state == -4 then
			draw.RoundedBox(0,0,0,scr_w,scr_h,Color(255, 255, 255, 255))
			draw.SimpleText("Отказ коммуникации!","Metrostroi_775_Calibri30b",800, 300,Color(0, 0, 0),1,1)
			draw.SimpleText("Отсутствует связь между","Metrostroi_775_Calibri30b",800, 500,Color(0, 0, 0),1,1)
			draw.SimpleText("компьютером головного вагона и дисплеем МФДУ!","Metrostroi_775_Calibri30b",800, 550,Color(0, 0, 0),1,1)
			draw.SimpleText("включи режим \"АВАРИЙНЫЙ ХОД\"","Metrostroi_775_Calibri30b",800, 750,Color(0, 0, 0),1,1)
		end
		if state == 2 then
			Metrostroi.DrawRectOutline(2,2,800-6,600-6,Color(255,255,255),2)
			Metrostroi.DrawRectOutline(2,600+6,800-6,600-6,Color(255,255,255),2)
			Metrostroi.DrawRectOutline(800+6,2,800-6,1198,Color(255,255,255),2)

			surface.SetDrawColor(255, 255, 255, 255)
			self:SetTexture("moscow_logo")
			self:DrawTexture(2+294, 608+260, 680, 680, true)

			local butt_size = 150
			local sy = 600 - (butt_size+14)*2
			for iy = 1, 4 do
				for ix = 1, 3 do
					local pos_x, pos_y = 490*2 + (ix-1) * (butt_size+14), sy + (iy-1) * (butt_size+14)
					DrawButton(pos_x, pos_y, butt_size, butt_size,keyboard[iy][ix],"Metrostroi_775_Calibri20",color_gray_butt)
				end
			end

			DrawButton(490*2 + (butt_size+14), sy + (5-1) * (butt_size+14), butt_size, butt_size)

			surface.SetDrawColor(255, 255, 255, 255)
			self:SetTexture("shutdown")
			self:DrawTexture(490*2 + (butt_size+14) + butt_size / 2, sy + (5-1) * (butt_size+14) + butt_size/2, butt_size/2, butt_size/2, true)

			local pass = train:GetNW2String("MFDU_CurrentPassword", "")
			local pass_selected = train:GetNW2Bool("MFDU_PasswordSelected", false)
			local pass_typed = train:GetNW2Bool("MFDU_PasswordStartType", false)

			local pass_x = 796/2
			local pass_y = 596/2

			surface.SetFont("Metrostroi_775_Primus")

			local w, h = surface.GetTextSize(pass)

			if pass_selected then
				surface.SetDrawColor(17, 202, 190)
				surface.DrawRect(pass_x - w/2, pass_y - h/2, w, h)
			end

			draw.SimpleText(pass,"Metrostroi_775_Primus",pass_x,pass_y,pass_selected and Color(0,0,0) or Color(17,202,190),1,1)

			if math.floor(CurTime()/0.3)%2==0 and pass_typed then
				surface.SetDrawColor(17, 202, 190)
				surface.DrawRect(pass_x + w/2, pass_y - h/2, 2, h)
			end
		end
		if state == 3 then
			Depot(train)
		end
		if state >= 4 then
			self:DrawMain(train, state,dT)
			if train:GetNW2Bool("MFDU:VTBDialog", false) then
				local fx, fy, fw, fh = 132, 80, 1326, 786
				DrawBox(fx, fy, fw, fh, Color(0,0,0,255), color_white)
				Metrostroi.DrawRectOutline(fx+4, fy+4, fw-8, fh-8, color_white, 2)
				draw.SimpleText("Для включения блокировки ВТБ","Metrostroi_775_Calibri40",fx+fw/2,fy+90,color_white,1,1)
				draw.SimpleText("нажмите кнопку \"Ок\"","Metrostroi_775_Calibri40",fx+fw/2,fy+150,color_white,1,1)
				draw.SimpleText("Для отмены включения блокировки ВТБ","Metrostroi_775_Calibri40",fx+fw/2,fy+250,color_white,1,1)
				draw.SimpleText("нажмите кнопку \"Отмена\"","Metrostroi_775_Calibri40",fx+fw/2,fy+310,color_white,1,1)
				local bw, bh, by = 260, 240, 520
				DrawBox(463-bw/2, by, bw, bh, Color(39,39,39,255), color_white)
				draw.SimpleText("Ок","Metrostroi_775_Calibri40",463,by+bh/2,color_white,1,1)
				DrawBox(1127-bw/2, by, bw, bh, Color(39,39,39,255), color_white)
				draw.SimpleText("Отмена","Metrostroi_775_Calibri40",1127,by+bh/2,color_white,1,1)
			end
		end
	end

	function TRAIN_SYSTEM:ClientThink(dT)

		if not self.Train:ShouldDrawPanel("MFDU") then return end

		local currentTime = CurTime()
		if currentTime - self.LastRenderTime < self.RenderInterval then
			return
		end
		self.LastRenderTime = currentTime

		render.PushRenderTarget(self.Train.MFDU,0,0,800*2, 600*2)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			surface.SetDrawColor(0,0,0)
			surface.DrawRect(0,0,1600,1200)
			self:DrawMFDU(self.Train,dT)
		cam.End2D()
		render.PopRenderTarget()
		self.FPSTimer = currentTime
	end
end
