Metrostroi775Kp = Metrostroi775Kp or {}
local KP = Metrostroi775Kp

KP.Points = {
	Vector( 41,  54, -18),
	Vector( 41, -54, -18),
	Vector(-41,  54, -18),
	Vector(-41, -54, -18),
}

local mins = Vector(-4.4, -4.4, -0.8)
local maxs = Vector(4.4, 4.4, 0.8)
local vector_up = Vector(0, 0, 1)
local bogeys = {"FrontBogey", "RearBogey"}
local classes = {
	["gmod_subway_81-775"] = true,
	["gmod_subway_81-776"] = true,
	["gmod_subway_81-777"] = true,
}

local CHECK_DT   = 0.1
local TRACE_LEN  = 10
local MIN_POINTS = 2
KP.HullTime = 1.5
KP.EncTime  = 3.0

local function CheckWheels(wag, wheels)
	if (wag.Speed or 0) < 1.4 and (wheels.Kp775Off or 0) == 0 then
		wheels.Kp775Off = 0
		return
	end
	local missed = 0
	for _, point in ipairs(KP.Points) do
		local start = wheels:LocalToWorld(point)
		local tr = util.TraceHull({
			start = start,
			endpos = start + (-wheels:GetUp() * TRACE_LEN),
			mins = mins,
			maxs = maxs,
			filter = wheels,
		})
		if not tr.Hit then missed = missed + 1 end
	end
	if missed >= MIN_POINTS then
		wheels.Kp775Off = math.min(99, (wheels.Kp775Off or 0) + CHECK_DT)
	else
		wheels.Kp775Off = 0
	end
end

local function CheckHull(wag)
	local ang = wag:GetAngles()
	ang.p = 0
	ang:Normalize()
	wag.Hull775Result = (1 - vector_up:Dot(ang:Up())) / 0.007
end

timer.Create("Metrostroi775KpCheck", CHECK_DT, 0, function()
	if not Metrostroi or not Metrostroi.SpawnedTrains then return end
	for wag in pairs(Metrostroi.SpawnedTrains) do
		if IsValid(wag) and classes[wag:GetClass()] then
			for _, k in ipairs(bogeys) do
				local bogey = wag[k]
				local wheels = IsValid(bogey) and bogey.Wheels
				if IsValid(wheels) then
					CheckWheels(wag, wheels)
					wheels.Kp775ConstrFail = not IsValid(constraint.Find(bogey, wheels, "Weld", 0, 0))
				end
			end
			CheckHull(wag)
		end
	end
end)

function KP.WheelsOk(wheels)
	if not IsValid(wheels) or wheels.Kp775ConstrFail then return false end
	return (wheels.Kp775Off or 0) < KP.HullTime
end

function KP.EncoderOk(wheels)
	if not IsValid(wheels) then return true end
	if (wheels.Kp775Off or 0) >= KP.EncTime then return false end
	return not wheels:GetNW2Bool("Disabled", false) and not wheels.Kp775ConstrFail
end
