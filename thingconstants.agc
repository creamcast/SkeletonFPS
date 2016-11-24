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

//------------------------------------
//THINGS
//------------------------------------
//things
#constant T_PAUSE 		1
#constant T_LEVELGEO 	2
#constant T_PLAYER		3
#constant T_LEVELGEN 	4
#constant T_INVENTORY 	5
#constant T_HUD 		6
#constant T_CAMERA 		7
#constant T_FREECAM 	8
#constant T_REDKEY 		9
#constant T_BLUKEY 		10
#constant T_YELKEY 		11
#constant T_GAMEMSG 	12
#constant T_OBJPLACE 	13
#constant T_WEAP 		14

#constant T_BURST		20
#constant T_ITEMSSTART	21
#constant T_ITEMEND		64
#constant T_SPLASHSTART 65
#constant T_SPLASHEND 79
#constant T_TRIGGERSTART 80
#constant T_TRIGGEREND 99
#constant T_DOORSTART 100
#constant T_DOOREND 120
#constant T_ENEMYSTART 150
#constant T_ENEMYEND 200
#constant T_BULLETSTART 201
#constant T_BULLETEND 255
#constant T_SHADOWSTART 256
#constant T_SHADOWEND 306
#constant T_EXPLODESTART 307
#constant T_EXPLODEEND 320
#constant T_SMOKESTART 321
#constant T_SMOKEEND 390
#constant T_BLOODSTART 391
#constant T_BLOODEND 401
#constant T_EXIT 402

#constant T_HUDBULLETCOUNTER 410
#constant T_HUDCLIPCOUNTER 411
#constant T_HUDHEALTH 412
#constant T_HUDDMG 413
#constant T_HUDMSG 414
#constant T_CROSSHAIR 415
#constant T_HUDLIVES 416
#constant T_HUDCOINS 417
#constant T_HUDGEMS 418
#constant T_CHANGESCENE 419

#constant T_MAP 500
#constant T_TILESELECT 501
#constant T_MAPCAM 502
#constant T_OBJPRV 503
#constant T_EXPORTMAP 504
#constant T_CHOOSEBOX 505
#constant T_MAPSETUP 506

#constant T_LVLSELECT 507

//------------------------------------
//VARS
//------------------------------------
//for lvlselect
#constant V_LVLSELECT_TEXT 0
#constant V_LVLSELECT_MAX 1
#constant V_LVLSELECT_CLVL 2

//for mapsetup
#constant V_MAPSETUP_TXT1 0
#constant V_MAPSETUP_TXT2 1
#constant V_MAPSETUP_EDIT1 2
#constant V_MAPSETUP_EDIT2 3
#constant V_MAPSETUP_TXT0 4

//for change scene
#constant V_CHANGESCENE_WAIT 0 
#constant V_CHANGESCENE_NEXTTIME 1
#constant V_CHANGESCENE_SCENENEXT 2

//for exit
#constant V_EXIT_SECONDPART 0
#constant V_EXIT_INITX 1
#constant V_EXIT_INITZ 2
#constant V_EXIT_NEXTTIME 3
#constant V_EXIT_GEMREQ 4
#constant V_EXIT_LIGHT 5

//for crosshair
#constant V_CROSSHAIR_SID 0
#constant V_CROSSHAIR_HIDDEN 1

//for choosebox
#constant V_CHOOSEBOX_MSGSLOT 0
#constant V_CHOOSEBOX_TXTID 1
#constant V_CHOOSEBOX_LASTRESULT 2
#constant V_CHOOSEBOX_BGSPRITEID 3

//for export map
#constant V_EXPORT_SAVESLOT 0

//for object preview

//for MAP
#constant V_MAP_TSIZE 0
#constant V_MAP_MAPX 1
#constant V_MAP_MAPY 2
#constant V_MAP_MAPSIZE 3
#constant V_MAP_LAYERNOW 4
#constant V_MAP_TOGGLELAYERCOLOR 5

//for TileSelect
#constant V_TS_TSIZE 0
#constant V_TS_MAPX 1
#constant V_TS_MAPY 2
#constant V_TS_DRAWTILE 3
#constant V_TS_DTCOUNT 4
#constant V_TS_ROTATE 5

//for map ed cam
#constant V_MAPCAM_STARTX 0
#constant V_MAPCAM_STARTY 1

//for smoke
#constant V_SMOKE_ALPHANOW 0
#constant V_SMOKE_NEXTTIME 1
#constant V_SMOKE_INITX 2
#constant V_SMOKE_INITY 3
#constant V_SMOKE_INITZ 4
#constant V_SMOKE_SIZENOW 5
#constant V_SMOKE_DARKER 6

//for item
#constant V_ITEM_INITX 0
#constant V_ITEM_INITZ 1
#constant V_ITEM_TYPE 2
#constant V_ITEM_LIGHT 3

//for msg
#constant V_MSG_TEXTID 0
#constant V_MSG_TEXTSIZE 1
#constant V_MSG_SLOT 2
#constant V_MSG_INITPOS 3
#constant V_MSG_SHOWTIME 4
#constant V_MSG_NEXTTIME 5

//for dmg effect
#constant V_HUDDMG_REDID 0
#constant V_HUDDMG_GREENID 1
#constant V_HUDDMG_YELID 2
#constant V_HUDDMG_ALPHANOW 3
#constant V_HUDDMG_COLORACTIVE 4

//for counter
#constant V_COUNTER_NUMNOW 0
#constant V_COUNTER_NUMREC 1
#constant V_COUNTER_INITPOS 2
#constant V_COUNTER_INITTEXTSIZE 3
#constant V_COUNTER_IMG 4
#constant V_COUNTER_COUNTTEXTID 5
#constant V_COUNTER_TITLETEXTID 6
#constant V_COUNTER_SPR 7
#constant V_COUNTER_USEIMG 8


//for burst
#constant V_BURST_OFFSETX 0
#constant V_BURST_OFFSETY 1
#constant V_BURST_OFFSETZ 2
#constant V_BURST_NEXTTIME 3

//for levelgen
#constant V_LEVELGEN_LEVEL 0
#constant V_LEVELGEN_SLOT 1

//for weap
#constant V_WEAP_FOLLOWTHING 0
#constant V_WEAP_XOFFSET 1
#constant V_WEAP_YOFFSET 2
#constant V_WEAP_ZOFFSET 3
#constant V_WEAP_BXOFFSET 4
#constant V_WEAP_BYOFFSET 5
#constant V_WEAP_BZOFFSET 6 
#constant V_WEAP_NEXTTIME 7
#constant V_WEAP_ATTACKTIME 8
#constant V_WEAP_AMMOROCKET 9
#constant V_WEAP_SHOT_B 10
#constant V_WEAP_SHOT_E 11
#constant V_WEAP_SHOT_T 12
#constant V_WEAP_RELOAD_B 13
#constant V_WEAP_RELOAD_E 14
#constant V_WEAP_RELOAD_T 15
#constant V_WEAP_AMMO 16
#constant V_WEAP_AMMOMAX 17
#constant V_WEAP_SPAREAMMO 18
#constant V_WEAP_SPAREAMMOMAX 19
#constant V_WEAP_ISROCKETLAUNCHER 20
#constant V_WEAP_SPREAD 21
#constant V_WEAP_MOVE_B 22
#constant V_WEAP_MOVE_E 23
#constant V_WEAP_MOVE_T 24
#constant V_WEAP_RANONCE 25
#constant V_WEAP_ENTER_B 26
#constant V_WEAP_ENTER_E 27
#constant V_WEAP_ENTER_T 28
#constant V_WEAP_LEAVE_B 29
#constant V_WEAP_LEAVE_E 30
#constant V_WEAP_LEAVE_T 31
#constant V_WEAP_NORELOADANIM 32
#constant V_WEAP_LIGHT 33
#constant V_WEAP_TWEENDONE 34
#constant V_WEAP_MELEE 35
#constant V_WEAP_BULLETMAXDIST 36
#constant V_WEAP_BULLETCASTSIZE 37
#constant V_WEAP_BULLETSPEED 38
#constant V_WEAP_BULLETHIDE 39
#constant V_WEAP_BULLETDMG 40
#constant V_WEAP_SHOTSOUND 41
#constant V_WEAP_RELOADSOUND 42
#constant V_WEAP_EMPTYSOUND 43


//for shadow
#constant V_SHADOW_FOLLOWTHING 0

//for splash
#constant V_SPLASH_INITX 0
#constant V_SPLASH_INITY 1
#constant V_SPLASH_INITZ 2
#constant V_SPLASH_CURFRAME 3
#constant V_SPLASH_MAXFRAME 4
#constant V_SPLASH_NEXTTIME 5
#constant V_SPLASH_LOOP 6
#constant V_SPLASH_ANIMSPEED 7

//for explode
#constant V_EXPLODE_INITX 0
#constant V_EXPLODE_INITY 1
#constant V_EXPLODE_INITZ 2
#constant V_EXPLODE_CURFRAME 3
#constant V_EXPLODE_MAXFRAME 4
#constant V_EXPLODE_NEXTTIME 5
#constant V_EXPLODE_LOOP 6
#constant V_EXPLODE_ANIMSPEED 7

//for bullet
#constant V_BULLET_SPEED 0
#constant V_BULLET_LOOKAT 1
#constant V_BULLET_STARTTHING 2
#constant V_BULLET_FORWARD 3
#constant V_BULLET_UP 4
#constant V_BULLET_RIGHT 5
#constant V_BULLET_DMG 6
#constant V_BULLET_NOSPLASH 7
#constant V_BULLET_RCX 8
#constant V_BULLET_RCY 9
#constant V_BULLET_RCZ 10
#constant V_BULLET_HIDE 11
#constant V_BULLET_SPREAD 12
#constant V_BULLET_MAXDIST 13
#constant V_BULLET_TRAVELDIST 14
#constant V_BULLET_IGNORE 15
#constant V_BULLET_ISROCKET 16
#constant V_BULLET_SCASTSIZE 17
#constant V_BULLET_NOSMOKE 18
#constant V_BULLET_SMOKENEXTTIME 19
#constant V_BULLET_SPILLBLOOD 20
#constant V_BULLET_LIGHTFLASH 21
#constant V_BULLET_LIGHT 22
#constant V_BULLET_LIGHTNEXTTIME 23
#constant V_BULLET_BURSTPLANE 24
//for enemy
#constant V_ENEMY_NEXTTIME 0
#constant V_ENEMY_SPEED 1
#constant V_ENEMY_TX 2	//target xyz
#constant V_ENEMY_TY 3
#constant V_ENEMY_TZ 4
#constant V_ENEMY_TARGETDONE 5
#constant V_ENEMY_CHARID 6
#constant V_ENEMY_ROTSPEED 7
#constant V_ENEMY_ATTACKNEXTTIME 8
#constant V_ENEMY_HP 9
#constant V_ENEMY_RDMG 10	//receive damage
#constant V_ENEMY_INITX 11	
#constant V_ENEMY_INITY 12
#constant V_ENEMY_INITZ 13
#constant V_ENEMY_RANGE 14
#constant V_ENEMY_ANIM_IDLE_B 15
#constant V_ENEMY_ANIM_IDLE_E 16
#constant V_ENEMY_ANIM_IDLE_T 17
#constant V_ENEMY_ANIM_DIE_B 18
#constant V_ENEMY_ANIM_DIE_E 19
#constant V_ENEMY_ANIM_DIE_T 20
#constant V_ENEMY_ANIM_MOVE_B 21
#constant V_ENEMY_ANIM_MOVE_E 22
#constant V_ENEMY_ANIM_MOVE_T 23
#constant V_ENEMY_ANIM_ATTACK_B 24
#constant V_ENEMY_ANIM_ATTACK_E 25
#constant V_ENEMY_ANIM_ATTACK_T 26
#constant V_ENEMY_ANIMNOW 27
#constant V_ENEMY_USETEMPLATE 28
#constant V_ENEMY_PROJECTILEDIST 29
#constant V_ENEMY_ATTACKRANGE 30
#constant V_ENEMY_ATTACKWAIT 31
#constant V_ENEMY_TMPLFORBULLET 32
#constant V_ENEMY_USEROCKET 33
#constant V_ENEMY_HITBOXFLOAT 34
#constant V_ENEMY_PROJECTILESPREAD 35
#constant V_ENEMY_PROJECTILESCASTSIZE 36
#constant V_ENEMY_PROJECTILEUP 37
#constant V_ENEMY_FORWARDTIME 38
#constant V_ENEMY_LFLASHONATTACK 39
#constant V_ENEMY_SNDATTACK 40
#constant V_ENEMY_SNDALERT 41
#constant V_ENEMY_SNDDIE 42
#constant V_ENEMY_SNDFORWARD 43
//for HUD
#constant V_HUD_STEPCOUNT 0


//for object placer
#constant V_OBJPLACE_TSLOT 0
#constant V_OBJPLACE_YADJ 1

//for pause
#constant V_PAUSE_SWITCH 0

//for trigger
#constant V_TRIGGER_THING 0
#constant V_TRIGGER_INITX 1
#constant V_TRIGGER_INITY 2
#constant V_TRIGGER_INITZ 3
#constant V_TRIGGER_MSGSLOT 4

//for game msg
#constant V_GAMEMSG_NEXTTIME 0
#constant V_GAMEMSG_SLOT 1

//for key
#constant V_KEY_COLOR 0	//0 - RED, 1 - BLUE, 2 - YELLOW
#constant V_KEY_INITX 1
#constant V_KEY_INITY 2
#constant V_KEY_INITZ 3

//for inventory
#constant V_INVENTORY_HASREDKEY 0
#constant V_INVENTORY_HASBLUKEY 1
#constant V_INVENTORY_HASYELKEY 2
#constant V_INVENTORY_WEAPNOW 3
#constant V_INVENTORY_WEAPMAX 4
#constant V_INVENTORY_HASMELEE 5
#constant V_INVENTORY_HASGUN 6
#constant V_INVENTORY_HASRIFLE 7
#constant V_INVENTORY_HASRLAUNCHER 8
#constant V_INVENTORY_GUN_SPAREAMMO 9
#constant V_INVENTORY_GUN_AMMO 10
#constant V_INVENTORY_RIFLE_SPAREAMMO 11
#constant V_INVENTORY_RIFLE_AMMO 12
#constant V_INVENTORY_ROCKET_SPAREAMMO 13
#constant V_INVENTORY_ROCKET_AMMO 14
#constant V_INVENTORY_COINS 15
#constant V_INVENTORY_GEMS 16
#constant V_INVENTORY_HASTRIDENT 17
#constant V_INVENTORY_NEXTTIME 18

//for doors
#constant V_DOOR_INITX 0
#constant V_DOOR_INITY 1
#constant V_DOOR_INITZ 2
#constant V_DOOR_MOVESPEED 3
#constant V_DOOR_MOVEMAX 4
#constant V_DOOR_MOVECOUNT 5
#constant V_DOOR_WAIT 6
#constant V_DOOR_NEXTTIME 7
#constant V_DOOR_TYPE 8
#constant V_DOOR_REQREDKEY 9
#constant V_DOOR_REQBLUKEY 10
#constant V_DOOR_REQYELKEY 11
#constant V_DOOR_REQTRIGGER 12

#constant V_DOOR_INITYROT 13

//for player
#constant V_PLAYER_SPEED 0
#constant V_PLAYER_ACCEL 1
#constant V_PLAYER_ACCELSTEP 2

#constant V_PLAYER_STRAFESPEED 3
#constant V_PLAYER_STRAFEACCEL 4
#constant V_PLAYER_STRAFEACCELSTEP 5

#constant V_PLAYER_FRICTION 6

#constant V_PLAYER_JUMPSPEED 7
#constant V_PLAYER_JUMPINIT 8
#constant V_PLAYER_JUMPING 9

#constant V_PLAYER_FALLING 10

#constant V_PLAYER_ACTIONACTIVATE 11
#constant V_PLAYER_CHARID 12
#constant V_PLAYER_SHADOWID 13

#constant V_PLAYER_IDLEANIM 14
#constant V_PLAYER_RUNANIM 15
#constant V_PLAYER_JUMPANIM 16
#constant V_PLAYER_FALLANIM 17
#constant V_PLAYER_ACTIONANIM 18
#constant V_PLAYER_DMGREC 19

#constant V_PLAYER_HP 20
#constant V_PLAYER_HITBOX 21
#constant V_PLAYER_DEADMAXROT 22
#constant V_PLAYER_DEADMAXMOVE 23

#constant V_PLAYER_MOVED 24
#constant V_PLAYER_WALKSNDNUM 25
#constant V_PLAYER_WALKSNDNEXTT 26

//for levelgeo
#constant V_LEVELGEO_P1 0
#constant V_LEVELGEO_P2 1
#constant V_LEVELGEO_P3 2
#constant V_LEVELGEO_P4 3
#constant V_LEVELGEO_P5 4
#constant V_LEVELGEO_P6 5
#constant V_LEVELGEO_P7 6
#constant V_LEVELGEO_P8 7
#constant V_LEVELGEO_TEX1 8
#constant V_LEVELGEO_TEX2 9
#constant V_LEVELGEO_TEX3 10
#constant V_LEVELGEO_TEX4 11
#constant V_LEVELGEO_TEX5 12

//anim controller
#constant V_ANIMC_STARTTIME 0
#constant V_ANIMC_ENDTIME 1
#constant V_ANIMC_TTIME 2

//for camera
#constant V_CAMERA_SKYBOXID 0

//------------------------------------
//PROGS
//------------------------------------
#constant PROG_END_EVAL 1
#constant PROG_PLAYER 2
#constant PROG_FREECAM 3
#constant PROG_LEVELGEO 4
#constant PROG_CAMERA 5
#constant PROG_DOOR 6
#constant PROG_INVENTORY 7
#constant PROG_KEY 8
#constant PROG_GAMEMSG 9
#constant PROG_TRIGGER 10
#constant PROG_PAUSE 11
#constant PROG_TEMPS 12
#constant PROG_OBJPLACE 13
#constant PROG_HUD 14
#constant PROG_ENEMY 15
#constant PROG_BULLET 16

#constant PROG_SPLASH 18
#constant PROG_SHADOW 19
#constant PROG_LEVELGEN 20
#constant PROG_WEAP 21
#constant PROG_BURST 22
#constant PROG_EXPLODE 23
#constant PROG_ANIMCON 24
#constant PROG_COUNTER 25
#constant PROG_HUDDMG 26
#constant PROG_HUDMSG 27
#constant PROG_ITEM 28
#constant PROG_SMOKE 29
#constant PROG_BLOOD 30
#constant PROG_TILESELECT 31
#constant PROG_MAPCAM 32
#constant PROG_MAP 33
#constant PROG_OBJPRV 34
#constant PROG_EXPORTMAP 35
#constant PROG_CHOOSEBOX 36
#constant PROG_CROSSHAIR 37
#constant PROG_EXIT 38
#constant PROG_CHANGESCENE 39
#constant PROG_MAPSETUP 40
#constant PROG_LVLSELECT 41
