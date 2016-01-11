local HUD_Elements = {}
local V_HUD_Elements = {}

local Fonds = {
"DebugFixed",
"DebugFixedSmall",
"Default",
"Marlett",
"Trebuchet18",
"Trebuchet24",
"HudHintTextLarge",
"HudHintTextSmall",
"CenterPrintText",
"HudSelectionText",
"CloseCaption_Normal",
"CloseCaption_Bold",
"CloseCaption_BoldItalic",
"ChatFont",
"TargetID",
"TargetIDSmall",
"HL2MPTypeDeath",
"BudgetLabel",
"DermaDefault",
"DermaDefaultBold",
"DermaLarge"}

local function draw_elements( v )
	for i = 0, table.maxn( v ) do
		if v[i] then
			local element = v[i]
			if element.type == "text" then 
				draw.DrawText( element.text, Fonds[element.size] , element.x, element.y, Color( element.color.x, element.color.y, element.color.z, element.alpha ), element.align ) 
			elseif element.type == "rbox" then
				draw.RoundedBox( element.bsize, element.x, element.y, element.w, element.h, Color( element.color.x, element.color.y, element.color.z, element.alpha ) )
			elseif element.type == "rect" then
				surface.SetDrawColor( element.color.x, element.color.y, element.color.z, element.alpha )
				surface.DrawRect( element.x, element.y, element.w, element.h )
			elseif element.type == "line" then
				surface.SetDrawColor( element.color.x, element.color.y, element.color.z, element.alpha )
				surface.DrawLine( element.x, element.y, element.ex, element.ey )
			elseif element.type == "poly" then
				local vertexes = {}
				for n = 1, element.vertexes do
					vertexes[n] = {}
					vertexes[n].x = element["x"..n]
					vertexes[n].y = element["y"..n]
				end
				surface.SetDrawColor( element.color.x, element.color.y, element.color.z, element.alpha )
				surface.DrawPoly( vertexes )
			end
		end
	end
end
	
hook.Add( "HUDPaint", "expression2_renderhud", function( )
	for k,v in pairs( HUD_Elements ) do
		if k and k:IsValid() then
			draw_elements( v )
		else
			v = nil
		end
	end	
	for k,v in pairs( V_HUD_Elements ) do
		if LocalPlayer():GetVehicle() and LocalPlayer():GetVehicle():IsValid() and LocalPlayer():GetVehicle():IsVehicle() then	
			if k and k:IsValid() then
				draw_elements( v )
			else
				v = nil
			end
		else
			V_HUD_Elements = {}
		end
	end	
end )

usermessage.Hook( "expression2_add_hud_element", function( um )
	local vehicle = um:ReadBool()
	local index = um:ReadShort()
	local element_type = um:ReadString()
	local ent = um:ReadEntity()
	local percents = um:ReadBool()
	local element
	
	if !vehicle then
		if !HUD_Elements[ent] then HUD_Elements[ent] = {} end
		HUD_Elements[ent][index] = {}
		element = HUD_Elements[ent][index]
	else
		if !V_HUD_Elements[ent] then V_HUD_Elements[ent] = {} end
		V_HUD_Elements[ent][index] = {}
		element = V_HUD_Elements[ent][index]
	end
	
	element.type = element_type
	
	if element_type == "text" then
		element.text = um:ReadString()
		if percents then
			element.x = ( ScrW() / 100 ) * um:ReadShort()
			element.y = ( ScrH() / 100 ) * um:ReadShort()
		else
			element.x = um:ReadShort()
			element.y = um:ReadShort()
		end
		element.color = um:ReadVector()
		element.alpha = um:ReadShort()
		element.align = um:ReadShort()
		element.size = um:ReadShort()
	elseif element_type == "rbox" then
		element.bsize = um:ReadShort()
		if percents then
			element.x = ( ScrW() / 100 ) * um:ReadShort()
			element.y = ( ScrH() / 100 ) * um:ReadShort()
			element.w = ( ScrW() / 100 ) * um:ReadShort()
			element.h  = ( ScrH() / 100 ) * um:ReadShort()
		else
			element.x = um:ReadShort()
			element.y = um:ReadShort()
			element.w = um:ReadShort()
			element.h = um:ReadShort()
		end
		element.color = um:ReadVector()
		element.alpha = um:ReadShort()
	elseif element_type == "rect" then
		if percents then
			element.x = ( ScrW() / 100 ) * um:ReadShort()
			element.y = ( ScrH() / 100 ) * um:ReadShort()
			element.w = ( ScrW() / 100 ) * um:ReadShort()
			element.h = ( ScrH() / 100 ) * um:ReadShort()
		else
			element.x = um:ReadShort()
			element.y = um:ReadShort()
			element.w = um:ReadShort()
			element.h = um:ReadShort()
		end
		element.color = um:ReadVector()
		element.alpha = um:ReadShort()
	elseif element_type == "line" then
		if percents then
			element.x = ( ScrW() / 100 ) * um:ReadShort()
			element.y = ( ScrH() / 100 ) * um:ReadShort()
			element.ex = ( ScrW() / 100 ) * um:ReadShort()
			element.ey = ( ScrH() / 100 ) * um:ReadShort()
		else
			element.x = um:ReadShort()
			element.y = um:ReadShort()
			element.ex = um:ReadShort()
			element.ey = um:ReadShort()
		end
		element.color = um:ReadVector()
		element.alpha = um:ReadShort()
	elseif element_type == "poly" then
		element.vertexes = um:ReadShort()
		for i = 1, element.vertexes do
			if percents then
				element["x"..i] = ( ScrW() / 100 ) * um:ReadShort()
				element["y"..i] = ( ScrH() / 100 ) * um:ReadShort()
			else
				element["x"..i] = um:ReadShort()
				element["y"..i] = um:ReadShort()
			end
		end
		element.color = um:ReadVector()
		element.alpha = um:ReadShort()
	end
end )

usermessage.Hook( "expression2_remove_hud_element", function( um )
	local vehicle = um:ReadBool()
	local ent = um:ReadEntity()
	
	if !vehicle then
		if ent and HUD_Elements[ent] and type( HUD_Elements[ent] ) == "table" then
			HUD_Elements[ent][um:ReadShort()] = nil
		end
	else
		if ent and V_HUD_Elements[ent] and type( V_HUD_Elements[ent] ) == "table" then
			V_HUD_Elements[ent][um:ReadShort()] = nil
		end
	end
end )

usermessage.Hook( "expression2_remove_all_elements", function( um )
	local vehicle = um:ReadBool()
	local ent = um:ReadEntity()
	
	if !vehicle then
		if ent and HUD_Elements[ent] and type( HUD_Elements[ent] ) == "table" then
			HUD_Elements[ent] = nil
		end
	else
		if ent and V_HUD_Elements[ent] and type( V_HUD_Elements[ent] ) == "table" then
			V_HUD_Elements[ent] = nil
		end
	end
end )
