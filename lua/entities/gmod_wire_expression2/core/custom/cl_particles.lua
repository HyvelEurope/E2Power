local Clamp = math.Clamp
local Bounce = {}
local Gravity = {}
local Collision = {}
local ValidParticle = {}
local em       = ParticleEmitter(Vector(0,0,0))

local function get_bounce(message)
    nom = message:ReadEntity()
    Bounce[nom] = message:ReadLong()
end
local function get_collision(message)
    nom = message:ReadEntity()
    local Collide = message:ReadLong()
    if (Collide != 0) then Collision[nom] = true else Collision[nom] = false end
end
local function get_gravity(message)
    nom = message:ReadEntity()
    Gravity[nom] = message:ReadVector()
end

function use_message(message)
	
	local Ent       = message:ReadEntity()
	local RollDelta = message:ReadChar()
	local StartAlpha= message:ReadChar()
	local EndAlpha  = message:ReadChar()
	local StartSize = message:ReadShort()
	local Duration  = message:ReadFloat()
	local EndSize   = message:ReadFloat()
	local Pitch     = message:ReadFloat()
	
	local centr    = message:ReadVector()
	local Color    = message:ReadVector()
    local Vel      = message:ReadVector()
    
	local PartType = message:ReadString()	
    	
    if(em!=nil) then
		local part     = em:Add(PartType,centr)
        part:SetColor(Color[1],Color[2],Color[3],255)
        part:SetVelocity(Vel)
        part:SetDieTime(Clamp(Duration, 0.01, 60))
        part:SetStartSize(Clamp(StartSize,1,3000))
        part:SetEndSize(Clamp(EndSize,0.1,3000))
        part:SetAngles(Angle(Pitch,0,0)) 
		part:SetRollDelta(RollDelta)
		part:SetStartAlpha(StartAlpha+128) 
		part:SetEndAlpha(EndAlpha+128)

        if(Gravity[Ent]==nil) then Gravity[Ent] = Vector(0,0,-9.8) end
        if(Collision[Ent]==nil) then Collision[Ent] = true end
        if(Bounce[Ent]==nil) then Bounce[Ent] = 0.3 end

        part:SetGravity(Gravity[Ent])
        part:SetCollide(Collision[Ent])
        part:SetBounce(Bounce[Ent])   
    end
end

usermessage.Hook("e2p_bounce", get_bounce)
usermessage.Hook("e2p_collide", get_collision)
usermessage.Hook("e2p_gravity", get_gravity)
usermessage.Hook("e2p_pm", use_message)