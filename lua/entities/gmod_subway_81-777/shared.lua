ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"

ENT.PrintName		= "81-777 MVM"
ENT.Author          = "Moscow2020"
ENT.Contact         = "Steam addon"
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "Metrostroi (trains)"

ENT.Model = "models/metrostroi_train/81-775/776_body.mdl"

ENT.Spawnable       = true
ENT.AdminSpawnable  = false
ENT.DontAccelerateSimulation = false

function ENT:PassengerCapacity()
	return 300
end

function ENT:GetStandingArea()
	return Vector(-450,-30,-58),Vector(360,30,-58)
end
local AOD_DOOR_X = {R = {350.5, 116.8, -116.8, -350.5}, L = {-350.5, -116.8, 116.8, 350.5}}
ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}
for i = 1, 4 do
	table.insert(ENT.LeftDoorPositions, Vector(AOD_DOOR_X.L[i], 66, -1))
	table.insert(ENT.RightDoorPositions, Vector(AOD_DOOR_X.R[i], -66, -1))
end
local yventpos = {
	-414.5+0*117,
	-414.5+1*117+6.2,
	-414.5+2*117+5,
	-414.5+3*117+2,
	-414.5+4*117+0.5,
	-414.5+5*117-2.3,
	-414.5+6*117,
}
function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
	self.SoundNames["release_f"] = {loop=true,"subway_trains/765/rumble/pneumo_release2.wav"}
	self.SoundPositions["release_f"] = {320,1e9,Vector(320,0,-78),0.375}
	self.SoundNames["release_r"] = {loop=true,"subway_trains/765/rumble/pneumo_release2.wav"}
	self.SoundPositions["release_r"] = {320,1e9,Vector(-324,0,-78),0.375}
	self.SoundNames["release_bto"] = {loop=true,"subway_trains/765/rumble/pneumo_release2.wav"}
	self.SoundPositions["release_bto"] = {320,1e9,Vector(-14,-50,-60),0.5}

    self.SoundNames["test_async1_2"]   = {"subway_trains/722/engines/inverter_1000.wav",loop = true}
    self.SoundNames["test_async1_3"]   = {"subway_trains/722/engines/inverter_1000.wav",loop = true}
    self.SoundNames["test_async2"]   = {"subway_trains/722/engines/inverter_2000.wav",loop = true}
    self.SoundNames["test_async3"]   = {"subway_trains/722/engines/inverter_2800.wav",loop = true}
    self.SoundNames["test_async3_2"]   = {"subway_trains/722/engines/inverter_2800.wav",loop = true}
    self.SoundPositions["test_async1_2"] = {400,1e9,Vector(0,0,0),0.1}
    self.SoundPositions["test_async1_3"] = {400,1e9,Vector(0,0,0),0.1}
    self.SoundPositions["test_async2"] = {400,1e9,Vector(0,0,0),0.1}
    self.SoundPositions["test_async3"] = {400,1e9,Vector(0,0,0),0.1}
    self.SoundPositions["test_async3_2"] = self.SoundPositions["test_async3"]
    self.SoundNames["async_p2"]   = {"subway_trains/722/engines/inverter_1000.wav",loop = true}
    self.SoundPositions["async_p2"] = {400,1e9,Vector(0,0,0),1}
    self.SoundNames["async_p3"]   = {"subway_trains/722/engines/inverter_1000.wav",loop = true}
    self.SoundPositions["async_p3"] = {400,1e9,Vector(0,0,0),1}
    self.SoundNames["engine_loud"]   = {"subway_trains/722/engines/engine_loud.wav",loop = true}
    self.SoundPositions["engine_loud"] = {400,1e9,Vector(0,0,0),0.2}
    self.SoundNames["chopper"]   = {"subway_trains/722/chopper.wav",loop = true}
    self.SoundPositions["chopper"] = {400,1e9,Vector(0,0,0),0.03}
	self.SoundNames["async1"]   = {"subway_trains/760/engines/inverter.wav", loop = true}
    self.SoundPositions["async1"] = {400,1e9,Vector(0,0,0),0.5}

	for i=1,7 do
		self.SoundNames["vent"..i] = {loop=true,"subway_trains/720/vent_mix.wav"}
		self.SoundPositions["vent"..i] = {100,1e9,Vector(yventpos[i],0,30),0.5}
	end

	self.SoundNames["compressor"] = {loop=true,"subway_trains/775/compressor/compressor775_loop.wav"}
	self.SoundPositions["compressor"] = {800,1e9,Vector(-118,-40,-66)}
	self.SoundNames["compressor_start"] = {loop=true,"subway_trains/775/compressor/compressor775_start.wav"}
	self.SoundPositions["compressor_start"] = {800,1e9,Vector(-118,-40,-66)}
	self.SoundNames["compressor_pn1"] = "subway_trains/760/new/compressor_dhm.wav"
	self.SoundPositions["compressor_pn1"] = {800,1e9,Vector(-118,-40,-66)}
	self.SoundNames["compressor_pn2"] = "subway_trains/760/new/compressor_dhm_2.wav"
	self.SoundPositions["compressor_pn2"] = {800,1e9,Vector(-118,-40,-66)}

    self.SoundNames["pneumo_disconnect_close"] = {
		"subway_trains/760/new/013_close1.wav",
		"subway_trains/760/new/013_close2.wav",
	}
    self.SoundNames["pneumo_disconnect_open"] = {
        "subway_trains/760/new/013_open1.wav",
        "subway_trains/760/new/013_open2.wav",
    }
    self.SoundPositions["pneumo_disconnect_close"] = {100,1e9,Vector(478,45,-61),0.5}
    self.SoundPositions["pneumo_disconnect_open"] = {100,1e9,Vector(478,45,-61),0.5}

    self.SoundNames["front_isolation"] = {loop=true,"subway_trains/common/pneumatic/isolation_leak.wav"}
    self.SoundPositions["front_isolation"] = {300,1e9,Vector(500, 0,-63),1}
    self.SoundNames["rear_isolation"] = {loop=true,"subway_trains/common/pneumatic/isolation_leak.wav"}
    self.SoundPositions["rear_isolation"] = {300,1e9,Vector(-469, 0,-63),1}

    self.SoundNames["rolling_10"] = {loop=true,"subway_trains/722/rolling_10.wav"}
    self.SoundNames["rolling_45"] = {loop=true,"subway_trains/722/rolling_45.wav"}
    self.SoundNames["rolling_60"] = {loop=true,"subway_trains/722/rolling_60.wav"}
    self.SoundNames["rolling_70"] = {loop=true,"subway_trains/722/rolling_70.wav"}
    self.SoundPositions["rolling_10"] = {485,1e9,Vector(0,0,0),0.20}
    self.SoundPositions["rolling_45"] = {485,1e9,Vector(0,0,0),0.50}
    self.SoundPositions["rolling_60"] = {485,1e9,Vector(0,0,0),0.55}
    self.SoundPositions["rolling_70"] = {485,1e9,Vector(0,0,0),0.60}
    self.SoundNames["rolling_low"] = {loop=true,"subway_trains/717/rolling/rolling_outside_low.wav"}
    self.SoundNames["rolling_medium1"] = {loop=true,"subway_trains/717/rolling/rolling_outside_medium1.wav"}
    self.SoundNames["rolling_medium2"] = {loop=true,"subway_trains/717/rolling/rolling_outside_medium2.wav"}
    self.SoundNames["rolling_high2"] = {loop=true,"subway_trains/717/rolling/rolling_outside_high2.wav"}
    self.SoundPositions["rolling_low"] = {480,1e12,Vector(0,0,0),0.6*0.4}
    self.SoundPositions["rolling_medium1"] = {480,1e12,Vector(0,0,0),0.90*0.4}
    self.SoundPositions["rolling_medium2"] = {480,1e12,Vector(0,0,0),0.90*0.4}
    self.SoundPositions["rolling_high2"] = {480,1e12,Vector(0,0,0),1.00*0.4}

	self.SoundNames["gv_f"] = {"subway_trains/717/kv70/reverser_0-b_1.mp3","subway_trains/717/kv70/reverser_0-b_2.mp3"}
	self.SoundNames["gv_b"] = {"subway_trains/717/kv70/reverser_b-0_1.mp3","subway_trains/717/kv70/reverser_b-0_2.mp3"}
	self.SoundPositions["gv_f"] = {80,1e9,Vector(126.4,50,-60-23.5),0.8}
	self.SoundPositions["gv_b"] = {80,1e9,Vector(126.4,50,-60-23.5),0.8}

    self.SoundNames["disconnectvalve"] = "subway_trains/common/switches/pneumo_disconnect_switch.mp3"

	self.SoundNames["batt_on"] = "subway_trains/720/batt_on.mp3"
	self.SoundPositions["batt_on"] = {400,1e9,Vector(126.4,50,-60-23.5),0.3}

    self.SoundNames["valve_brake"] = {loop=true,"subway_trains/760/new/stopcrane_loop.wav"}
    self.SoundPositions["valve_brake"] = {400,1e9,Vector(418.25,-49.2,1.3),1}
    self.SoundNames["valve_brake_close"] = {"subway_trains/760/stopkran_close.wav"}
    self.SoundPositions["valve_brake_close"] = {400,1e9,Vector(418.25,-49.2,1.3),1}
	self.SoundNames["valve_brake_open"] = {"subway_trains/760/stopkran_open.wav"}
    self.SoundPositions["valve_brake_open"] = {400,1e9,Vector(418.25,-49.2,1.3),1}

    self.SoundNames["emer_brake"] = {loop=true,"subway_trains/common/pneumatic/autostop_loop.wav"}
    self.SoundPositions["emer_brake"] = {600,1e9,Vector(380,-45,-75),0.95}

    self.SoundNames["stopkran_brake"] = {loop=true,"subway_trains/common/pneumatic/autostop_loop.wav"}
    self.SoundPositions["stopkran_brake"] = {600,1e9,Vector(-462.9,-43,-21.5),0.95}

    self.SoundNames["stopkran_open"] = {
        "subway_trains/ezh3/pneumatic/brake_line_on.mp3",
        "subway_trains/ezh3/pneumatic/brake_line_on2.mp3",
    }
    self.SoundNames["stopkran_disconnect"] = {
        "subway_trains/common/334/334_close.mp3",
    }
    self.SoundPositions["stopkran_open"] = {60,1e9,Vector(-462.9,-43,-21.5),0.7}
    self.SoundPositions["stopkran_disconnect"] = {60,1e9,Vector(-462.9,-43,-21.5),0.7}

	self.SoundNames["vent_loop"] = {loop=true,"subway_trains/760/new/vent_cockpit_default_2.wav"}
    self.SoundPositions["vent_loop"] = {400,1e9,Vector(422,55,40),1}
	self.SoundNames["vent_loop_max"] = {loop=true,"subway_trains/760/new/vent_cockpit_high.wav"}
    self.SoundPositions["vent_loop_max"] = {400,1e9,Vector(422,55,40),1}

	local function GetDoorPosition(i,k)
		return (k == 1 and self.LeftDoorPositions or self.RightDoorPositions)[i+1]
	end

    for i=0,3 do
        for k=0,1 do
            self.SoundNames["door"..i.."x"..k.."r"] = {loop=true,"subway_trains/775/doors/door_vjj.wav"}
            self.SoundPositions["door"..i.."x"..k.."r"] = {100,1e9,GetDoorPosition(i,k),0.25}
            self.SoundNames["door"..i.."x"..k.."op"] = {"subway_trains/775/doors/door_open_start1.wav"}
            self.SoundPositions["door"..i.."x"..k.."op"] = {150,1e9,GetDoorPosition(i,k),15}
            self.SoundNames["door"..i.."x"..k.."c"] = {"subway_trains/775/doors/door_close_end1.wav"}
            self.SoundPositions["door"..i.."x"..k.."c"] = {250,1e9,GetDoorPosition(i,k),3}
        end
    end
    local doorAlarmFile = "mm/moskwa2020/door_alarm2.wav"

    for i = 1, 8 do
        local soundName = "door_alarm_" .. i
        self.SoundNames[soundName] = { loop = true, doorAlarmFile }

        local doorIndex = ((i-1) % 4) + 1
        local isLeft = i <= 4

        local doorPos
        if isLeft and self.LeftDoorPositions and self.LeftDoorPositions[doorIndex] then
            doorPos = self.LeftDoorPositions[doorIndex]
        elseif not isLeft and self.RightDoorPositions and self.RightDoorPositions[doorIndex] then
            doorPos = self.RightDoorPositions[doorIndex]
        else
            local xPos = 359.0 - 229.5 * (doorIndex - 1)
            local yPos = isLeft and 66 or -66
            doorPos = Vector(xPos, yPos, 7.5)
        end

        self.SoundPositions[soundName] = { 100, 1e9, doorPos + Vector(0, 0, 30), 0.8 }
    end

	self.SoundNames["sf_on"] = "subway_trains/722/switches/sf_on.mp3"
	self.SoundNames["sf_off"] = "subway_trains/722/switches/sf_off.mp3"

    self.SoundNames["bv_off"] = {"subway_trains/760/new/bv_off.wav"}
    self.SoundPositions["bv_off"] = {800,1e9,Vector(0,0,-45),0.5}

	self.SoundNames["rvs1"] = {"mm/moskwa2020/door_alarm1.wav"}
	self.SoundPositions["rvs1"] = {800,1e9,Vector(454.817,60.54,-10.64),0.5}

    for i = 1,10 do
        local id1 = Format("b1tunnel_%d",i)
        local id2 = Format("b2tunnel_%d",i)
        self.SoundPositions[id1.."a"] = {700*0.75,1e9,Vector( 317-5,0,-84),1*0.5}
        self.SoundPositions[id1.."b"] = self.SoundPositions[id1.."a"]
        self.SoundPositions[id2.."a"] = {700*0.75,1e9,Vector(-317+0,0,-84),1*0.5}
        self.SoundPositions[id2.."b"] = self.SoundPositions[id2.."a"]
    end
    for i = 1,14 do
        local id1 = Format("b1street_%d",i)
        local id2 = Format("b2street_%d",i)
        self.SoundPositions[id1.."a"] = {700,1e9,Vector( 317-5,0,-84),1.5*0.5}
        self.SoundPositions[id1.."b"] = self.SoundPositions[id1.."a"]
        self.SoundPositions[id2.."a"] = {700,1e9,Vector(-317+0,0,-84),1.5*0.5}
        self.SoundPositions[id2.."b"] = self.SoundPositions[id2.."a"]
    end
    for k,v in ipairs(self.AnnouncerPositions) do
        self.SoundNames["announcer_noise1_"..k] = {loop=true,"subway_announcers/upo/noiseS1.wav"}
        self.SoundPositions["announcer_noise1_"..k] = {v[2] or 300,1e9,v[1],v[3]*0.2}
        self.SoundNames["announcer_noise2_"..k] = {loop=true,"subway_announcers/upo/noiseS2.wav"}
        self.SoundPositions["announcer_noise2_"..k] = {v[2] or 300,1e9,v[1],v[3]*0.2}
        self.SoundNames["announcer_noise3_"..k] = {loop=true,"subway_announcers/upo/noiseS3.wav"}
        self.SoundPositions["announcer_noise3_"..k] = {v[2] or 300,1e9,v[1],v[3]*0.2}
        self.SoundNames["announcer_noiseW"..k] = {loop=true,"subway_announcers/upo/noiseW.wav"}
        self.SoundPositions["announcer_noiseW"..k] = {v[2] or 300,1e9,v[1],v[3]*0.2}
    end
	self.SoundNames["door_pvz_open"] = {"subway_trains/720/door/door_torec_open.mp3","subway_trains/720/door/door_torec_open2.mp3"}
	self.SoundPositions["door_pvz_open"] = {800,1e9,Vector(-445.70,37.85,-40.20),0.5}
	self.SoundNames["door_pvz_close"] = {"subway_trains/720/door/door_torec_close.mp3","subway_trains/720/door/door_torec_close2.mp3"}
	self.SoundPositions["door_pvz_close"] = {800,1e9,Vector(-445.70,37.85,-40.20),0.5}
end

function ENT:InitializeSystems()
	self:LoadSystem("TR","TR_3B")
	self:LoadSystem("Electric","81_775_Electric_new")

	self:LoadSystem("BUV","81_775_BUV")
	self:LoadSystem("BUD","81_775_BUD")
    self:LoadSystem("BNT","775BNT")
    self:LoadSystem("Screens","775_TVSCREEN")

	self:LoadSystem("Panel","81_777_Panel")

    self:LoadSystem("BNTN","81_775_BNTN")

	self:LoadSystem("Pneumatic","81_775_Pneumatic")
	self:LoadSystem("BTBU","81_775_BTBU")

	self:LoadSystem("Announcer","81_71_Announcer", "AnnouncementsASNP")
	self:LoadSystem("IGLA_PCBK","81_775_IGLA_PCBK")
end

function ENT:PostInitializeSystems()
    self.Electric:TriggerInput("Type",self.Electric.T777)
end

ENT.AnnouncerPositions = {
}
table.insert(ENT.AnnouncerPositions,{Vector(470,0,44),100,0.1})
for i=1,4 do
    table.insert(ENT.AnnouncerPositions,{Vector(323-(i-1)*230  ,47 ,44),100,0.1})
    table.insert(ENT.AnnouncerPositions,{Vector(323-(i-1)*230,-47,44),100,0.1})
end
ENT.SubwayTrain = {
	Type = "81-77",
	Name = "81-777",
	WagType = 2,
	Manufacturer = "MVM",
    EKKType = 775,
}
ENT.NumberRanges = {{77001,77999}}
