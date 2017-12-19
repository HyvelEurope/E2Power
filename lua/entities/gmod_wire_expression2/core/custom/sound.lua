-- made by [G-moder]FertNoN
-- modified by [AI]Ubi

util.AddNetworkString('E2SoundSendURL')

local VarsE2pTbl = {}
local MaxSoundPerSecond = CreateConVar( "sbox_e2_maxSoundurlPerSecond", "3", FCVAR_ARCHIVE )
local tempSound = 0 ts = tostring

local function explodeData(STR)
	return string.Explode(" ",STR,false)
end

local function umsgData(ply,com,arg)
	local Data = explodeData(arg[1])
	local PrepTbl = {}
	PrepTbl.id   = Data[1]
	PrepTbl.alen = tonumber(Data[2],10)
	PrepTbl.clen = tonumber(Data[3],10)
	PrepTbl.name = Data[4]

	VarsE2pTbl[PrepTbl.id] = PrepTbl
end
concommand.Add("_snddat",umsgData)

local function umsgFFT(ply,com,arg)
	local Data = explodeData(arg[1])
	local PrepTbl = {}
	for id = 2,#Data do
		local toid = string.byte(Data[id])
		if toid == 1 then PrepTbl[id-1] = 0
		else PrepTbl[id-1] = toid end
	end

	VarsE2pTbl[Data[1]].level = PrepTbl
end
concommand.Add("_sndfft",umsgFFT)

local function SoundURL(cmd, ent, id, volume, pos, url, noplay, tar, ply)
	plys = RecipientFilter()
	if ply==nil then plys:AddAllPlayers() else plys:AddPlayer(ply) end
	umsg.Start("e2soundURL", plys)
		umsg.Entity(ent)
		umsg.Entity(ent:GetPlayer())
		if type(id)=="string" then
			umsg.String(id)
		elseif type(id)=="number" then
			umsg.String(tostring(id))
		end

		if cmd=="load" then
			if !IsValid(tar) and (pos==nil || (pos[1]==0 and pos[2]==0 and pos[3]==0)) and not ent:GetPlayer():GetNWBool('E2PowerAccess') then umsg.Char(-1) umsg.End() return end
			if tempSound>MaxSoundPerSecond:GetInt() then umsg.Char(-1) umsg.End() return end
			tempSound=tempSound+1
			if tempSound==1 then timer.Simple( 1, function() tempSound=0 end) end
			umsg.Char(1)
			umsg.Char(volume)
			umsg.String(url)
				net.Start('E2SoundSendURL')
				net.WriteString(url)
				net.Broadcast()
			umsg.Char(noplay)
			if pos!=nil then umsg.Vector(Vector(pos[1],pos[2],pos[3])) else umsg.Vector(Vector(0,0,0)) end
			umsg.Entity(tar)
		end

		if cmd=="play" then
			umsg.Char(2)
		end

		if cmd=="stop" then
			umsg.Char(3)
		end

		if cmd=="volume" then
			umsg.Char(4)
			umsg.Char(math.Clamp(volume,0,1)*100)
		end

		if cmd=="pos" then
			umsg.Char(5)
			umsg.Vector(Vector(pos[1],pos[2],pos[3]))
		end

		if cmd=="del" then
			umsg.Char(6)
		end

		if cmd=="par" then
			umsg.Char(7)
			umsg.Entity(tar)
		end

		if cmd=="cls" then
			umsg.Char(0)
		end
	umsg.End()
end

local function sendRequest(ent,id)
	local EntId = ent:EntIndex()
	local RecFilt = RecipientFilter()

	RecFilt:AddPlayer(ent.player)
	umsg.Start("ai_e2_soundurl",RecFilt)
		umsg.Long(EntId)
		umsg.String(id)
	umsg.End()
end

local function returnFFT(ent,id)
	if VarsE2pTbl[id..ts(ent:EntIndex())] == nil then return {} end
	return VarsE2pTbl[id..ts(ent:EntIndex())].level
end

__e2setcost(10)

e2function array entity:soundFFT(string id)
	sendRequest(this,id)
	return returnFFT(this,id)
end

e2function array entity:soundFFT(id)
	sendRequest(this,id)
	return returnFFT(this,id)
end

e2function string entity:soundName(string id)
	sendRequest(this,id)
	if VarsE2pTbl[id..ts(this:EntIndex())] == nil then return "wait" end
	return VarsE2pTbl[ts(id)..ts(this:EntIndex())].name
end

e2function number entity:soundState(string id)
	sendRequest(this,id)
	if VarsE2pTbl[id..ts(this:EntIndex())] == nil then return 0 end
	return VarsE2pTbl[ts(id)..ts(this:EntIndex())].clen
end

e2function number entity:soundLength(string id)
	sendRequest(this,id)
    if VarsE2pTbl[id..ts(this:EntIndex())] == nil then return 0 end
	return VarsE2pTbl[ts(id)..ts(this:EntIndex())].alen
end
__e2setcost(100)

e2function void soundURLload(string id,string url,volume, noplay, vector pos)
	SoundURL("load", self.entity, id, volume, pos, url, noplay)
end

e2function void soundURLload(string id,string url, volume, noplay, entity tar)
	SoundURL("load", self.entity, id, volume, nil, url, noplay, tar)
end

e2function void entity:soundURLload(string id,string url, volume, noplay)
	SoundURL("load", self.entity, id, volume, nil, url, noplay, nil, this)
end

e2function void soundURLplay(string id)
	SoundURL("play", self.entity, id)
end

e2function void soundURLpause(string id)
	SoundURL("stop", self.entity, id)
end

e2function void soundURLvolume(string id, volume)
	SoundURL("volume", self.entity, id, volume)
end

e2function void soundURLpos(string id, vector pos)
	SoundURL("pos", self.entity, id, nil, pos)
end

e2function void soundURLparent(string id, entity tar)
	SoundURL("par", self.entity, id, nil, nil, nil, nil, tar)
end

e2function void soundURLdelete(string id)
	SoundURL("del", self.entity, id)
end

--
e2function void soundURLload(id,string url,volume, noplay, vector pos)
	SoundURL("load", self.entity, id, volume, pos, url, noplay)
end

e2function void soundURLload(id,string url, volume, noplay, entity tar)
	SoundURL("load", self.entity, id, volume, nil, url, noplay, tar)
end

e2function void entity:soundURLload(id,string url, volume, noplay)
	SoundURL("load", self.entity, id, volume, nil, url, noplay, nil, this)
end

e2function void soundURLplay(id)
	SoundURL("play", self.entity, id)
end

e2function void soundURLpause(id)
	SoundURL("stop", self.entity, id)
end

e2function void soundURLvolume(id, volume)
	SoundURL("volume", self.entity, id, volume)
end

e2function void soundURLpos(id, vector pos)
	SoundURL("pos", self.entity, id, nil, pos)
end

e2function void soundURLparent(id, entity tar)
	SoundURL("par", self.entity, id, nil, nil, nil, nil, tar)
end

e2function void soundURLdelete(id)
	SoundURL("del", self.entity, id)
end
--

e2function void soundURLPurge()
	SoundURL("clr", self.entity,0)
end

e2function void soundPlayAll(string path,volume,pitch)
	local path = path:Trim()
	if string.find(path:lower(),"loop",1,true) then return end

	local pitch = math.Clamp(pitch,0,255)
	local volume = math.Clamp(volume,0,100)/100
	for _, ply in ipairs( player.GetAll() ) do
		ply:EmitSound(path, 75, pitch, volume, CHAN_AUTO)
	end
end

e2function void soundPlayWorld(string path,vector pos,distance,pitch,volume)
	local path=path:Trim()
	if string.find(path:lower(),"loop",1,true) then return end
	distance=math.Clamp(distance,20,140)
	sound.Play(path,Vector(pos[1],pos[2],pos[3]),distance,pitch,volume)
end

__e2setcost(5)
e2function void entity:soundPlaySingle(string path, number volume, number pitch)
	if !IsValid(this) then return end
	local path=path:Trim()
	if string.find(path:lower(),"loop",1,true) then return end
	this:EmitSound(path, 75, math.Clamp(pitch,0,255), math.Clamp(volume,0,127)/127, CHAN_AUTO)
end
