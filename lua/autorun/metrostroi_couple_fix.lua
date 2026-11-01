if SERVER then
	timer.Simple(0,function()
		if not Metrostroi then return end
		timer.Simple(1,function()
			local couple = scripted_ents.Get("gmod_train_couple")
			if couple then
				function couple:Couple(ent)
					local strain = self:GetNW2Entity("TrainEntity")
					local etrain = ent:GetNW2Entity("TrainEntity")
					if IsValid(strain) then
						self:SetAngles(strain:LocalToWorldAngles(self.SpawnAng))
					end
					if IsValid(etrain) then
						ent:SetAngles(etrain:LocalToWorldAngles(ent.SpawnAng))
					end
					local MCouplingPointOffset = (ent.CouplingPointOffset+self.CouplingPointOffset)/2
					ent:SetPos(self:LocalToWorld(MCouplingPointOffset*Vector(2,1,1)))
					ent:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
					self:SetPos(ent:LocalToWorld(MCouplingPointOffset*Vector(2,-1,-1)))
					self:SetAngles(ent:LocalToWorldAngles(Angle(0,180,0)))
					if IsValid(constraint.Weld(
						self,
						ent,
						0,
						0,
						0
					)) then
						sound.Play("subway_trains/bogey/couple.mp3",(self:GetPos()+ent:GetPos())/2,70,100,1)
						self:OnCouple(ent)
						ent:OnCouple(self)
					end
				end
				scripted_ents.Register(couple,"gmod_train_couple")
			end
		end)
	end)
end
