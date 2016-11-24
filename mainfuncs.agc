
function ChangeScene(tgame ref as Game, scene_number as integer)
	tgame.current_scene = scene_number
	tgame.need_scene_change = 1
endfunction

function InitGame(tgame ref as Game)
	SetWindowTitle("Game")
	SetWindowSize(tgame.window_width, tgame.window_height, tgame.fullscreen)
	SetVirtualResolution(tgame.window_width, tgame.window_height)
	SetOrientationAllowed( 0, 0, 1, 1 )
	SetResolutionMode(1)
	SetWindowAllowResize(0)
	
	//SetSyncRate(60,0)
	
	SetAntialiasMode( 1 )
	//SetDefaultMagFilter( 0 ) //blocky textures
	SetGenerateMipmaps(1)
	SetPrintSize(24)
	SetScissor(0,0,0,0)
endfunction

function SV(things ref as Thing[], thingindex as integer, varindex as integer, value as float)
	things[thingindex].vars[varindex] = value
endfunction

function GV(things ref as Thing[], thingindex as integer, varindex as integer)
	result as float
	result = things[thingindex].vars[varindex]
endfunction result

function SETV(things ref as Thing[], thingindex as integer, varindex as integer, value as float)
	result as integer
	if things[thingindex].used = YES
		things[thingindex].vars[varindex] = value
		result = YES
	endif
endfunction result

function SETSTATE(things ref as Thing[], thingindex as integer, state as integer)
	result as integer
	if things[thingindex].used = YES
		things[thingindex].state = state
		result = YES
	endif
endfunction result

function GetThingVar(things ref as Thing[], thingindex as integer, varindex as integer)
	result as float
	if things[thingindex].used = YES
		result = things[thingindex].vars[varindex]
	endif
endfunction result

/*
	used as integer		//set to 1 if thing slot is being used
	id as integer			//set to number returned by object creation commands
	prog as integer			//set to program jump number
	thing_type as integer
	state as integer
	vars as float[255]
*/
//function SaveThings(things ref as Thing[], savething ref as Thing[])
	//i as integer
	//j as integer
	//for i = 0 to MAXTHINGS
		//savethings[i].used 			= things[i].used
		//savethings[i].id 			= things[i].id
		//savethings[i].prog 			= things[i].prog
		//savethings[i].thing_type 	= things[i].thing_type
		//savethings[i].state			= things[i].state

		//for j = 0 to MAXTHINGVARS
			//savethings[i].vars[j] = things[i].vars[j]
		//next
	//next
//endfunction

//function LoadThings(things ref as Thing[], savething ref as Thing[])
	//i as integer
	//j as integer
	//for i = 0 to MAXTHINGS
		//things[i].used 			= savethings[i].used
		//things[i].id 			= savethings[i].id
		//things[i].prog 			= savethings[i].prog
		//things[i].thing_type 	= savethings[i].thing_type
		//things[i].state			= savethings[i].state
		//for j = 0 to MAXTHINGVARS
			//things[i].vars[j] = savethings[i].vars[j]
		//next
	//next
//endfunction

function CloneTObject(tgame ref as Game, template_index)
	id as integer
	id = CloneObject(tgame.t[template_index])
	SetObjectCollisionMode(id, 1)
	SetObjectVisible(id, 1)
	SetObjectPosition(id, 0, 0, 0)
	
	//special for map editor
	if template_index = TMPL_MEREDWALLDOOR
		SetObjectColor(id, 255,0,0,255)
	elseif template_index = TMPL_MEBLUWALLDOOR
		SetObjectColor(id, 0,0,255,255)
	elseif template_index = TMPL_MEYELWALLDOOR
		SetObjectColor(id, 255,255,0,255)
	endif
endfunction id

function LoadTemplateObject(tgame ref as Game, template_index as integer, filename as string, img as integer, children as integer, scale as float)
	if filename = "plane1"
		tgame.t[template_index] = CreateObjectPlane(3,3)
	elseif filename = "plane2"
		tgame.t[template_index] = CreateObjectPlane(2,3)
	elseif filename = "plane3"
		tgame.t[template_index] = CreateObjectPlane(0.5,0.5)
	elseif filename = "sphere"
		tgame.t[template_index] = CreateObjectSphere(2,2,2)
	elseif children = 1
		tgame.t[template_index] = LoadObjectWithChildren(filename)
	else
		tgame.t[template_index] = LoadObject(filename)
	endif
	
	SetObjectVisible(tgame.t[template_index], 0)
	SetObjectCollisionMode(tgame.t[template_index], 0)
	SetObjectPosition(tgame.t[template_index], 0, -100, 0)
	
	if scale <> 0
	SetObjectScalePermanent(tgame.t[template_index], scale,scale,scale)
	endif
	
	if img <> 0
		SetObjectImage(tgame.t[template_index], img, 0)
	endif
endfunction

function ClearThing(things ref as Thing[], index as integer)
	if things[index].used = YES
		select things[index].thing_type
			case THING_TYPE_NONE : : endcase
			case THING_TYPE_OBJ : DeleteObjectWithChildren(things[index].id) : endcase
		endselect
		j as integer
		for j = 0 to MAXTHINGVARS
			things[index].vars[j] = 0
		next
		things[index].thing_type = THING_TYPE_NONE
		things[index].prog = 0
		things[index].id = 0
		things[index].state = 0
		things[index].used = NO
	endif
endfunction

function ClearThings(things ref as Thing[])
	i as integer
	for i = 0 to MAXTHINGS
		ClearThing(things, i)
	next
endfunction

function SpawnThing(things ref as Thing[], thing_index as integer, id as integer, prog as integer, thing_type as integer)
	things[thing_index].used = YES
	things[thing_index].id = id
	things[thing_index].prog = prog
	things[thing_index].thing_type = thing_type
endfunction id

function GetObjectInfo(id as integer, o ref as ObjInfo)
	o.x = GetObjectX(id)
	o.y = GetObjectY(id)
	o.z = GetObjectZ(id)
	o.xrot = GetObjectAngleX(id)
	o.yrot = GetObjectAngleY(id)
	o.zrot = GetObjectAngleZ(id)
endfunction

function GetEmptySlot(things ref as Thing[], rangestart as integer, rangeend as integer)
	i as integer
	useslot as integer
	useslot = -1		//set default explode slot
	for i = rangestart to rangeend
		if things[i].used = NO
			useslot = i
			exit
		endif
	next	
endfunction useslot

function GetEmptyLight(rangestart as integer, rangeend as integer)
	i as integer
	uselight as integer
	uselight = -1
	for i = rangestart to rangeend
		if GetPointLightExists(i) = 0
			uselight = i
			exit
		endif
	next
endfunction uselight

function GetAngle(x1 as float, z1 as float, x2 as float, z2 as float)
	result as float
	result = ATanFull(x1 - x2, z1 - z2)
endfunction result

//return value of 360 means x2z2 is facing x1z2
function GetAngleYAdjust(x1 as float, z1 as float, x2 as float, z2 as float, originYAngle as float)
	ang as float
	ang = GetAngle(x1, z1, x2, z2)
	ang = ang + originYAngle
	if ang > 360
		ang = ang - 360
	endif
endfunction ang

//x1z1 target (player)
//x2z2 origin
//originYangle GetObjectAngleY
function IsFacing(x1 as float, z1 as float, x2 as float, z2 as float, originYAngle as float)
	ang as float
	result as integer
	ang = GetAngle(x1, z1, x2, z2)
	ang = ang + originYAngle
	
	//wrap
	if ang > 360
		ang = ang - 360
	endif
	
	if ang >= 0 and ang <= 40
		result = 1
	elseif ang >= 320 and ang <= 360
		result = 1
	endif
endfunction result

function IsFacingNarrow(x1 as float, z1 as float, x2 as float, z2 as float, originYAngle as float)
	ang as float
	result as integer
	ang = GetAngle(x1, z1, x2, z2)
	ang = ang + originYAngle
	
	//wrap
	if ang > 360
		ang = ang - 360
	endif
	
	if ang >= 0 and ang <= 20
		result = 1
	elseif ang >= 340 and ang <= 360
		result = 1
	endif
endfunction result
 
function GetDistance(x1 as float, z1 as float, x2 as float, z2 as float)
	 dx as float
	 dz as float
	 r as float
	 dx = x2 - x1
	 dz = z2 - z1
	 r=sqrt( dx *dx  + dz * dz)
endfunction r

function DeleteAllLights()
	i as integer
	for i = 0 to 1000
		if GetPointLightExists(i) = 1
			DeletePointLight(i)
		endif
	next
endfunction

function DeleteAllSounds(begini as integer, endi as integer)
	i as integer
	for i = begini to endi
		DeleteSound(i)
	next
endfunction

//note: massive slow down when passing local copy of dim custom type, must be passed as reference
function AllowHit(things ref as Thing[], thingindex as integer, hitid as integer)
	r as integer
	r = 0
	if things[thingindex].used = YES and hitid = things[thingindex].id and things[thingindex].state <> STATE_DEAD
		r = 1
	endif
endfunction r

function Handler(things ref as Thing[], cobj_old as ObjInfo, cobj_new as ObjInfo, sc_size as float, startthing as integer, endthing as integer, allowstate as integer, newstate as integer)
	//Enemy handler
	foundenemy as integer
	object_hit as integer
	index as integer
	hits as integer
	
	object_hit = 0
	for index = startthing to endthing
		if things[index].used = NO : continue : endif
		object_hit = ObjectSphereCast(things[index].id,cobj_old.x, cobj_old.y, cobj_old.z, cobj_new.x, cobj_new.y, cobj_new.z, sc_size)
		if object_hit <> 0
			exit
		endif
	next
	foundenemy = index
	if object_hit <> 0
		hits = GetObjectRayCastNumHits()
		for index = 0 to hits
			If GetObjectRayCastHitID(index) = things[foundenemy].id and things[foundenemy].state = allowstate
				things[foundenemy].state = newstate
			endif
		next
	endif
endfunction

function GetGroundY(id)
	obj as ObjInfo
	hitid as integer
	result as float
	GetObjectInfo(id, obj)
	if ObjectRayCast(0, obj.x, obj.y, obj.z, obj.x, obj.y - 50, obj.z) <> 0
		hitid = GetObjectRayCastHitID(0)
		result = GetObjectY(hitid)
	endif	
endfunction result

function GetHudPos(tgame ref as Game, objwidth as integer, objheight as integer, postype as integer, result ref as Coord2D)
	select postype
		case POS_TOPLEFT
			result.x = 0
			result.y = 0 + 8
		endcase
		case POS_TOPCENTER
			result.x = (tgame.window_width / 2) - (objwidth/2)
			result.y = 0 + 8
		endcase
		case POS_TOPRIGHT
			result.x = tgame.window_width - objwidth
			result.y = 0 + 8
		endcase
		case POS_BOTTOMLEFT
			result.x = 0
			result.y = (tgame.window_height/2) - objheight
		endcase
		case POS_BOTTOMCENTER
			result.x = (tgame.window_width / 2) - (objwidth/2)
			result.y = tgame.window_height - objheight
		endcase
		case POS_BOTTOMRIGHT
			result.x = tgame.window_width - objwidth
			result.y = (tgame.window_height/2) - objheight
		endcase
		case POS_CENTER
			result.x = (tgame.window_width / 2) - (objwidth/2)
			result.y = (tgame.window_height / 2) - (objheight/2)
		endcase
		case POS_CENTERLEFT
			result.x = 0
			result.y = ((tgame.window_height/2) / 2) - (objheight/2)
		endcase
		case POS_CENTERRIGHT
			result.x = tgame.window_width - objwidth
			result.y = ((tgame.window_height/2) / 2) - (objheight/2)
		endcase
	endselect	
endfunction

function SetImageRepeat(img as integer)
	SetImageWrapU(img, 1)
	SetImageWrapV(img, 1)
endfunction

function ShowMessage(things ref as Thing[], msgslot, screenpos, showtime, textsize)
	//==================show msg==================
	if things[T_HUDMSG].used = YES	//delete anything there..
		DeleteText(things[T_HUDMSG].vars[V_MSG_TEXTID])
		ClearThing(things, T_HUDMSG)
	endif
	SpawnThing(things, T_HUDMSG, 0, PROG_HUDMSG, THING_TYPE_NONE)
	SETV(things, T_HUDMSG, V_MSG_SLOT, msgslot)
	SETV(things, T_HUDMSG, V_MSG_INITPOS, screenpos)
	SETV(things, T_HUDMSG, V_MSG_SHOWTIME, showtime)
	SETV(things, T_HUDMSG, V_MSG_TEXTSIZE, textsize)
	//========================================
endfunction

function SetMapVal( map ref as integer[], mapsize as integer, x as integer, y as integer, value as integer)
	map[x + (mapsize*y)] = value
endfunction

function DeleteVirtualButtons()
	If GetVirtualButtonExists(VBUTTON1) then DeleteVirtualButton(VBUTTON1)
	If GetVirtualButtonExists(VBUTTON2) then DeleteVirtualButton(VBUTTON2)
	If GetVirtualButtonExists(VBUTTON3) then DeleteVirtualButton(VBUTTON3)
	If GetVirtualButtonExists(VBUTTON4) then DeleteVirtualButton(VBUTTON4)
	If GetVirtualButtonExists(VBUTTON5) then DeleteVirtualButton(VBUTTON5)
	If GetVirtualButtonExists(VBUTTON6) then DeleteVirtualButton(VBUTTON6)
	If GetVirtualButtonExists(VBUTTON7) then DeleteVirtualButton(VBUTTON7)
	If GetVirtualButtonExists(VBUTTON8) then DeleteVirtualButton(VBUTTON8)
	If GetVirtualButtonExists(VBUTTON9) then DeleteVirtualButton(VBUTTON9)
	If GetVirtualButtonExists(VBUTTON10) then DeleteVirtualButton(VBUTTON10)
	If GetVirtualJoystickExists(JOYL) then DeleteVirtualJoystick(JOYL)
	If GetVirtualJoystickExists(JOYR) then DeleteVirtualJoystick(JOYR)
endfunction

function AddZeros(digits as integer, num as string)
	do
	If Len(num) < digits
		num = "0" + num
	else
		exit
	endif
	loop
endfunction num

function PlaySoundDist(sourceobjid as integer, sound as integer)
	sx as integer : sz as integer
	cx as integer : cz as integer
	dist as integer
	sx = GetObjectX(sourceobjid)
	sz = getObjectZ(sourceobjid)
	cx = GetCameraX(CAM_MAIN)
	cz = GetCameraZ(CAM_MAIN)
	if sound <> 0
		dist = GetDistance(sx, sz, cx, cz)
		if dist >= 0 and dist <= 10 
			PlaySound(sound, 100)
		elseif dist >= 11 and dist <= 30
			PlaySound(sound, 70)
		elseif dist >= 31 and dist <= 50
			PlaySound(sound, 40)
		elseif dist >= 51 and dist <= 100
			PlaySound(sound, 10)
		endif
	endif
endfunction


function ReadLevel()
	filename as string
	file as integer
	score as integer
	filename = "complevel.txt"
	if GetFileExists(filename)
		file = OpenToRead(filename)
		score = ReadInteger(file)
		CloseFile(file)
	else
		score = 0
	endif
endfunction score

function WriteLevel(score as integer)
	filename as string
	file as integer
	result as integer
	filename = "complevel.txt"
	
	file = OpenToWrite(filename,0)
	WriteInteger(file, score)
	CloseFile(file)
	result = 1
endfunction result
