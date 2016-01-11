--Draw core by [G-moder]FertNoN

-------------------------------------SPRITIES

local sbox_E2_maxSpritesPerSecond = CreateConVar( "sbox_E2_maxSpritesPerSecond", "12", FCVAR_ARCHIVE )
local sbox_E2_maxSprites = CreateConVar( "sbox_E2_maxSprites", "300", FCVAR_ARCHIVE )
local SpritesSpawnInSecond=0
local SpritesCount=0

function E2_spawn_sprite(self,this,mat,pos,color,alpha,sizex,sizey)
	
	if SpritesSpawnInSecond >= sbox_E2_maxSpritesPerSecond:GetInt() then return end
	if SpritesCount >= sbox_E2_maxSprites:GetInt() then return end
	if mat == "" then return end
	if string.find(mat:lower(),"pp",1,true) then return end
	local sprite=ents.Create("e2_sprite")
	sprite:SetModel("models/effects/teleporttrail.mdl")
	sprite:SetMaterial(mat)
	sprite:SetPos(Vector(pos[1],pos[2],pos[3]))
	sprite:SetAngles(Angle(0,0,0))
	sprite:SetColor(Color(color[1],color[2],color[3],alpha))
	sprite:SetOwner(self.player)
	if IsValid(this) and isOwner(self,this) then
		sprite:SetParent( this )
	end
	
	sprite:SetNWFloat("sizex",sizex)
	sprite:SetNWFloat("sizey",sizey)

	sprite:Spawn()
	sprite:Activate()
	
	sprite:CallOnRemove("minus_sprite",function()
		SpritesCount=SpritesCount-1
	end)
	
	SpritesSpawnInSecond=SpritesSpawnInSecond+1
	SpritesCount=SpritesCount+1
	if SpritesSpawnInSecond==1 then
		timer.Simple( 1, function()
			SpritesSpawnInSecond=0
		end)
	end

	undo.Create("E2_sprite")
		undo.AddEntity(sprite)
		undo.SetPlayer(self.player)
	undo.Finish()

	return sprite
end


__e2setcost(200)
e2function entity entity:drawSprite(string mat,vector pos,vector color,number alpha,sizex,sizey)
	if !IsValid(this) then return nil end  
	if !isOwner(self,this) then return nil end  
	return E2_spawn_sprite(self,this,mat,pos,color,alpha,sizex,sizey)
end

e2function entity drawSprite(string mat,vector pos,vector color,number alpha,sizex,sizey)
	return E2_spawn_sprite(self,this,mat,pos,color,alpha,sizex,sizey)
end

__e2setcost(50)
e2function void entity:spriteSize(sizex,sizey)
	if !IsValid(this)  then return end
	if !isOwner(self,this)  then return end
	
	this:SetNWFloat("sizex",sizex)
	this:SetNWFloat("sizey",sizey)
end
---------------------------------------------------BEAMS
local sbox_E2_maxBeamPerSecond = CreateConVar( "sbox_E2_maxBeamPerSecond", "12", FCVAR_ARCHIVE )
local sbox_E2_maxBeam = CreateConVar( "sbox_E2_maxBeam", "300", FCVAR_ARCHIVE )
local BeamSpawnInSecond=0
local BeamCount=0

function E2_spawn_beam(self,this,ent,mat,pos,endpos,color,alpha,width,textstart,textend)

	if BeamSpawnInSecond >= sbox_E2_maxBeamPerSecond:GetInt() then return end
	if BeamCount >= sbox_E2_maxBeam:GetInt() then return end
	if mat == "" then return end
	if string.find(mat:lower(),"pp",1,true) then return end
	local beam=ents.Create("e2_beam")
	beam:SetModel("models/props_phx/huge/evildisc_corp.mdl")
	beam:SetMaterial(mat)
	beam:SetPos(Vector(pos[1],pos[2],pos[3]))
	beam:SetAngles(Angle(0,0,0))
	beam:SetColor(Color(color[1],color[2],color[3],alpha))
	beam:SetOwner(self.player)
	
	if IsValid(this) and isOwner(self,this) then
		beam:SetParent( this )
	end
	
	beam.mc = true
	
	if endpos!=nil then beam:SetNWVector("endpos",Vector( endpos[1],endpos[2],endpos[3] ) ) 
		beam.endpos=Vector( endpos[1],endpos[2],endpos[3] ) else beam.endpos=Vector(0,0,0) end
	if ent!=nil then beam:SetNWFloat("EndEnt",ent) beam.EndEnt=ent else beam.EndEnt=nil end
	
	beam:SetNWFloat("width",width)
	beam:SetNWFloat("TextStart",textstart)
	beam:SetNWFloat("TextEnd",textend)
		
	beam:Spawn()
	beam:Activate()
	
	beam:CallOnRemove("minus_beam",function()
		BeamCount=BeamCount-1
	end)
	
	BeamSpawnInSecond=BeamSpawnInSecond+1
	BeamCount=BeamCount+1
	if BeamSpawnInSecond==1 then
		timer.Simple( 1, function()
			BeamSpawnInSecond=0
		end)
	end
	
	undo.Create("E2_beam")
		undo.AddEntity(beam)
		undo.SetPlayer(self.player)
	undo.Finish()

	return beam
end

__e2setcost(200)
e2function entity entity:drawBeam(string mat,vector pos,vector endpos,vector color,number alpha,width,textstart,textend)
	if !IsValid(this) then return nil end  
	if !isOwner(self,this) then return nil end  
	return E2_spawn_beam(self,this,ent,mat,pos,endpos,color,alpha,width,textstart,textend)
end

e2function entity entity:drawBeam(string mat,vector pos,entity ent,vector color,number alpha,width,textstart,textend)
	if !IsValid(this) then return nil end  
	if !isOwner(self,this) then return nil end  
	return E2_spawn_beam(self,this,ent,mat,pos,endpos,color,alpha,width,textstart,textend)
end

e2function entity drawBeam(string mat,vector pos,vector endpos,vector color,number alpha,width,textstart,textend)
	return E2_spawn_beam(self,this,ent,mat,pos,endpos,color,alpha,width,textstart,textend)
end

e2function entity entity:drawBeam(string mat,vector pos,vector endpos,vector color,number alpha,width)
	if !IsValid(this) then return nil end  
	if !isOwner(self,this) then return nil end  
	return E2_spawn_beam(self,this,ent,mat,pos,endpos,color,alpha,width,1,1)
end

e2function entity entity:drawBeam(string mat,vector pos,entity ent,vector color,number alpha,width,textstart,textend)
	if !IsValid(this) then return nil end  
	if !isOwner(self,this) then return nil end  
	return E2_spawn_beam(self,this,ent,mat,pos,endpos,color,alpha,width,1,1)
end

e2function entity drawBeam(string mat,vector pos,vector endpos,vector color,number alpha,width)
	return E2_spawn_beam(self,this,ent,mat,pos,endpos,color,alpha,width,1,1)
end

__e2setcost(50)
e2function void entity:setBeamEndEnt(entity ent)
	if !IsValid(this) then return end  
	if !IsValid(ent) then return end  
	if !isOwner(self,this) then return end  
	if this.EndEnt!=ent then
		this:SetNWFloat("EndEnt",ent)
		this.EndEnt=ent
	end
end

e2function void entity:setBeamEndPos(vector endpos)
	if !IsValid(this)  then return end
	if !isOwner(self,this)  then return end
	this:SetNWVector("endpos",Vector( endpos[1],endpos[2],endpos[3] ) )
	this.mc = true
	this.endpos=Vector( endpos[1],endpos[2],endpos[3] )
end

e2function void entity:setBeamWidth(number width)
	if !IsValid(this)  then return end
	if !isOwner(self,this)  then return end
	this:SetNWFloat("width",width)
end

e2function void entity:setBeamText(number textstart,number textend)
	if !IsValid(this)  then return end
	if !isOwner(self,this)  then return end
	this:SetNWFloat("TextStart",textstart)
	this:SetNWFloat("TextEnd",textend)
end

------------------------------------------------------QUADS

local sbox_E2_maxQuadsPerSecond = CreateConVar( "sbox_E2_maxQuadsPerSecond", "12", FCVAR_ARCHIVE )
local sbox_E2_maxQuads = CreateConVar( "sbox_E2_maxQuads", "300", FCVAR_ARCHIVE )
local QuadsSpawnInSecond=0
local QuadsCount=0

function E2_spawn_quad(self,this,mat,pos,ang,color,alpha,sizex,sizey)
	
	if QuadsSpawnInSecond >= sbox_E2_maxQuadsPerSecond:GetInt() then return end
	if QuadsCount >= sbox_E2_maxQuads:GetInt() then return end
	if mat == "" then return end
	if string.find(mat:lower(),"pp",1,true) then return end
	local quad=ents.Create("e2_quad")
	quad:SetModel("models/hunter/plates/plate32x32.mdl")
	quad:SetMaterial(mat)
	quad:SetPos(Vector(pos[1],pos[2],pos[3]))
	quad:SetAngles(Angle(ang[1],ang[2],ang[3]))
	quad:SetColor(Color(color[1],color[2],color[3],alpha))
	quad:SetOwner(self.player)
	if IsValid(this) and isOwner(self,this) then
		quad:SetParent( this )
	end
	quad:SetNWFloat("sizex",sizex)
	quad:SetNWFloat("sizey",sizey)

	quad:Spawn()
	quad:Activate()
	
	quad:CallOnRemove("minus_quad",function()
		QuadsCount=QuadsCount-1
	end)
	
	QuadsSpawnInSecond=QuadsSpawnInSecond+1
	QuadsCount=QuadsCount+1
	if QuadsSpawnInSecond==1 then
		timer.Simple( 1, function()
			QuadsSpawnInSecond=0
		end)
	end
	
	undo.Create("E2_quad")
		undo.AddEntity(quad)
		undo.SetPlayer(self.player)
	undo.Finish()

	return quad
end

__e2setcost(200)
e2function entity entity:drawQuad(string mat,vector pos,angle ang,vector color,number alpha,sizex,sizey)
	if !IsValid(this) then return nil end  
	if !isOwner(self,this) then return nil end  
	return E2_spawn_quad(self,this,mat,pos,ang,color,alpha,sizex,sizey)
end

e2function entity drawQuad(string mat,vector pos,angle ang,vector color,number alpha,sizex,sizey)
	return E2_spawn_quad(self,this,mat,pos,ang,color,alpha,sizex,sizey)
end

__e2setcost(50)
e2function void entity:quadSize(sizex,sizey)
	if !IsValid(this)  then return end
	if !isOwner(self,this)  then return end
	
	this:SetNWFloat("sizex",sizex)
	this:SetNWFloat("sizey",sizey)
end

----------------------------------------------------------------------
__e2setcost(20)
e2function void ranger:drawPaint(string mat)
	util.Decal(mat,this.HitPos + this.HitNormal ,this.HitPos - this.HitNormal)
end

e2function void entity:drawShadow(status)
	if !IsValid(this) then return end
	if !isOwner(self,this) then return end
	this:DrawShadow( status!=0 )
end

e2function void entity:noDraw(status)
	if !IsValid(this) then return end
	if !isOwner(self,this) then return end
	this:SetNoDraw( status!=0 )
end