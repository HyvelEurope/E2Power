--E2EMPTY
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:DrawShadow( false )
	self:SetNoDraw( true )
end