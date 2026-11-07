Metrostroi.DefineSystem("775_TVSCREEN")
TRAIN_SYSTEM.DontAccelerateSimulation = true
if TURBOSTROI then return end
function TRAIN_SYSTEM:Initialize()
    self.State = 0
    self.TickerCurr = "Депо"
    self.TickerCurrNum = 900
    self.TickerNext = 0
    self.Advert = 1
    self.AdvertSymbol = 0
    self.CurrentAdvert = "Android 5.1.1 / Moscow Metro 3.5.5 / 1440x900 / big tablet"
    self.Active = false
    self.Winter = 0
    self.Degree = 0
    self.Texture = "models/virus/vir_screen_inited_2"

    local map = game.GetMap()
    if file.Exists("screensconfigs/"..map..".lua", "LUA") then
        self.ScreenConfig = util.JSONToTable(file.Read("screensconfigs/"..map..".lua","LUA"))
    end

    self.Textures = {}
    local textureFiles = file.Find("materials/ms_screen/screens/advert/*.vmt", "THIRDPARTY")
    for _, file in ipairs(textureFiles) do
        table.insert(self.Textures, "ms_screen/screens/advert/"..string.TrimRight(file, ".vmt"))
    end

    self.LastRenderTime = 0
    self.RenderInterval = 0.05
    self.LastDataUpdate = 0
    self.DataUpdateInterval = 0.1
    self.CachedData = {}
    self.CachedAdvertChars = {}
    self.LastAdvert = ""
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:Outputs()
    return {}
end

function TRAIN_SYSTEM:TriggerInput(name,value)

end

if TURBOSTROI then return end

if CLIENT then

    local function createFont(name,font,size)
        surface.CreateFont(name, {
            font = font,
            size = size,
            weight = 500,
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

    createFont("Screen","Moscow Sans Regular",80,1000,0,0,false)
    createFont("Screen1","Moscow Sans Regular",45,1000,0,0,false)
    createFont("Screen2","Moscow Sans Regular",45,1000,0,0,false)
    createFont("Screen_small","Moscow Sans Regular",34,1000,0,0,false)
    createFont("Pictogram","MoscowSansPictogram",60,400,0,0,false)
    createFont("Pictogram2","MoscowSansPictogram",80,400,0,0,false)
    createFont("Pictogram3","MoscowSansPictogram",228,400,0,0,false)
    createFont("Screen_low","Moscow Sans Regular",50,1000,0,0,false)
    createFont("Screen_low2","Moscow Sans Regular",32,1000,0,0,false)
    createFont("Screen_low","Ubuntu Mono",55,1000,0,0,false)
end

function TRAIN_SYSTEM:SyncSCREEN()
    local tbl = Metrostroi.ASNPSetup[self.Train:GetNW2Int("Announcer",1)][self.Train:GetNW2Int("ASNP:Line",1)]
    self.Train:CANWrite("SCREEN",self.Train:GetWagonNumber(),"Screens",nil,"Degree",self.Degree)
    self.Train:CANWrite("SCREEN",self.Train:GetWagonNumber(),"Screens",nil,"Screen",self.Texture)
    if self.Train:ReadCell(49160) == 0 then
        self.Train:CANWrite("SCREEN",self.Train:GetWagonNumber(),"Screens",nil,"Next",true)
        for i=1,#tbl do
            if self.Train:ReadCell(49161) == tbl[i][1] then
                self.Train:CANWrite("SCREEN",self.Train:GetWagonNumber(),"Screens",nil,"Curr",tbl[i][2])
            end
        end
        self.Train:CANWrite("SCREEN",self.Train:GetWagonNumber(),"Screens",nil,"CurrNum",self.Train:ReadCell(49161))
    else
        self.Train:CANWrite("SCREEN",self.Train:GetWagonNumber(),"Screens",nil,"Next",false)
        for i=1,#tbl do
            if self.Train:ReadCell(49160) == tbl[i][1] then
                self.Train:CANWrite("SCREEN",self.Train:GetWagonNumber(),"Screens",nil,"Curr",tbl[i][2])
            end
        end
        self.Train:CANWrite("SCREEN",self.Train:GetWagonNumber(),"Screens",nil,"CurrNum",self.Train:ReadCell(49160))
    end
end

function TRAIN_SYSTEM:CANReceive(source,sourceid,target,targetid,textdata,numdata)
    if textdata == "Curr" then
        self.TickerCurr = numdata
    end
    if textdata == "CurrNum" then
        self.TickerCurrNum = numdata
    end
    if textdata == "Next" then
        self.TickerNext = numdata
    end
    if textdata == "Degree" then
        self.Degree = numdata
    end
    if textdata == "Screen" then
        self.Texture = numdata
    end
end

function TRAIN_SYSTEM:Think()
    local Train = self.Train

    local PowerNum = Train.Electric.Power*Train["45F7"].Value
    local Power = PowerNum > 0
    Train:SetNW2Int("TV:Power",PowerNum)

    Train.Panel.PassSchemeControl = true and 1 or 0

    if Power and self.State == 0 then
        self.State = 1
        self.StartTimer = CurTime()
    end

    if not Power and self.State ~= 0 then
        self.State = 0
        if self.Active then
            timer.Remove("WeatherTimer_"..Train:EntIndex())
            timer.Remove("ScreenChanger_"..Train:EntIndex())
            self.Active = false
        end
    end

    if self.State == 1 and CurTime()-self.StartTimer > 20 then
        self.State = 2
    end

    if self.State == 2 and self.Train:ReadCell(49161) ~= 0 then
        self.State = 3
    end

    if self.State == 3 and self.Train:ReadCell(49161) == 0 then
        self.State = 2
        timer.Remove("WeatherTimer_"..Train:EntIndex())
        timer.Remove("ScreenChanger_"..Train:EntIndex())
        self.Active = false
    end

    if self.State == 3 and not self.Active then

        timer.Simple(5,function()
            if not IsValid(self.Train) then return end
            http.Fetch(
            "http://api.openweathermap.org/data/2.5/forecast?id=524901&appid=98ba4333281c6d0711ca78d2d0481c3d&cnt=1&units=metric",
                function(body)
                    if not IsValid(self.Train) then return end
                    local Tab = util.JSONToTable(body)
                    local gradus = math.ceil(Tab["list"][1]["main"]["temp"])
                    self.Degree = gradus
                end,
                function()
                end
            )
        end)

        timer.Create("WeatherTimer_"..Train:EntIndex(), 450, 0, function()
            if not IsValid(self.Train) then
                timer.Remove("WeatherTimer_"..Train:EntIndex())
                return
            end
            http.Fetch(
            "http://api.openweathermap.org/data/2.5/forecast?id=524901&appid=98ba4333281c6d0711ca78d2d0481c3d&cnt=1&units=metric",
                function(body)
                    if not IsValid(self.Train) then return end
                    local Tab = util.JSONToTable(body)
                    local gradus = math.ceil(Tab["list"][1]["main"]["temp"])
                    self.Degree = gradus
                end,
                function()
                end
            )
        end)

        self.Texture = table.Random(self.Textures)

        timer.Create("ScreenChanger_"..Train:EntIndex(), 17, 0, function()
            if not IsValid(self.Train) then
                timer.Remove("ScreenChanger_"..Train:EntIndex())
                return
            end
            local next_ad = math.random(1, #self.Textures)
            local prev = table.KeyFromValue(self.Textures, self.Texture) or 1
            if next_ad == prev then
                next_ad = next_ad + 1
            end
            if next_ad > #self.Textures then
                next_ad = next_ad - 3
            end
            self.Texture = self.Textures[next_ad]
        end)

        self.Active = true
    end

    local map = game.GetMap()
    local tbl = {}

    if self.ScreenConfig then
        tbl = self.ScreenConfig["tickers"] or {
          "Будьте взаимно вежливы! Уступайте места инвалидам, пожилым людям, пассажирам с детьми и беременным женщинам!",
          "О подозрительных предметах сообщайте машинисту",
          "В вагонах поезда держитесь за поручни!",
          "Будьте внимательны и осторожны при выходе из вагонов!"
        }
    else
        tbl = {
          "Будьте взаимно вежливы! Уступайте места инвалидам, пожилым людям, пассажирам с детьми и беременным женщинам!",
          "О подозрительных предметах сообщайте машинисту",
          "В вагонах поезда держитесь за поручни!",
          "Будьте внимательны и осторожны при выходе из вагонов!"
        }
    end

    Train:SetNW2String("SCREEN:Texture",self.Texture)

    self.AdvertSymbol = self.AdvertSymbol - 50*Train.DeltaTime
    if self.AdvertSymbol < -utf8.len(self.CurrentAdvert)*10-80 then
        self.AdvertSymbol = 40*(7+math.random(0,3))
        local rnd
        repeat rnd = math.random(1,#tbl) until rnd ~= self.Advert
        self.Advert = rnd
        self.CurrentAdvert = tbl[self.Advert]
    end

    if self.Train:ReadCell(49161) ~= 0 then
        self:SyncSCREEN()

        if self.ScreenConfig then
            local stationConfig = self.ScreenConfig[self.TickerCurrNum]
            if stationConfig then
                Train:SetNW2String("SCREEN:Buses",stationConfig["autobuses"] or "")
                Train:SetNW2String("SCREEN:Trams",stationConfig["trams"] or "")
                Train:SetNW2String("SCREEN:Transition",stationConfig["transition"] or "")
            else
                Train:SetNW2String("SCREEN:Buses","")
                Train:SetNW2String("SCREEN:Trams","")
                Train:SetNW2String("SCREEN:Transition","")
            end
        else
            Train:SetNW2String("SCREEN:Buses","")
            Train:SetNW2String("SCREEN:Trams","")
            Train:SetNW2String("SCREEN:Transition","")
        end
    end

    Train:SetNW2String("SCREEN:Texture",self.Texture)
    Train:SetNW2Int("SCREEN:State",self.State)
    Train:SetNW2String("SCREEN:Station",self.TickerCurr)
    Train:SetNW2Bool("SCREEN:Next",self.TickerNext)
    Train:SetNW2Int("TickerState",math.ceil(self.AdvertSymbol))
    Train:SetNW2String("SCREEN:Advert",self.CurrentAdvert)
    Train:SetNW2Int("SCREEN:Degree",self.Degree)
    Train:SetNW2Int("SCREEN:weather_icon",self.weather_icon)
end

function TRAIN_SYSTEM:UpdateCachedData()
    self.CachedData = {
        power = self.Train:GetNW2Int("TV:Power", 0),
        state = self.Train:GetNW2Int("SCREEN:State", 0),
        texture = self.Train:GetNW2String("SCREEN:Texture", ""),
        station = self.Train:GetNW2String("SCREEN:Station", ""),
        nextStation = self.Train:GetNW2Bool("SCREEN:Next", false),
        degree = self.Train:GetNW2Int("SCREEN:Degree", 0),
        advert = self.Train:GetNW2String("SCREEN:Advert", ""),
        tickerState = self.Train:GetNW2Int("TickerState", 0),
        buses = self.Train:GetNW2String("SCREEN:Buses", ""),
        trams = self.Train:GetNW2String("SCREEN:Trams", ""),
        transition = self.Train:GetNW2String("SCREEN:Transition", "")
    }

    if self.LastAdvert ~= self.CachedData.advert then
        self.CachedAdvertChars = {utf8.codepoint(self.CachedData.advert, 1, -1)}
        self.LastAdvert = self.CachedData.advert
    end
end

local function PrintText(x, textChars)
    for i = 0, #textChars - 1 do
        local draw_char = utf8.char(textChars[i + 1])
        local xpos = i * 25 + x * 3.005

        local shirik = {'М','Ц','Д','Ю','Ж'}
        for _, char in ipairs(shirik) do
            if draw_char == char then
                xpos = i * 35 + x * 3.005
                break
            end
        end

        if -26.5 < xpos and xpos < 26.5 * 41 then
            draw.SimpleText(draw_char, "Screen_low", xpos + 320, 865, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

local optimizationCV2
function TRAIN_SYSTEM:ClientThink()

        optimizationCV2 = optimizationCV2 or GetConVar("775_optimization2")
        local optimizationFlag2 = optimizationCV2:GetInt()
    if optimizationFlag2 == 1 then
        return
    end

    self.LastRenderTime = self.LastRenderTime or 1
    self.RenderInterval = self.RenderInterval or 0.05
    self.LastDataUpdate = self.LastDataUpdate or 0
    self.DataUpdateInterval = self.DataUpdateInterval or 0.1
    self.CachedData = self.CachedData or {}
    self.CachedAdvertChars = self.CachedAdvertChars or {}
    self.LastAdvert = self.LastAdvert or ""

    local currentTime = CurTime()

    if currentTime - self.LastRenderTime < self.RenderInterval then return end
    self.LastRenderTime = currentTime

    if currentTime - self.LastDataUpdate > self.DataUpdateInterval then
        self:UpdateCachedData()
        self.LastDataUpdate = currentTime
    end

    render.PushRenderTarget(self.Train.SCREEN,0,0,1433, 895)
    render.Clear(0, 0, 0, 0)
    cam.Start2D()
        self:DrawScreen(self.Train)
    cam.End2D()
    render.PopRenderTarget()
end

local function drawScreenFrame(tex,x,y,w,h,alpha)
        x,y,w,h = x or 0,y or 0,w or 1433,h or 895
        surface.SetTexture(tex)
        surface.SetDrawColor(255,255,255,alpha)
        surface.DrawTexturedRect(x,y,w,h)
end

local function drawBackground()
    surface.SetDrawColor(255,255,255)
    surface.DrawRect(0,0,1433,895)
    surface.SetDrawColor(0,0,0)
    surface.DrawLine(280,0,280,895)
    surface.DrawLine(0,100,1433,100)
    surface.DrawLine(280,845,1433,845)
end

function TRAIN_SYSTEM:DrawScreen(Train)
    local data = self.CachedData
    local sost = data.state

    local def = surface.GetTextureID("ms_screem/screens/vir_screen2")

    if sost == 0 then
        return
    end

    if sost == 1 then
        surface.SetDrawColor(20,20,20)
        surface.DrawRect(0,0,1433,895)
        surface.SetDrawColor(255,255,255)
        surface.SetTexture(surface.GetTextureID("ms_screen/screens/loading"))
        surface.DrawTexturedRectRotated(716.5,447.5,1433,895,0)
        draw.SimpleText("Московский","Screen1", 716, 560, Color(176,41,37), TEXT_ALIGN_CENTER )
        draw.SimpleText("Метрополитен","Screen1", 716, 600, Color(176,41,37), TEXT_ALIGN_CENTER )
        self.Changed = false
    end

    if sost == 2 then
        surface.SetDrawColor(20,20,20)
        surface.DrawRect(0,0,1433,895)
        surface.SetDrawColor(255,255,255)
        surface.SetTexture(surface.GetTextureID("ms_screen/screens/loading"))
        surface.DrawTexturedRectRotated(716.5,447.5,1433,895,0)
        draw.SimpleText("Московский","Screen1", 716, 560, Color(176,41,37), TEXT_ALIGN_CENTER )
        draw.SimpleText("Метрополитен","Screen1", 716, 600, Color(176,41,37), TEXT_ALIGN_CENTER )
        draw.SimpleText("Отсутствует соединение с SK SCREEN","Screen_small", 716, 640, Color(176,41,37), TEXT_ALIGN_CENTER )
        if not self.Changed then
            surface.SetDrawColor(20,20,20)
            surface.DrawRect(0,0,1433,895)
            surface.SetDrawColor(255,255,255)
            surface.SetTexture(surface.GetTextureID("ms_screen/screens/loading"))
            surface.DrawTexturedRectRotated(716.5,447.5,1433,895,0)
            self.Changed = true
        end
    end

    if sost == 3 then
        drawBackground()
        drawScreenFrame(surface.GetTextureID(data.texture),280,100,1153,745)

        draw.SimpleText(data.degree.."°С ☀", "Screen", 274, 10, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)

        if data.nextStation then
            draw.SimpleText( "След. станция ", "Screen", 300, 10, color_black )
            draw.SimpleText( data.station, "Screen", 760, 10, color_black )
        else
            draw.SimpleText( "Станция ", "Screen", 300, 10, color_black )
            draw.SimpleText( data.station, "Screen", 580, 10, color_black )
        end

        PrintText(data.tickerState, self.CachedAdvertChars)

        if data.buses == "" or data.buses == "vokzal" then
        else
            draw.SimpleText( "g", "Pictogram", 70, 145, Color(0,162,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "Автобус", "Screen_small", 240, 140, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( data.buses, "Screen1", 140, 190, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        if data.buses == "vokzal" then
            draw.SimpleText( "g", "Pictogram", 70, 145, Color(0,162,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "Автобус", "Screen_small", 240, 140, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end

        if data.trams == "" then
        else
            draw.SimpleText( "e", "Pictogram2", 70, 275, Color(0,162,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "Трамвай", "Screen_small", 240, 280, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( data.trams, "Screen1", 135, 330, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        if data.trams == "" and data.buses == "" and data.transition == "" then
            surface.SetDrawColor(230,0,0)
            surface.DrawRect(0,100,280,800)
            draw.SimpleText( "i", "Pictogram3", 210, 420, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "Московский", "Screen_low2", 225, 520, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "Метрополитен", "Screen_low2", 240, 550, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end

        if data.transition == "crimson" then
            draw.SimpleText( "●", "Pictogram2", 70, 370, Color(254,0,136), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "Пересадка", "Screen_small", 240, 377, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "На малиновую", "Screen_small", 240, 415, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "линию", "Screen_small", 185, 440, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end

        if data.transition == "loop" then
            draw.SimpleText( "●", "Pictogram2", 70, 370, Color(0,39,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "Пересадка", "Screen_small", 240, 377, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "На кольцевую", "Screen_small", 240, 415, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "линию", "Screen_small", 185, 440, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end

        if data.transition == "orange" then
            draw.SimpleText( "●", "Pictogram2", 70, 370, Color(254,106,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "Пересадка", "Screen_small", 240, 377, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "На оранжевую", "Screen_small", 240, 415, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "линию", "Screen_small", 185, 440, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end

        if data.transition == "seliger-rossosh" then
            draw.SimpleText( "1", "Pictogram", 87, 420, Color(159,28,192), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "2", "Pictogram", 57, 420, Color(255,193,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            draw.SimpleText( "Пересадка", "Screen_small", 252, 417, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end
    end
end
