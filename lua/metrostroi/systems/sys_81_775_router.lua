Metrostroi.DefineSystem("81_775_ROUTER")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()

end

function TRAIN_SYSTEM:Outputs()

end

function TRAIN_SYSTEM:Inputs()
	return {}
end
if TURBOSTROI then return end

function TRAIN_SYSTEM:TriggerInput(name,value)
end

if SERVER then
    function TRAIN_SYSTEM:Think(dT)
		local Train = self.Train
		local Power = Train.SF19.Value*Train.Electric.Power
		Train:SetNW2Int("Roter:Power",Power)
    end
    concommand.Add("775_Last", function(ply, cmd, args)
        if not args[1] then
            print('Использование: 775_Last <название станции>, Для сброса введите 775_Last ""')
            return
        end
        local stationName = table.concat(args, " ")
        for _, ent in pairs(ents.FindByClass("gmod_subway_81-775")) do
            if IsValid(ent) then
                ent:SetNW2String("CIK:LastStationText", stationName)
            end
        end
    end)
else
	function TRAIN_SYSTEM:ClientInitialize()
	end

	local function createFont(name,font,size,w)
        surface.CreateFont("Metrostroi_775_"..name, {
            font = font,
            size = size,
            weight = w,
            blursize = false,
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
            scanlines = false,
        })
    end

    createFont("Router_numbers","Moscow Sans Regular",70,800,0,0,false)
	createFont("Router_station","Moscow Sans Regular",54,400,0,0,false)

	function TRAIN_SYSTEM:ClientThink()
		local Train = self.Train
		if not Train:ShouldDrawPanel("ROUTER") then return end
		if not Train.ROUTER then return end

		render.PushRenderTarget(Train.ROUTER,0,0,500,72)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
			render.SetScissorRect(0, 0, 500, 72, true)
			surface.SetDrawColor(30,30,30,255)
			surface.DrawRect(0,0,500,72)
			local ok, err = pcall(self.RouteScrean, self, Train)
			if not ok and (not self.LastErrTime or CurTime() - self.LastErrTime > 5) then
				self.LastErrTime = CurTime()
				ErrorNoHalt("[81-775 ROUTER] "..tostring(err).."\n")
			end
			render.SetScissorRect(0, 0, 0, 0, false)
		cam.End2D()
		render.PopRenderTarget()
	end

	function TRAIN_SYSTEM:RouteScrean(Train)
		if Train:GetNW2Int("Roter:Power",0) <= 0 then return end
		if not Train:GetNW2Bool("CIK:Power") then return end

		local line  = Train:GetNW2Int("CIK:Line",1)
		local ls    = Train:GetNW2Int("CIK:LastStation",1)
		local path  = Train:GetNW2Int("CIK:Path",1)
		local route = Train:GetNW2Int("CIK:Route",0)
		local customStation = Train:GetNW2String("CIK:LastStationText", "")

		local Station
		if customStation ~= "" then
			Station = "| "..customStation
		else
			local map = Metrostroi.ANNOUNCER_MAP_775
			local lineData = map and map[line]
			local stations = lineData and lineData.stations
			if not stations then return end
			local idx = path == 2 and (#stations - ls + 1) or ls
			local st = stations[idx]
			if not st then return end
			Station = "| "..st.name
		end

		draw.SimpleText(Format("%03d",route),'Metrostroi_775_Router_numbers',5,36,Color(255,255,255), 0, 1)
		draw.SimpleText(Station,'Metrostroi_775_Router_station',114,36,Color(255,255,255), 0, 1)
	end
end
