ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"

ENT.PrintName		= "81-775 (Москва 2020)"
ENT.Author          = "Moscow2020"
ENT.Contact         = "Steam addon"
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "Metrostroi (trains)"

ENT.Model = "models/metrostroi_train/81-775/775_body.mdl"

ENT.Spawnable       = true
ENT.AdminSpawnable  = false
ENT.DontAccelerateSimulation = false

function ENT:PassengerCapacity()
	return 300
end

function ENT:GetStandingArea()
	return Vector(-450,-30,-48),Vector(360,30,-48)
end
local function GetDoorPosition(i,k)
	return Vector(359.0 - 35/2 - 229.5*i,-65*(1-2*k),7.5)
end

ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}
for i=1,4 do
    table.insert(ENT.LeftDoorPositions,GetDoorPosition(i-1,1))
    table.insert(ENT.RightDoorPositions,GetDoorPosition(i-1,0))
end

ENT.Cameras = {

	{Vector(440, 33, 13), Angle(60, 71, 0), "Левый ПУ"},
	{Vector(460, 18, 15), Angle(69, 0, 0), "Центральный ПУ"},
	{Vector(455, 3, 15), Angle(70, -30, 0), "Правый ПУ"},
	{Vector(455, 6, 5), Angle(17, -31, 2) , "МФДУ"},
	{Vector(460, 40, 5), Angle(25, 32, 0), "Видеонаблюдение"},
	{Vector(405, 46, 19), Angle(0, -180, 0), "Автоматы ППЗ"},
	{Vector(400, 39.2, 30.7), Angle(0, -180, 0), "ЦИC"},
	{Vector(400, 45, 40), Angle(0, -180, 0), 'АСНП и АСОТП "Игла"'},
	{Vector(315, -10, 45), Angle(-20, -90, 0), "Правый БНТ"},
	{Vector(315, 10, 45), Angle(-20, 90, 0), "Левый БНТ"},
	{Vector(350, 0, 45), Angle(0, -180, 0), "Салон"},
}

ENT.AnnouncerPositions = {}
for i=1,4 do
    table.insert(ENT.AnnouncerPositions,{Vector(323-(i-1)*230+37.5,47 ,110),100,0.1})
    table.insert(ENT.AnnouncerPositions,{Vector(323-(i-1)*230,-47,110),100,0.1})
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
	self.SoundPositions["release_f"] = {320,1e9,Vector(330,0,-70),0.375}
	self.SoundNames["release_r"] = {loop=true,"subway_trains/765/rumble/pneumo_release2.wav"}
	self.SoundPositions["release_r"] = {320,1e9,Vector(-334,0,-70),0.375}

    self.SoundNames["test_async1_2"]   = {"subway_trains/722/engines/inverter_1000.wav",loop = true}
    self.SoundNames["test_async1_3"]   = {"subway_trains/722/engines/inverter_1000.wav",loop = true}
    self.SoundNames["test_async2"]   = {"subway_trains/722/engines/inverter_2000.wav",loop = true}
    self.SoundNames["test_async3"]   = {"subway_trains/722/engines/inverter_2800.wav",loop = true}
    self.SoundNames["test_async3_2"]   = {"subway_trains/722/engines/inverter_2800.wav",loop = true}
   self.SoundPositions["test_async1"] = {400,1e9,Vector(430,0,0),0.5}
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
    self.SoundNames["chopper_katp"] = {"subway_trains/720a/chopper.mp3", loop = true}
    self.SoundPositions["chopper_katp"] = {400,1e9,Vector(0,0,0),0.35}
	self.SoundNames["async775"]   = {"subway_trains/775/engines/inverter1.wav", loop = true}
    self.SoundPositions["async775"] = {400,1e9,Vector(0,0,0),1}
	self.SoundNames["async775.1"]   = {"subway_trains/775/engines/inverter2.wav", loop = true}
    self.SoundPositions["async775.1"] = {400,1e9,Vector(0,0,0),0.7}

	for i=1,7 do
		self.SoundNames["vent"..i] = {loop=true,"subway_trains/720/vent_mix.wav"}
		self.SoundPositions["vent"..i] = {100,1e9,Vector(yventpos[i],0,30),0.5}
	end

	self.SoundNames["ring"] = {loop=0,"subway_trains/722/ring1_loop.wav","subway_trains/722/ring1_loop.wav","subway_trains/722/ring1_end.wav"}
	self.SoundPositions["ring"] = {100,1e9,Vector(409,25.6,-26.3)}

	self.SoundNames["compressor"] = {loop=true,"subway_trains/775/compressor/compressor775_loop.wav"}
	self.SoundPositions["compressor"] = {800,1e9,Vector(-118,-40,-66)}
	self.SoundNames["compressor_start"] = {loop=true,"subway_trains/775/compressor/compressor775_start.wav"}
	self.SoundPositions["compressor_start"] = {800,1e9,Vector(-118,-40,-66)}
	self.SoundNames["compressor_pn1"] = "subway_trains/760/new/compressor_dhm.wav"
	self.SoundPositions["compressor_pn1"] = {800,1e9,Vector(-118,-40,-66)}
	self.SoundNames["compressor_pn2"] = "subway_trains/760/new/compressor_dhm_2.wav"
	self.SoundPositions["compressor_pn2"] = {800,1e9,Vector(-118,-40,-66)}

    self.SoundNames["release"] = {loop=true,"subway_trains/765/rumble/pneumo_release2.wav"}
    self.SoundPositions["release"] = {320,1e9,Vector(-183,0,-70),0.75}
    self.SoundNames["parking_brake"] = {loop=true,"subway_trains/common/pneumatic/autostop_loop.wav"}
    self.SoundPositions["parking_brake"] = {400,1e9,Vector(-183,0,-70),0.95}
    self.SoundNames["crane013_brake"] = {loop=true,"subway_trains/common/pneumatic/release_2.wav"}
    self.SoundPositions["crane013_brake"] = {80,1e9,Vector(475,-10,-47.9),0.86}
    self.SoundNames["crane013_brake2"] = {loop=true,"subway_trains/common/pneumatic/013_brake2.wav"}
    self.SoundPositions["crane013_brake2"] = {80,1e9,Vector(475,-10,-47.9),0.86}
    self.SoundNames["crane013_release"] = {loop=true,"subway_trains/775/pneumatic/013_release.wav"}
    self.SoundPositions["crane013_release"] = {80,1e9,Vector(475,-10,-47.9),0.4}

    self.SoundNames["pneumo_disconnect_close"] = {"subway_trains/775/revers/013_close2.wav"}

    self.SoundNames["pneumo_disconnect_open"] = {"subway_trains/775/revers/013_open1.wav"}

    self.SoundPositions["pneumo_disconnect_close"] = {100,1e9,Vector(478,45,-61),0.125}
    self.SoundPositions["pneumo_disconnect_open"] = {100,1e9,Vector(478,45,-61),0.375}

    self.SoundNames["front_isolation"] = {loop=true,"subway_trains/common/pneumatic/isolation_leak.wav"}
    self.SoundPositions["front_isolation"] = {300,1e9,Vector(500, 0,-63),1}
    self.SoundNames["rear_isolation"] = {loop=true,"subway_trains/common/pneumatic/isolation_leak.wav"}
    self.SoundPositions["rear_isolation"] = {300,1e9,Vector(-469, 0,-63),1}

    self.SoundNames["horn1"] = {loop=0.1,"subway_trains/775/tifon/svistok_start.mp3","subway_trains/775/tifon/svistok_loop.mp3", "subway_trains/775/tifon/svistok_end.mp3"}
    self.SoundPositions["horn1"] = {2000,1e9,Vector(520,-45,-3)}

	self.SoundNames["KV_-3_-2"] = "subway_trains/760/controller/t3_t2.mp3"
	self.SoundNames["KV_-2_-1"] = "subway_trains/760/controller/t2_t1.mp3"
	self.SoundNames["KV_-1_0"] = "subway_trains/760/controller/t1_0.mp3"
	self.SoundNames["KV_0_1"] = "subway_trains/760/controller/0_x1.mp3"
	self.SoundNames["KV_1_2"] = "subway_trains/760/controller/x1_x2.mp3"
	self.SoundNames["KV_2_3"] = "subway_trains/760/controller/x2_x3.mp3"
	self.SoundNames["KV_3_4"] = "subway_trains/760/controller/x3_x4.mp3"
	self.SoundNames["KV_4_3"] = "subway_trains/760/controller/x4_x3.mp3"
	self.SoundNames["KV_3_2"] = "subway_trains/760/controller/x3_x2.mp3"
	self.SoundNames["KV_2_1"] = "subway_trains/760/controller/x2_x1.mp3"
	self.SoundNames["KV_1_0"] = "subway_trains/760/controller/x1_0.mp3"
	self.SoundNames["KV_0_-1"] = "subway_trains/760/controller/0_t1.mp3"
	self.SoundNames["KV_-1_-2"] = "subway_trains/760/controller/t1_t2.mp3"
	self.SoundNames["KV_-2_-3"] = "subway_trains/760/controller/t2_t3.mp3"
	self.SoundPositions["KV_-3_-2"] = {80,1e9,Vector(461.8,25.3,-27.7)}
	self.SoundPositions["KV_-2_-1"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_-1_0"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_0_1"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_1_2"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_2_3"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_3_4"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_4_3"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_3_2"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_2_1"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_1_0"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_0_-1"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_-1_-2"] = self.SoundPositions["KV_-3_-2"]
	self.SoundPositions["KV_-2_-3"] = self.SoundPositions["KV_-3_-2"]

	self.SoundNames["kro_in"] = {
		"subway_trains/717/kru/kru_insert1.mp3",
		"subway_trains/717/kru/kru_insert2.mp3"
	}
	self.SoundNames["kro_out"] = {
		"subway_trains/717/kru/kru_eject1.mp3",
		"subway_trains/717/kru/kru_eject2.mp3",
		"subway_trains/717/kru/kru_eject3.mp3",
	}
	self.SoundNames["kro_-1_0"] = {
		"subway_trains/722/switches/multi_switch_panel_mid.mp3",
		"subway_trains/722/switches/multi_switch_panel_mid2.mp3"
	}
	self.SoundNames["kro_0_1"] = {
		"subway_trains/722/switches/multi_switch_panel_max.mp3"
	}
	self.SoundNames["kro_1_0"] = {
		"subway_trains/722/switches/multi_switch_panel_mid.mp3",
		"subway_trains/722/switches/multi_switch_panel_mid2.mp3"
	}
	self.SoundNames["kro_0_-1"] = {
		"subway_trains/722/switches/multi_switch_panel_min.mp3"
	}
	self.SoundPositions["kro_in"] = {80,1e9,Vector(503.161194,-0.094173,55.346401)}
	self.SoundPositions["kro_out"] = self.SoundPositions["kro_in"]
	self.SoundPositions["kro_-1_0"] = self.SoundPositions["kro_in"]
	self.SoundPositions["kro_0_1"] = self.SoundPositions["kro_in"]
	self.SoundPositions["kro_1_0"] = self.SoundPositions["kro_in"]
	self.SoundPositions["kro_0_-1"] = self.SoundPositions["kro_in"]

	self.SoundNames["krr_in"] = self.SoundNames["kro_in"]
	self.SoundNames["krr_out"] = self.SoundNames["kro_out"]
	self.SoundNames["krr_-1_0"] = self.SoundNames["kro_-1_0"]
	self.SoundNames["krr_0_1"] = self.SoundNames["kro_0_1"]
	self.SoundNames["krr_1_0"] = self.SoundNames["kro_1_0"]
	self.SoundNames["krr_0_-1"] = self.SoundNames["kro_0_-1"]
	self.SoundPositions["krr_in"] = {80,1e9,Vector(502.262268,-1.651456,55.261826)}
	self.SoundPositions["krr_out"] = self.SoundPositions["krr_in"]
	self.SoundPositions["krr_-1_0"] = self.SoundPositions["krr_in"]
	self.SoundPositions["krr_0_1"] = self.SoundPositions["krr_in"]
	self.SoundPositions["krr_1_0"] = self.SoundPositions["krr_in"]
	self.SoundPositions["krr_0_-1"] = self.SoundPositions["krr_in"]

	self.SoundNames["switch_batt_on"] = {"subway_trains/760/vb_on.wav"}
	self.SoundNames["switch_batt_off"] = {"subway_trains/720/switches/batt_off.mp3","subway_trains/720/switches/batt_off2.mp3"}

	self.SoundNames["switch_batt"] = {"subway_trains/720/switches/batt_on.mp3","subway_trains/720/switches/batt_on2.mp3","subway_trains/720/switches/batt_off.mp3","subway_trains/720/switches/batt_off2.mp3"}

	self.SoundNames["switch_pvz_on"] = {"subway_trains/720/switches/switchb_on.mp3","subway_trains/720/switches/switchp_on.mp3"}
	self.SoundNames["switch_pvz_off"] = {"subway_trains/720/switches/switchb_off.mp3","subway_trains/720/switches/switchp_off.mp3"}

	self.SoundNames["switch_on"] = "subway_trains/722/switches/multi_switch_panel_max.mp3"
	self.SoundNames["switch_mid"] = {"subway_trains/722/switches/multi_switch_panel_mid.mp3","subway_trains/722/switches/multi_switch_panel_mid2.mp3"}
	self.SoundNames["switch_off"] = "subway_trains/722/switches/multi_switch_panel_min.mp3"

	self.SoundNames["button_press"] = {"subway_trains/720/switches/butt_press.mp3","subway_trains/720/switches/butt_press2.mp3","subway_trains/720/switches/butt_press3.mp3"}
	self.SoundNames["button_release"] = {"subway_trains/720/switches/butt_release.mp3","subway_trains/720/switches/butt_release2.mp3","subway_trains/720/switches/butt_release3.mp3"}

	self.SoundNames["button_square_press"] = "subway_trains/775/button_press.mp3"
	self.SoundNames["button_square_release"] = "subway_trains/775/button_release.mp3"

	self.SoundNames["button_square_on"] = "subway_trains/775/button_on.mp3"
	self.SoundNames["button_square_off"] = "subway_trains/775/button_off.mp3"

	self.SoundNames["button_nazhat"] = "subway_trains/720/switches/butts_press.mp3"
	self.SoundNames["button_nazhat_fix"] = "subway_trains/720/switches/butts_release.mp3"
	self.SoundNames["button_otzhat"] = "subway_trains/720/switches/butts_release.mp3"
	self.SoundNames["button_otzhat_fix"] = {"subway_trains/720/switches/butts_off.mp3","subway_trains/720/switches/butts_off2.mp3"}

	self.SoundNames["door_cab_open"] = {"subway_trains/720/door/door_torec_open.mp3","subway_trains/720/door/door_torec_open2.mp3"}
	self.SoundNames["door_cab_close"] = {"subway_trains/720/door/door_torec_close.mp3","subway_trains/720/door/door_torec_close2.mp3"}
	self.SoundNames["door_cab_roll"] = {"subway_trains/720/door/cabdoor_roll1.mp3","subway_trains/720/door/cabdoor_roll2.mp3","subway_trains/720/door/cabdoor_roll3.mp3","subway_trains/720/door/cabdoor_roll4.mp3"}

	for _, d in ipairs({
		{"r", Vector(435,-61,30)},
		{"l", Vector(397, 61,30)},
		{"p", Vector(363,-32,30)},
	}) do
		self.SoundNames["door_cab_"..d[1].."_open"]  = self.SoundNames["door_cab_open"]
		self.SoundNames["door_cab_"..d[1].."_close"] = self.SoundNames["door_cab_close"]
		self.SoundPositions["door_cab_"..d[1].."_open"]  = {300,1e9,d[2],0.8}
		self.SoundPositions["door_cab_"..d[1].."_close"] = {300,1e9,d[2],0.8}
	end
	self.SoundNames["door_add_1_open"]  = self.SoundNames["door_cab_open"]
	self.SoundNames["door_add_1_close"] = self.SoundNames["door_cab_close"]
	self.SoundPositions["door_add_1_open"]  = {800,1e9,Vector(388,-47.5,27),0.5}
	self.SoundPositions["door_add_1_close"] = {800,1e9,Vector(388,-47.5,27),0.5}

	if not self.SoundNames["pb_on"] then
		self.SoundNames["pb_on"]  = {"subway_trains/720/switches/butt_press.mp3","subway_trains/720/switches/butt_press2.mp3","subway_trains/720/switches/butt_press3.mp3"}
	end
	if not self.SoundNames["pb_off"] then
		self.SoundNames["pb_off"] = {"subway_trains/720/switches/butt_release.mp3","subway_trains/720/switches/butt_release2.mp3","subway_trains/720/switches/butt_release3.mp3"}
	end
	if not self.SoundPositions["pb_on"] then self.SoundPositions["pb_on"] = {150,1e9,Vector(462,18,-40),0.3} end
	if not self.SoundPositions["pb_off"] then self.SoundPositions["pb_off"] = {150,1e9,Vector(462,18,-40),0.3} end

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

	self.SoundNames["work_beep"] = {loop=true,"subway_trains/720/work_beep_loop.wav"}
	self.SoundPositions["work_beep"] = {100,1e9,Vector(407.5,23,10),0.05}
	self.SoundNames["batt_on"] = "subway_trains/720/batt_on.mp3"
	self.SoundPositions["batt_on"] = {400,1e9,Vector(126.4,50,-60-23.5),0.3}

	self.SoundNames["igla_on"]	= "subway_trains/common/other/igla/igla_on1.mp3"
	self.SoundNames["igla_off"]	= "subway_trains/common/other/igla/igla_off2.mp3"
	self.SoundNames["igla_start1"]	= "subway_trains/775/igla/igla_start.mp3"
	self.SoundNames["igla_start2"]	= "subway_trains/775/igla/igla_start2.mp3"
	self.SoundNames["igla_alarm1"]	= "subway_trains/common/other/igla/igla_alarm1.mp3"
	self.SoundNames["igla_alarm2"]	= "subway_trains/common/other/igla/igla_alarm2.mp3"
	self.SoundNames["igla_alarm3"]	= "subway_trains/common/other/igla/igla_alarm3.mp3"
	self.SoundPositions["igla_on"] = {50,1e9,Vector(452.56,62,3.81),0.3}
	self.SoundPositions["igla_off"] = {50,1e9,Vector(452.56,62,3.81),0.3}
	self.SoundPositions["igla_start1"] = {50,1e9,Vector(452.56,62,3.81),0.5}
	self.SoundPositions["igla_start2"] = {50,1e9,Vector(452.56,62,3.81),0.3}
	self.SoundPositions["igla_alarm1"] = {50,1e9,Vector(452.56,62,3.81),0.5}
	self.SoundPositions["igla_alarm2"] = {50,1e9,Vector(452.56,62,3.81),0.5}
	self.SoundPositions["igla_alarm3"] = {50,1e9,Vector(452.56,62,3.81),0.5}

    self.SoundNames["epk_brake"] = {loop=true,"subway_trains/760/new/rvtb_loop.wav"}
    self.SoundPositions["epk_brake"] = {80,1e9,Vector(458,56.5,-61),0.65}
    self.SoundNames["epk_brake_close"] = {"subway_trains/760/new/rvtb_end.wav"}
    self.SoundPositions["epk_brake_close"] = {80,1e9,Vector(458,56.5,-61),0.65}
    self.SoundNames["epk_brake_open"] = {"subway_trains/760/new/rvtb_start.wav"}
    self.SoundPositions["epk_brake_open"] = {80,1e9,Vector(458,56.5,-61),0.65}

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
		return Vector(381 - 36.0 + 1*(k) -0.85*(k == 1 and 1 or 0) - 230*i,-66*(1-2*k),-1)
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

	self.SoundPositions["door_cab_l_open"] = {800,1e9,Vector(412.8,63.2,34.5),0.5}
	self.SoundNames["door_cab_l_close"] = self.SoundNames["door_cab_close"]
	self.SoundPositions["door_cab_l_close"] = {800,1e9,Vector(412.8,63.2,34.5),0.5}
	self.SoundNames["door_cab_r_open"] = self.SoundNames["door_cab_open"]
	self.SoundPositions["door_cab_r_open"] = {800,1e9,Vector(412.8,-63.2,34.5),0.5}
	self.SoundNames["door_cab_r_close"] = self.SoundNames["door_cab_close"]
	self.SoundPositions["door_cab_r_close"] = {800,1e9,Vector(412.8,-63.2,34.5),0.5}
	self.SoundNames["door_cab_m_open"] = self.SoundNames["door_cab_open"]
	self.SoundPositions["door_cab_m_open"] = {800,1e9,Vector(380,5,-12.3),0.5}
	self.SoundNames["door_cab_m_close"] = self.SoundNames["door_cab_close"]
	self.SoundPositions["door_cab_m_close"] = {800,1e9,Vector(380,5,-12.3),0.5}
	self.SoundNames["door_pvz_open"] = self.SoundNames["door_cab_open"]
	self.SoundPositions["door_pvz_open"] = {800,1e9,Vector(-475.96,37.90,-30.33),0.5}
	self.SoundNames["door_pvz_close"] = self.SoundNames["door_cab_close"]
	self.SoundPositions["door_pvz_close"] = {800,1e9,Vector(-475.96,37.90,-30.33),0.5}

	self.SoundNames["bkpu"] = {"subway_trains/760/vb_on.wav"}
	self.SoundPositions["bkpu"] = {800,1e9,Vector(410.2,59,1),0.5}
	self.SoundNames["ring_ppz"] = {loop = true,"subway_trains/760/new/ring_vityaz.wav"}
	self.SoundPositions["ring_ppz"] = {800,1e9,Vector(410.2,57,1),0.5}
	self.SoundNames["ring_call"] = {loop=0,"subway_trains/722/ring1_loop.wav","subway_trains/722/ring1_loop.wav","subway_trains/722/ring1_end.wav"}
	self.SoundPositions["ring_call"] = {100,1e9,Vector(409,25.6,-26.3)}
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
end

function ENT:InitializeSystems()
	self:LoadSystem("TR","TR_3B")
	self:LoadSystem("Electric","81_775_Electric_new")
	self:LoadSystem("BUTP","81_775_AsyncInverter")
	self:LoadSystem("RV","81_720_RV")

	self:LoadSystem("BKPU","81_775_BKPU")
	self:LoadSystem("BUV","81_775_BUV")
	self:LoadSystem("BUD","81_775_BUD")

    self:LoadSystem("ALSCoil")
	self:LoadSystem("ATC1","81_775_ATC_C",1)
	self:LoadSystem("ATC2","81_775_ATC_C",2)

	self:LoadSystem("Panel","81_775_Panel")

	self:LoadSystem("SD3","Relay","Switch")
	self:LoadSystem("Pneumatic","81_775_Pneumatic")
	self:LoadSystem("BTBU","81_775_BTBU")
	self:LoadSystem("Horn","81_775_Horn")

	self:LoadSystem("Announcer","81_775_Announcer")

	self:LoadSystem("Controller","81_775_Controller")

    self:LoadSystem("MFDU", "81_775_MFDU")
	self:LoadSystem("Speedometer","81_775_Speedometer")
	self:LoadSystem("MVO","81_775_MVO")

	self:LoadSystem("BNT","775BNT")
	self:LoadSystem("Screens","775_TVSCREEN")

	self:LoadSystem("IGLA_CBKI","81_775_IGLA_CBKI1")
	self:LoadSystem("IGLA_PCBK","81_775_IGLA_PCBK")
	self:LoadSystem("ASNP","81_775_ASNP")
	self:LoadSystem("ASNP_VV","81_775_ASNP_VV")

	self:LoadSystem("Prost_Kos","81_775_Prost_Kos")

	self:LoadSystem("81_775_MosLogo")
	self:LoadSystem("ROUTER","81_775_ROUTER")

	self:LoadSystem("BNTN","81_775_BNTN")

	self:LoadSystem("CPanel","81_775_CPanel")
	self:LoadSystem("CIK", "81_775_CIK")

	self:LoadSystem("CoupleCenteringF","Relay","Switch",{bass = true})
end

function ENT:PostInitializeSystems()
    self.Electric:TriggerInput("Type",self.Electric.T775)
end

ENT.SubwayTrain = {
	Type = "81-77",
	Name = "81-775",
	WagType = 1,
	Manufacturer = "MVM",
	ALS = {
        HaveAutostop = true,
        TwoToSix = true,
        RSAs325Hz = true,
        Aproove0As325Hz = false,
    },
    EKKType = 775,
    NoFrontEKK=true,
}
ENT.NumberRanges = {{75001,75330}}

local function Wag775Rot(i, n)
	local half = math.ceil(n/2)
	if i <= half then return i % 2 == 0 end
	return (n - i) % 2 == 0
end
ENT.Wag775Rot = Wag775Rot

if SERVER and not Metrostroi_775RotRandom then
	local origRandom = math.random
	Metrostroi_775RotRandom = {Queue = nil, Expire = 0}
	local R = Metrostroi_775RotRandom
	local function callerIsSpawnerLoop()
		for idx = 1, 64 do
			local name = debug.getlocal(3, idx)
			if not name then return false end
			if name == "LastRot" then return true end
		end
		return false
	end
	math.random = function(...)
		if R.Queue and select("#", ...) == 0 then
			if CurTime() > R.Expire or #R.Queue == 0 then
				R.Queue = nil
			elseif callerIsSpawnerLoop() then
				return table.remove(R.Queue, 1)
			end
		end
		return origRandom(...)
	end
end

ENT.Spawner = {
	model = {
		"models/metrostroi_train/81-775/775_body.mdl",
		"models/metrostroi_train/81-775/775_salon.mdl",
	},
	spawnfunc = function(i,tbls,tblt)
        local WagNum = tbls.WagNum
        if SERVER and i == 1 and Metrostroi_775RotRandom then
            local q = {}
            for k = 2, WagNum-1 do q[#q+1] = Wag775Rot(k, WagNum) and 1 or 0 end
            Metrostroi_775RotRandom.Queue = q
            Metrostroi_775RotRandom.Expire = CurTime() + 5
        end
        if 1<i and i<WagNum  then
            if i==2 or (WagNum==8 and i==WagNum-1) then
                return "gmod_subway_81-777"
            else
                return "gmod_subway_81-776"
            end
        else
            return "gmod_subway_81-775"
        end
    end,
	WagNumTable = {2,3,4,5,6,7,8},
	costomrotat = function(i,wags)
		return Wag775Rot(i, wags)
	end,
	func = function(ent,i,WagNum,LastRot)
		ent:GenerateWagonNumber(i,WagNum)
	end,

{"MosLogoType","Тип логотипа","List",{"МосМетро","МосТранспорт"}, "Выберите тип отображения логотипа MosLogo", function(ent,val,rot,i,wagnum,rclk)
    if rclk then return end
    ent.MosLogoType = (val == 2) and 3 or 2
    if ent.MosLogo then
        ent.MosLogo:TriggerInput("LogoType",ent.MosLogoType)
    end
end},

    {"SpawnMode","Spawner.Common.SpawnMode","List",{"Spawner.Common.SpawnMode.Full","Spawner.Common.SpawnMode.Deadlock","Spawner.Common.SpawnMode.NightDeadlock","Spawner.Common.SpawnMode.Depot"}, nil,function(ent,val,rot,i,wagnum,rclk)
		if rclk then return end

        if ent._SpawnerStarted~=val then
            ent.GV:TriggerInput("Set",val<4 and 1 or 0)
			if val==1 and ent.BV then
				ent.BV:TriggerInput('Close',1)
			end
			if val==1 and (i==1 or i==wagnum) then
				timer.Simple(5,function()
					if not IsValid(ent) or not ent.HeadlightsSwitch then return end
					ent.HeadlightsSwitch:TriggerInput("Set",2)
				end)
			end
			if val==1 and i==1 then
				timer.Simple(5,function()
					if not IsValid(ent) then return end
					ent.EnableBS:TriggerInput('Toggle',1)
					timer.Simple(5,function()
						if not IsValid(ent) then return end
						ent.EnableBS:TriggerInput('Toggle',1)
					end)
				end)
			end

			ent.Pneumatic.TrainLinePressure = val==3 and 5+math.random() or val==2 and 6.6+math.random()*1.5 or 7.6+math.random()*0.5
			if not ent.SF1 then
				ent.Pneumatic.TLPressure = ent.Pneumatic.TrainLinePressure
			end
			ent.Pneumatic.ParkingBrakePressure = val == 3 and 0 or ent.Pneumatic.TrainLinePressure
			ent.Pneumatic.ParkingBrake = (val == 3)

            ent._SpawnerStarted = val
        end
    end},

}
local function Strip775DirtSpawner()
	for _, cls in ipairs({"gmod_subway_81-775", "gmod_subway_81-776", "gmod_subway_81-777"}) do
		local st = scripted_ents.GetStored(cls)
		local sp = st and st.t and st.t.Spawner
		if sp then
			for k = #sp, 1, -1 do
				local v = sp[k]
				if istable(v) and v[1] == "DirtLevelCustom" then table.remove(sp, k) end
			end
		end
	end
end
hook.Add("InitPostEntity", "81-775_NoDirtSpawner", Strip775DirtSpawner)
timer.Create("81-775_NoDirtSpawner", 1, 10, Strip775DirtSpawner)
