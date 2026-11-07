timer.Simple(0.5,function()
	local ENT = scripted_ents.GetStored("gmod_subway_81-775").t
	if not ENT or not  ENT.Spawner then return end
	local skip_textures = false
	local skip_cab_textures = false
	for k,v in pairs(ENT.Spawner) do
		if istable(v) and v[1] == "Texture" then skip_textures = true end
	end
	if not skip_textures then
		local Textures = {}
		for k,v in pairs(Metrostroi.Skins["train"] or {}) do
			if v.typ == "81-775" then Textures[k] = v.name or k end
		end
		table.insert(ENT.Spawner,{"Texture","Окраска кузова","List", Textures})
	end
	if SERVER then
		local function TrainSpawnerUpdate(self)
		ENT.TrainSpawnerUpdate = TrainSpawnerUpdate
		ENT = scripted_ents.GetStored("gmod_subway_81-776").t
		if ENT then ENT.TrainSpawnerUpdate = TrainSpawnerUpdate end
		ENT = scripted_ents.GetStored("gmod_subway_81-777").t
		if ENT then ENT.TrainSpawnerUpdate = TrainSpawnerUpdate end
		end
	else
		local function UpdateTextures(self)
			self.Texture = self:GetNW2String("texture")

			if not IsValid(self.RearBogey) then
				self.RearBogey = self:GetNW2Entity("RearBogey")		
			end
			if not IsValid(self.FrontBogey) then
				self.FrontBogey = self:GetNW2Entity("FrontBogey")
			end
		end
		ENT.UpdateTextures = UpdateTextures
		ENT = scripted_ents.GetStored("gmod_subway_81-776").t
		if ENT then ENT.UpdateTextures = UpdateTextures end
		ENT = scripted_ents.GetStored("gmod_subway_81-777").t
		if ENT then ENT.UpdateTextures = UpdateTextures end
	end
end)