timer.Simple(0, function()
    if not Metrostroi then return end

    Metrostroi.Trains775 = Metrostroi.Trains775 or {}

    timer.Simple(1, function()
        local tbl = scripted_ents.Get("gmod_train_bogey")
        if tbl then
            tbl.Types = tbl.Types or {}
            tbl.Types["775"] = {
                "models/metrostroi_train/81-775/81-775_bogey_base.mdl",
                Vector(0,0.0,-3.8), Angle(0,0,0), "models/metrostroi_train/81-775/81-775_bogey_wheels.mdl",
                Vector(0,-72,-16),Vector(0,72,-16),
                47,
                Vector(-10.8,-61.4,-14.5), Vector(10.8,61.4,-14.5),
            }
            scripted_ents.Register(tbl, "gmod_train_bogey")
        end

        tbl = scripted_ents.Get("gmod_train_couple")
        if tbl then
            tbl.Types = tbl.Types or {}
            tbl.Types["775"] = {
                "models/metrostroi_train/81-775/81-775_coupler_front.mdl", Vector(79.5,0,0), Vector(79.1,1,-4.9), Angle(0,-90,0)
            }
            tbl.Types["776"] = {
                "models/metrostroi_train/81-775/81-775_coupler_int.mdl", Vector(63.7,0,0), Vector(79.1,1,-4.9), Angle(0,-90,0)
            }
            scripted_ents.Register(tbl, "gmod_train_couple")
        end
    end)
end)
