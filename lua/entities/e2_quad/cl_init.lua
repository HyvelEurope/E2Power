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
	render.SetMaterial(self.Glow)
	render.DrawQuadEasy( self:GetPos(),self:GetUp(), self:GetNWFloat("sizey"), self:GetNWFloat("sizey"),self:GetColor(),90) 
end