//By: {iG} I_am_McLovin\\

local function Update_Timer( self )
	local hud = self.data.huddraw
	
	if ( CurTime() - hud.lastcheck ) >= 1 then
		hud.lastcheck = CurTime()
		hud.remaining = 15
	end
	
	if hud.remaining > 0 then
		hud.remaining = hud.remaining - 1
		return true
	else
		return false
	end
end

local function Send_Text( index, recipient, ent, percent, text, x, y, color, alpha, align, size, vehicle )
	umsg.Start( "expression2_add_hud_element", recipient )
		umsg.Bool( vehicle )
		umsg.Short( index )
		umsg.String( "text" )
		umsg.Entity( ent )
		umsg.Bool( percent )
		umsg.String( text )
		umsg.Short( x )
		umsg.Short( y )
		umsg.Vector( color )
		umsg.Short( alpha )
		umsg.Short( align )
		umsg.Short( size )
	umsg.End()
end

local function Send_Rbox( index, recipient, ent, percent, border, x, y, width, height, color, alpha, vehicle )
	umsg.Start( "expression2_add_hud_element", recipient )
		umsg.Bool( vehicle )
		umsg.Short( index )
		umsg.String( "rbox" )
		umsg.Entity( ent )
		umsg.Bool( percent )
		umsg.Short( border )
		umsg.Short( x )
		umsg.Short( y )
		umsg.Short( width )
		umsg.Short( height )
		umsg.Vector( color )
		umsg.Short( alpha )
	umsg.End()
end

local function Send_Rect( index, recipient, ent, percent, x, y, width, height, color, alpha, vehicle )
	umsg.Start( "expression2_add_hud_element", recipient )
		umsg.Bool( vehicle )
		umsg.Short( index )
		umsg.String( "rect" )
		umsg.Entity( ent )
		umsg.Bool( percent )
		umsg.Short( x )
		umsg.Short( y )
		umsg.Short( width )
		umsg.Short( height )
		umsg.Vector( color )
		umsg.Short( alpha )
	umsg.End()
end

local function Send_Line( index, recipient, ent, percent, x, y, ex, ey, color, alpha, vehicle )
	umsg.Start( "expression2_add_hud_element", recipient )
		umsg.Bool( vehicle )
		umsg.Short( index )
		umsg.String( "line" )
		umsg.Entity( ent )
		umsg.Bool( percent )
		umsg.Short( x )
		umsg.Short( y )
		umsg.Short( ex )
		umsg.Short( ey )
		umsg.Vector( color )
		umsg.Short( alpha )
	umsg.End()
end

local function Send_Poly( index, recipient, ent, percent, amt, verts, color, alpha, vehicle )
	umsg.Start( "expression2_add_hud_element", recipient )
		umsg.Bool( vehicle )
		umsg.Short( index )
		umsg.String( "poly" )
		umsg.Entity( ent )
		umsg.Bool( percent )
		umsg.Short( amt )
		for n = 1, amt do
			umsg.Short( verts[n][1] )
			umsg.Short( verts[n][2] )
		end
		umsg.Vector( color )
		umsg.Short( alpha )
	umsg.End()
end

registerFunction( "hudDrawText", "nsnnvnnn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8)
	if !Update_Timer( self ) then return end
	rv1 = math.floor( rv1 )
	if rv1 < 1 then return end
	if string.len( rv2 ) > 150 then return end
	rv3 = math.Clamp( rv3, 0, 100 )
	rv4 = math.Clamp( rv4, 0, 100 )
	rv7 = math.Clamp( rv7, 0, 5 )
	rv8 = math.Clamp( rv8, 1, 15 )
	rv8 = 16 - rv8
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	Send_Text( rv1, self.player, self.entity, true, rv2, rv3, rv4, Vector( rv5[1], rv5[2], rv5[3] ), rv6, rv7, rv8, false )
end )

registerFunction( "hudDrawTextPixels", "nsnnvnnn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8)
	if !Update_Timer( self ) then return end
	rv1 = math.floor( rv1 )
	if rv1 < 1 then return end
	if string.len( rv2 ) > 150 then return end
	rv7 = math.Clamp( rv7, 0, 5 )
	rv8 = math.Clamp( rv8, 1, 15 )
	rv8 = 16 - rv8
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	Send_Text( rv1, self.player, self.entity, false, rv2, rv3, rv4, Vector( rv5[1], rv5[2], rv5[3] ), rv6, rv7, rv8, false )
end )

registerFunction( "hudDrawText", "e:nsnnvnnn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8,op9 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8,rv9 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8),op9[1](self, op9)
	if !Update_Timer( self ) then return end
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	rv2 = math.floor( rv2 )
	if rv2 < 1 then return end
	if string.len( rv3 ) > 150 then return end
	rv4 = math.Clamp( rv4, 0, 100 )
	rv5 = math.Clamp( rv5, 0, 100 )
	rv8 = math.Clamp( rv8, 0, 5 )
	rv9 = math.Clamp( rv9, 1, 15 )
	rv9 = 16 - rv9
	Send_Text( rv2, rv1, self.entity, true, rv3, rv4, rv5, Vector( rv6[1], rv6[2], rv6[3] ), rv7, rv8, rv9, true )
end )

registerFunction( "hudDrawTextPixels", "e:nsnnvnnn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8,op9 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8,rv9 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8),op9[1](self, op9)
	if !Update_Timer( self ) then return end
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	rv2 = math.floor( rv2 )
	if rv2 < 1 then return end
	if string.len( rv3 ) > 150 then return end
	rv8 = math.Clamp( rv8, 0, 5 )
	rv9 = math.Clamp( rv9, 1, 15 )
	rv9 = 16 - rv9
	Send_Text( rv2, rv1, self.entity, false, rv3, rv4, rv5, Vector( rv6[1], rv6[2], rv6[3] ), rv7, rv8, rv9, true )
end )

registerFunction( "hudDrawRBox", "nnnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8)
	if !Update_Timer( self ) then return end
	rv1 = math.floor( rv1 )
	if rv1 < 1 then return end
	rv3 = math.Clamp( rv3, 0, 100 )
	rv4 = math.Clamp( rv4, 0, 100 )
	rv5 = math.Clamp( rv5, 0, 100 )
	rv6 = math.Clamp( rv6, 0, 100 )
	rv8 = math.Clamp( rv8, 0, 255 )
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	Send_Rbox( rv1, self.player, self.entity, true, rv2, rv3, rv4, rv5, rv6, Vector( rv7[1], rv7[2], rv7[3] ), rv8, false )
end )

registerFunction( "hudDrawRBoxPixels", "nnnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8)
	if !Update_Timer( self ) then return end
	rv1 = math.floor( rv1 )
	if rv1 < 1 then return end
	rv8 = math.Clamp( rv8, 0, 255 )
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	Send_Rbox( rv1, self.player, self.entity, false, rv2, rv3, rv4, rv5, rv6, Vector( rv7[1], rv7[2], rv7[3] ), rv8, false )
end )

registerFunction( "hudDrawRBox", "e:nnnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8,op9 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8,rv9 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8),op9[1](self, op9)
	if !Update_Timer( self ) then return end
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	rv2 = math.floor( rv2 )
	if rv2 < 1 then return end
	rv4 = math.Clamp( rv4, 0, 100 )
	rv5 = math.Clamp( rv5, 0, 100 )
	rv6 = math.Clamp( rv6, 0, 100 )
	rv7 = math.Clamp( rv7, 0, 100 )
	rv9 = math.Clamp( rv9, 0, 255 )
	Send_Rbox( rv2, rv1, self.entity, true, rv3, rv4, rv5, rv6, rv7, Vector( rv8[1], rv8[2], rv8[3] ), rv9, true )
end )

registerFunction( "hudDrawRBoxPixels", "e:nnnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8,op9 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8,rv9 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8),op9[1](self, op9)
	if !Update_Timer( self ) then return end
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	rv2 = math.floor( rv2 )
	if rv2 < 1 then return end
	rv9 = math.Clamp( rv9, 0, 255 )
	Send_Rbox( rv2, rv1, self.entity, false, rv3, rv4, rv5, rv6, rv7, Vector( rv8[1], rv8[2], rv8[3] ), rv9, true )
end )

registerFunction( "hudDrawRect", "nnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7 = args[2],args[3],args[4],args[5],args[6],args[7],args[8]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7)
	if !Update_Timer( self ) then return end
	rv1 = math.floor( rv1 )
	if rv1 < 1 then return end
	rv2 = math.Clamp( rv2, 0, 100 )
	rv3 = math.Clamp( rv3, 0, 100 )
	rv4 = math.Clamp( rv4, 0, 100 )
	rv5 = math.Clamp( rv5, 0, 100 )
	rv7 = math.Clamp( rv7, 0, 255 )
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	Send_Rect( rv1, self.player, self.entity, true, rv2, rv3, rv4, rv5, Vector( rv6[1], rv6[2], rv6[3] ), rv7, false )
end )

registerFunction( "hudDrawRectPixels", "nnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7 = args[2],args[3],args[4],args[5],args[6],args[7],args[8]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7)
	if !Update_Timer( self ) then return end
	rv1 = math.floor( rv1 )
	if rv1 < 1 then return end
	rv7 = math.Clamp( rv7, 0, 255 )
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	Send_Rect( rv1, self.player, self.entity, false, rv2, rv3, rv4, rv5, Vector( rv6[1], rv6[2], rv6[3] ), rv7, false )
end )

registerFunction( "hudDrawRect", "e:nnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8)
	if !Update_Timer( self ) then return end
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	rv2 = math.floor( rv2 )
	if rv2 < 1 then return end
	rv3 = math.Clamp( rv3, 0, 100 )
	rv4 = math.Clamp( rv4, 0, 100 )
	rv5 = math.Clamp( rv5, 0, 100 )
	rv6 = math.Clamp( rv6, 0, 100 )
	rv8 = math.Clamp( rv8, 0, 255 )
	Send_Rect( rv2, rv1, self.entity, true, rv3, rv4, rv5, rv6, Vector( rv7[1], rv7[2], rv7[3] ), rv8, true )
end )

registerFunction( "hudDrawRectPixels", "e:nnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8)
	if !Update_Timer( self ) then return end
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	rv2 = math.floor( rv2 )
	if rv2 < 1 then return end
	rv8 = math.Clamp( rv8, 0, 255 )
	Send_Rect( rv2, rv1, self.entity, false, rv3, rv4, rv5, rv6, Vector( rv7[1], rv7[2], rv7[3] ), rv8, true )
end )

registerFunction( "hudDrawLine", "nnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7 = args[2],args[3],args[4],args[5],args[6],args[7],args[8]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7)
	if !Update_Timer( self ) then return end
	rv1 = math.floor( rv1 )
	if rv1 < 1 then return end
	rv2 = math.Clamp( rv2, 0, 100 )
	rv3 = math.Clamp( rv3, 0, 100 )
	rv4 = math.Clamp( rv4, 0, 100 )
	rv5 = math.Clamp( rv5, 0, 100 )
	rv7 = math.Clamp( rv7, 0, 255 )
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	Send_Line( rv1, self.player, self.entity, true, rv2, rv3, rv4, rv5, Vector( rv6[1], rv6[2], rv6[3] ), rv7, false )
end )

registerFunction( "hudDrawLinePixels", "nnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7 = args[2],args[3],args[4],args[5],args[6],args[7],args[8]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7)
	if !Update_Timer( self ) then return end
	rv1 = math.floor( rv1 )
	if rv1 < 1 then return end
	rv7 = math.Clamp( rv7, 0, 255 )
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	Send_Line( rv1, self.player, self.entity, false, rv2, rv3, rv4, rv5, Vector( rv6[1], rv6[2], rv6[3] ), rv7, false )
end )

registerFunction( "hudDrawLine", "e:nnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8)
	if !Update_Timer( self ) then return end
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	rv2 = math.floor( rv2 )
	if rv2 < 1 then return end
	rv3 = math.Clamp( rv3, 0, 100 )
	rv4 = math.Clamp( rv4, 0, 100 )
	rv5 = math.Clamp( rv5, 0, 100 )
	rv6 = math.Clamp( rv6, 0, 100 )
	rv8 = math.Clamp( rv8, 0, 255 )
	Send_Line( rv2, rv1, self.entity, true, rv3, rv4, rv5, rv6, Vector( rv7[1], rv7[2], rv7[3] ), rv8, true )
end )

registerFunction( "hudDrawLinePixels", "e:nnnnnvn", "", function(self, args)
	local op1,op2,op3,op4,op5,op6,op7,op8 = args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]
	local rv1,rv2,rv3,rv4,rv5,rv6,rv7,rv8 = op1[1](self, op1),op2[1](self, op2),op3[1](self, op3),op4[1](self, op4),op5[1](self, op5),op6[1](self, op6),op7[1](self, op7),op8[1](self, op8)
	if !Update_Timer( self ) then return end
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	rv2 = math.floor( rv2 )
	if rv2 < 1 then return end
	rv8 = math.Clamp( rv8, 0, 255 )
	Send_Line( rv2, rv1, self.entity, false, rv3, rv4, rv5, rv6, Vector( rv7[1], rv7[2], rv7[3] ), rv8, true )
end )

for i = 3, 16 do
	local str = ""
	for n = 1, i do
		str = str.."xv2"
	end
	
	registerFunction( "hudDrawPoly", "n"..str.."vn", "", function(self, args)
		local rv = {}
		local verts = {}
		if !Update_Timer( self ) then return end
		for n = 1, i + 3 do
			rv[n] = args[n+1][1](self, args[n+1])
		end
		rv[1] = math.floor( rv[1] )
		if rv[1] < 1 then return end
		for n = 2, i + 1 do
			rv[n] = { math.Clamp( rv[n][1], 0, 100 ), math.Clamp( rv[n][2], 0, 100 ) }
			verts[n-1] = rv[n]
		end
		rv[i+3] = math.Clamp( rv[i+3], 0, 255 )
		if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
		Send_Poly( rv[1], self.player, self.entity, true, i, verts, Vector( rv[i+2][1], rv[i+2][2], rv[i+2][3] ), rv[i+3], false )
	end )
	
	registerFunction( "hudDrawPolyPixels", "n"..str.."vn", "", function(self, args)
		local rv = {}
		local verts = {}
		if !Update_Timer( self ) then return end
		for n = 1, i + 3 do
			rv[n] = args[n+1][1](self, args[n+1])
		end
		rv[1] = math.floor( rv[1] )
		if rv[1] < 1 then return end
		for n = 2, i + 1 do
			verts[n-1] = rv[n]
		end
		rv[i+3] = math.Clamp( rv[i+3], 0, 255 )
		if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
		Send_Poly( rv[1], self.player, self.entity, false, i, verts, Vector( rv[i+2][1], rv[i+2][2], rv[i+2][3] ), rv[i+3], false )
	end )
	
	registerFunction( "hudDrawPoly", "e:n"..str.."vn", "", function(self, args)
		local rv = {}
		local verts = {}
		if !Update_Timer( self ) then return end
		for n = 1, i + 4 do
			rv[n] = args[n+1][1](self, args[n+1])
		end
		if !rv[1] or !rv[1]:IsValid() or !rv[1]:IsPlayer() or !rv[1]:GetVehicle() or !rv[1]:GetVehicle():IsValid() or !rv[1]:GetVehicle():IsVehicle() then return end
		rv[2] = math.floor( rv[2] )
		if rv[2] < 1 then return end
		for n = 3, i + 2 do
			rv[n] = { math.Clamp( rv[n][1], 0, 100 ), math.Clamp( rv[n][2], 0, 100 ) }
			verts[n-2] = rv[n]
		end
		rv[i+4] = math.Clamp( rv[i+4], 0, 255 )
		Send_Poly( rv[2], rv[1], self.entity, true, i, verts, Vector( rv[i+3][1], rv[i+3][2], rv[i+3][3] ), rv[i+4], true )
	end )
	
	registerFunction( "hudDrawPolyPixels", "e:n"..str.."vn", "", function(self, args)
		local rv = {}
		local verts = {}
		if !Update_Timer( self ) then return end
		for n = 1, i + 4 do
			rv[n] = args[n+1][1](self, args[n+1])
		end
		if !rv[1] or !rv[1]:IsValid() or !rv[1]:IsPlayer() or !rv[1]:GetVehicle() or !rv[1]:GetVehicle():IsValid() or !rv[1]:GetVehicle():IsVehicle() then return end
		rv[2] = math.floor( rv[2] )
		if rv[2] < 1 then return end
		for n = 3, i + 2 do
			verts[n-2] = rv[n]
		end
		rv[i+4] = math.Clamp( rv[i+4], 0, 255 )
		Send_Poly( rv[2], rv[1], self.entity, false, i, verts, Vector( rv[i+3][1], rv[i+3][2], rv[i+3][3] ), rv[i+4], true )
	end )
end
	
registerFunction( "hudRemoveElement", "n", "", function(self, args)
	local op1 = args[2]
	local rv1 = op1[1](self, op1)
	rv1 = math.floor( rv1 )
	if rv1 < 1 then return end
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	umsg.Start( "expression2_remove_hud_element", self.player )
		umsg.Bool( false )
		umsg.Entity( self.entity )
		umsg.Short( rv1 )
	umsg.End()
end )

registerFunction( "hudRemoveElement", "e:n", "", function(self, args)
	local op1,op2 = args[2],args[3]
	local rv1,rv2 = op1[1](self, op1),op2[1](self, op2)
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	rv2 = math.floor( rv2 )
	if rv2 < 1 then return end
	umsg.Start( "expression2_remove_hud_element", rv1 )
		umsg.Bool( true )
		umsg.Entity( self.entity )
		umsg.Short( rv2 )
	umsg.End()
end )

registerFunction( "hudClear", "", "", function(self, args)
	if !self.player or !self.player:IsValid() or !self.player:IsPlayer() or !self.entity or !self.entity:IsValid() then return end
	umsg.Start( "expression2_remove_all_elements", self.player )
		umsg.Bool( false )
		umsg.Entity( self.entity )
	umsg.End()
end )

registerFunction( "hudClear", "e:", "", function(self, args)
	local op1 = args[2]
	local rv1 = op1[1](self, op1)
	if !rv1 or !rv1:IsValid() or !rv1:IsPlayer() or !rv1:GetVehicle() or !rv1:GetVehicle():IsValid() or !rv1:GetVehicle():IsVehicle() then return end
	umsg.Start( "expression2_remove_all_elements", rv1 )
		umsg.Bool( true )
		umsg.Entity( self.entity )
	umsg.End()
end )

registerCallback( "construct", function( self )
	self.data.huddraw = { lastcheck = CurTime(), remaining = 30 }
end )

registerCallback( "destruct", function( self )

end )
