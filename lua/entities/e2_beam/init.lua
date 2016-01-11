AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:DrawShadow( false )
end

function ENT:Think()

	if self.EndEnt!=nil then 
		if !self.EndEnt:IsValid() then self.EndEnt=nil return end
		self.endpos=self.EndEnt:GetPos() 
		self.mc=true  
	end
	
	if self.mc then
		self.mc = false
		local Ang = (self.endpos-self:GetPos()):Angle()
		if self:GetAngles() != Ang then 
			self:SetAngles(Ang)
		end
	end
	
end