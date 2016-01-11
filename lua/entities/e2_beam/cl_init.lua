include('shared.lua')     

function ENT:Initialize()
		self.Glow = Material(self:GetMaterial())
		self.Glow:SetInt("$spriterendermode",9)
		self.Glow:SetInt("$ignorez",1)
		self.Glow:SetInt("$illumfactor",8)
		self.Glow:SetFloat("$alpha",1)
		self.Glow:SetInt("$nocull",1)
end

function ENT:Draw()
	self.EndEnt=self:GetNWEntity("EndEnt")
	if self.EndEnt:IsValid() then self.endpos=self.EndEnt:GetPos() else self.endpos=self:GetNWVector("endpos") end 
	render.SetMaterial(self.Glow)
	render.DrawBeam(self:GetPos(), self.endpos, self:GetNWFloat("width"), self:GetNWFloat("TextStart"), self:GetNWFloat("TextEnd"), self:GetColor())
end
