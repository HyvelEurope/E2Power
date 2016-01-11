/* 


 _______ ___       _______   _______ .______      .___  ___.      ___      
|   ____|__ \     |       \ |   ____||   _  \     |   \/   |     /   \     
|  |__     ) |    |  .--.  ||  |__   |  |_)  |    |  \  /  |    /  ^  \    
|   __|   / /     |  |  |  ||   __|  |      /     |  |\/|  |   /  /_\  \   
|  |____ / /_     |  '--'  ||  |____ |  |\  \----.|  |  |  |  /  _____  \  
|_______|____|    |_______/ |_______|| _| `._____||__|  |__| /__/     \__\

                        __        __         
   ____ ___  ____ _____/ /__     / /_  __  __
  / __ `__ \/ __ `/ __  / _ \   / __ \/ / / /
 / / / / / / /_/ / /_/ /  __/  / /_/ / /_/ / 
/_/ /_/ /_/\__,_/\__,_/\___/  /_.___/\__, /  
                                    /____/ 
                                    
  _________              _____  _____       
 /   _____/ ____  __ ___/ ____\/ ____\__.__.
 \_____  \ /    \|  |  \   __\\   __<   |  |
 /        \   |  \  |  /|  |   |  |  \___  |
/_______  /___|  /____/ |__|   |__|  / ____|
        \/     \/                    \/  



HOLY FUCKING SHIT ITS DERMA!!!! YAY!!!
ok, so i remade it....


*/

local catch = {}
local rec = {}


//***********basic sender************\\
function sendDermaStuff(tbl,pl,e2 , pod)
if catch[e2]          == nil then return end
if catch[e2].dontsend then return end
if catch[e2].panels   == nil then return end 
if catch[e2].holders  == nil then return end
//if CurTime( ) - catch[e2].time > 1 then pod = true ; catch[e2].time = CurTime( ) ; print("?")end


//    local T = {}
//    if pod != nil then T = table.Copy( tbl ) else T = table_dif(tbl,catch[e2].old) end
//    catch[e2].old = table.Copy(  tbl )

/*
    datastream.StreamToClients( pl,  
    "dermaStuff",                    
    {                                
    e = e2,                          
    t = tbl,                         
    p = catch[e2].panels,            
    h = catch[e2].holders            
    });
    
*/

if pod != nil then catch[e2].old = nil end

local new = tbl
local old = catch[e2].old

if old == nil then old = {} end




    for k,v in pairs(catch[e2].panels) do
        if diff(new[k],old[k]) then user_msg(new[k],k,pl,e2) end 
    end
    for k,v in pairs(catch[e2].holders) do
        if diff(new[k],old[k]) then user_msg(new[k],k,pl,e2) end
    end
    for k,v in pairs(catch[e2].tabs) do
        if diff(new[k],old[k]) then user_msg(new[k],k,pl,e2) end 
    end
    for k,v in pairs(new) do
        if v.type != "dTab" && v.type != "dPanel" && v.type != "dTabHolder" && diff(v,old[k]) then user_msg(v,k,pl,e2) end
    end
	
	catch[e2].old = table.Copy( tbl )
end

function diff(v1,v2)
   if v2 == nil then return true end
   if type(v1) != type(v2) then return true end
   if type(v1) == "table" then 
       for k,v in pairs(v1) do
           if diff(v , v2[k]) then return true end
       end
   end
   if v1 != v2 then return true end
   return false
end

--require("glon")
--util.AddNetworkString("dermaStuff")
util.AddNetworkString("dermaStuff_datastream_backup")
function user_msg(tbl,k,pl,e2)
--	local s = util.TableToJSON(tbl)
--	local s = glon.encode(s)
    
--	if(string.len(s)+ string.len(k)+5>255) then//usermsg haz a 256 byte limit :<
        net.Start("dermaStuff_datastream_backup")                             
			net.WriteFloat( e2 )
			net.WriteTable( tbl )			           
			net.WriteString( k )                        
        net.Send( pl )   
--[[		
    else

		net.Start("dermaStuff")                             
			net.WriteFloat( e2 )         
			net.WriteString( k ) 
			net.WriteString( s )
        net.Send( pl )  
	
		umsg.Start("dermaStuff", pl)
			umsg.Float( e2 ) 
			umsg.String( k )
			umsg.String( s )
		umsg.End()
	
    end
]]--	
end



//**************************basic receiver************************\\
concommand.Add("_e2derma",                                        //
function(player,commandName,args)                                 //
    if args[1]   == nil then return end                             //
    if args[2]   == nil then return end                             //
    local e2     =  tonumber(args[1])
    local name   =  args[2]                                 //
    if catch[e2] == nil then return end
    if catch[e2].derma[name] == nil then return end                            //
    if rec[ catch[e2].derma[args[2]].type ] == nil then return end//
    rec[ catch[e2].derma[args[2]].type ](args)                    //
    local run = catch[e2].derma[name].run_on_change
    
    if run != nil && run then
        catch[e2].bexe = name
        ents.GetByIndex( e2 ):Execute()
    end
end)                                                              //
//****************************************************************\\





//******************receiver functions********************\\
rec.dButton = function( args )
    local e2       =  tonumber(args[1])
    catch[e2].bexe = args[2]
    ents.GetByIndex( e2 ):Execute()
end

rec.dCheckBox = function( args )
    local e2       =  tonumber(args[1])
    local name     =  args[2]
    local val      =  tonumber(args[3])
    catch[e2].derma[name].val = val
end

rec.dSlider = function( args )
    local e2       =  tonumber(args[1])
    local name     =  args[2]
    local val      =  tonumber(args[3])
    catch[e2].derma[name].val = val
end

rec.dTextBox = function( args )
    local e2       =  tonumber(args[1])
    local name     =  args[2]
    local val      =  args[3]
    catch[e2].derma[name].text = val
end


rec.dDropBox = function( args )
    local e2       =  tonumber(args[1])
    local name     =  args[2]
    local val      =  args[3]
    catch[e2].derma[name].text = val
end


rec.dListBox = function( args )
    local e2       =  tonumber(args[1])
    local name     =  args[2]
    local val      =  args[3]
    catch[e2].derma[name].text = val
end

//**********************************************************\\










//****************************call backs**************************\\
registerCallback("construct", function(self)
    local e2         = self.entity:EntIndex()
    
    self.dermacrap = {}
    self.dermacrap.e2 = e2
    
    catch[e2]        = {}
    //catch[e2].time   = CurTime( ) - 10 // the - 10 is just to make shure it runs the first time its spawned
    catch[e2].derma  = {}
    catch[e2].panels = {} 
    catch[e2].holders= {}
    catch[e2].tabs   = {} 
    catch[e2].pod    = nil 
    catch[e2].bexe   = ""
    catch[e2].owner  = self.player
end)

registerCallback("postexecute", function(self)
if self.dermacrap.e2  == nil then return end
local e2     = self.dermacrap.e2 
if catch[e2] == nil then return end
if catch[e2].update == true then update_derma(e2,self) end
catch[e2].bexe  = ""		
end)

registerCallback("destruct", function(self)
if self.dermacrap.e2  == nil then return end

local e2     = self.dermacrap.e2 
catch[e2].dontsend = true
if catch[e2] == nil then return end
if !catch[e2].pod then
    remove_derma(e2,self.player)    
else
    if catch[e2].pod:GetDriver():IsPlayer( ) then
        remove_derma(e2,catch[e2].pod:GetDriver())
    end	       
end
catch[e2]       = nil	

end)
//*****************************************************************\\













//******************************updater***************************************\\
function update_derma(e2,self, pod)

    if catch[e2].update || self == nil then
        
        if !catch[e2].pod && self != nil then
            sendDermaStuff(catch[e2].derma,self.player,e2)    
	    else
            if catch[e2].pod:GetDriver():IsPlayer( ) then
	           sendDermaStuff(catch[e2].derma,catch[e2].pod:GetDriver(),e2 , pod)
            end
	       
	    end
	    catch[e2].update = false
	end    
end
//****************************************************************************\\









 
//**********removeall*********\\
function remove_derma(e2,pl)
    umsg.Start("removedermaStuff", pl )             
        umsg.Short( e2 )             
    umsg.End()    
end











//*******************************POD SUPPORT**********************************\\
                                                                              
e2function void dPod(entity pod)                                              
    local e2  = self.entity:EntIndex() 
    if pod==nil then return end                             
    if pod:IsVehicle() then            
        catch[e2].pod   = pod 
    else
        catch[e2].pod   = nil
    end                                                     
end                                                                           
                                                                              
function enter( player, vehicle, role )                                       
	for k,v in pairs(catch) do                                                
        if v.pod == vehicle then 
            update_derma(k , nil , true )
//            catch[k].time   = CurTime( ) - 10 
        end                           
    end                                                                       
end                                                                           
hook.Add( "PlayerEnteredVehicle", "derma_V_enter", enter )                    
                                                                              
                                                                              
function VehicleExit(pl, vehicle)                                             
	for k,v in pairs(catch) do                                               
	   if v.pod == vehicle then remove_derma(k,pl) end                        
    end                                                                       
end                                                                           
hook.Add("PlayerLeaveVehicle", "derma_V_Exit", VehicleExit)                   
                                                                    
//****************************************************************************\\









__e2setcost(20)
//***********************panel*****************************\\
e2function void dPanel(string name, vector2 pos, vector2 size)
    
	local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dPanel"
    tbl.text  = name
    tbl.pos   = pos
    tbl.size  = size
    tbl.show  = 1
    tbl.cCol  = false   // custom color flag
    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]  = tbl 
    catch[e2].panels[name] = false 
    catch[e2].update       = true 
	
end

//***********************button*****************************\\
e2function void dButton(string name,string parent, vector2 pos, vector2 size)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dButton"
    tbl.parent= parent
    tbl.text  = name
    tbl.pos   = pos
    tbl.size  = size
    tbl.cCol  = false   //custom color flag
    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]  = tbl 
    catch[e2].update       = true 
end


__e2setcost(1)
e2function number dClk(string name)
    local e2  = self.entity:EntIndex()
    if catch[e2].bexe == name then return 1 end
    return 0
end

e2function string dClk()
    local e2  = self.entity:EntIndex()
    if catch[e2].bexe == nil then return "" end
    return catch[e2].bexe
end
__e2setcost(20)


//***********************dCheckBox*****************************\\
e2function void dCheckBox(string name,string parent, vector2 pos)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dCheckBox"
    tbl.parent= parent
    tbl.text  = name
    tbl.pos   = pos
    tbl.cCol  = Color(255,255,255,255)
    tbl.val   = 0
    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]  = tbl 
    catch[e2].update       = true 
end


//***********************dSlider*****************************\\
e2function void dSlider(string name,string parent, vector2 pos, number length, number min , number max)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dSlider"
    tbl.parent= parent
    tbl.length= length
    tbl.min   = min
    tbl.max   = max
    tbl.text  = name
    tbl.pos   = pos
    tbl.val   = 0
    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]  = tbl 
    catch[e2].update       = true 
end


//***********************dTextBox*****************************\\
e2function void dTextBox(string name,string parent, vector2 pos, number length)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dTextBox"
    tbl.parent= parent
    tbl.length= length
    tbl.text  = ""
    tbl.pos   = pos
    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]     = tbl 
    catch[e2].update          = true 
end

//***********************dImage*****************************\\
e2function void dImage(string name,string parent,string image, vector2 pos, vector2 size)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dImage"
    tbl.parent= parent
    tbl.pos   = pos
    tbl.size  = size
    tbl.image = image
    tbl.cCol  = Color(255,255,255,255)
    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]     = tbl 
    catch[e2].update          = true 
end


//***********************dDropBox*****************************\\
e2function void dDropBox(string name,string parent, vector2 pos, number length)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dDropBox"
    tbl.parent= parent
    tbl.pos   = pos
    tbl.length= length
    tbl.text  = ""
    tbl.array = {}
    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]     = tbl 
    catch[e2].update          = true 
end


//***********************dLabel*****************************\\
e2function void dLabel(string name,string parent, vector2 pos)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dLabel"
    tbl.parent= parent
    tbl.pos   = pos
    tbl.cCol  = Color(255,255,255,255)
    tbl.text  = name
    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]     = tbl 
    catch[e2].update          = true 
end


//***********************dTabHolder*****************************\\
e2function void dTabHolder(string name,string parent, vector2 pos,vector2 size)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dTabHolder"
    tbl.parent= parent
    tbl.pos   = pos
    tbl.size  = size

    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]     = tbl
    catch[e2].holders[name]   = false  
    catch[e2].update          = true 
end


//***********************dTab*****************************\\
e2function void dTab(string name,string parent)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dTab"
    tbl.parent= parent

    catch[e2].tabs[name]   = false
    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]     = tbl 
    catch[e2].update          = true 
end




//***********************dListBox*****************************\\
e2function void dListBox(string name,string parent, vector2 pos,vector2 size)
    local e2  = self.entity:EntIndex()
    local tbl = {}
    tbl.type  = "dListBox"
    tbl.parent= parent
    tbl.pos   = pos
    tbl.size  = size
    tbl.text  = ""
    tbl.array = {}

    
    if catch[e2].derma[name] != nil then return end
    catch[e2].derma[name]     = tbl 
    catch[e2].update          = true 
end



//************modifiers*************\\
__e2setcost(10)
e2function void dPos(string name, vector2 pos)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].pos   = pos 
    catch[e2].update       = true 
end

e2function void dSize(string name, vector2 size)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].size   = size 
    catch[e2].update       = true 
end


e2function void dText(string name, string text )
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].text = text
    catch[e2].update       = true 
end

e2function void dShow(string name, number show )
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].show = show
    catch[e2].update       = true 
end

e2function void dShowCloseButton(string name, number show )
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].ClBut = show
    catch[e2].update       = true 
end

e2function void dColor(string name, number r,number g,number b,number a)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].cCol   = Color(r,g,b,a)
    catch[e2].update             = true 
end

e2function void dLength(string name, number length)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].length = length
    catch[e2].update             = true 
end


e2function void dSetImage(string name, string image)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].image  = image
    catch[e2].update             = true 
end


e2function void dArray(string name, array tbl)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    if catch[e2].derma[name].array == nil then return end
    
    for k,v in pairs(tbl) do
        if type(v) != "string" then tbl[k] = "" end
    end
    
    catch[e2].derma[name].array  = tbl
    catch[e2].update             = true 
end


e2function void dRunOnChange(string name, number bool)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].run_on_change   = (bool==1)
    //catch[e2].update       = true 
end



//************remove*************\\



e2function void dRemove(string name)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name] = nil
    
    for k,v in pairs(catch[e2].derma) do
        if v.parent == name then 
            catch[e2].derma[k] = nil
        end 
    end
    
    catch[e2].update             = true 
end




//************get value functions*************\\
__e2setcost(1)
e2function number dNval(string name)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return 0 end
    if catch[e2].derma[name].val == nil then return 0 end
    if type(catch[e2].derma[name].val) != "number" then return 0 end
    return catch[e2].derma[name].val
end

e2function string dSval(string name)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return name .. " is a nil name" end
    if catch[e2].derma[name].text == nil then return name .. " has no text" end
    if type(catch[e2].derma[name].text) != "string" then return "not a string value" end
    return catch[e2].derma[name].text
end


__e2setcost(20)
//************set value functions*************\\
e2function void dSetNval(string name, number value)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].val = value
    catch[e2].update          = true 
end

e2function void dSetSval(string name, string value)
    local e2  = self.entity:EntIndex()
    if catch[e2].derma[name] == nil then return end
    catch[e2].derma[name].text = value
    catch[e2].update       = true 
end





//********screen h/w************\\
__e2setcost(1)
e2function number scrH()
    local s = self.player:GetInfo("e2_dHW_")
    local stbl = string.Explode(",", s)
    return tonumber(stbl[1])
end

e2function number scrW()
    local s = self.player:GetInfo("e2_dHW_")
    local stbl = string.Explode(",", s)
    return tonumber(stbl[2])
end


//*******mouse capture*******\\
__e2setcost(15)
e2function void enableMouse(number a )
    local e2  = self.entity:EntIndex()
    local b = "false"
    if a==1 then b = "true" end
    
    if !catch[e2].pod then
        self.player:SendLua( "gui.EnableScreenClicker("..b..")")   
	else
        if catch[e2].pod:GetDriver():IsPlayer( ) then
            catch[e2].pod:GetDriver():SendLua( "gui.EnableScreenClicker("..b..")")   
        end
	       
	end

end

local mouseF3       = {}
local mouseF3Toggle = {}

e2function void enableMouseF3(number trap )
    local e2  = self.entity:EntIndex()
    if trap == 1 then catch[e2].mf3 = true else catch[e2].mf3 = false end
end

hook.Add("ShowSpare1", "e2_mouse_f3", function( ply )
    for k,v in pairs(catch) do  
        if !catch[k].pod && catch[k].mf3 then
            if mouseF3Toggle[k] == nil then mouseF3Toggle[k] = true end
        
            local b = "false"
            if mouseF3Toggle[k] then b = "true" end
        
            catch[k].owner:SendLua( "gui.EnableScreenClicker("..b..")")
            mouseF3Toggle[k] = !mouseF3Toggle[k]  
            
                 
        elseif catch[k].mf3 && v.pod != nil && v.pod:GetDriver() == ply  then 
            if mouseF3Toggle[k] == nil then mouseF3Toggle[k] = true end
        
            local b = "false"
            if mouseF3Toggle[k] then b = "true" end
        
            ply:SendLua( "gui.EnableScreenClicker("..b..")")
            mouseF3Toggle[k] = !mouseF3Toggle[k]
              
        end                        
    end    
end)

__e2setcost(nil)