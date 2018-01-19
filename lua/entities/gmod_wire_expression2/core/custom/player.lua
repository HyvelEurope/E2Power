-- made by [G-moder]FertNoN
-- edit by Zimon4eR

__e2setcost(200)
e2function void entity:setWeaponColor(vector rgb) -- Zimon4eR
	if !IsValid(this)  then return end
	if !this:IsPlayer() then return end
	if !isOwner(self, this) then return end
	local Vec = Vector(0,0,0)
	Vec[1] = isNan(rgb[1]) and 0 or math.Clamp(rgb[1], 0, 255)/255
	Vec[2] = isNan(rgb[2]) and 0 or math.Clamp(rgb[2], 0, 255)/255
	Vec[3] = isNan(rgb[3]) and 0 or math.Clamp(rgb[3], 0, 255)/255
	this:SetWeaponColor(Vec)
end

e2function void entity:setPlayerColor(vector rgb) -- Zimon4eR
	if !IsValid(this)  then return end
	if !this:IsPlayer() then return end
	if !isOwner(self, this) then return end
	local Vec = Vector(0,0,0)
	Vec[1] = isNan(rgb[1]) and 0 or math.Clamp(rgb[1], 0, 255)/255
	Vec[2] = isNan(rgb[2]) and 0 or math.Clamp(rgb[2], 0, 255)/255
	Vec[3] = isNan(rgb[3]) and 0 or math.Clamp(rgb[3], 0, 255)/255
	this:SetPlayerColor(Vec)
end

e2function vector entity:getWeaponColor() -- Zimon4eR
	if !IsValid(this)  then return end
	if !this:IsPlayer() then return end
	local Vec = this:GetWeaponColor()*255
	return {math.floor(Vec[1]),math.floor(Vec[2]),math.floor(Vec[3])}
end

e2function vector entity:getPlayerColor() -- Zimon4eR
	if !IsValid(this)  then return end
	if !this:IsPlayer() then return end
	local Vec = this:GetPlayerColor()*255
	return {math.floor(Vec[1]),math.floor(Vec[2]),math.floor(Vec[3])}
end
__e2setcost(20)
e2function void entity:playerFreeze()
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
        this:Lock()
end

e2function void entity:playerUnFreeze()
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
       this:UnLock()
end

e2function number entity:hasGodMode()
	if !IsValid(this) then return 0 end
	if !this:IsPlayer() then return 0 end
	return this:HasGodMode() and 1 or 0
end

e2function void entity:playerRemove()
	if !self.player:IsAdmin() then return end
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end
    this:Remove()
end

e2function void entity:playerSetAlpha(rv2)
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	if !this:IsPlayer() then return end
	local r,g,b = this:GetColor()
	this:SetColor(r, g, b, math.Clamp(rv2, 0, 255))
end

e2function void entity:playerNoclip(status)
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	if !this:IsPlayer() then return end
	if status!=0 then
		this:SetMoveType( MOVETYPE_NOCLIP )
	else
		this:SetMoveType( MOVETYPE_WALK )
	end
end

e2function number entity:playerIsRagdoll()
	if !IsValid(this) then return 0 end
	if !this:IsPlayer() then return 0 end
	return IsValid(this.ragdoll) and 1 or 0
end

__e2setcost(100)
e2function void entity:playerModel(string model)
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	if !this:IsPlayer() then return end
	local modelname = player_manager.TranslatePlayerModel( model )
	util.PrecacheModel( modelname )
	this:SetModel( modelname )
end

e2function vector entity:playerBonePos(Index)
	if !IsValid(this) then return {0,0,0} end
	if !this:IsPlayer() then return {0,0,0} end 
	local bonepos, boneang = this:GetBonePosition(this:TranslatePhysBoneToBone(Index))
	if bonepos == nil then return {0,0,0} 
	else return bonepos end
end

e2function angle entity:playerBoneAng(Index)
	if !IsValid(this) then return {0,0,0} end
	if !this:IsPlayer() then return {0,0,0} end 
	local bonepos, boneang = this:GetBonePosition(this:TranslatePhysBoneToBone(Index))
	if boneang == nil then return {0,0,0} 
	else return {boneang.Yaw,boneang.Pitch,boneang.Roll} end
end

e2function vector entity:playerBonePos(string boneName)
	if !IsValid(this) then return {0,0,0} end
	if !this:IsPlayer() then return {0,0,0} end 
	local bonepos, boneang = this:GetBonePosition(this:LookupBone(boneName))
	if bonepos == nil then return {0,0,0} 
	else return bonepos end
end

e2function angle entity:playerBoneAng(string boneName)
	if !IsValid(this) then return {0,0,0} end
	if !this:IsPlayer() then return {0,0,0} end 
	local bonepos, boneang = this:GetBonePosition(this:LookupBone(boneName))
	if boneang == nil then return {0,0,0} 
	else return {boneang.Yaw,boneang.Pitch,boneang.Roll} end
end

e2function number entity:lookUpBone(string boneName)
	if !IsValid(this) then return -1 end
	return this:LookupBone(boneName) or -1
end

e2function void entity:playerSetBoneAng(Index,angle ang)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end 
	if !isOwner(self, this) then end
	if isNan(ang[1]) or isNan(ang[2]) or isNan(ang[3]) then return end
	this:ManipulateBoneAngles(Index,Angle(ang[1],ang[2],ang[3]))
end

e2function void entity:playerSetBoneAng(string boneName ,angle ang)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return end 
	if !isOwner(self, this) then end
	if isNan(ang[1]) or isNan(ang[2]) or isNan(ang[3]) then return end
	this:ManipulateBoneAngles( this:LookupBone(boneName) ,Angle(ang[1],ang[2],ang[3]))
end

e2function void playerSetBoneAng(Index,angle ang)
	self.player:ManipulateBoneAngles(Index,Angle(ang[1],ang[2],ang[3]))	
end

e2function void playerSetBoneAng(string boneName ,angle ang)
	self.player:ManipulateBoneAngles(self.player:LookupBone(boneName),Angle(ang[1],ang[2],ang[3]))	
end

__e2setcost(15000)
e2function entity entity:playerRagdoll()
	if !IsValid(this) then return end
	if !isOwner(self, this) then return end
	if !this:IsPlayer() then return end 
	if !this:Alive() then return end
	if this:InVehicle() then this:ExitVehicle()	end
	local v = this

	if !IsValid(v.ragdoll) then

		local ragdoll = ents.Create( "prop_ragdoll" )
		ragdoll.ragdolledPly = v
		ragdoll:SetPos( v:GetPos() )
		local velocity = v:GetVelocity()
		ragdoll:SetAngles( v:GetAngles() )
		ragdoll:SetModel( v:GetModel() )
		ragdoll:Spawn()
		ragdoll:Activate()
		v:SetParent( ragdoll )
			
		local j = 1
		while true do 
			local phys_obj = ragdoll:GetPhysicsObjectNum( j )
			if phys_obj then
				phys_obj:SetVelocity( velocity )
				j = j + 1
			else
				break
			end
		end

		v:Spectate( OBS_MODE_CHASE )
		v:SpectateEntity( ragdoll )
		v:StripWeapons() 

		v.ragdoll = ragdoll
		
		return ragdoll
	else
		v:SetParent()
		v:UnSpectate()

		local ragdoll = v.ragdoll
		v.ragdoll = nil 
		if ragdoll:IsValid() then 
			
			local pos = ragdoll:GetPos()
			pos.z = pos.z + 10 

			v:Spawn()
			v:SetPos( pos )
			v:SetVelocity( ragdoll:GetVelocity() )
			local yaw = ragdoll:GetAngles().yaw
			v:SetAngles( Angle( 0, yaw, 0 ) )
			ragdoll:Remove()
		end
	
		return self.player
	end
end

__e2setcost(20)

e2function void entity:plyRunSpeed(number speed)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	speed=math.Clamp(speed, 0, 90000)
	if (speed > 0) then
		this:SetRunSpeed(speed)
	else
		this:SetRunSpeed(500)
	end
end

e2function void entity:plyWalkSpeed(number speed)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	speed=math.Clamp(speed, 0, 90000)
	if (speed > 0) then
		this:SetWalkSpeed(speed)
	else
		this:SetWalkSpeed(250)
	end
end

e2function void entity:plyJumpPower(number power)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	power=math.Clamp(power, 0, 90000)
	if (power > 0) then
		this:SetJumpPower(power)
	else
		this:SetJumpPower(160)
	end
end

e2function void entity:plyCrouchWalkSpeed(number speed)
	if !IsValid(this)  then return end
	if !isOwner(self, this)  then return end
	if !this:IsPlayer() then return end
	speed=math.Clamp(speed, 0.01, 10)
	this:SetCrouchedWalkSpeed(speed)
end

e2function number entity:plyGetMaxSpeed()
	if not IsValid(this) then return end
	if !this:IsPlayer() then return end
	return this:GetMaxSpeed()
end

e2function number entity:plyGetJumpPower()
	if not IsValid(this) then return end
	if !this:IsPlayer() then return end
	return this:GetJumpPower()
end
