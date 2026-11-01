Metrostroi.DefineSystem("81_775_BUD")
local function BRK(Train,id)
	local r = Train[id]
	return (not r) or (r.Value or 1) > 0.5
end
local DOOR_BRK = {[1]="80F14",[2]="80F13",[3]="80F12",[4]="80F14",[5]="80F14",[6]="80F12",[7]="80F13",[8]="80F12"}
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.CloseDelay = {}
    self.DoorsDelayMax = 0.5
    self.IsClosing = {}
    self.CloseCommandActive = false

    self.DoorAnnounceState = {}

    self.AutoReverse = {}
    self.ReverseDelay = {}
    self.ReverseFailed = {}
    self.ClosedOnce = {}
    self.ForeignObject = {}
    for idx = 1, 8 do self.ReverseFailed[idx] = 0 end

    if not TURBOSTROI then
        self.LeftDoorState = {0, 0, 0, 0}
        self.RightDoorState = {0, 0, 0, 0}
        self.LeftDoorDir = {0, 0, 0, 0}
        self.RightDoorDir = {0, 0, 0, 0}
        self.LeftDoorSpeed = {0, 0, 0, 0}
        self.RightDoorSpeed = {0, 0, 0, 0}
        self.LeftDoorStuck = {false, false, false, false}
        self.RightDoorStuck = {false, false, false, false}
        self.LeftDoorStucked = {false, false, false, false}
        self.RightDoorStucked = {false, false, false, false}
        self.DoorSpeedMain = math.Rand(1.9, 2.1)

        for i = 1, 4 do
            self.LeftDoorSpeed[i] = math.Rand(self.DoorSpeedMain - 0.3, self.DoorSpeedMain + 0.3)
            self.RightDoorSpeed[i] = math.Rand(self.DoorSpeedMain - 0.3, self.DoorSpeedMain + 0.3)
            self.CloseDelay[i] = nil
            self.CloseDelay[i+4] = nil
            self.IsClosing[i] = false
            self.IsClosing[i+4] = false
            self.DoorAnnounceState[i] = "Closed"
            self.DoorAnnounceState[i+4] = "Closed"
        end
    end

    for i = 1, 4 do
        self.Train:LoadSystem("DLDoor"..i, "Relay", "Switch", {bass = true})
        self.Train:LoadSystem("DRDoor"..i, "Relay", "Switch", {bass = true})
        self.Train:LoadSystem("DLDoor"..i..'k', "Relay", "Switch", {bass = true, normally_closed = true})
        self.Train:LoadSystem("DRDoor"..i..'k', "Relay", "Switch", {bass = true, normally_closed = true})
        for _,side in ipairs({"L","R"}) do
            self.Train:LoadSystem("DoorAODOpen"..side..i, "Relay", "Switch", {bass = true})
            self.Train:LoadSystem("DoorAODClose"..side..i, "Relay", "Switch", {bass = true})
        end
    end
    self.ManualDir = {L = {0,0,0,0}, R = {0,0,0,0}}
end

function TRAIN_SYSTEM:Inputs()
    return {}
end

function TRAIN_SYSTEM:Outputs()
    return {}
end

if TURBOSTROI then return end

local function MakeDoorTriggers(self)
    local Train = self.Train
    if not SERVER or not IsValid(Train) or not Train.TrainEntities then return end
    local is775 = Train:GetClass() == "gmod_subway_81-775"
    for k = 0, 1 do
        for j = 1, 4 do
            local idx = (k == 1 and 0 or 4) + j
            local x = (is775 and 345 or 341) + k - 230 * (j - 1)
            local pos = Vector(x, -66 * (1 - 2 * k), -1)
            local trigger = ents.Create("base_entity")
            trigger:SetPos(Train:LocalToWorld(pos))
            trigger:SetAngles(Train:GetAngles())
            trigger:SetParent(Train)
            trigger:Spawn()
            trigger:SetModel("models/hunter/blocks/cube05x05x05.mdl")
            trigger:SetNoDraw(true)
            trigger:SetNotSolid(true)
            trigger:SetCollisionBounds(Vector(-8, -14, -30), Vector(8, 14, 30))
            trigger:SetSolid(SOLID_BBOX)
            trigger:SetTrigger(true)
            trigger:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
            trigger:AddEFlags(EFL_SERVER_ONLY)
            trigger.count = 0
            trigger.entMap = {}
            trigger.StartTouch = function(this, ent)
                if IsValid(self.Train) and IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) and not this.entMap[ent] then
                    this.count = this.count + 1
                    this.entMap[ent] = true
                    self.ForeignObject[idx] = true
                end
            end
            trigger.EndTouch = function(this, ent)
                if this.entMap[ent] then
                    this.count = this.count - 1
                    this.entMap[ent] = nil
                    self.ForeignObject[idx] = this.count > 0
                end
            end
            table.insert(Train.TrainEntities, trigger)
        end
    end
end

local function DoorDrive(self, sd, i, idx, dT, commandClose)
    local Train = self.Train
    self.AutoReverse = self.AutoReverse or {}
    self.ReverseDelay = self.ReverseDelay or {}
    self.ClosedOnce = self.ClosedOnce or {}
    self.ForeignObject = self.ForeignObject or {}
    if not self.ReverseFailed then
        self.ReverseFailed = {}
        for n = 1, 8 do self.ReverseFailed[n] = 0 end
    end
    local L = sd == "L"
    local state = L and self.LeftDoorState or self.RightDoorState
    local dir = L and self.LeftDoorDir or self.RightDoorDir
    local speed = (L and self.LeftDoorSpeed or self.RightDoorSpeed)[i]
    local stuckT = L and self.LeftDoorStuck or self.RightDoorStuck
    local cmdOpen
    if L then cmdOpen = self.DoorLeft and true or false else cmdOpen = self.DoorRight and true or false end
    local now = CurTime()
    local mode = Train:GetNW2Int("DoorReverseMode", 1)
    local AR, RD, RF = self.AutoReverse, self.ReverseDelay, self.ReverseFailed
    local OBST = 0.3

    if commandClose and state[i] > 0 and not self.CloseDelay[idx] then
        self.CloseDelay[idx] = now + 2
        self.IsClosing[idx] = true
        self.DoorAnnounceState[idx] = "Closing"
    end

    if cmdOpen and AR[idx] then
        AR[idx] = nil RD[idx] = nil RF[idx] = 0
    end

    if state[i] <= 0 then
        if not self.ClosedOnce[idx] then
            self.ClosedOnce[idx] = true
            if not AR[idx] and math.random() < 0.004 then AR[idx] = 1 end
        end
    else
        self.ClosedOnce[idx] = false
    end

    local closing = not cmdOpen and self.CloseDelay[idx] ~= nil and now >= self.CloseDelay[idx]
    local obstacle = (stuckT[i] or self.ForeignObject[idx]) and true or false
    local blocked = obstacle and closing and state[i] >= 0.15 and state[i] <= OBST + 0.005
    local canReverse = not AR[idx] or (mode == 3 and AR[idx] == 2 and now - (RD[idx] or 0) > 1)
    if canReverse and blocked then
        AR[idx] = 1 + math.min(0.85, state[i] + 0.4)
        RD[idx] = now + 0.4
        dir[i] = 0
    end

    local open = cmdOpen
    local reverseOpening = AR[idx] and AR[idx] >= 1 and AR[idx] < 2
    if reverseOpening then
        if state[i] >= math.max(AR[idx] - 1, 0.35) then
            AR[idx] = 2
            RF[idx] = RF[idx] + 1
            RD[idx] = now + 0.4
            dir[i] = 0
            reverseOpening = false
            if stuckT[i] and math.random() < 0.9 then stuckT[i] = false end
        else
            open = true
        end
    end
    if AR[idx] and AR[idx] >= 2 and (mode ~= 2 or RF[idx] < 2) then
        if not commandClose then AR[idx] = 3 end
        if commandClose and AR[idx] == 3 then
            if mode == 3 then
                AR[idx] = 2 RF[idx] = 0 RD[idx] = now
            else
                AR[idx] = 1 + math.Clamp(state[i] + 0.2, 0.35, 0.85)
            end
        end
    end
    if mode == 3 and AR[idx] and AR[idx] >= 2 and RF[idx] >= 3 then
        if AR[idx] == 2 then AR[idx] = 1 else RD[idx] = now + 1 end
    end
    if AR[idx] then self.CloseDelay[idx] = 0 end

    if RD[idx] and now < RD[idx] then
        dir[i] = 0
    else
        local prev = state[i]
        local shouldClose = not open and self.CloseDelay[idx] ~= nil and now >= self.CloseDelay[idx]
        if shouldClose or (open and state[i] < 1) then
            dir[i] = math.Clamp(dir[i] + dT * (open and speed or -speed), -1, 1)
            state[i] = math.Clamp(state[i] + (1 / speed * dT * dir[i]), obstacle and math.min(OBST, prev) or 0, 1)
            if obstacle and shouldClose and state[i] <= OBST then dir[i] = 0 end
            if state[i] == 0 or state[i] == 1 then
                dir[i] = 0
                if state[i] == 0 then
                    self.CloseDelay[idx] = nil
                    self.IsClosing[idx] = false
                    self.DoorAnnounceState[idx] = "Closed"
                    if AR[idx] and AR[idx] >= 2 or RF[idx] > 0 then AR[idx] = nil RD[idx] = nil RF[idx] = 0 end
                end
            end
        elseif Train["ChangeDoors"..sd..i] then
            dir[i] = math.Clamp(dir[i] + dT * (Train["ChangeDoors"..sd..i.."Dir"] and speed or -speed), -1, 1)
            state[i] = math.Clamp(state[i] + (1 / speed * dT * dir[i]), obstacle and math.min(OBST, prev) or 0, 1)
            if state[i] == 0 or state[i] == 1 then dir[i] = 0 end
        end
    end

    if commandClose and state[i] > 0 then
        self.IsClosing[idx] = true
        self.DoorAnnounceState[idx] = "Closing"
    elseif state[i] == 0 then
        self.IsClosing[idx] = false
        self.DoorAnnounceState[idx] = "Closed"
    elseif state[i] == 1 and not commandClose then
        self.DoorAnnounceState[idx] = "Open"
    elseif dir[i] ~= 0 then
        self.DoorAnnounceState[idx] = "Moving"
    end
    Train:SetNW2Bool("DoorReverse"..idx, AR[idx] ~= nil and AR[idx] < 4)
end

function TRAIN_SYSTEM:Think(dT)
    if SERVER and not self.TrigMade then self.TrigMade = true MakeDoorTriggers(self) end
    local Train = self.Train

    local LeftDL = 1
    local RightDL = 1

    if Train.CanStuckPassengerLeft then
        for i in ipairs(self.LeftDoorStuck) do
            self.LeftDoorStuck[i] = math.random() < (0.6 + math.min(2, 2 - self.LeftDoorSpeed[i] / LeftDL) * 0.2) * Train.CanStuckPassengerLeft * 0.6 and (math.random() > 0.7 and CurTime())
        end
        Train.CanStuckPassengerLeft = false
    end
    if Train.CanStuckPassengerRight then
        for i in ipairs(self.RightDoorStuck) do
            self.RightDoorStuck[i] = math.random() < (0.6 + math.min(2, 2 - self.RightDoorSpeed[i] / RightDL) * 0.2) * Train.CanStuckPassengerRight * 0.6 and (math.random() > 0.7 and CurTime())
        end
        Train.CanStuckPassengerRight = false
    end

    self.commandLeft = (Train:ReadTrainWire(65) * Train:ReadTrainWire(66) * Train:ReadTrainWire(64)) > 0
    self.commandRight = (Train:ReadTrainWire(61) * Train:ReadTrainWire(62) * Train:ReadTrainWire(64)) > 0
    self.commandClose = Train:ReadTrainWire(63) > 0
    if Train.BUV and Train.BUV.DisableDoors == 1 then
        self.commandLeft = false
        self.commandRight = false
        self.commandClose = true
    end

    local commandLeft, commandRight, commandClose = self.commandLeft, self.commandRight, self.commandClose
    self.AODHold = self.AODHold or {}
    self.AODWas = self.AODWas or {}
    self.PrevCmdClose, self.PrevCmdLeft, self.PrevCmdRight = commandClose, commandLeft, commandRight

    if commandClose and not self.CloseCommandActive then
        self.CloseCommandActive = true

        for i = 1, 4 do
            local idxL = i
            local idxR = i + 4

            if self.LeftDoorState[i] > 0 and (((Train.AODStage or {})[2*(i-1)+2] or 0) < 3) then
                self.IsClosing[idxL] = true
                self.DoorAnnounceState[idxL] = "Closing"
            end
            if self.RightDoorState[i] > 0 and (((Train.AODStage or {})[2*(i-1)+1] or 0) < 3) then
                self.IsClosing[idxR] = true
                self.DoorAnnounceState[idxR] = "Closing"
            end
        end
    elseif not commandClose then
        self.CloseCommandActive = false
    end

    for i = 1, 4 do
        local idxL = i
        local idxR = i + 4
        local ctrlOK = BRK(Train,"80F2")
        local ori = Train.BUV and Train.BUV.Orientation
        local pwL = ctrlOK and BRK(Train, DOOR_BRK[ori and (i+4) or i])
        local pwR = ctrlOK and BRK(Train, DOOR_BRK[ori and i or (i+4)])

        if commandLeft then
            self.DoorLeft = true
        elseif commandRight then
            self.DoorRight = true
        elseif commandClose then
            self.DoorLeft = false
            self.DoorRight = false
        end

        local manualL = ((Train.AODStage or {})[2*(i-1)+2] or 0) >= 3
        local manualR = ((Train.AODStage or {})[2*(i-1)+1] or 0) >= 3
        local moving = math.abs(Train.Speed or 0) > 3
        for _, sd in ipairs({"L","R"}) do
            if (sd == "L" and manualL) or (sd == "R" and manualR) then
                local st = sd == "L" and self.LeftDoorState or self.RightDoorState
                local spd = sd == "L" and self.LeftDoorSpeed or self.RightDoorSpeed
                local dr = sd == "L" and self.LeftDoorDir or self.RightDoorDir
                local factor = moving and -0.5 or 0
                local push = Train.AODPush or {}
                if push["Open"..sd..i] then factor = 0.6 end
                if push["Close"..sd..i] then factor = -0.6 end
                self.ManualDir = self.ManualDir or {L = {0,0,0,0}, R = {0,0,0,0}}
                local md = self.ManualDir[sd]
                if factor ~= 0 then
                    md[i] = math.Clamp(md[i] + dT * factor * 1.5, -0.7, 0.7)
                else
                    md[i] = md[i] > 0 and math.max(0, md[i] - 0.15 * dT) or math.min(0, md[i] + 0.15 * dT)
                end
                st[i] = math.Clamp(st[i] + dT * md[i] / spd[i] * 2, 0, 1)
                if st[i] == 0 or st[i] == 1 then md[i] = 0 end
                dr[i] = 0
                local idx = sd == "L" and idxL or idxR
                self.CloseDelay[idx] = nil
                self.IsClosing[idx] = false
                self.DoorAnnounceState[idx] = "Closing"
            end
        end

        for _, sd in ipairs({"L","R"}) do
            local key = sd..i
            local man = sd == "L" and manualL or manualR
            local st = sd == "L" and self.LeftDoorState[i] or self.RightDoorState[i]
            if man then
                self.AODWas[key] = true
                self.AODHold[key] = nil
            elseif self.AODWas[key] then
                self.AODWas[key] = nil
                if st > 0 then self.AODHold[key] = true end
            end
            if self.AODHold[key] and st <= 0 then self.AODHold[key] = nil end
        end
        local holdL, holdR = self.AODHold["L"..i], self.AODHold["R"..i]
        if holdL then
            self.LeftDoorDir[i] = -1
            self.LeftDoorState[i] = math.Clamp(self.LeftDoorState[i] - dT / self.LeftDoorSpeed[i], 0, 1)
            self.CloseDelay[idxL] = nil
            self.DoorAnnounceState[idxL] = self.LeftDoorState[i] > 0 and "Closing" or "Closed"
            if self.LeftDoorState[i] <= 0 then self.LeftDoorDir[i] = 0 end
        end
        if holdR then
            self.RightDoorDir[i] = -1
            self.RightDoorState[i] = math.Clamp(self.RightDoorState[i] - dT / self.RightDoorSpeed[i], 0, 1)
            self.CloseDelay[idxR] = nil
            self.DoorAnnounceState[idxR] = self.RightDoorState[i] > 0 and "Closing" or "Closed"
            if self.RightDoorState[i] <= 0 then self.RightDoorDir[i] = 0 end
        end

        if not manualL and not holdL and pwL and Train["DLDoor"..i].Value < 0.5 then
            DoorDrive(self, "L", i, idxL, dT, commandClose)
        end

        if not manualR and not holdR and pwR and Train["DRDoor"..i].Value < 0.5 then
            DoorDrive(self, "R", i, idxR, dT, commandClose)
        end

        if not self.LeftDoorStucked[i] and type(self.LeftDoorStuck[i]) == "number" and self.LeftDoorStuck[i] + 3 < CurTime() and not self.DoorLeft then
            self.LeftDoorStucked[i] = CurTime() + 3
        end
        if not self.RightDoorStucked[i] and type(self.RightDoorStuck[i]) == "number" and self.RightDoorStuck[i] + 3 < CurTime() and not self.DoorLeft then
            self.RightDoorStucked[i] = CurTime() + 3
        end
        if self.LeftDoorStucked[i] and self.LeftDoorStuck[i] and self.LeftDoorState[i] > 0.4 then
            self.LeftDoorStuck[i] = false
        end
        if self.RightDoorStucked[i] and self.RightDoorStuck[i] and self.RightDoorState[i] > 0.4 then
            self.RightDoorStuck[i] = false
        end
        if self.LeftDoorStucked[i] and self.LeftDoorStucked[i] < CurTime() and not self.LeftDoorStuck[i] and self.LeftDoorState[i] == 0 then
            self.LeftDoorStucked[i] = false
        end
        if self.RightDoorStucked[i] and self.RightDoorStucked[i] < CurTime() and not self.RightDoorStuck[i] and self.RightDoorState[i] == 0 then
            self.RightDoorStucked[i] = false
        end

        Train:SetPackedRatio("DoorL"..i, self.LeftDoorState[i])
        Train:SetPackedRatio("DoorR"..i, self.RightDoorState[i])

        Train:SetNW2String("DoorAnnounceState"..idxL, self.DoorAnnounceState[idxL])
        Train:SetNW2String("DoorAnnounceState"..idxR, self.DoorAnnounceState[idxR])
    end

    Train:SetPackedBool("DoorL", self.DoorLeft)
    Train:SetPackedBool("DoorR", self.DoorRight)

    Train.LeftDoorsOpen = self.LeftDoorState[1] > 0.5 or self.LeftDoorState[2] > 0.5 or self.LeftDoorState[3] > 0.5 or self.LeftDoorState[4] > 0.5
    Train.RightDoorsOpen = self.RightDoorState[1] > 0.5 or self.RightDoorState[2] > 0.5 or self.RightDoorState[3] > 0.5 or self.RightDoorState[4] > 0.5
    Train.LeftDoorsClosed = self.LeftDoorState[1] == 0 and self.LeftDoorState[2] == 0 and self.LeftDoorState[3] == 0 and self.LeftDoorState[4] == 0
    Train.RightDoorsClosed = self.RightDoorState[1] == 0 and self.RightDoorState[2] == 0 and self.RightDoorState[3] == 0 and self.RightDoorState[4] == 0
    Train.LeftDoorsOpening = self.DoorLeft
    Train.RightDoorsOpening = self.DoorRight
end

if CLIENT then
    function TRAIN_SYSTEM:ClientInitialize()
        self.nextClThink = 0
        self.WasOpen = {}
        self.DelayTimer = {}
    end

    function TRAIN_SYSTEM:ClientThink()
        if (self.nextClThink or 0) > CurTime() then return end
        self.nextClThink = CurTime() + 0.05

        local Train = self.Train

        for idx = 1, 8 do
            local state = Train:GetNW2String("DoorAnnounceState" .. idx, "Closed")
            local alarm = state == "Closing"

            Train:SetSoundState("door_alarm_" .. idx, alarm and 1 or 0, alarm and 1 or 0)

            local delay = self.DelayTimer[idx] and CurTime() < self.DelayTimer[idx] or state ~= "Open" and self.WasOpen[idx]
            if delay and not self.DelayTimer[idx] then
                self.DelayTimer[idx] = CurTime() + 0.2
                self.WasOpen[idx] = false
            elseif not delay then
                self.DelayTimer[idx] = nil
            end
        end
    end
end
