-- made by [G-moder]FertNoN

local keys = {
["w"]= IN_FORWARD,
["a"]= IN_MOVELEFT,
["s"]= IN_BACK,
["d"]= IN_MOVERIGHT,
["mouse1"]= IN_ATTACK,
["mouse2"]= IN_ATTACK2,
["reload"]= IN_RELOAD,
["jump"]= IN_JUMP,
["speed"] = IN_SPEED,
["run"] = IN_SPEED,
["zoom"]= IN_ZOOM,
["walk"]= IN_WALK,
["turnleftkey"]= IN_LEFT,
["turnrightkey"]= IN_RIGHT,
["duck"]= IN_DUCK,
["use"]= IN_USE,
["cancel"]= IN_CANCEL,
}

local MouseKeys = {
["left"] = 107,
["middle"] = 109,
["right"] = 108,
["4"] = 110,
["5"] = 111,
["wheel_down"] = 113,
["wheel_up"] = 112,
["invprev"] = 113,
["invnext"] = 112,
}

for k,v in pairs(MouseKeys) do
	MouseKeys[v]=k
end

local function keyMemory(ply)
	ply.e2Keys = {}
	ply.e2KeyAsk = {}
	ply.KeyAct={}
	ply.MKeyAct={}
end

hook.Add("PlayerInitialSpawn", "E2KeyPress", function(ply)		
	keyMemory(ply)
end)
	
for _, ply in ipairs( player.GetAll() ) do
	keyMemory(ply)
end

hook.Add("PlayerButtonUp","E2KeyPress", function(ply,key) 
	ply.e2Keys[key] = nil
end)

hook.Add("PlayerButtonDown","E2KeyPress", function(ply,key) 
	if ply.runkey then 
		ply.e2Keys[key] = 1
		ply.e2KeyAsk[key] = {}
		if key < 107 or key > 113 then 
			ply.e2LastKeyPress=key
			ply.e2KeyAsk[0] = {}
			for k,v in pairs(ply.KeyAct) do
				if !IsValid(k) then ply.KeyAct[k]=nil continue end
				k:Execute()
			end
		else
			ply.e2mLastKeyPress = MouseKeys[key]
			ply.e2KeyAsk["last"] = {}
			for k,v in pairs(ply.MKeyAct) do
				if !IsValid(k) then ply.MKeyAct[k]=nil continue end
				k:Execute()
			end
		end
	end
end)

concommand.Add("wire_e2mkp",function(ply, cmd, argm)
	if !ply.runkey then return end
	key = MouseKeys[argm[1]]
	ply.e2Keys[key] = 1
	ply.e2KeyAsk[key] = {}
	ply.e2mLastKeyPress = MouseKeys[key]
	ply.e2KeyAsk["last"] = {}
	for k,v in pairs(ply.MKeyAct) do
		if !IsValid(k) then ply.MKeyAct[k]=nil continue end
		k:Execute()
	end
end)

__e2setcost(20)
e2function number clKeyPress(number key)
	return self.player.e2Keys[key] or 0
end

e2function number clKeyPressVel(number key)
	if self.player.e2Keys[key] then
		if self.player.e2KeyAsk[key][self.entity]!=nil then return 0 end
		self.player.e2KeyAsk[key][self.entity]=true
		return 1
	else
		return 0
	end
end

e2function number clLastKeyPress()
	return self.player.e2LastKeyPress or 0
end

e2function number clLastKeyPressVel()
	if self.player.e2LastKeyPress then 
		if self.player.e2KeyAsk[0][self.entity]!=nil then return 0 end
		self.player.e2KeyAsk[0][self.entity]=true
		return self.player.e2LastKeyPress
	else 
		return 0 
	end
end

local function runkey(self,active)
	if active!=0 then 
		if self.runkey then return end
		self.runkey=true
		if self.player.runkey==nil then self.player.runkey=1 else self.player.runkey=self.player.runkey+1 end
		self.entity:CallOnRemove("e2keyrun",function() if IsValid(self.player) then if self.player.runkey==1 then self.player.runkey=nil else self.player.runkey=self.player.runkey-1 end end end)
	else 
		if !self.runkey then return end
		self.runkey=nil
		if self.player.runkey==1 then self.player.runkey=nil else self.player.runkey=self.player.runkey-1 end
		self.entity:RemoveCallOnRemove("e2keyrun")
	end
end

__e2setcost(200)
e2function void runOnKey(number active)
	if active!=0 then 
		if self.player.KeyAct[self.entity] then return end
		self.player.KeyAct[self.entity]=true
	else 
		if !self.player.KeyAct[self.entity] then return end
		self.player.KeyAct[self.entity]=nil
	end
	runkey(self,active)
end

e2function void runOnMouseKey(number active)
	if active!=0 then 
		if self.player.MKeyAct[self.entity] then return end
		self.player.MKeyAct[self.entity]=true
	else 
		if !self.player.MKeyAct[self.entity] then return end
		self.player.MKeyAct[self.entity]=nil
	end
	runkey(self,active)
end

e2function void runKey(number active)
	runkey(self,active)
end

e2function void clKeyClearBuffer()
	self.player.e2Keys = {}
	self.player.e2KeyAsk = {}
	self.player.e2LastKeyPress = nil
	self.player.e2mLastKeyPress = nil
end

--------------------MOUSE

__e2setcost(20)
e2function number clMouseKeyPress(string key)
	return self.player.e2Keys[MouseKeys[key:lower()]] or 0
end

e2function number clMouseKeyPressVel(string key)
	local key = MouseKeys[key:lower()]
	if self.player.e2Keys[key] then
		if self.player.e2KeyAsk[key][self.entity]!=nil then return 0 end
		self.player.e2KeyAsk[key][self.entity]=true
		return 1
	else
		return 0
	end
end

e2function string clLastMouseKeyPress()
	return self.player.e2mLastKeyPress or "null"
end

e2function string clLastMouseKeyPressVel()
	if self.player.e2mLastKeyPress then
		if self.player.e2KeyAsk["last"][self.entity]!=nil then return "null" end
		self.player.e2KeyAsk["last"][self.entity]=true
		return self.player.e2mLastKeyPress
	else 
		return "null"
	end
end

__e2setcost(20)
e2function number keyPress(string key)
	if !keys[key:lower()] then return 0 end
	if self.player:KeyDown(keys[key:lower()]) then return 1 else return 0 end
end

__e2setcost(50)
e2function number entity:inUse()
	if !IsValid(this) then return 0 end
	if this.e2UseKeyAsk==nil then this.e2UseKeyAsk={} end
	if this.e2UseKeyAsk[self.entity]==nil then this.e2UseKeyAsk[self.entity]={} end
	if this.e2UseKeyAsk[self.entity].use==nil then this.e2UseKeyAsk[self.entity].use=true else return 0 end
	if this.user==nil then return 0 end
	return 1
end

e2function entity entity:inUseBy()
    if !IsValid(this) then return nil end
	if this.e2UseKeyAsk==nil then this.e2UseKeyAsk={} end
	if this.e2UseKeyAsk[self.entity]==nil then this.e2UseKeyAsk[self.entity]={} end
	if this.e2UseKeyAsk[self.entity].useBy==nil then this.e2UseKeyAsk[self.entity].useBy=true else return nil end
	return this.user
end

__e2setcost(150)
e2function void runOnUse(number active)
    if active!=0 then
		self.entity.Use = function(ent,ply)
			if ply.CantUseE2 != nil then return end
			local plyID = tostring(ply:EntIndex())
			hook.Add("PlayerButtonUp","e2RunUse"..plyID, function(player,key) 
				if !IsValid(ply) then hook.Remove("Think","e2RunUse"..plyID) end
				if player == ply and key==15 then ply.CantUseE2=nil hook.Remove("Think","e2RunUse"..plyID) end
			end)
			ply.CantUseE2=true
			self.entity.user=ply
			self.entity:Execute()
		end
	else
		self.entity.Use = nil
	end
end

__e2setcost(50)
e2function void runOnUse(number active, entity ent)
	if !IsValid(ent) then return end
	if active!=0 then
		if ent.E2Execute == nil then ent.E2Execute = {} end
		ent.E2Execute[self.entity]=true 
	else
		ent.E2Execute[self.entity]=nil
	end
end 

__e2setcost(5)
e2function entity useEntClk()
	return self.entity.UseEntClk
end

local function e2_use(ply,key)
	if key==15 then 
		local rv1=ply:GetEyeTraceNoCursor().HitPos
		local rv2=ply:GetShootPos()
		local rvd1, rvd2, rvd3 = rv1[1] - rv2[1], rv1[2] - rv2[2], rv1[3] - rv2[3]
        local dis=(rvd1 * rvd1 + rvd2 * rvd2 + rvd3 * rvd3) ^ 0.5
		if dis<40 then
			local ent = ply:GetEyeTraceNoCursor().Entity
            if ent:IsValid() then 
				ent.user=ply
				ent.e2UseKeyAsk={} 
				if ent.E2Execute != nil then 
					for k,v in pairs(ent.E2Execute) do
						if !IsValid(k) then ent.E2Execute[k]=nil continue end
						k.UseEntClk=ent k:Execute() k.UseEntClk=nil
					end					
				end
			end
		end
	end
end 

hook.Add("PlayerButtonDown","e2_use", e2_use)