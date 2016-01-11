__e2setcost(200)

CreateConVar("sbox_e2_constraints","0")

local function Weldit(self, ent1, ent2, nc, fl)
    if IsValid(ent1) and IsValid(ent2) and type(ent1)!="Player" and type(ent2)!="Player" then
        if ent1==ent2 then return end
        if isOwner(self, ent1) and isOwner(self, ent2) then
            local welded = constraint.Weld(ent1, ent2, 0, 0, fl, tobool(nc))
                undo.Create("Weld")
                undo.AddEntity(welded)
                undo.SetPlayer( self.player )
                undo.Finish()
                self.player:AddCleanup( "constraints", welded )
        else return end
    else return end
end

e2function void entity:weldTo(entity ent,number nocollide)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    Weldit(self, this, ent, nocollide, forcelimit)
end

e2function void entity:weldTo(entity ent,number forcelimit,number nocollide)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    Weldit(self, this, ent, nocollide, forcelimit)
end

local function AxisIt(self, ent1, ent2, lpos1, lpos2, fl, tl, fric, nc, laxis)
    if IsValid(ent1) and IsValid(ent2) and type(ent1)!="Player" and type(ent2)!="Player" then
        if isOwner(self, ent1) and isOwner(self, ent2) then
            local axis = constraint.Axis(ent1, ent2, 0, 0, lpos1, lpos2, fl, tl, fric, nc, laxis)
                undo.Create("Axis")
                undo.AddEntity(axis)
                undo.SetPlayer( self.player )
                undo.Finish()
                self.player:AddCleanup( "constraints", axis )
        else return end
    else return end
end

e2function void entity:axisTo(entity ent2,vector localposition1,vector localposition2,number forcelimit,number torquelimit,number friction,number nocollide,vector localaxis)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    if this==ent2 then return end
    local lpos1 = Vector(localposition1[1],localposition1[2],localposition1[3])
    local lpos2 = Vector(localposition2[1],localposition2[2],localposition2[3])
    if lpos2 == Vector(0,0,0) then
        lpos2 = lpos1
    end
    local laxis = Vector(localaxis[1],localaxis[2],localaxis[3])
    AxisIt(self, this, ent2, lpos1, lpos2, forcelimit, torquelimit, friction, nocollide, laxis)
end

e2function void entity:ropeTo(entity ent2,vector localposition1,vector localposition2,number addlength,number forcelimit,number width,string material,number rigid)
    if !IsValid(this) or !IsValid(ent2) then return end
	local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    local lpos1 = Vector(localposition1[1],localposition1[2],localposition1[3])
    local lpos2 = Vector(localposition2[1],localposition2[2],localposition2[3])
    local wpos1 = this:LocalToWorld(lpos1)
    local wpos2 = ent2:LocalToWorld(lpos2)
    if material==""    then material = "cable/cable2" end
    
    if IsValid(this) and IsValid(ent2) and type(this)!="Player" and type(ent2)!="Player" then
        if isOwner(self, this) and isOwner(self, ent2) then
            local length = (wpos1-wpos2):Length()
            local rope = constraint.Rope( this, ent2, 0, 0, lpos1, lpos2, length, addlength, forcelimit, width, material, tobool(rigid) )
                undo.Create("rope")
                undo.AddEntity(rope)
                undo.SetPlayer( self.player )
                undo.Finish()
                self.player:AddCleanup( "constraints", rope )
        else return end
    else return end
end

e2function void entity:setPhysProp(string material,number gravity)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
	if !IsValid(this) then return end
    if this:IsPlayer() then return end
	if !isOwner(self,this) then return end
    construct.SetPhysProp( self.player, this, 0, nil,  { GravityToggle = tobool(gravity), Material = material } )
    --DoPropSpawnedEffect( this )
end

local function BallsocketIt(self, ent1, ent2, LPos, forcelimit, torquelimit, nocollide )
    if IsValid(ent1) and IsValid(ent2) and type(ent1)!="Player" and type(ent2)!="Player" then
        if isOwner(self, ent1) and isOwner(self, ent2) and ent1!=ent2 then
            local Ballsocket = constraint.Ballsocket(ent1,ent2,0,0,LPos,forcelimit,torquelimit,nocollide)
                undo.Create("ballsocket")
                undo.AddEntity(Ballsocket)
                undo.SetPlayer( self.player )
                undo.Finish()
                self.player:AddCleanup( "constraints", Ballsocket )
        else return end
    else return end
end

e2function void entity:ballsocketTo(entity ent,vector localposition,number forcelimit,number torquelimit,number nocollide)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    local lpos = Vector(localposition[1],localposition[2],localposition[3])
    BallsocketIt(self, this, ent, lpos, forcelimit, torquelimit, nocollide)
end

e2function void entity:ballsocketTo(entity ent,number nocollide)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    local lpos = Vector(0,0,0)
    BallsocketIt(self, this, ent, lpos, forcelimit, torquelimit, nocollide)
end

e2function void entity:removeAllConstraints()
	if IsValid(this) then 
		if isOwner(self,this) and validPhysics(this) then
			pcall( function() constraint.RemoveAll(this) end )
		else return end
	end
end

e2function void entity:removeConstraint(string constraintname)
    if IsValid(this) then 
		if isOwner(self,this) and validPhysics(this) then
			constraint.RemoveConstraints( this, constraintname )
		else return end
	end
end

e2function void entity:noCollideAll(number)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    if isOwner(self,this) and IsValid(this) then
        if number!=1 then
            this:SetCollisionGroup( COLLISION_GROUP_NONE )    
        else
            this:SetCollisionGroup( COLLISION_GROUP_WORLD )        
        end
    else return end
end

e2function void entity:noCollide(entity ent)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
	if !IsValid(this) then return end
	if !validPhysics(this) then return end
	if !IsValid(ent) then return end
	if !validPhysics(ent) then return end
    if isOwner(self,this) and this!=ent then
        local NoCollide = constraint.NoCollide(this, ent, 0, 0)
        undo.Create("NoCollide")
        undo.AddEntity( NoCollide )
        undo.SetPlayer( ply )
        undo.Finish()
        ply:AddCleanup( "nocollide", NoCollide )
    else return end
end

e2function void entity:sliderTo(entity ent, vector localpos1, vector localpos2, number width)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    if isOwner(self,this) and this!=ent then
        local LPos1 = Vector(localpos1[1],localpos1[2],localpos1[3])
        local LPos2 = Vector(localpos2[1],localpos2[2],localpos2[3])
        local Num = math.Clamp(width,0,25)
        local constraint,rope = constraint.Slider( this, ent, 0, 0, LPos1, LPos2, Num )

        undo.Create("Slider")
        undo.AddEntity( constraint )
        if rope then undo.AddEntity( rope ) end
        undo.SetPlayer( ply )
        undo.Finish()
        ply:AddCleanup( "ropeconstraints", constraint )
        ply:AddCleanup( "ropeconstraints", rope )
    else return end
end

e2function void entity:elasticTo(entity ent, vector localpos1, vector localpos2, number constant, number damping, number rdamping, string material, number width, number stretchonly )
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    if isOwner(self,this) and this!=ent then
        local LPos1 = Vector(localpos1[1],localpos1[2],localpos1[3])
        local LPos2 = Vector(localpos2[1],localpos2[2],localpos2[3])
        local Num = math.Clamp(width,0,25)
            if not material then
                local Mat = "cable/cable2"
            else
                local Mat = material
            end
        local constraint = constraint.Elastic( this, ent, 0, 0, LPos1, LPos2, constant, damping, rdamping, Mat, width, stretchonly )

        undo.Create("Elastic")
        undo.AddEntity( constraint )
        if rope then undo.AddEntity( rope ) end
        undo.SetPlayer( ply )
        undo.Finish()
        
        ply:AddCleanup( "ropeconstraints", constraint )
        if rope then ply:AddCleanup( "ropeconstraints", rope ) end
    else return end
end

e2function void entity:unConstrain()
	if !IsValid(this) then return end
    if !validPhysics(this) then return end
	if !isOwner(self,this) then return end
	pcall( function() constraint.RemoveAll(this) end )
end

local function Weldit2(self, ent1, ent2, bone1, bone2, nc, fl)
    if IsValid(ent1) and IsValid(ent2) and type(ent1)!="Player" and type(ent2)!="Player" then
        if isOwner(self, ent1) and isOwner(self, ent2) then
			if ent1==ent2 and bone1==bone2 then return end
            local welded = constraint.Weld(ent1, ent2, bone1, bone2, fl, tobool(nc))
                undo.Create("Weld")
                undo.AddEntity(welded)
                undo.SetPlayer( self.player )
                undo.Finish()
                self.player:AddCleanup( "constraints", welded )
        else return end
    else return end
end

e2function void entity:weldTo(entity ent,number bone1,number bone2,number forcelimit)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    Weldit2(self, this, ent, bone1, bone2, nocollide, forcelimit)
end

e2function void entity:weldTo(entity ent,number bone1,number forcelimit)
    local ply = self.player
    if GetConVar("sbox_e2_constraints"):GetInt() == 1 then
        if not ply:IsAdmin() then return end
    end
    Weldit2(self, this, ent, bone1, 0, nocollide, forcelimit)
end

-------------Poser
e2function void entity:inflator(number Bone, Scale)
	if !IsValid(this) then return end 
	if this:GetClass() != "prop_ragdoll" then return end
	if ( !Bone ) then return end
	
	local Bone = this:TranslatePhysBoneToBone(this:LookupBone(this:GetBoneName(Bone)))
	Scale = math.Clamp( Scale, -50, 500 )
	this:ManipulateBoneScale(Bone, Vector(Scale,Scale,Scale) )
end
/*
e2function vector entity:inflatorGetSize(number Bone)
	if !IsValid(this) then return end 
	if this:GetClass() != "prop_ragdoll" then return end
	if ( !Bone ) then return end
	local Bone = this:TranslatePhysBoneToBone(this:LookupBone(this:GetBoneName(Bone)))
	return this:GetBoneScale( Bone ) 
end
*/
local Clamp = math.Clamp 

e2function void entity:facePoser(array Values)
	if !IsValid(this) then return end 
	if this:GetClass() != "prop_ragdoll" then return end
	for i=0, 64 do
		this:SetFlexWeight( i, string.format( "%.3f", Clamp(Values[i+1],0,1) ) )
	end
end

e2function void entity:facePoser(Flex, Value)
	if !IsValid(this) then return end 
	if this:GetClass() != "prop_ragdoll" then return end
	this:SetFlexWeight( Clamp(Flex,0,64), string.format( "%.3f", Clamp(Value,0,1) ) )
end

e2function void entity:facePoserScale(Value)
	if !IsValid(this) then return end 
	if this:GetClass() != "prop_ragdoll" then return end
	this:SetFlexScale( Clamp(Value,-1,20) )
end

e2function number entity:getfacePoserValue(k)
	if !IsValid(this) then return 0 end 
	if this:GetClass() != "prop_ragdoll" then return 0 end
	return this:GetFlexWeight(k)
end

e2function void entity:eyePoser(vector Pos)
	if !IsValid(this) then return end 
	if this:GetClass() != "prop_ragdoll" then return end
	local eyeattachment = this:LookupAttachment( "eyes" )
	if ( eyeattachment == 0 ) then return end
	local attachment = this:GetAttachment( eyeattachment )
	if ( !attachment ) then return end
	local LocalPos, LocalAng = WorldToLocal( Pos, Angle(0,0,0), attachment.Pos, attachment.Ang )
	if (!LocalPos) then return false end
	
	this:SetEyeTarget( LocalPos )
end


e2function void entity:fingerPoser(index,vector2 Var)
	if !IsValid(this) then return end 
	if this:GetClass() != "prop_ragdoll" then return end
	local Ang = Angle( tonumber(Var[1]), tonumber(Var[2]) )
		
	if ( index < 3 ) then
		Ang = Angle( tonumber(Var[2]), tonumber(Var[1]) )		
	end
	
	this:SetNetworkedAngle( "Finger".. index, Ang )
	duplicator.StoreEntityModifier( this, "finger", { [index] = Ang } )
end


e2function vector2 entity:getfingerPoserVar(index)
	if !IsValid(this) then return end 
	if this:GetClass() != "prop_ragdoll" then return end
	local Ang = this:GetNetworkedAngle( "Finger".. index)
	
	local Vec = { tonumber(Ang[1]), tonumber(Ang[2]) }
		
	if ( index < 3 ) then
		Vec = {tonumber(Ang[2]), tonumber(Ang[1]) }
	end
	return Vec
end

__e2setcost(20)
e2function number entity:isNoCollideAll()
    if !IsValid(this) then return end
    return this:GetCollisionGroup() == COLLISION_GROUP_WORLD and 1 or 0 
end
