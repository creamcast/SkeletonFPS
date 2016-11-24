#option_explicit
#include "constants.agc"
#include "thingconstants.agc"
#include "mainfuncs.agc"
#include "thingfuncs.agc"
#include "thingfuncsmaped.agc"

/*
    This file is part of SkeletonFPS.

    SkeletonFPS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SkeletonFPS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with SkeletonFPS.  If not, see <http://www.gnu.org/licenses/>.
    
    Author:Creamcast
    URL:https://github.com/creamcast/SkeletonFPS
*/

type Game
	fullscreen as integer
	device_width as integer
	device_height as integer
	window_width as integer
	window_height as integer
	current_scene as integer
	need_scene_change as integer
	paused as integer
	ms as integer
	currentslot as integer
	lives as integer
	mapsize as integer
	carry_coin as integer
	t as integer[MAXTEMPLATES]
endtype

type Thing
	used as integer		//set to 1 if thing slot is being used
	id as integer			//set to number returned by object creation commands
	prog as integer			//set to program jump number
	thing_type as integer
	state as integer
	vars as float[MAXTHINGVARS]
endtype

type Coord2D
	x as integer
	y as integer
endtype

type ObjInfo
	id as float
	x as float
	y as float
	z as float
	xrot as float
	yrot as float
	zrot as float
endtype


tgame as Game
tgame.fullscreen = 0
tgame.window_width =  1334//1334
tgame.window_height = 750 //750
tgame.lives = 3
tgame.currentslot = 0 //chosen level will be +1
InitGame(tgame)

dim things[MAXTHINGS] as Thing
//dim savethings[MAXTHINGS] as Thing
ChangeScene(tgame, INITSCENE)	//5 level editor 4 - start level
debug_num as integer
debug_msg as string
tindex as integer
do	
	tgame.ms = GetMilliseconds()
	if tgame.need_scene_change = YES
		//-----------scene setup----------	
		//only runs once at beginning of scene to intialize things
		sync()
		SetSkyBoxVisible(0)
		DeleteAllText()
		DeleteAllImages()
		DeleteAllSprites()
		DeleteAllLights()
		DeleteAllSounds(SND_SHOT, SND_DOORLOCKED)
		ClearPointLights()
		ClearThings(things)
		DeleteAllObjects()
		DeleteVirtualButtons()
		sync()
		tgame.need_scene_change = NO
		select tgame.current_scene
			
			case 1
				LoadImage(IMG_DEER, "deer.png")
				LoadImage(IMG_RIFLE, "rifle.png")
				LoadImage(IMG_RPG7, "rpg.png")
				LoadImage(IMG_SHADOW, "shadow.png")
				LoadImage(IMG_BRICK, "brick.png")
				LoadImage(IMG_GRASS, "grass.png")
				LoadImage(IMG_BURST, "burst.png")
				LoadImage(IMG_METALDOOR, "metaldoor.png")
				LoadImage(IMG_SKELETON, "skeleton.png")
				LoadImage(IMG_MAINFONT, "gfont.png")
				LoadImage(IMG_ROCKDARK, "rock.png")
				LoadImage(IMG_MEDPACK, "medpack.png")
				LoadImage(IMG_AMMO, "ammo.png")
				LoadImage(IMG_SMOKE, "smoke.png")
				LoadImage(IMG_GCOLORATLAS, "gcolors.png")
				LoadImage(IMG_GUN, "gun.png")
				LoadImage(IMG_ITEMPISTOL, "itempistol.png")
				LoadImage(IMG_ITEMRIFLE, "itemrifle.png")
				LoadImage(IMG_CROSSHAIR, "crosshair.png")
				LoadImage(IMG_CRATE, "crate.png")
				LoadImage(IMG_EXIT, "exit.png")
				LoadImage(IMG_COIN, "coin.png")
				LoadImage(IMG_SKELSOLDIER, "skelsoldier.png")
				LoadImage(IMG_TORCH, "torch.png")
				LoadImage(IMG_CONCREATE, "concreate.png")
				LoadImage(IMG_CHECKERFLOOR, "checkerfloor.png")
				LoadImage(IMG_FBARREL, "fbarrel.png")
				LoadImage(IMG_BARREL, "barrel.png")
				LoadImage(IMG_GEM, "gem.png")
				LoadImage(IMG_ICONGEM, "icongem.png")
				LoadImage(IMG_TRIDENT, "trident.png")
				LoadImage(IMG_SKYBOX, "skybox.png")
				
				LoadImage(IMG_GBUTTONSATLAS, "gamebuttons.png")
				LoadSubImage(IMG_GBUTTON_JOYD, IMG_GBUTTONSATLAS, "joyu")
				LoadSubImage(IMG_GBUTTON_JOYU, IMG_GBUTTONSATLAS, "joyd")
				LoadSubImage(IMG_GBUTTON_OPEN, IMG_GBUTTONSATLAS, "open")
				LoadSubImage(IMG_GBUTTON_JUMP, IMG_GBUTTONSATLAS, "jump")
				
				LoadImage(IMG_ICONATLAS, "hudicons.png")
				LoadSubImage(IMG_ICONCOIN, IMG_ICONATLAS, "coin") 
				LoadSubImage(IMG_ICONHEALTH, IMG_ICONATLAS, "health")
				LoadSubImage(IMG_ICONAMMO, IMG_ICONATLAS, "ammo")
				LoadSubImage(IMG_ICONLIVES, IMG_ICONATLAS, "lives")
				
				LoadSubImage(IMG_GCOLORRED, IMG_GCOLORATLAS, "red")
				LoadSubImage(IMG_GCOLORGREEN, IMG_GCOLORATLAS, "green")
				LoadSubImage(IMG_GCOLORBLUE, IMG_GCOLORATLAS, "blue")
				LoadSubImage(IMG_GCOLORYELLOW, IMG_GCOLORATLAS, "yellow")
				
				CreateImageColor(IMG_RED, 255,0,0,255)
				CreateImageColor(IMG_GREEN, 0,255,0,255)
				CreateImageColor(IMG_BLUE, 0,0,255,255)
				CreateImageColor(IMG_YELLOW, 255,255,0,255)
				
				LoadImage(IMG_SPLASHATLAS, "explode2.png")
				LoadSubImage(IMG_SPLASHSTART+0, IMG_SPLASHATLAS, "0.png")
				LoadSubImage(IMG_SPLASHSTART+1, IMG_SPLASHATLAS, "1.png")
				LoadSubImage(IMG_SPLASHSTART+2, IMG_SPLASHATLAS, "2.png")
				LoadSubImage(IMG_SPLASHSTART+3, IMG_SPLASHATLAS, "3.png")
				LoadSubImage(IMG_SPLASHSTART+4, IMG_SPLASHATLAS, "4.png")
				LoadSubImage(IMG_SPLASHSTART+5, IMG_SPLASHATLAS, "5.png")
				LoadSubImage(IMG_SPLASHSTART+6, IMG_SPLASHATLAS, "6.png")
				LoadSubImage(IMG_SPLASHSTART+7, IMG_SPLASHATLAS, "7.png")
				LoadSubImage(IMG_SPLASHSTART+8, IMG_SPLASHATLAS, "8.png")
				LoadSubImage(IMG_SPLASHSTART+9, IMG_SPLASHATLAS, "9.png")
				LoadSubImage(IMG_SPLASHSTART+10, IMG_SPLASHATLAS, "10.png")
				LoadSubImage(IMG_SPLASHSTART+11, IMG_SPLASHATLAS, "11.png")
				LoadSubImage(IMG_SPLASHSTART+12, IMG_SPLASHATLAS, "12.png")
				LoadSubImage(IMG_SPLASHSTART+13, IMG_SPLASHATLAS, "13.png")
				LoadSubImage(IMG_SPLASHSTART+14, IMG_SPLASHATLAS, "14.png")
				LoadSubImage(IMG_SPLASHSTART+15, IMG_SPLASHATLAS, "15.png")	//24
				
				LoadImage(IMG_EXPLODEATLAS, "explode.png")
				LoadSubImage(IMG_EXPLODESTART+0, IMG_EXPLODEATLAS, "0.png")
				LoadSubImage(IMG_EXPLODESTART+1, IMG_EXPLODEATLAS, "1.png")
				LoadSubImage(IMG_EXPLODESTART+2, IMG_EXPLODEATLAS, "2.png")
				LoadSubImage(IMG_EXPLODESTART+3, IMG_EXPLODEATLAS, "3.png")
				LoadSubImage(IMG_EXPLODESTART+4, IMG_EXPLODEATLAS, "4.png")
				LoadSubImage(IMG_EXPLODESTART+5, IMG_EXPLODEATLAS, "5.png")
				LoadSubImage(IMG_EXPLODESTART+6, IMG_EXPLODEATLAS, "6.png")
				LoadSubImage(IMG_EXPLODESTART+7, IMG_EXPLODEATLAS, "7.png")
				LoadSubImage(IMG_EXPLODESTART+8, IMG_EXPLODEATLAS, "8.png")
				LoadSubImage(IMG_EXPLODESTART+9, IMG_EXPLODEATLAS, "9.png")
				LoadSubImage(IMG_EXPLODESTART+10, IMG_EXPLODEATLAS, "10.png")
				LoadSubImage(IMG_EXPLODESTART+11, IMG_EXPLODEATLAS, "11.png")
				LoadSubImage(IMG_EXPLODESTART+12, IMG_EXPLODEATLAS, "12.png")
				LoadSubImage(IMG_EXPLODESTART+13, IMG_EXPLODEATLAS, "13.png")
				LoadSubImage(IMG_EXPLODESTART+14, IMG_EXPLODEATLAS, "14.png")
				LoadSubImage(IMG_EXPLODESTART+15, IMG_EXPLODEATLAS, "15.png")	//24
				
				LoadImage(IMG_BLOODATLAS, "blood.png")
				LoadSubImage(IMG_BLOODSTART+0, IMG_BLOODATLAS, "0.png")
				LoadSubImage(IMG_BLOODSTART+1, IMG_BLOODATLAS, "1.png")
				LoadSubImage(IMG_BLOODSTART+2, IMG_BLOODATLAS, "2.png")
				LoadSubImage(IMG_BLOODSTART+3, IMG_BLOODATLAS, "3.png")
				LoadSubImage(IMG_BLOODSTART+4, IMG_BLOODATLAS, "4.png")
				LoadSubImage(IMG_BLOODSTART+5, IMG_BLOODATLAS, "5.png")
				LoadSubImage(IMG_BLOODSTART+6, IMG_BLOODATLAS, "6.png")
				LoadSubImage(IMG_BLOODSTART+7, IMG_BLOODATLAS, "7.png")
				LoadSubImage(IMG_BLOODSTART+8, IMG_BLOODATLAS, "8.png")
				LoadSubImage(IMG_BLOODSTART+9, IMG_BLOODATLAS, "9.png")
				LoadSubImage(IMG_BLOODSTART+10, IMG_BLOODATLAS, "10.png")
				LoadSubImage(IMG_BLOODSTART+11, IMG_BLOODATLAS, "11.png")
				LoadSubImage(IMG_BLOODSTART+12, IMG_BLOODATLAS, "12.png")
				LoadSubImage(IMG_BLOODSTART+13, IMG_BLOODATLAS, "13.png")
				LoadSubImage(IMG_BLOODSTART+14, IMG_BLOODATLAS, "14.png")
				LoadSubImage(IMG_BLOODSTART+15, IMG_BLOODATLAS, "15.png")	//24
				
				LoadTemplateObject(tgame, TMPL_LAST, "pillar.dae", IMG_BRICK, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_GEM, "gem.dae", IMG_GEM, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_BULLET, "bullet.dae", IMG_GCOLORYELLOW, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_BOULDER, "boulder.dae", IMG_ROCKDARK, NOCHILD, 1.5)
				LoadTemplateObject(tgame, TMPL_RPG7ROCKET, "rpg7rocket.dae", IMG_RPG7, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_DEER, "deer.dae", IMG_DEER, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_SKELETON, "skeleton.dae", IMG_SKELETON, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_GOLEM, "golem.dae", IMG_ROCKDARK, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WEAPRIFLE, "rifle.dae", IMG_RIFLE, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WEAPRPG7, "rpg7.dae", IMG_RPG7, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_SPLASHPLANE, "plane1", 0, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_SHADOWPLANE, "plane2", 0, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_BURSTPLANE, "plane3", IMG_BURST, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WALL, "wall.dae", IMG_BRICK, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_GRASS, "grass.dae", IMG_GRASS, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WALLDOOR, "walldoor.dae", IMG_METALDOOR, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WALLDOORFRAME, "walldoorframe.dae", IMG_BRICK, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WALLCORNER, "wallcorner.dae", IMG_BRICK, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_MEDPACK, "medpack.dae", IMG_MEDPACK, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_AMMO, "ammo.dae", IMG_AMMO, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_KEY, "key.dae", IMG_GCOLORYELLOW, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WEAPGUN, "gun.dae", IMG_GUN, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_ITEMPISTOL, "itempistol.dae", IMG_ITEMPISTOL, NOCHILD, 0.5)
				LoadTemplateObject(tgame, TMPL_ITEMRIFLE, "itemrifle.dae", IMG_ITEMRIFLE, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_ITEMLAUNCHER, "itemrpg7.dae", IMG_RPG7, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_CRATE, "crate.dae", IMG_CRATE, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_EXIT1, "exit1.dae", IMG_EXIT, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_EXIT2, "exit2.dae", IMG_EXIT, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_COIN, "coin.dae", IMG_COIN, NOCHILD, 0.5)
				LoadTemplateObject(tgame, TMPL_SKELSOLDIER, "skelsoldier.dae", IMG_SKELSOLDIER, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_FBARREL, "fbarrel.dae", IMG_FBARREL, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_FBARREL3, "fbarrel3.dae", IMG_FBARREL, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_BARREL, "barrel.dae", IMG_BARREL, NOCHILD,10)
				LoadTemplateObject(tgame, TMPL_TORCH, "torch.dae", IMG_TORCH, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_TWALLNORTH, "twallnorth.dae", IMG_BRICK, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_TWALLSOUTH, "twallsouth.dae", IMG_BRICK, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_FLOORCEIL, "floorwithc.dae", IMG_CONCREATE, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_WCSTARTNORTH, "wcstartnorth.dae", IMG_CONCREATE, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WCSTARTSOUTH, "wcstartsouth.dae", IMG_CONCREATE, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_TRIDENT, "trident.dae", IMG_TRIDENT, HASCHILD, 0)
		
				LoadSound(SND_SHOT, "shot.wav")
				LoadSound(SND_DRY, "dry.wav")
				LoadSound(SND_EXPLODE, "explode.wav")
				LoadSound(SND_GATE, "gate.wav")
				LoadSound(SND_HITENEMY, "hitenemy.wav")
				LoadSound(SND_RELOAD, "reload.wav")
				LoadSound(SND_RICO1, "rico1.wav")
				LoadSound(SND_RICO2, "rico2.wav")
				LoadSound(SND_ROCKETSHOT, "rocketshot.wav")
				LoadSound(SND_FALL2, "fall2.wav")
				LoadSound(SND_SWING, "swing.wav")
				LoadSound(SND_UGH1, "ugh1.wav")
				LoadSound(SND_UGH2, "ugh2.wav")
				LoadSound(SND_DIE, "die.wav")
				LoadSound(SND_PICKUP1, "pickup1.wav")
				LoadSound(SND_PICKUP2, "pickup2.wav")
				LoadSound(SND_JUMP, "jump.wav")
				LoadSound(SND_LAND, "land.wav")
				LoadSound(SND_AMMO, "ammo.wav")
				LoadSound(SND_WALK1, "walk1.wav")
				LoadSound(SND_WALK2, "walk2.wav")
				LoadSound(SND_SCREECH1, "screech1.wav")
				LoadSound(SND_SCREECH2, "screech2.wav")
				LoadSound(SND_SWING2, "swing2.wav")
				LoadSound(SND_COMPLETE, "missioncomplete.wav")
				LoadSound(SND_ERROR, "error.wav")
				LoadSound(SND_DOOROPEN, "dooropen.wav")
				LoadSound(SND_DOORLOCKED, "doorlocked.wav")
				LoadSound(SND_COIN, "coin.wav")
				LoadSound(SND_1UP, "1up.wav")
				SpawnThing(things, T_PAUSE, 0, PROG_PAUSE, THING_TYPE_NONE)
				SpawnThing(things, T_PLAYER, CreateObjectBox(1, 3, 1), PROG_PLAYER, THING_TYPE_OBJ)
				SpawnThing(things, T_INVENTORY, 0, PROG_INVENTORY, THING_TYPE_NONE)
				SETV(things, T_INVENTORY, V_INVENTORY_COINS, tgame.carry_coin)
				SpawnThing(things, T_GAMEMSG, 0, PROG_GAMEMSG, THING_TYPE_NONE)
				SpawnThing(things, T_CAMERA, 0, PROG_CAMERA, THING_TYPE_NONE)
				
				/*
				SpawnThing(things, T_DOORSTART, CloneTObject(tgame, TMPL_DOOR1), PROG_DOOR, THING_TYPE_OBJ)
				SETV(things, T_DOORSTART, V_DOOR_INITX, 31)
				SETV(things, T_DOORSTART, V_DOOR_INITY, 1.3)
				SETV(things, T_DOORSTART, V_DOOR_INITZ, 0)
				SETV(things, T_DOORSTART, V_DOOR_MOVESPEED, 0.2)
				SETV(things, T_DOORSTART, V_DOOR_MOVEMAX, 40)
				SETV(things, T_DOORSTART, V_DOOR_WAIT, 1500)
				SETV(things, T_DOORSTART, V_DOOR_REQREDKEY, 1)
				
				SpawnThing(things, T_DOORSTART+1, CloneTObject(tgame, TMPL_DOOR2), PROG_DOOR, THING_TYPE_OBJ)
				SETV(things, T_DOORSTART+1, V_DOOR_INITX, 56)
				SETV(things, T_DOORSTART+1, V_DOOR_INITY, 1.3)
				SETV(things, T_DOORSTART+1, V_DOOR_INITZ, 3.4)
				SETV(things, T_DOORSTART+1, V_DOOR_TYPE, 1)
				SETV(things, T_DOORSTART+1, V_DOOR_MOVESPEED, 1)
				SETV(things, T_DOORSTART+1, V_DOOR_MOVEMAX, 100)
				SETV(things, T_DOORSTART+1, V_DOOR_WAIT, 2500)
				SETV(things, T_DOORSTART+1, V_DOOR_REQYELKEY, 1)
				
				SpawnThing(things, T_DOORSTART+2, CloneTObject(tgame, TMPL_DOOR1), PROG_DOOR, THING_TYPE_OBJ)
				SETV(things, T_DOORSTART+2, V_DOOR_INITX, 0)
				SETV(things, T_DOORSTART+2, V_DOOR_INITY, 1.3)
				SETV(things, T_DOORSTART+2, V_DOOR_INITZ, 29)
				SETV(things, T_DOORSTART+2, V_DOOR_INITYROT, 90)
				SETV(things, T_DOORSTART+2, V_DOOR_TYPE, 0)
				SETV(things, T_DOORSTART+2, V_DOOR_MOVESPEED, 0.2)
				SETV(things, T_DOORSTART+2, V_DOOR_MOVEMAX, 40)
				SETV(things, T_DOORSTART+2, V_DOOR_WAIT, 2500)
				SETV(things, T_DOORSTART+2, V_DOOR_REQTRIGGER, 1)
				
				SpawnThing(things, T_TRIGGERSTART, CreateObjectBox(0.5, 2, 0.5), PROG_TRIGGER, THING_TYPE_OBJ)
				SETV(things, T_TRIGGERSTART, V_TRIGGER_THING, T_DOORSTART+2) //set trigger to open door 2
				SETV(things, T_TRIGGERSTART, V_TRIGGER_INITX, 0)
				SETV(things, T_TRIGGERSTART, V_TRIGGER_INITY, 0)
				SETV(things, T_TRIGGERSTART, V_TRIGGER_INITZ, 3)
				SETV(things, T_TRIGGERSTART, V_TRIGGER_MSGSLOT, 4) //display msg in slot 4 when triggered
				*/
				
				SpawnThing(things, T_LEVELGEN, 0, PROG_LEVELGEN, THING_TYPE_OBJ)
				SETV(things, T_LEVELGEN, V_LEVELGEN_SLOT, tgame.currentslot)
				
				SpawnThing(things, T_BURST, CloneTObject(tgame, TMPL_BURSTPLANE), PROG_BURST, THING_TYPE_OBJ)
				
				SpawnThing(things, T_HUDBULLETCOUNTER, 0, PROG_COUNTER, THING_TYPE_NONE)
				SETV(things, T_HUDBULLETCOUNTER, V_COUNTER_INITTEXTSIZE, NUM_HUDTEXTSIZE)	
				SETV(things, T_HUDBULLETCOUNTER, V_COUNTER_INITPOS, POS_BOTTOMLEFT)
				
				SpawnThing(things, T_HUDCLIPCOUNTER, 0, PROG_COUNTER, THING_TYPE_NONE)
				SETV(things, T_HUDCLIPCOUNTER, V_COUNTER_INITTEXTSIZE, NUM_HUDTEXTSIZE)	
				SETV(things, T_HUDCLIPCOUNTER, V_COUNTER_INITPOS, POS_CENTERLEFT)
				SETV(things, T_HUDCLIPCOUNTER, V_COUNTER_USEIMG, IMG_ICONAMMO)
				
				SpawnThing(things, T_HUDHEALTH, 0, PROG_COUNTER, THING_TYPE_NONE)
				SETV(things, T_HUDHEALTH, V_COUNTER_INITTEXTSIZE, NUM_HUDTEXTSIZE)	
				SETV(things, T_HUDHEALTH, V_COUNTER_INITPOS, POS_BOTTOMRIGHT)
				SETV(things, T_HUDHEALTH, V_COUNTER_NUMNOW, 99)
				SETV(things, T_HUDHEALTH, V_COUNTER_USEIMG, IMG_ICONHEALTH)
				
				SpawnThing(things, T_HUDLIVES, 0, PROG_COUNTER, THING_TYPE_NONE)
				SETV(things, T_HUDLIVES, V_COUNTER_INITTEXTSIZE, NUM_HUDTEXTSIZE)
				SETV(things, T_HUDLIVES, V_COUNTER_INITPOS, POS_TOPRIGHT)
				SETV(things, T_HUDLIVES, V_COUNTER_NUMNOW, tgame.lives)
				SETV(things, T_HUDLIVES, V_COUNTER_USEIMG, IMG_ICONLIVES)
				
				SpawnThing(things, T_HUDCOINS, 0, PROG_COUNTER, THING_TYPE_NONE)
				SETV(things, T_HUDCOINS, V_COUNTER_INITTEXTSIZE, NUM_HUDTEXTSIZE)
				SETV(things, T_HUDCOINS, V_COUNTER_INITPOS, POS_TOPLEFT)
				SETV(things, T_HUDCOINS, V_COUNTER_NUMNOW, tgame.carry_coin)
				SETV(things, T_HUDCOINS, V_COUNTER_USEIMG, IMG_ICONCOIN)
				tgame.carry_coin = 0
				
				SpawnThing(things, T_HUDGEMS, 0, PROG_COUNTER, THING_TYPE_NONE)
				SETV(things, T_HUDGEMS, V_COUNTER_INITTEXTSIZE, NUM_HUDTEXTSIZE)
				SETV(things, T_HUDGEMS, V_COUNTER_INITPOS, POS_CENTERRIGHT)
				SETV(things, T_HUDGEMS, V_COUNTER_NUMNOW, 0)
				SETV(things, T_HUDGEMS, V_COUNTER_USEIMG, IMG_ICONGEM)
				
				SpawnThing(things, T_HUDDMG, 0, PROG_HUDDMG, THING_TYPE_NONE)
				
				SpawnThing(things, T_CROSSHAIR, 0, PROG_CROSSHAIR, THING_TYPE_NONE)
				
				
				SetAmbientColor( 77,77,77 )
				SetSunActive(0)
				//SetAmbientColor( 70,70,70 )
				//SetSkyBoxSkyColor(180,180,180)
				//SetSunActive(1)
				//SetFogMode(1)
				//SetSkyBoxVisible(1)
				//SetSkyBoxSunVisible(1)
				
				
			endcase
			
			case 2
				LoadImage(IMG_DEER, "deer.png")
				LoadImage(IMG_SKELETON, "skeleton.png")
				LoadImage(IMG_ROCKDARK, "rock.png")
				LoadImage(IMG_RPG7, "rpg.png")
				LoadImage(IMG_RIFLE, "rifle.png")
				LoadImage(IMG_GUN, "gun.png")
				LoadImage(IMG_GCOLORATLAS, "gcolors.png")
				LoadSubImage(IMG_GCOLORRED, IMG_GCOLORATLAS, "red")
				LoadSubImage(IMG_GCOLORGREEN, IMG_GCOLORATLAS, "green")
				LoadSubImage(IMG_GCOLORBLUE, IMG_GCOLORATLAS, "blue")
				LoadSubImage(IMG_GCOLORYELLOW, IMG_GCOLORATLAS, "yellow")
				
				LoadImage(IMG_TRIDENT, "trident.png")
				
				LoadTemplateObject(tgame, TMPL_DEER, "deer.dae", IMG_DEER, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_SKELETON, "skeleton.dae", IMG_SKELETON, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_GOLEM, "golem.dae", IMG_ROCKDARK, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WEAPRPG7, "rpg7.dae", IMG_RPG7, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_RPG7ROCKET, "rpg7rocket.dae", IMG_RPG7, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WEAPRIFLE, "rifle.dae", IMG_RIFLE, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_BULLET, "bullet.dae", IMG_GCOLORYELLOW, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WEAPGUN, "gun.dae", IMG_GUN, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_TRIDENT, "trident.dae", IMG_TRIDENT, HASCHILD, 0)
				
				SpawnThing(things, T_PLAYER, CloneTObject(tgame, TMPL_TRIDENT), PROG_ANIMCON, THING_TYPE_OBJ)
			endcase
			
			case 3
				//SetRawWritePath( "/Users/mack/Desktop/" )
				
				LoadImage(IMG_DEER, "deer.png")
				LoadImage(IMG_BRICK, "brick.png")
				LoadImage(IMG_GRASS, "grass.png")
				LoadImage(IMG_METALDOOR, "metaldoor.png")
				LoadImage(IMG_SKELETON, "skeleton.png")
				LoadImage(IMG_MAINFONT, "gfont.png")
				LoadImage(IMG_MEDPACK, "medpack.png")
				LoadImage(IMG_AMMO, "ammo.png")
				LoadImage(IMG_ITEMPISTOL, "itempistol.png")
				LoadImage(IMG_ITEMRIFLE, "itemrifle.png")
				LoadImage(IMG_GCOLORATLAS, "gcolors.png")
				LoadImage(IMG_RPG7, "rpg.png")
				LoadImage(IMG_ROCKDARK, "rock.png")
				LoadImage(IMG_CRATE, "crate.png")
				LoadImage(IMG_EXIT, "exit.png")
				LoadImage(IMG_COIN, "coin.png")
				LoadImage(IMG_SKELSOLDIER, "skelsoldier.png")
				LoadImage(IMG_TORCH, "torch.png")
				LoadImage(IMG_CONCREATE, "concreate.png")
				LoadImage(IMG_CHECKERFLOOR, "checkerfloor.png")
				LoadImage(IMG_FBARREL, "fbarrel.png")
				LoadImage(IMG_BARREL, "barrel.png")
				LoadSubImage(IMG_GCOLORRED, IMG_GCOLORATLAS, "red")
				LoadSubImage(IMG_GCOLORGREEN, IMG_GCOLORATLAS, "green")
				LoadSubImage(IMG_GCOLORBLUE, IMG_GCOLORATLAS, "blue")
				LoadSubImage(IMG_GCOLORYELLOW, IMG_GCOLORATLAS, "yellow")
				
				CreateImageColor(IMG_RED, 255,0,0,255)
				CreateImageColor(IMG_GREEN, 0,255,0,255)
				CreateImageColor(IMG_BLUE, 0,0,255,255)
				CreateImageColor(IMG_YELLOW, 255,255,0,255)
				
				LoadImage(IMG_MAPEDBTNATLAS1, "mapedbuttons1.png")
				LoadImage(IMG_MAPEDBTNATLAS2, "mapedbuttons2.png")
				LoadSubImage(IMG_MEBTNEXPORTUP, IMG_MAPEDBTNATLAS1, "export")
				LoadSubImage(IMG_MEBTNEXPORTDN, IMG_MAPEDBTNATLAS2, "export")
				LoadSubImage(IMG_MEBTNLAYER1UP, IMG_MAPEDBTNATLAS1, "layer1")
				LoadSubImage(IMG_MEBTNLAYER2UP, IMG_MAPEDBTNATLAS1, "layer2")
				LoadSubImage(IMG_MEBTNLAYER3UP, IMG_MAPEDBTNATLAS1, "layer3")
				LoadSubImage(IMG_MEBTNLAYER1DN, IMG_MAPEDBTNATLAS2, "layer1")
				LoadSubImage(IMG_MEBTNLAYER2DN, IMG_MAPEDBTNATLAS2, "layer2")
				LoadSubImage(IMG_MEBTNLAYER3DN, IMG_MAPEDBTNATLAS2, "layer3")
				
				LoadSubImage(IMG_MEBTNPLACEUP, IMG_MAPEDBTNATLAS1, "place")
				LoadSubImage(IMG_MEBTNLEFTUP, IMG_MAPEDBTNATLAS1, "left")
				LoadSubImage(IMG_MEBTNRIGHTUP, IMG_MAPEDBTNATLAS1, "right")
				LoadSubImage(IMG_MEBTNPLACEDN, IMG_MAPEDBTNATLAS2, "place")
				LoadSubImage(IMG_MEBTNLEFTDN, IMG_MAPEDBTNATLAS2, "left")
				LoadSubImage(IMG_MEBTNRIGHTDN, IMG_MAPEDBTNATLAS2, "right")
				
				LoadImage(IMG_DIALOGBTNATLAS, "dialogbuttonsatlas.png")
				LoadSubImage(IMG_DIALOGBTNYES, IMG_DIALOGBTNATLAS, "yes")
				LoadSubImage(IMG_DIALOGBTNNO, IMG_DIALOGBTNATLAS, "no")
				LoadSubImage(IMG_MEBTNDEL, IMG_DIALOGBTNATLAS, "delete")
				
				LoadTemplateObject(tgame, TMPL_DEER, "deer.dae", IMG_DEER, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_SKELETON, "skeleton.dae", IMG_SKELETON, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_GOLEM, "golem.dae", IMG_ROCKDARK, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WALL, "wall.dae", IMG_BRICK, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_GRASS, "grass.dae", IMG_GRASS, NOCHILD, 0)
				
				LoadTemplateObject(tgame, TMPL_WALLDOORFRAME, "walldoorframe.dae", IMG_BRICK, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WALLCORNER, "wallcorner.dae", IMG_BRICK, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_MEDPACK, "medpack.dae", IMG_MEDPACK, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_AMMO, "ammo.dae", IMG_AMMO, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_KEY, "key.dae", IMG_GCOLORYELLOW, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_ITEMPISTOL, "itempistol.dae", IMG_ITEMPISTOL, NOCHILD, 0.5)
				LoadTemplateObject(tgame, TMPL_ITEMRIFLE, "itemrifle.dae", IMG_ITEMRIFLE, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_ITEMLAUNCHER, "itemrpg7.dae", IMG_RPG7, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_MEPLAYER, "meplayer.dae", IMG_GCOLORRED, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_KEYR, "key.dae", IMG_GCOLORRED, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_KEYY, "key.dae", IMG_GCOLORYELLOW, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_KEYB, "key.dae", IMG_GCOLORBLUE, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WALLDOOR, "walldoor.dae", IMG_METALDOOR, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_MEREDWALLDOOR, "walldoor.dae", IMG_METALDOOR, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_MEBLUWALLDOOR, "walldoor.dae", IMG_METALDOOR, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_MEYELWALLDOOR, "walldoor.dae", IMG_METALDOOR, NOCHILD, 0)	
				LoadTemplateObject(tgame, TMPL_CRATE, "crate.dae", IMG_CRATE, NOCHILD, 0)				
				LoadTemplateObject(tgame, TMPL_TILESELECT, "tileselect.dae", 0, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_GRASS, "grass.dae", IMG_GRASS, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_EXIT1, "exit1.dae", IMG_EXIT, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_COIN, "coin.dae", IMG_COIN, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_SKELSOLDIER, "skelsoldier.dae", IMG_SKELSOLDIER, HASCHILD, 0)
				LoadTemplateObject(tgame, TMPL_FBARREL, "fbarrel.dae", IMG_FBARREL, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_FBARREL3, "fbarrel3.dae", IMG_FBARREL, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_BARREL, "barrel.dae", IMG_BARREL, NOCHILD,8)
				LoadTemplateObject(tgame, TMPL_TORCH, "torch.dae", IMG_TORCH, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_TWALLNORTH, "twallnorth.dae", IMG_BRICK, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_TWALLSOUTH, "twallsouth.dae", IMG_BRICK, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_FLOORCEIL, "floorwithc.dae", IMG_CONCREATE, NOCHILD,0)
				LoadTemplateObject(tgame, TMPL_WHITELIGHT, "sphere", 0, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_REDLIGHT, "sphere", IMG_RED, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_GREENLIGHT, "sphere", IMG_GREEN, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_BLUELIGHT, "sphere", IMG_BLUE, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WCSTARTNORTH, "wcstartnorth.dae", IMG_CONCREATE, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_WCSTARTSOUTH, "wcstartsouth.dae", IMG_CONCREATE, NOCHILD, 0)
				LoadTemplateObject(tgame, TMPL_LAST, "pillar.dae", IMG_BRICK, NOCHILD, 0)
				
				SpawnThing(things, T_TILESELECT, CloneTObject(tgame, TMPL_TILESELECT), PROG_TILESELECT, THING_TYPE_OBJ)
				SpawnThing(things, T_MAP, 0, PROG_MAP, THING_TYPE_NONE)
				SpawnThing(things, T_MAPCAM, 0, PROG_MAPCAM, THING_TYPE_NONE)
				SpawnThing(things, T_OBJPRV, 0, PROG_OBJPRV, THING_TYPE_NONE)
				SpawnThing(things, T_EXPORTMAP, 0, PROG_EXPORTMAP, THING_TYPE_NONE)
				
				SpawnThing(things, T_CHOOSEBOX, 0, PROG_CHOOSEBOX, THING_TYPE_NONE)
				SpawnThing(things, T_HUDDMG, 0, PROG_HUDDMG, THING_TYPE_NONE)
				
				SetAmbientColor(100,100,100)
			endcase
			
			case SCENE_LVLDISPLAY //level display
				LoadImage(IMG_MAINFONT, "gfont.png")
				LoadImage(IMG_ICONATLAS, "hudicons.png")
				LoadSubImage(IMG_ICONLIVES, IMG_ICONATLAS, "lives")
				
				inc tgame.currentslot
				ShowMessage(things, 14, POS_CENTER, 2000,48)
				
				SpawnThing(things, T_CHANGESCENE, 0, PROG_CHANGESCENE, THING_TYPE_NONE)
				SETV(things, T_CHANGESCENE, V_CHANGESCENE_WAIT, 2000)
				SETV(things, T_CHANGESCENE, V_CHANGESCENE_SCENENEXT, 1)
				
				SpawnThing(things, T_HUDLIVES, 0, PROG_COUNTER, THING_TYPE_NONE)
				SETV(things, T_HUDLIVES, V_COUNTER_INITTEXTSIZE, NUM_HUDTEXTSIZE)
				SETV(things, T_HUDLIVES, V_COUNTER_INITPOS, POS_TOPRIGHT)
				SETV(things, T_HUDLIVES, V_COUNTER_NUMNOW, tgame.lives)
				SETV(things, T_HUDLIVES, V_COUNTER_USEIMG, IMG_ICONLIVES)
			endcase
			
			
			case 5 //map option
				LoadImage(IMG_MAINFONT, "gfont.png")
				SpawnThing(things, T_MAPSETUP, 0, PROG_MAPSETUP, THING_TYPE_NONE)
			endcase
			
			case 6 //level select
				LoadSound(SND_SHOT, "shot.wav")
				LoadSound(SND_DRY, "dry.wav")
				LoadSound(SND_EXPLODE, "explode.wav")
				LoadImage(IMG_MAINFONT, "gfont.png")
				LoadImage(IMG_MAPEDBTNATLAS1, "mapedbuttons1.png")
				LoadImage(IMG_MAPEDBTNATLAS2, "mapedbuttons2.png")
				LoadImage(IMG_GRASS, "grass.png")
				LoadSubImage(IMG_MEBTNLEFTUP, IMG_MAPEDBTNATLAS1, "left")
				LoadSubImage(IMG_MEBTNRIGHTUP, IMG_MAPEDBTNATLAS1, "right")
				LoadSubImage(IMG_MEBTNLEFTDN, IMG_MAPEDBTNATLAS2, "left")
				LoadSubImage(IMG_MEBTNRIGHTDN, IMG_MAPEDBTNATLAS2, "right")
				SpawnThing(things, T_LVLSELECT, 0, PROG_LVLSELECT, THING_TYPE_NONE)
			endcase
		endselect
    endif
    
    
    //------------execute thing programs------------
    if tgame.paused = 0
		For tindex = 0 to MAXTHINGS
			if things[tindex].used = YES
				select things[tindex].prog
					case 0 : : endcase
					case PROG_END_EVAL 	: exit : endcase	//stops evaluation
					case PROG_PLAYER 	: ProgPlayer(tgame, things, tindex): endcase
					case PROG_FREECAM 	: CameraControl(tgame, things, tindex) : endcase
					case PROG_CAMERA 	: ProgCamera(tgame, things, tindex) : endcase
					case PROG_DOOR 		: ProgDoor(tgame, things, tindex) : endcase
					case PROG_INVENTORY : ProgInventory(tgame,things,tindex) : endcase
					case PROG_KEY 		: ProgKey(tgame,things,tindex) : endcase
					case PROG_GAMEMSG 	: ProgGameMsg(tgame, things, tindex) : endcase
					case PROG_TRIGGER 	: ProgTrigger(tgame, things, tindex) : endcase
					case PROG_PAUSE 	: ProgPause(tgame, things, tindex) : endcase
					case PROG_OBJPLACE	: ProgObjPlacer(tgame, things, tindex) : endcase
					case PROG_HUD		: ProgHud(tgame, things, tindex) : endcase
					case PROG_ENEMY		: ProgEnemy(tgame, things, tindex) : endcase
					case PROG_BULLET	: ProgBullet(tgame, things, tindex) : endcase
					case PROG_SPLASH	: ProgSplash(tgame,things,tindex) : endcase
					case PROG_SHADOW	: ProgShadow(tgame,things,tindex) : endcase
					case PROG_LEVELGEN	: ProgLevelGen(tgame,things,tindex) : endcase
					case PROG_WEAP		: ProgWeap(tgame,things,tindex) : endcase
					case PROG_BURST		: ProgBurst(tgame,things,tindex) : endcase
					case PROG_EXPLODE	: ProgExplode(tgame,things,tindex) : endcase
					case PROG_ANIMCON	: AnimController(tgame,things,tindex) : endcase
					case PROG_COUNTER	: ProgCounter(tgame,things,tindex) : endcase
					case PROG_HUDDMG	: ProgDmgEffect(tgame,things,tindex) : endcase
					case PROG_HUDMSG	: ProgMsg(tgame,things,tindex) : endcase
					case PROG_ITEM		: ProgItem(tgame,things,tindex) : endcase
					case PROG_SMOKE		: ProgSmoke(tgame,things,tindex) : endcase
					case PROG_BLOOD		: ProgBloodSplash(tgame,things,tindex) : endcase
					case PROG_MAP		: ProgMap(tgame,things,tindex) : endcase
					case PROG_TILESELECT: ProgTileSelect(tgame,things,tindex) : endcase
					case PROG_MAPCAM	: ProgMapCam(tgame, things, tindex) : endcase
					case PROG_OBJPRV	: ProgObjectPreview(tgame,things,tindex) : endcase
					case PROG_EXPORTMAP : ProgExportMap(tgame, things, tindex) : endcase
					case PROG_CHOOSEBOX : ProgChooseBox(tgame, things, tindex) : endcase
					case PROG_CROSSHAIR : ProgCrosshair(tgame, things, tindex) : endcase
					case PROG_EXIT		: ProgExit(tgame,things,tindex) : endcase
					case PROG_CHANGESCENE : ProgChangeScene(tgame, things, tindex) : endcase
					case PROG_MAPSETUP : ProgMapSetup(tgame, things,  tindex) : endcase
					case PROG_LVLSELECT : ProgLvlSelect(tgame,things,tindex):endcase
				endselect
			endif
		Next
	elseif tgame.paused = 1
		if things[T_PAUSE].used = YES : ProgPause(tgame, things, T_PAUSE) : endif
	endif
	//print(ScreenFPS())
	//print(GetWritePath())	
    Sync()
loop

