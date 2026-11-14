CreateClientConVar( "775_optimization", 0, true)
CreateClientConVar( "775_optimization2",0, true)
CreateClientConVar( "775_optimization3",0, true)
local function AddBox(panel,cmd,str)
    panel:AddControl("CheckBox",{Label=str, Command=cmd})
end
local function ClientPanel(panel)
    panel:ClearControls()
    panel:SetPadding(0)
    panel:SetSpacing(0)
    panel:Dock( FILL )
    AddBox(panel,"775_optimization",Metrostroi.GetPhrase("Не обновлять БНТ"))
    AddBox(panel,"775_optimization2",Metrostroi.GetPhrase("Не обновлять тв-экраны"))
    AddBox(panel,"775_optimization3",Metrostroi.GetPhrase("Отключить проекторы света салона"))
end

hook.Add("PopulateToolMenu", "775_Optimization", function()
    spawnmenu.AddToolMenuOption("Utilities", "Metrostroi", "metrostroi_775_panel", Metrostroi.GetPhrase("81-775 Оптимизация"), "", "", ClientPanel)
end)
