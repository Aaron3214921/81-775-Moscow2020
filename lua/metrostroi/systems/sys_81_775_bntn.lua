Metrostroi.DefineSystem("81_775_BNTN")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.Bname = "N/A"
    self.Bename = "N/A"
    self.ShowNoBoarding = false
    self.NoBoardingStartTime = nil
    self.LastCIKStation = -1
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
    end
else
    local SCALE = 4

    local monthNames = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
    local dayNames = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"}

    local randomIPs = {
        "192.168.1.101",
        "10.0.0.42",
        "172.16.0.15",
        "192.168.0.77",
        "10.10.10.101",
        "192.168.100.50",
        "172.20.1.33",
        "1.4.8.8",
        "192.168.2.200",
        "172.31.0.99"
    }

    local trainIPs = {}

    function TRAIN_SYSTEM:ClientInitialize()
        self.Tbname = "N/A"
        self.TbEname = "N/A"
        self.ShowNoBoarding = false
        self.NoBoardingStartTime = nil
        self.NoBoardingDelay = 3

        self.InactiveX = nil
        self.InactiveY = nil
        self.InactiveXD = nil
        self.InactiveYD = nil

        local trainID = self.Train:EntIndex()
        if not trainIPs[trainID] then
            local randomIndex = math.random(1, #randomIPs)
            trainIPs[trainID] = randomIPs[randomIndex]
        end
    end

    local function createFont(name,font,size,w)
        surface.CreateFont("Metrostroi_775_"..name, {
            font = font,
            size = size * SCALE,
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

    createFont("MS25","Moscow Sans Regular",25,200)
    createFont("MS40","Moscow Sans Regular",35)
    createFont("MS401","Moscow Sans Regular",35,200)
    createFont("MS200","Moscow Sans Regular",200)
    createFont("MSP60","moscowsans_pictogram_expanded",60)
    createFont("MSP40","moscowsans_pictogram_expanded",38)
    createFont("NoBoarding","Moscow Sans Regular",25, 800)
    createFont("root","Moscow Sans Regular",4)
    createFont("NoBoarding1","Moscow Sans Regular",15, 400)
    createFont("NoBoardingp","moscowsans_pictogram_expanded",50, 400)
    createFont("InfoSmall","Moscow Sans Regular",6, 400)
    createFont("InfoMedium","Moscow Sans Regular",7, 400)
    createFont("Copyright","Moscow Sans Regular",7, 400)

    local function GetTrainIP(train)
        local trainID = train:EntIndex()
        return trainIPs[trainID] or "192.168.1.101"
    end

    local function GetFormattedTime()
        local time = os.time()
        local hours = os.date("%H", time)
        local minutes = os.date("%M", time)
        local seconds = os.date("%S", time)
        return string.format("%s:%s:%s", hours, minutes, seconds)
    end

    local function GetFormattedDate()
        local time = os.time()
        local day = tonumber(os.date("%w", time)) + 1
        local month = tonumber(os.date("%m", time))
        local year = os.date("%Y", time)
        return dayNames[day] or "Thu", monthNames[month] or "Jan", year
    end

    local function GetStationData(self, Train)
        local currentStation = Train:GetNW2Int("BNT:Station", 1)
        local lastStation = Train:GetNW2Int("BNT:Last", 8)
        local path = Train:GetNW2Int("BNT:Path", 1)

        if path == 2 then
            currentStation = lastStation*2-3 - currentStation
        end

        local shouldShowNoBoarding = (currentStation >= (lastStation*2)-2) or
            self.Tbname == "Обкатка" or
            self.Tbname == "Перегонка" or
            self.Tbname == "В депо" or
            currentStation == -1

        local lineData = Metrostroi.ANNOUNCER_MAP_775[Train:GetNW2Int("BNT:Line")]
        if not lineData then return nil, nil, shouldShowNoBoarding end

        local stationIndex = math.floor((currentStation + 3) / 2)
        local stations = lineData.stations

        if not stations or not stations[stationIndex] then
            self.Tbname = "N/A"
            self.TbEname = "N/A"
            return lineData, {}, shouldShowNoBoarding
        end

        local stationData = stations[stationIndex]
        self.Tbname = stationData.name or "N/A"
        self.TbEname = stationData.ename or "N/A"

        local transfers = {}
        if stationData.tr and type(stationData.tr) == "table" then
            for i = 1, 4 do
                if stationData.tr[i] then
                    transfers[i] = {
                        text = stationData.tr[i].p,
                        color = stationData.tr[i].lc
                    }
                end
            end
        end

        return lineData, transfers, shouldShowNoBoarding
    end

    local function UpdateNoBoardingState(self, shouldShowNoBoarding)
        if shouldShowNoBoarding then
            if not self.NoBoardingStartTime then
                self.NoBoardingStartTime = CurTime()
            end

            self.ShowNoBoarding = (CurTime() - self.NoBoardingStartTime >= self.NoBoardingDelay)
        else
            self.NoBoardingStartTime = nil
            self.ShowNoBoarding = false
        end
    end

    local function DrawTransfers(transfers, startX, baseY, maxWidth)
        local availableWidth = maxWidth
        local currentX = startX

        for i = 1, 4 do
            if transfers[i] and availableWidth > 0 then
                surface.SetFont("Metrostroi_775_MSP40")
                local textWidth = surface.GetTextSize(transfers[i].text)

                if textWidth <= availableWidth then
                    draw.SimpleText(transfers[i].text, "Metrostroi_775_MSP40",
                                   currentX, baseY, transfers[i].color or Color(255,255,255), 0, 1)
                    currentX = currentX + textWidth + (3 * SCALE)
                    availableWidth = availableWidth - (textWidth + (3 * SCALE))
                end
            end
        end
    end

    local function DrawInactiveInfo(self, Train)
        local currentTime = GetFormattedTime()
        local dayName, monthName, year = GetFormattedDate()
        local trainIP = GetTrainIP(Train)

        local startX = 2280 - 210
        local startY = 100

        local lineHeight = 42 / 1.5

        draw.SimpleText(currentTime, "Metrostroi_775_InfoMedium", startX, startY,
                       Color(200, 200, 200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        local dateText = dayName .. ", " .. monthName
        draw.SimpleText(dateText, "Metrostroi_775_InfoMedium", startX, startY + lineHeight,
                       Color(200, 200, 200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        local ipText = trainIP
        draw.SimpleText(ipText, "Metrostroi_775_InfoMedium", startX, startY + (lineHeight * 2),
                       Color(200, 200, 200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        local bvitText = "BVIT: New Design"
        draw.SimpleText(bvitText, "Metrostroi_775_InfoMedium", startX, startY + (lineHeight * 3),
                       Color(200, 200, 200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        local buildText = "Build ver:20230418@20230418091"
        draw.SimpleText(buildText, "Metrostroi_775_InfoMedium", startX, startY + (lineHeight * 4),
                       Color(200, 200, 200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        local copyrightText = "© NPP Sarmat Rostov-Na-Dony, " .. year
        draw.SimpleText(copyrightText, "Metrostroi_775_Copyright", startX, startY + (lineHeight * 5),
                       Color(200, 200, 200), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    local function DrawActiveDisplay(panelName, self, Train)
        if not self.Train:ShouldDrawPanel(panelName) then return end

        self.InactiveX = nil
        self.InactiveY = nil

        local lineData, transfers, shouldShowNoBoarding = GetStationData(self, Train)
        UpdateNoBoardingState(self, shouldShowNoBoarding)

        render.PushRenderTarget(self.Train[panelName], 0, 0, 2280, 288)
        render.Clear(0, 0, 0, 0)
        cam.Start2D()
            render.SetScissorRect(0, 0, 2280, 288, true)

            if self.ShowNoBoarding then
                surface.SetDrawColor(255, 50, 50, 255)
                surface.DrawRect(0, 0, 2280, 288)

                draw.SimpleText("y", "Metrostroi_775_NoBoardingp", 160 * SCALE, 36 * SCALE,
                               Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("Нет посадки", "Metrostroi_775_NoBoarding", 210 * SCALE, 25 * SCALE,
                               Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("No boarding", "Metrostroi_775_NoBoarding1", 210 * SCALE, 45 * SCALE,
                               Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            else
                if not lineData then
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.DrawRect(1 * SCALE, 0, 2280, 288)

                    draw.SimpleText("НЕТ ДАННЫХ", 'Metrostroi_775_MS40', 2280/2, 288/2,
                                   Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.DrawRect(1 * SCALE, 0, 2280, 288)

                    draw.SimpleText("СЛЕДУЮЩАЯ", 'Metrostroi_775_MS25', 7 * SCALE, 20 * SCALE, Color(0,0,0), 0, 1)
                    draw.SimpleText("СТАНЦИЯ", 'Metrostroi_775_MS25', 7 * SCALE, 45 * SCALE, Color(0,0,0), 0, 1)
                    draw.SimpleText("|", 'Metrostroi_775_MS25', 155 * SCALE, 19 * SCALE, Color(0,0,0), 0, 1)
                    draw.SimpleText("|", 'Metrostroi_775_MS25', 155 * SCALE, 38 * SCALE, Color(0,0,0), 0, 1)
                    draw.SimpleText("|", 'Metrostroi_775_MS25', 155 * SCALE, 50 * SCALE, Color(0,0,0), 0, 1)

                    local line = lineData.pic or "N/A"
                    local color = lineData.color or Color(0,0,0)
                    draw.SimpleText(line, 'Metrostroi_775_MSP60', 170 * SCALE, 36 * SCALE, color, 0, 1)
                    draw.SimpleText(self.Tbname, 'Metrostroi_775_MS40', 230 * SCALE, 20 * SCALE, Color(0,0,0), 0, 1)
                    draw.SimpleText(self.TbEname, 'Metrostroi_775_MS25', 230 * SCALE, 50 * SCALE, Color(120,120,120), 0, 1)

                    surface.SetFont("Metrostroi_775_MS40")
                    local textWidth = surface.GetTextSize(self.Tbname)
                    local transferStartX = 230 * SCALE + textWidth + (5 * SCALE)
                    local maxTransferWidth = 2280 - transferStartX - (32 * SCALE)

                    DrawTransfers(transfers, transferStartX, 20 * SCALE, maxTransferWidth)
                end
            end

            render.SetScissorRect(0, 0, 0, 0, false)
        cam.End2D()
        render.PopRenderTarget()
    end

    local function DrawInactiveDisplay(panelName, self)
        render.PushRenderTarget(self.Train[panelName], 0, 0, 2280, 288)
        render.Clear(0, 0, 0, 0)
        cam.Start2D()

            render.SetScissorRect(0, 0, 2280, 288, true)

            draw.RoundedBox(0, 0, 0, 2280, 288, Color(20, 20, 20))

            local w, h = draw.SimpleText("БЛОК НЕАКТИВЕН", "Metrostroi_775_MS401",
                                         self.InactiveX or (2280/2),
                                         self.InactiveY or (288/2),
                                         Color(255, 255, 255), 1, 1)
            self.InactiveX = self.InactiveX and (self.InactiveXD and self.InactiveX - (2 * SCALE) or self.InactiveX + (2 * SCALE)) or 2280/2
            self.InactiveY = self.InactiveY and (self.InactiveYD and self.InactiveY - (0.5 * SCALE) or self.InactiveY + (0.5 * SCALE)) or 288/2

            if self.InactiveX - w/2 < 0 then
                self.InactiveXD = false
            end
            if self.InactiveX + w/2 > (520 * SCALE) then
                self.InactiveXD = true
            end
            if self.InactiveY - h/2 < 0 then
                self.InactiveYD = false
            end
            if self.InactiveY + h/2 > 288 then
                self.InactiveYD = true
            end

            DrawInactiveInfo(self, self.Train)

            render.SetScissorRect(0, 0, 0, 0, false)
        cam.End2D()
        render.PopRenderTarget()
    end

    local function DrawOffDisplay(panelName, self)
        if not self.Train:ShouldDrawPanel(panelName) then return end
        self.InactiveX = nil
        self.InactiveY = nil
        render.PushRenderTarget(self.Train[panelName], 0, 0, 2280, 288)
        render.Clear(0, 0, 0, 255)
        render.PopRenderTarget()
    end

    function TRAIN_SYSTEM:ClientThink()
        local Train = self.Train
        local active = Train:GetNW2Bool("BNT:Active") == true
        local powered = Train:GetNW2Int("BNT:Power", 0) > 0

        if not powered then
            DrawOffDisplay("BNTN", self)
            DrawOffDisplay("BNTN2", self)
        elseif active then
            DrawActiveDisplay("BNTN", self, Train)
            DrawActiveDisplay("BNTN2", self, Train)
        elseif Train:ShouldDrawPanel("BNTN") or Train:ShouldDrawPanel("BNTN2") then
            DrawInactiveDisplay("BNTN", self)
            DrawInactiveDisplay("BNTN2", self)
        end
    end
end
