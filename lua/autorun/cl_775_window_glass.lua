if SERVER then
	AddCSLuaFile()
	return
end

local DRAW_DISTANCE = 2500
local GLASS_Y       = 65.0
local MARGIN        = 0.25

local WINDOWS = {
	["gmod_subway_81-775"] = {
		{-300.1, -227.8,  0.5, 28.6}, {-66.2, 6.0,   0.5, 28.6}, {167.5, 239.8,  0.5, 28.6},
		{-298.8, -229.1, 31.2, 44.1}, {168.9, 238.4, 31.2, 44.1},
	},
	["gmod_subway_81-776"] = {
		{-269.8, -197.5, -9.6, 18.5}, {-36.1, 36.1, -9.6, 18.5}, {197.5, 269.8, -9.6, 18.5},
		{-268.4, -198.9, 21.1, 34.0}, {198.9, 268.4, 21.1, 34.0},
	},
}
WINDOWS["gmod_subway_81-777"] = WINDOWS["gmod_subway_81-776"]

local glassMat = Material("models/metrostroi_train/81-775/window_glass")

local GLASS_U, GLASS_V = 0.08, 0.5

local meshes = {}
local function BuildMesh(class)
	local cfg = WINDOWS[class]
	local quads = #cfg * 2
	local m = Mesh(glassMat)
	mesh.Begin(m, MATERIAL_QUADS, quads)
	for side = -1, 1, 2 do
		local y = GLASS_Y * side
		local n = Vector(0, -side, 0)
		for _, w in ipairs(cfg) do
			local x0, x1, z0, z1 = w[1] - MARGIN, w[2] + MARGIN, w[3] - MARGIN, w[4] + MARGIN
			local pts = {
				{x0, z0, GLASS_U, GLASS_V}, {x1, z0, GLASS_U, GLASS_V}, {x1, z1, GLASS_U, GLASS_V}, {x0, z1, GLASS_U, GLASS_V},
			}
			if side == 1 then pts = {pts[4], pts[3], pts[2], pts[1]} end
			for _, p in ipairs(pts) do
				mesh.Position(Vector(p[1], y, p[2]))
				mesh.Normal(n)
				mesh.TexCoord(0, p[3], p[4])
				mesh.Color(255, 255, 255, 255)
				mesh.AdvanceVertex()
			end
		end
	end
	mesh.End()
	meshes[class] = m
	return m
end

local trains, nextScan = {}, 0
local function RescanTrains()
	trains = {}
	for class in pairs(WINDOWS) do
		for _, ent in ipairs(ents.FindByClass(class)) do
			trains[#trains + 1] = ent
		end
	end
end

local matrix = Matrix()

hook.Add("PostDrawTranslucentRenderables", "775_WindowGlass", function(bDrawingDepth, bDrawingSkybox, bIs3DSkybox)
	if bDrawingDepth or bDrawingSkybox or bIs3DSkybox then return end
	if glassMat:IsError() then return end

	if CurTime() > nextScan then
		nextScan = CurTime() + 1
		RescanTrains()
	end
	if #trains == 0 then return end

	local eye = EyePos()
	local maxDistSqr = DRAW_DISTANCE * DRAW_DISTANCE

	render.SetMaterial(glassMat)
	for _, ent in ipairs(trains) do
		if IsValid(ent) and not ent:IsDormant() and ent:GetPos():DistToSqr(eye) < maxDistSqr then
			local class = ent:GetClass()
			if WINDOWS[class] then
				local m = meshes[class] or BuildMesh(class)
				matrix:Identity()
				matrix:SetTranslation(ent:GetPos())
				matrix:SetAngles(ent:GetAngles())
				render.SetLightingOrigin(ent:GetPos())
				cam.PushModelMatrix(matrix)
					m:Draw()
				cam.PopModelMatrix()
			end
		end
	end
end)
