timer.Simple(0, function()
    local ENT = scripted_ents.GetStored("gmod_train_couple")
    if not ENT or not ENT.t then return end
    ENT = ENT.t

    local original = ZMS_COUPLE_THINK_ORIGINAL or ENT.Think
    ZMS_COUPLE_THINK_ORIGINAL = ZMS_COUPLE_THINK_ORIGINAL or original
    function ENT:Think()
        local train = self:GetNW2Entity("TrainEntity")
        if IsValid(train) and train.OnCoupled and not IsValid(self.CoupledEnt) then
            local phy = self:GetPhysicsObject()
            if IsValid(phy) then
                phy:SetAngleVelocityInstantaneous(-phy:GetAngleVelocity())
            end
            self:NextThink(CurTime())
            return true
        end
        return original(self)
    end

    MsgC(Color(166, 30, 220), "Couple Fix Applied\n")
end)
