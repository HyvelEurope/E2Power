--E2_DYNAMIC_PROP
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:PhysicsSetup()	
	constraint.RemoveAll( self )
	
	
	
	
	if self.sphere!=nil then 
		local r=self.sphere
		self:PhysicsInitSphere(r)
		self:SetCollisionBounds(Vector(-r,-r,-r),Vector(r,r,r))
	else
		
		local scale = self.size
		local angles = Angle(0,0,0)

		local min_x = -scale.x
		local min_y = -scale.y
		local min_z = -scale.z
	
		local max_x = scale.x
		local max_y = scale.y
		local max_z = scale.z
		
		local beg = Vector(min_x, min_y, min_z)
		local ends = Vector(max_x, max_y, max_z)
		
		beg:Rotate(angles)
		ends:Rotate(angles)
		self:PhysicsInitBox(beg,ends)
		self:SetCollisionBounds(beg,ends)
	end	
	
end

function ENT:Initialize()
	self:DrawShadow( false )
	self:PhysicsSetup()
end



/*
function ENT:Initialize()
	local angles = self:GetAngles();
	
	local size = self.size
	
	self:PhysicsInitBox(size/2,size/2)
	
	--beg:Rotate(angles)
	--ends:Rotate(angles)
	
	--self:SetCollisionBounds(beg,ends)
	
	self:DrawShadow( false )
end
*/