#constant MAXTHINGS = 512
#constant MAXTHINGVARS = 255
#constant MAXTEMPLATES = 255



//5 - level editor | 4 - start level
#constant INITSCENE 6
#constant FOV 100//100
#constant SHOWHITBOXES 0
#constant TILESIZE 16

#constant SCENE_LVLDISPLAY 4
#constant SCENE_EDITOR 5

#constant KEY_A = 65
#constant KEY_I = 73
#constant KEY_J = 74
#constant KEY_K = 75
#constant KEY_L = 76

#constant KEY_M = 77
#constant KEY_N = 78

#constant KEY_O = 79
#constant KEY_P = 80
#constant KEY_W = 87
#constant KEY_S = 83
#constant KEY_D = 68
#constant KEY_E = 69
#constant KEY_Q = 81
#constant KEY_R = 82
#constant KEY_X = 88
#constant KEY_Z = 90
#constant KEY_SPACE = 32
#constant KEY_LEFT = 37
#constant KEY_UP = 38
#constant KEY_RIGHT = 39
#constant KEY_DOWN = 40
#constant KEY_F1 = 112

#constant YES = 1
#constant NO = 0
#constant TRUE = 1
#constant FALSE = 0

#constant HASCHILD = 1
#constant NOCHILD = 0

#constant THING_TYPE_NONE = 0
#constant THING_TYPE_OBJ = 1

#constant STATE_INIT = 0
#constant STATE_MAIN = 1
#constant STATE_IDLE = 2
#constant STATE_DEAD = 3
#constant STATE_PAUSE = 4
#constant STATE_UNPAUSE = 5
#constant STATE_THIRDPERSONMODE = 6
#constant STATE_FIRSTPERSONMODE = 7
#constant STATE_LOCKED = 8
#constant STATE_OPENDOOR = 9
#constant STATE_OPENDOORUP = 10
#constant STATE_CLOSEDOORDOWN = 11
#constant STATE_ATTACK = 12
#constant STATE_WAIT = 13
#constant STATE_TRIGGER = 14
#constant STATE_HIT = 15
#constant STATE_FORWARD = 16
#constant STATE_LOOKAT = 17
#constant STATE_LOOKRANDOM = 18
#constant STATE_BURST = 19
#constant STATE_NOBURST = 20
#constant STATE_BURSTSTART = 21
#constant STATE_DISSAPEAR = 22
#constant STATE_RELOAD = 23
#constant STATE_UPDATE = 24
#constant STATE_UPDATE2 = 25
#constant STATE_DEAD2 = 26
#constant STATE_DEADPREPARE = 27
#constant STATE_EFFECTRED = 28
#constant STATE_EFFECTGREEN = 29
#constant STATE_EFFECTDOWN = 30
#constant STATE_EFFECTREDSTAY = 31
#constant STATE_EFFECTYELLOW = 32
#constant STATE_HIDE = 33
#constant STATE_SHOW = 34
#constant STATE_SAVE = 35
#constant STATE_CHOOSE = 36
#constant STATE_EXPORT = 37

#constant TEXT_MSG 1

#constant CAM_MAIN 1

#constant TMPL_NONE 0
#constant TMPL_GEM 1
#constant TMPL_ENMY1 2
#constant TMPL_DEER 3
#constant TMPL_BULLET 4
#constant TMPL_TRIDENT 5
#constant TMPL_SPLASHPLANE 6
#constant TMPL_SHADOWPLANE 7
#constant TMPL_GRASS 8
#constant TMPL_WEAPRIFLE 9
#constant TMPL_BURSTPLANE 10
#constant TMPL_WALLDOOR 11
#constant TMPL_WALLDOORFRAME 12
#constant TMPL_WALL 13
#constant TMPL_WALLCORNER 14
#constant TMPL_SKELETON 15
#constant TMPL_GOLEM 16
#constant TMPL_WEAPRPG7 17
#constant TMPL_RPG7ROCKET 18
#constant TMPL_BOULDER 19
#constant TMPL_MEDPACK 20
#constant TMPL_AMMO 21
#constant TMPL_KEY 23
#constant TMPL_WEAPGUN 24
#constant TMPL_ITEMPISTOL 25
#constant TMPL_ITEMRIFLE 26
#constant TMPL_ITEMLAUNCHER 27
#constant TMPL_TILESELECT 28
#constant TMPL_MEPLAYER 29
#constant TMPL_KEYR 30
#constant TMPL_KEYY 31
#constant TMPL_KEYB 32
#constant TMPL_MEREDWALLDOOR 33
#constant TMPL_MEYELWALLDOOR 34
#constant TMPL_MEBLUWALLDOOR 35
#constant TMPL_CRATE 36
#constant TMPL_EXIT1 37
#constant TMPL_EXIT2 38
#constant TMPL_COIN 39
#constant TMPL_SKELSOLDIER 40
#constant TMPL_FBARREL 41
#constant TMPL_FBARREL3 42
#constant TMPL_BARREL 43
#constant TMPL_TWALLNORTH 44
#constant TMPL_TWALLSOUTH 45
#constant TMPL_FLOORCEIL 46
#constant TMPL_TORCH 47
#constant TMPL_WHITELIGHT 48
#constant TMPL_REDLIGHT 49
#constant TMPL_BLUELIGHT 50
#constant TMPL_GREENLIGHT 51
#constant TMPL_WCSTARTNORTH 52
#constant TMPL_WCSTARTSOUTH 53
#constant TMPL_LAST 54

#constant IMG_TEXPLAYER 1
#constant IMG_ROCKBROWN 2
#constant IMG_BRICK 3
#constant IMG_GRASS 4
#constant IMG_PLATFORM 5
#constant IMG_DEER 6
#constant IMG_COLT 7
#constant IMG_SPLASHATLAS 8
#constant IMG_SPLASHSTART 9
#constant IMG_SPLASHEND 24
#constant IMG_EXPLODEATLAS 25
#constant IMG_EXPLODESTART 26
#constant IMG_EXPLODEEND 41
#constant IMG_SHADOW 42
#constant IMG_RIFLE 43
#constant IMG_BURST 44
#constant IMG_METALDOOR 45
#constant IMG_SKELETON 46
#constant IMG_ROCKDARK 47
#constant IMG_RPG7 48
#constant IMG_MAINFONT 49
#constant IMG_RED 50
#constant IMG_GREEN 51
#constant IMG_BLUE 52
#constant IMG_YELLOW 53
#constant IMG_MEDPACK 54
#constant IMG_AMMO 55
#constant IMG_SMOKE 56
#constant IMG_BLOODATLAS 57
#constant IMG_BLOODSTART 58
#constant IMG_BLOODEND 73
#constant IMG_GCOLORATLAS 74
#constant IMG_GCOLORRED 75
#constant IMG_GCOLORGREEN 76
#constant IMG_GCOLORBLUE 77
#constant IMG_GCOLORYELLOW 78
#constant IMG_GUN 79
#constant IMG_ITEMPISTOL 80
#constant IMG_ITEMRIFLE 81
#constant IMG_ITEMLAUNCHER 82
#constant IMG_MAPEDBTNATLAS1 83
#constant IMG_MAPEDBTNATLAS2 84
#constant IMG_MEBTNLAYER1UP 85
#constant IMG_MEBTNLAYER2UP 86
#constant IMG_MEBTNLAYER3UP 87
#constant IMG_MEBTNLAYER1DN 88
#constant IMG_MEBTNLAYER2DN 89
#constant IMG_MEBTNLAYER3DN 90
#constant IMG_MEBTNEXPORTUP 91
#constant IMG_MEBTNEXPORTDN 92
#constant IMG_MEBTNPLACEUP 93
#constant IMG_MEBTNPLACEDN 94
#constant IMG_MEBTNLEFTUP 95
#constant IMG_MEBTNLEFTDN 96
#constant IMG_MEBTNRIGHTUP 97
#constant IMG_MEBTNRIGHTDN 98
#constant IMG_DIALOGBTNATLAS 99
#constant IMG_DIALOGBTNYES 100
#constant IMG_DIALOGBTNNO 101
#constant IMG_CROSSHAIR 102
#constant IMG_CRATE 103
#constant IMG_COIN 104
#constant IMG_SKELSOLDIER 105
#constant IMG_EXIT 106
#constant IMG_ICONHEALTH 107
#constant IMG_ICONAMMO 108
#constant IMG_ICONCOIN 109
#constant IMG_ICONLIVES 110
#constant IMG_ICONATLAS 111
#constant IMG_FBARREL 112
#constant IMG_BARREL 113
#constant IMG_CONCREATE 114
#constant IMG_CHECKERFLOOR 115
#constant IMG_CLASSICBRICK 116
#constant IMG_TORCH 117
#constant IMG_MEBTNDEL 118
#constant IMG_GEM 119
#constant IMG_ICONGEM 120
#constant IMG_TRIDENT 121
#constant IMG_SKYBOX 122
#constant IMG_GBUTTONSATLAS 123
#constant IMG_GBUTTON_OPEN 124
#constant IMG_GBUTTON_JUMP 125
#constant IMG_GBUTTON_JOYU 126
#constant IMG_GBUTTON_JOYD 127

#constant ANIM_IDLE_B 0
#constant ANIM_IDLE_E 1.65

//2.4
#constant ANIM_RUN_B 2.5
#constant ANIM_RUN_E 4.2
#constant ANIM_JUMP_B 4.6
#constant ANIM_JUMP_E 5.4
#constant ANIM_FALL_B 9.2
#constant ANIM_FALL_E 9.25
#constant ANIM_ACTION_B 9.8
#constant ANIM_ACTION_E 10.5

#constant ANIM_DEERWALK_B 1.879
#constant ANIM_DEERWALK_E 2.809
#constant ANIM_DEERWALK_T 0.08
#constant ANIM_DEERDIE_B 3.37
#constant ANIM_DEERDIE_E 4.5
#constant ANIM_DEERDIE_T 0.2
#constant ANIM_DEERATTACK_B 0.6
#constant ANIM_DEERATTACK_E 1.1
#constant ANIM_DEERATTACK_T 0.2
#constant ANIM_DEERIDLE_B 0
#constant ANIM_DEERIDLE_E 0.1
#constant ANIM_DEERIDLE_T 0.1

#constant ANIM_SKELWALK_B	2.459
#constant ANIM_SKELWALK_E	3.099
#constant ANIM_SKELWALK_T	0.05
#constant ANIM_SKELDIE_B	6.60
#constant ANIM_SKELDIE_E	7.22
#constant ANIM_SKELDIE_T	0.01
#constant ANIM_SKELATTACK_B	5.10
#constant ANIM_SKELATTACK_E	5.83
#constant ANIM_SKELATTACK_T	0.05
#constant ANIM_SKELIDLE_B	0
#constant ANIM_SKELIDLE_E	1.529
#constant ANIM_SKELIDLE_T	0.250

#constant ANIM_GOLEMWALK_B	2.5
#constant ANIM_GOLEMWALK_E	4.2
#constant ANIM_GOLEMWALK_T	0.03
#constant ANIM_GOLEMDIE_B	6.65
#constant ANIM_GOLEMDIE_E	8.00
#constant ANIM_GOLEMDIE_T	0.05
#constant ANIM_GOLEMATTACK_B	5
#constant ANIM_GOLEMATTACK_E	6.30
#constant ANIM_GOLEMATTACK_T	0.05
#constant ANIM_GOLEMIDLE_B	0
#constant ANIM_GOLEMIDLE_E	1.7
#constant ANIM_GOLEMIDLE_T	0.08

#constant ANIM_RIFLESHOT_B 0.0
#constant ANIM_RIFLESHOT_E 0.4
#constant ANIM_RIFLESHOT_T 0.0
#constant ANIM_RIFLERELOAD_B 0.4
#constant ANIM_RIFLERELOAD_E 1.5
#constant ANIM_RIFLERELOAD_T 0.0
#constant ANIM_RIFLEMOVE_B 0
#constant ANIM_RIFLEMOVE_E 0 
#constant ANIM_RIFLEMOVE_T 0
#constant ANIM_RIFLELEAVE_B 0.60
#constant ANIM_RIFLELEAVE_E 0.70
#constant ANIM_RIFLELEAVE_T 0.05

#constant ANIM_RPG7SHOT_B 0.0
#constant ANIM_RPG7SHOT_E 1.5
#constant ANIM_RPG7SHOT_T 0.0

#constant ANIM_TRIDENTSHOT_B 0.4
#constant ANIM_TRIDENTSHOT_E 1.25
#constant ANIM_TRIDENTSHOT_T 0.05
#constant ANIM_TRIDENTLEAVE_B 1.40
#constant ANIM_TRIDENTLEAVE_E 1.90
#constant ANIM_TRIDENTLEAVE_T 0.05


#constant ANIM_GUNENTER_B 1.25
#constant ANIM_GUNENTER_E 2.10
#constant ANIM_GUNENTER_T 0.05
#constant ANIM_GUNLEAVE_B 0.60
#constant ANIM_GUNLEAVE_E 1.30
#constant ANIM_GUNLEAVE_T 0.05
#constant ANIM_GUNSHOT_B 0.0
#constant ANIM_GUNSHOT_E 0.4
#constant ANIM_GUNSHOT_T 0.01
#constant ANIM_GUNRELOAD_B 0.64
#constant ANIM_GUNRELOAD_E 2.10
#constant ANIM_GUNRELOAD_T 0.03
#constant ANIM_GUNMOVE_B 2.30
#constant ANIM_GUNMOVE_E 3.13
#constant ANIM_GUNMOVE_T 0.05

#constant LIGHT_BURST 1

#constant MEM_LEVEL 1

#constant POS_TOPLEFT 0
#constant POS_TOPCENTER 1
#constant POS_TOPRIGHT 2
#constant POS_BOTTOMLEFT 3
#constant POS_BOTTOMCENTER 4
#constant POS_BOTTOMRIGHT 5
#constant POS_CENTER 6
#constant POS_CENTERLEFT 7
#constant POS_CENTERRIGHT 8


#constant NUM_STARTRIFLEAMMO 30
#constant NUM_STARTRIFLESPAREAMMO 99
#constant NUM_HUDTEXTSIZE 48


#constant ITEM_HEALTH 0
#constant ITEM_AMMO 1
#constant ITEM_REDKEY 2
#constant ITEM_YELKEY 3
#constant ITEM_BLUKEY 4
#constant ITEM_PISTOL 5
#constant ITEM_RIFLE 6
#constant ITEM_LAUNCHER 7
#constant ITEM_COIN 8
#constant ITEM_GEM 9

#constant JOYL 1
#constant JOYR 2

#constant VBUTTON1 1
#constant VBUTTON2 2
#constant VBUTTON3 3
#constant VBUTTON4 4
#constant VBUTTON5 5
#constant VBUTTON6 6
#constant VBUTTON7 7

#constant VBUTTON8 8
#constant VBUTTON9 9
#constant VBUTTON10 10

#constant MAPFILE_NEWLINE "NEWLINE"
#constant MAPFILE_NEWLAYER "NEWLAYER"
#constant MAPFILE_END "ENDOFFILE"

#constant LIGHTSTART 10
#constant LIGHTEND 999

#constant TWEENCHAIN_WEAP 1
#constant TWEEN_WEAP_P1 2
#constant TWEEN_WEAP_P2 3

#constant SND_SHOT 1
#constant SND_DRY 2
#constant SND_EXPLODE 3
#constant SND_GATE 4
#constant SND_HITENEMY 5
#constant SND_RELOAD 6
#constant SND_RICO1 7
#constant SND_RICO2 8
#constant SND_ROCKETSHOT 9
#constant SND_SKELFALL 10
#constant SND_SWING 11
#constant SND_UGH1 12
#constant SND_UGH2 13
#constant SND_DIE 14
#constant SND_PICKUP1 15
#constant SND_PICKUP2 16
#constant SND_JUMP 17
#constant SND_LAND 18
#constant SND_AMMO 19
#constant SND_WALK1 20
#constant SND_WALK2 21
#constant SND_SWING2 23
#constant SND_SCREECH1 24
#constant SND_SCREECH2 25
#constant SND_FALL1 26
#constant SND_FALL2 27
#constant SND_COMPLETE 28
#constant SND_ERROR 29
#constant SND_DOOROPEN 30
#constant SND_DOORLOCKED 31
#constant SND_COIN 32
#constant SND_1UP 33
