Metrostroi.DefineSystem("81_775_MosLogo")
TRAIN_SYSTEM.DontAccelerateSimulation = true
if TURBOSTROI then return end
function TRAIN_SYSTEM:Initialize()
    self.SlonA = 0
    self.AnimationSpeed = 0.5
    self.LogoType = self.Train.MosLogoType or 2
    self.Train:SetNW2Int("MosLogo_Type", self.LogoType)
end

function TRAIN_SYSTEM:Outputs()
    return { "LogoType" }
end

function TRAIN_SYSTEM:Inputs()
    return { "LogoType" }
end

function TRAIN_SYSTEM:TriggerInput(name,value)
    if name == "LogoType" then
        self.LogoType = math.Clamp(math.floor(value), 2, 3)
        self.Train:SetNW2Int("MosLogo_Type", self.LogoType)
    end
end

if SERVER then
    function TRAIN_SYSTEM:Think(dT)
        local Train = self.Train
        self.SlonA = (self.SlonA or 0) + self.AnimationSpeed * dT * 60

        if self.SlonA >= 129 then
            self.SlonA = 0
        end

        if self.Train.MosLogoType and self.Train.MosLogoType ~= self.LogoType then
            self.LogoType = self.Train.MosLogoType
            self.Train:SetNW2Int("MosLogo_Type", self.LogoType)
        end

        Train:SetNW2Float("MosLogo_SlonA", self.SlonA)
        Train:SetNW2Int("MosLogo_Frame", math.Round(self.SlonA))
        Train:SetNW2Int("MosLogo_Type", self.LogoType)
    end
else
    local function createFont(name,font,size,w)
        surface.CreateFont("Metrostroi_775_"..name, {
            font = font,
            size = size,
            weight = w or 400,
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
    createFont("MosLogo","moscowsans_pictogram_expanded",240,400)

    function TRAIN_SYSTEM:ClientInitialize()
        self.PreloadedTextures = {}
        self.PreloadedTextures2 = {}

        for i = 1, 130 do
            local frameName = string.format("%04d", i)
            local texID = surface.GetTextureID("gif/" .. frameName)
            if texID and texID ~= -1 then
                self.PreloadedTextures[i] = texID
            else
                self.PreloadedTextures[i] = surface.GetTextureID("vgui/white")
            end
        end

        for i = 1, 130 do
            local frameName = string.format("%04d", i)
            local texID = surface.GetTextureID("gif2/" .. frameName)
            if texID and texID ~= -1 then
                self.PreloadedTextures2[i] = texID
            else
                self.PreloadedTextures2[i] = surface.GetTextureID("vgui/white")
            end
        end
    end

    function TRAIN_SYSTEM:ClientThink(dT)
        if not self.Train:ShouldDrawPanel("MosLogo") then return end

        local currentFrame = self.Train:GetNW2Int("MosLogo_Frame", 1)
        currentFrame = math.Clamp(currentFrame, 1, 130)

        if not self.Train.MosLogo then
            self.Train.MosLogo = GetRenderTarget("Metrostroi_775_MosLogo_" .. self.Train:EntIndex(), 256, 256)
            if not self.Train.MosLogo then return end
        end

        render.PushRenderTarget(self.Train.MosLogo, 0, 0, 256, 256)
        render.Clear(0, 0, 0, 0)

        cam.Start2D()
            if self.Train:GetNW2Int("N:MFDUState",0) == 0 or self.Train:GetNW2Int("N:MFDUState",0) == -1 then
                surface.SetDrawColor(0, 0, 0, 255)
            else
                surface.SetDrawColor(20, 15, 20, 255)
            end
            surface.DrawRect(0, 0, 256, 256)

            self:MosLogo(self.Train, currentFrame)
        cam.End2D()

        render.PopRenderTarget()
    end

    function TRAIN_SYSTEM:MosLogo(Train, currentFrame)
        local logoType = Train:GetNW2Int("MosLogo_Type", 1)
        local power = Train:GetNW2Int("Roter:Power", 1)

        if power > 0 then
            if logoType == 1 then
                local frameTexture = self.PreloadedTextures[currentFrame]

                if frameTexture then
                    surface.SetTexture(frameTexture)
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.DrawTexturedRect(2, 2, 252, 252)
                else
                    draw.SimpleText('i', "Metrostroi_775_MosLogo", 128, 105, Color(255, 255, 255, 255), 1, 1)
                end
            elseif logoType == 2 then
                surface.SetDrawColor(0, 0, 0, 255)
                surface.DrawRect(0, 0, 256, 256)
                draw.SimpleText("i", "Metrostroi_775_MosLogo", 128, 132, Color(255, 255, 255, 255), 1, 1)
            elseif logoType == 3 then
                surface.SetDrawColor(0, 0, 0, 255)
                surface.DrawRect(0, 0, 256, 256)
                draw.SimpleText("X", "Metrostroi_775_MosLogo", 128, 132, Color(255, 255, 255, 255), 1, 1)
            elseif logoType == 4 then
                local frameTexture = self.PreloadedTextures2[currentFrame]

                if frameTexture then
                    surface.SetTexture(frameTexture)
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.DrawTexturedRect(2, 2, 252, 252)
                else
                    draw.SimpleText('X', "Metrostroi_775_MosLogo", 128, 105, Color(255, 255, 255, 255), 1, 1)
                end
            end
        else
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawRect(0, 0, 256, 256)
        end
    end
end
