--Light mod made by [G-moder]FertNoN

local Clamp = math.Clamp

local sbox_E2_maxdLightPerSecond = CreateConVar( "sbox_E2_maxdLightPerSecond", "12", FCVAR_ARCHIVE )
local dLightSpawnInSecond=0

------------------------------------------Dynamic LIGHT

function SetE2DLight(self,this,pos,color,brightness,size,delay)

	if !IsValid(this)  then return end
	if !isOwner(self,this)  then return end
	if this:GetClass()=="light_dynamic" then return end
	if dLightSpawnInSecond >= sbox_E2_maxdLightPerSecond:GetInt() then return end

	local dynlight = ents.Create( "light_dynamic" )
		
	if pos!=nil then dynlight:SetPos( Vector(pos[1],pos[2],pos[3]) ) else dynlight:SetPos(this:GetPos()) end
	dynlight:SetKeyValue( "_light", Clamp(color[1], 0, 255) .. " " .. Clamp(color[2], 0, 255) .. " " .. Clamp(color[3], 0, 255) .. " " .. 255 )
	if delay!=nil then dynlight:SetKeyValue( "style", delay ) end
	dynlight:SetKeyValue( "distance", Clamp(size, 0, 5000) )
	dynlight:SetKeyValue( "brightness", Clamp(brightness, 0, 15) )
	if this!=nil then dynlight:SetParent( this ) end
	dynlight:SetOwner( self.player )
	
	dLightSpawnInSecond=dLightSpawnInSecond+1
	if dLightSpawnInSecond == 1 then 
		timer.Simple( 1, function()
			dLightSpawnInSecond=0
		end)
	end
	
	if IsValid(this.e2_dlight) then this.e2_dlight:Remove() end
    this.e2_dlight=dynlight
        
	dynlight:Spawn()
    return dynlight
end

__e2setcost(200)

e2function entity entity:setdLight(vector pos,vector color,number brightness,number size,number delay)
return SetE2DLight(self,this,pos,color,brightness,size,delay)
end

e2function entity entity:setdLight(vector color,number brightness,number size)
return SetE2DLight(self,this,pos,color,brightness,size,delay)
end

__e2setcost(20)
e2function number dLightCanSet()
if dLightSpawnInSecond >= sbox_E2_maxdLightPerSecond:GetInt() then return 0 else return 1 end
end

e2function void entity:dLightPos(vector pos)
if !IsValid(this)  then return end
if !IsValid(this.e2_dlight)  then return end
if !isOwner(self,this)  then return end
this.e2_dlight:SetPos( Vector(pos[1],pos[2],pos[3]) )
end

e2function void entity:dLightColor(vector color)
if !IsValid(this)  then return end
if !IsValid(this.e2_dlight)  then return end
if !isOwner(self,this)  then return end
this.e2_dlight:SetKeyValue( "_light", Clamp(color[1], 0, 255) .. " " .. Clamp(color[2], 0, 255) .. " " .. Clamp(color[3], 0, 255) .. " " .. 255 )
end

e2function void entity:dLightBrightness(number brightness)
if !IsValid(this)  then return end
if !IsValid(this.e2_dlight)  then return end
if !isOwner(self,this)  then return end
this.e2_dlight:SetKeyValue( "brightness", Clamp(brightness, 0, 15) )
end

e2function void entity:dLightSize(number size)
if !IsValid(this)  then return end
if !IsValid(this.e2_dlight)  then return end
if !isOwner(self,this)  then return end
this.e2_dlight:SetKeyValue( "distance", Clamp(size, 0, 5000) )
end

e2function void entity:dLightDelay(number delay)
if !IsValid(this)  then return end
if !IsValid(this.e2_dlight)  then return end
if !isOwner(self,this)  then return end
this.e2_dlight:SetKeyValue( "style", delay )
end

e2function void entity:dLightReParent(entity parent)
if !IsValid(this)  then return end
if !IsValid(this.e2_dlight)  then return end
if !isOwner(self,this)  then return end
this.e2_dlight:SetParent( parent )
parent.e2_dlight=this.e2_dlight
this.e2_dlight=nil
end

e2function void entity:dLightRemove()
if !IsValid(this)  then return end
if !IsValid(this.e2_dlight)  then return end
if !isOwner(self,this)  then return end
this.e2_dlight:Remove()
this.e2_dlight=nil
end

e2function entity entity:dLightEntity()
if !IsValid(this)  then return end
if !IsValid(this.e2_dlight)  then return end
return this.e2_dlight
end

------------------------------------------Flash LIGHT

local sbox_E2_maxfLightPerSecond = CreateConVar( "sbox_E2_maxfLightPerSecond", "5", FCVAR_ARCHIVE )
local fLightSpawnInSecond=0

__e2setcost(200)
e2function entity entity:setfLight(vector pos,vector color,angle ang,string material,number fov,number farz,number nearz)
	
	if !IsValid(this)  then return end
	if !isOwner(self,this)  then return end
	if this:GetClass()=="env_projectedtexture" then return end
	if fLightSpawnInSecond >= sbox_E2_maxfLightPerSecond:GetInt() then return end
	
	local flashlight = ents.Create( "env_projectedtexture" )
	flashlight:SetParent( this )	
	flashlight:SetPos( Vector( pos[1], pos[2], pos[3] ) )
	flashlight:SetAngles( Angle( ang[1] , ang[2] , ang[3] ) )
	flashlight:SetKeyValue( "enableshadows", 1 )
	flashlight:SetKeyValue( "farz", farz )
	flashlight:SetKeyValue( "nearz", nearz )
	flashlight:SetKeyValue( "lightfov", fov )
	flashlight:SetKeyValue( "lightcolor", Clamp(color[1], 0, 255) .. " " .. Clamp(color[2], 0, 255) .. " " .. Clamp(color[3], 0, 255) )	
	flashlight:SetOwner( self.player )	
	
	fLightSpawnInSecond=fLightSpawnInSecond+1
	if fLightSpawnInSecond == 1 then 
		timer.Simple( 1, function()
			fLightSpawnInSecond=0
		end)
	end
	
	if IsValid(this.e2_flight) then this.e2_flight:Remove() end
    this.e2_flight=flashlight

	flashlight:Spawn()
	flashlight:Input( "SpotlightTexture", NULL, NULL, material )
	
	return flashlight
end

__e2setcost(20)
e2function number fLightCanSet()
if fLightSpawnInSecond >= sbox_E2_maxfLightPerSecond:GetInt() then return 0 else return 1 end
end

e2function void entity:fLightPos(vector pos)
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
if !isOwner(self,this)  then return end
this.e2_flight:SetPos( Vector(pos[1],pos[2],pos[3]) )
end

e2function void entity:fLightAng(angle ang)
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
if !isOwner(self,this)  then return end
this.e2_flight:SetAngles( Angle( ang[1] , ang[2] , ang[3] ) )
end

e2function void entity:fLightColor(vector color)
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
if !isOwner(self,this)  then return end
this.e2_flight:SetKeyValue( "lightcolor", Clamp(color[1], 0, 255) .. " " .. Clamp(color[2], 0, 255) .. " " .. Clamp(color[3], 0, 255) )
end

e2function void entity:fLightMaterial(string material)
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
if !isOwner(self,this)  then return end
this.e2_flight:Input( "SpotlightTexture", NULL, NULL, material )
end

e2function void entity:fLightFOV(number fov)
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
if !isOwner(self,this)  then return end
this.e2_flight:SetKeyValue( "lightfov", fov )
end

e2function void entity:fLightFarz(number farz)
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
if !isOwner(self,this)  then return end
this.e2_flight:SetKeyValue( "farz", farz )
end

e2function void entity:fLightNearz(number nearz)
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
if !isOwner(self,this)  then return end
this.e2_flight:SetKeyValue( "nearz", nearz )
end

e2function void entity:fLightReParent(entity parent)
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
if !isOwner(self,this)  then return end
this.e2_flight:SetParent( parent )
parent.e2_flight=this.e2_flight
this.e2_flight=nil
end

e2function void entity:fLightRemove()
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
if !isOwner(self,this)  then return end
this.e2_flight:Remove()
this.e2_flight=nil
end

e2function entity entity:fLightEntity()
if !IsValid(this)  then return end
if !IsValid(this.e2_flight)  then return end
return this.e2_flight
end

