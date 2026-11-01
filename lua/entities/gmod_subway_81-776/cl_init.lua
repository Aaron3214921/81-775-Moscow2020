include("shared.lua")

ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
ENT.ClientPropsInitialized = false

ENT.ClientProps["underwagon"] = {
    model = "models/metrostroi_train/81-775/776_underwagon.mdl",
    pos = Vector(0,0,-84.5),
    ang = Angle(0,0,0),
    hide = 2.0,
}
ENT.ClientProps["crane_tm"] = {
	model = "models/metrostroi_train/81-775/81_760a_crane_nm.mdl",
	pos = Vector(410,0,-74),
	ang = Angle(0,0,0),
	hide = 2,
}
ENT.ClientProps["crane_nm"] = {
	model = "models/metrostroi_train/81-775/81_760a_crane_nm.mdl",
	pos = Vector(416,4,-76),
	ang = Angle(0,0,0),
	hide = 2,
}
ENT.ClientProps["crane_tm2"] = {
	model = "models/metrostroi_train/81-775/81_760a_crane_nm.mdl",
	pos = Vector(-457,0,-74),
	ang = Angle(0,0,0),
	hide = 2,
}
ENT.ClientProps["crane_nm2"] = {
	model = "models/metrostroi_train/81-775/81_760a_crane_nm.mdl",
	pos = Vector(-463,4,-76),
	ang = Angle(0,0,0),
	hide = 2,
}

ENT.ClientProps["ecran1"] = {
	pos = Vector(429.55, -61.2, 13.35),
	ang = Angle(0, 180, 0),
	model = "models/metrostroi_train/81-775/775_ecran.mdl",
	hide = 2,
}
ENT.ClientProps["ecran2"] = {
	pos = Vector(-429.55, 61.2, 13.35),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/775_ecran.mdl",
	hide = 2,
}

ENT.ClientProps["shema"] = {
	pos = Vector(-284.3, 60.3, 14.2),
	ang = Angle(0, 90, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema2"] = {
	pos = Vector(-50.7, 60.3, 14.2),
	ang = Angle(0, 90, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema3"] = {
	pos = Vector(183.3, 60.3, 14.2),
	ang = Angle(0, 90, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema4"] = {
	pos = Vector(430, 60.3, 14.2),
	ang = Angle(0, 90, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema5"] = {
	pos = Vector(284.3, -60.3, 14.2),
	ang = Angle(0, 270, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema6"] = {
	pos = Vector(50.7, -60.3, 14.2),
	ang = Angle(0, 270, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema7"] = {
	pos = Vector(-183.3, -60.3, 14.2),
	ang = Angle(0, 270, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["shema8"] = {
	pos = Vector(-430, -60.3, 14.2),
	ang = Angle(0, 270, 0),
	model = "models/metrostroi_train/81-775/shema.mdl",
	hide = 2,
	scale = 10,
}
ENT.ClientProps["lamps"] = {
	pos = Vector(0, 0, -3.2),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/776_lamps.mdl",
	hide = 2,
}

ENT.ClientProps["salon"] = {
	pos = Vector(0, 0, -3.5),
	ang = Angle(0, 0, 0),
	model = "models/metrostroi_train/81-775/776_salon.mdl",
	hide = 2,
}
ENT.ClientProps["vent"] = {
    model = "models/metrostroi_train/81-775/776_vent.mdl",
    pos = Vector(-0,0,65.9),
    ang = Angle(0,0,0),
    hide = 2.0,
}

ENT.ClientProps["door0x0"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(350.6,-68,-3.8),
    ang = Angle(0,-90,0),
    hide = 2.0,
}
ENT.ClientProps["door1x0"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(117,-68,-3.8),
    ang = Angle(0,-90,0),
    hide = 2.0,
}
ENT.ClientProps["door2x0"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(-116.7,-68,-3.8),
    ang = Angle(0,-90,0),
    hide = 2.0,
}
ENT.ClientProps["door3x0"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(-350.0,-68,-3.8),
    ang = Angle(0,-90,0),
    hide = 2.0,
}
ENT.ClientProps["door0x1"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(-350.6,68,-3.8),
    ang = Angle(0,90,0),
    hide = 2.0,
}
ENT.ClientProps["door1x1"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(-116.7,68,-3.8),
    ang = Angle(0,90,0),
    hide = 2.0,
}
ENT.ClientProps["door2x1"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(117,68,-3.8),
    ang = Angle(0,90,0),
    hide = 2.0,
}
ENT.ClientProps["door3x1"] = {
    model = "models/metrostroi_train/81-775/775_passdoors2_IFE.mdl",
    pos = Vector(350.0,68,-3.8),
    ang = Angle(0,90,0),
    hide = 2.0,
}

ENT.ClientProps["salon_led0x1"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(-356.2,52.55,-10),
	ang = Angle(0,90,0),
}
ENT.ClientProps["salon_led1x1"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(-122.3,52.55,-10),
	ang = Angle(0,90,0),
}
ENT.ClientProps["salon_led2x1"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(111.5,52.55,-10),
	ang = Angle(0,90,0),
}
ENT.ClientProps["salon_led3x1"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(345.3,52.55,-10),
	ang = Angle(0,90,0),
}
ENT.ClientProps["salon_led0x0"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(356,-52.55,-10),
	ang = Angle(0,-90,0),
}
ENT.ClientProps["salon_led1x0"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(122.3,-52.55,-10),
	ang = Angle(0,-90,0),
}
ENT.ClientProps["salon_led2x0"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(-111.5,-52.55,-10),
	ang = Angle(0,-90,0),
}
ENT.ClientProps["salon_led3x0"] = {
	model = "models/metrostroi_train/81-775/salon_led.mdl",
	pos = Vector(-345,-52.55,-10),
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

ENT.ButtonMap["GV"] = {
    pos = Vector(-160,48,-77),
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
    pos = Vector(-162,53,-81),
    ang = Angle(-90,180,0),
	hide=0.5,
}

local SKR = {
	floorZ = -58.20,
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
SalonKran({ box = "floor_box1", cap = "floor_cap1", panel = "K53", capid = "K53_cap", x = 252.00, wide = false, name = "К53",
	valves = { { id = "K53", prop = "kran_k53", dx = 0.8 } } })
SalonKran({ box = "floor_box2", cap = "floor_cap2", panel = "K40", capid = "K40_cap", x = 228.00, wide = true, name = "К40 и К31", bto = { prop = "bto_k31", dx = 0.6 },
	valves = { { id = "K40", prop = "kran_k40", dx = 5.4 }, { id = "K31", prop = "kran_k31", dx = -4.2 } } })
SalonKran({ box = "floor_box3", cap = "floor_cap3", panel = "K41", capid = "K41_cap", x = -234.00, wide = false, name = "К41",
	valves = { { id = "K41", prop = "kran_k41", dx = 0.8 } } })

ENT.ButtonMap["K22_outside"] = {
    pos = Vector(-180,-59.25,-0.25),
    ang = Angle(90,90,180),
    width = 75,
    height = 75,
    scale = 0.0625,
    hideseat=0.2,

    buttons = {
        {ID = "K22Toggle", x=13,  y=0, w = 45, h = 75, tooltip="NO_LANG_К22 Ц1-Ц4", model = {
            model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(90,180,90),
            var="K22",speed=6, max=0.25
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
        {ID = "1:K41Toggle", x=13,  y=0, w = 45, h = 75, tooltip="NO_LANG_К41 ТЦ-3 ТЦ-4", model = {
            model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(-90,180,90),
            var="K41",speed=6, max=0.25
        }},
    }
}

ENT.ButtonMap["K40_outside"] = {
    pos = Vector(159.8+34.8,-63.34,0.6),
    ang = Angle(90,90,180),
    width = 100,
    height = 75,
    scale = 0.0625,
    hideseat=0.2,

    buttons = {
        {ID = "1:K40Toggle", x=13,  y=0, w = 35, h = 75, tooltip="NO_LANG_К40 ТЦ-1 ТЦ-2", model = {
            model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(-90,0,90),
            var="K40",speed=6, max=0.25
        }},
    }
}

ENT.ButtonMap["K31_outside"] = {
    pos = Vector(145.4+34.8,-63.34,-2.1),
    ang = Angle(90,90,180),
    width = 100,
    height = 75,
    scale = 0.0625,
    hideseat=0.2,

    buttons = {
        {ID = "1:K31Toggle", x=13,  y=0, w = 35, h = 75, tooltip="NO_LANG_К31 КТО 01", model = {
            model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang = Angle(-90,0,90),
            var="K31",speed=6, min=0.25 ,max=0,
        }},
    }
}

ENT.ButtonMap["K53_outside"] = {
    pos = Vector(175.8+34.8,-63.34,2.4),
    ang = Angle(90,90,180),
    width = 100,
    height = 75,
    scale = 0.0625,
    hideseat=0.2,

    buttons = {
        {ID = "1:K53Toggle", x=13,  y=0, w = 35, h = 75, tooltip="NO_LANG_К53 СТ", model = {
            model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang=Angle(90,180,90),
            var="K53",speed=6, max=0.25
        }},
    }
}

ENT.ButtonMap["K23_outside"] = {
    pos = Vector(175.8+27,-53.34,1.3),
    ang = Angle(90,90,180),
    width = 100,
    height = 75,
    scale = 0.0625,
    hideseat=0.2,

    buttons = {
        {ID = "K23Toggle", x=13,  y=0, w = 35, h = 75, tooltip="NO_LANG_К23 БУСТ", model = {
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
        {ID = "K18Toggle", x=13,  y=420, w = 35, h = 75, tooltip="NO_LANG_К18 НМ КТО 01", model = {
            model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang=Angle(90,180,90),
            var="K18",speed=6, max=0.25
        }},
        {ID = "K19Toggle", x=13,  y=0, w = 35, h = 75, tooltip="NO_LANG_К19 ТМ КТО 01", model = {
            model = "models/metrostroi_train/81-775/81-775_underwagon_crane2.mdl", ang=Angle(90,180,90),
            var="K19",speed=6, max=0.25
        }},
    }
}

ENT.ButtonMap["K36"] = {
	pos = Vector(434,-65,-69),
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
ENT.ButtonMap["K38"] = {
	pos = Vector(440,-65,-70),
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
	pos = Vector(-432,-65,-68),
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
	pos = Vector(-439,-65,-70),
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

local PVZ_MODELS  = "models/metrostroi_train/81-775/"
local PVZ_ORIGIN  = Vector(-457.700, 49.850, -58.200)
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

ENT.ButtonMap["PVZ"] = {
    pos = Vector(-450.240,58.450,-34.385),
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
local sf_offset_y = 0

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

for i=1, 37 do
    AddSFButtonPVZ(sf_names[i], sf_tooltips[i] or "ну и где блин " .. i)
end


local pos = {
	[1] = Vector(-27.93,40.5,-18.36),
	[2] = Vector(-27.93,-39.5,-18.36),
	[3] = Vector(27.93,39.5,-18.36),
	[4] = Vector(27.93,-40.5,-18.36),
}

ENT.Lights = {
}

ENT.ButtonMap["BNTS1"] = {
	pos = Vector(387.524 ,-42.34,50.1),
	ang = Angle(0,180,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS2"] = {
	pos = Vector(153.8 ,-42.34,50.1),
	ang = Angle(0,180,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS3"] = {
	pos = Vector(-79.9 ,-42.34,50.1),
	ang = Angle(0,180,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS4"] = {
	pos = Vector(-313.55 ,-42.34,50.1),
	ang = Angle(0,180,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS5"] = {
	pos = Vector(313.564 ,42.34,50.1),
	ang = Angle(0,0,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS6"] = {
	pos = Vector(79.9,42.34,50.1),
	ang = Angle(0,0,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS7"] = {
	pos = Vector(-153.7 ,42.34,50.1),
	ang = Angle(0,0,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTS8"] = {
	pos = Vector(-387.4 ,42.34,50.1),
	ang = Angle(0,0,90+27),
	width = 1920,
	height = 238,
	scale = 1/26,
	hide=0.5,
}
ENT.ButtonMap["BNTN"] = {
	pos = Vector(-5.25,-66,28.5),
	ang = Angle(0,0,90),
	width = 2280,
	height = 288,
	scale = 0.0645/2,
	hideseat=0.2,
}
ENT.ButtonMap["BNTN2"] = {
	pos = Vector(5.25,66,28.5),
	ang = Angle(0,180,90),
	width = 2280,
	height = 288,
	scale = 0.0645/2,
	hideseat=0.2,
}
ENT.ButtonMap["ScreenOne"] = {
	pos = Vector(-192.7,60.5,24),
	ang = Angle(0,0,90),
	width = 1080,
	height = 676,
	scale = 0.018,
    hide=0.4,
}
ENT.ButtonMap["ScreenTwo"] = {
	pos = Vector(192.6,-60.5,24),
	ang = Angle(0,180,90),
	width = 1080,
	height = 676,
	scale = 0.018,
    hide=0.4,
}
ENT.ButtonMap["ScreenThree"] = {
	pos = Vector(274.6,60.5,24),
	ang = Angle(0,0,90),
	width = 1080,
	height = 676,
	scale = 0.018,
    hide=0.4,
}
ENT.ButtonMap["ScreenFour"] = {
	pos = Vector(40.8,60.5,24),
	ang = Angle(0,0,90),
	width = 1080,
	height = 676,
	scale = 0.018,
    hide=0.4,
}
ENT.ButtonMap["ScreenFive"] = {
	pos = Vector(-41,-60.5,24),
	ang = Angle(0,180,90),
	width = 1080,
	height = 676,
	scale = 0.018,
    hide=0.4,
}
ENT.ButtonMap["ScreenSix"] = {
	pos = Vector(-274.5,-60.5,24),
	ang = Angle(0,180,90),
	width = 1080,
	height = 676,
	scale = 0.018,
    hide=0.4,
}
ENT.ButtonMap["DLD1"] = {
	pos = Vector(306,51.2,25),
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
	pos = Vector(309,-55.7,25),
	ang = Angle(0,46+90,90),
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

local SALON_PT_PITCH = 65
local SALON_LEVEL = 0.50
local SALON_PT_COLOR = Color(255,206,166)
local SALON_PT_Z = 35
local END_LIGHTS = {
	{key = "SalonPT1", pos = Vector(420,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT2", pos = Vector(300,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT3", pos = Vector(180,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT4", pos = Vector(60,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT5", pos = Vector(-60,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT6", pos = Vector(-180,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT7", pos = Vector(-300,0,SALON_PT_Z), ang = Angle(90,0,0)},
	{key = "SalonPT8", pos = Vector(-420,0,SALON_PT_Z), ang = Angle(90,0,0)},
}
function ENT:RemoveSalonEndLights()
	for _,d in ipairs(END_LIGHTS) do
		local pt = self[d.key]
		if IsValid(pt) then pt:Remove() end
		self[d.key] = nil
	end
end
function ENT:UpdateSalonEndLights(on, power)
	local lp = LocalPlayer()
	if on and IsValid(lp) and lp:GetPos():DistToSqr(self:GetPos()) > 1200*1200 then on = false end
	if not on or power <= 0 then self:RemoveSalonEndLights() return end
	if not self.EndLightsHooked then
		self.EndLightsHooked = true
		self:CallOnRemove("SalonEndLights", function(ent) ent:RemoveSalonEndLights() end)
	end
	for i,d in ipairs(END_LIGHTS) do
		local pt = self[d.key]
		if not IsValid(pt) then
			pt = ProjectedTexture()
			pt:SetTexture("effects/flashlight/soft")
			pt:SetEnableShadows(false)
			pt:SetFOV(160)
			pt:SetNearZ(6)
			pt:SetFarZ(260)
			pt:SetColor(SALON_PT_COLOR)
			self[d.key] = pt
		end
		pt:SetPos(self:LocalToWorld(d.pos))
		pt:SetAngles(self:LocalToWorldAngles(Angle(SALON_PT_PITCH, (i%2==0) and 90 or -90, 0)))
		pt:SetBrightness(0.135*power*(power >= 1 and SALON_LEVEL or 1))
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
local SALON_TINT = {1.0, 0.808, 0.651}
local function SalonSetFace(side, v, k, amb)
	render.SetModelLighting(side, SALON_TINT[1]*v*k + amb.x, SALON_TINT[2]*v*k + amb.y, SALON_TINT[3]*v*k + amb.z)
end
local function SalonRenderOverride(ent, flags)
	local p = ent.SalonLightPow or 0
	if p <= 0 then ent:DrawModel(flags) return end
	local k = salonAmbCV:GetFloat() * p * (p >= 1 and SALON_LEVEL or 1)
	local amb = render.GetLightColor(ent:GetPos()) * 0.15
	local walls = salonWallsCV:GetFloat()
	render.SuppressEngineLighting(true)
	SalonSetFace(BOX_TOP,    salonFloorCV:GetFloat(), k, amb)
	SalonSetFace(BOX_BOTTOM, salonCeilCV:GetFloat(),  k, amb)
	local axial = walls * (1 - math.Clamp(salonContrastCV:GetFloat(), 0, 1))
	local fwd, right = ent:GetForward(), ent:GetRight()
	for _, f in ipairs(SALON_WORLD_SIDES) do
		local lx, ly = f[2]:Dot(fwd), f[2]:Dot(right)
		SalonSetFace(f[1], lx*lx*axial + ly*ly*walls, k, amb)
	end
	ent:DrawModel(flags)
	render.SuppressEngineLighting(false)
end

local BORTNUM = {x = -452.50, z = 5.45, yl = 66.77, yr = -66.80, pitch = 3.42, max = 6}
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

function ENT:UpdateBortNumber()
	if not self.ClientEnts or not self.GetWagonNumber then return end
	local num = tostring(self:GetWagonNumber() or "")
	num = string.gsub(num, "%D", "")
	local n = #num
	for i = 1, BORTNUM.max do
		for _, side in ipairs({"l", "r"}) do
			local ent = self.ClientEnts["bortnum_"..side..i]
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
	self.BNTScr = self:CreateRT("775BNT",1920*2,238*2)
	self.BNTScr2 = self:CreateRT("775BNT2",1920*2,238*2)
	self.BNTScr3 = self:CreateRT("775BNT3",1920*2,238*2)
	self.BNTScr4 = self:CreateRT("775BNT4",1920*2,238*2)
	self.BNTScr5 = self:CreateRT("775BNT5",1920*2,238*2)
	self.BNTScr6 = self:CreateRT("775BNT6",1920*2,238*2)
	self.BNTScr7 = self:CreateRT("775BNT7",1920*2,238*2)
	self.BNTScr8 = self:CreateRT("775BNT8",1920*2,238*2)
	self.BNTN = self:CreateRT("775BNTN",570*4,72*4)
	self.BNTN2 = self:CreateRT("775BNTN2",570*4,72*4)
    self.SCREEN = self:CreateRT("717SCREEN",1080,676)
    self.Tickers = self:CreateRT("760Ticker",2*1024,2*64)
    render.PushRenderTarget(self.Tickers,0,0,1024*2, 2*64)
    render.Clear(0, 0, 0, 0)
    render.PopRenderTarget()
    self.ReleasedPdT = 0
    self.PreviousRingState = false
    self.PreviousCompressorState = false
    self.TISUVol = 0

	self.EmergencyValveRamp = 0
	self.StopKranValveRamp = 0
	self.EmergencyValveEPKRamp = 0
	self.EmergencyBrakeValveRamp = 0

    self.FrontLeak = 0
    self.RearLeak = 0
    self.CompressorVol = 0
    self.ParkingBrake = 0
    self.BrakeCylinder = 0.5
	self.VentVolume = 0
	self.VentVolume2 = 0

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
end
function ENT:UpdateTextures()
    self.Texture = self:GetNW2String("texture")
    self.PassTexture = self:GetNW2String("passtexture")
    self.CabinTexture = self:GetNW2String("cabtexture")
    self.LastStation = self:GetNW2Int("LastStation")
    self.RouteNumber = self:GetNW2Int("RouteNumber")
    self.Number = self:GetWagonNumber()

    self.Scheme = self:GetNW2Int("Scheme",1)
    self.InvertSchemes = self:GetNW2Bool("PassSchemesInvert",false)
    local sarmat,sarmatr = self.ClientEnts.PassSchemes,self.ClientEnts.PassSchemesR
    if IsValid(sarmat) and IsValid(sarmatr) and Metrostroi.Skins["760_schemes"] and Metrostroi.Skins["760_schemes"][self.Scheme] then
        local scheme = Metrostroi.Skins["760_schemes"][self.Scheme]

		sarmat:SetSubMaterial(0,scheme[1])
		sarmatr:SetSubMaterial(0,scheme[1])
    end
	self.keyval = -1

	if not IsValid(self.RearBogey) then
		self.RearBogey = self:GetNW2Entity("RearBogey")
	end
	if not IsValid(self.FrontBogey) then
		self.FrontBogey = self:GetNW2Entity("FrontBogey")
	end
end

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
    bogey.SoundNames["flangea"]      = "subway_trains/bogey/skrip1.wav"
    bogey.SoundNames["flangeb"]      = "subway_trains/bogey/skrip2.wav"
    bogey.SoundNames["flange1"]      = "subway_trains/bogey/flange_9.wav"
    bogey.SoundNames["flange2"]      = "subway_trains/bogey/flange_10.wav"
    bogey.SoundNames["brakea_loop1"]       = "subway_trains/bogey/braking_async1.wav"
    bogey.SoundNames["brakea_loop2"]       = "subway_trains/bogey/braking_async2.wav"
    bogey.SoundNames["brake_loop1"]       = "subway_trains/bogey/brake_rattle3.wav"
    bogey.SoundNames["brake_loop2"]       = "subway_trains/bogey/brake_rattle4.wav"
    bogey.SoundNames["brake_loop3"]       = "subway_trains/bogey/brake_rattle5.wav"
    bogey.SoundNames["brake_loop4"]       = "subway_trains/bogey/brake_rattle6.wav"
    bogey.SoundNames["brake_loopb"]       = "subway_trains/common/junk/junk_background_braking1.wav"
    bogey.SoundNames["brake2_loop1"]       = "subway_trains/bogey/brake_rattle2.wav"
    bogey.SoundNames["brake2_loop2"]       = "subway_trains/bogey/brake_rattle_h.wav"
    bogey.SoundNames["brake_squeal1"]       = "subway_trains/bogey/brake_squeal1.wav"
    bogey.SoundNames["brake_squeal2"]       = "subway_trains/bogey/brake_squeal2.wav"

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

function ENT:UpdateDoor(door_var, door_name, lang, lval)
	local door_val = self:GetPackedBool(door_var)

	local name_old_door = "Old" .. door_name
	local name_timer_door = "Timer" .. door_name

	self[name_old_door] = self[name_old_door] or false

	local door_state = self:Animate(door_name, lval or (door_val and 1 or 0),0,1, 2, 1)

	if self[name_old_door] ~= door_val then
		if door_state < 0.01 and door_val then
			self[name_timer_door] = CurTime()
		end

		self[name_old_door] = door_val
	end

	if IsValid(self.ClientEnts[door_name]) then
		local ent = self.ClientEnts[door_name]

		local handle = 1

		local door_time = self[name_timer_door]

		if door_time ~= nil then
			local anim_time = 0.5
			local anim_angle = 20

			local time = (CurTime()-door_time)

			local ang

			local function easing(t)
				return math.ease.OutSine(t)
			end

			if time <= anim_time/2 then
				local r = time/(anim_time/2)

				ang = Lerp(easing(r), 0, -anim_angle) * lang
			else
				local r = math.Clamp((time/(anim_time/2)) - (anim_time+1), 0, 1)

				ang = Lerp(easing(r), -anim_angle, 0) * lang
			end

			if time > (anim_time + 1) then self[name_timer_door] = nil end

			ent:ManipulateBoneAngles(handle, ang)
		else
			ent:ManipulateBoneAngles(handle, Angle(0, 0, 0))
		end

	end

end

local ECRAN_KEYS = {"ecran1", "ecran2"}
function ENT:Think()
    self.BaseClass.Think(self)
	self:UpdateBortNumber()
    if not self.RenderClientEnts or self.CreatingCSEnts then
        self.Number = 0
        self.RouteNumber = 0
        self.LastStation = 0
        return
    end

	if IsValid(self.FrontBogey) and self.FrontBogey.SoundNames and (self.FrontBogey.SoundNames["ted1_720"] ~= "subway_trains/760/engines/engine_8.wav" or self.FrontBogey.EngineSNDConfig and self.FrontBogey.EngineSNDConfig[1] and self.FrontBogey.EngineSNDConfig[1][5] ~= 0.14) or refresh then
		self:ReInitBogeySounds(self.FrontBogey)
	end
	if IsValid(self.RearBogey) and self.RearBogey.SoundNames and (self.RearBogey.SoundNames["ted1_720"] ~= "subway_trains/760/engines/engine_8.wav" or self.RearBogey.EngineSNDConfig and self.RearBogey.EngineSNDConfig[1] and self.RearBogey.EngineSNDConfig[1][5] ~= 0.14) or refresh then
		self:ReInitBogeySounds(self.RearBogey)
	end

	local pvzOpen = self:GetPackedBool("PVZDoor")
	if self.PVZDoorOld ~= nil and self.PVZDoorOld ~= pvzOpen then
		self:PlayOnce(pvzOpen and "door_pvz_open" or "door_pvz_close", "", 1, 1)
	end
	self.PVZDoorOld = pvzOpen
	local pvzDoor = self:Animate("pvz_door", pvzOpen and 1 or 0, 0, 1, 1.6, 0.5)
	self:HidePanel("PVZDoorClosed", pvzOpen)
	self:HidePanel("PVZDoorOpen", (not pvzOpen) or pvzDoor < 0.97)
	self:HidePanel("PVZ", pvzDoor < 0.34)

    if self.LastStation ~= self:GetNW2Int("LastStation") then self:UpdateTextures() end
    if self.RouteNumber ~= self:GetNW2Int("RouteNumber") then self:UpdateTextures() end
    if self.Number ~= self:GetWagonNumber() then self:UpdateTextures() end
    if self.Texture ~= self:GetNW2String("texture") then self:UpdateTextures() end
    if self.PassTexture ~= self:GetNW2String("passtexture") then self:UpdateTextures() end
    if self.CabinTexture ~= self:GetNW2String("cabtexture") then self:UpdateTextures() end
    if self.Scheme ~= self:GetNW2Int("Scheme",1) then self:UpdateTextures() end
	if self.InvertSchemes ~= self:GetNW2Bool("PassSchemesInvert",false) then self:UpdateTextures() end
	if self:IsNumberError() then self:UpdateTextures() end

	local glow1,glow2 = self:GetNW2Entity("GlowingLights1"),self:GetNW2Entity("GlowingLights2")
	if IsValid(glow1) and IsValid(glow2) then
		if (IsValid(self.ClientEnts["HeadLights2"]) or IsValid(self.ClientEnts["HeadLights1"])) and self.keyval ~= 1 then
			glow1:SetKeyValue("rendercolor","100 120 128")
			glow2:SetKeyValue("rendercolor","100 120 128")
			self.keyval = 1
		elseif not (IsValid(self.ClientEnts["HeadLights2"]) or IsValid(self.ClientEnts["HeadLights1"])) and self.keyval ~= 0 then
			glow1:SetKeyValue("rendercolor","0 0 0")
			glow2:SetKeyValue("rendercolor","0 0 0")
			self.keyval = 0
		end
	end

	local salonOn = self:GetPackedBool("SalonLighting2") or self:GetPackedBool("SalonLighting1")
	local salonPow = salonOn and (self:GetPackedBool("SalonHV") and 1 or 0.3) or 0
	if self:GetPackedBool("SalonEmer") then salonPow = salonPow * 0.3 end
	local lampsEnt = self.ClientEnts["lamps"]
	if IsValid(lampsEnt) and lampsEnt.SalonLampsOff ~= not salonOn then
		lampsEnt.SalonLampsOff = not salonOn
		lampsEnt:SetMaterial(lampsEnt.SalonLampsOff and "models/metrostroi_train/81-775/ledL_off" or "models/metrostroi_train/81-775/ledL")
	end
	local salonEnt = self.ClientEnts["salon"]
	if IsValid(salonEnt) then
		salonEnt.SalonLightPow = salonPow
		if salonEnt.RenderOverride ~= SalonRenderOverride then salonEnt.RenderOverride = SalonRenderOverride end
	end
	for n,e in pairs(self.ClientEnts) do
		if isstring(n) and (string.StartWith(n,"salon_led") or string.StartWith(n,"emerdoor_plate")) and IsValid(e) then
			e.SalonLightPow = salonPow
			if e.RenderOverride ~= SalonRenderOverride then e.RenderOverride = SalonRenderOverride end
		end
	end
	self:UpdateSalonEndLights(salonOn, salonPow)
	self:UpdateEmerDoor()

	self:Animate("EmergencyBrakeValve", self:GetPackedBool("EmergencyBrakeValve") and 1 or 0, 0, 1,  6,false)
	for i=1,4 do
		self:Animate("TR"..i, self:GetPackedBool("TR"..i) and 1 or 0, 0, 1, 8, 0.5)
	end

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
    self:ShowHideSmooth("gv_wrench",    CurTime() < self.ResetTime and 1 or 0.1)

if not self.DoorStates then self.DoorStates = {} end
if not self.DoorLoopStates then self.DoorLoopStates = {} end

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

for i=0,3 do
    for k=0,1 do
        local st = k==1 and "DoorL" or "DoorR"
        local doorstate = self:GetPackedBool(st)
        local id,sid = st..(i+1),"door"..i.."x"..k
        local state = self:GetPackedRatio(id)
        local aodManual = self:GetNW2Int("AOD"..(k==1 and 2*i+2 or 2*i+1), 0) >= 3

        if (state ~= 1 and state ~= 0) ~= self.DoorStates[id] then
            if aodManual then
            elseif doorstate and state < 1 or not doorstate and state > 0 then
				if doorstate then self:PlayOnce(sid.."op","",1,1) end

            else
                if state > 0 then
                    self:PlayOnce(sid.."o","",1,1)
                else
                    self:PlayOnce(sid.."c","",1,1)
                end
            end
            self.DoorStates[id] = (state ~= 1 and state ~= 0)
        end

        if (state ~= 1 and state ~= 0) and not aodManual then
            self.DoorLoopStates[id] = math.Clamp((self.DoorLoopStates[id] or 0) + 2*self.DeltaTime,0,1)
        else
            self.DoorLoopStates[id] = math.Clamp((self.DoorLoopStates[id] or 0) - 6*self.DeltaTime,0,1)
        end
        self:SetSoundState(sid.."r",self.DoorLoopStates[id],0.8+self.DoorLoopStates[id]*0.2)

        local n_l = "door"..i.."x"..k
        local s_l = "salon_led"..i.."x"..k

        if IsValid(self.ClientEnts[n_l]) then
    		local textnumb = 2

    		local blink = CurTime()%0.5 > 0.25 and self.DoorStates[id]
    		local isDoorOpen = state == 1
			local doorIndex = i + 1
            local alarmIndex = k==1 and doorIndex or doorIndex + 4
			local alarmState = self:GetNW2String("DoorAnnounceState" .. alarmIndex, "Closed")
			local isAlarmActive = alarmState == "Closing"

			if not self:GetPackedBool(k==1 and "DoorLightL" or "DoorLightR") then
        		self.ClientEnts[n_l]:SetSubMaterial(textnumb,"models/metrostroi_train/81-775/led.vtf")
			elseif isAlarmActive and self:GetNW2Int("AOD"..(k==1 and 2*i+2 or 2*i+1), 0) >= 3 then
        		self.ClientEnts[n_l]:SetSubMaterial(textnumb, CurTime()%0.5 > 0.25 and "models/metrostroi_train/81-775/led_red.vtf" or "models/metrostroi_train/81-775/led.vtf")
			elseif isDoorOpen and speed < 2.5 and not isAlarmActive and not self:GetNW2Bool("Depart123") then
        		self.ClientEnts[n_l]:SetSubMaterial(textnumb,"models/metrostroi_train/81-775/led_green.vtf")
    		elseif not self.DoorStates[id] and speed < 2.5 then
        		self.ClientEnts[n_l]:SetSubMaterial(textnumb,"models/metrostroi_train/81-775/led_red.vtf")
    		elseif not self.DoorStates[id] and not self:GetNW2Bool("BNT:Depaeted") and speed < 2.5 then
        		self.ClientEnts[n_l]:SetSubMaterial(textnumb,"models/metrostroi_train/81-775/led_red.vtf")
    		elseif blink then
        		self.ClientEnts[n_l]:SetSubMaterial(textnumb,"models/metrostroi_train/81-775/led_red.vtf")
    		else
        		self.ClientEnts[n_l]:SetSubMaterial(textnumb,"models/metrostroi_train/81-775/led.vtf")
    		end
		end
        self:Animate(n_l,state,0,1,0.9,false)

        if IsValid(self.ClientEnts[s_l]) then
    		local salon_textnumb = 0

    		local blink = CurTime()%0.5 > 0.25 and self.DoorStates[id]
    		local isDoorOpen = state == 1
			local doorIndex = i + 1
            local alarmIndex = k==1 and doorIndex or doorIndex + 4
			local alarmState = self:GetNW2String("DoorAnnounceState" .. alarmIndex, "Closed")
			local isAlarmActive = alarmState == "Closing"

			if not self:GetPackedBool(k==1 and "DoorLightL" or "DoorLightR") then
        		self.ClientEnts[s_l]:SetSubMaterial(salon_textnumb,"models/metrostroi_train/81-775/led.vtf")
			elseif isAlarmActive and self:GetNW2Int("AOD"..(k==1 and 2*i+2 or 2*i+1), 0) >= 3 then
        		self.ClientEnts[s_l]:SetSubMaterial(salon_textnumb, CurTime()%0.5 > 0.25 and "models/metrostroi_train/81-775/led_red.vtf" or "models/metrostroi_train/81-775/led.vtf")
			elseif isDoorOpen and speed < 2.5 and not isAlarmActive and not self:GetNW2Bool("Depart123") then
        		self.ClientEnts[s_l]:SetSubMaterial(salon_textnumb,"models/metrostroi_train/81-775/led_green.vtf")
    		elseif not self.DoorStates[id] and speed < 2.5 and self:GetNW2Bool("BNT:Depaeted") then
        		self.ClientEnts[s_l]:SetSubMaterial(salon_textnumb,"models/metrostroi_train/81-775/led_red.vtf")
    		elseif self.DoorStates[id] then
        		if blink then
            		self.ClientEnts[s_l]:SetSubMaterial(salon_textnumb,"models/metrostroi_train/81-775/led_red.vtf")
        		else
            		self.ClientEnts[s_l]:SetSubMaterial(salon_textnumb,"models/metrostroi_train/81-775/led.vtf")
        		end
    		elseif not self.DoorStates[id] and not self:GetNW2Bool("BNT:Depaeted") and speed < 2.5 then
        		self.ClientEnts[s_l]:SetSubMaterial(salon_textnumb,"models/metrostroi_train/81-775/led_red.vtf")
    		else
        		self.ClientEnts[s_l]:SetSubMaterial(salon_textnumb,"models/metrostroi_train/81-775/led_white.vtf")
            end
        end
			self:Animate(s_l,state,0,1,0.9,false)
		end
	end
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
    self.VentB = math.Clamp((self.VentB or 0) + 10*(self:GetPackedRatio("BTOVentRate",0)-(self.VentB or 0))*dT*1.5,0,1)
    self:SetSoundState("release_bto",self.VentB^0.5,1)

    self.FrontLeak = math.Clamp(self.FrontLeak + 10*(-self:GetPackedRatio("FrontLeak")-self.FrontLeak)*dT,0,1)
    self.RearLeak = math.Clamp(self.RearLeak + 10*(-self:GetPackedRatio("RearLeak")-self.RearLeak)*dT,0,1)
    self:SetSoundState("front_isolation",self.FrontLeak,0.9+0.2*self.FrontLeak)
    self:SetSoundState("rear_isolation",self.RearLeak,0.9+0.2*self.RearLeak)

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

    local state = self:GetPackedBool("CompressorWork")
    if state and not self.PreviousCompressorState then self.CompressorStartT = CurTime() end
    local ct = state and (CurTime()-(self.CompressorStartT or 0)) or 0
    self:SetSoundState("compressor_start",(state and ct < 1.76) and 1 or 0,1)
    self:SetSoundState("compressor",(state and ct >= 1.6) and 1 or 0,1)

    self.PreviousCompressorState = state

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
    self:SetSoundState("rolling_low"    ,rol10*rollings,rol10p)
    self:SetSoundState("rolling_medium2",rol40*rollings,rol40p)
    self:SetSoundState("rolling_medium1",0 or rol40*rollings,rol40p)
    self:SetSoundState("rolling_high2"  ,rol70*rollings,rol70p)

    local state = self:GetPackedRatio("asynccurrent")
    local strength = self:GetPackedRatio("asyncstate")*(1-math.Clamp((speed-23)/23,0,1))*0.5
	self:SetSoundState("async1", tunstreet*math.Clamp((state)/0.26+0.2,0,1)*strength, 1)
	self:SetSoundState("chopper_katp", tunstreet*self:GetPackedRatio("chopper"), 1)

    local work = self:GetPackedBool("AnnPlay")
	local head = self:GetPackedBool("AnnPlayHead")
    for k,v in ipairs(self.AnnouncerPositions) do
        if self.Sounds["announcer"..k] and IsValid(self.Sounds["announcer"..k]) then
            self.Sounds["announcer"..k]:SetVolume((work and (k > 1 or k == 1 and head)) and (v[3] or 1)  or 0)
        end
    end

end

function ENT:Draw()
    self.BaseClass.Draw(self)
end

function ENT:DrawPost(special)
	self.RTMaterial:SetTexture("$basetexture",self.BNTScr)
	self:DrawOnPanel("BNTS1",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(960,119,1920,238,0)
	end)
	self.RTMaterial:SetTexture("$basetexture",self.BNTScr2)
	self:DrawOnPanel("BNTS2",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(960,119,1920,238,0)
	end)
	self.RTMaterial:SetTexture("$basetexture",self.BNTScr3)
	self:DrawOnPanel("BNTS3",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(960,119,1920,238,0)
	end)
	self.RTMaterial:SetTexture("$basetexture",self.BNTScr4)
	self:DrawOnPanel("BNTS4",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(960,119,1920,238,0)
	end)
	self.RTMaterial:SetTexture("$basetexture",self.BNTScr5)
	self:DrawOnPanel("BNTS5",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(960,119,1920,238,0)
	end)
	self.RTMaterial:SetTexture("$basetexture",self.BNTScr6)
	self:DrawOnPanel("BNTS6",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(960,119,1920,238,0)
	end)
	self.RTMaterial:SetTexture("$basetexture",self.BNTScr7)
	self:DrawOnPanel("BNTS7",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(960,119,1920,238,0)
	end)
	self.RTMaterial:SetTexture("$basetexture",self.BNTScr8)
	self:DrawOnPanel("BNTS8",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(960,119,1920,238,0)
	end)
	self.RTMaterial:SetTexture("$basetexture", self.BNTN)
	self:DrawOnPanel("BNTN",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(250,36,570*4,72*4,0)
	end)
	self.RTMaterial:SetTexture("$basetexture", self.BNTN2)
	self:DrawOnPanel("BNTN2",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(250,36,570*4,72*4,0)
	end)
    self.RTMaterial:SetTexture("$basetexture",self.SCREEN)
	self:DrawOnPanel("ScreenOne",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(1080/2,676/2,1080,676,0)
	end)
	self:DrawOnPanel("ScreenTwo",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(1080/2,676/2,1080,676,0)
	end)
	self:DrawOnPanel("ScreenThree",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(1080/2,676/2,1080,676,0)
	end)
	self:DrawOnPanel("ScreenFour",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(1080/2,676/2,1080,676,0)
	end)
	self:DrawOnPanel("ScreenFive",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(1080/2,676/2,1080,676,0)
	end)
	self:DrawOnPanel("ScreenSix",function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRectRotated(1080/2,676/2,1080,676,0)
	end)
end
function ENT:OnButtonPressed(button)
    if button == "ShowHelp" then
        RunConsoleCommand("metrostroi_train_manual")
    end
end

local EMD_LIST = {
	{ pos = Vector(394.49, -53.92, 13.22), ang = Angle(0, 60, 0) },
	{ pos = Vector(-394.49, 53.96, 13.22), ang = Angle(0, 240, 0) },
	{ pos = Vector(160.84, -53.92, 13.22), ang = Angle(0, 60, 0) },
	{ pos = Vector(-160.84, 53.96, 13.22), ang = Angle(0, 240, 0) },
	{ pos = Vector(-72.81, -53.92, 13.22), ang = Angle(0, 60, 0) },
	{ pos = Vector(72.81, 53.96, 13.22), ang = Angle(0, 240, 0) },
	{ pos = Vector(-306.46, -53.92, 13.22), ang = Angle(0, 60, 0) },
	{ pos = Vector(306.46, 53.96, 13.22), ang = Angle(0, 240, 0) },
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
	ENT.ClientProps["emerdoor_plate"..n] = { model = "models/metrostroi_train/81-775/emerdoor_p776_"..i..".mdl", pos = ENT.ClientProps["salon"].pos, ang = ENT.ClientProps["salon"].ang, hide = 2 }
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

local AOD_DOORX_R = {350.475, 116.825, -116.825, -350.475}
local AOD_DOORX_L = {-350.475, -116.825, 116.825, 350.475}
for i = 1, #EMD_LIST do
	local k = math.floor((i - 1) / 2) + 1
	local left = i % 2 == 0
	local cx, W, top, H = (left and AOD_DOORX_L or AOD_DOORX_R)[k], 94, 47.6, 108
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
EMD_TARGET = EMD_TARGET or 0
function ENT:UpdateEmerDoor()
	self.AODAnim = self.AODAnim or {}
	local dt = FrameTime()
	for i, d in ipairs(EMD_LIST) do
		local n = i == 1 and "" or tostring(i)
		local stage = self:GetNW2Int("AOD"..i, 0)
		if EMD_TARGET > 0.5 then stage = 3 end
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
		local cover, handle = self.ClientEnts["emerdoor_cover"..n], self.ClientEnts["emerdoor_handle"..n]
		if IsValid(cover) then
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
		if IsValid(handle) then
			if handle:GetParent() ~= self then handle:SetParent(self) end
			local p, a = EmdToTrain(d, vector_origin, Angle(handleAng, 0, 0))
			handle:SetLocalPos(p)
			handle:SetLocalAngles(a)
		end
		self:ShowHide("emerdoor_seal"..n, stage < 1)
		self:HidePanel("AODs"..i, stage ~= 0)
		self:HidePanel("AODc"..i, stage ~= 1)
		self:HidePanel("AODx"..i, stage ~= 2)
		self:HidePanel("AODh"..i, stage ~= 3)
		self:HidePanel("AODDoor"..i, stage < 3)
	end
end

Metrostroi.GenerateClientProps()
