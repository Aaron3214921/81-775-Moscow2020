local CLASSES = { "gmod_subway_81-775", "gmod_subway_81-776", "gmod_subway_81-777" }
local PANELS = {
	{ name = "775_usbpanel",  lit = "models/metrostroi_train/81-775/775_usbpanel_lit",  key = "USBPanelLit" },
	{ name = "775_usbpanelh", lit = "models/metrostroi_train/81-775/775_usbpanelh_lit", key = "USBPanelLit" },
	{ name = "775_emerg",     lit = "models/metrostroi_train/81-775/775_emerg_lit",     key = "EmergPanelLit" },
	{ name = "775_emergv",    lit = "models/metrostroi_train/81-775/775_emergv_lit",    key = "EmergPanelLit" },
}

if SERVER then
	AddCSLuaFile()

	local function Breaker(ent, id)
		local r = ent[id]
		return (not r) or (r.Value or 1) > 0.5
	end

	timer.Create("775_USBPanelLit", 0.2, 0, function()
		for _, class in ipairs(CLASSES) do
			for _, ent in ipairs(ents.FindByClass(class)) do
				if IsValid(ent) and ent.Electric then
					local pow = (ent.Electric.Power or 0) > 0
					ent:SetPackedBool("USBPanelLit", pow and Breaker(ent, "70F6"))
					ent:SetPackedBool("EmergPanelLit", pow and Breaker(ent, "52F1"))
					local act = ent.BNT and ent.BNT.Active
					act = act == true or (tonumber(act) or 0) > 0
					ent:SetPackedBool("LineLEDLit", pow and act)
				end
			end
		end
	end)
else
	local PLATES_775 = {
		{ pos = Vector(353.629, 54.485, 31.390), nrm = Vector(-0.8440, -0.5364, 0) },
		{ pos = Vector(-103.174, 54.485, 31.390), nrm = Vector(-0.8440, -0.5364, 0) },
		{ pos = Vector(43.084, -54.485, 31.390), nrm = Vector(0.8440, 0.5364, 0) },
		{ pos = Vector(-424.485, -54.485, 31.390), nrm = Vector(0.8440, 0.5364, 0) },
	}
	local PLATES_776 = {
		{ pos = Vector(394.211, 54.470, 21.420), nrm = Vector(-0.8440, -0.5364, 0) },
		{ pos = Vector(-73.087, 54.436, 21.420), nrm = Vector(-0.8440, -0.5364, 0) },
		{ pos = Vector(73.086, -54.436, 21.420), nrm = Vector(0.8440, 0.5364, 0) },
		{ pos = Vector(-394.211, -54.470, 21.420), nrm = Vector(0.8440, 0.5364, 0) },
	}
	local PLATES = {
		["gmod_subway_81-775"] = PLATES_775,
		["gmod_subway_81-776"] = PLATES_776,
		["gmod_subway_81-777"] = PLATES_776,
	}
	local NUM_SCALE = 0.05
	local NUM_DIST  = 700
	local NUM_DIST_SQR = NUM_DIST ^ 2
	local ENT_DIST_SQR = (NUM_DIST + 600) ^ 2
	for _, list in pairs(PLATES) do
		for _, pl in ipairs(list) do
			if not pl.lang then
				local ang = pl.nrm:Angle()
				ang:RotateAroundAxis(ang:Up(), 90)
				ang:RotateAroundAxis(ang:Forward(), 90)
				pl.lang = ang
			end
		end
	end

	local DIG_MAT = Material("models/metrostroi_train/81-775/775_enum_digits")
	local DIG_QH, DIG_QW, DIG_ADV = 40, 20, 18
	local function DrawDigits(num)
		local n = #num
		local x0 = -((n - 1) * DIG_ADV + DIG_QW) / 2
		surface.SetMaterial(DIG_MAT)
		surface.SetDrawColor(14, 14, 16, 255)
		for i = 1, n do
			local d = tonumber(string.sub(num, i, i))
			if d then
				surface.DrawTexturedRectUV(x0 + (i - 1) * DIG_ADV, -DIG_QH / 2, DIG_QW, DIG_QH, d * 64 / 1024, 0, (d + 1) * 64 / 1024, 1)
			end
		end
	end

	local function WagonNum(ent)
		local n = ent.GetWagonNumber and ent:GetWagonNumber() or 0
		return (n and n > 0) and tostring(n) or nil
	end

	hook.Add("PostDrawTranslucentRenderables", "775_WagonNumPlates", function(depth, sky)
		if depth or sky then return end
		local eye = EyePos()
		for class, list in pairs(PLATES) do
			for _, ent in ipairs(ents.FindByClass(class)) do
				if IsValid(ent) and ent:GetPos():DistToSqr(eye) < ENT_DIST_SQR then
					local num = WagonNum(ent)
					if num then
						for _, pl in ipairs(list) do
							local wpos = ent:LocalToWorld(pl.pos)
							if wpos:DistToSqr(eye) < NUM_DIST_SQR then
								local ang = ent:LocalToWorldAngles(pl.lang)
								cam.Start3D2D(wpos, ang, NUM_SCALE)
									local oldClip = DisableClipping(true)
									render.OverrideDepthEnable(true, false)
									DrawDigits(num)
									render.OverrideDepthEnable(false, false)
									DisableClipping(oldClip)
								cam.End3D2D()
							end
						end
					end
				end
			end
		end
	end)

	local function Apply(salon, ent)
		if salon._usbPanelSlots == nil then
			salon._usbPanelSlots = {}
			for i, m in ipairs(salon:GetMaterials()) do
				for _, p in ipairs(PANELS) do
					if string.sub(m, -#p.name) == p.name then
						salon._usbPanelSlots[#salon._usbPanelSlots + 1] = { idx = i - 1, lit = p.lit, key = p.key }
					end
				end
			end
		end
		for _, s in ipairs(salon._usbPanelSlots) do
			salon:SetSubMaterial(s.idx, ent:GetPackedBool(s.key) and s.lit or "")
		end
		salon._usbPanelState = (ent:GetPackedBool("USBPanelLit") and 1 or 0) + (ent:GetPackedBool("EmergPanelLit") and 2 or 0)
	end

	local LED_STRIP, LED_GLOW = "775_ledstrip", "775_ledglow"
	local GLOW_K = 0.55
	local ledMats = {}
	local function LineColor(ent)
		local map = Metrostroi and Metrostroi.ANNOUNCER_MAP_775
		local line = ent:GetNW2Int("BNT:Line", 1)
		local c = map and map[line] and map[line].color
		return c
	end
	local function LedMats(c)
		local key = c.r .. "_" .. c.g .. "_" .. c.b
		local m = ledMats[key]
		if m then return m end
		local r, g, b = c.r / 255, c.g / 255, c.b / 255
		local col = string.format("[%.3f %.3f %.3f]", r, g, b)
		local gcol = string.format("[%.3f %.3f %.3f]", r * GLOW_K, g * GLOW_K, b * GLOW_K)
		local sn, gn = "mm775_ledstrip_" .. key, "mm775_ledglow_" .. key
		CreateMaterial(sn, "UnlitGeneric", {
			["$basetexture"] = "models/metrostroi_train/81-775/775_ledstrip_lit", ["$model"] = 1,
			["$color"] = col, ["$color2"] = col,
		})
		CreateMaterial(gn, "UnlitGeneric", {
			["$basetexture"] = "models/metrostroi_train/81-775/775_ledglow", ["$model"] = 1, ["$additive"] = 1,
			["$color"] = gcol, ["$color2"] = gcol,
		})
		m = { strip = "!" .. sn, glow = "!" .. gn }
		ledMats[key] = m
		return m
	end
	local function ApplyLED(salon, ent)
		if salon._ledSlots == nil then
			salon._ledSlots = {}
			for i, m in ipairs(salon:GetMaterials()) do
				if string.sub(m, -#LED_STRIP) == LED_STRIP then salon._ledSlots.strip = i - 1 end
				if string.sub(m, -#LED_GLOW) == LED_GLOW then salon._ledSlots.glow = i - 1 end
			end
		end
		local c = ent:GetPackedBool("LineLEDLit") and LineColor(ent)
		local m = c and LedMats(c)
		local sl = salon._ledSlots
		if sl.strip then salon:SetSubMaterial(sl.strip, m and m.strip or "") end
		if sl.glow then salon:SetSubMaterial(sl.glow, m and m.glow or "") end
		return c and (c.r .. "_" .. c.g .. "_" .. c.b) or "off"
	end

	timer.Create("775_USBPanelLit", 0.2, 0, function()
		for _, class in ipairs(CLASSES) do
			for _, ent in ipairs(ents.FindByClass(class)) do
				local ces = IsValid(ent) and ent.ClientEnts
				local salon = ces and ces["salon"]
				if IsValid(salon) then
					local st = (ent:GetPackedBool("USBPanelLit") and 1 or 0) + (ent:GetPackedBool("EmergPanelLit") and 2 or 0)
					if salon._usbPanelState ~= st then Apply(salon, ent) end
					local c = ent:GetPackedBool("LineLEDLit") and LineColor(ent)
					local lst = c and (c.r .. "_" .. c.g .. "_" .. c.b) or "off"
					if salon._ledState ~= lst then salon._ledState = ApplyLED(salon, ent) end
				end
			end
		end
	end)
end
