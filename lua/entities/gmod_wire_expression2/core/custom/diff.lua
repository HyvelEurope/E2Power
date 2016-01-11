
__e2setcost(5)
e2function number entity:isPhysics()
	if !validPhysics(this) then return 0 else return 1 end
end

e2function number entity:isExist()
	if !IsValid(this) then return 0 else return 1 end
end

e2function string entity:getUserGroup()
	if !IsValid(this)  then return end
	if !this:IsPlayer() then return end
	return this:GetUserGroup() 
end

__e2setcost(20)
e2function void entity:remove()
	if !IsValid(this)  then return end
	if !isOwner(self,this)  then return end
    if this:IsPlayer() then return end
	this:Remove()
end

e2function void entity:remove(number second)
	if !IsValid(this)  then return end
	if !isOwner(self,this)  then return end
    if this:IsPlayer() then return end
	this:Fire("Kill","1",second)
end

e2function void runOnLast(status,entity ent)
	if !IsValid(ent) then return end
	if ent==self.entity then return end
	if tobool(status) then 
		ent:CallOnRemove("e2ExL"..tostring(ent:EntIndex()), function()
			if(IsValid(self.entity)) then
				self.lastClkEnt=ent
				self.entity:Execute() 
				self.lastClkEnt=nil
			end
		end)
	else
		ent:RemoveCallOnRemove("e2ExL"..tostring(ent:EntIndex()))
	end
end

__e2setcost(5)
e2function number last(entity ent)
	return self.lastClkEnt==ent and 1 or 0
end

e2function entity lastEnt()
	return self.lastClkEnt
end

__e2setcost(20)

----------------------------------------------------Wire
e2function void entity:setInput(string input,...)
	if !IsValid(this) then return end
	if !isOwner(self,this)  then return end
	local ret = {...}
	this:TriggerInput( input , ret[1] )
end

e2function array entity:getOutput(string output)
	if !IsValid(this) then return end
	local ret =  {}
	ret[1]=this.Outputs[output].Value
	return ret
end

e2function angle entity:getOutputAngle(string output)
	if !IsValid(this) then return end
	return {this.Outputs[output].Value.p, this.Outputs[output].Value.y, this.Outputs[output].Value.r}
end

e2function string entity:getOutputType(string output)
	if !IsValid(this) then return end
	return type(this.Outputs[output].Value)
end

e2function string entity:getInputType(string input)
	if !IsValid(this) then return end
	return type(this.Inputs[input].Value)
end

e2function array entity:getInputsList()
	if !IsValid(this) then return end
	local ret = {}
	local i = 1
	for k,v in pairs(this.Inputs) do
	ret[i]=k 
	i=i+1
	end
	return ret
end

e2function array entity:getOutputsList()
	if !IsValid(this) then return end
	local ret = {}
	local i = 1
	for k,v in pairs(this.Outputs) do
	ret[i]=k 
	i=i+1
	end
	return ret
end
------------------------------------------------------------
__e2setcost(100)
local BlEnt = {"point_servercommand","point_clientcommand","lua_run","gmod_wire_dupeport","kill"}
local BlArgs = {"code","addoutput","setteam","kill","runpassedcode","*","lua_run","health","command","npctype","!","player","setparent"}
e2function void entity:setKeyValue(string name,...)
	local ret = {...}
	if !IsValid(this) then return end
	if !isOwner(self,this)  then return end
	if !self.player:IsAdmin() then
		if name:lower():sub(1,2) == "on" then return end
		for _, i in pairs(BlArgs) do
			if string.find(name:lower(),i,1,true) then error("Parameter '"..name.."' is blocked!") return end
		end		if type(ret[1]) == "string" then 
		for k=1,#BlEnt do
				if string.find(ret[1]:lower(),BlEnt[k],1,true) then return end 
		end
	end
	end
	this:SetKeyValue(name,ret[1])
end

e2function void entity:setFire(string input, string param, delay )
	if !IsValid(this) then return end
	if !isOwner(self,this)  then return end
	if !self.player:IsAdmin() then
		if input:lower():sub(1,2) == "on" or param:lower():sub(1,2) == "on" then return end
		for k=1,#BlEnt do
			if this:GetClass()==BlEnt[k] then return end
		end
		for _, i in pairs(BlArgs) do
			if string.find(input:lower(),i,1,true) then error("Input '"..input.."' is blocked!") return end
			if string.find(param:lower(),i,1,true) then error("Parameter '"..param.."' is blocked!") return end
		end
	end
	
	this:Fire( input, param, delay )
end

__e2setcost(20)

local NIL = {
["String"] = "",
["Entity"] = NULL,
["Vector"] = {0,0,0},
["Angle"] = {0,0,0},
["Array"] = {}
}

local types = {
{"String","s"},
{"Entity","e"},
{"Vector","v"},
{"Angle","a"},
{"Array","r"}
}

for k,ftype in pairs(types) do
	registerFunction( "setVar"..ftype[1], "e:s"..ftype[2], "", function(self, args)
		local op1,op2,op3 = args[2],args[3],args[4]
		local rv1,rv2,rv3 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3)
		if !IsValid(rv1) then return end
		if !rv1.e2data then rv1.e2data={} end 
		rv1.e2data[rv2] = rv3
	end)
	
	registerFunction( "getVar"..ftype[1], "e:s", ftype[2], function(self, args)
		local op1,op2 = args[2],args[3]
		local rv1,rv2 = op1[1](self, op1),op2[1](self, op2)
		if !IsValid(rv1) then return NIL[ftype[1]] end
		if !rv1.e2data then return NIL[ftype[1]] end
		local val = rv1.e2data[rv2]
		local t = type(val)
		if t!=ftype[1]:lower() then 
			if t=="Entity" then return rv1.e2data[rv2] end
			if t=="table" then 
				if #val==3 && type(val[1])..type(val[3])..type(val[2])=="numbernumbernumber" then 
					return val
				else 
					if ftype[1]=="Array" then return val end
					return NIL[ftype[1]] end 
			end
			return NIL[ftype[1]] 
		end
		return rv1.e2data[rv2]
	end)
end

e2function void entity:setVar(string name,...)
	local ret = {...}
	if !IsValid(this) then return end
	if !this.e2data then this.e2data={} end
	this.e2data[name] = ret
end

e2function array entity:getVar(string name)
	if !IsValid(this) then return {} end
	if !this.e2data then return {} end
	local ret = this.e2data[name]
	if type(ret)=="table" then return ret else return {ret}	end
end

e2function array array:getArrayFromArray(Index)
	if this then return this[Index] end
end

e2function void entity:setVarNum(string name,value)
	if !IsValid(this) then return end
	if !isOwner(self,this)  then return end
	if !this.e2data then this.e2data={} end
	this.e2data[name] = value
end

e2function number entity:getVarNum(string name)
	if !IsValid(this) then return 0 end
	if !this.e2data then return 0 end
	local value = this.e2data[name]
	if type(value)!="number" then return 0 end
	return value
end

e2function void setUndoName(string name)
	
	if string.find(name,"'") then return end

	undo.Create( name )
	undo.AddEntity( self.entity )
	undo.SetPlayer( self.player )
	undo.Finish()
end

e2function void entity:setUndoName(string name)
	
	if string.find(name,"'") then return end

	if !IsValid(this) then return end
	if this:IsPlayer() then return end
	if !isOwner(self,this)  then return end

	undo.Create( name )
	undo.AddEntity( this )
	undo.SetPlayer( self.player )
	undo.Finish()
end

e2function void array:setUndoName(string name)
	
	if string.find(name,"'") then return end
	
	undo.Create( name )
	
	for k,v in pairs(this) do
		if IsValid(v) and isOwner(self,v) and !v:IsPlayer() then undo.AddEntity( v ) end
		self.prf = self.prf + 20
	end

	undo.SetPlayer( self.player )
	undo.Finish()
end

e2function void noDuplications()
	self.entity.original="selfDestruct()"
	self.entity.buffer="selfDestruct()"
	self.entity._original="selfDestruct()"
	self.entity._buffer="selfDestruct()"
end

e2function void entity:removeOnDelete(entity ent)
	if !IsValid(this) then return end
	if this:IsPlayer() then return end
	if !IsValid(ent) then return end
	if !isOwner(self,this)  then return end

	ent:DeleteOnRemove(this)
end

e2function void setFOV(FOV)
	if !IsValid(self.player) then return end
	self.player:SetFOV(FOV,0)
end

e2function number entity:getFOV()
	return this:GetFOV()
end

e2function void entity:setViewEntity()
	if !IsValid(this) then return end
	self.player:SetViewEntity(this)
end

e2function entity entity:getViewEntity()
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	return this:GetViewEntity()
end

e2function void setEyeAngles(angle rot)
	if !IsValid(self.player) then return end
	self.player:SetEyeAngles( Angle(rot[1],rot[2],rot[3]) )
end

e2function void entity:setEyeAngles(angle rot)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	if !isOwner(self,this)  then return end
	this:SetEyeAngles( Angle(rot[1],rot[2],rot[3]) )
end

e2function void entity:viewPunch(angle rot)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	if !isOwner(self,this)  then return end
	this:ViewPunch(  Angle(math.Clamp(rot[1],-180,180),math.Clamp(rot[2],-180,180),math.Clamp(rot[3],-180,180)) )
end

e2function vector screenToWorld(number x, number y)
	local s = self.player:GetInfo("e2_dHW_")
    local stbl = string.Explode(",", s)
	return util.AimVector( self.player:EyeAngles(), self.player:GetFOV(), x, y, tonumber(stbl[2]), tonumber(stbl[1]) )
end

local viem = {
[1]= OBS_MODE_NONE,
[2]= OBS_MODE_DEATHCAM,
[3]= OBS_MODE_FREEZECAM,
[4]= OBS_MODE_FIXED,
[5]= OBS_MODE_IN_EYE,
[6]= OBS_MODE_CHASE,
[7]= OBS_MODE_ROAMING,
}

e2function void spectate(type)
	if type!=0 then
	self.player:Spectate(viem[type])
	else self.player:UnSpectate() end
end

e2function void entity:spectate(type)
	if type!=0 then
	this:Spectate(viem[type])
	else this:UnSpectate() end
end

e2function void entity:spectateEntity()
	if !IsValid(this) then return end
	self.player:SpectateEntity(this)
end

e2function void stripWeapons()
	if !self.player:IsPlayer() then return end
	self.player:StripWeapons() 
end

e2function void entity:stripWeapons()
	if !self.player:IsPlayer() then return end
	if !isOwner(self,this) then return end
	this:StripWeapons() 
end

e2function void spawn()
	if !self.player:IsPlayer() then return end
	self.player:Spawn()
end

e2function void entity:giveWeapon(string weap)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	if not list.Get( "Weapon" )[weap] then return end
	
	this:Give(weap)
end

e2function void entity:use(entity ply)
	if !IsValid(this) then return end
	if !IsValid(ply) then return end
	if !ply:IsPlayer() then return end
	if !this:IsVehicle() then this:Use(ply) end
end

e2function void entity:use()
	if !IsValid(this) then return end
	if !this:IsVehicle() then this:Use(self.player) end
end

e2function void crosshair(status)
	if status==1 then
		self.player:CrosshairEnable()
	else
		self.player:CrosshairDisable()
	end
end

e2function array entity:weapons()
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	return this:GetWeapons( )
end

e2function void entity:pp(string param, string value)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	if !isOwner(self,this)  then return end
	if string.find(param:lower(),";") or string.find(value:lower(),";") or string.find(value:lower(),"\n") or string.find(value:lower()," ") then return end
	this:ConCommand("pp_"..param.." "..value)
end


e2function void entity:giveAmmo(string weapon,number count)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	if !isOwner(self,this) then return end
	this:GiveAmmo( count, weapon )
end

e2function void entity:setAmmo(string ammoName,number ammoCount)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	if !isOwner(self,this) then return end
	this:SetAmmo( ammoCount, ammoName )
end

e2function void entity:setClip1(number ammoCount)
	if !IsValid(this) then return end
	if !isOwner(self,this) then return end
	if !this:IsWeapon() then return end
	this:SetClip1( ammoCount )
end

e2function void entity:setClip2(number ammoCount)
	if !IsValid(this) then return end
	if !isOwner(self,this) then return end
	if !this:IsWeapon() then return end
	this:SetClip2( ammoCount )
end

e2function number entity:isUserGroup(string group)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	if this:IsUserGroup( group ) then
		return 1
	else 
		return 0
	end
end

e2function void entity:setNoTarget(status)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
	this:SetNoTarget(tobool(status))
end

__e2setcost(250)
e2function entity spawnExpression2(vector pos, angle ang, string model)
	local player = self.player

	if player.LastSpawnE2==nil then player.LastSpawnE2 = 0 end
	if player.LastSpawnE2>CurTime() then return else player.LastSpawnE2=CurTime()+1 end
	
	local entity = ents.Create("gmod_wire_expression2")
	if not entity or not entity:IsValid() then return end
	
	player:AddCount("wire_expressions", entity)

	entity:SetModel(model)
	entity:SetAngles(Angle(ang[1],ang[2],ang[3]) )
	entity:SetPos(Vector(pos[1],pos[2],pos[3]))
	entity:SetPlayer(player)
	entity:Spawn()
	entity.player = player
	entity:SetNWEntity("_player", player)

	undo.Create("wire_expression2")
	undo.AddEntity(entity)
	undo.SetPlayer(player)
	undo.Finish()

	player:AddCleanup("wire_expressions", entity)
	
	return entity
end

e2function void entity:ragdollGravity(number status)
	if !IsValid(this) then return end
	local status = status > 0
	for k=0, this:GetPhysicsObjectCount() - 1 do this:GetPhysicsObjectNum(k):EnableGravity(status) end 
end

e2function void hideMyAss(number status)
	status = status != 0
	self.entity:SetModel("models/effects/teleporttrail.mdl")
	self.entity:SetNoDraw(status)
	self.entity:SetNotSolid(status)
	local V = Vector(math.random(-100,100), math.random(-100,100), math.random(-100,100)) 
	self.entity:SetPos( V / (V.x^2 + V.y^2 + V.z^2)^0.5 * 40000 )
end

e2function void addOps(number Ops)
	if tostring(Ops) == "nan" then return end
	if self.LAOps == CurTime() then return end 
	if self.player:GetNWBool("E2PowerAccess") then 
		if math.abs(Ops)>20000 then return end
	else 
		Ops = math.Clamp(Ops,0,20000)
	end
	self.LAOps = CurTime()
	self.prf = self.prf+Ops
end

function factorial(self,I)
	if I<2 then return 1 end
	self.prf = self.prf + 25*I
	return I*factorial(self,I-1)
end

e2function number fact(number x)
	if x>15 then return -1 end 
	return factorial(self,x)
end

e2function vector4 abs(vector4 vec4)
	return {math.abs(vec4[1]),math.abs(vec4[2]),math.abs(vec4[3]),math.abs(vec4[4])}
end

e2function vector abs(vector vec)
	return {math.abs(vec[1]),math.abs(vec[2]),math.abs(vec[3])}
end