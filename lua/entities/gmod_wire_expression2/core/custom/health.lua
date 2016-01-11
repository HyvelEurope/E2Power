
__e2setcost(20)

local fl = math.floor
local cl = math.Clamp  

e2function void entity:setHealth(number Health)
    if !IsValid(this)  then return end
	if tostring(Health) == "nan" then return end
	if !isOwner(self, this)  then return end
	if this:Health()==0 then return end
	Health=cl(Health,0, 1000000000)
	this:SetHealth(Health)
end

e2function void entity:setArmor(number Armor)
	if !IsValid(this)  then return end
	if tostring(Armor) == "nan" then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	Armor=cl(Armor, 0, 1000000000)
	this:SetArmor(Armor)
end

e2function void entity:heal(number Health)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if this:Health()==0 then return end
	if tostring(Health) == "nan" then return end
	Health=this:Health()+Health
	Health=cl(Health,0, 1000000000)
	this:SetHealth(Health)
	
end

e2function void entity:extinguish()
	if !IsValid(this) then return end
	if !isOwner(self,this)  then return end
	this:Extinguish()
end

e2function void entity:ignite(number l)
	if !IsValid(this) then return end
	if !isOwner(self,this)  then return end
	local _length	= math.Max( l , 2 )
	this:Ignite( _length, 0 )
end

e2function void entity:setMaxHealth(number Health)
	if !IsValid(this) then return end
	if !isOwner(self,this)  then return end
	if tostring(Health) == "nan" then return end
	if this:Health()==0 then return end
	this:SetMaxHealth(Health)
	this:SetHealth(Health)
end

e2function number entity:maxHealth()
    if !IsValid(this) then return 0 end
	return this:GetMaxHealth() or 0
end

__e2setcost(250)
e2function void entity:shootTo(vector start,vector dir,number spread,number force,number damage,string effect)
	local BlEff = {"dof_node","smoke","hl1gaussbeam"}
	if !IsValid(this) then return end
	for _, i in pairs(BlEff) do
		if effect:lower() == i then error("Effect "..effect.." is blocked!") return end
	end
	
	if !isOwner(self,this)  then return end
	local bullet = {}
		bullet.Num = 1
		bullet.Src = Vector(start[1],start[2],start[3])
		bullet.Dir = Vector(dir[1],dir[2],dir[3])
		bullet.Spread = Vector( spread, spread, 0 )
		bullet.Tracer = 1
		bullet.TracerName = effect
		bullet.Force = math.Clamp(force, 0 , 10000 ) 
		bullet.Damage = damage
		bullet.Attacker = self.player
	this:FireBullets( bullet )
end

e2function void shake(vector pos, amplitude, frequency, duration, radius)
	util.ScreenShake( Vector(pos[1],pos[2],pos[3]), amplitude, frequency, duration, radius)
end

e2function void explosion(number damage, number radius, vector pos)
	util.BlastDamage( self.player, self.player, Vector(pos[1],pos[2],pos[3]), cl(radius,0,10000), damage )	
end

e2function void entity:explosion(number damage, number radius)
	if !IsValid(this) then return end
	util.BlastDamage( this, self.player, this:GetPos(), cl(radius,0,10000), damage )	
end

e2function void entity:explosion()
	if !IsValid(this) then return end
	if !isOwner(self, this)  then return end
	local radius=(this:OBBMaxs() - this:OBBMins())
	radius = (radius.x^2 + radius.y^2 + radius.z^2) ^ 0.5
	local pos=this:GetPos()
	util.BlastDamage( this, self.player, this:GetPos(), radius*10, radius*3 )
	local effectdata = EffectData()
	effectdata:SetOrigin( pos )
	util.Effect( "explosion" , effectdata  )
end

e2function void explosion(number damage, number radius, vector pos, entity attacker, entity inflictor)
	util.BlastDamage( inflictor, attacker, Vector(pos[1],pos[2],pos[3]), cl(radius,0,10000), damage )	
end

e2function void explosion(vector pos)
	local pos=Vector(pos[1],pos[2],pos[3])
	util.BlastDamage( self.player, self.player, pos, 150, 100)
	local effectdata = EffectData()
	effectdata:SetOrigin( pos )
	util.Effect( "explosion" , effectdata  )
end

local dmgEffect = {
[0] = function(ent,d,h) end,

[1] = function(ent,d,h) 
		local c = ent:GetColor() 
		ent:SetColor(Color( cl(c.r-fl((c.r/h)*d),0,255) , cl(c.g-fl((c.g/h)*d),0,255) , cl(c.b-fl((c.g/h)*d),0,255) ,c.a)) 
	end,
}

local dstrEffect = {
[0] = function(ent) ent:Remove() end,

[1] = function(ent) 
		ent.hasHP=nil
		ent:SetColor(Color(0,0,0,0))
		ent:SetRenderMode(RENDERMODE_TRANSALPHA)
		local effectdata = EffectData()
		effectdata:SetEntity( ent )
		util.Effect( "entity_remove" , effectdata  )
		ent:SetNotSolid(true)
		ent:Fire("Kill","1",0.2)
	end,

[2] = function(ent) 
		local effectdata = EffectData()
		effectdata:SetOrigin( ent:GetPos() )
		util.Effect( "explosion" , effectdata  )
		ent:Remove() 
	end,
	
[3] = function(ent) 
		ent.hasHP=nil
		local c = ent:GetColor()
		ent:SetColor(Color(0,0,0,c.a))
		constraint.RemoveAll(ent)
		ent:SetNotSolid(true)    
		local phys = ent:GetPhysicsObject()
		phys:Wake()
		phys:EnableMotion(true)
		phys:EnableGravity(false) 
		ent:Fire("Kill","1",10)
	end,
	
["explo"] = function(ent) 
		local radius=(ent:OBBMaxs() - ent:OBBMins())
		radius = (radius.x^2 + radius.y^2 + radius.z^2) ^ 0.5
		local pos = ent:GetPos()
		ent.hasHP=nil
		util.BlastDamage( ent, ent.owner , pos, radius*10, radius*3)	
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		util.Effect( "explosion" , effectdata  )
		ent:Remove()
	end,
} 

local dmgType1 = {
["DMG_ACID"]=1048576,
["DMG_AIRBOAT"]=33554432,
["DMG_ALWAYSGIB"]=8192,
["DMG_BLAST"]=64,
["DMG_BLAST_SURFACE"]=134217728,
["DMG_BUCKSHOT"]=536870912,
["DMG_BULLET"]=2,
["DMG_BURN"]=8,
["DMG_CLUB"]=128,
["DMG_CRUSH"]=1,
["DMG_DIRECT"]=268435456,
["DMG_DISSOLVE"]=67108864,
["DMG_DROWN"]=16384,
["DMG_DROWNRECOVER"]=524288, 
["DMG_ENERGYBEAM"]=1024,
["DMG_FALL"]=32,
["DMG_GENERIC"]=0,
["DMG_NERVEGAS"]=65536,
["DMG_NEVERGIB"]=4096,
["DMG_PARALYZE"]=32768,
["DMG_PHYSGUN"]=8388608,
["DMG_PLASMA"]=16777216,
["DMG_POISON"]=131072,
["DMG_PREVENT_PHYSICS_FORCE"]=2048,
["DMG_RADIATION"]=262144,
["DMG_REMOVENORAGDOLL"]=4194304,
["DMG_SHOCK"]=256,
["DMG_SLASH"]=4,
["DMG_SLOWBURN"]=2097152,
["DMG_SONIC"]=512,
["DMG_VEHICLE"]=16,
}

local dmgType = {}

for v,k in pairs(dmgType1) do
	local s = v:Right(v:len()-4):lower()
	dmgType[s]=k
	dmgType[k]=s
end

local dmgType1 = nil

__e2setcost(50)
local function takeDmg(Ent, Amount, Type, Force, Attacker, Inflictor)
	local dmgInfo = DamageInfo()
	dmgInfo:AddDamage(Amount)
	dmgInfo:SetDamageType( dmgType[type:lower()] or 0 )
	dmgInfo:SetAttacker(Attacker or self.player)
	dmgInfo:SetInflictor(Inflictor or self.player)
	dmgInfo:SetDamageForce( Forse or Vector(0,0,0) )
	
	Ent:TakeDamageInfo(dmgInfo)
end


e2function void entity:takeDamage(number Amount,string Type)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	takeDmg(this,Amount,Type)
end

e2function void entity:takeDamage(number Amount, string Type, vector Force)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	takeDmg(this,Amount,Type,Vector(Force[1],Force[2],Force[3]))
end

e2function void entity:takeDamage(number Amount, string Type, vector Force, entity Attacker, entity Inflictor)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	takeDmg(this,Amount,Type,Vector(Force[1],Force[2],Force[3]),Attacker, Inflictor)
end

e2function void entity:takeDamage(number Amount, entity Attacker, entity Inflictor)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	this:TakeDamage(Amount, Attacker, Inflictor)
end

e2function void entity:takeDamage(number Amount)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	this:TakeDamage(Amount,self.player,self.player)
end

hook.Add("EntityTakeDamage", "CheckE2Dmg", function( ent, dmginfo )
	if ent.e2DmgDebag then
		ent.e2DmgInf = {}
		ent.e2DmgInf["damage"] = dmginfo:GetDamage()
		ent.e2DmgInf["attacker"] = dmginfo:GetAttacker()
		ent.e2DmgInf["inflictor"] = dmginfo:GetInflictor()
		ent.e2DmgInf["dmgtype"] = dmginfo:GetDamageType()
		ent.e2DmgInf["pos"] = dmginfo:GetDamagePosition()
		ent.e2DmgCheck = {}
		
		if ent.e2DmgEx!=nil then 
			for k,v in pairs(ent.e2DmgEx) do 
				if !IsValid(k) then ent.e2DmgEx[k]=nil continue end
				if k.DmgClkEnt==nil then k.DmgClkEnt=ent k:Execute() k.DmgClkEnt=nil end
			end
		end
	end
	if ent.hasHP then
		local H = ent:Health()
		local D = dmginfo:GetDamage()
		if H>D then ent:SetHealth(H-D) dmgEffect[ent.dmgEff](ent,D,H)
			else dstrEffect[ent.dstrEff](ent)
		end
	end
end)

local function e2DmgValid(param, e2 , ent)
	if !IsValid(ent) then return false end
	if !ent.e2DmgDebag then ent.e2DmgDebag=true ent.e2DmgCheck={} ent.e2DmgInf={} return false end
	if ent.e2DmgCheck[e2]==nil then
		ent.e2DmgCheck[e2] = {}
		ent.e2DmgCheck[e2][param] = false 
	end 
	if ent.e2DmgCheck[e2][param] then return false end
	ent.e2DmgCheck[e2][param]=true
	return true
end

__e2setcost(20)
e2function number entity:getDamage()
	if !e2DmgValid("damage",self.entity,this) then return 0 end 
	return this.e2DmgInf["damage"] or 0
end

e2function entity entity:getAttacker()
	if !e2DmgValid("attacker",self.entity,this) then return nil end 
	return this.e2DmgInf["attacker"] or nil
end

e2function entity entity:getInflictor()
	if !e2DmgValid("inflictor",self.entity,this) then return nil end 
	return this.e2DmgInf["inflictor"] or nil
end

e2function vector entity:getDamagePos()
	if !e2DmgValid("pos",self.entity,this) then return {0,0,0} end 
	return this.e2DmgInf["pos"] or {0,0,0}
end

e2function string entity:getDamageType()
	if !e2DmgValid("dmgtype",self.entity,this) then return "" end 
	return dmgType[this.e2DmgInf["dmgtype"]] or ""
end

e2function void runOnDamage(active,entity ent)
	if !IsValid(ent) then return end
	if ent==self.entity then return end
	if ent.e2DmgEx == nil then ent.e2DmgDebag=true ent.e2DmgEx={} ent.e2DmgCheck={} ent.e2DmgInf={} end
	ent.e2DmgEx[self.entity]= tobool(active) and true or nil
end

e2function void runOnDamage(number active)
    if active!=0 then
		self.entity.OnTakeDamage = function(dmgInf)
			if self.entity.DmgClkEnt==nil then self.entity.DmgClkEnt=self.entity  self.entity:Execute() self.entity.DmgClkEnt=nil end 
		end
	else
		self.entity.OnTakeDamage = nil
	end
end

__e2setcost(5)
e2function entity damageEntClk()
	return self.entity.DmgClkEnt
end

__e2setcost(70)
local function MakeHealth(ent,dmgeff,dstreff,health)
	if ent:Health()!=0 then return end
	if ent:IsPlayerHolding() then return end
	if !validPhysics(ent) then return end
	if health==nil then
		health=ent:GetPhysicsObject():GetMass()*10
	end
	health = math.Clamp(health,0, 1000000000)
	ent:SetMaxHealth(health)
	ent:SetHealth(health)
	ent.hasHP=true
	
	ent.dmgEff=math.Clamp(dmgeff,0,table.Count(dmgEffect)-1)
	ent.dstrEff=math.Clamp(dstreff,0,table.Count(dstrEffect)-1)
end

e2function void entity:makeHealth()
	if !IsValid(this) then return end
	if !isOwner(self, this)  then return end
	MakeHealth(this,1,1)
end

e2function void entity:makeHealth(damageEffect,destroyEffect)
	if !IsValid(this) then return end
	if !isOwner(self, this)  then return end
	MakeHealth(this,damageEffect,destroyEffect)
end

e2function void entity:makeHealth(damageEffect,destroyEffect,Health)
	if !IsValid(this) then return end
	if !isOwner(self, this)  then return end
	MakeHealth(this,damageEffect,destroyEffect,Health)
end

e2function void entity:makeNoHealth()
	if !IsValid(this) then return end
	if !isOwner(self, this)  then return end
	this:SetMaxHealth(0)
	this:SetHealth(0)
	this.hasHP=nil
	this.dmgEff=nil
	this.dstrEff=nil
end

e2function void entity:makeVolatile()
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	MakeHealth(this,0,0,25)
	this.dstrEff= "explo"
	this.owner = self.player
end

concommand.Add( "props_health", function(ply,cmd,argm)
	if IsValid(ply) then if !ply:IsAdmin() then return end end
	if tobool(argm[1]) then 
		hook.Add("EntityTakeDamage", "E2AllDmg", function( ent ) 
			if !ent.hasHP then if ent:Health()==0 then if validPhysics(ent) then MakeHealth(ent, tonumber(argm[2]) or 1 ,tonumber(argm[3]) or 1) end end end
		end)
	else
		hook.Remove("EntityTakeDamage", "E2AllDmg")
	end
end)