include("shared.lua")

ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
ENT.ClientPropsInitialized = false

local door_button_w = 625
local door_button_h = 1700

ENT.ButtonMap["CabinRightDoor"] = {
	pos = Vector(435, -61, 55),
	ang = Angle(0, 180, 90),
	width = door_button_w,
	height = door_button_h,
	scale = 0.0605,
	buttons = {
		{ID = "CabinRightDoor", x=0, y=0, w=door_button_w, h=door_button_h, tooltip = "Дверь"}
	}
}

ENT.ButtonMap["CabinLeftDoor"] = {
	pos = Vector(397, 61, 55),
	ang = Angle(0, 0, 90),
	width = door_button_w,
	height = door_button_h,
	scale = 0.0605,
	buttons = {
		{ID = "CabinLeftDoor", x=0, y=0, w=door_button_w, h=door_button_h, tooltip = "Дверь"}
	}
}

ENT.ButtonMap["CabinPassDoor"] = {
	pos = Vector(363, -32, 55),
	ang = Angle(0, 90, 90),
	width = door_button_w,
	height = door_button_h,
	scale = 0.0605,
	buttons = {
		{ID = "CabinPassDoor", x=0, y=0, w=door_button_w, h=door_button_h, tooltip = "Дверь"}
	}
}

local function CabinDoorOtherSide(name, pos, angle)
	local tbl = ENT.ButtonMap[name]

	ENT.ButtonMap[name .. "OtherSide"] = {
		pos = pos,
		ang = angle,
		width = tbl.width,
		height = tbl.height,
		scale = tbl.scale,
		buttons = tbl.buttons
	}
end

CabinDoorOtherSide("CabinRightDoor", Vector(435 - (625*0.0605), -65, 55), Angle(0, 0, 90))
CabinDoorOtherSide("CabinLeftDoor", Vector(397 + (625*0.0605), 65, 55), Angle(0, 180, 90))
CabinDoorOtherSide("CabinPassDoor", Vector(367, -32 + (625*0.0605), 55), Angle(0, 270, 90))

ENT.ClientProps["underwagon"] = {
    model = "models/metrostroi_train/81-775/775_underwagon.mdl",
    pos = Vector(0,0,-74.5),
    ang = Angle(0,0,0),
    hide = 2.0,
}
ENT.ClientProps["crane_tm"] = {
	model = "models/metrostroi_train/81-775/81_760a_crane_nm.mdl",
	pos = Vector(390,0,-64),
	ang = Angle(0,0,0),
	hide = 2,
}
ENT.ClientProps["crane_nm"] = {
	model = "models/metrostroi_train/81-775/81_760a_crane_nm.mdl",
	pos = Vector(396,4,-66),
	ang = Angle(0,0,0),
	hide = 2,
}
ENT.ClientProps["crane_tm2"] = {
	model = "models/metrostroi_train/81-775/81_760a_crane_nm.mdl",
	pos = Vector(-490,0,-64),
	ang = Angle(0,0,0),
	hide = 2,
}
ENT.ClientProps["crane_nm2"] = {
	model = "models/metrostroi_train/81-775/81_760a_crane_nm.mdl",
	pos = Vector(-496,4,-66),
	ang = Angle(0,0,0),
	hide = 2,
}
ENT.ClientProps["vent"] = {
    model = "models/metrostroi_train/81-775/775_vent.mdl",
    pos = Vector(-23.7,0,74.9),
    ang = Angle(0,0,0),
    hide = 2.0,
}
ENT.ClientProps["salon"] = {
	pos = Vector(-1.96, 0, 6.47),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/775_salon.mdl",
	hide = 2,
}
ENT.ClientProps["ppz"] = {
	pos = Vector(387.5, 45.32, 23.75),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/775_ppz.mdl",
	hide = 2,
}
ENT.ClientProps["pods"] = {
	pos = Vector(459.7,27.2,-7.63),
	ang = Angle(0, 91, -0.4),
	model = "models/metrostroi_train/81-775/pods.mdl",
	scale = 1
}
ENT.ClientProps["shema"] = {
	pos = Vector(153, 60.3, 25),
	ang = Angle(0, 90, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema1"] = {
	pos = Vector(-81, 60.3, 25),
	ang = Angle(0, 90, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema2"] = {
	pos = Vector(-314.5, 60.3, 25),
	ang = Angle(0, 90, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema3"] = {
	pos = Vector(20.7, -60.3, 25),
	ang = Angle(0, 270, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema4"] = {
	pos = Vector(-213.5, -60.3, 25),
	ang = Angle(0, 270, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema5"] = {
	pos = Vector(-460, -60.3, 25),
	ang = Angle(0, 270, 0),
	model = "",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["Lpult"] = {
	pos = Vector(444.5, 48.6, -6.4),
	ang = Angle(-39, -114.5, 6),
	model = "models/metrostroi_train/81-775/Lpult.mdl",
	hide = 2,
	scale = 1.05,
	callback = function(ent, cent)
		cent:SetMaterial("models/metrostroi_train/81-775/Lpult")
	end,
}
ENT.ClientProps["chair"] = {
	pos = Vector(432.8, 16.3, -16.3),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/775_chair.mdl",
	hide = 2,
}
ENT.ClientProps["wiper"] = {
    model = "models/metrostroi_train/81-760/81_760_wiper.mdl",
    pos = Vector(-19,-4,4),
    ang = Angle(0,0,0),
	hide=2,
}
ENT.ClientProps["cabin"] = {
	pos = Vector(428.5, 0, 4.6),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/775_cabin.mdl",
	hide = 4,
}
ENT.ClientProps["mano_glass"] = {
	pos = Vector(428.5, 0, 4.6),
	ang = Angle(0, -90, 0),
	model = "models/metrostroi_train/81-775/775_mano_glass.mdl",
	hide = 4,
}
ENT.ClientProps["cab_glass"] = {
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/775_cab_glass.mdl",
	hide = 4,
}
ENT.ClientProps["pult"] = {
	pos = Vector(459.6, 23, -21),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/775_pult_new.mdl",
	hide = 2,
}
ENT.ClientProps["ecran1"] = {
	pos = Vector(-459.75, 61.2, 23.35),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/775_ecran.mdl",
	hide = 2,
}
ENT.ClientProps["lamps"] = {
	pos = Vector(-81.83, 0, 58.95),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/775_lamps.mdl",
	hide = 2,
}
ENT.ClientProps["door0x1"] = {
    model = "models/metrostroi_train/81-775/775_passdoors1_IFE.mdl",
    pos = Vector(315,68,6.2),
    ang = Angle(0,90,0),
    hide = 2.0,
}

ENT.ClientProps["door1x1"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(86.6,68,6.2),
    ang = Angle(0,90,0),
    hide = 2.0,
}
ENT.ClientProps["door2x1"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(-147.3,68,6.2),
    ang = Angle(0,90,0),
    hide = 2.0,
}
ENT.ClientProps["door3x1"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(-380.9,68,6.2),
    ang = Angle(0,90,0),
    hide = 2.0,
}
ENT.ClientProps["door0x0"] = {
    model = "models/metrostroi_train/81-775/775_passdoors1_IFE.mdl",
    pos = Vector(315,-68,6.2),
    ang = Angle(0,-90,0),
    hide = 2.0,
}
ENT.ClientProps["door1x0"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(86.6,-68,6.2),
    ang = Angle(0,-90,0),
    hide = 2.0,
}
ENT.ClientProps["door2x0"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(-147.3,-68,6.2),
    ang = Angle(0,-90,0),
    hide = 2.0,
}
ENT.ClientProps["door3x0"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(-380.9,-68,6.2),
    ang = Angle(0,-90,0),
    hide = 2.0,
}

ENT.ClientProps["salon_led0x1"] = {
	model = "models/metrostroi_train/81-775/salon_led1.mdl",
	pos = Vector(315.3,52.55,0),
	ang = Angle(0,90,0),
}
ENT.ClientProps["salon_led1x1"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(81.5,52.55,0),
	ang = Angle(0,90,0),
}
ENT.ClientProps["salon_led2x1"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(-152.3,52.55,0),
	ang = Angle(0,90,0),
}
ENT.ClientProps["salon_led3x1"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(-386.2,52.55,0),
	ang = Angle(0,90,0),
}
ENT.ClientProps["salon_led0x0"] = {
	model = "models/metrostroi_train/81-775/salon_led1.mdl",
	pos = Vector(315.3,-52.55,0),
	ang = Angle(0,-90,0),
}
ENT.ClientProps["salon_led1x0"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(92.3,-52.55,0),
	ang = Angle(0,-90,0),
}
ENT.ClientProps["salon_led2x0"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(-141.5,-52.55,0),
	ang = Angle(0,-90,0),
}
ENT.ClientProps["salon_led3x0"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(-375.4,-52.55,0),
	ang = Angle(0,-90,0),
}
for i=1,4 do
	ENT.ClientProps["TR"..i] = {
		model = "models/metrostroi_train/81-760/81_760_pantograph.mdl",
		pos = Vector(0,0,0),
		ang = Angle(0,180*(i%2),0),
		hide = 2,
        callback = function(ent,cl_ent)
			local rearbogey,frontbogey = ent:GetNW2Entity("RearBogey"),ent:GetNW2Entity("FrontBogey")
			if i <= 2 then
				if not IsValid(frontbogey) then
					ent:ShowHide("TR"..i,false)
					return
				end
				cl_ent:SetParent(frontbogey)
				cl_ent:SetPos(frontbogey:GetPos())
				local ang = frontbogey:GetAngles()
				cl_ent:SetAngles(i%2 == 1 and Angle(-ang.x,180+ang.y,-ang.z) or ang)
			else
				if not IsValid(rearbogey) then
					ent:ShowHide("TR"..i,false)
					return
				end
				cl_ent:SetParent(rearbogey)
				cl_ent:SetPos(rearbogey:GetPos())
				local ang = rearbogey:GetAngles()
				cl_ent:SetAngles(i%2 == 1 and Angle(-ang.x,180+ang.y,-ang.z) or ang)
			end
        end,
	}
end

ENT.ClientProps["CabinRightDoor"] = {
    model = "models/metrostroi_train/81-775/775_doors_1.mdl",
    pos = Vector(396.3,-64.58, 1.85),
    ang = Angle(0,0,0),
    hide = 2.0,
}
ENT.ClientProps["CabinLeftDoor"] = {
    model = "models/metrostroi_train/81-775/775_doors_2.mdl",
    pos = Vector(-25.5, 0.22, 1.85),
    ang = Angle(0,0,0),
    hide = 2.0,
}
ENT.ClientProps["CabinLeftDoorGlass"] = {
    model = "models/metrostroi_train/81-775/775_doors_2_glass.mdl",
    pos = Vector(-25.5, 0.22, 1.85),
    ang = Angle(0,0,0),
    hide = 2.0,
}
ENT.ClientProps["CabinRightDoorGlass"] = {
    model = "models/metrostroi_train/81-775/775_doors_1_glass.mdl",
    pos = Vector(396.3,-64.58, 1.85),
    ang = Angle(0,0,0),
    hide = 2.0,
}
ENT.ClientProps["CabinPassDoor"] = {
    model = "models/metrostroi_train/81-775/775_doors_3.mdl",
    pos = Vector(-25.5, 0.22, 1.85),
    ang = Angle(0,0,0),
    hide = 2.0,
}

local CABDOOR = {
	HANDLE_ANGLE    = 40,
	PRESS_TIME      = 0.18,
	HOLD_OPEN       = 0.35,
	RELEASE_TIME    = 0.25,
	CLOSE_SND_DELAY = 1.6,
	CLOSE_TIMEOUT   = 4,
	HANDLES_ENABLED = true,
}
CABDOOR.Handles = {
	CabinRightDoor = {axis = "roll", sign = -1, bones = {"handle_out", "handle_in"}},
	CabinLeftDoor  = {axis = "roll", sign = -1, bones = {"handle_out", "handle_in"}},
	CabinPassDoor  = {axis = "yaw",  sign = 1,  bones = {"handle_cab", "handle_salon"}},
}

local button_vmax = 1

local function AddButton(name, isToggle, color, x, y, lampVar, z, vmax)

	local but = {
		ID = name .. (isToggle and "Toggle" or "Set"),
		x = x,
		y = y,
		radius = 15,
		tooltip = "",
		model = {
			model = string.format("models/metrostroi_train/81-775/81-775_button1_%s.mdl", color == "lime" and "green" or color),
			z = (z ~= nil) and z or (color == "emerbrake" and -3 or 0),
			var = name,

			speed = 12,
			vmin = 0,
			vmax = vmax or button_vmax,

			sndvol = 0.3,
			snd = function(val) return val and "button_press" or "button_release" end,
			sndmin = 80,
			sndmax = 1e3/3,
			sndang = Angle(-90,0,0)
		}
	}

	if isToggle then
		but.model.getfunc = function(self, vmin, vmax, var)
			return self:GetPackedRatio(name)
		end

		but.model.snd = function(_, val)
			if val == 1 then
				return "button_nazhat"
			end
			if val == 0.5 then
				return "button_nazhat_fix"
			end
			if val == 0 then
				return "button_otzhat_fix"
			end

			return "button_square_off"
		end
	end

	if lampVar then

		but.model.lamp = {
			model = string.format("models/metrostroi_train/81-775/lamps/81-775_button1_%s_glow.mdl", color == "gray" and "darkblue" or color),
			scale = 1,
			var = lampVar,
			z = 0,
			anim = true
		}
	end
	if color == "emerbrake" then
		but.model.model = "models/metrostroi_train/81-775/81-775_button_emerbrake1.mdl"
		but.model.lamp.model = "models/metrostroi_train/81-775/lamps/81-775_button_emerbrake1_glow.mdl"
	end

	return but
end

local function AddLamp(name, color, x, y, var)
	return {
		ID = "!" .. name,
		x = x,
		y = y,
		radius = 15,
		tooltip = "",
		model = {
			model = string.format("models/metrostroi_train/81-775/81-775_button1_%s.mdl", color),
			z = 0,
			lamp = {
				model = string.format("models/metrostroi_train/81-775/lamps/81-775_button1_%s_glow.mdl", color == "black" and "white" or color),
				ang = Angle(0,0,0),
				scale = 1,
				x = 0,
				y = 0,
				z = 0,
				anim = true,
				var = var,
			}
		},
	}

end

local rotYbase = 326-270.5
local rotXbase = 48
local rotXoffset = 48.6
local rotYoffset = 52

ENT.ButtonMap["PMV"] = {
	pos = Vector(387.6,31.87,29.09),
	ang = Angle(0,90,90),
	width = 440,
	height = 700,
	scale = 0.0605,
	hideseat=0.2,

	buttons = {
		{ID = "!PVZBuzzer", x = 342, y = 290-264.5, radius = 0, tooltip = "", model = {
			model = "",
			var = "noname3",
			speed = 0,
			vmin = 0,
			vmax = 0,
		}},
		AddButton("ChargeAKB", true, "blue", 388.4, 297-264.5, "ChargeAKBLamp", 0, 0.5),
		AddButton("EnableBS", false, "green", 388.4-48.5, 293+43.4-264.5, "EnableBSLamp", 0, 0.5),
		AddButton("DisableBS", false, "yellow", 388.4, 293+43.4-264.5, "DisableBSLamp", 0, 0.5),
		AddButton("ALSDecoder", true, "black", 388.4-48.5, 290+43.4*2-264.5, nil, 0, 0.5),
		AddButton("_Rezerv", false, "yellow", 388, 290+43.4*2-264.5, nil, 0, 0.5),
		{ID = "NightStayToggle",x=rotXbase+14, y=rotYbase, radius=20, tooltip = "Ночной отстой",model = {
			model =  "models/metrostroi_train/81-775/775_switch_ppz.mdl", ang=Angle(180,90,0), z = 0,
			var="NightStay",speed=6,
			sndvol = 0.5, snd = function(val) return val and "switch_batt_on" or "switch_batt_off" end, sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),min = 1, max = 0,
		}},
		{ID = "TLBLToggle",x=rotXbase+rotXoffset+11, y=rotYbase, radius=20, tooltip = "НМ.ТМ",model = {
			model =  "models/metrostroi_train/81-775/775_switch_ppz.mdl", ang=Angle(180,90,0), z = 0,
			var="TLBL",speed=6,
			plomb = {var="TLBLPl", ID="TLBLPl", },
			sndvol = 0.5, snd = function(val) return val and "switch_batt_on" or "switch_batt_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),min = 1, max = 0,
		}},

		{ID = "SalonConditionerToggle",x=rotXbase+rotXoffset*3+3, y=rotYbase, radius=20, tooltip = "Кондиционер салона",model = {
			model =  "models/metrostroi_train/81-775/775_switch_ppz.mdl", ang=Angle(180,90,0), z = 0,
			var="SalonConditioner",speed=6,
			sndvol = 0.5, snd = function(val) return val and "switch_batt_on" or "switch_batt_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),min = 1, max = 0,
		}},

		{ID = "EmerLDOpToggle",x=rotXbase+rotXoffset*4, y=rotYbase, radius=20, tooltip = "Аварийное открытие дверей: левые",model = {
			model =  "models/metrostroi_train/81-775/775_switch_ppz.mdl", ang=Angle(180,90,0), z = 0,
			var="EmerLDOp",speed=6,
			sndvol = 0.5, snd = function(val) return val and "switch_batt_on" or "switch_batt_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),min = 0, max = 1,
		}},
		{ID = "EmerRDOpToggle",x=rotXbase+rotXoffset*5-5, y=rotYbase, radius=20, tooltip = "Аварийное открытие дверей: правые",model = {
			model =  "models/metrostroi_train/81-775/775_switch_ppz.mdl", ang=Angle(180,90,0), z = 0,
			var="EmerRDOp",speed=6,
			sndvol = 0.5, snd = function(val) return val and "switch_batt_on" or "switch_batt_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),min = 0, max = 1,
		}},

		{ID = "ParkingBrakeToggle",x=rotXbase+rotXoffset+10, y=rotYbase+rotYoffset-3, radius=20, tooltip = "Стояночный тормоз",model = {
			model =  "models/metrostroi_train/81-775/775_switch_ppz.mdl", ang=Angle(180,90,0), z = 0,
			var="ParkingBrake",speed=6,
			sndvol = 0.5, snd = function(val) return val and "switch_batt_on" or "switch_batt_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),min = 0, max = 1,
		}},
		{ID = "ALSFreqToggle",x=rotXbase+rotXoffset*3+3, y=rotYbase+rotYoffset-3, radius=20, tooltip = "Переключатель диапазонов ДАУ, 2/6",model = {
			model =  "models/metrostroi_train/81-775/775_switch_ppz.mdl", ang=Angle(180,90,0), z = 0,
			var="ALSFreq",speed=6,
			sndvol = 0.5, snd = function(val) return val and "switch_batt_on" or "switch_batt_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),min = 0, max = 1,
		}},
		{ID = "RPDPPowerToggle",x=rotXbase+rotXoffset*4, y=rotYbase+rotYoffset-3, radius=20, tooltip = "Питание РПДП",model = {
			model =  "models/metrostroi_train/81-775/775_switch_ppz.mdl", ang=Angle(180,90,0), z = 0,
			var="RPDPPower",speed=6,
			sndvol = 0.5, snd = function(val) return val and "switch_batt_on" or "switch_batt_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0), min = 0, max = 1,
		}},
		{ID = "EmerPowerToggle",x=rotXbase+rotXoffset*5-4, y=rotYbase+rotYoffset-3, radius=20, tooltip = "Аварийное питание",model = {
			model =  "models/metrostroi_train/81-775/775_switch_ppz.mdl", ang=Angle(180,90,0), z = 0,
			var="EmerPower",speed=6,
			sndvol = 0.5, snd = function(val) return val and "switch_batt_on" or "switch_batt_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0), min = 0, max = 1,
		}},

		{ID = "!ATSBlock",x=rotXbase+rotXoffset*2+6, y=rotYbase+rotYoffset-3, radius=0, model = {
			model = "models/metrostroi_train/81-775/775_switch_ppz.mdl",z=0,ang=Angle(-160,90,-20),
			getfunc = function(ent) return ent:GetPackedRatio("ATSBlock") end,var="ATSBlock",
			plomb = {var="ATSBlockPl", ID="ATSBlockPl", },
			speed=6, min=0,max=1.25,
			sndvol = 1, snd = function(_,val) return val==3 and "switch_batt_on" or val == 0 and "switch_batt_off" or "switch_batt" end,
			sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
		}},
		{ID = "ATSBlock-",x=rotXbase+rotXoffset*2-15, y=rotYbase+rotYoffset-20,w=15,h=40,tooltip="Блокиратор АТС: -",model={
			plomb = {var="ATSBlockPl", ID="ATSBlockPl", },
		}},
		{ID = "ATSBlock+",x=rotXbase+rotXoffset*2, y=rotYbase+rotYoffset-20,w=15,h=40,tooltip="Блокиратор АТС: +", model={
			plomb = {var="ATSBlockPl", ID="ATSBlockPl", },
		}},

		{ID = "!VTBBlock",x=rotXbase+rotXoffset*2+6, y=rotYbase, radius=0, model = {
			model = "models/metrostroi_train/81-775/775_switch_vtb2.mdl", z=0, ang=Angle(200,90,0),
			getfunc = function(ent) return ent:GetPackedRatio("VTBBlock") end,var="VTBBlock",
			plomb = {var="VTBBlockPl", ID="VTBBlockPl", },

			speed=3, min=0,max=1,
			sndvol = 1, snd = function(_,val) return val==2 and "switch_batt_on" or val == 0 and "switch_batt_off" or "switch_batt" end,
			sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
		}},

		{ID = "VTBBlock-",x=rotXbase+rotXoffset*2-15, y=rotYbase-20,w=15,h=40,tooltip="Блокиратор ВТБ: -",model={
			plomb = {var="VTBBlockPl", ID="VTBBlockPl", },
		}},

		{ID = "VTBBlock+",x=rotXbase+rotXoffset*2, y=rotYbase-20,w=15,h=40,tooltip="Блокиратор ВТБ: +", model={
			plomb = {var="VTBBlockPl", ID="VTBBlockPl", },
		}},
		{ID = "!PantBlock",x=rotXbase+14, y=rotYbase+rotYoffset-3, radius=0, model = {
			model = "models/metrostroi_train/81-775/775_switch_pant.mdl",z=0,ang=Angle(70,90,21),
			getfunc = function(ent)
				local pos = math.Clamp(math.floor(ent:GetPackedRatio("PantBlock")*3+0.5),0,3)
				return ({0,0.25,0.5,1})[pos+1]
			end,var="PantBlock",
			plomb = {var="PantBlockPl", ID="PantBlockPl", },
			speed=6,
			sndvol = 1, snd = function(_,val) return val==2 and "switch_batt_on" or val == 0 and "switch_batt_off" or "switch_batt" end,
			sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
		}},
		{ID = "PantBlock-",x=rotXbase, y=rotYbase+rotYoffset-20,w=15,h=40,tooltip="Токоприёмники: -",model={
			plomb = {var="PantBlockPl", ID="PantBlockPl", },
		}},
		{ID = "PantBlock+",x=rotXbase+15, y=rotYbase+rotYoffset-20,w=15,h=40,tooltip="Токоприёмники: +", model={
			plomb = {var="PantBlockPl", ID="PantBlockPl", },
		}},
	}
}

ENT.ClientProps["volt_lv"] = {
	model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
	pos = Vector(471.35,52.5,32.7),
	ang = Angle(-6,-50,5),
	hide = 0.2,
}
local HV_ZERO_PITCH = -19
ENT.ClientProps["volt_hv"] = {
	model = "models/metrostroi_train/81-760/81_760_arrow_electric.mdl",
	pos = Vector(472,52.25,28.25),
	ang = Angle(10+HV_ZERO_PITCH,-53,5),
	hide = 0.2,
}
ENT.ClientProps["brake_cylinder"] = {
	model = "models/metrostroi_train/81-760/81_760_arrow_nm.mdl",
	pos = Vector(472.8,51.9,23.2),
	ang = Angle(-5.4,34.310871,-44.322998),
	hideseat = 0.2,
}
ENT.ClientProps["train_line"] = {
	model = "models/metrostroi_train/81-760/81_760_arrow_nm.mdl",
	pos = Vector(473.7,51.92,17.25),
	ang = Angle(-5.400000,34.310871,-44.322998),
	hideseat = 0.2,
}

ENT.ClientProps["brake_line"] = {
	model = "models/metrostroi_train/81-760/81_760_arrow_tm.mdl",
	pos = Vector(473.69,51.90,17.25),
	ang = Angle(-5.400000,34.310871,-44.322998),
	hideseat = 0.2,
}

local sf_max = 16

local sf_offset_x = 88-1
local sf_offset_y = 208

local sf_w = 16
local sf_h = 40

local sf_step_x = 16.6
local sf_step_y = 102
local sf_num = 0

local function AddSFButton(id, tooltip)
	local tbl = ENT.ButtonMap["PMV"]

	local but_id = id .. "Toggle"
	local x = sf_offset_x + (sf_num%sf_max * sf_step_x)
	local y = sf_offset_y + (math.floor(sf_num/sf_max)*sf_step_y) + math.random() * 0.6 - 0.3

	table.insert(tbl.buttons, {
		ID = but_id,
		x = x,
		y = y,
		w = sf_w,
		h = sf_h,
		tooltip = tooltip or id,

		model = {
			model = "models/metrostroi_train/81-760/81_760_switch_pmv.mdl",z=-10,ang=Angle(-180,90,90),
			var=id,speed=9, vmin=0,vmax=1,
			sndvol = 0.4, snd = function(val) return val and "sf_on" or "sf_off" end,
			sndmin = 90, sndmax = 1e3,
		}
	})

	sf_num = sf_num + 1
end

local sf_tooltips = {
	"30F1: Бортсеть управление",
	"23F1: Управление резервное",
	"23F2: Управление основное",
	"23F21: УПИ, Доступ",
	"23F22: СУ1, Монитор 1",
	"23F23: СУ2, Монитор 2, БИС, БДН",
	"23F9: Антисон",
	"22F5: РВТБ",
	"22F6: БТБУ",
	"22F3: Стояночный тормоз",
	"22F9: КМ",
	"80F1: Контроль дверей",
	"80F3: Двери / Аварийное управление",
	"95F4: Резерв",
	"95F6: Резерв",
	"45F13: СОЛ",

	"70F1: Радиосвязь",
	"51F2: Ночной отстой",
	"52F2: Освещение кабины / Панель управления",
	"45F10: БУТ",
	"45F12: БВТ",
	"51F1: Фары, Габаритные огни",
	"45F11: ЦИК",
	"45F3: Видеонаблюдение",
	"62F3: Кондиционер кабины",
	"62F4: ЭПРА Кабины",
	"61F5: Кондиционер салона",
	"70F5: Стеклоочист., Омыватель, Холод-к, Шторка, Кресло",
	"70F3: ГС, Гудок",
	"70F2: Обогрев стекла",
	"95F5: Резерв",
	"42F1: БД",
}

for i=1, 32 do
	AddSFButton("SF" .. i, sf_tooltips[i] or "SF" .. i)
end

ENT.ButtonMap["PVZ"] = {
	pos = Vector(-480.500,58.500,-24.515),
	ang = Angle(0,0,90),
	width = 634,
	height = 50,
	scale = 0.0605,
	hideseat=0.2,
	buttons = {
	}
}
local sf_max = 37

local sf_offset_x = 5
local sf_offset_y = 10

local sf_w = 13
local sf_h = 40

local sf_step_x = 16.8
local sf_num = 0

local function AddSFButtonPVZ(id, tooltip)
	local tbl = ENT.ButtonMap["PVZ"]

	local but_id = id .. "Toggle"
	local cons = sf_num < 19 and 0 or 8
	local x = cons+sf_offset_x + (sf_num%sf_max * sf_step_x)
	local y = sf_offset_y
	table.insert(tbl.buttons, {
		ID = but_id,
		x = x,
		y = y,
		w = sf_w,
		h = sf_h,
		tooltip = tooltip or id,

		model = {
			model = "models/metrostroi_train/81-760/81_760_switch_pmv.mdl",z=2,ang=Angle(-180,90,90),
			var=id,speed=9, vmin=0,vmax=1,
			sndvol = 0.4, snd = function(val) return val and "sf_on" or "sf_off" end,
			sndmin = 90, sndmax = 1e3,
		}
	})

	sf_num = sf_num + 1
end

local sf_tooltips = {
	"23F5: Управление основное",
	"23F6: Управление резервное",
	"30F4: ПСН",
	"45F14: СОЛ",
	"95F1: (Резерв)",
	"22F1: БТО",
	"23F4: Инвертр",
	"23F12: Вентиляция 1",
	"23F11: Вентиляция 2",
	"23F13: Счетчик",
	"23F25: Противоюз",
	"23F26: АДУВ",
	"23F27: БУВ",
	"30F3: Оссушитель",
	"90F1: Пожарная система",
	"45F2: Видеонаблюдение",
	"45F7: ЦИК Салон 1",
	"45F8: ЦИК Салон 2",
	"45F9: ЦИК Салон 3",

	"45F1: Москва-24",
	"45F4: Максима Телеком",
	"52F1: Подсветка салон",
	"52F4: Подсветка двери правые",
	"52F5: Подсветка двери левые",
	"52F3: Освещение аварийное",
	"80F2: Контроль дверей",
	"80F13: Двери питание 2,7",
	"80F12: Двери питание 3,6,8",
	"80F14: Двери питание 1,4,5",
	"70F4: USB 1",
	"70F6: USB 1",
	"21F1: ТКПР, БККЗ",
	"61F4: ЭПРА",
	"61F3: ПКС",
	"61F1: УВКС 1",
	"61F2: УВКС 2",
	"95F2: Откл. АКБ вагон",
}

local sf_names = {
	"23F5",
	"23F6",
	"30F4",
	"45F14",
	"95F1",
	"22F1",
	"23F4",
	"23F12",
	"23F11",
	"23F13",
	"23F25",
	"23F26",
	"23F27",
	"30F3",
	"90F1",
	"45F2",
	"45F7",
	"45F8",
	"45F9",

	"45F1",
	"45F4",
	"52F1",
	"52F4",
	"52F5",
	"52F3",
	"80F2",
	"80F13",
	"80F12",
	"80F14",
	"70F4",
	"70F6",
	"21F1",
	"61F4",
	"61F3",
	"61F1",
	"61F2",
	"95F2",

}

local PVZ_MODELS  = "models/metrostroi_train/81-775/"
local PVZ_ORIGIN  = Vector(-487.960, 49.900, -48.330)
local PVZ_DOOR_C  = Vector(27.200, 0.400, 18.100)

ENT.ClientProps["pvz_cabinet"] = {
	model = PVZ_MODELS.."775_pvz_cabinet.mdl",
	pos = PVZ_ORIGIN,
	ang = Angle(0,0,0),
	hide = 2,
}
ENT.ClientProps["pvz_door"] = {
	model = PVZ_MODELS.."775_pvz_door.mdl",
	pos = PVZ_ORIGIN + PVZ_DOOR_C,
	ang = Angle(0,0,0),
	hide = 2,
}

for i = 1, 37 do
	AddSFButtonPVZ(sf_names[i], sf_tooltips[i] or ("PVZ"..i))
end

local pvz_s = 0.05
ENT.ButtonMap["PVZDoorClosed"] = {
	pos = PVZ_ORIGIN + Vector(0.5, -0.2, 36.1),
	ang = Angle(0,0,90),
	width = 53.4/pvz_s,
	height = 36.0/pvz_s,
	scale = pvz_s,
	hideseat = 0.2,
	buttons = {
		{ID = "PVZDoor", x = 0, y = 0, w = 53.4/pvz_s, h = 36.0/pvz_s, tooltip = "Шкаф ПВЗ: снять панель (трёхгранный ключ)"},
	}
}
ENT.ButtonMap["PVZDoorOpen"] = {
	pos = PVZ_ORIGIN + Vector(6.34, -39.00, 52.75),
	ang = Angle(0,90,90),
	width = 36.00/pvz_s,
	height = 52.59/pvz_s,
	scale = pvz_s,
	hideseat = 0.2,
	buttons = {
		{ID = "PVZDoor", x = 0, y = 0, w = 36.00/pvz_s, h = 52.59/pvz_s, tooltip = "Шкаф ПВЗ: установить панель"},
	}
}

ENT.ButtonMap["LPU"] = {
	pos = Vector(438.25, 47.4, -9.3),
	ang = Angle(-4.9, -20, 1),
	width = 230,
	height = 80,
	scale = 0.06,
	hideseat=0.2,

	buttons = {
		AddButton("Wiper",				true , "blue",	34.5,		27),
		AddButton("Washer",				false, "blue",	32.5+45,	27),
		AddButton("EmergencyCompressor",false, "white",	30.5+45*2,	27),
		AddButton("EmerX1",				false, "gray",	27.5+45.5*3,26, "EmerX1Lamp"),
		AddButton("EmerX2",				false, "gray",	26.5+44.4*4,52, "EmerX2Lamp"),
	}
}

local headlights_x = 97
local headlights_y = 62

ENT.ButtonMap["CPU"] = {
	pos = Vector(471.9, 33.6,-6.3),
	ang = Angle(0, -90, 5),
	width = 425,
	height = 100,
	scale = 0.06,
	hideseat=0.2,

	buttons = {
		AddLamp("HVoltage", "blue", 127, 20, "HVoltage"),
		AddLamp("DoorsClosed", "green", 126 + 36, 20, "DoorsClosed"),
		AddButton("BVDisable", false, "red", 124 + 36 * 2, 20, "BVDisableLamp"),
		AddButton("BVEnable", false, "green", 123 + 36 * 3, 20, "BVEnableLamp"),
		AddButton("DoorSelectLeft", true, "white", 120 + 38.7 * 4, 20, "DoorSelectLeftLamp"),
		AddButton("DoorBlock", true, "red", 290.5 + 36, 20, "DoorBlockLamp"),
		{ID = "DoorBlockkToggle",x=290.5 + 16, y=30, w=40,h=10, tooltip="", model = {
			model = "models/metrostroi_train/81-775/81-775_button_cap1.mdl", ang = 90, z = -1, x = 0, y = -15,
			var="DoorBlockk",speed=8,min=1,max=0, disable="DoorBlockToggle",
			plomb = {var="DoorBlockkPl", ID="DoorBlockkPl", },
			sndvol = 1, snd = function(val) return val and "kr_close" or "kr_open" end,
			sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
		}},

		AddButton("DoorSelectRight", true, "white", 113 + 37.7 * 7, 20, "DoorSelectRightLamp"),
		{ID = "EmerBlockSDToggle",x=66, y=57, radius = 15, tooltip = "", model = {
			model = "models/metrostroi_train/81-722/button_rot.mdl",z=0,ang=40,
			var="EmerBlockSD",speed=12,vmin=0,vmax=0.25,
			sndvol = 0.3, snd = function(val) return val and "switch_on" or "switch_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
		}},
		{ID = "EmerBlockSDkToggle",x=46, y=67, w=40,h=10, tooltip="", model = {
			model = "models/metrostroi_train/81-775/81-775_button_cap2.mdl", ang = 90, z = 0, x = 0, y = -15,
			var="EmerBlockSDk",speed=8,min=1,max=0, disable="EmerBlockSDToggle",
			plomb = {var="EmerBlockSDkPl", ID="EmerBlockSDkPl", },
			sndvol = 1, snd = function(val) return val and "kr_close" or "kr_open" end,
			sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
		}},
		{ID = "HeadlightsSwitch",x=headlights_x, y=headlights_y,radius = 0, tooltip = "",model = {
			getfunc = function(ent) return (ent:GetPackedRatio("HeadlightsSwitch")*3)*0.125 end, var="HeadlightsSwitch",
			model = "models/metrostroi_train/81-722/button_rot.mdl",z=0,ang=40,
			speed=2,
			sndvol = 0.3, snd = function(val) return val and "switch_on" or "switch_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
		}},
		{ID="HeadlightsSwitch+",x=headlights_x, y=headlights_y-15, w=15,h=30, tooltip=""},
		{ID="HeadlightsSwitch-",x=headlights_x-15, y=headlights_y-15, w=15,h=30, tooltip=""},

		AddButton("Autodrive", true, "green", 145.6, 59, "AutodriveLamp"),
		{ID = "AutodrivekToggle",x=145.6 - 20, y=69, w=40,h=10, tooltip="", model = {
			model = "models/metrostroi_train/81-775/81-775_button_cap1.mdl", ang = 90, z = -1, x = 0, y = -15,
			var="Autodrivek",speed=8,min=1,max=0, disable="AutodriveToggle",
			sndvol = 1, snd = function(val) return val and "kr_close" or "kr_open" end,
			sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
		}},

		AddButton("Ring", false, "white", 180, 60),
		AddButton("Antison", false, "yellow", 179 + 35.8, 60),
		AddButton("Progrev", true, "green", 177 + 35.8 * 2, 60, "ProgrevLamp"),

		AddButton("DoorOpenLeft", false, "white", 291.5 + 35.9 * 0, 59, "DoorOpenLeftLamp",0, 0.75),
		AddButton("DoorClose", true, "green", 289.5 + 35.9 * 1, 59, "DoorCloseLamp"),
		AddButton("DoorOpenRight", false, "white", 288.5 + 35.9 * 2, 59, "DoorOpenRightLamp",0, 0.75),
	}
}

local KR_ANG = 40
local KR_INVERT = true
local function krPose(ratio) return ((KR_INVERT and (1-ratio) or ratio)*2)*0.125 end

local EmergencyBrakeButton = AddButton("EmergencyBrake", true, "emerbrake", 81 + 43.85 * 3, 111, "EmergencyBrakeLamp", -3)
EmergencyBrakeButton.tooltip = "Тормоз экстренный"
EmergencyBrakeButton.model.ang = 180
EmergencyBrakeButton.model.lamp.z = 0

ENT.ButtonMap["RPU"] = {
	pos = Vector(471.5, 6, -6.3),
	ang = Angle(2.7, 240, 4.4),
	width = 300,
	height = 160,
	scale = 0.06,
	hideseat=0.2,

	buttons = {
		{ID = "!KROSwitch",x=85, y=32,radius = 0, tooltip = "",model = {
			getfunc = function(ent) return krPose(ent:GetPackedRatio("KRO")) end, var="!noname1",
			model = "models/metrostroi_train/81-722/button_rot.mdl",z=0,ang=KR_ANG,
			speed=2,
			sndvol = 0.3, snd = function(val) return val and "switch_on" or "switch_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
		}},
		{ID="KRO+",x=85-15, y=32-15, w=15,h=30, tooltip="Реверс Основной +"},
		{ID="KRO-",x=85, y=32-15, w=15,h=30, tooltip="Реверс Основной -"},

		{ID = "!KRRSwitch",x=126, y=32,radius = 0, tooltip = "",model = {
			getfunc = function(ent) return krPose(ent:GetPackedRatio("KRR")) end, var="!noname2",
			model = "models/metrostroi_train/81-722/button_rot.mdl",z=0,ang=KR_ANG,
			speed=2,
			sndvol = 0.3, snd = function(val) return val and "switch_on" or "switch_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
		}},
		{ID="KRR+",x=126-15, y=32-15, w=15,h=30, tooltip="Реверс Резервный +"},
		{ID="KRR-",x=126, y=32-15, w=15,h=30, tooltip="Реверс Резервный -"},

		{ID = "KRRkToggle",x=106, y=36, w=40,h=10, tooltip="", model = {
			model = "models/metrostroi_train/81-775/81-775_button_cap2.mdl", ang = 90, z = 4, x = 0, y = -10,
			var="KRRk",speed=8,min=1,max=0,
			sndvol = 1, snd = function(val) return val and "kr_close" or "kr_open" end,
			sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
		}},
		AddButton("EmerBrake", true, "red", 169, 32, "EmerBrakeLamp"),
		AddButton("EmerBrakeAdd", false, "black", 166.1 + 43.8 * 1, 32),
		AddButton("EmerBrakeRelease", false, "white", 165 + 43.8 * 2, 32),

		AddButton("LinkSC", false, "yellow", 84.2, 73, "LinkSCLamp"),
		AddButton("AttentionMessage", false, "orange", 82 + 43.85 * 2, 72),
		AddButton("Attention", false, "red", 79 + 43.85 * 3, 71),
		AddButton("AttentionBrake", false, "red", 77 + 43.85 * 4, 71),

		AddButton("Microphone", false, "yellow", 85 + 43.85 * 1, 112, "MicrophoneLamp"),
		AddButton("R_Program1", false, "yellow", 83 + 43.85 * 2, 112),
        {ID = "HornBSet",x=83 + 43.85 * 1, y=73, radius=15, tooltip = "Сигнал",model = {
            model = "models/metrostroi_train/81-775/81-775_button1_white.mdl",z=-0.5,
            var="HornB",speed=12, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }},
		EmergencyBrakeButton,
	}
}

local arscranepos = {
	0,
	1/(360/60)*2,
	1/(360/60)
}

local krmcranepos = {
	0,
	0.5,
	1/(360/150),
}

ENT.ButtonMap["Cranes"] = {
	pos = Vector(467.7, -55.5, -12),
	ang = Angle(0, -180, 0),
	width = 350,
	height = 120,
	scale = 0.06,
	hideseat=0.2,

	buttons = {
		{ID = "KRRH3Toggle",x=63.5, y=56,radius = 50, tooltip = "K9: РВТБ",model = {
			var="KRRH3",
			model = "models/metrostroi_train/81-775/taps/rvtb.mdl",z=15,ang=0,
			plomb = {var="KRRH3Pl", ID="KRRH3Pl", },
			speed=6, max= 1, min = 0,
			sndvol = 0.3, snd = function(val) return val and "switch_on" or "switch_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
		}},
		{ID = "KPRRKMToggle",x=63+95, y=57,radius = 50, tooltip = "K29: Резеврное включение КРМШ",model = {
			var="KPRRKM",
			model = "models/metrostroi_train/81-775/taps/k29.mdl",z=15,ang=0,
			speed=6, max=0 , min = 1,
			sndvol = 0.3, snd = function(val) return val and "switch_on" or "switch_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
		}},
		{ID = "EmergencyBrakeValveToggle",x=56+247.7, y=57,radius = 50, tooltip = "КАЭТ: Клапан аварийного экстренного тормоза",model = {
			var="EmergencyBrakeValve",
			model = "models/metrostroi_train/81-775/taps/kaet.mdl",z=15,ang=0,
			speed=12,
		}},

	}
}

ENT.ClientProps["headlightoff"] = {
	model = "models/metrostroi_train/81-775/light_off.mdl",
	pos = Vector(485.3, 0, 3.3),
	ang = Angle(0, 0, 0),
	nohide = true,
}
ENT.ClientProps["headlight1"] = {
	model = "models/metrostroi_train/81-775/light_group1.mdl",
	pos = Vector(490.8, 0, -7),
	ang = Angle(0, 0, 0),
	nohide = true,
}
ENT.ClientProps["headlight11"] = {
	model = "models/metrostroi_train/81-775/light_group1.mdl",
	pos = Vector(488.5, 0, 8.6),
	ang = Angle(0, 0, 0),
	nohide = true,
}

ENT.ClientProps["headlight2"] = {
	model = "models/metrostroi_train/81-775/light_group2.mdl",
	pos = Vector(487.55, 0, 8.5),
	ang = Angle(0, 0, 0),
	nohide = true,
}
ENT.ClientProps["headlight3"] = {
	model = "models/metrostroi_train/81-775/light_group0.mdl",
	pos = Vector(485.6, 0, 3.3),
	ang = Angle(0, 0, 0),
	nohide = true,
}

ENT.ClientProps["redlight"] = {
	model = "models/metrostroi_train/81-775/light_red.mdl",
	pos = Vector(485.5, 0, 3.3),
	ang = Angle(0, 0, 0),
	nohide = true,
}

ENT.ButtonMap["stopkran"] = {
	pos = Vector(-455.3,-64.2,83.4),
	ang = Angle(0,0,-90),
	width = 100,
	height = 75,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "StopkranToggle", x=13,  y=0, w = 35, h = 75, tooltip="Стоп-кран", model = {
			model = "models/metrostroi_train/81-775/81-775_crane_compartment2.mdl", pos = Vector(24,32,-2), ang=Angle(90,270,0),
			var="Stopkran",speed=4, max=0.25
		}},
	}
}

local SKR = {
	floorZ = -48.23,
	faceY  = -58.4,
	scale  = 0.0625,
	niche_d = 0.95,
	winH   = 3.4,
	winZ   = 3.0,
	hingeD = 2.45,
	flapH  = 4.6,
	pre    = "",
}
local SKR_MODELS = {
	box = {[false] = "models/metrostroi_train/81-775/81-775_int_floor_box1.mdl", [true] = "models/metrostroi_train/81-775/81-775_int_floor_box2.mdl"},
	cap = {[false] = "models/metrostroi_train/81-775/81-775_int_floor_cap1.mdl", [true] = "models/metrostroi_train/81-775/81-775_int_floor_cap2.mdl"},
	lever = "models/metrostroi_train/81-775/81-775_crane_compartment2.mdl",
	bto = "models/metrostroi_train/81-775/81-775_crane_bto.mdl",
}
local SKR_TIPS = {
	K53 = "К53 (СТ)", K40 = "К40 (ТЦ-1, ТЦ-2)", K41 = "К41 (ТЦ-3, ТЦ-4)", K31 = "К31 (БТО 073-01)",
}
local function SalonKran(n)
	local sc   = SKR.scale
	local hc   = SKR.floorZ + SKR.winZ
	local hz   = hc - SKR.hingeD
	local hw   = n.wide and 8 or 4
	local fw   = 2 * hw + 1.6
	ENT.ClientProps[n.box] = { model = SKR_MODELS.box[n.wide], pos = Vector(n.x, SKR.faceY, hc), ang = Angle(0, 0, 0), hide = 1.0 }
	ENT.ClientProps[n.cap] = { model = SKR_MODELS.cap[n.wide], pos = Vector(n.x, SKR.faceY, hz), ang = Angle(0, 0, 0), hide = 1.0 }
	local lz = hc - SKR.winH / 2 + 0.15
	if n.bto then
		ENT.ClientProps[n.bto.prop] = { model = SKR_MODELS.bto, pos = Vector(n.x + n.bto.dx, SKR.faceY - SKR.niche_d, lz), ang = Angle(0, 0, 0), hide = 1.0 }
	end
	local btns = {}
	for _, v in ipairs(n.valves) do
		ENT.ClientProps[v.prop] = { model = SKR_MODELS.lever, pos = Vector(n.x + v.dx, SKR.faceY - SKR.niche_d + 0.25, lz), ang = Angle(0, 0, 0), hide = 1.0 }
		local x0 = math.max(-hw, v.dx - 1.0)
		local x1 = math.min(hw, v.dx + 2.4)
		btns[#btns + 1] = { ID = v.id .. "Toggle", x = (x0 + hw) / sc, y = 0, w = (x1 - x0) / sc, h = SKR.winH / sc, tooltip = SKR.pre .. SKR_TIPS[v.id] }
	end
	ENT.ButtonMap[n.panel] = {
		pos = Vector(n.x - hw, SKR.faceY - 0.3, hc - SKR.winH / 2), ang = Angle(0, 0, -90),
		width = 2 * hw / sc, height = SKR.winH / sc, scale = sc, hideseat = 0.2, buttons = btns,
	}
	ENT.ButtonMap[n.capid .. "_Open"] = {
		pos = Vector(n.x - fw / 2, SKR.faceY + 0.6, hz), ang = Angle(0, 0, -90),
		width = fw / sc, height = SKR.flapH / sc, scale = sc, hide = 0.8,
		buttons = { { ID = n.capid, x = 0, y = 0, w = fw / sc, h = SKR.flapH / sc, tooltip = SKR.pre .. "Открыть крышку крана " .. n.name } },
	}
	ENT.ButtonMap[n.capid .. "_Close"] = {
		pos = Vector(n.x - fw / 2, SKR.faceY + 2.3, hz - 0.5), ang = Angle(0, 0, -90),
		width = fw / sc, height = 1.2 / sc, scale = sc, hide = 0.8,
		buttons = { { ID = n.capid, x = 0, y = 0, w = fw / sc, h = 1.2 / sc, tooltip = SKR.pre .. "Закрыть крышку крана " .. n.name } },
	}
end
SalonKran({ box = "floor_box1", cap = "floor_cap1", panel = "K53", capid = "K53_cap", x = 184.50, wide = false, name = "К53",
	valves = { { id = "K53", prop = "kran_k53", dx = 0.8 } } })
SalonKran({ box = "floor_box2", cap = "floor_cap2", panel = "K40", capid = "K40_cap", x = 160.50, wide = true, name = "К40 и К31", bto = { prop = "bto_k31", dx = 0.6 },
	valves = { { id = "K40", prop = "kran_k40", dx = 5.4 }, { id = "K31", prop = "kran_k31", dx = -4.2 } } })
SalonKran({ box = "floor_box3", cap = "floor_cap3", panel = "K41", capid = "K41_cap", x = -264.00, wide = false, name = "К41",
	valves = { { id = "K41", prop = "kran_k41", dx = 0.8 } } })

ENT.ButtonMap["K53_outside"] = {
	pos = Vector(210.6,-63.34,2.4),
	ang = Angle(90,90,180),
	width = 100,
	height = 75,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "1:K53Toggle", x=13,  y=0, w = 35, h = 75, tooltip="К53 СТ", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang=Angle(90,180,90),
			var="K53",speed=6, max=0.25
		}},
	}
}

ENT.ButtonMap["K23_outside"] = {
	pos = Vector(202.8,-53.34,1.3),
	ang = Angle(90,90,180),
	width = 100,
	height = 75,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "K23Toggle", x=13,  y=0, w = 35, h = 75, tooltip="К23 БУСТ", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang=Angle(90,180,90),
			var="K23",speed=6, max=0.25
		}},
	}
}

ENT.ButtonMap["K18_K19_outside"] = {
	pos = Vector(115,-59.34,-0.4),
	ang = Angle(90,90,180),
	width = 75,
	height = 550,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "K18Toggle", x=13,  y=420, w = 35, h = 75, tooltip="К18 НМ КТО 01", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang=Angle(90,180,90),
			var="K18",speed=6, max=0.25
		}},
		{ID = "K19Toggle", x=13,  y=0, w = 35, h = 75, tooltip="К19 ТМ КТО 01", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang=Angle(90,180,90),
			var="K19",speed=6, max=0.25
		}},
	}
}

ENT.ButtonMap["K40_outside"] = {
	pos = Vector(194.6,-63.34,0.6),
	ang = Angle(90,90,180),
	width = 100,
	height = 75,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "1:K40Toggle", x=13,  y=0, w = 35, h = 75, tooltip="К40 ТЦ-1 ТЦ-2", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(-90,0,90),
			var="K40",speed=6, max=0.25
		}},
	}
}

ENT.ButtonMap["K31_outside"] = {
	pos = Vector(180.2,-63.34,-2.1),
	ang = Angle(90,90,180),
	width = 100,
	height = 75,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "1:K31Toggle", x=13,  y=0, w = 35, h = 75, tooltip="К31 КТО 01", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(-90,0,90),
			var="K31",speed=6, min=0.25 ,max=0,
		}},
	}
}

ENT.ButtonMap["K41_outside"] = {
	pos = Vector(-215,-59.25,-0.25),
	ang = Angle(90,90,180),
	width = 75,
	height = 75,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "1:K41Toggle", x=13,  y=0, w = 45, h = 75, tooltip="К41 ТЦ-3 ТЦ-4", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(-90,180,90),
			var="K41",speed=6, max=0.25
		}},
	}
}

ENT.ButtonMap["K22_outside"] = {
	pos = Vector(-180,-59.25,-0.25),
	ang = Angle(90,90,180),
	width = 75,
	height = 75,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "K22Toggle", x=13,  y=0, w = 45, h = 75, tooltip="К22 Ц1-Ц4", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(90,180,90),
			var="K22",speed=6, max=0.25
		}},
	}
}

local K35_HINGE = Vector(388.6216, -57.0787, 0)
local K35_OPEN  = 95
ENT.ButtonMap["K35"] = {
	pos = Vector(387.0, -57.2, 10.0),
	ang = Angle(0, 90, 90),
	width = 50,
	height = 62,
	scale = 0.1,
	hideseat = 0.2,
	buttons = {
		{ID = "K35Toggle", x = 0, y = 0, w = 50, h = 62, tooltip = "К35 Выключатель автостопа", model = {
			plomb = {var = "K35Pl", ID = "K35Pl"},
			var = "K35", speed = 4,
		}},
	}
}
ENT.ButtonMap["K35Closet"] = {
	pos = Vector(388.8, -57.08, 51.5),
	ang = Angle(0, 90, 90),
	width = 191, height = 481, scale = 0.1,
	buttons = {{ID = "K35Closet", x = 0, y = 0, w = 191, h = 481, tooltip = "Шкаф (кран К35)"}},
}
ENT.ButtonMap["K35ClosetOp"] = {
	pos = Vector(407.773, -57.902, 51.5),
	ang = Angle(0, 175, 90),
	width = 191, height = 481, scale = 0.1,
	buttons = {{ID = "K35Closet", x = 0, y = 0, w = 191, h = 481, tooltip = "Шкаф (кран К35)"}},
}
ENT.ClientProps["K35Door"] = {
	model = "models/metrostroi_train/81-775/775_k35_door.mdl",
	pos = K35_HINGE,
	ang = Angle(0, 0, 0),
	hide = 2,
}
ENT.ClientProps["K35"] = {
	model = "models/metrostroi_train/81-775/81-775_k35.mdl",
	pos = Vector(-20.808, 9.823, 11.6),
	ang = Angle(0, 0, 0),
	hideseat = 0.5,
}

ENT.ButtonMap["K35_outside"] = {
	pos = Vector(418.75,-63.34,-2.1),
	ang = Angle(90,90,180),
	width = 100,
	height = 75,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "1:K35Toggle", x=13,  y=0, w = 35, h = 75, tooltip="К35 Выключатель автостопа", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(-90,0,90),
			var="K35",speed=6, min=0 ,max=0.25,
		}},
	}
}

ENT.ButtonMap["K27"] = {
	pos = Vector(445,-59.05,-0.5),
	ang = Angle(90,90,180),
	width = 50,
	height = 75,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "K27Toggle", x=13,  y=0, w = 35, h = 75, tooltip="K27 НМ КМ", model = {
			model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(180,90,0), z = -39,
			var="K27",speed=6, min=0 ,max=0.25,
		}},
	}
}
ENT.ButtonMap["K36"] = {
	pos = Vector(414,-65,-59),
	ang = Angle(90,90,180),
	width = 100,
	height = 100,
	scale = 0.0625,
	hideseat=1,

	buttons = {
		{ID = "FrontBrakeLineIsolationToggle", x=0,  y=0, w = 100, h = 100, tooltip="К36 Концевой кран ТМ", model = {
			model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl", ang = Angle(90,0,270),pos = Vector(56.3,36,-28),
			var="FrontBrakeLineIsolation",speed=6, min=0.25 ,max=0
		}},
	}
}
ENT.ButtonMap["CoupleCenteringF"] = {
	pos = Vector(488, -50, -50), ang = Angle(0, 90, 90),
	width = 100, height = 30, scale = 1,
	buttons = {
		{
			ID = "CoupleCenteringFToggle",
			x = 0, y = 0, w = 100, h = 30,
			tooltip = "Ручная центровка",
			model = {
				var = "CoupleCenteringF",
			}
		}
	}
}
ENT.ButtonMap["K38"] = {
	pos = Vector(420,-65,-60),
	ang = Angle(90,90,180),
	width = 100,
	height = 100,
	scale = 0.0625,
	hideseat=1,

	buttons = {
		{ID = "FrontTrainLineIsolationToggle", x=0,  y=0, w = 100, h = 100, tooltip="К38 Концевой кран НМ", model = {
			model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",ang = Angle(270,180,90),pos = Vector(72.3,36,-92),
			var="FrontTrainLineIsolation",speed=6, min=0.25 ,max=0,
		}},
	}
}

ENT.ButtonMap["K37"] = {
	pos = Vector(-465,-65,-58),
	ang = Angle(90,90,180),
	width = 100,
	height = 100,
	scale = 0.0625,
	hideseat=1,

	buttons = {
		{ID = "RearBrakeLineIsolationToggle", x=0,  y=0, w = 100, h = 100, tooltip="К37 Концевой кран ТМ", model = {
			model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl", ang = Angle(-270,-20,270),pos = Vector(72.3,52,-28.5),
			var="RearBrakeLineIsolation",speed=6, min=0.25 ,max=0
		}},
	}
}

ENT.ButtonMap["K39"] = {
	pos = Vector(-472,-65,-60),
	ang = Angle(90,90,180),
	width = 100,
	height = 100,
	scale = 0.0625,
	hideseat=1,

	buttons = {
		{ID = "RearTrainLineIsolationToggle", x=0,  y=0, w = 100, h = 100, tooltip="К39 Концевой кран НМ", model = {
			model = "models/metrostroi_train/81-760/81_760_crane_k23.mdl",ang = Angle(-270,-20,270),pos = Vector(72.3,36,-92),
			var="RearTrainLineIsolation",speed=6, min=0.25 ,max=0,
		}},
	}
}

ENT.ClientProps["compartment_cab"] = {
	model = "models/metrostroi_train/81-775/81-775_compartment_cab.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0)
}
ENT.ClientProps["compartment_stopcrane"] = {
	model = "models/metrostroi_train/81-775/81-775_compartment_stopcrane.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	hide=2,
}
ENT.ClientProps["compartment1"] = {
	model = "models/metrostroi_train/81-775/81-776_compartment1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	hide=2,
}

ENT.ClientProps["pb"] = {
	model = "models/metrostroi_train/81-775/81-775_pb.mdl",
	pos = Vector(466.13, 35.60, -40.24),
	ang = Angle(0,0,0),
}
for i, p in ipairs({
	Vector(401.97,  46.42, 61.10), Vector(401.97, -46.47, 61.10), Vector(402.78, -0.85, 56.84),
	Vector(432.50,  46.42, 61.10), Vector(432.50, -46.47, 61.10),
}) do
	ENT.ClientProps["cablamp" .. i] = {
		model = "models/metrostroi_train/81-775/775_cablamp.mdl",
		pos = p,
		ang = Angle(0,0,0),
		hide = 2,
	}
end
ENT.ClientProps["cab_handles"] = {
	model = "models/metrostroi_train/81-775/775_cab_handles.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	hide = 2,
}
ENT.ClientProps["controller"] = {
	model = "models/metrostroi_train/81-775/775_controller.mdl",
	pos = Vector(459.75,27.2,-9),
	ang = Angle(0,-90,-10),
	scale = 1.1,
}

ENT.ClientProps["km013"] = {
	model = "models/metrostroi_train/81-760/81_760_km_013.mdl",
	pos = Vector(457,-12,-13),
	ang = Angle(25,-6,15),
	callback = function(ent, cent)
		cent:SetMaterial("models/metrostroi_train/81-775/775_km_013")
	end,
}
if not ENT.ClientSounds["br_013"] then ENT.ClientSounds["br_013"] = {} end
table.insert(ENT.ClientSounds["br_013"],{"km013",function(ent,_,var) return "br_013" end,1,1,50,1e3,Angle(-90,0,0)})

local pos = {
	[1] = Vector(-27.93,40.5,-18.36),
	[2] = Vector(-27.93,-39.5,-18.36),
	[3] = Vector(27.93,39.5,-18.36),
	[4] = Vector(27.93,-40.5,-18.36),
}

ENT.ButtonMap["GV"] = {
	pos = Vector(-190.5,50,-67),
	ang = Angle(0,90,90),
	width = 170,
	height = 150,
	scale = 0.1,
	buttons = {
		{ID = "GVToggle",x=0, y=0, w= 170,h = 150, tooltip="Разъединитель БРУ (ГВ)", model = {
			var="GV",sndid = "gv_wrench",
			sndvol = 0.8,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
			snd = function(val) return val and "gv_f" or "gv_b" end,
		}},
	}
}
ENT.ClientProps["gv_wrench"] = {
	model = "models/metrostroi_train/reversor/reversor_classic.mdl",
	pos = Vector(-193.5,53,-70.5),
	ang = Angle(-90,180,0),
	hide=0.5,
}

ENT.ButtonMap["MFDU"] = {
	pos = Vector(474.7 , 1.6, 3.69),
	ang = Angle(2.49,240-0.25,90-18.1),
	width = 800,
	height = 600,
	scale = 0.01595,
	hideseat=0.2,
	sensor=true,
	system="MFDU",
	hide=0.5,
}

ENT.ButtonMap["Speedometer"] = {
	pos = Vector(474.7 ,33.54, -0.45),
	ang = Angle(0,270.18,90-10.41),
	width = 1940,
	height = 330,
	scale = 0.012553,
	hideseat=0.2,
	sensor=true,
	system = "Speedometer",
	hide=0.5,
}

ENT.ButtonMap["MVO"] = {
	pos = Vector(468.27 ,52.7 ,3.13),
	ang = Angle(-2.49, 300+0.25, 90-18.1),
	width = 800,
	height = 600,
	scale = 0.01595,
	hideseat=0.2,
	sensor=true,
	system="MVO",
	hide=0.5,
}

ENT.ButtonMap["IGLA_Buttons"] = {
	pos = Vector(388,33.5,44),
	ang = Angle(0, 90, 90),
	width = 190,
	height = 110,
	scale = 0.06,
	buttons = {
		{ID = "IGLA1Set",x=39.5, y=92, radius=14,tooltip="ИГЛА: 1",model = {
			model = "models/metrostroi_train/81-775/81-775_button_asotp.mdl", z=2, ang=-90,
			var="IGLA1",speed=16, min=0.0, max=1.0,
			sndvol = 0.4, snd = function(val,val2) return val and "button_square_press" or "button_square_release" end,
			sndmin = 90, sndmax = 1e3,
		}},
		{ID = "IGLA2Set",x=39.5+25, y=92, radius=16,tooltip="ИГЛА: 2",model = {
			model = "models/metrostroi_train/81-775/81-775_button_asotp.mdl", z=2, ang=-90,
			var="IGLA2",speed=16, min=0.0, max=1.0,
			sndvol = 0.4, snd = function(val,val2) return val and "button_square_press" or "button_square_release" end,
			sndmin = 90, sndmax = 1e3,
		}},
		{ID = "IGLA3Set",x=39.5+50, y=92, radius=16,tooltip="ИГЛА: 3",model = {
			model = "models/metrostroi_train/81-775/81-775_button_asotp.mdl", z=2, ang=-90,
			var="IGLA3",speed=16, min=0.0, max=1.0,
			sndvol = 0.4, snd = function(val,val2) return val and "button_square_press" or "button_square_release" end,
			sndmin = 90, sndmax = 1e3,
		}},
		{ID = "IGLA4Set",x=39.5+75, y=92, radius=16,tooltip="ИГЛА: 4",model = {
			model = "models/metrostroi_train/81-775/81-775_button_asotp.mdl", z=2, ang=-90,
			var="IGLA4",speed=16, min=0.0, max=1.0,
			sndvol = 0.4, snd = function(val,val2) return val and "button_square_press" or "button_square_release" end,
			sndmin = 90, sndmax = 1e3,
		}},
	}
}

ENT.ButtonMap["CIK"] = {
	pos = Vector(387.8,34.9,33.9),
	ang = Angle(0, 90, 90),
	width = 840,
	height = 600,
	scale = 0.01013,
	hideseat=0.2,
    sensor = true,
	system="CIK",
	hide=0.5,
}

ENT.ButtonMap["CIK_Buttons"] = {
	pos = Vector(388,43.5,35),
	ang = Angle(0, 90, 90),
	width = 100,
	height = 120,
	scale = 0.06,
	buttons = {
		{ID = "R_0Set",x=66-8.3333, y=18, w = 20, h=15,tooltip="ЦИК: Установка в начало",model = {
			model = "models/metrostroi_train/81-775/81-775_button_ppz4.mdl", z=2.6, ang=-90,
			var="R_0",speed=16, min=0.0, max=0.5,
			sndvol = 0.4, snd = function(val,val2) return val and "button_square_press" or "button_square_release" end,
			sndmin = 90, sndmax = 1e3,
		}},
		{ID = "R_GGOSet",x=66-8.3333, y=18+22, w = 20, h=15,tooltip="ЦИК: ГГО",model = {
			model = "models/metrostroi_train/81-775/81-775_button_ppz3.mdl", z=2.6, ang=-90,
			var="R_GGO",speed=16, min=0.0, max=0.5,
			sndvol = 0.4, snd = function(val,val2) return val and "button_square_press" or "button_square_release" end,
			sndmin = 90, sndmax = 1e3,
		}},
		{ID = "R_DirectionSet",x=66-8.3333, y=18+44, w = 20, h=15,tooltip="ЦИК: Смена направления",model = {
			model = "models/metrostroi_train/81-775/81-775_button_ppz2.mdl", z=2.6, ang=-90,
			var="R_Direction",speed=16, min=0.0, max=0.5,
			sndvol = 0.4, snd = function(val,val2) return val and "button_square_press" or "button_square_release" end,
			sndmin = 90, sndmax = 1e3,
		}},
		{ID = "R_EnterSet",x=66-8.3333, y=18+66, w = 20, h=15,tooltip="ЦИК: Enter",model = {
			model = "models/metrostroi_train/81-775/81-775_button_ppz1.mdl", z=2.6, ang=-90,
			var="R_Enter",speed=16, min=0.0, max=0.5,
			sndvol = 0.4, snd = function(val,val2) return val and "button_square_press" or "button_square_release" end,
			sndmin = 90, sndmax = 1e3,
		}},
	}
}

ENT.ButtonMap["BNTS1"] = {
	pos = Vector(352.324 ,-42.34,60.1),
	ang = Angle(0,180,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS2"] = {
	pos = Vector(123.524 ,-42.34,60.1),
	ang = Angle(0,180,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS3"] = {
	pos = Vector(-109.8 ,-42.34,60.1),
	ang = Angle(0,180,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS4"] = {
	pos = Vector(-343.8 ,-42.34,60.1),
	ang = Angle(0,180,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS5"] = {
	pos = Vector(278.724 ,42.34,60.1),
	ang = Angle(0,0,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS6"] = {
	pos = Vector(49.999 ,42.34,60.1),
	ang = Angle(0,0,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS7"] = {
	pos = Vector(-184 ,42.34,60.1),
	ang = Angle(0,0,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS8"] = {
	pos = Vector(-417.3 ,42.34,60.1),
	ang = Angle(0,0,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["MosLogo"] = {
	pos = Vector(492.4,-4.35,-19.5),
	ang = Angle(0,90,86),
	width = 1024,
	height = 1024,
	scale = 0.0205,
	hideseat=0.2,
}
ENT.ButtonMap["ROUTER"] = {
	pos = Vector(473.1,-30.25,71.8),
	ang = Angle(0,90,73),
	width = 500,
	height = 72,
	scale = 0.129,
	hideseat=0.2,
}
ENT.ButtonMap["BNTN"] = {
	pos = Vector(-35,-66,38.4),
	ang = Angle(0,0,90),
	width = 2280,
	height = 288,
	scale = 0.0645/2,
	hideseat=0.2,
}
ENT.ButtonMap["BNTN2"] = {
	pos = Vector(-25,66,38.4),
	ang = Angle(0,180,90),
	width = 2280,
	height = 288,
	scale = 0.0645/2,
	hideseat=0.2,
}
for i = 1, 6 do
	local x = math.max(math.ceil(i/2)-1,0)
	if i%2 == 1 then
		ENT.ClientProps["int_light_"..i] = {
			model = "models/metrostroi_train/81-775/81-775_int_lamp1.mdl",
			pos = Vector(234.752-239.13*x,16.517,121.4),
			ang = Angle(0,0,0),
			hide=1,
		}
	else
		ENT.ClientProps["int_light_"..i] = {
			model = "models/metrostroi_train/81-775/81-775_int_lamp1.mdl",
			pos = Vector(234.752-239.13*x,-16.517,121.4),
			ang = Angle(0,180,0),
			hide=1,
		}
	end
end

ENT.ClientProps["int_light_7"] = {
	model = "models/metrostroi_train/81-775/81-775_int_lamp2.mdl",
	pos = Vector(-442.44,0,121.4),
	ang = Angle(0,0,0),
	hide=1,
}

ENT.ClientProps["int_light_8"] = {
	model = "models/metrostroi_train/81-775/81-775_int_lamp3.mdl",
	pos = Vector(353.615,0,120.38),
	ang = Angle(0,0,0),
	hide=1,
}

ENT.ClientProps["int_light_9"] = {
	model = "models/metrostroi_train/81-775/81-775_int_lamp3.mdl",
	pos = Vector(-362.413,0,120.38),
	ang = Angle(0,0,0),
	hide=1,
}

ENT.ClientProps["int_light_10"] = {
	model = "models/metrostroi_train/81-775/81-775_int_lamp4.mdl",
	pos = Vector(115.2,0,115.1),
	ang = Angle(0,0,0),
	hide=1,
}

ENT.ClientProps["int_light_11"] = {
	model = "models/metrostroi_train/81-775/81-775_int_lamp4.mdl",
	pos = Vector(115.2-239.2,0,115.1),
	ang = Angle(0,0,0),
	hide=1,
}

ENT.ClientProps["int_light_doors_1"] = {
	model = "models/metrostroi_train/81-775/81-775_int_led_doors_narrow.mdl",
	pos = Vector(345.202,0,93.5),
	ang = Angle(0,0,0),
	hide=1,
}

ENT.ClientProps["int_light_doors_2"] = {
	model = "models/metrostroi_train/81-775/81-775_int_led_doors_narrow.mdl",
	pos = Vector(345.202+6.485,0,93.5),
	ang = Angle(0,180,0),
	hide=1,
}

for i = 1, 6 do
	local x = math.max(math.ceil(i/2)-1,0)
	if i%2 == 1 then
		ENT.ClientProps["int_light_doors_"..i+2] = {
			model = "models/metrostroi_train/81-775/81-775_int_led_doors_wide.mdl",
			pos = Vector(115.285-239.13*x,0,93.5),
			ang = Angle(0,0,0),
			hide=1,
		}
	else
		ENT.ClientProps["int_light_doors_"..i+2] = {
			model = "models/metrostroi_train/81-775/81-775_int_led_doors_wide.mdl",
			pos = Vector(115.236-239.13*x,0,93.5),
			ang = Angle(0,180,0),
			hide=1,
		}
	end
end

ENT.ButtonMap["DLD1"] = {
	pos = Vector(276,53.2,40),
	ang = Angle(0,57.95,90),
	width = 85,
	height = 100,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "DLDoor1Toggle", x=45,  y=53, radius=30, tooltip="Отключение дверей", model = {
			model = "models/metrostroi_train/81-775/81-775_switch_aod_internal.mdl", ang=Angle(-90,35+20,0),z=-6,
			var="DLDoor1",speed=8.2, min=0,max=1,
		}},
		{ID = "DLDoor1kToggle", x=0,  y=3, w = 85, h = 20, tooltip="Отключение дверей", model = {
			model = "models/metrostroi_train/81-775/81-775_switch_aod_internal_cap.mdl", y=40,x=1, ang=Angle(-90,35+20,0),z=-6,
			var="DLDoor1k",speed=4, min=1,max=0,disable="DLDoor1Toggle",
		}},
	}
}
ENT.ButtonMap["DRD1"] = {
	pos = Vector(279,-55.2,40),
	ang = Angle(0,45+90,90),
	width = 85,
	height = 100,
	scale = 0.0625,
	hideseat=0.2,

	buttons = {
		{ID = "DRDoor1Toggle", x=45,  y=53, radius=30, tooltip="Отключение дверей", model = {
			model = "models/metrostroi_train/81-775/81-775_switch_aod_internal.mdl", ang=Angle(-90,35+20,0),z=-6,
			var="DRDoor1",speed=8.2, min=0,max=1,
		}},
		{ID = "DRDoor1kToggle", x=0,  y=3, w = 85, h = 20, tooltip="Отключение дверей", model = {
			model = "models/metrostroi_train/81-775/81-775_switch_aod_internal_cap.mdl", y=40,x=1, ang=Angle(-90,35+20,0),z=-6,
			var="DRDoor1k",speed=4, min=1,max=0,disable="DRDoor1Toggle",
		}},
	}
}

ENT.ButtonMap["IGLA"] = {
    pos = Vector(387.7,34.9,41.5),
    ang = Angle(0,90,90),
    width = 512,
    height = 185,
    scale = 0.0127,
	hideseat=0.2,
}

ENT.ButtonMap["ASNP"] = {
    pos = Vector(388,47.2,42.3),
    ang = Angle(0,90,90),
    width = 180,
    height = 70,
    scale = 0.05,
    hideseat=0.2,

    buttons = {
        {ID = "R_ASNPMenuSet",x=80.5,y=60,radius=6,tooltip = "АСНП: Меню",model = {
            model = "models/metrostroi_train/81-775/81-775_button_asnp.mdl",z=4,
            var="R_ASNPMenu",speed=12,vmin=0,vmax=0.9,
            sndvol = 0.5,snd = function(val) return val and "pnm_button1_on" or "pnm_button1_off" end,
            sndmin = 50,sndmax = 1e3,sndang = Angle(-90,0,0),
        }},
        {ID = "R_ASNPUpSet",x=159.8,y=8,radius=8,tooltip = "АСНП: Вверх",model = {
            model = "models/metrostroi_train/81-775/81-775_button_asnp.mdl",z=4,
            var="R_ASNPUp",speed=12,vmin=0,vmax=0.9,
            sndvol = 0.5,snd = function(val) return val and "pnm_button1_on" or "pnm_button2_off" end,
            sndmin = 50,sndmax = 1e3,sndang = Angle(-90,0,0),
        }},
        {ID = "R_ASNPDownSet",x=159.8,y=28,radius=8,tooltip = "АСНП: Вниз",model = {
            model = "models/metrostroi_train/81-775/81-775_button_asnp.mdl",z=4,
            var="R_ASNPDown",speed=12,vmin=0,vmax=0.9,
            sndvol = 0.5,snd = function(val) return val and "pnm_button2_on" or "pnm_button1_off" end,
            sndmin = 50,sndmax = 1e3,sndang = Angle(-90,0,0),
        }},
        {ID = "R_ASNPOnToggle",x=10,y=22,radius=8,tooltip = "АСНП: Включение",model = {
            model = "models/metrostroi_train/81-775/81-775_button_asnp.mdl",z=4,ang=0,
            var="R_ASNPOn",speed=12,vmin=0,vmax=1,
            sndvol = 0.5,snd = function(val) return val and "pnm_on" or "pnm_off" end,
            sndmin = 50,sndmax = 1e3,sndang = Angle(-90,0,0),
        }},
    }
}

ENT.ButtonMap["ASNPScreen"] = {
    pos = Vector(387.6,48.6,42),
    ang = Angle(0,90,90),
    width = 622,
    height = 128,
    scale = 0.0086,
    hideseat=0.2,
}

ENT.ButtonMap["Lighting"] = {
    pos = Vector(440,52.35,-4.5),
    ang = Angle(-5.2,-20.6,51),
    width = 200,
    height = 125,
    scale = 0.05,
    hideseat=0.2,

    buttons = {
		{ID = "CPanelShtoraUp",		x=178,	y=24,	radius=15,tooltip="Поднять штору"},
		{ID = "CPanelShtoraDown",	x=128,	y=24,	radius=15,tooltip="Опустить штору"},

		{ID = "CPanelCabLight",		x=59,	y=63,	radius=15,tooltip="Освещение кабины"},
		{ID = "CPanelCabLight1",	x=35,	y=24,	radius=10,tooltip="Освещение кабины слабое"},
		{ID = "CPanelCabLight2",	x=81,	y=24,	radius=10,tooltip="Освещение кабины сильное"},

		{ID = "CPanelPultLight",	x=152,  y=63,	radius=15,tooltip="Освещение пульта"},
		{ID = "CPanelPultLight1",	x=175,	y=101,	radius=15,tooltip="Освещение пульта сильнeе"},
		{ID = "CPanelPultLight2",	x=127,	y=101,	radius=15,tooltip="Освещение пульта слабeе"},
    }
}

ENT.ButtonMap["ScreenOne"] = {
	pos = Vector(-223,60.5,34.1),
	ang = Angle(0,0,90),
	width = 1080,
	height = 676,
	scale = 0.018,
	hide=0.4,
}
ENT.ButtonMap["ScreenTwo"] = {
	pos = Vector(162.7,-60.5,34.1),
	ang = Angle(0,180,90),
	width = 1080,
	height = 676,
	scale = 0.018,
	hidet=0.4,
}
ENT.ButtonMap["ScreenThree"] = {
	pos = Vector(244.6,60.5,34.1),
	ang = Angle(0,0,90),
	width = 1080,
	height = 676,
	scale = 0.018,
	hide=0.4,
}
ENT.ButtonMap["ScreenFour"] = {
	pos = Vector(10.8,60.5,34.1),
	ang = Angle(0,0,90),
	width = 1080,
	height = 676,
	scale = 0.018,
	hide=0.4,
}
ENT.ButtonMap["ScreenFive"] = {
	pos = Vector(-71.1,-60.5,34.1),
	ang = Angle(0,180,90),
	width = 1080,
	height = 676,
	scale = 0.018,
	hide=0.4,
}
ENT.ButtonMap["ScreenSix"] = {
	pos = Vector(-304.9,-60.5,34.1),
	ang = Angle(0,180,90),
	width = 1080,
	height = 676,
	scale = 0.018,
	hide=0.4,
}

ENT.Lights = {
	[1] = {	"headlight",	Vector(530,0,55),	Angle(-8,0,0),	Color(200,200,255),	farz = 200,	fov=179,	brightness = 0.2,	nearz = 100,texture = "models/metrostroi_train/equipment/headlight2",shadows = 1,headlight=true},
	[2] = {	"headlight",	Vector(530,0,55),	Angle(30,0,0),	Color(200,200,255),	farz = 10000,fov=120,	brightness = 2,		nearz = 100,texture = "models/metrostroi_train/equipment/headlight2",shadows = 1,headlight=true},
	[3] = {	"headlight",	Vector(530,0,55),	Angle(0,0,0),	Color(200,200,255),	farz = 10000,fov=120,	brightness = 2,		nearz = 100,texture = "models/metrostroi_train/equipment/headlight2",shadows = 1,headlight=true},
	[4] = {	"headlight",	Vector(530,0,55),	Angle(-4,0,0),	Color(255,4,2),		farz = 320,	fov=170,	brightness = 0.18,	nearz = 100,texture = "models/metrostroi_train/equipment/headlight2",shadows = 1,backlight=true},

}

local NewMetrostroi = Metrostroi.Version >= 1623941696

local SALON_PT_PITCH = 65
local SALON_LEVEL = 0.50
local SALON_MODES = {
	{col = Color(255,206,166), mul = 0.85},
	{col = Color(255,228,206), mul = 1},
	{col = Color(255,196,137), mul = 0.8},
	{col = Color(255,196,137), mul = 0.55},
}
for _, m in ipairs(SALON_MODES) do m.tint = {m.col.r/255, m.col.g/255, m.col.b/255} end
local SALON_PT_Z = 45
local END_LIGHTS = {
	{key = "SalonPT1", pos = Vector(353,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT2", pos = Vector(234,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT3", pos = Vector(115,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT4", pos = Vector(-4,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT5", pos = Vector(-124,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT6", pos = Vector(-243,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT7", pos = Vector(-362,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT8", pos = Vector(-442,0,SALON_PT_Z), ang = Angle(90,0,0)},
}
function ENT:RemoveSalonEndLights()
	self.EndLightsState = nil
	for _,d in ipairs(END_LIGHTS) do
		local pt = self[d.key]
		if IsValid(pt) then pt:Remove() end
		self[d.key] = nil
	end
end
local endLightsOffCV = CreateClientConVar("775_optimization3","0",true,false)
local SALON_PT_IDLE_INTERVAL = 0.2
local SALON_PT_ANG_EVEN = Angle(SALON_PT_PITCH, 90, 0)
local SALON_PT_ANG_ODD = Angle(SALON_PT_PITCH, -90, 0)
function ENT:UpdateSalonEndLights(on, power)
	local lp = LocalPlayer()
	if on and endLightsOffCV:GetBool() then on = false end
	if on and IsValid(lp) and lp:GetPos():DistToSqr(self:GetPos()) > 1200*1200 then on = false end
	if not on or power <= 0 then self:RemoveSalonEndLights() return end
	local mode = self.SalonMode or SALON_MODES[1]
	if not self.EndLightsHooked then
		self.EndLightsHooked = true
		self:CallOnRemove("SalonEndLights", function(ent) ent:RemoveSalonEndLights() end)
	end
	local pos, ang = self:GetPos(), self:GetAngles()
	local brightness = 0.135*power*(power >= 1 and SALON_LEVEL or 1)*mode.mul
	local now = RealTime()
	local st = self.EndLightsState
	if not st then
		st = {}
		self.EndLightsState = st
	elseif st.pos == pos and st.ang == ang and st.mode == mode and st.brightness == brightness and now - st.time < SALON_PT_IDLE_INTERVAL then
		return
	end
	st.pos, st.ang, st.mode, st.brightness, st.time = pos, ang, mode, brightness, now
	for i,d in ipairs(END_LIGHTS) do
		local pt = self[d.key]
		if not IsValid(pt) then
			pt = ProjectedTexture()
			pt:SetTexture("effects/flashlight/soft")
			pt:SetEnableShadows(false)
			pt:SetFOV(160)
			pt:SetNearZ(6)
			pt:SetFarZ(260)
			self[d.key] = pt
		end
		pt:SetPos(self:LocalToWorld(d.pos))
		pt:SetAngles(self:LocalToWorldAngles((i%2==0) and SALON_PT_ANG_EVEN or SALON_PT_ANG_ODD))
		pt:SetColor(mode.col)
		pt:SetBrightness(brightness)
		pt:Update()
	end
end

local salonAmbCV   = CreateClientConVar("metrostroi_775_salon_ambient","1",true,false)
local salonCeilCV  = CreateClientConVar("metrostroi_775_salon_ceiling","0.85",true,false)
local salonWallsCV = CreateClientConVar("metrostroi_775_salon_walls","0.70",true,false)
local salonFloorCV = CreateClientConVar("metrostroi_775_salon_floor","0.75",true,false)
local salonContrastCV = CreateClientConVar("metrostroi_775_salon_contrast","0.6",true,false)
local SALON_WORLD_SIDES = {
	{BOX_FRONT, Vector( 1, 0, 0)}, {BOX_BACK, Vector(-1, 0, 0)},
	{BOX_RIGHT, Vector( 0, 1, 0)}, {BOX_LEFT, Vector( 0,-1, 0)},
}
local function SalonSetFace(side, v, k, amb, t)
	render.SetModelLighting(side, t[1]*v*k + amb.x, t[2]*v*k + amb.y, t[3]*v*k + amb.z)
end
local function SalonRenderOverride(ent, flags)
	local p = ent.SalonLightPow or 0
	if p <= 0 then ent:DrawModel(flags) return end
	local mode = ent.SalonMode or SALON_MODES[1]
	local t = mode.tint
	local k = salonAmbCV:GetFloat() * p * (p >= 1 and SALON_LEVEL or 1) * mode.mul
	local amb = render.GetLightColor(ent:GetPos()) * 0.15
	local walls = salonWallsCV:GetFloat()
	render.SuppressEngineLighting(true)
	SalonSetFace(BOX_TOP,    salonFloorCV:GetFloat(), k, amb, t)
	SalonSetFace(BOX_BOTTOM, salonCeilCV:GetFloat(),  k, amb, t)
	local axial = walls * (1 - math.Clamp(salonContrastCV:GetFloat(), 0, 1))
	local fwd, right = ent:GetForward(), ent:GetRight()
	for _, f in ipairs(SALON_WORLD_SIDES) do
		local lx, ly = f[2]:Dot(fwd), f[2]:Dot(right)
		SalonSetFace(f[1], lx*lx*axial + ly*ly*walls, k, amb, t)
	end
	ent:DrawModel(flags)
	render.SuppressEngineLighting(false)
end

local CAB_DOOR_LIGHT = {
	CabinRightDoor = {center = Vector(416, -65, 40), out = Vector(0, -1, 0)},
	CabinLeftDoor  = {center = Vector(416,  65, 40), out = Vector(0,  1, 0)},
}

local BORTNUM = {x = -482.90, z = 15.45, yl = 66.85, yr = -66.80, pitch = 3.42, max = 6}
for i = 1, BORTNUM.max do
	ENT.ClientProps["bortnum_l"..i] = {
		model = "models/metrostroi_train/81-775/775_bortnum.mdl",
		pos = Vector(BORTNUM.x, BORTNUM.yl, BORTNUM.z),
		ang = Angle(0, 90, 0),
		hide = 1.5,
	}
	ENT.ClientProps["bortnum_r"..i] = {
		model = "models/metrostroi_train/81-775/775_bortnum.mdl",
		pos = Vector(BORTNUM.x, BORTNUM.yr, BORTNUM.z),
		ang = Angle(0, -90, 0),
		hide = 1.5,
	}
end

local BORT_SIDES = {"l", "r"}
local BORT_NAMES = {l = {}, r = {}}
for i = 1, BORTNUM.max do
	BORT_NAMES.l[i] = "bortnum_l"..i
	BORT_NAMES.r[i] = "bortnum_r"..i
end

function ENT:UpdateBortNumber()
	if not self.ClientEnts or not self.GetWagonNumber then return end
	local raw = self:GetWagonNumber() or ""
	if self.BortNumRaw ~= raw then
		self.BortNumRaw = raw
		self.BortNumStr = string.gsub(tostring(raw), "%D", "")
	end
	local num = self.BortNumStr
	local n = #num
	for i = 1, BORTNUM.max do
		for _, side in ipairs(BORT_SIDES) do
			local ent = self.ClientEnts[BORT_NAMES[side][i]]
			if IsValid(ent) and ent.BortKey ~= num then
				ent.BortKey = num
				local d = tonumber(string.sub(num, i, i))
				if not d then
					ent:SetNoDraw(true)
				else
					ent:SetNoDraw(false)
					local bg = ent:FindBodygroupByName("digit")
					ent:SetBodygroup(bg >= 0 and bg or 0, d)
					local off = (i - (n + 1) / 2) * BORTNUM.pitch
					local pos = side == "l" and Vector(BORTNUM.x - off, BORTNUM.yl, BORTNUM.z) or Vector(BORTNUM.x + off, BORTNUM.yr, BORTNUM.z)
					ent:SetPos(self:LocalToWorld(pos))
					ent:SetAngles(self:LocalToWorldAngles(Angle(0, side == "l" and 90 or -90, 0)))
				end
			end
		end
	end
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.MFDU = self:CreateRT("775MFDU",800*2,600*2)
	self.Speedometer = self:CreateRT("775Speedometer",1940,330)
	self.MVO = self:CreateRT("775MVO",800,600)
	self.CIK = self:CreateRT("775CIK",2048,1024)
	self.ASNP = self:CreateRT("775ASNP",512,128)
    self.IGLA = self:CreateRT("775IGLA",512,185)
	self.MosLogo = GetRenderTarget("Metrostroi_775_MosLogo_" .. self:EntIndex(), 256, 256)
	self.ROUTER = self:CreateRT("775ROUTER",500,72)
	self.BNTN = self:CreateRT("775BNTN",570*4,72*4)
	self.BNTN2 = self:CreateRT("775BNTN2",570*4,72*4)
	self.BNTScr = self:CreateRT("775BNT",1920*2,238*2)
	self.BNTScr2 = self.BNTScr
	self.BNTScr3 = self.BNTScr
	self.BNTScr4 = self.BNTScr
	self.BNTScr5 = self:CreateRT("775BNT5",1920*2,238*2)
	self.BNTScr6 = self.BNTScr5
	self.BNTScr7 = self.BNTScr5
	self.BNTScr8 = self.BNTScr5
	self.SCREEN = self:CreateRT("717SCREEN",1080,676)
	self.ReleasedPdT = 0
	self.PreviousRingState = false
	self.PreviousCompressorState = false
	self.TISUVol = 0

	self.EmergencyValveRamp = 0
	self.StopKranValveRamp = 0
	self.EmergencyValveEPKRamp = 0
	self.EmergencyBrakeValveRamp = 0

	self.CraneRamp = 0
	self.CraneRRamp = 0
	self.FrontLeak = 0
	self.RearLeak = 0
	self.CompressorVol = 0
	self.ParkingBrake = 0
	self.BrakeCylinder = 0.5
	self.BPSNBuzzVolume = 0
	self.VentVolume = 0
	self.VentVolume2 = 0

	self.WiperValue = 0

	self.VentRand = {}
	self.VentState = {}
	self.VentVol = {}
	for i=1,7 do
		self.VentRand[i] = math.Rand(0.5,2)
		self.VentState[i] = 0
		self.VentVol[i] = 0
	end
	self.FrontBogey = self:GetNW2Entity("FrontBogey")
	self.RearBogey = self:GetNW2Entity("RearBogey")

	self.FrontCouple = self:GetNW2Entity("FrontCouple")
	self.RearCouple = self:GetNW2Entity("RearCouple")

	self.DoorMigTimer = 10

end

function ENT:UpdateTextures()
	self.Texture = self:GetNW2String("texture")
	self.PassTexture = self:GetNW2String("passtexture")
	self.CabinTexture = self:GetNW2String("cabtexture")
	self.Number = self:GetWagonNumber()
	for i=0,4 do
		local num = tostring(self.Number)[i+1]
		if not num or num == "" then num = "3" end
		if IsValid(self.ClientEnts["TrainNumberL"..i]) then
			local number = self.ClientEnts["TrainNumberL"..i]
			number:SetPos(self:LocalToWorld(Vector(-458.7-i*5.8,68,30)))
			number:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)))
			number:SetModel("models/metrostroi_train/81-760/numbers/number_"..num..".mdl")
		end
		if IsValid(self.ClientEnts["TrainNumberR"..i]) then
			local number = self.ClientEnts["TrainNumberR"..i]
			number:SetPos(self:LocalToWorld(Vector(-473.7+i*5.8,-68,30)))
			number:SetAngles(self:LocalToWorldAngles(Angle(0,-90,0)))
			number:SetModel("models/metrostroi_train/81-760/numbers/number_"..num..".mdl")
		end
	end
	if not IsValid(self.RearBogey) then
		self.RearBogey = self:GetNW2Entity("RearBogey")
	end
	if not IsValid(self.FrontBogey) then
		self.FrontBogey = self:GetNW2Entity("FrontBogey")
	end
end
local Cpos = {
	1.2,1,0.7,0.4,0.1,-0.2,-0.8
}
local controllerpos = {
	0,0.13,0.265,0.432,0.568,0.708,0.877,1
}
function ENT:IsNumberError()
	local err = false
	for i=0,4 do
		if IsValid(self.ClientEnts["TrainNumber"..i]) and (self.ClientEnts["TrainNumber"..i]:GetPos()==self:GetPos()) then
			err = true
			break
		end
		if IsValid(self.ClientEnts["TrainNumberL"..i]) and (self.ClientEnts["TrainNumberL"..i]:GetPos()==self:GetPos()) then
			err = true
			break
		end
		if IsValid(self.ClientEnts["TrainNumberR"..i]) and (self.ClientEnts["TrainNumberR"..i]:GetPos()==self:GetPos()) then
			err = true
			break
		end
	end
	return err
end

function ENT:ReInitBogeySounds(bogey)
	if not IsValid(bogey) then return end

	bogey.SoundNames = {}
	bogey.EngineSNDConfig = {}

	bogey.MotorSoundType = bogey:GetNWInt("MotorSoundType",2)
	for k,v in pairs(bogey.EngineSNDConfig) do bogey:SetSoundState(v[1],0,0) end
	table.insert(bogey.EngineSNDConfig,{"ted1_720" ,08,00,16,  0.14})
	table.insert(bogey.EngineSNDConfig,{"ted2_720" ,16,08-4,24,0.13})
	table.insert(bogey.EngineSNDConfig,{"ted3_720" ,24,16-4,32,0.12})
	table.insert(bogey.EngineSNDConfig,{"ted4_720" ,32,24-4,40,0.10})
	table.insert(bogey.EngineSNDConfig,{"ted5_720" ,40,32-4,48,0.09})
	table.insert(bogey.EngineSNDConfig,{"ted6_720" ,48,40-4,56,0.06})
	table.insert(bogey.EngineSNDConfig,{"ted7_720" ,56,48-4,64,0.05})
	table.insert(bogey.EngineSNDConfig,{"ted8_720" ,64,56-4,72,0.04})
	table.insert(bogey.EngineSNDConfig,{"ted9_720" ,72,64-4,80,0.03})
	table.insert(bogey.EngineSNDConfig,{"ted10_720",80,72-4,88,0.02})

	bogey.SoundNames = {}

	bogey.SoundNames["ted1_703"]  = "subway_trains/bogey/engines/703/speed_8.wav"
	bogey.SoundNames["ted2_703"]  = "subway_trains/bogey/engines/703/speed_16.wav"
	bogey.SoundNames["ted3_703"]  = "subway_trains/bogey/engines/703/speed_24.wav"
	bogey.SoundNames["ted4_703"]  = "subway_trains/bogey/engines/703/speed_32.wav"
	bogey.SoundNames["ted5_703"]  = "subway_trains/bogey/engines/703/speed_40.wav"
	bogey.SoundNames["ted6_703"]  = "subway_trains/bogey/engines/703/speed_48.wav"
	bogey.SoundNames["ted7_703"]  = "subway_trains/bogey/engines/703/speed_56.wav"
	bogey.SoundNames["ted8_703"]  = "subway_trains/bogey/engines/703/speed_64.wav"
	bogey.SoundNames["ted9_703"]  = "subway_trains/bogey/engines/703/speed_72.wav"
	bogey.SoundNames["ted10_703"] = "subway_trains/bogey/engines/703/speed_80.wav"
	bogey.SoundNames["ted11_703"] = "subway_trains/bogey/engines/703/speed_88.wav"

	bogey.SoundNames["ted1_717"]  = "subway_trains/bogey/engines/717/engines_8.wav"
	bogey.SoundNames["ted2_717"]  = "subway_trains/bogey/engines/717/engines_16.wav"
	bogey.SoundNames["ted3_717"]  = "subway_trains/bogey/engines/717/engines_24.wav"
	bogey.SoundNames["ted4_717"]  = "subway_trains/bogey/engines/717/engines_32.wav"
	bogey.SoundNames["ted5_717"]  = "subway_trains/bogey/engines/717/engines_40.wav"
	bogey.SoundNames["ted6_717"]  = "subway_trains/bogey/engines/717/engines_48.wav"
	bogey.SoundNames["ted7_717"]  = "subway_trains/bogey/engines/717/engines_56.wav"
	bogey.SoundNames["ted8_717"]  = "subway_trains/bogey/engines/717/engines_64.wav"
	bogey.SoundNames["ted9_717"]  = "subway_trains/bogey/engines/717/engines_72.wav"
	bogey.SoundNames["ted10_717"] = "subway_trains/bogey/engines/717/engines_80.wav"

	bogey.SoundNames["ted1_720"]  = "subway_trains/760/engines/engine_8.wav"
	bogey.SoundNames["ted2_720"]  = "subway_trains/760/engines/engine_16.wav"
	bogey.SoundNames["ted3_720"]  = "subway_trains/760/engines/engine_24.wav"
	bogey.SoundNames["ted4_720"]  = "subway_trains/760/engines/engine_32.wav"
	bogey.SoundNames["ted5_720"]  = "subway_trains/760/engines/engine_40.wav"
	bogey.SoundNames["ted6_720"]  = "subway_trains/760/engines/engine_48.wav"
	bogey.SoundNames["ted7_720"]  = "subway_trains/760/engines/engine_56.wav"
	bogey.SoundNames["ted8_720"]  = "subway_trains/760/engines/engine_64.wav"
	bogey.SoundNames["ted9_720"]  = "subway_trains/760/engines/engine_72.wav"
	bogey.SoundNames["ted10_720"] = "subway_trains/760/engines/engine_80.wav"
	bogey.SoundNames["flangea"]	  = "subway_trains/bogey/skrip1.wav"
	bogey.SoundNames["flangeb"]	  = "subway_trains/bogey/skrip2.wav"
	bogey.SoundNames["flange1"]	  = "subway_trains/bogey/flange_9.wav"
	bogey.SoundNames["flange2"]	  = "subway_trains/bogey/flange_10.wav"
	bogey.SoundNames["brakea_loop1"]	   = "subway_trains/bogey/braking_async1.wav"
	bogey.SoundNames["brakea_loop2"]	   = "subway_trains/bogey/braking_async2.wav"
	bogey.SoundNames["brake_loop1"]	   = "subway_trains/bogey/brake_rattle3.wav"
	bogey.SoundNames["brake_loop2"]	   = "subway_trains/bogey/brake_rattle4.wav"
	bogey.SoundNames["brake_loop3"]	   = "subway_trains/bogey/brake_rattle5.wav"
	bogey.SoundNames["brake_loop4"]	   = "subway_trains/bogey/brake_rattle6.wav"
	bogey.SoundNames["brake_loopb"]	   = "subway_trains/common/junk/junk_background_braking1.wav"
	bogey.SoundNames["brake2_loop1"]	   = "subway_trains/bogey/brake_rattle2.wav"
	bogey.SoundNames["brake2_loop2"]	   = "subway_trains/bogey/brake_rattle_h.wav"
	bogey.SoundNames["brake_squeal1"]	   = "subway_trains/bogey/brake_squeal1.wav"
	bogey.SoundNames["brake_squeal2"]	   = "subway_trains/bogey/brake_squeal2.wav"

	if bogey.Sounds then
		for k,v in pairs(bogey.Sounds) do
			v:Stop()
		end
	end

	bogey.Sounds = {}
	bogey.Playing = {}
	for k,v in pairs(bogey.SoundNames) do
		util.PrecacheSound(v)
		local e = bogey
		if (k == "brake3a") and IsValid(bogey:GetNW2Entity("TrainWheels")) then
			e = bogey:GetNW2Entity("TrainWheels")
		end
		bogey.Sounds[k] = CreateSound(e, Sound(v))
	end

	bogey.Async = nil

end

function ENT:PlayDoorSound(bool,door)
 	if self[door] ~= bool then
 		self[door] = bool
 		self:PlayOnce(door.."_"..(self[door] and "open" or "close"),"",1,1)
 	end
end

local CabDoorSoundPrefix = {
	CabinRightDoor = "door_cab_r_",
	CabinLeftDoor  = "door_cab_l_",
	CabinPassDoor  = "door_cab_p_",
}

local function CabDoorEase(x) return x * x * (3 - 2 * x) end

function ENT:UpdateCabDoorHandles(door_name, frac)
	if not CABDOOR.HANDLES_ENABLED then return end
	local cfg = CABDOOR.Handles[door_name]
	local door = self.ClientEnts[door_name]
	if not cfg or not IsValid(door) then return end
	if door.CabHandleFrac == frac then return end

	if door.CabHandleBones == nil then
		local list = {}
		for _, name in ipairs(cfg.bones) do
			local id = door:LookupBone(name)
			if id then list[#list + 1] = id end
		end
		door.CabHandleBones = list
	end
	door.CabHandleFrac = frac

	local deg = cfg.sign * CABDOOR.HANDLE_ANGLE * frac
	local ang = cfg.axis == "yaw" and Angle(0, deg, 0) or Angle(0, 0, deg)
	for _, id in ipairs(door.CabHandleBones) do
		door:ManipulateBoneAngles(id, ang)
	end
end

function ENT:UpdateDoor(door_var, door_name, limit)
	local now = CurTime()
	local want = self:GetPackedBool(door_var)
	local sndPrefix = CabDoorSoundPrefix[door_name]

	self.CabDoorAnim = self.CabDoorAnim or {}
	local st = self.CabDoorAnim[door_name]
	if not st then
		st = {want = want, target = want, frac = 0}
		self.CabDoorAnim[door_name] = st
	elseif st.want ~= want then
		st.want = want
		if want then
			st.closeSndAt = nil
			if not st.target then
				st.target = true
				st.handle = {kind = "open", t0 = now, from = st.frac}
				if sndPrefix then self:PlayOnce(sndPrefix .. "open", "", 1, 1) end
			end
		else
			if st.target then
				st.target = false
				st.handle = {kind = "close", t0 = now, from = st.frac}
				st.closeSndAt = now + CABDOOR.CLOSE_SND_DELAY
			end
		end
	end

	if st.closeSndAt and now >= st.closeSndAt then
		st.closeSndAt = nil
		if sndPrefix then self:PlayOnce(sndPrefix .. "close", "", 1, 1) end
	end

	local door_state = self:Animate(door_name, st.target and (limit or 1) or 0, 0, 1, 2, 1)
	st.pos = door_state

	local frac = 0
	local ha = st.handle
	if ha then
		local t = now - ha.t0
		local press = CabDoorEase(math.Clamp(t / CABDOOR.PRESS_TIME, 0, 1))
		local releaseAt
		if ha.kind == "open" then
			releaseAt = ha.t0 + CABDOOR.PRESS_TIME + CABDOOR.HOLD_OPEN
		else
			if not ha.releaseAt and ((t > CABDOOR.PRESS_TIME and door_state < 0.04) or t > CABDOOR.CLOSE_TIMEOUT) then
				ha.releaseAt = now
			end
			releaseAt = ha.releaseAt
		end
		local rel = releaseAt and math.Clamp((now - releaseAt) / CABDOOR.RELEASE_TIME, 0, 1) or 0
		if rel >= 1 then
			st.handle = nil
		else
			frac = Lerp(press, ha.from or 0, 1) * (1 - CabDoorEase(rel))
		end
	end
	st.frac = frac
	self:UpdateCabDoorHandles(door_name, frac)

	return st
end

function ENT:UpdateIntLight()
	if not IsValid(self.ClientEnts["interior_led"]) then return end
	local led = self.ClientEnts["interior_led"]

	led:SetColor(Metrostroi.ANNOUNCER_MAP_775[self:GetNW2Int("BNT:Line",1)].color or Color(255,255,255))

end

local CAB_DLIGHTS = {
	{pos = Vector(402.3, 0, 38), col = Color(255,203,161), brightness = 0.924, size = 450},
	{pos = Vector(432.5, 0, 42), col = Color(255,203,161), brightness = 0.616, size = 400},
}
function ENT:UpdateCabDLight(n, on)
	self.CabDLightOn = self.CabDLightOn or {}
	local key = 77500000 + self:EntIndex()*4 + n*2
	if not on then
		if self.CabDLightOn[n] then
			self.CabDLightOn[n] = false
			for i = 0, 1 do
				local l = DynamicLight(key + i, i == 1)
				if l then l.DieTime = 0 end
			end
		end
		return
	end
	self.CabDLightOn[n] = true
	local d = CAB_DLIGHTS[n]
	local pos = self:LocalToWorld(d.pos)
	for i = 0, 1 do
		local l = DynamicLight(key + i, i == 1)
		if l then
			l.Pos = pos
			l.r, l.g, l.b = d.col.r, d.col.g, d.col.b
			l.Brightness = d.brightness
			l.Size = d.size
			l.Decay = d.size*50
			l.DieTime = CurTime() + 1
			l.nomodel = i == 0
		end
	end
end
local ECRAN_KEYS = {"ecran1", "ecran2"}
local DOOR_LED_OFF = "models/metrostroi_train/81-775/led.vtf"
local DOOR_LED_RED = "models/metrostroi_train/81-775/led_red.vtf"
local DOOR_LED_GREEN = "models/metrostroi_train/81-775/led_green.vtf"
local DOOR_LED_WHITE = "models/metrostroi_train/81-775/led_white.vtf"
local DOOR_INFO = {}
for i = 0, 3 do
	for k = 0, 1 do
		local side = k == 1 and "DoorL" or "DoorR"
		local sid = "door"..i.."x"..k
		DOOR_INFO[#DOOR_INFO + 1] = {
			side = side,
			id = side..(i + 1),
			sid = sid,
			loop = sid.."r",
			led = "salon_led"..i.."x"..k,
			aod = "AOD"..(k == 1 and 2*i + 2 or 2*i + 1),
			announce = "DoorAnnounceState"..(k == 1 and i + 1 or i + 5),
			light = k == 1 and "DoorLightL" or "DoorLightR",
			slot = i == 0 and 1 or 2,
		}
	end
end
local function SetLedMat(ent, slot, mat)
	if ent.DoorLedMat ~= mat then
		ent.DoorLedMat = mat
		ent:SetSubMaterial(slot, mat)
	end
end
local propNameCache = setmetatable({}, {__mode = "k"})
local function PropNames(props, id, match)
	local cache = propNameCache[props]
	if not cache then
		cache = {}
		propNameCache[props] = cache
	end
	local list = cache[id]
	if not list then
		list = {}
		for n in pairs(props) do
			if isstring(n) and match(n) then list[#list + 1] = n end
		end
		cache[id] = list
	end
	return list
end
local function IsSalonLitProp(n) return string.StartWith(n,"salon_led") or string.StartWith(n,"emerdoor_plate") end
local function IsIntLightProp(n) return string.StartWith(n,"int_light") end
local INT_LIGHT_ON = Color(255,255,255)
local INT_LIGHT_OFF = Color(25,25,25)
local CAB_DOOR_NAMES = {"CabinRightDoor", "CabinLeftDoor"}
local CAB_DOOR_PARTS = {"CabinRightDoor", "CabinLeftDoor", "CabinRightDoorGlass", "CabinLeftDoorGlass"}
local CAB_DOOR_GLASS = {{"CabinLeftDoorGlass", "CabinLeftDoor"}, {"CabinRightDoorGlass", "CabinRightDoor"}}
function ENT:Think()
	self.BaseClass.Think(self)
	self:UpdateBortNumber()
	if not self.RenderClientEnts or self.CreatingCSEnts then
		self.Number = 0
		return
	end
	self:UpdateEmerDoor()
	if not MSMP then
		if IsValid(self.FrontBogey) and self.FrontBogey.SoundNames and (self.FrontBogey.SoundNames["ted1_720"] ~= "subway_trains/760/engines/engine_8.wav" or self.FrontBogey.EngineSNDConfig and self.FrontBogey.EngineSNDConfig[1] and self.FrontBogey.EngineSNDConfig[1][5] ~= 0.14) or refresh then
			self:ReInitBogeySounds(self.FrontBogey)
		end
		if IsValid(self.RearBogey) and self.RearBogey.SoundNames and (self.RearBogey.SoundNames["ted1_720"] ~= "subway_trains/760/engines/engine_8.wav" or self.RearBogey.EngineSNDConfig and self.RearBogey.EngineSNDConfig[1] and self.RearBogey.EngineSNDConfig[1][5] ~= 0.14) or refresh then
			self:ReInitBogeySounds(self.RearBogey)
		end
	end
local glow21 = self:GetNW2Entity("GlowingLights21")
local glow22 = self:GetNW2Entity("GlowingLights22")

if IsValid(glow21) and IsValid(glow22) then
    local headlightsOn = self:GetPackedBool("HeadlightsEnabled2") or self:GetPackedBool("HeadlightsEnabled1")

    if headlightsOn and self.keyval ~= 1 then
        glow21:SetKeyValue("_light", "255 255 255")
        glow22:SetKeyValue("_light", "255 255 255")
        self.keyval = 1
    elseif not headlightsOn and self.keyval ~= 0 then
        glow21:SetKeyValue("_light", "0 0 0")
        glow22:SetKeyValue("_light", "0 0 0")
        self.keyval = 0
    end
end

	self:UpdateIntLight()

	if IsValid(self.ClientEnts["bogey_flexible_front"]) then
		local bogey_part = self.ClientEnts["bogey_flexible_front"]

		local bonen = 1

		if not self.BogeyPartFrontPos then
			self.BogeyPartFrontPos = self:WorldToLocal(bogey_part:GetPos())
		end

		bogey_part:ManipulateBonePosition(bonen, Vector(0, 0, 0))
	end

	if not NewMetrostroi then

	end

	for i=1,4 do
		self:Animate("TR"..i, self:GetPackedBool("TR"..i) and 1 or 0, 0, 1, 8, 0.5)
	end

	local lv = self:GetPackedRatio("AKBVoltage")
	local hv = self:GetPackedRatio("HVVoltage")
	local bc = self:GetPackedRatio("BC")
	local tl = self:GetPackedRatio("TL")
	local bl = self:GetPackedRatio("BL")

	local pbState = self:GetPackedBool("PB")
	if self.PBSndOld == nil then
		self.PBSndOld = pbState
	elseif self.PBSndOld ~= pbState then
		self.PBSndOld = pbState
		self:PlayOnce(pbState and "pb_on" or "pb_off", "", 1, 1)
	end
	self:Animate("pb",  self:GetPackedBool("PB") and 1 or 0,0,1,  8,false)
	self:Animate("volt_lv",lv/150,0,1,4,1)
	self:Animate("volt_hv",hv/1000,0,1.03,16,6)

	self:Animate("interior_cap",0,1,0,1, 1,0.5)
	local pvzOpen = self:GetPackedBool("PVZDoor")
	if self.PVZDoorOld ~= nil and self.PVZDoorOld ~= pvzOpen then
		self:PlayOnce(pvzOpen and "door_pvz_open" or "door_pvz_close", "", 1, 1)
	end
	self.PVZDoorOld = pvzOpen
	local pvzDoor = self:Animate("pvz_door", pvzOpen and 1 or 0, 0, 1, 1.6, 0.5)
	self:HidePanel("CoupleCenteringF", self:GetNW2Bool("FrontCoupled", false))
	self:HidePanel("PVZDoorClosed", pvzOpen)
	self:HidePanel("PVZDoorOpen", (not pvzOpen) or pvzDoor < 0.97)
	self:HidePanel("PVZ", pvzDoor < 0.34)

	self:Animate("brake_cylinder", bc, 0, 0.76, 8, 1)
	self:Animate("train_line", tl, 0, 0.76, 8, 1)
	self:Animate("brake_line", bl, 0, 0.76, 8, 1)

	self:HideButton("KRR+",self:GetPackedBool("KRRk"))
	self:HideButton("KRR-",self:GetPackedBool("KRRk"))

	self:ShowHide("headlight1", self:GetPackedBool("headlight1"))
	self:ShowHide("headlight11", self:GetPackedBool("headlight2"))
	self:ShowHide("headlight2", self:GetPackedBool("headlight3"))
	self:ShowHide("headlight3", self:GetPackedBool("headlight3"))
	self:ShowHide("redlight", self:GetPackedBool("redlight"))

	self:SetLightPower(1,self:GetPackedBool("headlight3"))
	self:SetLightPower(2,self:GetPackedBool("headlight1"))
	self:SetLightPower(3,self:GetPackedBool("headlight2"))
	self:SetLightPower(4,self:GetPackedBool("redlight"))

	local CL1,CL2 = self:GetPackedBool("CabLight1"),self:GetPackedBool("CabLight2")
	self:UpdateCabDLight(1, CL1 or CL2)
	self:UpdateCabDLight(2, CL2)
	for i = 1, 5 do
		local on = (i <= 3 and CL1) or CL2
		local le = self.ClientEnts["cablamp" .. i]
		if IsValid(le) then
			local sk = on and 1 or 0
			if le:GetSkin() ~= sk then le:SetSkin(sk) end
		end
	end
	local salonOn = self:GetPackedBool("SalonLighting2") or self:GetPackedBool("SalonLighting1")
	local salonPow = salonOn and (self:GetPackedBool("SalonHV") and 1 or 0.3) or 0
	if self:GetPackedBool("SalonEmer") then salonPow = salonPow * 0.3 end
	local salonMode = SALON_MODES[self:GetNW2Int("SalonLightTemp", 1)] or SALON_MODES[1]
	self.SalonMode = salonMode
	local lampsEnt = self.ClientEnts["lamps"]
	if IsValid(lampsEnt) and lampsEnt.SalonLampsOff ~= not salonOn then
		lampsEnt.SalonLampsOff = not salonOn
		lampsEnt:SetMaterial(lampsEnt.SalonLampsOff and "models/metrostroi_train/81-775/ledL_off" or "models/metrostroi_train/81-775/ledL")
	end
	local salonEnt = self.ClientEnts["salon"]
	if IsValid(salonEnt) then
		salonEnt.SalonLightPow = salonPow
		salonEnt.SalonMode = salonMode
		if salonEnt.RenderOverride ~= SalonRenderOverride then salonEnt.RenderOverride = SalonRenderOverride end
	end
	for _,n in ipairs(PropNames(self.ClientProps,"salonlit",IsSalonLitProp)) do
		local e = self.ClientEnts[n]
		if IsValid(e) then
			e.SalonLightPow = salonPow
			e.SalonMode = salonMode
			if e.RenderOverride ~= SalonRenderOverride then e.RenderOverride = SalonRenderOverride end
		end
	end
	local pult = self.ClientEnts["pult"]
	if IsValid(pult) then
		local pl = math.Round(self:GetPackedRatio("PultLight")*2)
		local radio = self:GetPackedBool("RadioLit")
		local pmat = pl >= 2 and (radio and "models/metrostroi_train/81-775/pult_2_lit1r" or "models/metrostroi_train/81-775/pult_2_lit1") or pl == 1 and (radio and "models/metrostroi_train/81-775/pult_2_lit2r" or "models/metrostroi_train/81-775/pult_2_lit2") or (radio and "models/metrostroi_train/81-775/pult_2_r" or "")
		if pult.Pult2Slot == nil then
			pult.Pult2Slot = false
			for k, m in ipairs(pult:GetMaterials() or {}) do
				if string.find(m, "pult_2$") then pult.Pult2Slot = k - 1 break end
			end
		end
		if pult.Pult2Slot and pult.PultMat ~= pmat then
			pult.PultMat = pmat
			pult:SetSubMaterial(pult.Pult2Slot, pmat)
		end
	end
	if IsValid(self.ClientEnts["Lpult"]) then
		local pl = math.Round(self:GetPackedRatio("PultLight")*2)
		local cab = self:GetPackedBool("CabLight2Lamp") and 2 or (self:GetPackedBool("CabLightLamp") and 1 or 0)
		local fl = 0
		if pl > 0 then
			if self:GetPackedBool("PultLight1Lamp") then fl = 1 elseif self:GetPackedBool("PultLight2Lamp") then fl = 2 end
		end
		local lmat = (cab > 0 or pl > 0) and string.format("models/metrostroi_train/81-775/Lpult_s%d%d%d_m",cab,pl,fl) or nil
		lmat = lmat or "models/metrostroi_train/81-775/Lpult"
		if self.ClientEnts["Lpult"].LpultMat ~= lmat then
			self.ClientEnts["Lpult"].LpultMat = lmat
			self.ClientEnts["Lpult"]:SetMaterial(lmat)
		end
	end
	if IsValid(self.ClientEnts["cabin"]) then
		local pl = math.Round(self:GetPackedRatio("PultLight")*2)
		local gmat = pl >= 2 and "models/metrostroi_train/81-775/775_manometrs_lit1" or pl == 1 and "models/metrostroi_train/81-775/775_manometrs_lit2" or ""
		if self.ClientEnts["cabin"].GaugeMat ~= gmat then
			self.ClientEnts["cabin"].GaugeMat = gmat
			if gmat == "" then self.ClientEnts["cabin"]:SetSubMaterial(2) else self.ClientEnts["cabin"]:SetSubMaterial(2,gmat) end
		end
	end
	self:UpdateSalonEndLights(salonOn, salonPow)
	do
		local doorLight = self:GetPackedBool("DoorLightL") or self:GetPackedBool("DoorLightR")
		for _,n in ipairs(PropNames(self.ClientProps,"intlight",IsIntLightProp)) do
			local e = self.ClientEnts[n]
			if IsValid(e) then
				local lit
				if n:find("doors") then lit = doorLight else lit = salonOn end
				lit = lit and true or false
				if e.IntLightLit ~= lit then
					e.IntLightLit = lit
					e:SetColor(lit and INT_LIGHT_ON or INT_LIGHT_OFF)
				end
			end
		end
	end

	do
		local cv = self:Animate("K35ClosetVal", self:GetPackedBool("K35Closet") and 1 or 0, 0, 1, 2, 0.5)
		self:PlayDoorSound(cv > 0, "door_add_1")
		local de = self.ClientEnts["K35Door"]
		if IsValid(de) then
			de:SetPos(self:LocalToWorld(K35_HINGE))
			de:SetAngles(self:LocalToWorldAngles(Angle(0, -K35_OPEN * cv, 0)))
		end
		self:HidePanel("K35Closet", cv > 0)
		self:HidePanel("K35ClosetOp", cv < 1)
		self:HidePanel("K35", cv == 0)
		self:ShowHide("K35", cv > 0)
		self:Animate("K35", self:GetPackedBool("K35") and 0 or 1, 0, 1, 32, 0.5)
	end
	local rightDoor = self:UpdateDoor("CabinDoorRight", "CabinRightDoor")
	self:UpdateDoor("CabinDoorLeft", "CabinLeftDoor")
	for _, nm in ipairs(CAB_DOOR_PARTS) do
		local de = self.ClientEnts[nm]
		if IsValid(de) and de.RenderOverride then de.RenderOverride = nil end
	end
	for _, nm in ipairs(CAB_DOOR_NAMES) do
		local de = self.ClientEnts[nm]
		if IsValid(de) and not de.NoGlareSet then
			for i, mat in ipairs(de:GetMaterials()) do
				if string.EndsWith(mat, "775_cabin") then
					de:SetSubMaterial(i - 1, "models/metrostroi_train/81-775/775_cabin_door")
				end
			end
			de.NoGlareSet = true
		end
	end
	do
		for _, pr in ipairs(CAB_DOOR_GLASS) do
			local lg, ld = self.ClientEnts[pr[1]], self.ClientEnts[pr[2]]
			if IsValid(lg) and IsValid(ld) and lg:GetParent() ~= ld then
				lg:SetParent(ld)
				lg:AddEffects(EF_BONEMERGE)
				lg:SetLocalPos(Vector(0, 0, 0))
				lg:SetLocalAngles(Angle(0, 0, 0))
			end
		end
	end
	self:UpdateDoor("PassengerDoor", "CabinPassDoor", rightDoor.target and 0.7 or nil)

	local spos = self:GetPackedRatio("Controller")
	local res = -(spos-0.5)
	local CTRL_ANIM_BASE, CTRL_ANIM_K = 0.375, 6
	local ctrlAnim = self.Anims and self.Anims["controller"]
	local ctrlSpeed = CTRL_ANIM_BASE
	if ctrlAnim and ctrlAnim.val then
		ctrlSpeed = math.max(CTRL_ANIM_BASE, math.abs(res - ctrlAnim.val) * CTRL_ANIM_K)
	end
	self:Animate("controller", res, 0.25, 0.80, ctrlSpeed,false)

	self:Animate("cab_helper_seat", self:GetPackedBool("HelperSeat") and 0 or 0.9,0,1, 2, 0.5)

	self:Animate("EmergencyBrakeValve", self:GetPackedBool("EmergencyBrakeValve") and 1 or 0, 0, 1,  6,false)

	local crane = self:GetPackedRatio("Crane", 0)

	self:Animate("km013", Cpos[crane] or 0, 0.18, 0.6,  1,false)

	self:Animate("bogey_brakes_front", 0, 0, 1,  1,false)
	self:Animate("bogey_brakes_back", 0, 0, 1,  1,false)

	local speed = self:GetPackedRatio("Speed", 0)

	self:Animate("FrontBrake", self:GetNW2Bool("FbI") and 0 or 1,0,1, 3, false)
	self:Animate("FrontTrain",  self:GetNW2Bool("FtI") and 0 or 1,0,1, 3, false)
	self:Animate("RearBrake",   self:GetNW2Bool("RbI") and 0 or 1,0,1, 3, false)
	self:Animate("RearTrain",   self:GetNW2Bool("RtI") and 0 or 1,0,1, 3, false)

	 if self.LastValue ~= self:GetPackedBool("GV") then
		 self.ResetTime = CurTime()+1.5
		 self.LastValue = self:GetPackedBool("GV")
	 end
	 self:Animate("gv_wrench",   (self:GetPackedBool("GV") and 0 or 1),  0,0.5, 128,  1,false)
	 self:ShowHideSmooth("gv_wrench",	CurTime() < self.ResetTime and 1 or 0.1)

	local k53_cap_anim = self:Animate("floor_cap1", (self:GetPackedBool("K53_cap") and 1 or 0), 0,1,5,2)
	self:HidePanel("K53", k53_cap_anim < 0.3)
	self:HidePanel("K53_cap_Open", self:GetPackedBool("K53_cap"))
	self:HidePanel("K53_cap_Close", not self:GetPackedBool("K53_cap"))

	local k40_cap_anim = self:Animate("floor_cap2", (self:GetPackedBool("K40_cap") and 1 or 0), 0,1,5,2)
	self:HidePanel("K40", k40_cap_anim < 0.3)
	self:HidePanel("K40_cap_Open", self:GetPackedBool("K40_cap"))
	self:HidePanel("K40_cap_Close", not self:GetPackedBool("K40_cap"))

	local k41_cap_anim = self:Animate("floor_cap3", (self:GetPackedBool("K41_cap") and 1 or 0), 0,1,5,2)
	self:HidePanel("K41_cap_Open", self:GetPackedBool("K41_cap"))
	self:HidePanel("K41_cap_Close", not self:GetPackedBool("K41_cap"))
	self:HidePanel("K41", k41_cap_anim < 0.3)

	self:Animate("kran_k53", self:GetPackedBool("K53") and 0 or 1, 0, 1, 16, 0.5)
	self:Animate("kran_k40", self:GetPackedBool("K40") and 0 or 1, 0, 1, 16, 0.5)
	self:Animate("kran_k31", self:GetPackedBool("K31") and 0 or 1, 0, 1, 16, 0.5)
	self:Animate("kran_k41", self:GetPackedBool("K41") and 0 or 1, 0, 1, 16, 0.5)
if not self.DoorStates then self.DoorStates = {} end
if not self.DoorLoopStates then self.DoorLoopStates = {} end
if not self.DoorPrev then self.DoorPrev = {} self.DoorMoveT = {} end

do
	local ecranMat = (self:GetNW2Bool("BNT:Active") == true and self:GetNW2Int("TV:Power",0) > 0) and "models/metrostroi_train/81-775/775_ecran.vtf" or "models/metrostroi_train/81-775/775_ecranoff.vtf"
	for _, k in ipairs(ECRAN_KEYS) do
		local e = self.ClientEnts[k]
		if IsValid(e) and e.EcranMat ~= ecranMat then
			e.EcranMat = ecranMat
			e:SetMaterial(ecranMat)
		end
	end
end

do
	local now = CurTime()
	local blinkOn = now%0.5 > 0.25
	local depart123 = self:GetNW2Bool("Depart123")
	local depaeted = self:GetNW2Bool("BNT:Depaeted")
	local cents = self.ClientEnts
	for _, d in ipairs(DOOR_INFO) do
		local doorstate = self:GetPackedBool(d.side)
		local id,sid = d.id,d.sid
		local state = self:GetPackedRatio(id)
		local aodManual = self:GetNW2Int(d.aod, 0) >= 3

		if self.DoorPrev[id] ~= state then
			if self.DoorPrev[id] ~= nil then self.DoorMoveT[id] = now end
			self.DoorPrev[id] = state
		end
		local moving = state ~= 1 and state ~= 0 and now - (self.DoorMoveT[id] or -1) < 0.3

		if moving ~= self.DoorStates[id] then
			if aodManual then
			elseif moving then
				if doorstate then self:PlayOnce(sid.."op","",1,1) end
			elseif state >= 1 then
				self:PlayOnce(sid.."o","",1,1)
			elseif state <= 0 then
				self:PlayOnce(sid.."c","",1,1)
			end
			self.DoorStates[id] = moving
		end

		if moving and not aodManual then
			self.DoorLoopStates[id] = math.Clamp((self.DoorLoopStates[id] or 0) + 2*self.DeltaTime,0,1)
		else
			self.DoorLoopStates[id] = math.Clamp((self.DoorLoopStates[id] or 0) - 6*self.DeltaTime,0,1)
		end
		self:SetSoundState(d.loop,self.DoorLoopStates[id],0.8+self.DoorLoopStates[id]*0.2)

		local doorEnt,ledEnt = cents[sid],cents[d.led]
		local doorValid,ledValid = IsValid(doorEnt),IsValid(ledEnt)
		local doorMoving = self.DoorStates[id]
		local blink = blinkOn and doorMoving
		local isDoorOpen = state == 1
		local isAlarmActive,lightOn = false,false
		if doorValid or ledValid then
			isAlarmActive = self:GetNW2String(d.announce, "Closed") == "Closing"
			lightOn = self:GetPackedBool(d.light)
		end

		if doorValid then
			local mat
			if not lightOn then
				mat = DOOR_LED_OFF
			elseif isAlarmActive and aodManual then
				mat = blinkOn and DOOR_LED_RED or DOOR_LED_OFF
			elseif isDoorOpen and speed < 2.5 and not isAlarmActive and not depart123 then
				mat = DOOR_LED_GREEN
			elseif not doorMoving and speed < 2.5 then
				mat = DOOR_LED_RED
			elseif not doorMoving and not depaeted and speed < 2.5 then
				mat = DOOR_LED_RED
			elseif blink then
				mat = DOOR_LED_RED
			else
				mat = DOOR_LED_OFF
			end
			SetLedMat(doorEnt,d.slot,mat)
		end

		self:Animate(sid,state,0,1,0.9,false)

		if ledValid then
			local mat
			if not lightOn then
				mat = DOOR_LED_OFF
			elseif isAlarmActive and aodManual then
				mat = blinkOn and DOOR_LED_RED or DOOR_LED_OFF
			elseif isDoorOpen and speed < 2.5 and not isAlarmActive and not depart123 then
				mat = DOOR_LED_GREEN
			elseif not doorMoving and speed < 2.5 and depaeted then
				mat = DOOR_LED_RED
			elseif doorMoving then
				mat = blink and DOOR_LED_RED or DOOR_LED_OFF
			elseif not doorMoving and not depaeted and speed < 2.5 then
				mat = DOOR_LED_RED
			else
				mat = DOOR_LED_WHITE
			end
			SetLedMat(ledEnt,0,mat)
		end
		self:Animate(d.led,state,0,1,0.9,false)
	end
end

	self:SetSoundState("ring_ppz",self:GetPackedBool("BUKPRing",false) and 1.6 or 0,1)
	self:SetSoundState("ring_call",self:GetPackedBool("CallRing",false) and 1 or 0,1)

	local dT = self.DeltaTime

	local parking_brake = math.max(0,-self:GetPackedRatio("ParkingBrakePressure_dPdT",0))
	self.ParkingBrake = self.ParkingBrake+(parking_brake-self.ParkingBrake)*dT*10
	self:SetSoundState("parking_brake",self.ParkingBrake,1.4)

	self.ReleasedPdT = math.Clamp(self.ReleasedPdT + 10*(-self:GetPackedRatio("BrakeCylinderPressure_dPdT",0)-self.ReleasedPdT)*dT*1.5,0,1)
	local release1 = math.Clamp(self.ReleasedPdT,0,1)^2
	self:SetSoundState("release",release1,1)
	self.VentF = math.Clamp((self.VentF or 0) + 10*(self:GetPackedRatio("FrontVentRate",0)-(self.VentF or 0))*dT*1.5,0,1)
	self.VentR = math.Clamp((self.VentR or 0) + 10*(self:GetPackedRatio("RearVentRate",0)-(self.VentR or 0))*dT*1.5,0,1)
	self:SetSoundState("release_f",self.VentF^0.5,1)
	self:SetSoundState("release_r",self.VentR^0.5,1)

	self.FrontLeak = math.Clamp(self.FrontLeak + 10*(-self:GetPackedRatio("FrontLeak")-self.FrontLeak)*dT,0,1)
	self.RearLeak = math.Clamp(self.RearLeak + 10*(-self:GetPackedRatio("RearLeak")-self.RearLeak)*dT,0,1)
	self:SetSoundState("front_isolation",self.FrontLeak,0.9+0.2*self.FrontLeak)
	self:SetSoundState("rear_isolation",self.RearLeak,0.9+0.2*self.RearLeak)
	local ramp = self:GetPackedRatio("Crane_dPdT",0)
	if ramp > 0 then
		self.CraneRamp = self.CraneRamp + ((0.4*ramp)-self.CraneRamp)*dT*2
	else
		self.CraneRamp = self.CraneRamp + ((1.2*ramp)-self.CraneRamp)*dT
	end
	self.CraneRRamp = math.Clamp(self.CraneRRamp + 1.0*((1*ramp)-self.CraneRRamp)*dT*2,0,1)
	self:SetSoundState("crane013_release",self.CraneRRamp^1.5,1.0)
	self:SetSoundState("crane013_brake",math.Clamp(-self.CraneRamp*1.5,0,1)^1.3,1.0)
	self:SetSoundState("crane013_brake2",math.Clamp(-self.CraneRamp*1.5-0.95,0,1.5)^2,1.0)

	local emergencyValveEPK = self:GetPackedRatio("EmergencyValveEPK_dPdT",0)
	self.EmergencyValveEPKRamp = math.Clamp(self.EmergencyValveEPKRamp + 1.0*((0.5*emergencyValveEPK)-self.EmergencyValveEPKRamp)*dT,0,1)
	if self.EmergencyValveEPKRamp < 0.01 then self.EmergencyValveEPKRamp = 0 end
	self:SetSoundState("epk_brake",self.EmergencyValveEPKRamp,1.0)

	local emergencyBrakeValve = self:GetPackedRatio("EmergencyBrakeValve_dPdT", 0)
	self.EmergencyBrakeValveRamp = math.Clamp(self.EmergencyBrakeValveRamp + (emergencyBrakeValve-self.EmergencyBrakeValveRamp)*dT*8,0,1)
	self:SetSoundState("valve_brake",self.EmergencyBrakeValveRamp,0.8+math.min(0.2,self.EmergencyBrakeValveRamp*0.8))
	self:SetSoundState("valve_brake_open",self.EmergencyBrakeValveRamp > 0.0001 and CurTime()-self:GetPackedRatio("EmerValve",1e9) < 0 and 1 or 0,1)

	local emergencyValve = self:GetPackedRatio("EmergencyValve_dPdT", 0)^0.4*1.2
	self.EmergencyValveRamp = math.Clamp(self.EmergencyValveRamp + (emergencyValve-self.EmergencyValveRamp)*dT*16,0,1)
	self:SetSoundState("emer_brake",self.EmergencyValveRamp,1.0)

	local stopkranValve = self:GetPackedRatio("stopkran_dPdT", 0)^0.4*1.2
	self.StopKranValveRamp = math.Clamp(self.StopKranValveRamp + (stopkranValve-self.StopKranValveRamp)*dT*16,0,1)
	self:SetSoundState("stopkran_brake",self.StopKranValveRamp,1.0)

	local state = self:GetPackedBool("RingEnabled")
	self:SetSoundState("ring",state and 1 or 0,1)

	local state = self:GetPackedBool("CompressorWork")
	if self.CompressorVol < 1 and state then
		self.CompressorVol = math.min(1,self.CompressorVol + (self.CompressorVol < 0.2 and 0.1 or 0.2)*dT)
	elseif self.CompressorVol > 0 and not state then
		self.CompressorVol = math.max(0,self.CompressorVol - dT)
	end

	self:SetSoundState("compressor",self.CompressorVol/3,0.8+0.2*self.CompressorVol)

	self.PreviousCompressorState = state

	local state = self:GetPackedBool("WorkBeep")
	self:SetSoundState("work_beep",state and 1 or 0,1)

	self:SetSoundState("rvs1",self:GetPackedBool("RVSButtonsState",false) and 0.5 or 0,1)

	self.TrueAngle = self.TrueAngle or 0
	self.TrueAngle = self.TrueAngle + (self:GetPackedRatio("BARSBlock")*900 - self.TrueAngle)*5.0*(self.DeltaTime or 0)
	if self.ClientEnts and IsValid(self.ClientEnts["!BARSBlock"]) then
		self.ClientEnts["!BARSBlock"]:SetPoseParameter("position",1.0-((self.TrueAngle % 360)/360))
	end

	local rollingi = math.min(1,self.TunnelCoeff+math.Clamp((self.StreetCoeff-0.82)/0.5,0,1))
	local rollings = math.max(self.TunnelCoeff*0.6,self.StreetCoeff)
	local tunstreet = (rollingi+rollings*0.2)
	local speed = self:GetPackedRatio("Speed", 0)
	local rol10 = math.Clamp(speed/25,0,1)*(1-math.Clamp((speed-25)/8,0,1))
	local rol45 = math.Clamp((speed-23)/8,0,1)*(1-math.Clamp((speed-50)/8,0,1))
	local rol60 = math.Clamp((speed-50)/8,0,1)*(1-math.Clamp((speed-65)/5,0,1))
	local rol70 = math.Clamp((speed-65)/5,0,1)
	self:SetSoundState("rolling_10",rollingi*rol10,1)
	self:SetSoundState("rolling_45",rollingi*rol45,1)
	self:SetSoundState("rolling_60",rollingi*rol60,1)
	self:SetSoundState("rolling_70",rollingi*rol70,1)

	local rol10 = math.Clamp(speed/15,0,1)*(1-math.Clamp((speed-18)/35,0,1))
	local rol10p = Lerp((speed-15)/14,0.6,0.78)
	local rol40 = math.Clamp((speed-18)/35,0,1)*(1-math.Clamp((speed-55)/40,0,1))
	local rol40p = Lerp((speed-15)/66,0.6,1.3)
	local rol70 = math.Clamp((speed-55)/20,0,1)
	local rol70p = Lerp((speed-55)/27,0.78,1.15)
	self:SetSoundState("rolling_low"	,rol10*rollings,rol10p)
	self:SetSoundState("rolling_medium2",rol40*rollings,rol40p)
	self:SetSoundState("rolling_high2"  ,rol70*rollings,rol70p)
	local state = self:GetPackedRatio("asynccurrent")
	local absSpeed = math.abs(speed)

	local blend = math.Clamp((absSpeed - 13) / 10, 0, 1)

	local strength = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((absSpeed - 23)/23, 0, 1)) * 0.5 * (1 - blend)
	local strength1 = self:GetPackedRatio("asyncstate") * (1 - math.Clamp((absSpeed - 23)/23, 0, 1)) * 0.5 * blend

	self:SetSoundState("async775", tunstreet * math.Clamp(state/0.26 + 0.2, 0, 1) * strength, 1)
	self:SetSoundState("async775.1", tunstreet * math.Clamp(state/0.26 + 0.2, 0, 1) * strength1, 1)
	self:SetSoundState("chopper_katp", tunstreet * self:GetPackedRatio("chopper"), 1)

end
if not NewMetrostroi then
	ENT.Sprites = {
		[1] = { Vector(509.7,1.95,59), Angle(0,0,0), Color(0,255,4),scale=0.1,nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		[2] = { Vector(510.3,34.15,58.7), Angle(0,0,0), Color(0,255,4),scale=0.1,nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		[3] = { Vector(501.3,52.8,58.2), Angle(0,0,0), Color(0,255,4),scale=0.1,nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	}
	ENT.SpritesEnabled = {}
	for _,v in pairs(ENT.Sprites) do
		ENT.SpritesEnabled[v] = false
	end

	function ENT:SetSpritePower(index,power,brightness)
		local brightness = brightness or 1
		self.SpritesEnabled[index] = power and brightness
	end

	function ENT:DrawSprite(num,param,brightness)
		local pos,ang,col,scale,texture = self:LocalToWorld(Vector(466,52.6,-3)),param[2],param[3],param.scale or 1.0,(param.texture and param.texture ~= "" and param.texture or "sprites/light_glow02")
		if Material(texture):IsError() then
			ErrorNoHalt("Texture of client sprite "..num.." is not valid. \n Texture: "..param.texture.."\n")
			return
		end

		local v = {sprite = texture, color = col}

		local name = v.sprite.."-"
		local params = { ["$basetexture"] = v.sprite }
		local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
		for i, j in pairs( tocheck ) do
			if (param[j]) then
				params["$"..j] = 1
				name = name.."1"
			else
				name = name.."0"
			end
		end

		v.createdSprite = v.sprite
		v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)

		cam.Start3D()
			render.SetMaterial(v.spriteMaterial)
			render.DrawSprite(pos,scale*16,scale*16, col)
		cam.End3D()

		return true
	end

	do
		local attempts = 0
		local function WrapTrainView()
			attempts = attempts + 1
			local tbl = hook.GetTable()
			local hookName
			if tbl["CalcVehicleView"] and tbl["CalcVehicleView"]["Metrostroi_TrainView"] then
				hookName = "CalcVehicleView"
			elseif tbl["CalcView"] and tbl["CalcView"]["Metrostroi_TrainView"] then
				hookName = "CalcView"
			end
			if not hookName then
				if attempts < 20 then timer.Simple(1, WrapTrainView) end
				return
			end

			Metrostroi_TrainView_hook = Metrostroi_TrainView_hook or tbl[hookName]["Metrostroi_TrainView"]
			if not isfunction(Metrostroi_TrainView_hook) then return end

			hook.Add(hookName, "Metrostroi_TrainView", function(...)
				local ret = Metrostroi_TrainView_hook(...)
				if not ret then return end

				local ply = ...
				if not IsValid(ply) then return ret end
				local seat = ply:GetVehicle()
				if not IsValid(seat) then return ret end
				local train = seat:GetNW2Entity("TrainEntity")
				if not IsValid(train) then return ret end

				if train.CurrentCamera and train.CurrentCamera > 0 and train.Cameras and train.Cameras[train.CurrentCamera] then
					return ret
				end

				ret.znear = 10
				return ret
			end)
		end
		timer.Simple(1, WrapTrainView)
	end
	function ENT:DrawSprites()
		for k,v in pairs(self.Sprites) do
			if self.SpritesEnabled[k] then
				self:DrawSprite(k,v,self.SpritesEnabled[k])
			end
		end
	end
end

function ENT:Draw()
	self.BaseClass.Draw(self)
end

local RT_PANELS = {
	{"MFDU","MFDU",399,300,754,566},
	{"MosLogo","MosLogo",512,512,1024,1024},
	{"ROUTER","ROUTER",250,36,500,72},
	{"BNTN","BNTN",250,36,570*4,72*4},
	{"BNTN2","BNTN2",250,36,570*4,72*4},
	{"Speedometer","Speedometer",968,166,1940,330},
	{"MVO","MVO",399,300,754,566},
	{"IGLA","IGLA",256,92.5,512,185},
	{"ASNPScreen","ASNP",256*1.36-15,64,460*1.36,115*1.36},
	{"CIK","CIK",512,256,1000,475},
	{"BNTS1","BNTScr",960,119,1920,238},
	{"BNTS2","BNTScr2",960,119,1920,238},
	{"BNTS3","BNTScr3",960,119,1920,238},
	{"BNTS4","BNTScr4",960,119,1920,238},
	{"BNTS5","BNTScr5",960,119,1920,238},
	{"BNTS6","BNTScr6",960,119,1920,238},
	{"BNTS7","BNTScr7",960,119,1920,238},
	{"BNTS8","BNTScr8",960,119,1920,238},
	{"ScreenOne","SCREEN",1080/2,676/2,1080,676},
	{"ScreenTwo","SCREEN",1080/2,676/2,1080,676},
	{"ScreenThree","SCREEN",1080/2,676/2,1080,676},
	{"ScreenFour","SCREEN",1080/2,676/2,1080,676},
	{"ScreenFive","SCREEN",1080/2,676/2,1080,676},
	{"ScreenSix","SCREEN",1080/2,676/2,1080,676},
}
local rtPanel
local rtMaterial
local function DrawRTPanel()
	surface.SetMaterial(rtMaterial)
	surface.SetDrawColor(255,255,255)
	surface.DrawTexturedRectRotated(rtPanel[3],rtPanel[4],rtPanel[5],rtPanel[6],0)
end

function ENT:DrawPost(special)
	local mat = self.RTMaterial
	rtMaterial = mat
	for i = 1, #RT_PANELS do
		local panel = RT_PANELS[i]
		if self:ShouldDrawPanel(panel[1]) then
			rtPanel = panel
			mat:SetTexture("$basetexture", self[panel[2]])
			self:DrawOnPanel(panel[1],DrawRTPanel)
		end
	end
	if not NewMetrostroi then
		self:DrawSprites()
	end
end

local matDot   = Material("models/metrostroi_train/81-775/bezel_led_dot")
local matPanel = Material("models/metrostroi_train/81-775/bezel_led_panel")
local matLens  = Material("models/metrostroi_train/81-775/bezel_led_lens")
if matLens:IsError() then matLens = Material("models/metrostroi_train/81-775/bezel_led_dot") end

local function BortPower(ent) return ent:GetPackedBool("BortPower") end

local LED_POS = {
	MFDU        = Vector(473.50, 4.45, -3.51),
	Speedometer = Vector(474.00, 34.89, -3.65),
	MVO         = Vector(465.27, 52.40, -4.87),
}
local LED_NAMES = { "MFDU", "Speedometer", "MVO" }

local RED_OFFSET   = 0.55
local DECAL_W      = 1.0
local DECAL_H      = 4.0
local DECAL_CENTER = -0.7
local DECAL_LIFT   = 0.15
local LED_GLOW     = 0.4
local LED_CORE     = 0.11
local GLOW_ALPHA   = 140

local PANEL_ROT = { MFDU = 0, Speedometer = 0, MVO = 0 }

local COL_GREEN = Color(0, 255, 60, GLOW_ALPHA)
local COL_RED   = Color(255, 20, 10, GLOW_ALPHA)
local COL_WHITE = Color(255, 255, 255)

local LENS_OFF        = Color(40, 40, 40)
local COL_GREEN_LENS  = Color(40, 255, 90)
local COL_RED_LENS    = Color(255, 40, 30)
local LENS_GREEN_SIZE = 0.19
local LENS_RED_SIZE   = 0.14
local CORE_GREEN      = Color(0, 255, 60, 255)
local CORE_RED        = Color(255, 20, 10, 255)

local function DrawLens(center, up, right, size, col)
	local h = size * 0.5
	render.SetMaterial(matLens)
	render.DrawQuad(center + up * h - right * h, center + up * h + right * h,
	                center - up * h + right * h, center - up * h - right * h, col)
end

local function DrawBezel(ent, name, eye, power)
	local pos = LED_POS[name]
	local m = ent.ButtonMap and ent.ButtonMap[name]
	if not pos or not m then return end

	local p = ent:LocalToWorld(pos)

	local n = ent:LocalToWorldAngles(m.ang):Up()
	if (eye - p):Dot(n) < 0 then n = -n end

	local up = ent:LocalToWorldAngles(m.ang):Right()
	if up:Dot(ent:GetUp()) < 0 then up = -up end
	up = up - n * up:Dot(n)
	if up:LengthSqr() < 1e-6 then return end
	up:Normalize()
	local right = up:Cross(n)
	local rot = math.rad(PANEL_ROT[name] or 0)
	if rot ~= 0 then
		up = up * math.cos(rot) + right * math.sin(rot)
		right = up:Cross(n)
	end

	local c  = p + up * DECAL_CENTER + n * DECAL_LIFT
	local hw, hh = DECAL_W * 0.5, DECAL_H * 0.5
	render.SetMaterial(matPanel)
	render.DrawQuad(
		c + up * hh - right * hw, c + up * hh + right * hw,
		c - up * hh + right * hw, c - up * hh - right * hw,
		COL_WHITE)

	local greenOn = power
	local redOn   = false

	local gp = p + n * (DECAL_LIFT + 0.03)
	local rp = p + up * RED_OFFSET + n * (DECAL_LIFT + 0.03)

	DrawLens(rp, up, right, LENS_RED_SIZE,   redOn   and COL_RED_LENS   or LENS_OFF)
	DrawLens(gp, up, right, LENS_GREEN_SIZE, greenOn and COL_GREEN_LENS or LENS_OFF)

	if greenOn then
		render.SetMaterial(matDot)
		render.DrawSprite(gp + n * 0.02, LED_GLOW, LED_GLOW, COL_GREEN)
		render.DrawSprite(gp + n * 0.02, LED_CORE, LED_CORE, CORE_GREEN)
	end
	if redOn then
		render.SetMaterial(matDot)
		render.DrawSprite(rp + n * 0.02, LED_GLOW, LED_GLOW, COL_RED)
		render.DrawSprite(rp + n * 0.02, LED_CORE, LED_CORE, CORE_RED)
	end
end

local RADIO_LED_POS  = Vector(461.81, 49.65, -7.08)
local RADIO_LED_LENS = 0.17
local RADIO_LED_GLOW = 0.36
local RADIO_LED_CORE = 0.09

local function DrawRadioLED(ent, eye)
	local p = ent:LocalToWorld(RADIO_LED_POS)
	local n = ent:GetUp()
	if (eye - p):Dot(n) < 0 then return end
	local up = ent:GetForward()
	local right = up:Cross(n)
	local gp = p + n * 0.05
	local on = ent:GetPackedBool("RadioLit")
	DrawLens(gp, up, right, RADIO_LED_LENS, on and COL_GREEN_LENS or LENS_OFF)
	if on then
		render.SetMaterial(matDot)
		render.DrawSprite(gp + n * 0.02, RADIO_LED_GLOW, RADIO_LED_GLOW, COL_GREEN)
		render.DrawSprite(gp + n * 0.02, RADIO_LED_CORE, RADIO_LED_CORE, CORE_GREEN)
	end
end

local bezelTrains, nextBezelScan = {}, 0
hook.Add("PostDrawTranslucentRenderables", "775_BezelLEDs", function(depth, sky)
	if sky or depth then return end
	if RealTime() > nextBezelScan then
		nextBezelScan = RealTime() + 1
		bezelTrains = ents.FindByClass("gmod_subway_81-775")
	end
	local eye = EyePos()
	for _, ent in ipairs(bezelTrains) do
		if IsValid(ent) and ent:GetPos():DistToSqr(eye) < 600*600 then
			local power = BortPower(ent)
			for _, name in ipairs(LED_NAMES) do
				DrawBezel(ent, name, eye, power)
			end
			DrawRadioLED(ent, eye)
		end
	end
end)

local EMD_LIST = {
	{ pos = Vector( 353.90, -53.97, 23.19), ang = Angle(0,  60, 0) },
	{ pos = Vector( 276.59,  53.97, 23.19), ang = Angle(0, 240, 0) },
	{ pos = Vector( 130.88, -53.97, 23.19), ang = Angle(0,  60, 0) },
	{ pos = Vector(  42.81,  53.97, 23.19), ang = Angle(0, 240, 0) },
	{ pos = Vector(-102.90, -53.97, 23.19), ang = Angle(0,  60, 0) },
	{ pos = Vector(-190.98,  53.97, 23.19), ang = Angle(0, 240, 0) },
	{ pos = Vector(-336.69, -53.97, 23.19), ang = Angle(0,  60, 0) },
	{ pos = Vector(-424.76,  53.97, 23.19), ang = Angle(0, 240, 0) },
}
local EMD_HINGE = Vector(2.287, 0.403, 0)
local EMD_SEAL  = Vector(0, 0.314, -2.330)
local EMD_PIVOT = Vector(0, 0.403, 2.76)
local EMD_COVER_OPEN  = 110
local EMD_COVER_MODE  = "swing"
local EMD_SWING_PIVOT = Vector(0.126, 0.403, 2.299)
local EMD_SWING_OPEN  = -105
local EMD_COVER_SLIDE = 6.0
local EMD_COVER_LIFT  = 0.42
local EMD_HANDLE_TURN = 90
local EMD_MDL   = "models/metrostroi_train/81-775/emerdoor_"
local function EmdToTrain(d, off, ang)
	return LocalToWorld(off or vector_origin, ang or angle_zero, d.pos, d.ang)
end

for i, d in ipairs(EMD_LIST) do
	local n = i == 1 and "" or tostring(i)
	ENT.ClientProps["emerdoor_body"..n]   = { model = EMD_MDL.."body.mdl",   pos = d.pos, ang = d.ang, hide = 1.0 }
	ENT.ClientProps["emerdoor_hub"..n]    = { model = EMD_MDL.."hub.mdl",    pos = d.pos, ang = d.ang, hide = 1.0 }
	ENT.ClientProps["emerdoor_label"..n]  = { model = EMD_MDL.."label.mdl",  pos = d.pos, ang = d.ang, hide = 1.0 }
	ENT.ClientProps["emerdoor_handle"..n] = { model = EMD_MDL.."handle.mdl", pos = d.pos, ang = d.ang, hide = 1.0 }
	ENT.ClientProps["emerdoor_seal"..n]   = { model = EMD_MDL.."seal.mdl",   pos = (EmdToTrain(d, EMD_SEAL)),  ang = d.ang, hide = 1.0 }
	ENT.ClientProps["emerdoor_cover"..n]  = { model = EMD_MDL.."cover.mdl",  pos = (EmdToTrain(d, EMD_HINGE)), ang = d.ang, hide = 1.0 }
end

for i = 1, #EMD_LIST do
	local n = i == 1 and "" or tostring(i)
	ENT.ClientProps["emerdoor_plate"..n] = { model = "models/metrostroi_train/81-775/emerdoor_plate"..n..".mdl", pos = ENT.ClientProps["salon"].pos, ang = ENT.ClientProps["salon"].ang, hide = 2 }
end

local function AODBox(u1, v1, u2, v2) return (u1 + 7) / 0.02, (6.5 - v2) / 0.02, (u2 - u1) / 0.02, (v2 - v1) / 0.02 end
for i, d in ipairs(EMD_LIST) do
	local pp, pa = EmdToTrain(d, Vector(7, 0.7, 6.5), Angle(0, 180, 90))
	local function mk(name, btns)
		ENT.ButtonMap[name..i] = { pos = pp, ang = pa, width = 700, height = 650, scale = 0.02, buttons = btns }
	end
	local function b(id, tip, u1, v1, u2, v2) local x, y, w, h = AODBox(u1, v1, u2, v2) return {ID = id..i, x = x, y = y, w = w, h = h, tooltip = tip} end
	mk("AODs", { (function()
		local tip = "АОД (аварийное открывание дверей)"
		local btn = b("AODSeal", tip, -1.6, -3.8, 1.6, -1.0)
		btn.plombed = function(train)
			if train:GetNW2Int("AOD"..i, 0) == 0 then
				return Format("%s\n%s", tip, Metrostroi.GetPhrase("Train.Buttons.Sealed") or "Plombed"), "AODSeal"..i.."Pl", Color(255, 150, 150), true
			end
			return tip, "AODSeal"..i, false
		end
		return btn
	end)() })
	mk("AODc", { b("AODCover", "Открыть крышку АОД", -5.5, -5.0, 5.5, 5.2) })
	mk("AODx", { b("AODHandle", "Ручка АОД (аварийное открытие дверей)", -3.0, -3.8, 3.5, 0.5), b("AODHandle", "Ручка АОД (аварийное открытие дверей)", -0.3, 0.5, 3.5, 3.5), b("AODCover", "Закрыть крышку АОД", -6.5, 0.6, -0.4, 5.6) })
	mk("AODh", { b("AODHandle", "Ручка АОД (аварийное открытие дверей)", -3.0, -3.8, 3.5, 0.5), b("AODHandle", "Ручка АОД (аварийное открытие дверей)", -0.3, 0.5, 3.5, 3.5) })
end

local AOD_DOORX = {315, 86.6, -147.3, -380.9}
for i = 1, #EMD_LIST do
	local k = math.floor((i - 1) / 2) + 1
	local left = i % 2 == 0
	local cx, W, top, H = AOD_DOORX[k], (k == 1 and 82 or 94), 57, 108
	local sc = 0.1
	local pw, ph = W / sc, H / sc
	local side = left and "L" or "R"
	ENT.ButtonMap["AODDoor"..i] = {
		pos = left and Vector(cx - W / 2, 60, top) or Vector(cx + W / 2, -60, top),
		ang = left and Angle(0, 0, 90) or Angle(0, 180, 90),
		width = pw, height = ph, scale = sc,
		buttons = {
			{ID = "AODDoorOpen"..side..k,  x = pw * 0.2, y = 0, w = pw * 0.6, h = ph, tooltip = "Открыть дверь вручную (аварийно)"},
			{ID = "AODDoorClose"..side..k, x = 0,        y = 0, w = pw * 0.2, h = ph, tooltip = "Закрыть дверь вручную"},
			{ID = "AODDoorClose"..side..k, x = pw * 0.8, y = 0, w = pw * 0.2, h = ph, tooltip = "Закрыть дверь вручную"},
		}
	}
end

local function EmdSmooth(x) x = math.Clamp(x, 0, 1) return x * x * (3 - 2 * x) end
local EMD_NAMES = {}
for i = 1, #EMD_LIST do
	local n = i == 1 and "" or tostring(i)
	EMD_NAMES[i] = {
		aod = "AOD"..i,
		cover = "emerdoor_cover"..n,
		handle = "emerdoor_handle"..n,
		seal = "emerdoor_seal"..n,
		panelS = "AODs"..i,
		panelC = "AODc"..i,
		panelX = "AODx"..i,
		panelH = "AODh"..i,
		panelDoor = "AODDoor"..i,
	}
end
function ENT:UpdateEmerDoor()
	self.AODAnim = self.AODAnim or {}
	local dt = FrameTime()
	for i, d in ipairs(EMD_LIST) do
		local names = EMD_NAMES[i]
		local stage = self:GetNW2Int(names.aod, 0)
		local an = self.AODAnim[i]
		if not an then an = {cover = 0, handle = 0} self.AODAnim[i] = an end
		local ct, ht = stage >= 2 and 1 or 0, stage >= 3 and 1 or 0
		an.cover  = an.cover  < ct and math.min(ct, an.cover  + dt / 0.8) or math.max(ct, an.cover  - dt / 0.8)
		local hl = ht
		if an.cover < 0.95 and ht > an.handle then hl = an.handle end
		an.handle = an.handle < hl and math.min(hl, an.handle + dt / 0.5) or math.max(hl, an.handle - dt / 0.5)
		local coverK    = EmdSmooth(an.cover)
		local coverAng  = EMD_COVER_OPEN * coverK
		local handleAng = -EMD_HANDLE_TURN * EmdSmooth(an.handle)
		local cover, handle = self.ClientEnts[names.cover], self.ClientEnts[names.handle]
		if IsValid(cover) and (an.coverEnt ~= cover or an.coverK ~= coverK) then
			an.coverEnt, an.coverK = cover, coverK
			if cover:GetParent() ~= self then cover:SetParent(self) cover:SetRenderBounds(Vector(-80,-80,-80), Vector(80,80,80)) end
			local lp, la = LocalToWorld(EMD_HINGE - EMD_PIVOT, Angle(0, 0, coverAng), EMD_PIVOT + Vector(0, 0, EMD_COVER_LIFT * coverK), angle_zero)
			if EMD_COVER_MODE == "swing" then
				la = Angle(EMD_SWING_OPEN * coverK, 0, 0)
				local off = Vector(EMD_HINGE.x - EMD_SWING_PIVOT.x, EMD_HINGE.y - EMD_SWING_PIVOT.y, EMD_HINGE.z - EMD_SWING_PIVOT.z)
				off:Rotate(la)
				lp = EMD_SWING_PIVOT + off
			elseif EMD_COVER_MODE == "slide" then
				lp, la = EMD_HINGE + Vector(0, 0.54 * math.min(1, coverK * 4), EMD_COVER_SLIDE * coverK), angle_zero
			end
			local p, a = EmdToTrain(d, lp, la)
			cover:SetLocalPos(p)
			cover:SetLocalAngles(a)
		end
		if IsValid(handle) and (an.handleEnt ~= handle or an.handleAng ~= handleAng) then
			an.handleEnt, an.handleAng = handle, handleAng
			if handle:GetParent() ~= self then handle:SetParent(self) end
			local p, a = EmdToTrain(d, vector_origin, Angle(handleAng, 0, 0))
			handle:SetLocalPos(p)
			handle:SetLocalAngles(a)
		end
		self:ShowHide(names.seal, stage < 1)
		self:HidePanel(names.panelS, stage ~= 0)
		self:HidePanel(names.panelC, stage ~= 1)
		self:HidePanel(names.panelX, stage ~= 2)
		self:HidePanel(names.panelH, stage ~= 3)
		self:HidePanel(names.panelDoor, stage < 3)
	end
end

local BUTTON_NAMES_775 = {
	RPU = {
		["KRRkToggle"] = "Крышка Резервного Реверса",
		["AttentionMessageSet"] = "Восприятие Сообщения",
		["AttentionSet"] = "Бдительность",
		["AttentionBrakeSet"] = "Восприятие Торможения",
		["MicrophoneSet"] = "Микрофон",
		["R_Program1Set"] = "Пуск записи",
		["EmerBrakeToggle"] = "Тормоз резервный",
		["EmerBrakeAddSet"] = "Тормоз",
		["EmerBrakeReleaseSet"] = "Отпуск",
		["LinkSCSet"] = "Связь с СЦ",
	},
	CPU = {
		["!HVoltage"] = "Сеть контактная",
		["!DoorsClosed"] = "Двери закрыты",
		["BVDisableSet"] = "Откл. БВ",
		["BVEnableSet"] = "Вкл. БВ",
		["DoorSelectLeftToggle"] = "Выбор левых дверей",
		["DoorSelectRightToggle"] = "Выбор правых дверей",
		["DoorBlockkToggle"] = "Крышка Блокировки дверей",
		["DoorBlockToggle"] = "Блокировка дверей",
		["EmerBlockSDkToggle"] = "Крышка АБСД",
		["EmerBlockSDToggle"] = "Аварийная блокировка СД",
		["HeadlightsSwitch-"] = "Фары тусклее",
		["HeadlightsSwitch+"] = "Фары ярче",
		["RingSet"] = "Передача управления",
		["AntisonSet"] = "Антисон",
		["ProgrevToggle"] = "Прогрев колодок",
		["DoorOpenLeftSet"] = "Открытие левых дверей",
		["DoorOpenRightSet"] = "Открытие правых дверей",
		["DoorCloseToggle"] = "Закрытие дверей",
		["AutodriveToggle"] = "Автоведение (Не работает)",
		["AutodrivekToggle"] = "Крышка Автоведения",
	},
	LPU = {
		["WiperToggle"] = "Стеклоочиститель",
		["WasherSet"] = "Омыватель",
		["EmergencyCompressorSet"] = "Компрессор резервный",
		["EmerX1Set"] = "Ход 1",
		["EmerX2Set"] = "Ход 2",
	},
	PMV = {
		["ChargeAKBToggle"] = "Заряд АКБ",
		["EnableBSSet"] = "Вкл. БС",
		["DisableBSSet"] = "Откл. БС",
		["ALSDecoderToggle"] = "АЛС",
		["_RezervSet"] = "Резерв",
	},
}
for panel, list in pairs(BUTTON_NAMES_775) do
	local map = ENT.ButtonMap[panel]
	if map and map.buttons then
		for _, b in pairs(map.buttons) do
			if istable(b) and b.ID and list[b.ID] and (b.tooltip == nil or b.tooltip == "") then b.tooltip = list[b.ID] end
		end
	end
end

Metrostroi.GenerateClientProps()
