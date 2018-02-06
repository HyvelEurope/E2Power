/// E2Power Control Menu
/// Made by SkyAngeLoL
///
if SERVER then return end
///
local BackColor=Color(0,170,150,255)
/// Don't Change this font! it my font lib !
surface.CreateFont("SkyDermaArial_I_17",{
	font="Default",
	size=17,
	weight=1000,
	antialias=true,
	italic=false,
})
///
function GetPlyAccess(ply)
	if not ply:IsValid() then return end
	return ply:GetNWBool("E2PowerAccess",false)
end
///
local function E2Power_BuildPanel(Panel)
	Panel:ClearControls()
	//
	if not LocalPlayer():IsSuperAdmin() then
		//
		Panel.StateText=vgui.Create("DLabel")
			Panel.StateText:SetColor(BackColor)
			Panel.StateText:SetFont("SkyDermaArial_I_17")
			Panel.StateText:SetText("Ваш E2P статус: "..tostring(GetPlyAccess(LocalPlayer())))
			Panel.StateText:SizeToContents()
		Panel:AddItem(Panel.StateText)
		//
		local CrosLine=vgui.Create('DPanelList')
			CrosLine:SetSize(200,2)
			CrosLine.Paint=function() draw.RoundedBox(0,0,0,CrosLine:GetWide(),CrosLine:GetTall(),BackColor) end
		Panel:AddItem(CrosLine)
		//
		Panel.UserPanel=vgui.Create('DPanelList')
			Panel.UserPanel:SetPadding(1)
			Panel.UserPanel:SetSpacing(1)
			Panel.UserPanel:SetAutoSize(true)
			Panel.UserPanel.Paint=function()
				draw.RoundedBox(0,0,0,Panel.UserPanel:GetWide(),Panel.UserPanel:GetTall(),BackColor)
			end
		Panel:AddItem(Panel.UserPanel)
		//
		Panel.PassBox=vgui.Create("DTextEntry")
			Panel.PassBox:SetText("Введите пароль")
			Panel.PassBox:SetSize(200,22)
			Panel.PassBox:SelectAllOnFocus()
		Panel.UserPanel:AddItem(Panel.PassBox)
		//
		Panel.PassBut=vgui.Create("DButton")
			Panel.PassBut:SetText("Ок")
			Panel.PassBut:SetSize(200,18)
			Panel.PassBut.DoClick=function()
				local Pass=Panel.PassBox:GetValue()
				RunConsoleCommand("e2power_pass",Pass)
				timer.Simple(0.2,function() Panel.StateText:SetText("Ваш E2P статус: "..tostring(GetPlyAccess(LocalPlayer()))) end)
			end
		Panel.UserPanel:AddItem(Panel.PassBut)
		//
		Panel.GetListBut=vgui.Create("DButton")
			Panel.GetListBut:SetText("Список игроков с E2P")
			Panel.GetListBut:SetSize(200,18)
			Panel.GetListBut.DoClick=function()
				for _,ply in pairs(player.GetAll()) do
					local Access = GetPlyAccess(ply)
					chat.AddText(ply:Nick()..' - ', Access and Color(65, 255, 65) or Color(255, 65, 65), tostring(Access))
				end
			end
		Panel.UserPanel:AddItem(Panel.GetListBut)
		//
		return
	end
	////////////////////
	/// Player panel
	Panel.PlayerText=vgui.Create("DLabel")
		Panel.PlayerText:SetColor(BackColor)
		Panel.PlayerText:SetFont("SkyDermaArial_I_17")
		Panel.PlayerText:SetText("Игроки")
		Panel.PlayerText:SizeToContents()
	Panel:AddItem(Panel.PlayerText)
	//
	Panel.PlayerPanel=vgui.Create('DPanelList')
		Panel.PlayerPanel:SetPadding(1)
		Panel.PlayerPanel:SetSpacing(1)
		Panel.PlayerPanel:SetAutoSize(true)
		Panel.PlayerPanel.Paint=function()
			draw.RoundedBox(0,0,0,Panel.PlayerPanel:GetWide(),Panel.PlayerPanel:GetTall(),BackColor)
		end
	Panel:AddItem(Panel.PlayerPanel)
	//
	Panel.PlyList=vgui.Create('DListView')
		Panel.PlyList:SetSize(100,150)
		Panel.PlyList:AddColumn("Ник")
		Panel.PlyList:AddColumn("Доступ"):SetFixedWidth(60)
		Panel.PlyList:SetMultiSelect(false)
		Panel.PlyList.LoadPlyList=function(self)
			Panel.PlyList:Clear()
			for _,ply in pairs(player.GetAll()) do
				Panel.PlyList:AddLine(ply:Nick(),tostring(GetPlyAccess(ply)))
			end
		end
		Panel.PlyList.OnClickLine=function(parent,line,isselected)
			local Pl=line:GetValue(1)
			local Stat=tobool(line:GetValue(2))
			local ContMenu=DermaMenu()
				if not Stat then
					ContMenu:AddOption("Выдать доступ",function()
						RunConsoleCommand('e2power_give_access',Pl)
						timer.Simple(0.2,function() Panel.PlyList.LoadPlyList() end)
					end)
				else
					ContMenu:AddOption("Отнять доступ",function()
						RunConsoleCommand('e2power_remove_access',Pl)
						timer.Simple(0.2,function() Panel.PlyList.LoadPlyList() end)
					end)
				end
			ContMenu:Open()
		end
	Panel.PlyList.LoadPlyList()
	Panel.PlayerPanel:AddItem(Panel.PlyList)
	//
	Panel.RemoveAllBut=vgui.Create("DButton")
		Panel.RemoveAllBut:SetText("Отнять доступ у всех игроков")
		Panel.RemoveAllBut:SetSize(200,18)
		Panel.RemoveAllBut.DoClick=function()
			RunConsoleCommand('e2power_all_remove_access')
			timer.Simple(0.2,function() Panel.PlyList.LoadPlyList() end)
		end
	Panel.PlayerPanel:AddItem(Panel.RemoveAllBut)
	/////////////////////
	/// Other function panel
	Panel.OptionText=vgui.Create("DLabel")
		Panel.OptionText:SetColor(BackColor)
		Panel.OptionText:SetFont("SkyDermaArial_I_17")
		Panel.OptionText:SetText("Редактор пароля")
		Panel.OptionText:SizeToContents()
	Panel:AddItem(Panel.OptionText)
	//
	Panel.FuncPanel=vgui.Create('DPanelList')
		Panel.FuncPanel:SetPadding(1)
		Panel.FuncPanel:SetSpacing(1)
		Panel.FuncPanel:SetAutoSize(true)
		Panel.FuncPanel.Paint=function()
			draw.RoundedBox(0,0,0,Panel.FuncPanel:GetWide(),Panel.FuncPanel:GetTall(),BackColor)
		end
	Panel:AddItem(Panel.FuncPanel)
	//
	Panel.DisPassBut=vgui.Create("DButton")
		Panel.DisPassBut:SetText("Отключить пароль")
		Panel.DisPassBut:SetSize(200,18)
		Panel.DisPassBut.DoClick=function()
			RunConsoleCommand('e2power_disable_pass')
			timer.Simple(0.2,function() Panel.PlyList.LoadPlyList() end)
		end
	Panel.FuncPanel:AddItem(Panel.DisPassBut)
	//
	Panel.GetPassBut=vgui.Create("DButton")
		Panel.GetPassBut:SetText("Получить пароль")
		Panel.GetPassBut:SetSize(200,18)
		Panel.GetPassBut.DoClick=function()
			RunConsoleCommand('e2power_get_pass')
		end
	Panel.FuncPanel:AddItem(Panel.GetPassBut)
	//
	Panel.PassBox=vgui.Create("DTextEntry")
		Panel.PassBox:SetText("Введите новый пароль")
		Panel.PassBox:SetSize(200,22)
		Panel.PassBox:SelectAllOnFocus()
	Panel.FuncPanel:AddItem(Panel.PassBox)
	//
	Panel.PassBut=vgui.Create("DButton")
		Panel.PassBut:SetText("Установить пароль")
		Panel.PassBut:SetSize(200,18)
		Panel.PassBut.DoClick=function()
			local NewPass=Panel.PassBox:GetValue()
			if NewPass!="Enter new password" then
				RunConsoleCommand("e2power_set_pass",NewPass)
			else
				LocalPlayer():ChatPrint('[E2Power]: Enter normal pass!!')
			end
		end
	Panel.FuncPanel:AddItem(Panel.PassBut)
	/////////////////////
	/// Groups panel
	Panel.GroupText=vgui.Create("DLabel")
		Panel.GroupText:SetColor(BackColor)
		Panel.GroupText:SetFont("SkyDermaArial_I_17")
		Panel.GroupText:SetText("Группы с доступом")
		Panel.GroupText:SizeToContents()
	Panel:AddItem(Panel.GroupText)
	//
	Panel.GroupPanel=vgui.Create('DPanelList')
		Panel.GroupPanel:SetPadding(1)
		Panel.GroupPanel:SetSpacing(1)
		Panel.GroupPanel:SetAutoSize(true)
		Panel.GroupPanel.Paint=function()
			draw.RoundedBox(0,0,0,Panel.GroupPanel:GetWide(),Panel.GroupPanel:GetTall(),BackColor)
		end
	Panel:AddItem(Panel.GroupPanel)
	//
	Panel.GroupList=vgui.Create('DListView')
		Panel.GroupList:SetSize(200,100)
		Panel.GroupList:AddColumn("Название группы")
		Panel.GroupList:SetMultiSelect(false)
		Panel.GroupList.LoadGroupList=function(self)
			Panel.GroupList:Clear()
			local Groups=util.JSONToTable(GetGlobalString("E2PowerGroupList")) or {}
			for _,group in pairs(Groups) do
				Panel.GroupList:AddLine(group)
			end
		end
		Panel.GroupList.OnClickLine=function(parent,line,isselected)
			local Group=line:GetValue(1)
			local ContMenu=DermaMenu()
				ContMenu:AddOption("Удалить группу",function()
					RunConsoleCommand('e2power_remove_access_group',Group)
					timer.Simple(0.2,function()
						Panel.GroupList.LoadGroupList()
						Panel.PlyList.LoadPlyList()
					end)
				end)
			ContMenu:Open()
		end
	Panel.GroupList.LoadGroupList()
	Panel.GroupPanel:AddItem(Panel.GroupList)
	//
	Panel.GroupBox=vgui.Create("DTextEntry")
		Panel.GroupBox:SetText("Введите название группы")
		Panel.GroupBox:SetSize(200,22)
		Panel.GroupBox:SelectAllOnFocus()
	Panel.GroupPanel:AddItem(Panel.GroupBox)
	//
	Panel.GroupBut=vgui.Create("DButton")
		Panel.GroupBut:SetText("Создать")
		Panel.GroupBut:SetSize(200,18)
		Panel.GroupBut.DoClick=function()
			local NewName=Panel.GroupBox:GetValue()
			if NewName!="Enter new group name" then
				RunConsoleCommand("e2power_give_access_group",NewName)
				Panel.GroupBox:SetText("Enter new group name")
				timer.Simple(0.2,function()
					Panel.GroupList.LoadGroupList()
					Panel.PlyList.LoadPlyList()
				end)
			else
				LocalPlayer():ChatPrint('[E2P]: Введите нормальный пароль!')
			end
		end
	Panel.GroupPanel:AddItem(Panel.GroupBut)
	/////////////////////
	/// Version and Logo
	local E2PVersion=GetGlobalString("E2PowerVersion")
	Panel.VersionText=vgui.Create("DLabel")
		Panel.VersionText:SetColor(BackColor)
		Panel.VersionText:SetFont("SkyDermaArial_I_17")
		Panel.VersionText:SetText("Версия: "..E2PVersion)
		Panel.VersionText:SizeToContents()
	Panel:AddItem(Panel.VersionText)
	//
	Panel.LogoPanel=vgui.Create('DPanelList')
		Panel.LogoPanel:SetNoSizing(true)
		Panel.LogoPanel:SetAutoSize(true)
		Panel.LogoPanel.Paint=nil
	Panel:AddItem(Panel.LogoPanel)
	//
	Panel.Logo=vgui.Create('DPanel')
		Panel.Logo:SetSize(250,250)
		Panel.Logo.Paint=function()
			surface.SetTexture(surface.GetTextureID("expression 2/cog"))
			surface.SetDrawColor(BackColor)
			surface.DrawTexturedRectRotated(Panel.Logo:GetWide()/2,Panel.Logo:GetTall()/2,Panel.Logo:GetWide()-2,Panel.Logo:GetTall()-2,RealTime()*20)
		end
	Panel.LogoPanel:AddItem(Panel.Logo)
	//
	local CrosLine=vgui.Create('DPanelList')
		CrosLine:SetSize(200,2)
		CrosLine.Paint=function() draw.RoundedBox(0,0,0,CrosLine:GetWide(),CrosLine:GetTall(),BackColor) end
	Panel:AddItem(CrosLine)
	//
	Panel.VersionText=vgui.Create("DLabel")
		Panel.VersionText:SetColor(BackColor)
		Panel.VersionText:SetFont("SkyDermaArial_I_17")
		Panel.VersionText:SetText(" FertNoN - склеил чужие аддоны\n SkyAngeLoL - меню\n Tengz - перевод и доработка\n Zimon4eR - дополнение и доработка")
		Panel.VersionText:SizeToContents()
	Panel:AddItem(Panel.VersionText)
	////////
	///////
	if !E2Power_Panel then
		E2Power_Panel=Panel
	end
end
///
function E2Power_SMO()
	if E2Power_Panel then
		E2Power_BuildPanel(E2Power_Panel)
	end
end
hook.Add("SpawnMenuOpen","E2Power_SpawnMenuOpen",E2Power_SMO)
///
hook.Add("PopulateToolMenu","E2Power_PopulateToolMenu",function()
	spawnmenu.AddToolMenuOption("Utilities","E2Power","Menu","E2Power","","",E2Power_BuildPanel)
end)
/// ULX Integr
/// Don't remove this if you not use ULX !
for name,data in pairs(hook.GetTable()) do
	if name=="UCLChanged" then
		hook.Add("UCLChanged","E2Power_Update",E2Power_SMO)
		break
	end
end
