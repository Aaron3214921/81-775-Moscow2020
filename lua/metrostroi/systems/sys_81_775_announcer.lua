Metrostroi.DefineSystem("81_775_Announcer")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Outputs()
    return {}
end

function TRAIN_SYSTEM:Inputs()
    return {"Reset"}
end

if TURBOSTROI then return end

if SERVER then

else
    net.Receive("metrostroi_announcer_775", function(len, pl)
        local train = net.ReadEntity()
        if not IsValid(train) or not train.RenderClientEnts then return end
        local snd = net.ReadString()

        if train.AnnouncerPositions then
            for k, v in ipairs(train.AnnouncerPositions) do
                train:PlayOnceFromPos("announcer" .. k, snd, train.OnAnnouncer and train:OnAnnouncer(v[3],k) or v[3] or 1, 1, v[2] or 400, 1e9, v[1])
            end
        else
            train:PlayOnceFromPos("announcer", snd, train.OnAnnouncer and train:OnAnnouncer(1) or 1, 1, 600, 1e9, Vector(0, 0, 0))
        end
    end)

    function TRAIN_SYSTEM:ClientInitialize()
    end

    function TRAIN_SYSTEM:ClientThink()
    end
end
