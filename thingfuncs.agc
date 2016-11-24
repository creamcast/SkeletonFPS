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

function TemplateController(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
		endcase
	endselect
endfunction

function ProgLvlSelect(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			pos as Coord2d
			text as integer
			lvlnow as integer
			
			things[this].vars[V_LVLSELECT_MAX] = 30// ReadLevel()
			if things[this].vars[V_LVLSELECT_MAX] < 1
			//	things[this].vars[V_LVLSELECT_MAX] = 1
			endif
			things[this].vars[V_LVLSELECT_CLVL] = things[this].vars[V_LVLSELECT_MAX]
			lvlnow = things[this].vars[V_LVLSELECT_CLVL]
			
			AddVirtualButton(VBUTTON1, 0 + 128, tgame.window_height/2, 128)
			AddVirtualButton(VBUTTON2, tgame.window_width - 128, tgame.window_height/2, 128)
			AddVirtualButton(VBUTTON3, tgame.window_width/2, tgame.window_height - 128, 128)
			SetVirtualButtonImageUp(VBUTTON1, IMG_MEBTNLEFTUP)
			SetVirtualButtonImageUp(VBUTTON2, IMG_MEBTNRIGHTUP)
			SetVirtualButtonImageDown(VBUTTON1, IMG_MEBTNLEFTDN)
			SetVirtualButtonImageDown(VBUTTON2, IMG_MEBTNRIGHTDN)
			SetVirtualButtonAlpha(VBUTTON1, 255)
			SetVirtualButtonAlpha(VBUTTOn2, 255)
			
			things[this].vars[V_LVLSELECT_TEXT] = CreateText("LEVEL " + AddZeros(2,STR(lvlnow)))
			text = things[this].vars[V_LVLSELECT_TEXT]
			SetTextFontImage(text, IMG_MAINFONT)
			SetTextSize(text, 80)
			GetHudPos(tgame, GetTextTotalWidth(text), GetTextTotalHeight(text), POS_CENTER, pos)
			SetTextPosition(text, pos.x,pos.y)
			
			//create title
			title as integer
			title = CreateText("SELECT LEVEL")
			SetTextFontImage(title, IMG_MAINFONT)
			SetTextSize(title, 48)
			GetHudPos(tgame, GetTextTotalWidth(title), GetTextTotalHeight(title), POS_TOPCENTER, pos)
			SetTextPosition(title, pos.x,pos.y)		
			
			//create bg
			bg as integer
			bg = CreateSprite(IMG_GRASS)
			SetSpriteUVScale( bg, 0.4, 0.4 ) 
			SetImageWrapU ( IMG_GRASS, 1 )
			SetImageWrapV ( IMG_GRASS, 1 ) 
			SetSpriteSize(bg, tgame.window_width, tgame.window_height)

			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			level as integer
			If GetVirtualButtonPressed(VBUTTON1) = 1
				dec things[this].vars[V_LVLSELECT_CLVL], 1
				if things[this].vars[V_LVLSELECT_CLVL] <= 0
					things[this].vars[V_LVLSELECT_CLVL] = things[this].vars[V_LVLSELECT_MAX]
				endif
				level = things[this].vars[V_LVLSELECT_CLVL]
				PlaySound(SND_SHOT)
			elseif GetVirtualButtonPressed(VBUTTON2) = 1
				inc things[this].vars[V_LVLSELECT_CLVL], 1
				if things[this].vars[V_LVLSELECT_CLVL] > things[this].vars[V_LVLSELECT_MAX]
					things[this].vars[V_LVLSELECT_CLVL] = 1
				endif
				level = things[this].vars[V_LVLSELECT_CLVL]
				PlaySound(SND_SHOT)
			elseif GetVirtualButtonPressed(VBUTTON3) = 1
				PlaySound(SND_EXPLODE)
				things[this].state  = STATE_DEAD
			endif			
			
			if level <> 0
				SetTextString(things[this].vars[V_LVLSELECT_TEXT], "LEVEL " + AddZeros(2,STR(level)))
			endif
		endcase
		
		case STATE_DEAD
			if things[this].vars[V_LVLSELECT_CLVL] = 30
				ChangeScene(tgame, SCENE_EDITOR)
			else
				tgame.currentslot = things[this].vars[V_LVLSELECT_CLVL] - 1
				ChangeScene(tgame, SCENE_LVLDISPLAY)
			endif
		endcase
	endselect
endfunction

function ProgChangeScene(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			if things[this].vars[V_CHANGESCENE_WAIT] = 0 then things[this].vars[V_CHANGESCENE_WAIT] = 1000
			
			things[this].vars[V_CHANGESCENE_NEXTTIME] = things[this].vars[V_CHANGESCENE_WAIT] + tgame.ms
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			If tgame.ms > things[this].vars[V_CHANGESCENE_NEXTTIME]
				things[this].state = STATE_DEAD
			endif
		endcase
		
		case STATE_DEAD
			ChangeScene(tgame, things[this].vars[V_CHANGESCENE_SCENENEXT])
			ClearThing(things, this)
		endcase
	endselect
endfunction

function ProgExit(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			x as integer
			z as integer
			i as integer
			gemcount as integer
			x = things[this].vars[V_EXIT_INITX]
			z = things[this].vars[V_EXIT_INITZ]
			
			things[this].vars[V_EXIT_SECONDPART] = CloneTObject(tgame, TMPL_EXIT2)
			SetObjectTransparency(things[this].vars[V_EXIT_SECONDPART], 1)
			SetObjectCollisionMode(things[this].vars[V_EXIT_SECONDPART],0)
			SetObjectPosition(things[this].id, x, 0, z)
			SetObjectPosition(things[this].vars[V_EXIT_SECONDPART], x, 0, z)
			SetObjectVisible(things[this].vars[V_EXIT_SECONDPART], 0) //hide it until player gets all gems
			//count num gems
			for i = T_ENEMYSTART to T_ENEMYEND
				if things[i].used = YES
					inc gemcount
				endif
			next 
			things[this].vars[V_EXIT_GEMREQ] = gemcount
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			if things[T_PLAYER].used = YES and things[T_INVENTORY].used = YES
				thisobj as ObjInfo
				GetObjectInfo(things[this].id, thisobj)
				if ObjectSphereCast(things[T_PLAYER].id, thisobj.x,thisobj.y,thisobj.z, thisobj.x,thisobj.y+1,thisobj.z, 1)	
					if things[T_INVENTORY].vars[V_INVENTORY_GEMS] = things[this].vars[V_EXIT_GEMREQ]
						ShowMessage(things, 16, POS_CENTER, 2000, 32)
						things[this].vars[V_EXIT_NEXTTIME] = tgame.ms + 2500
						things[this].state = STATE_DEAD
						PlaySound(SND_COMPLETE)
					else 
						if things[T_HUDMSG].used = NO
							PlaySound(SND_ERROR)
							ShowMessage(things, 18, POS_CENTER, 2500, 28)			
						endif
					endif
				endif
				
				if things[T_INVENTORY].vars[V_INVENTORY_GEMS] = things[this].vars[V_EXIT_GEMREQ]
					uselight as integer
					SetObjectVisible(things[this].vars[V_EXIT_SECONDPART], 1) //reveal it when player  gets all gems
					if things[this].vars[V_EXIT_LIGHT] = 0
						ShowMessage(things, 19, POS_CENTER, 2000, 24) //show gate activated message
						uselight = GetEmptyLight(LIGHTSTART, LIGHTEND)
						if uselight <> -1
							CreatePointLight(uselight, GetObjectX(things[this].id), 3, GetObjectZ(things[this].id), 25, 100, 255, 255)
							SetPointLightMode(uselight, 1)
							things[this].vars[V_EXIT_LIGHT] = uselight
							PlaySound(SND_GATE)
						endif
					endif
					
				endif
			endif
		endcase
		
		case STATE_DEAD
			if tgame.ms > things[this].vars[V_EXIT_NEXTTIME]
				tgame.carry_coin = things[T_INVENTORY].vars[V_INVENTORY_COINS]
				ChangeScene(tgame, 4) //goto next level
				if things[this].vars[V_EXIT_LIGHT] <> 0
					DeletePointLight(things[this].vars[V_EXIT_LIGHT])
				endif
				ClearThing(things, this)
			endif
		endcase
	endselect
endfunction

function ProgCrosshair(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			pos as Coord2D
			spriteid as integer
			things[this].vars[V_CROSSHAIR_SID] = CreateSprite(IMG_CROSSHAIR)	
			spriteid = things[this].vars[V_CROSSHAIR_SID	]
			SetSpriteSize(spriteid, 32, 32)
			GetHudPos(tgame, GetSpriteWidth(spriteid), GetSpriteHeight(spriteid), POS_CENTER, pos)	
			SetSpritePosition(spriteid, pos.x,pos.y)
			SetSpriteVisible(things[this].vars[V_CROSSHAIR_SID], 0)
			things[this].vars[V_CROSSHAIR_HIDDEN] = 1
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			if things[this].vars[V_CROSSHAIR_HIDDEN] = 1 and things[T_WEAP].used = YES
				SetSpriteVisible(things[this].vars[V_CROSSHAIR_SID], 1)
				things[this].vars[V_CROSSHAIR_HIDDEN] = 0
			endif
		endcase
		
		case STATE_HIDE
			SetSpriteVisible(things[this].vars[V_CROSSHAIR_SID], 0)
			things[this].vars[V_CROSSHAIR_HIDDEN] = 1
			things[this].state = STATE_MAIN
		endcase
	endselect
endfunction

function ProgSmoke(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			rand as integer
			initx as float
			inity as float
			initz as float
			sizenow as float
			initx = things[this].vars[V_SMOKE_INITX]
			inity = things[this].vars[V_SMOKE_INITY]
			initz = things[this].vars[V_SMOKE_INITZ]
			if things[this].vars[V_SMOKE_SIZENOW] = 0 : things[this].vars[V_SMOKE_SIZENOW] = 0.4 : endif
			sizenow = things[this].vars[V_SMOKE_SIZENOW]
			things[this].vars[V_SMOKE_ALPHANOW] = 255
			SetObjectScale(things[this].id, sizenow,sizenow,sizenow)
			SetObjectImage(things[this].id, IMG_SMOKE, 0)
			SetObjectVisible(things[this].id, 1)
			SetObjectTransparency(things[this].id, 1)
			SetObjectCollisionMode(things[this].id, 0)
			SetObjectLightMode( things[this].id, 0 )
			SetObjectPosition(things[this].id, initx,inity,initz)
			SetObjectLookAt(things[this].id, GetCameraX(CAM_MAIN),GetCameraY(CAM_MAIN),GetCameraZ(CAM_MAIN),0)
			MoveObjectLocalZ(things[this].id, 1)
			
			things[this].vars[V_SMOKE_NEXTTIME] = tgame.ms + 2000
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			color as integer
			SetObjectLookAt(things[this].id, GetCameraX(CAM_MAIN),GetCameraY(CAM_MAIN),GetCameraZ(CAM_MAIN),0)
			MoveObjectLocalY(things[this].id, 0.02)
			inc things[this].vars[V_SMOKE_SIZENOW], 0.005
			dec things[this].vars[V_SMOKE_ALPHANOW], 2 
			if things[this].vars[V_SMOKE_ALPHANOW] < 0
				things[this].vars[V_SMOKE_ALPHANOW] = 0
				things[this].state = STATE_DEAD
			endif
			if things[this].vars[V_SMOKE_ALPHANOW] <> 0
				if things[this].vars[V_SMOKE_DARKER] = 1
					color = 0
				else
					color = 255
				endif
				SetObjectColor(things[this].id, color,color,color,things[this].vars[V_SMOKE_ALPHANOW])
			endif
			SetObjectScale(things[this].id,things[this].vars[V_SMOKE_SIZENOW],things[this].vars[V_SMOKE_SIZENOW],things[this].vars[V_SMOKE_SIZENOW])
			
			if tgame.ms > things[this].vars[V_SMOKE_NEXTTIME]
				things[this].state = STATE_DEAD
			endif	
		endcase
		
		case STATE_DEAD
			ClearThing(things,this)
		endcase
	endselect
endfunction

function ProgItem(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			uselight as integer
			initx as integer
			initz as integer
			initx = things[this].vars[V_ITEM_INITX]
			initz = things[this].vars[V_ITEM_INITZ]
			
			If things[this].vars[V_ITEM_TYPE] = ITEM_YELKEY
				SetObjectImage(things[this].id, IMG_GCOLORYELLOW, 0)
			elseif things[this].vars[V_ITEM_TYPE] = ITEM_REDKEY
				SetObjectImage(things[this].id, IMG_GCOLORRED, 0)
			elseif things[this].vars[V_ITEM_TYPE] = ITEM_BLUKEY
				SetObjectImage(things[this].id, IMG_GCOLORBLUE, 0)
			elseif things[this].vars[V_ITEM_TYPE] = ITEM_COIN
				SetObjectLightMode(things[this].id, 0)
			elseif things[this].vars[V_ITEM_TYPE] = ITEM_GEM
				SetObjectLightMode(things[this].id, 0)
				SetObjectColorEmissive(things[this].id, 255,40,40)
			endif
			
			if things[this].vars[V_ITEM_TYPE] = ITEM_GEM
				uselight = GetEmptyLight(LIGHTSTART,LIGHTEND)
				if uselight <> -1
					things[this].vars[V_ITEM_LIGHT] = uselight
					CreatePointLight(uselight, initx, 2, initz, 5, 255,40,40)
					SetPointLightMode(uselight, 1)
				endif
			endif
			
			SetObjectPosition(things[this].id, initx, 0,initz)
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			if things[this].vars[V_ITEM_TYPE] = ITEM_PISTOL or things[this].vars[V_ITEM_TYPE] = ITEM_RIFLE or things[this].vars[V_ITEM_TYPE] = ITEM_LAUNCHER or things[this].vars[V_ITEM_TYPE] = ITEM_COIN or things[this].vars[V_ITEM_TYPE] = ITEM_GEM or things[this].vars[V_ITEM_TYPE] = ITEM_YELKEY or things[this].vars[V_ITEM_TYPE] = ITEM_BLUKEY or things[this].vars[V_ITEM_TYPE] = ITEM_REDKEY
				RotateObjectLocalY(things[this].id, 1.4)
			endif
			exitfunction
		endcase
		
		case STATE_DEAD
			itemtype as integer
			updatenum as integer
			msgslot as integer
			nopickup as integer
			msgtextsize as integer
			msgtextsize = 28
			nopickup = 0
			
			if things[T_PLAYER].used = YES and things[T_HUDHEALTH].used = YES and things[T_HUDCLIPCOUNTER].used = YES
				itemtype = things[this].vars[V_ITEM_TYPE]
				if itemtype = ITEM_PISTOL and things[T_INVENTORY].used = YES
					if things[T_INVENTORY].vars[V_INVENTORY_HASGUN] = 1
						itemtype = ITEM_AMMO
					else	
						msgslot = 10
					endif
					things[T_INVENTORY].vars[V_INVENTORY_HASGUN] = 1
				elseIf itemtype = ITEM_RIFLE and things[T_INVENTORY].used = YES
					if things[T_INVENTORY].vars[V_INVENTORY_HASRIFLE] = 1
						itemtype = ITEM_AMMO
					else
						msgslot = 9
					endif
					things[T_INVENTORY].vars[V_INVENTORY_HASRIFLE] = 1
				elseIf itemtype = ITEM_LAUNCHER and things[T_INVENTORY].used = YES
					if things[T_INVENTORY].vars[V_INVENTORY_HASRLAUNCHER] = 1
						itemtype = ITEM_AMMO
					else
						msgslot = 11
					endif
					things[T_INVENTORY].vars[V_INVENTORY_HASRLAUNCHER] = 1
				elseIf itemtype = ITEM_YELKEY and things[T_INVENTORY].used = YES
					things[T_INVENTORY].vars[V_INVENTORY_HASYELKEY] = 1
					msgslot = 4
				elseIf itemtype = ITEM_REDKEY and things[T_INVENTORY].used = YES
					things[T_INVENTORY].vars[V_INVENTORY_HASREDKEY] = 1
					msgslot = 3
				elseIf itemtype = ITEM_BLUKEY and things[T_INVENTORY].used = YES
					things[T_INVENTORY].vars[V_INVENTORY_HASBLUKEY] = 1
					msgslot = 5
				elseIf itemtype = ITEM_HEALTH
					if things[T_PLAYER].vars[V_PLAYER_HP] >= 99
						if things[T_HUDMSG].used = NO
								ShowMessage(things, 8, POS_TOPCENTER, 1500, msgtextsize) //show you don't need this message
						endif
						nopickup = 1
					else
						things[T_PLAYER].vars[V_PLAYER_HP] = things[T_PLAYER].vars[V_PLAYER_HP] + 50
						if things[T_PLAYER].vars[V_PLAYER_HP] > 99
							things[T_PLAYER].vars[V_PLAYER_HP] = 99
						endif
						things[T_HUDHEALTH].vars[V_COUNTER_NUMREC] = things[T_PLAYER].vars[V_PLAYER_HP]
						things[T_HUDHEALTH].state = STATE_UPDATE2
						msgslot = 2
					endif
				endif
				
				if itemtype = ITEM_AMMO
					if things[T_WEAP].used = YES
						if things[T_WEAP].vars[V_WEAP_SPAREAMMO] = things[T_WEAP].vars[V_WEAP_SPAREAMMOMAX] or things[T_WEAP].state = STATE_RELOAD //DO NOT PICKUP WHEN FULL MELEE
							nopickup = 1 //set to 1 keep this item alive
							if things[T_HUDMSG].used = NO
								ShowMessage(things, 8, POS_TOPCENTER, 1500, msgtextsize) //show you don't need this message
							endif
						else
							if things[T_WEAP].vars[V_WEAP_ISROCKETLAUNCHER] = 1
									inc things[T_WEAP].vars[V_WEAP_SPAREAMMO], 5
							else
								inc things[T_WEAP].vars[V_WEAP_SPAREAMMO], 50
							endif
							things[T_WEAP].state = STATE_RELOAD //force reload
						endif
					else
						nopickup = 1
					endif
					msgslot = 1
				endif
				
				if itemtype = ITEM_COIN
					if things[T_HUDCOINS].used = YES and things[T_HUDLIVES].used = YES and things[T_INVENTORY].used = YES
						inc things[T_INVENTORY].vars[V_INVENTORY_COINS], 10
						if things[T_INVENTORY].vars[V_INVENTORY_COINS] > 99
							things[T_INVENTORY].vars[V_INVENTORY_COINS] = 0
							inc tgame.lives
							things[T_HUDLIVES].vars[V_COUNTER_NUMREC] = tgame.lives
							things[T_HUDLIVES].state = STATE_UPDATE2
							PlaySound(SND_1UP)
							msgslot = 20
						else
							msgslot = 15
						endif
						things[T_HUDCOINS].vars[V_COUNTER_NUMREC] = things[T_INVENTORY].vars[V_INVENTORY_COINS]
						things[T_HUDCOINS].state = STATE_UPDATE2
					endif
				endif
				
				if itemtype = ITEM_GEM
					if things[T_HUDGEMS].used = YES and things[T_INVENTORY].used = YES
						inc things[T_INVENTORY].vars[V_INVENTORY_GEMS], 1
						things[T_HUDGEMS].vars[V_COUNTER_NUMREC] = things[T_INVENTORY].vars[V_INVENTORY_GEMS]
						things[T_HUDGEMS].state = STATE_UPDATE2
						msgslot = 17
					endif					
				endif
			endif
			
			//show msg on pickup
			if nopickup = 0
				ShowMessage(things, msgslot, POS_TOPCENTER, 1500, msgtextsize)
				//do screen flash effect
				If things[T_HUDDMG].used = YES
					if itemtype = ITEM_HEALTH
						things[T_HUDDMG].state = STATE_EFFECTGREEN
					else
						things[T_HUDDMG].state = STATE_EFFECTYELLOW
					endif
				endif
				//delete this thing
				if things[this].vars[V_ITEM_LIGHT] <> 0
					DeletePointLight(things[this].vars[V_ITEM_LIGHT])
				endif
				
				//play sound
				
				if itemtype = ITEM_GEM
					PlaySound(SND_PICKUP2)
				elseif itemtype = ITEM_HEALTH
					PlaySound(SND_PICKUP1)
				elseif  itemtype = ITEM_COIN
					PlaySound(SND_COIN) 
				elseif itemtype = ITEM_BLUKEY or itemtype = ITEM_YELKEY or itemtype = ITEM_REDKEY
					PlaySound(SND_PICKUP1)
				elseif itemtype = ITEM_PISTOL or itemtype = ITEM_RIFLE or itemtype = ITEM_LAUNCHER or itemtype = ITEM_AMMO
					PlaySound(SND_AMMO)
				endif
				
				ClearThing(things, this)
			else
				//keep alive if it wasn't picked up
				things[this].state = STATE_MAIN
			endif
		endcase
	endselect
endfunction

function ProgDmgEffect(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			//create sprites
			things[this].vars[V_HUDDMG_GREENID] = CreateSprite(IMG_GREEN)
			things[this].vars[V_HUDDMG_REDID] = CreateSprite(IMG_RED)
			things[this].vars[V_HUDDMG_YELID] = CreateSprite(IMG_YELLOW)
			
			SetSpriteSize(things[this].vars[V_HUDDMG_REDID], tgame.window_width, tgame.window_height)
			SetSpriteSize(things[this].vars[V_HUDDMG_GREENID], tgame.window_width, tgame.window_height)
			SetSpriteSize(things[this].vars[V_HUDDMG_YELID], tgame.window_width, tgame.window_height)
			things[this].vars[V_HUDDMG_ALPHANOW] = 0
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_REDID], things[this].vars[V_HUDDMG_ALPHANOW])
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_GREENID], things[this].vars[V_HUDDMG_ALPHANOW])
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_YELID], things[this].vars[V_HUDDMG_ALPHANOW])
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_IDLE
			exitfunction
		endcase
		
		case STATE_EFFECTDOWN
			if things[this].vars[V_HUDDMG_ALPHANOW] <> 0
				dec things[this].vars[V_HUDDMG_ALPHANOW],5
				if things[this].vars[V_HUDDMG_ALPHANOW] < 0 : things[this].vars[V_HUDDMG_ALPHANOW] = 0 : endif
				
				if things[this].vars[V_HUDDMG_COLORACTIVE] = 0
					SetSpriteColorAlpha(things[this].vars[V_HUDDMG_REDID], things[this].vars[V_HUDDMG_ALPHANOW])
				elseif things[this].vars[V_HUDDMG_COLORACTIVE] = 1
					SetSpriteColorAlpha(things[this].vars[V_HUDDMG_GREENID], things[this].vars[V_HUDDMG_ALPHANOW])
				elseif things[this].vars[V_HUDDMG_COLORACTIVE] = 2
					SetSpriteColorAlpha(things[this].vars[V_HUDDMG_YELID], things[this].vars[V_HUDDMG_ALPHANOW])
				endif
			endif
		endcase
		
		case STATE_EFFECTRED
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_REDID], 0)
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_GREENID], 0)
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_YELID], 0)
			things[this].vars[V_HUDDMG_ALPHANOW] = 200
			things[this].vars[V_HUDDMG_COLORACTIVE] = 0
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_REDID], things[this].vars[V_HUDDMG_ALPHANOW])
			things[this].state = STATE_EFFECTDOWN
		endcase
		
		case STATE_EFFECTGREEN
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_REDID], 0)
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_GREENID], 0)
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_YELID], 0)
			things[this].vars[V_HUDDMG_ALPHANOW] = 200
			things[this].vars[V_HUDDMG_COLORACTIVE] = 1
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_GREENID], things[this].vars[V_HUDDMG_ALPHANOW])
			things[this].state = STATE_EFFECTDOWN
		endcase
		
		case STATE_EFFECTYELLOW
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_REDID], 0)
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_GREENID], 0)
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_YELID], 0)
			things[this].vars[V_HUDDMG_ALPHANOW] = 200
			things[this].vars[V_HUDDMG_COLORACTIVE] = 2
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_YELID], things[this].vars[V_HUDDMG_ALPHANOW])
			things[this].state = STATE_EFFECTDOWN
		endcase
		
		case STATE_EFFECTREDSTAY
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_REDID], 0)
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_GREENID], 0)
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_YELID], 0)
			things[this].vars[V_HUDDMG_ALPHANOW] = 150
			SetSpriteColorAlpha(things[this].vars[V_HUDDMG_REDID], things[this].vars[V_HUDDMG_ALPHANOW])
			things[this].state = STATE_IDLE
		endcase
		
	endselect
endfunction

function ProgMsg(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			initpos as Coord2D
			slot as integer
			msg as string
			textid as integer
			
			slot = things[this].vars[V_MSG_SLOT]
			if things[this].vars[V_MSG_TEXTSIZE] = 0 : things[this].vars[V_MSG_TEXTSIZE] = 32 : endif
			if things[this].vars[V_MSG_SHOWTIME] = 0 : things[this].vars[V_MSG_SHOWTIME] = 1500 : endif
			
			if slot = 0
				msg = "YOU DIED"
			elseif slot = 1
				msg = "RECEIVED AMMO"
			elseif slot = 2
				msg = "GOT A MEDKIT"
			elseif slot = 3
				msg = "ACQUIRED RED KEY"
			elseif slot = 4
				msg = "ACQUIRED Y. KEY"
			elseif slot = 5
				msg = "ACQUIRED BLUE KEY"
			elseif slot = 6
				msg = "THIS DOOR IS LOCKED"
			elseif slot = 7
				msg = "YOU USED THE KEY"
			elseif slot = 8
				msg = "YOU DON'T NEED THIS YET"
			elseif slot = 9
				msg = "ACQUIRED THE ASSAULT RIFLE"
			elseif slot = 10
				msg = "ACQUIRED THE HANDGUN"
			elseif slot = 11
				msg = "ACQUIRED THE RPG"
			elseif slot = 12
				msg = "MAP WAS SAVED SUCCESSFULLY"
			elseif slot = 13
				msg = "MAP COULD NOT BE SAVED"
			elseif slot = 14
				msg = "LEVEL " + Str(tgame.currentslot)
			elseif slot = 15
				msg = "GOT A COIN"
			elseif slot = 16
				msg = "LEVEL COMPLETE!"
			elseif slot = 17
				msg = "FOUND A GEM"
			elseif slot = 18
				gemcount as integer
				if things[T_EXIT].used = YES
					gemcount = things[T_EXIT].vars[V_EXIT_GEMREQ]
				endif
				msg = "YOU NEED " + Str(gemcount) + " GEMS" +CHR(13)+CHR(10)+ "TO USE THIS GATE"
			elseif slot = 19
				msg = "THE GATE HAS BEEN ACTIVATED"
			elseif slot = 20
				msg = "GAINED AN EXTRA LIFE"
			endif
			
			things[this].vars[V_MSG_TEXTID] = CreateText(msg)
			textid = things[this].vars[V_MSG_TEXTID]
			SetTextFontImage(textid, IMG_MAINFONT)
			SetTextSize(textid, things[this].vars[V_MSG_TEXTSIZE])		
			GetHudPos(tgame, GetTextTotalWidth(textid), GetTextTotalHeight(textid), things[this].vars[V_MSG_INITPOS], initpos)
			
			SetTextPosition(textid, initpos.x, initpos.y)
			
			things[this].vars[V_MSG_NEXTTIME] = tgame.ms + things[this].vars[V_MSG_SHOWTIME]
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			if tgame.ms > things[this].vars[V_MSG_NEXTTIME]
				things[this].state = STATE_DEAD
			endif
		endcase
		
		case STATE_DEAD
			DeleteText(things[this].vars[V_MSG_TEXTID])
			ClearThing(things, this)
		endcase
	endselect
endfunction


function ProgCounter(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			initpos as Coord2D
			numnowinit as integer
			textid as integer
			sprite as integer
			useimg as integer
			spritesize as integer
			if things[this].vars[V_COUNTER_INITTEXTSIZE] = 0 : things[this].vars[V_COUNTER_INITTEXTSIZE] = 32 : endif
			
			//setupsprite
			useimg = things[this].vars[V_COUNTER_USEIMG]
			if useimg = 0 then useimg = IMG_BRICK
			things[this].vars[V_COUNTER_SPR] = CreateSprite(useimg)
			sprite = things[this].vars[V_COUNTER_SPR]
			
			things[this].vars[V_COUNTER_COUNTTEXTID] = CreateText(AddZeros(2,STR(numnowinit)))
			textid = things[this].vars[V_COUNTER_COUNTTEXTID]
			SetTextFontImage(textid, IMG_MAINFONT)
			numnowinit = things[this].vars[V_COUNTER_NUMNOW]
			SetTextSize(things[this].vars[V_COUNTER_COUNTTEXTID], things[this].vars[V_COUNTER_INITTEXTSIZE])	
			
			//resizesprite based on text
			spritesize = GetTextTotalHeight(textid)
			SetSpriteSize(sprite, spritesize, spritesize)
			
		
			GetHudPos(tgame, GetTextTotalWidth(textid) + spritesize, GetTextTotalHeight(textid), things[this].vars[V_COUNTER_INITPOS], initpos)
			SetTextPosition(things[this].vars[V_COUNTER_COUNTTEXTID], initpos.x + spritesize, initpos.y)
			
			SetTextString(things[this].vars[V_COUNTER_COUNTTEXTID], AddZeros(2,STR(numnowinit)))
			SetTextVisible(things[this].vars[V_COUNTER_COUNTTEXTID], 1)
			
			SetSpritePosition(sprite, initpos.x, initpos.y)
			
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_IDLE
		endcase
		
		case STATE_UPDATE
			numnow as integer
			numrec as integer
			numnow = things[this].vars[V_COUNTER_NUMNOW]
			numrec = things[this].vars[V_COUNTER_NUMREC]
			
			numnow = numnow + numrec
			
			things[this].vars[V_COUNTER_NUMNOW] = numnow
			things[this].vars[V_COUNTER_NUMREC] = 0
			
			SetTextString(things[this].vars[V_COUNTER_COUNTTEXTID],AddZeros(2,STR(numnow)))
			SetTextVisible(things[this].vars[V_COUNTER_COUNTTEXTID], 1)
			
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_UPDATE2
			tmpnum as integer
			things[this].vars[V_COUNTER_NUMNOW] = things[this].vars[V_COUNTER_NUMREC]
			things[this].vars[V_COUNTER_NUMREC] = 0
			tmpnum = things[this].vars[V_COUNTER_NUMNOW]
			SetTextString(things[this].vars[V_COUNTER_COUNTTEXTID], AddZeros(2,STR(tmpnum)))
			SetTextVisible(things[this].vars[V_COUNTER_COUNTTEXTID], 1)
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_HIDE
			SetTextVisible(things[this].vars[V_COUNTER_COUNTTEXTID], 0)
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_SHOW
			SetTextVisible(things[this].vars[V_COUNTER_COUNTTEXTID], 0)
			things[this].state = STATE_IDLE
		endcase
		
	endselect
endfunction

function ProgBurst(tgame ref as Game, things ref as Thing[], this as integer)
	x as float : y as float : z as float
	xrot as float : yrot as float : zrot as float
	select things[this].state
		case STATE_INIT
			//setup
			SetObjectCollisionMode(things[this].id, 0)
			SetObjectColorEmissive(things[this].id, 50,50,50)
			SetObjectLightMode(things[this].id, 0)
			SetObjectTransparency(things[this].id, 1)
			SetObjectDepthRange( things[this].id, 0.06, 0.1)
			SetObjectVisible(things[this].id, 0)
			//things[this].vars[V_BURST_OFFSETX] = 0.1
			//things[this].vars[V_BURST_OFFSETY] = -0.1
			//things[this].vars[V_BURST_OFFSETZ] = 1
			
			//follow camera
			x = GetCameraX(CAM_MAIN)
			y = GetcameraY(CAM_MAIN)
			z = GetCameraZ(CAM_MAIN)
			xrot = GetCameraAngleX(CAM_MAIN)
			yrot = GetCameraAngleY(CAM_MAIN)
			zrot = GetCameraAngleZ(CAM_MAIN)
			SetObjectPosition(things[this].id, x, y, z)
			SetObjectRotation(things[this].id, xrot, yrot, zrot)
			MoveObjectLocalX(things[this].id, things[this].vars[V_BURST_OFFSETX])
			MoveObjectLocalY(things[this].id, things[this].vars[V_BURST_OFFSETY])
			MoveObjectLocalZ(things[this].id, things[this].vars[V_BURST_OFFSETZ])
			things[this].state = STATE_NOBURST
		endcase
		
		case STATE_BURSTSTART
			things[this].vars[V_BURST_NEXTTIME] = tgame.ms + 50
			things[this].state = STATE_BURST
			
		endcase
		
		case STATE_BURST
			if GetObjectVisible(things[this].id) = 0 : SetObjectVisible(things[this].id, 1) : endif
			x = GetCameraX(CAM_MAIN)
			y = GetcameraY(CAM_MAIN)
			z = GetCameraZ(CAM_MAIN)
			xrot = GetCameraAngleX(CAM_MAIN)
			yrot = GetCameraAngleY(CAM_MAIN)
			zrot = GetCameraAngleZ(CAM_MAIN)
			SetObjectPosition(things[this].id, x, y, z)
			SetObjectRotation(things[this].id, xrot, yrot, zrot)
			MoveObjectLocalX(things[this].id, things[this].vars[V_BURST_OFFSETX])
			MoveObjectLocalY(things[this].id, things[this].vars[V_BURST_OFFSETY])
			MoveObjectLocalZ(things[this].id, things[this].vars[V_BURST_OFFSETZ])
			RotateObjectLocalZ(things[this].id, random(0,360))
			If GetPointLightExists(LIGHT_BURST) = 0
				CreatePointLight(LIGHT_BURST, GetObjectX(things[this].id),GetObjectY(things[this].id),GetObjectZ(things[this].id), 15, 255,255,128)
				SetPointLightMode(LIGHT_BURST, 1)
			endif
			
			
			if tgame.ms > things[this].vars[V_BURST_NEXTTIME] 
				things[this].state = STATE_NOBURST
			endif
		endcase
		
		case STATE_NOBURST
			If GetPointLightExists(LIGHT_BURST) = 1
				DeletePointLight(LIGHT_BURST)
			endif
			if GetObjectVisible(things[this].id) = 1 : SetObjectVisible(things[this].id, 0) : endif
		endcase
	endselect
endfunction

function PlaceObject(tgame ref as Game, tmpnum as integer, x as float, z as float)
	objid as integer
	useslot as integer
	rotate as integer
	colorlight as integer
	
	if tmpnum > TMPL_LAST
		rotate = 1
		tmpnum = tmpnum - TMPL_LAST
	endif
	
	select tmpnum
		case TMPL_LAST
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
		endcase
		
		case TMPL_WCSTARTNORTH
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
			if rotate = 1 then RotateObjectLocalY(objid, 90)			
		endcase
		
		case TMPL_WCSTARTSOUTH
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
			if rotate = 1 then RotateObjectLocalY(objid, 90)			
		endcase
		
		case TMPL_WALL
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
			if rotate = 1 then RotateObjectLocalY(objid, 90)
		endcase
		
		case TMPL_TWALLNORTH
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
			if rotate = 1 then RotateObjectLocalY(objid, 90)
		endcase
		
		case TMPL_TWALLSOUTH
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
			if rotate = 1 then RotateObjectLocalY(objid, 90)
		endcase
		
		case TMPL_FBARREL3
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
			if rotate = 1 then RotateObjectLocalY(objid, 90)
		endcase
		
		
		case TMPL_WALLCORNER
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
		endcase
		
		case TMPL_WALLDOORFRAME
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
			if rotate = 1 then RotateObjectLocalY(objid, 90)
		endcase
		
		case TMPL_GRASS
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
		endcase
		
		case TMPL_MEPLAYER
			SetObjectPosition(things[T_PLAYER].id, x, 2, z)
		endcase
		
		case TMPL_ITEMPISTOL
			useslot = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
			if useslot <> -1
				SpawnThing(things, useslot, CloneTObject(tgame,TMPL_ITEMPISTOL), PROG_ITEM, THING_TYPE_OBJ)
				SETV(things, useslot, V_ITEM_INITX, x)
				SETV(things, useslot, V_ITEM_INITZ, z)
				SETV(things, useslot, V_ITEM_TYPE, ITEM_PISTOL)
			endif
		endcase
		
		case TMPL_ITEMRIFLE
			useslot = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
			if useslot <> -1
				SpawnThing(things, useslot, CloneTObject(tgame,TMPL_ITEMRIFLE), PROG_ITEM, THING_TYPE_OBJ)
				SETV(things, useslot, V_ITEM_INITX, x)
				SETV(things, useslot, V_ITEM_INITZ, z)
				SETV(things, useslot, V_ITEM_TYPE, ITEM_RIFLE)
			endif		
		endcase
		
		case TMPL_ITEMLAUNCHER
			useslot = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
			if useslot <> -1
				SpawnThing(things, useslot, CloneTObject(tgame,TMPL_ITEMLAUNCHER), PROG_ITEM, THING_TYPE_OBJ)
				SETV(things, useslot, V_ITEM_INITX, x)
				SETV(things, useslot, V_ITEM_INITZ, z)
				SETV(things, useslot, V_ITEM_TYPE, ITEM_LAUNCHER)
			endif
		endcase
		
		case TMPL_GOLEM
			useslot = GetEmptySlot(things, T_ENEMYSTART, T_ENEMYEND)
			if useslot <> -1
				SpawnThing(things, useslot, CreateObjectBox(5,4,3), PROG_ENEMY, THING_TYPE_OBJ)
				SETV(things, useslot, V_ENEMY_INITX, x)
				SETV(things, useslot, V_ENEMY_INITZ, z)
				SETV(things, useslot, V_ENEMY_USETEMPLATE, TMPL_GOLEM)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_B, ANIM_GOLEMIDLE_B)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_E, ANIM_GOLEMIDLE_E)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_T, ANIM_GOLEMIDLE_T)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_B, ANIM_GOLEMDIE_B)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_E, ANIM_GOLEMDIE_E)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_T, ANIM_GOLEMDIE_T)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_B, ANIM_GOLEMWALK_B)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_E, ANIM_GOLEMWALK_E)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_T, ANIM_GOLEMWALK_T)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_B, ANIM_GOLEMATTACK_B)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_E, ANIM_GOLEMATTACK_E)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_T, ANIM_GOLEMATTACK_T)
				SETV(things, useslot, V_ENEMY_PROJECTILEDIST, 300)
				SETV(things, useslot, V_ENEMY_RANGE, 100)
				SETV(things, useslot, V_ENEMY_ATTACKRANGE, 80)
				SETV(things, useslot, V_ENEMY_SPEED, 0.05)
				SETV(things, useslot, V_ENEMY_ATTACKWAIT, 1000)
				SETV(things, useslot, V_ENEMY_TMPLFORBULLET, TMPL_BOULDER)
				SETV(things, useslot, V_ENEMY_USEROCKET, 1)
				SETV(things, useslot, V_ENEMY_HP, 300)
				SETV(things, useslot, V_ENEMY_HITBOXFLOAT, 7)
				SETV(things, useslot, V_ENEMY_PROJECTILESPREAD, 0)
				SETV(things, useslot, V_ENEMY_PROJECTILESCASTSIZE, 2)
				SETV(things, useslot, V_ENEMY_PROJECTILEUP, 3)
			endif
		endcase
		
		case TMPL_SKELETON
			useslot = GetEmptySlot(things, T_ENEMYSTART, T_ENEMYEND)
			if useslot <> -1
				SpawnThing(things, useslot, CreateObjectBox(0.5,2,1), PROG_ENEMY, THING_TYPE_OBJ)
				SETV(things, useslot, V_ENEMY_INITX, x)
				SETV(things, useslot, V_ENEMY_INITZ, z)
				SETV(things, useslot, V_ENEMY_USETEMPLATE, TMPL_SKELETON)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_B, ANIM_SKELIDLE_B)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_E, ANIM_SKELIDLE_E)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_T, ANIM_SKELIDLE_T)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_B, ANIM_SKELDIE_B)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_E, ANIM_SKELDIE_E)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_T, ANIM_SKELDIE_T)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_B, ANIM_SKELWALK_B)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_E, ANIM_SKELWALK_E)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_T, ANIM_SKELWALK_T)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_B, ANIM_SKELATTACK_B)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_E, ANIM_SKELATTACK_E)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_T, ANIM_SKELATTACK_T)
				SETV(things, useslot, V_ENEMY_PROJECTILEDIST, 10)
				SETV(things, useslot, V_ENEMY_RANGE, 100)
				SETV(things, useslot, V_ENEMY_ATTACKRANGE, 7)
				SETV(things, useslot, V_ENEMY_SPEED, 0.3)
				SETV(things, useslot, V_ENEMY_ATTACKWAIT, 1000)
				SETV(things, useslot, V_ENEMY_HITBOXFLOAT, 2.5)
				SETV(things, useslot, V_ENEMY_PROJECTILEUP, 1)
				SETV(things, useslot, V_ENEMY_FORWARDTIME, 400)
				SETV(things, useslot, V_ENEMY_SNDALERT, SND_SCREECH1)
				SETV(things, useslot, V_ENEMY_SNDATTACK, SND_SWING2)
				SETV(things, useslot, V_ENEMY_SNDDIE, SND_FALL2)
				SETV(things, useslot, V_ENEMY_SNDFORWARD, SND_SCREECH2)
			endif			
		endcase
		
		case TMPL_SKELSOLDIER
			useslot = GetEmptySlot(things, T_ENEMYSTART, T_ENEMYEND)
			if useslot <> -1
				SpawnThing(things, useslot, CreateObjectBox(1,2,1), PROG_ENEMY, THING_TYPE_OBJ)
				SETV(things, useslot, V_ENEMY_INITX, x)
				SETV(things, useslot, V_ENEMY_INITZ, z)
				SETV(things, useslot, V_ENEMY_USETEMPLATE, TMPL_SKELSOLDIER)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_B, ANIM_SKELIDLE_B)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_E, ANIM_SKELIDLE_E)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_T, ANIM_SKELIDLE_T)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_B, ANIM_SKELDIE_B)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_E, ANIM_SKELDIE_E)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_T, ANIM_SKELDIE_T)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_B, ANIM_SKELWALK_B)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_E, ANIM_SKELWALK_E)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_T, ANIM_SKELWALK_T)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_B, ANIM_SKELATTACK_B)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_E, ANIM_SKELATTACK_E -0.2)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_T, ANIM_SKELATTACK_T )
				SETV(things, useslot, V_ENEMY_PROJECTILEDIST, 300)
				SETV(things, useslot, V_ENEMY_RANGE, 100)
				SETV(things, useslot, V_ENEMY_ATTACKRANGE, 50)
				SETV(things, useslot, V_ENEMY_SPEED, 0.2)
				SETV(things, useslot, V_ENEMY_ATTACKWAIT, 300)
				SETV(things, useslot, V_ENEMY_HITBOXFLOAT, 2.5)
				SETV(things, useslot, V_ENEMY_PROJECTILEUP, 0.5)
				SETV(things, useslot, V_ENEMY_FORWARDTIME, 500)
				SETV(things, useslot, V_ENEMY_LFLASHONATTACK, 1)
				SETV(things, useslot, V_ENEMY_SNDALERT, SND_SCREECH1)
				SETV(things, useslot, V_ENEMY_SNDATTACK, SND_SHOT)
				SETV(things, useslot, V_ENEMY_SNDDIE, SND_FALL2)
				SETV(things, useslot, V_ENEMY_SNDFORWARD, SND_SCREECH2)
			endif			
		endcase
		
		case TMPL_DEER
			useslot = GetEmptySlot(things, T_ENEMYSTART, T_ENEMYEND)
			if useslot <> -1
				SpawnThing(things, useslot, CreateObjectBox(1,2,2), PROG_ENEMY, THING_TYPE_OBJ)
				SETV(things, useslot, V_ENEMY_INITX, x)
				SETV(things, useslot, V_ENEMY_INITZ, z)
				SETV(things, useslot, V_ENEMY_USETEMPLATE, TMPL_DEER)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_B, ANIM_DEERIDLE_B)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_E, ANIM_DEERIDLE_E)
				SETV(things, useslot, V_ENEMY_ANIM_IDLE_T, ANIM_DEERIDLE_T)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_B, ANIM_DEERDIE_B)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_E, ANIM_DEERDIE_E)
				SETV(things, useslot, V_ENEMY_ANIM_DIE_T, ANIM_DEERDIE_T)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_B, ANIM_DEERWALK_B)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_E, ANIM_DEERWALK_E)
				SETV(things, useslot, V_ENEMY_ANIM_MOVE_T, ANIM_DEERWALK_T)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_B, ANIM_DEERATTACK_B)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_E, ANIM_DEERATTACK_E)
				SETV(things, useslot, V_ENEMY_ANIM_ATTACK_T, ANIM_DEERATTACK_T)
				SETV(things, useslot, V_ENEMY_RANGE, 80)
				SETV(things, useslot, V_ENEMY_HITBOXFLOAT, 2.6)
				SETV(things, useslot, V_ENEMY_PROJECTILEUP, 0.5)
			endif			
		endcase
		
		case TMPL_WALLDOOR
			useslot = GetEmptySlot(things, T_DOORSTART, T_DOOREND)
			if useslot <> -1
				objid = CloneTObject(tgame, TMPL_WALLDOOR)
				SpawnThing(things, useslot, objid, PROG_DOOR, THING_TYPE_OBJ)
				SETV(things, useslot, V_DOOR_MOVESPEED, 0.08)
				SETV(things, useslot, V_DOOR_MOVEMAX, 60)
				SETV(things, useslot, V_DOOR_WAIT, 2000)
				SetObjectPosition(objid, x, 0, z)
				if rotate = 1 then RotateObjectLocalY(objid, 90)
			endif
		endcase
		
		case TMPL_MEREDWALLDOOR
			useslot = GetEmptySlot(things, T_DOORSTART, T_DOOREND)
			if useslot <> -1
				objid = CloneTObject(tgame, TMPL_WALLDOOR)
				SpawnThing(things, useslot, objid, PROG_DOOR, THING_TYPE_OBJ)
				SETV(things, useslot, V_DOOR_MOVESPEED, 0.08)
				SETV(things, useslot, V_DOOR_MOVEMAX, 60)
				SETV(things, useslot, V_DOOR_WAIT, 2000)
				SETV(things, useslot, V_DOOR_REQREDKEY, 1)
				SetObjectPosition(objid, x, 0, z)
				if rotate = 1 then RotateObjectLocalY(objid, 90)
			endif
		endcase
		
		case TMPL_MEBLUWALLDOOR
			useslot = GetEmptySlot(things, T_DOORSTART, T_DOOREND)
			if useslot <> -1
				objid = CloneTObject(tgame, TMPL_WALLDOOR)
				SpawnThing(things, useslot, objid, PROG_DOOR, THING_TYPE_OBJ)
				SETV(things, useslot, V_DOOR_MOVESPEED, 0.08)
				SETV(things, useslot, V_DOOR_MOVEMAX, 60)
				SETV(things, useslot, V_DOOR_WAIT, 2000)
				SETV(things, useslot, V_DOOR_REQBLUKEY, 1)
				SetObjectPosition(objid, x, 0, z)
				if rotate = 1 then RotateObjectLocalY(objid, 90)
			endif
		endcase

		case TMPL_MEYELWALLDOOR
			useslot = GetEmptySlot(things, T_DOORSTART, T_DOOREND)
			if useslot <> -1
				objid = CloneTObject(tgame, TMPL_WALLDOOR)
				SpawnThing(things, useslot, objid, PROG_DOOR, THING_TYPE_OBJ)
				SETV(things, useslot, V_DOOR_MOVESPEED, 0.08)
				SETV(things, useslot, V_DOOR_MOVEMAX, 60)
				SETV(things, useslot, V_DOOR_WAIT, 2000)
				SETV(things, useslot, V_DOOR_REQYELKEY, 1)
				SetObjectPosition(objid, x, 0, z)
				if rotate = 1 then RotateObjectLocalY(objid, 90)
			endif
		endcase
		
		case TMPL_KEYR
			useslot = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
			if useslot <> -1
				SpawnThing(things, useslot, CloneTObject(tgame,TMPL_KEY), PROG_ITEM, THING_TYPE_OBJ)
				SETV(things, useslot, V_ITEM_INITX, x)
				SETV(things, useslot, V_ITEM_INITZ, z)
				SETV(things, useslot, V_ITEM_TYPE, ITEM_REDKEY)
			endif
		endcase
		
		case TMPL_KEYY
			useslot = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
			if useslot <> -1
				SpawnThing(things, useslot, CloneTObject(tgame,TMPL_KEY), PROG_ITEM, THING_TYPE_OBJ)
				SETV(things, useslot, V_ITEM_INITX, x)
				SETV(things, useslot, V_ITEM_INITZ, z)
				SETV(things, useslot, V_ITEM_TYPE, ITEM_YELKEY)
			endif
		endcase
		
		case TMPL_KEYB
			useslot = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
			if useslot <> -1
				SpawnThing(things, useslot, CloneTObject(tgame,TMPL_KEY), PROG_ITEM, THING_TYPE_OBJ)
				SETV(things, useslot, V_ITEM_INITX, x)
				SETV(things, useslot, V_ITEM_INITZ, z)
				SETV(things, useslot, V_ITEM_TYPE, ITEM_BLUKEY)
			endif
		endcase

		case TMPL_MEDPACK
			useslot = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
			if useslot <> -1
				SpawnThing(things, useslot, CloneTObject(tgame,TMPL_MEDPACK), PROG_ITEM, THING_TYPE_OBJ)
				SETV(things, useslot, V_ITEM_INITX, x)
				SETV(things, useslot, V_ITEM_INITZ, z)
				SETV(things, useslot, V_ITEM_TYPE, ITEM_HEALTH)
			endif
		endcase

		case TMPL_AMMO
			useslot = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
			if useslot <> -1
				SpawnThing(things, useslot, CloneTObject(tgame,TMPL_AMMO), PROG_ITEM, THING_TYPE_OBJ)
				SETV(things, useslot, V_ITEM_INITX, x)
				SETV(things, useslot, V_ITEM_INITZ, z)
				SETV(things, useslot, V_ITEM_TYPE, ITEM_AMMO)
			endif
		endcase

		case TMPL_CRATE
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
		endcase

		case TMPL_EXIT1
			SpawnThing(things, T_EXIT, CloneTObject(tgame, TMPL_EXIT1), PROG_EXIT, THING_TYPE_OBJ)
			SETV(things, T_EXIT, V_EXIT_INITX, x)
			SETV(things, T_EXIT, V_EXIT_INITZ, z)
		endcase
		
		case TMPL_COIN
			useslot = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
			if useslot <> -1
				SpawnThing(things, useslot, CloneTObject(tgame,TMPL_COIN), PROG_ITEM, THING_TYPE_OBJ)
				SETV(things, useslot, V_ITEM_INITX, x)
				SETV(things, useslot, V_ITEM_INITZ, z)
				SETV(things, useslot, V_ITEM_TYPE, ITEM_COIN)
			endif
		endcase
		
		case TMPL_TORCH
			uselight as integer
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)

		endcase
		
		case TMPL_BARREL
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
		endcase
		
		
		case TMPL_FBARREL
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
		endcase
		
		
		case TMPL_FLOORCEIL
			objid = CloneTObject(tgame, tmpnum)
			SetObjectPosition(objid, x, 0, z)
		endcase
		
		case TMPL_REDLIGHT
			colorlight = GetEmptyLight(LIGHTSTART,LIGHTEND)
			if colorlight <> -1
				CreatePointLight(colorlight, x, 5, z, 100, 255,0,0)
				SetPointLightMode(colorlight, 1)
			endif
		endcase
		
		case TMPL_GREENLIGHT
			colorlight = GetEmptyLight(LIGHTSTART,LIGHTEND)
			if colorlight <> -1
				CreatePointLight(colorlight, x, 5, z, 100, 0,255,0)
				SetPointLightMode(colorlight, 1)
			endif
		endcase 
		
		case TMPL_BLUELIGHT
			colorlight = GetEmptyLight(LIGHTSTART,LIGHTEND)
			if colorlight <> -1
				CreatePointLight(colorlight, x, 5, z, 100, 0,0,255)
				SetPointLightMode(colorlight, 1)
			endif			
		endcase
		
		case TMPL_WHITELIGHT
			colorlight = GetEmptyLight(LIGHTSTART,LIGHTEND)
			if colorlight <> -1
				CreatePointLight(colorlight, x, 5, z, 100, 255,255,255)
				SetPointLightMode(colorlight, 1)
			endif			
		endcase
	endselect
endfunction

function ProgLevelGen(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			fileid as integer
			slot as integer
			mapsize as integer
			mindex as integer
			layernow as integer
			filename as string
			nowx as float
			nowy as float
			count as integer
			mapL0 as integer[0] //layer0
			mapL1 as integer[0] //layer1
			mapL2 as integer[0] //layer2
			slot = things[this].vars[V_LEVELGEN_SLOT]
			filename = "slot" + STR(slot) + ".txt"
			
			If GetFileExists(filename) = 1
				fileid = OpenToRead(filename)
				mapsize = Val(ReadLine(fileid))
				mapL0.length = mapsize * mapsize
				mapL1.length = mapsize * mapsize
				mapL2.length = mapsize * mapsize
				
				ReadLine(fileid) //readnewlayer
				for mindex = 0 to mapL0.length - 1
					mapL0[mindex] = Val(ReadLine(fileid))
				next
				
				ReadLine(fileid) //readnewlayer
				for mindex = 0 to mapL1.length - 1
					mapL1[mindex] = Val(ReadLine(fileid))
				next
				
				ReadLine(fileid) //readnewlayer
				for mindex = 0 to mapL2.length - 1
					mapL2[mindex] = Val(ReadLine(fileid))
				next
				CloseFile(fileid)
			
				//-----------------------------------------
				
				//place objects on map
				mindex = 0
				layernow = 0
				nowx = 0
				nowy = 0
				count = 0
				do
					if layernow = 0
						PlaceObject(tgame, mapL0[mindex], nowx, nowy)
					elseif layernow = 1
						PlaceObject(tgame, mapL1[mindex], nowx, nowy)
					elseif layernow = 2
						PlaceObject(tgame, mapL2[mindex], nowx, nowy)
					endif

					inc count
					if count >= mapsize
						nowx = 0
						nowy = nowy + TILESIZE
						count = 0
					else
						nowx = nowx + TILESIZE
					endif
					
					inc mindex
					if layernow = 0
						if mindex >= mapL0.length
							layernow = 1
							nowx = 0
							nowy = 0
							count = 0
							mindex=0
						endif
					elseif layernow = 1
						if mindex >= mapL1.length
							layernow = 2
							nowx = 0
							nowy = 0
							count = 0
							mindex=0
						endif
					elseif layernow = 2
						if mindex >= mapL2.length then exit
					endif
				loop
			endif	
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
		endcase
	endselect
endfunction

function ProgShadow(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			if things[this].vars[V_SHADOW_FOLLOWTHING] = 0 : things[this].state = STATE_DEAD : exitfunction : endif
			SetObjectCollisionMode(things[this].id, 0)
			SetObjectImage(things[this].id, IMG_SHADOW, 0)
			SetObjectTransparency(things[this].id, 1)
			SetObjectColor(things[this].id, 0, 0, 0, 190)
			//SetObjectAlphaMask(things[this].id, 1)
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			followthingindex as integer
			followthingindex = things[this].vars[V_SHADOW_FOLLOWTHING]
			if things[followthingindex].used = YES
				followthing as ObjInfo
				GetObjectInfo(things[followthingindex].id, followthing)
				SetObjectPosition(things[this].id, followthing.x, followthing.y - things[followthingindex].vars[V_ENEMY_HITBOXFLOAT] + 0.04, followthing.z)
				SetObjectRotation(things[this].id, 90, followthing.yrot, 0)
			else
				things[this].state = STATE_DEAD
			endif
		endcase
		
		case STATE_DEAD
			ClearThing(things, this)
		endcase
	endselect
endfunction

function ProgExplode(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			useslot as integer
			rand as integer
			rand = Random(2, 3)
			SetObjectScale(things[this].id, rand, rand, rand)
			SetObjectPosition(things[this].id, things[this].vars[V_EXPLODE_INITX],things[this].vars[V_EXPLODE_INITY],things[this].vars[V_EXPLODE_INITZ])
			SetObjectLookAt(things[this].id, GetCameraX(CAM_MAIN), GetCameraY(CAM_MAIN), GetCameraZ(CAM_MAIN), 0)
			MoveObjectLocalZ(things[this].id, 1.5)
			SetObjectImage(things[this].id, IMG_EXPLODESTART + things[this].vars[V_EXPLODE_CURFRAME],0)
			SetObjectTransparency( things[this].id, 1 ) 
			SetObjectCollisionMode(things[this].id, 0)
			SetObjectLightMode( things[this].id, 0 )
			SetObjectVisible(things[this].id, 1)
			
			//spawn SMOKE
			useslot = GetEmptySlot(things, T_SMOKESTART, T_SMOKEEND)
			if useslot <> -1				
				SpawnThing(things, useslot, CloneTObject(tgame, TMPL_SPLASHPLANE), PROG_SMOKE, THING_TYPE_OBJ)
				SetObjectVisible(things[useslot].id,0) //make it invisible until its init is reached
				SETV(things, useslot, V_SMOKE_INITX, things[this].vars[V_EXPLODE_INITX])
				SETV(things, useslot, V_SMOKE_INITY, things[this].vars[V_EXPLODE_INITY])
				SETV(things, useslot, V_SMOKE_INITZ, things[this].vars[V_EXPLODE_INITZ])
				SETV(things, useslot, V_SMOKE_SIZENOW, 2)
				SETV(things, useslot, V_SMOKE_DARKER, 1)
			endif
			
			PlaySound(SND_EXPLODE)
			
			if things[this].vars[V_EXPLODE_ANIMSPEED] = 0 : things[this].vars[V_EXPLODE_ANIMSPEED] = 40 : endif
			things[this].vars[V_EXPLODE_NEXTTIME] = tgame.ms + things[this].vars[V_EXPLODE_ANIMSPEED]
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			if tgame.ms > things[this].vars[V_EXPLODE_NEXTTIME]
				curimage as integer
				inc things[this].vars[V_EXPLODE_CURFRAME] //increment the frame
				curimage = IMG_EXPLODESTART + things[this].vars[V_EXPLODE_CURFRAME]
				if  curimage > IMG_EXPLODEEND
					if things[this].vars[V_EXPLODE_LOOP] = 1
						things[this].vars[V_EXPLODE_CURFRAME] = 0	//loop
					else
						things[this].state = STATE_DEAD
					endif
				else
					SetObjectImage(things[this].id, curimage,0)
					things[this].vars[V_EXPLODE_NEXTTIME] = tgame.ms + things[this].vars[V_EXPLODE_ANIMSPEED]
				endif
			endif
			SetObjectLookAt(things[this].id, GetCameraX(CAM_MAIN),GetCameraY(CAM_MAIN),GetcameraZ(CAM_MAIN),0)
		endcase
	
		case STATE_DEAD
			ClearThing(things, this)
		endcase
	endselect
endfunction

function ProgSplash(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			SetObjectPosition(things[this].id, things[this].vars[V_SPLASH_INITX],things[this].vars[V_SPLASH_INITY],things[this].vars[V_SPLASH_INITZ])
			SetObjectLookAt(things[this].id, GetCameraX(CAM_MAIN), GetCameraY(CAM_MAIN), GetCameraZ(CAM_MAIN), 0)
			MoveObjectLocalZ(things[this].id, 1)
			SetObjectImage(things[this].id, IMG_SPLASHSTART + things[this].vars[V_SPLASH_CURFRAME],0)
			SetObjectCollisionMode(things[this].id, 0)
			SetObjectLightMode( things[this].id, 0 )
			SetObjectTransparency(things[this].id, 1)
			SetObjectColorEmissive(things[this].id, 90,90,90)
			SetObjectVisible(things[this].id, 1)
			
			if things[this].vars[V_SPLASH_ANIMSPEED] = 0 : things[this].vars[V_SPLASH_ANIMSPEED] = 30 : endif
			things[this].vars[V_SPLASH_NEXTTIME] = tgame.ms + things[this].vars[V_SPLASH_ANIMSPEED]
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			if tgame.ms > things[this].vars[V_SPLASH_NEXTTIME]
				curimage as integer
				inc things[this].vars[V_SPLASH_CURFRAME] //increment the frame
				curimage = IMG_SPLASHSTART + things[this].vars[V_SPLASH_CURFRAME]
				if  curimage > IMG_SPLASHEND
					if things[this].vars[V_SPLASH_LOOP] = 1
						things[this].vars[V_SPLASH_CURFRAME] = 0	//loop
					else
						things[this].state = STATE_DEAD
					endif
				else
					SetObjectImage(things[this].id, curimage,0)
					things[this].vars[V_SPLASH_NEXTTIME] = tgame.ms + things[this].vars[V_SPLASH_ANIMSPEED]
				endif
			endif
		endcase
	
		case STATE_DEAD
			ClearThing(things, this)
		endcase
	endselect
endfunction

function ProgBloodSplash(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			SetObjectPosition(things[this].id, things[this].vars[V_SPLASH_INITX],things[this].vars[V_SPLASH_INITY],things[this].vars[V_SPLASH_INITZ])
			SetObjectLookAt(things[this].id, GetCameraX(CAM_MAIN), GetCameraY(CAM_MAIN), GetCameraZ(CAM_MAIN), 0)
			MoveObjectLocalZ(things[this].id, 1)
			SetObjectImage(things[this].id, IMG_BLOODSTART + things[this].vars[V_SPLASH_CURFRAME],0)
			SetObjectCollisionMode(things[this].id, 0)
			SetObjectLightMode( things[this].id, 0 )
			SetObjectTransparency(things[this].id, 1)
			//SetObjectColorEmissive(things[this].id, 90,90,90)
			SetObjectVisible(things[this].id, 1)
			
			if things[this].vars[V_SPLASH_ANIMSPEED] = 0 : things[this].vars[V_SPLASH_ANIMSPEED] = 30 : endif
			things[this].vars[V_SPLASH_NEXTTIME] = tgame.ms + things[this].vars[V_SPLASH_ANIMSPEED]
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			MoveObjectLocalY(things[this].id, -0.1)
			if tgame.ms > things[this].vars[V_SPLASH_NEXTTIME]
				curimage as integer
				inc things[this].vars[V_SPLASH_CURFRAME] //increment the frame
				curimage = IMG_BLOODSTART + things[this].vars[V_SPLASH_CURFRAME]
				if  curimage > IMG_BLOODEND
					if things[this].vars[V_SPLASH_LOOP] = 1
						things[this].vars[V_SPLASH_CURFRAME] = 0	//loop
					else
						things[this].state = STATE_DEAD
					endif
				else
					SetObjectImage(things[this].id, curimage,0)
					things[this].vars[V_SPLASH_NEXTTIME] = tgame.ms + things[this].vars[V_SPLASH_ANIMSPEED]
				endif
			endif
		endcase
	
		case STATE_DEAD
			ClearThing(things, this)
		endcase
	endselect
endfunction

function ProgWeap(tgame ref as Game, things ref as Thing[], this as integer)

	//draw gun before everything else
	cx as float
	cy as float
	cz as float
	cxrot as float
	cyrot as float
	czrot as float
	coffsetx as float
	coffsety as float
	coffsetz as float
	coffsetx = things[this].vars[V_WEAP_XOFFSET]
	coffsety = things[this].vars[V_WEAP_YOFFSET]
	coffsetz = things[this].vars[V_WEAP_ZOFFSET]
	cx = GetCameraX(CAM_MAIN)
	cy = GetCameraY(CAM_MAIN)
	cz = GetCameraZ(CAM_MAIN)
	cxrot = GetCameraAngleX(CAM_MAIN)
	cyrot = GetCameraAngleY(CAM_MAIN)
	czrot = GetCameraAngleZ(CAM_MAIN)
	SetCameraRotation(CAM_MAIN, 0, 0, 0)
	SetCameraPosition(CAM_MAIN, coffsetx, coffsety, coffsetz)	//set cam behind gun -0.5, 0.5, -1.
	SetObjectVisible(things[this].id, 1)
	
	If things[T_PLAYER].used = YES and things[this].vars[V_WEAP_TWEENDONE] = 1
		if things[T_PLAYER].vars[V_PLAYER_MOVED] = 1
//		if things[T_PLAYER].vars[V_PLAYER_SPEED] <= -0.05 or things[T_PLAYER].vars[V_PLAYER_SPEED] >= 0.05
			If GetTweenChainPlaying(TWEENCHAIN_WEAP) = 1
				UpdateTweenChain( TWEENCHAIN_WEAP, GetFrameTime() )
			endif
			if GetTweenChainPlaying(TWEENCHAIN_WEAP) = 0
				PlayTweenChain(TWEENCHAIN_WEAP)
			endif
		elseif GetTweenChainPlaying(TWEENCHAIN_WEAP) = 1
			UpdateTweenChain( TWEENCHAIN_WEAP, GetFrameTime() )
		endif
	endif
	
	//SetAmbientColor(200,200,200)
	DrawObject(things[this].id)
	//SetAmbientColor(10,10,10)
	SetObjectVisible(things[this].id, 0)
	SetCameraPosition(CAM_MAIN, cx, cy, cz)		//set cam back to original position
	SetCameraRotation(CAM_MAIN, cxrot, cyrot, czrot)
	
	select things[this].state
		case STATE_INIT
			uselight as integer
			
			//create the shooting animation
			SetObjectVisible(things[this].id, 0)
			SetObjectDepthRange( things[this].id, 0, 0.05 ) //make gun always in front and prevent it from going into walls
			SetObjectCollisionMode(things[this].id, 0)	
			SetObjectPosition(things[this].id, 0, 0, 0)
			
			uselight = GetEmptyLight(LIGHTSTART, LIGHTEND)
			if uselight <> -1
				CreatePointLight(uselight, -1, 1, 0, 20, 255,255,255)
				SetPointLightMode(uselight,1)
			endif
			things[this].vars[V_WEAP_LIGHT] = uselight
			
			//set muzzlefire offset
			if things[T_BURST].used = YES
				things[T_BURST].vars[V_BURST_OFFSETX] = things[this].vars[V_WEAP_BXOFFSET]
				things[T_BURST].vars[V_BURST_OFFSETY] = things[this].vars[V_WEAP_BYOFFSET]
				things[T_BURST].vars[V_BURST_OFFSETZ] = things[this].vars[V_WEAP_BZOFFSET]
			endif
			
			if things[this].vars[V_WEAP_ATTACKTIME] = 0
				things[this].vars[V_WEAP_ATTACKTIME] = 150
			endif
			
			if things[this].vars[V_WEAP_SPREAD] = 0
				things[this].vars[V_WEAP_SPREAD] = 15
			endif
			
			//create weapon bob effect tween
			CreateTweenChain(TWEENCHAIN_WEAP)
			CreateTweenObject(TWEEN_WEAP_P1,0.5)
			CreateTweenObject(TWEEN_WEAP_P2,0.5)
			SetTweenObjectZ( TWEEN_WEAP_P1, 0, 0.2, TweenSmooth1() ) 
			SetTweenObjectZ( TWEEN_WEAP_P2, 0.2, 0, TweenSmooth1() ) 
			AddTweenChainObject(TWEENCHAIN_WEAP, TWEEN_WEAP_P1, things[this].id, 0)
			AddTweenChainObject(TWEENCHAIN_WEAP, TWEEN_WEAP_P2, things[this].id, 0)
			
			SetObjectAnimationFrame(things[this].id, "", 0, 0)
			
			things[this].vars[V_WEAP_TWEENDONE] = 1
			things[T_WEAP].vars[V_WEAP_NORELOADANIM] = 1
			things[this].state = STATE_RELOAD
		endcase
		
		case STATE_MAIN
			press_fire as integer
			press_reload as integer
			If GetRawKeyState(KEY_L) = 1
				press_fire = 1
			elseif GetPointerState() = 1
				press_fire = 1
			endif
			if GetPointerPressed() = 1 or GetRawKeyState(KEY_R) = 1
				press_reload = 1
			endif
			
			if press_fire = 1 and things[this].vars[V_WEAP_AMMO] >= 1 and tgame.ms > things[this].vars[V_WEAP_NEXTTIME]
				PlayObjectAnimation(things[this].id, "", things[this].vars[V_WEAP_SHOT_B], things[this].vars[V_WEAP_SHOT_E], 0, things[this].vars[V_WEAP_SHOT_T])		
				things[this].state = STATE_ATTACK
				things[this].vars[V_WEAP_NEXTTIME] = tgame.ms + things[this].vars[V_WEAP_ATTACKTIME]
				if things[T_BURST].used = YES	//create muzzle fire effect
					if things[T_BURST].state = STATE_NOBURST : things[T_BURST].state = STATE_BURSTSTART : endif
				endif
				
				//decrease ammo
				dec things[this].vars[V_WEAP_AMMO], 1
				if things[T_HUDBULLETCOUNTER].used = YES
					things[T_HUDBULLETCOUNTER].vars[V_COUNTER_NUMREC] = -1
					things[T_HUDBULLETCOUNTER].state= STATE_UPDATE
				endif
			elseif press_reload = 1 and things[this].vars[V_WEAP_SPAREAMMO] >= 1 and things[this].vars[V_WEAP_AMMO] <> things[this].vars[V_WEAP_AMMOMAX] and things[this].vars[V_WEAP_AMMO] = 0
				things[this].state = STATE_RELOAD
			elseif press_fire = 1 and things[this].vars[V_WEAP_MELEE] = 1 and tgame.ms > things[this].vars[V_WEAP_NEXTTIME]
				PlayObjectAnimation(things[this].id, "", things[this].vars[V_WEAP_SHOT_B], things[this].vars[V_WEAP_SHOT_E], 0, things[this].vars[V_WEAP_SHOT_T])		
				things[this].vars[V_WEAP_NEXTTIME] = tgame.ms + things[this].vars[V_WEAP_ATTACKTIME]
				things[this].state = STATE_ATTACK
			elseif press_fire = 1 and things[this].vars[V_WEAP_AMMO] = 0
				If things[this].vars[V_WEAP_EMPTYSOUND] <> 0
					if GetSoundsPlaying(things[this].vars[V_WEAP_EMPTYSOUND]) = 0
						PlaySound(things[this].vars[V_WEAP_EMPTYSOUND])
					endif
				endif
			endif
		endcase
		
		case STATE_ATTACK
			if things[T_PLAYER].used = NO : things[this].state = STATE_MAIN : exitfunction : endif
			useslot as integer
			useslot = GetEmptySlot(things, T_BULLETSTART, T_BULLETEND)
			if useslot <> -1
				If things[this].vars[V_WEAP_AMMOROCKET] = 1
					SpawnThing(things, useslot, CloneTObject(tgame, TMPL_RPG7ROCKET), PROG_BULLET, THING_TYPE_OBJ)
					things[useslot].vars[V_BULLET_FORWARD] = 0
					things[useslot].vars[V_BULLET_UP] = 1.7
					things[useslot].vars[V_BULLET_RIGHT] = 0
					things[useslot].vars[V_BULLET_SPEED] = things[this].vars[V_WEAP_BULLETSPEED]
					things[useslot].vars[V_BULLET_HIDE] = things[this].vars[V_WEAP_BULLETHIDE]
					things[useslot].vars[V_BULLET_SPREAD] = 0
					things[useslot].vars[V_BULLET_MAXDIST] = things[this].vars[V_WEAP_BULLETMAXDIST]
					things[useslot].vars[V_BULLET_SCASTSIZE] = things[this].vars[V_WEAP_BULLETCASTSIZE]
					things[useslot].vars[V_BULLET_STARTTHING] = T_PLAYER
					things[useslot].vars[V_BULLET_IGNORE] = things[T_PLAYER].id
					things[useslot].vars[V_BULLET_ISROCKET] = 1
				else
					SpawnThing(things, useslot, CloneTObject(tgame, TMPL_BULLET), PROG_BULLET, THING_TYPE_OBJ)
					things[useslot].vars[V_BULLET_FORWARD] = 0
					things[useslot].vars[V_BULLET_UP] = 2
					things[useslot].vars[V_BULLET_RIGHT] = 0
					things[useslot].vars[V_BULLET_SPEED] = things[this].vars[V_WEAP_BULLETSPEED]
					things[useslot].vars[V_BULLET_HIDE] = things[this].vars[V_WEAP_BULLETHIDE]
					things[useslot].vars[V_BULLET_MAXDIST] = things[this].vars[V_WEAP_BULLETMAXDIST]
					things[useslot].vars[V_BULLET_SCASTSIZE] = things[this].vars[V_WEAP_BULLETCASTSIZE]
					things[useslot].vars[V_BULLET_SPREAD] = things[this].vars[V_WEAP_SPREAD]
					things[useslot].vars[V_BULLET_IGNORE] = things[T_PLAYER].id
					things[useslot].vars[V_BULLET_DMG] = things[this].vars[V_WEAP_BULLETDMG]
					things[useslot].vars[V_BULLET_STARTTHING] = T_PLAYER
				endif
			endif
			
			if things[this].vars[V_WEAP_ISROCKETLAUNCHER] = 1
				things[this].state= STATE_RELOAD
				things[this].vars[V_WEAP_NORELOADANIM] = 1
			else
				things[this].state = STATE_MAIN
			endif
			
			If things[this].vars[V_WEAP_SHOTSOUND] <> 0
				PlaySound(things[this].vars[V_WEAP_SHOTSOUND])
			endif
		endcase
		
		case STATE_RELOAD
			if things[this].vars[V_WEAP_RANONCE] = 0
				things[this].vars[V_WEAP_RANONCE] = 1
				//limit spare ammo incase
				if things[this].vars[V_WEAP_SPAREAMMO] > things[this].vars[V_WEAP_SPAREAMMOMAX]
					things[this].vars[V_WEAP_SPAREAMMO] = things[this].vars[V_WEAP_SPAREAMMOMAX]
				endif
				
				//get amount needed from the spare ammo
				amount_needed as integer
				amount_needed = things[this].vars[V_WEAP_AMMOMAX] - things[this].vars[V_WEAP_AMMO]
			
				//if not enough spare ammo to fill the max ammount transfer whats left
				if things[this].vars[V_WEAP_SPAREAMMO] < amount_needed
					things[this].vars[V_WEAP_AMMO] = things[this].vars[V_WEAP_AMMO] + things[this].vars[V_WEAP_SPAREAMMO]
					things[this].vars[V_WEAP_SPAREAMMO] = 0
				else
					things[this].vars[V_WEAP_AMMO] = things[this].vars[V_WEAP_AMMOMAX]
					dec things[this].vars[V_WEAP_SPAREAMMO], amount_needed
				endif
				
				//update using direct value
				//update clip and ammo display
				if things[T_HUDCLIPCOUNTER].used = YES
					things[T_HUDCLIPCOUNTER].vars[V_COUNTER_NUMREC] = things[this].vars[V_WEAP_SPAREAMMO]
					things[T_HUDCLIPCOUNTER].state= STATE_UPDATE2
				endif
				if things[T_HUDBULLETCOUNTER].used = YES
					things[T_HUDBULLETCOUNTER].vars[V_COUNTER_NUMREC] = things[this].vars[V_WEAP_AMMO]
					things[T_HUDBULLETCOUNTER].state= STATE_UPDATE2
				endif	
				
				if things[this].vars[V_WEAP_NORELOADANIM] = 0
					PlayObjectAnimation(things[this].id, "", things[this].vars[V_WEAP_RELOAD_B], things[this].vars[V_WEAP_RELOAD_E], 0, things[this].vars[V_WEAP_RELOAD_T])
				else
					things[this].vars[V_WEAP_NORELOADANIM] = 0
					things[this].vars[V_WEAP_RANONCE] = 0
					things[this].state = STATE_MAIN
				endif
				
				//play reload sound
				If things[this].vars[V_WEAP_RELOADSOUND] <> 0
					PlaySound(things[this].vars[V_WEAP_RELOADSOUND])
				endif
				
			elseif GetObjectIsAnimating(things[this].id) = 0
				things[this].vars[V_WEAP_RANONCE] = 0
				things[this].state = STATE_MAIN
			endif
		endcase
		
		case STATE_DEAD
			If GetObjectIsAnimating(things[this].id) = 0
				PlayObjectAnimation(things[this].id, "", things[this].vars[V_WEAP_LEAVE_B], things[this].vars[V_WEAP_LEAVE_E], 0, things[this].vars[V_WEAP_LEAVE_T])
			endif
			things[this].state = STATE_DEAD2
		endcase
		
		case STATE_DEAD2
			
			ClearTweenChain(TWEENCHAIN_WEAP)
			DeleteTweenChain(TWEENCHAIN_WEAP)
			DeleteTween(TWEEN_WEAP_P1)
			DeleteTween(TWEEN_WEAP_P2)
			if things[this].vars[V_WEAP_LIGHT] <> 0 or things[this].vars[V_WEAP_LIGHT] <> -1
				DeletePointLight(things[this].vars[V_WEAP_LIGHT])
			endif
			
			If GetObjectIsAnimating(things[this].id) = 0
				ClearThing(things,this)
			endif
			
		endcase
	endselect
endfunction

function ProgBullet(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			start as objinfo
			startthing as integer
			uselight as integer
			
			SetObjectCollisionMode(things[this].id, 0)
			
			if things[this].vars[V_BULLET_ISROCKET] = 0
				//SetObjectColor(things[this].id, 255, 200, 0, 255)
				//SetObjectColorEmissive(things[this].id, 255, 200, 0)
			endif
			if things[this].vars[V_BULLET_HIDE] = 1 : SetObjectVisible(things[this].id, 0) : endif
			if things[this].vars[V_BULLET_SPEED] = 0 : things[this].vars[V_BULLET_SPEED] = 1 : endif
			if things[this].vars[V_BULLET_MAXDIST] = 0 : things[this].vars[V_BULLET_MAXDIST] = 300 : endif
			if things[this].vars[V_BULLET_SCASTSIZE] = 0 : things[this].vars[V_BULLET_SCASTSIZE] = 0.2 : endif
			if things[this].vars[V_BULLET_DMG] = 0 : things[this].vars[V_BULLET_DMG]  = 15 : endif
			if things[this].vars[V_BULLET_LOOKAT] <> 0
				//auto aim shot
				targetthing as integer
				target as ObjInfo	//if target is alive shoot to it
				
				startthing = things[this].vars[V_BULLET_STARTTHING]
				targetthing = things[this].vars[V_BULLET_LOOKAT]
				if things[targetthing].used = YES and things[startthing].used = YES
					GetObjectInfo(things[targetthing].id, target)
					GetObjectInfo(things[startthing].id, start)
					SetObjectPosition(things[this].id, start.x, start.y, start.z)
					SetObjectLookAt(things[this].id, target.x, target.y, target.z, 0)
					MoveObjectLocalZ(things[this].id, things[this].vars[V_BULLET_FORWARD])	//move forward a bit to avoid hitting the spawner
					MoveObjectLocalY(things[this].id, things[this].vars[V_BULLET_UP])
					MoveObjectLocalX(things[this].id, things[this].vars[V_BULLET_RIGHT])
					
					//do muzzle flash effect
					if things[this].vars[V_BULLET_LIGHTFLASH] = 1
						uselight = GetEmptyLight(2,9)
						if uselight <> -1
							bplane as integer
							things[this].vars[V_BULLET_BURSTPLANE] = CloneTObject(tgame, TMPL_BURSTPLANE)
							bplane = things[this].vars[V_BULLET_BURSTPLANE]
							SetObjectImage(bplane, IMG_BURST, 0)
							SetObjectScale(bplane, 2,2,2)
							SetObjectTransparency(bplane, 1)
							//SetObjectColorEmissive(bplane, 255,255,0)
							SetObjectCollisionMode(bplane,0)
							SetObjectLightMode(bplane, 0)
							SetObjectPosition(bplane, start.x,start.y,start.z)
							SetObjectLookAt(bplane, GetCameraX(CAM_MAIN), GetCameraY(CAM_MAIN), GetCameraZ(CAM_MAIN), 0)
							MoveObjectLocalZ(bplane, 2.5)
							MoveObjectLocalY(bplane,0.4)
							MoveObjectLocalX(bplane,0.4)
							CreatePointLight(uselight, start.x, start.y, start.z, 15, 255, 255, 0)
							SetPointLightMode(uselight, 1)
							things[this].vars[V_BULLET_LIGHT] = uselight
							things[this].vars[V_BULLET_LIGHTNEXTTIME] = tgame.ms + 50
						endif
					endif
					
					things[this].state = STATE_MAIN
				else
					things[this].state = STATE_DEAD
				endif
			else
				//straight shot
				startthing = things[this].vars[V_BULLET_STARTTHING]
				if things[startthing].used = YES
					GetObjectInfo(things[startthing].id, start)
					SetObjectPosition(things[this].id, start.x, start.y, start.z)
					SetObjectRotation(things[this].id, start.xrot, start.yrot, start.zrot)
					MoveObjectLocalZ(things[this].id, things[this].vars[V_BULLET_FORWARD])	//move forward a bit to avoid hitting the spawner
					MoveObjectLocalY(things[this].id, things[this].vars[V_BULLET_UP])
					MoveObjectLocalX(things[this].id, things[this].vars[V_BULLET_RIGHT])
					
					//spread
					spread as integer
					spread = things[this].vars[V_BULLET_SPREAD]
					if spread <> 0
						RotateObjectLocalX(things[this].id, Random2(-spread,spread) * 0.1)
						RotateObjectLocalY(things[this].id, Random2(-spread,spread) * 0.1)
					endif
					
					things[this].state = STATE_MAIN
				else
					things[this].state = STATE_DEAD
				endif
			endif
		endcase
	
		
		case STATE_MAIN
			thisold as ObjInfo
			thisnew as ObjInfo
			hit as integer
			obji as integer
			ignoreid as integer
			dmgamount as integer
			smoketrailslot as integer
			
			
			if things[this].vars[V_BULLET_LIGHTFLASH] = 1
				if tgame.ms > things[this].vars[V_BULLET_LIGHTNEXTTIME]
					DeletePointLight(things[this].vars[V_BULLET_LIGHT])
					DeleteObject(things[this].vars[V_BULLET_BURSTPLANE])
					things[this].vars[V_BULLET_LIGHTFLASH] = 0
				endif
			endif
			
			GetObjectInfo(things[this].id, thisold)
			MoveObjectLocalZ(things[this].id, things[this].vars[V_BULLET_SPEED])
			inc things[this].vars[V_BULLET_TRAVELDIST], things[this].vars[V_BULLET_SPEED]
			GetObjectInfo(things[this].id, thisnew)
			ignoreid = things[this].vars[V_BULLET_IGNORE]
			hit = ObjectSphereCast(0, thisold.x, thisold.y, thisold.z, thisnew.x, thisnew.y, thisnew.z, things[this].vars[V_BULLET_SCASTSIZE])
			if hit <> 0 and hit <> ignoreid
				
				if things[this].vars[V_BULLET_ISROCKET] <> 0
					dmgamount = 100
				else
					dmgamount = things[this].vars[V_BULLET_DMG]
				endif
				
				if AllowHit(things, T_PLAYER, hit) = 1 //things[T_PLAYER].used = YES and hit = things[T_PLAYER].id and things[T_PLAYER].state <> STATE_DEAD
					things[T_PLAYER].state = STATE_HIT
					things[T_PLAYER].vars[V_PLAYER_DMGREC] = dmgamount
					things[this].vars[V_BULLET_NOSMOKE] = 1 //set so there is no smoke when hitting player
					//things[this].vars[V_BULLET_NOSPLASH] = 1 //set so there is no splash when bullet hits player
					things[this].vars[V_BULLET_SPILLBLOOD] = 1
				else
					for obji = T_ENEMYSTART to T_ENEMYEND
						if AllowHit(things, obji, hit) = 1 //things[obji].used = YES and hit = things[obji].id and things[obji].state <> STATE_DEAD
							things[obji].state = STATE_HIT
							things[obji].vars[V_ENEMY_RDMG] = dmgamount
							things[this].vars[V_BULLET_NOSMOKE] = 1
							//things[this].vars[V_BULLET_NOSPLASH] = 1
							things[this].vars[V_BULLET_SPILLBLOOD] = 1
						endif
					next
				endif
				
				things[this].vars[V_BULLET_RCX]=GetObjectRayCastX(0)
				things[this].vars[V_BULLET_RCY]=GetObjectRayCastY(0)
				things[this].vars[V_BULLET_RCZ]=GetObjectRayCastZ(0)
				things[this].state = STATE_DEAD
			endif
			
			//smoke trail
			if things[this].vars[V_BULLET_ISROCKET] = 1
				if tgame.ms > things[this].vars[V_BULLET_SMOKENEXTTIME]
					smoketrailslot = GetEmptySlot(things, T_SMOKESTART, T_SMOKEEND)
					if smoketrailslot <> -1				
						SpawnThing(things, smoketrailslot, CloneTObject(tgame, TMPL_SPLASHPLANE), PROG_SMOKE, THING_TYPE_OBJ)
						SetObjectVisible(things[smoketrailslot].id,0) //make it invisible until its init is reached
						SETV(things, smoketrailslot, V_SMOKE_INITX, thisnew.x)
						SETV(things, smoketrailslot, V_SMOKE_INITY, thisnew.y)
						SETV(things, smoketrailslot, V_SMOKE_INITZ, thisnew.z)
					endif
					things[this].vars[V_BULLET_SMOKENEXTTIME] = tgame.ms + 80
				endif
			endif
			
			
			if things[this].vars[V_BULLET_TRAVELDIST] > things[this].vars[V_BULLET_MAXDIST]
				things[this].vars[V_BULLET_NOSPLASH] = 1
				things[this].vars[V_BULLET_NOSMOKE] = 1
				things[this].state = STATE_DEAD
			endif
		endcase
		
		case STATE_DEAD
			useslot as integer
			if things[this].vars[V_BULLET_NOSPLASH] = 0
				//ClearThing(things, this)
				//exitfunction
				//spawn bullet splash
				useslot = GetEmptySlot(things, T_SPLASHSTART, T_SPLASHEND)
				if useslot <> -1				
					if things[this].vars[V_BULLET_ISROCKET] <> 0
						SpawnThing(things, useslot, CloneTObject(tgame, TMPL_SPLASHPLANE), PROG_EXPLODE, THING_TYPE_OBJ)
						SetObjectVisible(things[useslot].id,0) //make it invisible until its init is reached
						SETV(things, useslot, V_EXPLODE_INITX, things[this].vars[V_BULLET_RCX])
						SETV(things, useslot, V_EXPLODE_INITY, things[this].vars[V_BULLET_RCY])
						SETV(things, useslot, V_EXPLODE_INITZ, things[this].vars[V_BULLET_RCZ])
					else
						SpawnThing(things, useslot, CloneTObject(tgame, TMPL_SPLASHPLANE), PROG_SPLASH, THING_TYPE_OBJ)
						SetObjectVisible(things[useslot].id,0) //make it invisible until its init is reached
						SETV(things, useslot, V_SPLASH_INITX, things[this].vars[V_BULLET_RCX])
						SETV(things, useslot, V_SPLASH_INITY, things[this].vars[V_BULLET_RCY])
						SETV(things, useslot, V_SPLASH_INITZ, things[this].vars[V_BULLET_RCZ])
					endif
				endif
			
			endif
			
			//spawn smoke if wall
			if things[this].vars[V_BULLET_NOSMOKE] = 0
				useslot = GetEmptySlot(things, T_SMOKESTART, T_SMOKEEND)
				if useslot <> -1				
					SpawnThing(things, useslot, CloneTObject(tgame, TMPL_SPLASHPLANE), PROG_SMOKE, THING_TYPE_OBJ)
					SetObjectVisible(things[useslot].id,0) //make it invisible until its init is reached
					SETV(things, useslot, V_SMOKE_INITX, things[this].vars[V_BULLET_RCX])
					SETV(things, useslot, V_SMOKE_INITY, things[this].vars[V_BULLET_RCY])
					SETV(things, useslot, V_SMOKE_INITZ, things[this].vars[V_BULLET_RCZ])
					
					//play rico sound
					if things[this].vars[V_BULLET_ISROCKET] = 0
						rand as integer
						rand = random(0,1)
						if rand = 0 then PlaySoundDist(things[this].id, SND_RICO1)
						if rand = 1 then PlaySoundDist(things[this].id, SND_RICO2)
					endif
				endif
			endif
			
			if things[this].vars[V_BULLET_SPILLBLOOD] = 1
				useslot = GetEmptySlot(things, T_BLOODSTART, T_BLOODEND)
				if useslot <> -1
					SpawnThing(things, useslot, CloneTObject(tgame, TMPL_SPLASHPLANE), PROG_BLOOD, THING_TYPE_OBJ)
					SetObjectVisible(things[useslot].id,0) //make it invisible until its init is reached
					SETV(things, useslot, V_SPLASH_INITX, things[this].vars[V_BULLET_RCX])
					SETV(things, useslot, V_SPLASH_INITY, things[this].vars[V_BULLET_RCY])
					SETV(things, useslot, V_SPLASH_INITZ, things[this].vars[V_BULLET_RCZ])	
				endif
			endif
			
			//delete light if still exists
			if things[this].vars[V_BULLET_LIGHTFLASH] = 1
				DeletePointLight(things[this].vars[V_BULLET_LIGHT])
				DeleteObject(things[this].vars[V_BULLET_BURSTPLANE])
			endif
			
			ClearThing(things, this)
		endcase
	endselect
endfunction

function ProgEnemy(tgame ref as Game, things ref as Thing[], this as integer)
	thisobj as ObjInfo
	player as ObjInfo
	thisspeed as float
			
	select things[this].state
		case STATE_INIT
			shadow_useslot as integer
			
			if things[this].vars[V_ENEMY_HITBOXFLOAT] =0 :  things[this].vars[V_ENEMY_HITBOXFLOAT] = 2 : endif
			
			SetObjectPosition(things[this].id, things[this].vars[V_ENEMY_INITX], GetGroundY(things[this].id), things[this].vars[V_ENEMY_INITZ]) 
			MoveObjectLocalY(things[this].id, things[this].vars[V_ENEMY_HITBOXFLOAT]) //needs to float off ground a little
			SetObjectVisible(things[this].id, SHOWHITBOXES)
			
			things[this].vars[V_ENEMY_CHARID] = CloneTObject(tgame, things[this].vars[V_ENEMY_USETEMPLATE])
			SetObjectCollisionMode(things[this].vars[V_ENEMY_CHARID], 0)
			MoveObjectLocalY(things[this].vars[V_ENEMY_CHARID], -things[this].vars[V_ENEMY_HITBOXFLOAT])
			FixObjectToObject(things[this].vars[V_ENEMY_CHARID], things[this].id)
			
			//spawn shadow
			shadow_useslot = GetEmptySlot(things, T_SHADOWSTART, T_SHADOWEND)
			if shadow_useslot <> -1
				SpawnThing(things,shadow_useslot,CloneTObject(tgame, TMPL_SHADOWPLANE), PROG_SHADOW, THING_TYPE_OBJ)
				things[shadow_useslot].vars[V_SHADOW_FOLLOWTHING] = this
			endif
			
			if things[this].vars[V_ENEMY_FORWARDTIME] = 0 : things[this].vars[V_ENEMY_FORWARDTIME] = 1000 : endif
			if things[this].vars[V_ENEMY_PROJECTILEDIST] = 0 : things[this].vars[V_ENEMY_PROJECTILEDIST] = 300 : endif
			if things[this].vars[V_ENEMY_RANGE] = 0 	: things[this].vars[V_ENEMY_RANGE] = 30 : endif
			if things[this].vars[V_ENEMY_ATTACKRANGE] = 0 : things[this].vars[V_ENEMY_ATTACKRANGE] = 30 : endif
			if things[this].vars[V_ENEMY_HP] = 0 		: things[this].vars[V_ENEMY_HP] = 100	: endif
			if things[this].vars[V_ENEMY_ROTSPEED] = 0 	: things[this].vars[V_ENEMY_ROTSPEED] = 5	: endif
			if things[this].vars[V_ENEMY_SPEED] = 0 	: things[this].vars[V_ENEMY_SPEED] = 0.15	: endif
			if things[this].vars[V_ENEMY_ATTACKWAIT] = 0 : things[this].vars[V_ENEMY_ATTACKWAIT] = 500 : endif
			if things[this].vars[V_ENEMY_TMPLFORBULLET] = 0 : things[this].vars[V_ENEMY_TMPLFORBULLET] = TMPL_BULLET : endif
			if things[this].vars[V_ENEMY_PROJECTILESCASTSIZE] = 0 : things[this].vars[V_ENEMY_PROJECTILESCASTSIZE] = 0.2 : endif
			if things[this].vars[V_ENEMY_PROJECTILEUP] = 0 : things[this].vars[V_ENEMY_PROJECTILEUP] = 0 : endif
			things[this].state = STATE_IDLE
		endcase	
		
		case STATE_IDLE	//dormant state
			If things[T_PLAYER].used = NO : exitfunction : endif
			hit as integer
			pid as integer
			hid as integer
			
			GetObjectInfo(things[this].id, thisobj)
			GetObjectInfo(things[T_PLAYER].id, player)
			SetObjectCollisionMode(things[this].id, 0)
			if ObjectSphereCast(things[T_PLAYER].id, thisobj.x, thisobj.y, thisobj.z, thisobj.x, thisobj.y, thisobj.z, things[this].vars[V_ENEMY_RANGE])
				//follow player only when it can see it
				hit = ObjectRayCast(0, thisobj.x, thisobj.y, thisobj.z, player.x, player.y, player.z)
				
				if GetObjectRayCastNumHits() = 1 and hit = things[T_PLAYER].id
					things[this].state = STATE_LOOKAT
					PlaySoundDist(things[this].id,things[this].vars[V_ENEMY_SNDALERT] )
				endif
			endif
			SetObjectCollisionMode(things[this].id, 1)

			//animation
			If GetObjectIsAnimating(things[this].vars[V_ENEMY_CHARID]) = 0
				things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_IDLE_B
				PlayObjectAnimation(things[this].vars[V_ENEMY_CHARID], "", things[this].vars[V_ENEMY_ANIM_IDLE_B], things[this].vars[V_ENEMY_ANIM_IDLE_E], 0, things[this].vars[V_ENEMY_ANIM_IDLE_T])
			endif
		endcase
		
		case STATE_HIT
			receive_dmg as integer
			receive_dmg = things[this].vars[V_ENEMY_RDMG]
			dec things[this].vars[V_ENEMY_HP], receive_dmg
			things[this].vars[V_ENEMY_RDMG] = 0
			
			PlaySound(SND_HITENEMY)
			
			
			if things[this].vars[V_ENEMY_HP] <= 0
				things[this].vars[V_ENEMY_NEXTTIME] = tgame.ms + 5000
				SetObjectCollisionMode(things[this].id, 0)
				if things[this].vars[V_ENEMY_ANIMNOW] <> V_ENEMY_ANIM_DIE_B
					things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_DIE_B
					PlayObjectAnimation(things[this].vars[V_ENEMY_CHARID], "", things[this].vars[V_ENEMY_ANIM_DIE_B], things[this].vars[V_ENEMY_ANIM_DIE_E], 0, things[this].vars[V_ENEMY_ANIM_DIE_T])
				endif

				PlaySoundDist(things[this].id,things[this].vars[V_ENEMY_SNDDIE] )
				
				//Spawn a Gem
				gem as integer
				gem = GetEmptySlot(things, T_ITEMSSTART, T_ITEMEND)
				if gem <> -1
					SpawnThing(things, gem, CloneTObject(tgame,TMPL_GEM), PROG_ITEM, THING_TYPE_OBJ)
					SETV(things, gem, V_ITEM_INITX, GetObjectX(things[this].id))
					SETV(things, gem, V_ITEM_INITZ, GetObjectZ(things[this].id))
					SETV(things, gem, V_ITEM_TYPE, ITEM_GEM)
				endif

				things[this].state = STATE_DEAD
			else
				
				if things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_IDLE_B
					things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_MOVE_B
					PlayObjectAnimation(things[this].vars[V_ENEMY_CHARID], "", things[this].vars[V_ENEMY_ANIM_MOVE_B], things[this].vars[V_ENEMY_ANIM_MOVE_E], 0, things[this].vars[V_ENEMY_ANIM_MOVE_T])
				endif
				
				things[this].state = STATE_LOOKAT
			endif
		endcase
		
		case STATE_DEAD
			if tgame.ms > things[this].vars[V_ENEMY_NEXTTIME]
				DeleteObject(things[this].vars[V_ENEMY_CHARID])
				ClearThing(things, this)
			else
				//MoveObjectLocalY(things[this].id, -0.03)
				//RotateObjectLocalY(things[this].id, 5)
			endif
		endcase
		
		case STATE_LOOKAT
			//make enemy look at player
			If things[T_PLAYER].used = NO : exitfunction : endif
			rotspeed as float
			peangle as float
			hitray as integer
			rotspeed = things[this].vars[V_ENEMY_ROTSPEED]
			peangle = 0
			
			
			// 
			GetObjectInfo(things[T_PLAYER].id, player)
			GetObjectInfo(things[this].id, thisobj)
			peangle = GetAngleYAdjust(player.x, player.z, thisobj.x, thisobj.z, thisobj.yrot) //get angle between player and enemy
			
				
			if peangle >= 175 and peangle <= 185	//if the angle is between 170 and 190 it is facing the player
				things[this].vars[V_ENEMY_NEXTTIME] = tgame.ms + things[this].vars[V_ENEMY_FORWARDTIME]
				things[this].state = STATE_FORWARD	//its facing the player so it can go forward
				
				if random(0,10) = 1 and GetSoundsPlaying(things[this].vars[V_ENEMY_SNDFORWARD]) = 0
					PlaySoundDist(things[this].id,things[this].vars[V_ENEMY_SNDFORWARD] )
				endif
				
				if GetDistance(thisobj.x, thisobj.z, player.x, player.z) <= things[this].vars[V_ENEMY_ATTACKRANGE] //if player is in range attack
					hitray = ObjectRayCast(0, thisobj.x, thisobj.y, thisobj.z, player.x, player.y, player.z)
					if GetObjectRayCastNumHits() = 1 and hitray = things[T_PLAYER].id
						things[this].state = STATE_ATTACK
					endif
				endif
			else
				//check which side player is on to rotate to correct diretion
				if peangle > 180
					RotateObjectLocalY(things[this].id, -rotspeed)
				elseif peangle < 180
					RotateObjectLocalY(things[this].id, rotspeed)
				endif
				things[this].state = STATE_LOOKAT
			endif
			
			if GetObjectIsAnimating(things[this].vars[V_ENEMY_CHARID]) = 0
				things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_MOVE_B
				PlayObjectAnimation(things[this].vars[V_ENEMY_CHARID], "", things[this].vars[V_ENEMY_ANIM_MOVE_B], things[this].vars[V_ENEMY_ANIM_MOVE_E], 0, things[this].vars[V_ENEMY_ANIM_MOVE_T])
			endif
		endcase
		
		case STATE_LOOKRANDOM
			If things[T_PLAYER].used = NO : exitfunction : endif
			randdirection as integer
			target as ObjInfo
			tangle as float
			trotspeed as float
			trotspeed = things[this].vars[V_ENEMY_ROTSPEED]
			//get target location
			if things[this].vars[V_ENEMY_TARGETDONE] = 0
				GetObjectInfo(things[this].id, thisobj)
				randdirection = random(0,1)
				if randdirection = 1
					RotateObjectLocalY(things[this].id, 120)
				else
					RotateObjectLocalY(things[this].id, -120)
				endif
				MoveObjectLocalZ(things[this].id, 5)
				GetObjectInfo(things[this].id, target)
				SetObjectPosition(things[this].id, thisobj.x, thisobj.y, thisobj.z)
				SetObjectRotation(things[this].id, thisobj.xrot, thisobj.yrot, thisobj.zrot) //return to orignal state
				
				things[this].vars[V_ENEMY_TX] = target.x
				things[this].vars[V_ENEMY_TY] = target.y
				things[this].vars[V_ENEMY_TZ] = target.z
				
				things[this].vars[V_ENEMY_TARGETDONE] = 1
				
				things[this].state = STATE_LOOKRANDOM
			else
				GetObjectInfo(things[this].id, thisobj)
				tangle = GetAngleYAdjust(things[this].vars[V_ENEMY_TX], things[this].vars[V_ENEMY_TZ], thisobj.x, thisobj.z, thisobj.yrot) //get angle between player and target
				if tangle >= 175 and tangle <= 185	//if the angle is between 170 and 190 it is facing the player
					things[this].vars[V_ENEMY_NEXTTIME] = tgame.ms + things[this].vars[V_ENEMY_FORWARDTIME]
					things[this].state = STATE_FORWARD	//its facing the player so it can go forward
					things[this].vars[V_ENEMY_TARGETDONE] = 0 //reset target done
				else
					//check which side player is on to rotate to correct diretion
					if tangle > 180
						RotateObjectLocalY(things[this].id, -trotspeed)
					elseif tangle < 180
						RotateObjectLocalY(things[this].id, trotspeed)
					endif
					things[this].state = STATE_LOOKRANDOM
				endif
			endif
			
			if GetObjectIsAnimating(things[this].vars[V_ENEMY_CHARID]) = 0
				things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_MOVE_B
				PlayObjectAnimation(things[this].vars[V_ENEMY_CHARID], "", things[this].vars[V_ENEMY_ANIM_MOVE_B], things[this].vars[V_ENEMY_ANIM_MOVE_E], 0, things[this].vars[V_ENEMY_ANIM_MOVE_T])
			endif
		endcase
		
		case STATE_ATTACK
			useslot as integer
			template as integer
			
			if tgame.ms > things[this].vars[V_ENEMY_ATTACKNEXTTIME]
				useslot = GetEmptySlot(things, T_BULLETSTART, T_BULLETEND)
				if useslot <> -1
					template = things[this].vars[V_ENEMY_TMPLFORBULLET]
					GetObjectInfo(things[this].id, thisobj)
					SpawnThing(things, useslot, CloneTObject(tgame, template), PROG_BULLET, THING_TYPE_OBJ)
					things[useslot].vars[V_BULLET_FORWARD] = 0
					things[useslot].vars[V_BULLET_UP] = things[this].vars[V_ENEMY_PROJECTILEUP]
					things[useslot].vars[V_BULLET_STARTTHING] = this
					things[useslot].vars[V_BULLET_LOOKAT] = T_PLAYER
					things[useslot].vars[V_BULLET_MAXDIST] = things[this].vars[V_ENEMY_PROJECTILEDIST]
					things[useslot].vars[V_BULLET_IGNORE] = things[this].id
					things[useslot].vars[V_BULLET_ISROCKET] = things[this].vars[V_ENEMY_USEROCKET]
					things[useslot].vars[V_BULLET_SPREAD] = things[this].vars[V_ENEMY_PROJECTILESPREAD]
					things[useslot].vars[V_BULLET_SCASTSIZE] = things[this].vars[V_ENEMY_PROJECTILESCASTSIZE]
					things[useslot].vars[V_BULLET_LIGHTFLASH] = things[this].vars[V_ENEMY_LFLASHONATTACK]
					things[this].vars[V_ENEMY_ATTACKNEXTTIME] = tgame.ms + things[this].vars[V_ENEMY_ATTACKWAIT]
					things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_ATTACK_B
					
					PlayObjectAnimation(things[this].vars[V_ENEMY_CHARID], "", things[this].vars[V_ENEMY_ANIM_ATTACK_B], things[this].vars[V_ENEMY_ANIM_ATTACK_E], 0, things[this].vars[V_ENEMY_ANIM_ATTACK_T])
					PlaySoundDist(things[this].id,things[this].vars[V_ENEMY_SNDATTACK] )
				endif
			endif
			
			//look at player again after a few seconds
			If tgame.ms > things[this].vars[V_ENEMY_NEXTTIME]
				things[this].state = STATE_LOOKAT
			endif
		endcase
		
		case STATE_WAIT
			If tgame.ms > things[this].vars[V_ENEMY_NEXTTIME]
				//enemy walks through the door
				things[this].vars[V_ENEMY_NEXTTIME] = tgame.ms + things[this].vars[V_ENEMY_FORWARDTIME]
				things[this].state = STATE_FORWARD	//its facing the player so it can go forward
				PlayObjectAnimation(things[this].vars[V_ENEMY_CHARID], "", things[this].vars[V_ENEMY_ANIM_MOVE_B], things[this].vars[V_ENEMY_ANIM_MOVE_E], 0, things[this].vars[V_ENEMY_ANIM_MOVE_T])
			endif
			
			If GetObjectIsAnimating(things[this].vars[V_ENEMY_CHARID]) = 0
				things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_IDLE_B
				PlayObjectAnimation(things[this].vars[V_ENEMY_CHARID], "", things[this].vars[V_ENEMY_ANIM_IDLE_B], things[this].vars[V_ENEMY_ANIM_IDLE_E], 0, things[this].vars[V_ENEMY_ANIM_IDLE_T])
			endif
		endcase
		
		case STATE_FORWARD
			object_hit as integer
			hits as integer
			thisold as objinfo
			thisnew as objinfo
			index as integer
			doorindex as integer
			opendoor as integer
			
			thisspeed = things[this].vars[V_ENEMY_SPEED]
			
			GetObjectInfo(things[this].id, thisold)
			//make enemy move toward player
			MoveObjectLocalZ(things[this].id, thisspeed)
			GetObjectInfo(things[this].id, thisnew)
			
			//check for wall collision
			SetObjectCollisionMode(things[this].id, 0)	//prevent from hitting self
			object_hit = 0 
			object_hit = ObjectSphereSlide(0,thisold.x, thisold.y, thisold.z, thisnew.x, thisnew.y, thisnew.z, 1)
			if object_hit <> 0
				hits = GetObjectRayCastNumHits()
				for index = 0 to hits
					
					//GetObjectRaycastSLideY(index)
					SetObjectPosition(things[this].id, GetObjectRayCastSlideX(index), GetGroundY(things[this].id), GetObjectRayCastSlideZ(index) )
					MoveObjectLocalY(things[this].id, things[this].vars[V_ENEMY_HITBOXFLOAT]) 
					things[this].state = STATE_LOOKRANDOM
					
					//when enemy is at a door
					for doorindex = T_DOORSTART to T_DOOREND
						if things[doorindex].used = YES and GetObjectRayCastHitID(index) = things[doorindex].id
							//open only if door does not require key
							if things[doorindex].vars[V_DOOR_REQBLUKEY] = 0 and things[doorindex].vars[V_DOOR_REQREDKEY] = 0 and things[doorindex].vars[V_DOOR_REQYELKEY] = 0
								if things[doorindex].state = STATE_IDLE
									things[doorindex].state = STATE_OPENDOOR
									opendoor = 1
								elseif things[doorindex].state = STATE_OPENDOORUP or things[doorindex].state = STATE_CLOSEDOORDOWN
									//wait if the door closes in its face and try to open again
									opendoor = 1
								endif
							endif
						endif
					next
					
					//when enemy runs into player
					
					if things[T_PLAYER].used = YES
					if GetObjectRayCastHitID(index) = things[T_PLAYER].id
						things[this].state = STATE_LOOKAT
					endif
					endif
				next
			endif

			//attack imm if player is in range
			/*
			if things[T_PLAYER].used = YES
				GetObjectInfo(things[T_PLAYER].id, playerwf)
				if GetDistance(thisnew.x, thisnew.z, playerwf.x, playerwf.z) <= things[this].vars[V_ENEMY_RANGE] //if player is in range attack
					hitray = ObjectRayCast(0, thisnew.x, thisnew.y, thisnew.z, playerwf.x, playerwf.y, playerwf.z)
					if GetObjectRayCastNumHits() = 1 and hitray = things[T_PLAYER].id
						things[this].state = STATE_LOOKAT
						
					endif
				endif
			endif
			*/
			SetObjectCollisionMode(things[this].id, 1)
			
			//look at player again after a few seconds
			If tgame.ms > things[this].vars[V_ENEMY_NEXTTIME]
				things[this].state = STATE_LOOKAT
			endif
			
			//makes enemy wait for the door to open
			if opendoor = 1
				things[this].state = STATE_WAIT //waits
				things[this].vars[V_ENEMY_NEXTTIME] = tgame.ms + 1200			
			endif
			
			if GetObjectIsAnimating(things[this].vars[V_ENEMY_CHARID]) = 0 or things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_IDLE_B
				things[this].vars[V_ENEMY_ANIMNOW] = V_ENEMY_ANIM_MOVE_B
				PlayObjectAnimation(things[this].vars[V_ENEMY_CHARID], "", things[this].vars[V_ENEMY_ANIM_MOVE_B], things[this].vars[V_ENEMY_ANIM_MOVE_E], 0, things[this].vars[V_ENEMY_ANIM_MOVE_T])
			endif
			
		endcase
	endselect
	
	
endfunction

function ProgPause(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			If GetRawKeyPressed(KEY_P) = 1
				if tgame.paused = 0
					tgame.paused = 1
				elseif tgame.paused = 1
					tgame.paused = 0
				endif
			endif
		endcase
	endselect
endfunction

function ProgHud(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			
		endcase
	endselect
endfunction

function ProgObjPlacer(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			pinfo as ObjInfo
			oinfo as ObjInfo
			current_slot as integer
			
			If GetRawKeyPressed(KEY_L) = 1
				DeleteObject(things[this].id)
				things[this].id = 0
				
				//cycle through templates
				inc things[this].vars[V_OBJPLACE_TSLOT], 1
				if things[this].vars[V_OBJPLACE_TSLOT] = TMPL_LAST
					things[this].vars[V_OBJPLACE_TSLOT] = 0
				endif
				
				current_slot = things[this].vars[V_OBJPLACE_TSLOT]
				if tgame.t[current_slot] <> 0
					things[this].id = CloneTObject(tgame, things[this].vars[V_OBJPLACE_TSLOT])
					SetObjectCollisionMode(things[this].id, 0)
				endif
			endif
			
			
			if things[this].id <> 0 and things[T_PLAYER].used = YES
				
				If GetRawKeyPressed(KEY_I)
					inc things[this].vars[V_OBJPLACE_YADJ], 0.5
				elseif GetRawKeyPressed(KEY_O)
					dec things[this].vars[V_OBJPLACE_YADJ], 0.5
				endif
				
				GetObjectInfo(things[T_PLAYER].id, pinfo)
				SetObjectPosition(things[this].id, pinfo.x, pinfo.y + things[this].vars[V_OBJPLACE_YADJ] , pinfo.z)
				SetObjectRotation(things[this].id, pinfo.xrot, pinfo.yrot, pinfo.zrot)
				MoveObjectLocalZ(things[this].id, 8)
				RotateObjectLocalY(things[this].id, 90)
				
				GetObjectInfo(things[this].id, oinfo)
				
				print("--------------------------")
				print("SLOT: " + STR(things[this].vars[V_OBJPLACE_TSLOT]))
				print("X: " + STR(oinfo.x) + "Y: " + STR(oinfo.y) + "Z: " + STR(oinfo.z))
			endif
			
			
		endcase
		
		
		
	endselect
endfunction

function ProgTrigger(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			SetObjectPosition(things[this].id, things[this].vars[V_TRIGGER_INITX], things[this].vars[V_TRIGGER_INITY], things[this].vars[V_TRIGGER_INITZ])
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_IDLE
			
		endcase
		
		case STATE_TRIGGER
			target as integer
			target = things[this].vars[V_TRIGGER_THING]
			
			if things[target].used = YES
				if things[target].state = STATE_IDLE
					things[target].vars[V_DOOR_REQTRIGGER] = 2
					things[target].state = STATE_OPENDOOR
					
					if things[this].vars[V_TRIGGER_MSGSLOT] <> 0 and things[T_GAMEMSG].used = YES
						SETV(things, T_GAMEMSG, V_GAMEMSG_SLOT, things[this].vars[V_TRIGGER_MSGSLOT])
						SETSTATE(things, T_GAMEMSG, STATE_ATTACK)
					endif
					
				endif
			endif
			things[this].state = STATE_IDLE
		endcase
	endselect
endfunction

function ProgGameMsg(tgame ref as Game, things ref as Thing[], this as integer)
	msg_i as integer
	dim msgs[10] as string
	msgs[0] = "GOT THE RED KEY"
	msgs[1] = "GOT THE BLUE KEY"
	msgs[2] = "GOT THE YELLOW KEY"
	msgs[3] = "IT'S LOCKED"
	msgs[4] = "A DOOR HAS OPENED SOMEWHERE"
	
	select things[this].state
		case STATE_INIT
			CreateText(TEXT_MSG, "")
			SetTextSize(TEXT_MSG, 32)
			SetTextAlignment(TEXT_MSG, 1)
			SetTextPosition(TEXT_MSG, tgame.window_width/2, 0)
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
		endcase
		
		case STATE_WAIT
			if tgame.ms > things[this].vars[V_GAMEMSG_NEXTTIME] 
				SetTextString(TEXT_MSG, "")
				things[this].state = STATE_MAIN
			endif
		endcase
			
		case STATE_ATTACK
			slot as integer
			slot = things[this].vars[V_GAMEMSG_SLOT]
			SetTextString(TEXT_MSG, msgs[slot])
			
			things[this].vars[V_GAMEMSG_NEXTTIME] = tgame.ms + 2000
			things[this].state = STATE_WAIT
		endcase
	endselect
endfunction

function ProgInventory(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			things[this].state = STATE_MAIN
			things[this].vars[V_INVENTORY_WEAPNOW] = 0
			things[this].vars[V_INVENTORY_WEAPMAX] = 4
			//0 none, 1 pistol, 2 rifle, 3 launcher, 4 trident
			
			
			things[this].vars[V_INVENTORY_HASMELEE] = 1
			things[this].vars[V_INVENTORY_HASTRIDENT] = 1
			things[this].vars[V_INVENTORY_HASGUN] = 0
			things[this].vars[V_INVENTORY_HASRIFLE] = 0
			things[this].vars[V_INVENTORY_HASRLAUNCHER] = 0
			
			things[this].vars[V_INVENTORY_GUN_SPAREAMMO] = 30
			things[this].vars[V_INVENTORY_GUN_AMMO] = 7
			things[this].vars[V_INVENTORY_RIFLE_SPAREAMMO] = 80
			things[this].vars[V_INVENTORY_RIFLE_AMMO] = 30
			things[this].vars[V_INVENTORY_ROCKET_SPAREAMMO] = 10
			things[this].vars[V_INVENTORY_ROCKET_AMMO] = 1
		endcase
		
		case STATE_DEAD
			ClearTHing(things, this)
		endcase
		
		case STATE_MAIN
			switchgun as integer
			
			if GetRawKeyPressed(KEY_Q) = 1 or things[this].vars[V_INVENTORY_WEAPNOW] = 0
				switchgun = 1
			elseif GetVirtualJoystickY(JOYR) >= 0.8 and tgame.ms > things[this].vars[V_INVENTORY_NEXTTIME]
				switchgun = 1
			endif
			
			If switchgun = 1
				gunnow as integer
				gunnow = things[this].vars[V_INVENTORY_WEAPNOW]
				
				things[this].vars[V_INVENTORY_NEXTTIME] = tgame.ms + 1000
				
				//save the ammo values
				if gunnow = 3
					things[this].vars[V_INVENTORY_ROCKET_SPAREAMMO] = things[T_WEAP].vars[V_WEAP_SPAREAMMO]
					things[this].vars[V_INVENTORY_ROCKET_AMMO] = things[T_WEAP].vars[V_WEAP_AMMO]
				elseif gunnow = 2
					things[this].vars[V_INVENTORY_RIFLE_SPAREAMMO] = things[T_WEAP].vars[V_WEAP_SPAREAMMO]
					things[this].vars[V_INVENTORY_RIFLE_AMMO] = things[T_WEAP].vars[V_WEAP_AMMO]
				elseif gunnow = 1
					things[this].vars[V_INVENTORY_GUN_SPAREAMMO] = things[T_WEAP].vars[V_WEAP_SPAREAMMO]
					things[this].vars[V_INVENTORY_GUN_AMMO] = things[T_WEAP].vars[V_WEAP_AMMO]
				endif

				//clear current weapon
				
				ClearTweenChain(TWEENCHAIN_WEAP)
				DeleteTweenChain(TWEENCHAIN_WEAP)
				DeleteTween(TWEEN_WEAP_P1)
				DeleteTween(TWEEN_WEAP_P2)
				DeletePointLight(things[T_WEAP].vars[V_WEAP_LIGHT])
				ClearThing(things, T_WEAP)
				
				do
					inc things[this].vars[V_INVENTORY_WEAPNOW], 1
					if things[this].vars[V_INVENTORY_WEAPNOW] > things[this].vars[V_INVENTORY_WEAPMAX]
						things[this].vars[V_INVENTORY_WEAPNOW] = 0
					endif
					
					gunnow = things[this].vars[V_INVENTORY_WEAPNOW]
					
					if gunnow = 4 and things[this].vars[V_INVENTORY_HASTRIDENT] = 1
						exit
					elseif gunnow = 3 and things[this].vars[V_INVENTORY_HASRLAUNCHER] = 1
						exit
					elseif gunnow = 2 and things[this].vars[V_INVENTORY_HASRIFLE] = 1
						exit
					elseif gunnow = 1 and things[this].vars[V_INVENTORY_HASGUN] = 1
						exit
					elseif gunnow = 0
						exit
					endif
				loop
				
				//hide when zero..
				if gunnow = 0
					things[T_HUDBULLETCOUNTER].state = STATE_HIDE
					things[T_HUDCLIPCOUNTER].state = STATE_HIDE
					things[T_CROSSHAIR].state = STATE_HIDE
				endif
				
				if gunnow = 1 //pistol
					SpawnThing(things, T_WEAP, CloneTObject(tgame, TMPL_WEAPGUN), PROG_WEAP, THING_TYPE_OBJ)
					things[T_WEAP].vars[V_WEAP_XOFFSET] = -3.6	//guncam offset
					things[T_WEAP].vars[V_WEAP_YOFFSET] = 1.8
					things[T_WEAP].vars[V_WEAP_ZOFFSET] = -5.9
					things[T_WEAP].vars[V_WEAP_BXOFFSET] = 0.4 //muzzle fire offset
					things[T_WEAP].vars[V_WEAP_BYOFFSET] = -0.1
					things[T_WEAP].vars[V_WEAP_BZOFFSET] = 1
					things[T_WEAP].vars[V_WEAP_ATTACKTIME] = 300
					things[T_WEAP].vars[V_WEAP_SHOT_B] = ANIM_GUNSHOT_B
					things[T_WEAP].vars[V_WEAP_SHOT_E] = ANIM_GUNSHOT_E
					things[T_WEAP].vars[V_WEAP_SHOT_T] = ANIM_GUNSHOT_T
					things[T_WEAP].vars[V_WEAP_RELOAD_B] = ANIM_GUNRELOAD_B
					things[T_WEAP].vars[V_WEAP_RELOAD_E] = ANIM_GUNRELOAD_E
					things[T_WEAP].vars[V_WEAP_RELOAD_T] = ANIM_GUNRELOAD_T
					things[T_WEAP].vars[V_WEAP_MOVE_B] = ANIM_GUNMOVE_B
					things[T_WEAP].vars[V_WEAP_MOVE_E] = ANIM_GUNMOVE_E
					things[T_WEAP].vars[V_WEAP_MOVE_T] = ANIM_GUNMOVE_T
					things[T_WEAP].vars[V_WEAP_ENTER_B] = ANIM_GUNENTER_B
					things[T_WEAP].vars[V_WEAP_ENTER_E] = ANIM_GUNENTER_E
					things[T_WEAP].vars[V_WEAP_ENTER_T] = ANIM_GUNENTER_T
					things[T_WEAP].vars[V_WEAP_LEAVE_B] = ANIM_GUNLEAVE_B
					things[T_WEAP].vars[V_WEAP_LEAVE_E] = ANIM_GUNLEAVE_E
					things[T_WEAP].vars[V_WEAP_LEAVE_T] = ANIM_GUNLEAVE_T
					things[T_WEAP].vars[V_WEAP_AMMOMAX] = 7
					things[T_WEAP].vars[V_WEAP_SPAREAMMO] = things[this].vars[V_INVENTORY_GUN_SPAREAMMO]
					things[T_WEAP].vars[V_WEAP_AMMO] = things[this].vars[V_INVENTORY_GUN_AMMO]
					things[T_WEAP].vars[V_WEAP_SPAREAMMOMAX] = 99
					things[T_WEAP].vars[V_WEAP_SPREAD] = 1
					things[T_WEAP].vars[V_WEAP_BULLETSPEED] = 10
					things[T_WEAP].vars[V_WEAP_BULLETDMG] = 25
					things[T_WEAP].vars[V_WEAP_SHOTSOUND] = SND_SHOT
					things[T_WEAP].vars[V_WEAP_RELOADSOUND] = SND_RELOAD
					things[T_WEAP].vars[V_WEAP_EMPTYSOUND] = SND_DRY
					SetObjectAnimationSpeed(things[T_WEAP].id, 2)
				elseif gunnow = 2
					SpawnThing(things, T_WEAP, CloneTObject(tgame, TMPL_WEAPRIFLE), PROG_WEAP, THING_TYPE_OBJ)
					things[T_WEAP].vars[V_WEAP_XOFFSET] = -0.5	//guncam offset
					things[T_WEAP].vars[V_WEAP_YOFFSET] = 0.6
					things[T_WEAP].vars[V_WEAP_ZOFFSET] = -1.8
					things[T_WEAP].vars[V_WEAP_BXOFFSET] = 0.08 //muzzle fire offset
					things[T_WEAP].vars[V_WEAP_BYOFFSET] = -0.1
					things[T_WEAP].vars[V_WEAP_BZOFFSET] = 1
					things[T_WEAP].vars[V_WEAP_ATTACKTIME] = 100
					things[T_WEAP].vars[V_WEAP_SHOT_B] = ANIM_RIFLESHOT_B
					things[T_WEAP].vars[V_WEAP_SHOT_E] = ANIM_RIFLESHOT_E
					things[T_WEAP].vars[V_WEAP_SHOT_T] = ANIM_RIFLESHOT_T
					things[T_WEAP].vars[V_WEAP_RELOAD_B] = ANIM_RIFLERELOAD_B
					things[T_WEAP].vars[V_WEAP_RELOAD_E] = ANIM_RIFLERELOAD_E
					things[T_WEAP].vars[V_WEAP_RELOAD_T] = ANIM_RIFLERELOAD_T
					things[T_WEAP].vars[V_WEAP_LEAVE_B] = ANIM_RIFLELEAVE_B
					things[T_WEAP].vars[V_WEAP_LEAVE_E] = ANIM_RIFLELEAVE_E
					things[T_WEAP].vars[V_WEAP_LEAVE_T] = ANIM_RIFLELEAVE_T
					things[T_WEAP].vars[V_WEAP_AMMOMAX] = 30
					things[T_WEAP].vars[V_WEAP_SPAREAMMO] = things[this].vars[V_INVENTORY_RIFLE_SPAREAMMO]
					things[T_WEAP].vars[V_WEAP_AMMO] = things[this].vars[V_INVENTORY_RIFLE_AMMO]
					things[T_WEAP].vars[V_WEAP_SPAREAMMOMAX] = 99
					things[T_WEAP].vars[V_WEAP_SPREAD] = 15		
					things[T_WEAP].vars[V_WEAP_BULLETSPEED] = 10
					things[T_WEAP].vars[V_WEAP_BULLETDMG] = 25
					things[T_WEAP].vars[V_WEAP_SHOTSOUND] = SND_SHOT
					things[T_WEAP].vars[V_WEAP_RELOADSOUND] = SND_RELOAD
					things[T_WEAP].vars[V_WEAP_EMPTYSOUND] = SND_DRY
				elseif gunnow = 3
					SpawnThing(things, T_WEAP, CloneTObject(tgame, TMPL_WEAPRPG7), PROG_WEAP, THING_TYPE_OBJ)
					things[T_WEAP].vars[V_WEAP_XOFFSET] = -0.0	//guncam offset
					things[T_WEAP].vars[V_WEAP_YOFFSET] = 0.2
					things[T_WEAP].vars[V_WEAP_ZOFFSET] = -0.15
					things[T_WEAP].vars[V_WEAP_BXOFFSET] = 0 //muzzle fire offset
					things[T_WEAP].vars[V_WEAP_BYOFFSET] = 0
					things[T_WEAP].vars[V_WEAP_BZOFFSET] = 1
					things[T_WEAP].vars[V_WEAP_ATTACKTIME] = 1500
					things[T_WEAP].vars[V_WEAP_AMMOROCKET] = 1
					things[T_WEAP].vars[V_WEAP_SHOT_B] = ANIM_RPG7SHOT_B
					things[T_WEAP].vars[V_WEAP_SHOT_E] = ANIM_RPG7SHOT_E
					things[T_WEAP].vars[V_WEAP_SHOT_T] = ANIM_RPG7SHOT_T
					things[T_WEAP].vars[V_WEAP_SPAREAMMOMAX] = 99
					things[T_WEAP].vars[V_WEAP_AMMOMAX] = 1
					things[T_WEAP].vars[V_WEAP_SPAREAMMO] = things[this].vars[V_INVENTORY_ROCKET_SPAREAMMO]
					things[T_WEAP].vars[V_WEAP_AMMO] = things[this].vars[V_INVENTORY_ROCKET_AMMO]
					things[T_WEAP].vars[V_WEAP_ISROCKETLAUNCHER] = 1
					things[T_WEAP].vars[V_WEAP_BULLETSPEED] = 2
					things[T_WEAP].vars[V_WEAP_SHOTSOUND] = SND_ROCKETSHOT
					things[T_WEAP].vars[V_WEAP_RELOADSOUND] = SND_RELOAD
					things[T_WEAP].vars[V_WEAP_EMPTYSOUND] = SND_DRY
				elseif gunnow = 4
					SpawnThing(things, T_WEAP, CloneTObject(tgame, TMPL_TRIDENT), PROG_WEAP, THING_TYPE_OBJ)
					things[T_WEAP].vars[V_WEAP_XOFFSET] = -1	//guncam offset
					things[T_WEAP].vars[V_WEAP_YOFFSET] = 1.3
					things[T_WEAP].vars[V_WEAP_ZOFFSET] = -0.2
					things[T_WEAP].vars[V_WEAP_BXOFFSET] = 0 //muzzle fire offset
					things[T_WEAP].vars[V_WEAP_BYOFFSET] = 0
					things[T_WEAP].vars[V_WEAP_BZOFFSET] = 1
					things[T_WEAP].vars[V_WEAP_ATTACKTIME] = 600
					things[T_WEAP].vars[V_WEAP_SHOT_B] = ANIM_TRIDENTSHOT_B
					things[T_WEAP].vars[V_WEAP_SHOT_E] = ANIM_TRIDENTSHOT_E
					things[T_WEAP].vars[V_WEAP_SHOT_T] = ANIM_TRIDENTSHOT_T
					things[T_WEAP].vars[V_WEAP_LEAVE_B] = ANIM_TRIDENTLEAVE_T
					things[T_WEAP].vars[V_WEAP_LEAVE_E] = ANIM_TRIDENTLEAVE_T
					things[T_WEAP].vars[V_WEAP_LEAVE_T] = ANIM_TRIDENTLEAVE_T
					things[T_WEAP].vars[V_WEAP_BULLETCASTSIZE] = 0.5
					things[T_WEAP].vars[V_WEAP_BULLETMAXDIST] = 5
					things[T_WEAP].vars[V_WEAP_MELEE] =1
					things[T_WEAP].vars[V_WEAP_BULLETSPEED] = 1
					things[T_WEAP].vars[V_WEAP_BULLETHIDE] = 1
					things[T_WEAP].vars[V_WEAP_BULLETDMG] = 50
					things[T_WEAP].vars[V_WEAP_SHOTSOUND] = SND_SWING
					SetObjectLightMode(things[T_WEAP].id, 0 )
					SetObjectAnimationSpeed(things[T_WEAP].id, 2.5)
				endif
			endif
		endcase
	endselect
endfunction

function ProgKey(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			if things[this].vars[V_KEY_COLOR] = 0	//red
				SetObjectColor(things[this].id, 255, 0, 0, 0)
			elseif things[this].vars[V_KEY_COLOR] = 1  //blue
				SetObjectColor(things[this].id, 0, 0, 255, 0)
			elseif things[this].vars[V_KEY_COLOR] = 2  //yellow
				SetObjectColor(things[this].id, 255, 255, 0, 0)
			endif
			
			SetObjectPosition(things[this].id, things[this].vars[V_KEY_INITX],things[this].vars[V_KEY_INITY],things[this].vars[V_KEY_INITZ])
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			RotateObjectLocalY(things[this].id, 1)
		endcase
		
		case STATE_DEAD
			ClearThing(things, this)
		endcase
	endselect
endfunction

function ProgDoor(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			//SetObjectPosition(things[this].id, things[this].vars[V_DOOR_INITX], things[this].vars[V_DOOR_INITY], things[this].vars[V_DOOR_INITZ])
			//RotateObjectLocalY(things[this].id, things[this].vars[V_DOOR_INITYROT])
			
			If things[this].vars[V_DOOR_REQREDKEY] = 1
				SetObjectColor(things[this].id, 255,0,0,0)
			elseif things[this].vars[V_DOOR_REQBLUKEY] = 1
				SetObjectColor(things[this].id, 0,0,255,0)
			elseif things[this].vars[V_DOOR_REQYELKEY] = 1
				SetObjectColor(things[this].id, 255,255,0,0)
			endif
			
			things[this].vars[V_DOOR_MOVECOUNT] = 0
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_IDLE
			
		endcase
		
		case STATE_CLOSEDOORDOWN
			if tgame.ms > things[this].vars[V_DOOR_NEXTTIME]
				if things[this].vars[V_DOOR_MOVECOUNT] = 0
					PlaySoundDist(things[this].id, SND_DOOROPEN)
				endif
				
				if things[this].vars[V_DOOR_TYPE] = 0
					MoveObjectLocalY(things[this].id, -things[this].vars[V_DOOR_MOVESPEED])
				elseif things[this].vars[V_DOOR_TYPE] = 1
					RotateObjectLocalY(things[this].id, -things[this].vars[V_DOOR_MOVESPEED])
				endif
				
				inc things[this].vars[V_DOOR_MOVECOUNT], 1
				if things[this].vars[V_DOOR_MOVECOUNT] > things[this].vars[V_DOOR_MOVEMAX]
					things[this].vars[V_DOOR_MOVECOUNT] = 0
					things[this].vars[V_DOOR_NEXTTIME] = 0
					
					if things[this].vars[V_DOOR_REQTRIGGER] = 2 : things[this].vars[V_DOOR_REQTRIGGER] = 1 : endif
					
					things[this].state = STATE_IDLE
					//finish door closed
				endif
			endif
		endcase
		
		case STATE_OPENDOORUP
			if things[this].vars[V_DOOR_TYPE] = 0
				MoveObjectLocalY(things[this].id, things[this].vars[V_DOOR_MOVESPEED])
			elseif things[this].vars[V_DOOR_TYPE] = 1
				RotateObjectLocalY(things[this].id, things[this].vars[V_DOOR_MOVESPEED])
			endif
			
			inc things[this].vars[V_DOOR_MOVECOUNT], 1
			if things[this].vars[V_DOOR_MOVECOUNT] > things[this].vars[V_DOOR_MOVEMAX]
				things[this].vars[V_DOOR_NEXTTIME] = tgame.ms + things[this].vars[V_DOOR_WAIT]
				things[this].vars[V_DOOR_MOVECOUNT] = 0
				things[this].state = STATE_CLOSEDOORDOWN
			else
				things[this].state = STATE_OPENDOORUP
			endif
		endcase
		
		case STATE_LOCKED
			ShowMessage(things, 6, POS_TOPCENTER, 1500, 32)
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_OPENDOOR
			unlocked as integer
			disp_unlock_msg as integer
			disp_unlock_msg = 1
			
			if things[T_INVENTORY].used = NO
				things[this].state = STATE_IDLE
				exitfunction
			endif
			
			if things[this].vars[V_DOOR_REQREDKEY] = 0 and things[this].vars[V_DOOR_REQBLUKEY] = 0 and things[this].vars[V_DOOR_REQYELKEY] = 0 and things[this].vars[V_DOOR_REQTRIGGER] = 0
				unlocked = 1
				disp_unlock_msg = 0
			elseif things[this].vars[V_DOOR_REQREDKEY] = 1 and things[T_INVENTORY].vars[V_INVENTORY_HASREDKEY] = 1
				unlocked = 1
			elseif things[this].vars[V_DOOR_REQBLUKEY] = 1 and things[T_INVENTORY].vars[V_INVENTORY_HASBLUKEY] = 1
				unlocked = 1
			elseif things[this].vars[V_DOOR_REQYELKEY] = 1 and things[T_INVENTORY].vars[V_INVENTORY_HASYELKEY] = 1
				unlocked = 1
			elseif things[this].vars[V_DOOR_REQTRIGGER] = 2 //1 if needs trigger and door is closed, 2 if trigger has been activated and door is unlocked
				unlocked = 1
			endif
			
			if unlocked = 0
				things[this].state = STATE_LOCKED
				PlaySoundDist(things[this].id, SND_DOORLOCKED)
				exitfunction
			endif
			
			if disp_unlock_msg =1 
				ShowMessage(things, 7, POS_TOPCENTER, 1500, 32)
			endif
			PlaySoundDist(things[this].id, SND_DOOROPEN)
			things[this].state = STATE_OPENDOORUP
		endcase
	endselect
endfunction

function ProgCamera(tgame ref as Game, things ref as Thing[], this as integer)
	player as ObjInfo
	select things[this].state
		case STATE_INIT
			skybox as integer
			
			SetCameraRange(CAM_MAIN, 0.001,300)
			
			skybox = LoadObject("skybox.dae")
			things[this].vars[V_CAMERA_SKYBOXID] = skybox
			SetObjectImage(skybox, IMG_SKYBOX ,0)
			SetObjectLightMode(skybox, 0)
			SetObjectCollisionMode(skybox, 0)
			SetObjectDepthRange(skybox, 1, 1)
			SetObjectDepthReadMode(skybox, 2)
			
			SetCameraFOV(CAM_MAIN, FOV)
			things[this].state = STATE_FIRSTPERSONMODE
		endcase
		
		case STATE_THIRDPERSONMODE
			if things[T_PLAYER].used = NO : exitfunction : endif
				
			SetObjectVisible(things[T_PLAYER].vars[V_PLAYER_CHARID], 1)
			GetObjectInfo(things[T_PLAYER].id, player)
			
			SetCameraPosition(CAM_MAIN, player.x, player.y, player.z)
			SetCameraRotation(CAM_MAIN, player.xrot, player.yrot, player.zrot)

			//camera position
			MoveCameraLocalZ(CAM_MAIN, -6) //1.5
			MoveCameraLocalY(CAM_MAIN, 4)
			RotateCameraLocalX(CAM_MAIN,12)

			If GetRawKeyReleased(KEY_F1) = 1
				things[this].state = STATE_FIRSTPERSONMODE
			endif
		endcase
		
		
		case STATE_FIRSTPERSONMODE
			if things[T_PLAYER].used = NO : exitfunction : endif
			GetObjectInfo(things[T_PLAYER].id, player)
			
			SetCameraPosition(CAM_MAIN, player.x, player.y, player.z)
			SetCameraRotation(CAM_MAIN, player.xrot, player.yrot, player.zrot)

			//camera position
			//MoveCameraLocalZ(CAM_MAIN, -0.5) //1.5
			MoveCameraLocalY(CAM_MAIN, 2)

			SetObjectPosition(things[this].vars[V_CAMERA_SKYBOXID], GetcameraX(CAM_MAIN), GetcameraY(CAM_MAIN), GetCameraZ(CAM_MAIN))

			//If GetRawKeyReleased(KEY_F1) = 1
			//	things[this].state = STATE_THIRDPERSONMODE
			//endif
		endcase
	endselect
endfunction

function ProgPlayer(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			//SetObjectPosition(things[this].id, 25, -5, 25)
			
			MoveObjectLocalY(things[this].id, 10)
			SetObjectCollisionMode(things[this].id, 1) 		
			SetObjectVisible(things[this].id, 0)				//hide hitbox
			
			//Add joysticks for mobile
			joysize as integer
			offset as integer
			joysize = 180
			offset = 110
			AddVirtualJoystick(JOYL, 0 + offset, tgame.window_height - offset, joysize)
			AddVirtualJoystick(JOYR, tgame.window_width - offset , tgame.window_height - offset, joysize)		
			
			SetVirtualJoystickImageInner(JOYL,IMG_GBUTTON_JOYU)
			SetVirtualJoystickImageOuter(JOYL,IMG_GBUTTON_JOYD)
			SetVirtualJoystickImageInner(JOYR,IMG_GBUTTON_JOYU)
			SetVirtualJoystickImageOuter(JOYR,IMG_GBUTTON_JOYD)
			AddVirtualButton(VBUTTON1, tgame.window_width - offset , tgame.window_height - offset - offset - offset/2, joysize - 20)
			SetVirtualButtonImageUp(VBUTTON1, IMG_GBUTTON_JUMP)
			SetVirtualButtonImageDown(VBUTTON1, IMG_GBUTTON_JOYD)
			AddVirtualButton(VBUTTON2, 0 + offset, tgame.window_height - offset - offset - offset/2, joysize - 20)
			SetVirtualButtonImageUp(VBUTTON2, IMG_GBUTTON_OPEN)
			SetVirtualButtonImageDown(VBUTTON2, IMG_GBUTTON_JOYD)
					
			things[this].vars[V_PLAYER_HP] = 99
			things[this].vars[V_PLAYER_ACCELSTEP] = 0.015
			things[this].vars[V_PLAYER_STRAFEACCELSTEP] = 0.015
			things[this].vars[V_PLAYER_FRICTION] = 0.96
			things[this].vars[V_PLAYER_JUMPINIT] = 1
			things[this].vars[V_PLAYER_DEADMAXMOVE] = 2
			things[this].vars[V_PLAYER_DEADMAXROT] = 50
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_DEADPREPARE
			done1 as integer
			done2 as integer
			
			if things[this].vars[V_PLAYER_DEADMAXMOVE] > 0
				MoveObjectLocalY(things[this].id, -0.1)
				dec things[this].vars[V_PLAYER_DEADMAXMOVE], 0.1
			else
				done1 = 1
			endif
			
			if things[this].vars[V_PLAYER_DEADMAXROT] > 0
				RotateObjectLocalY(things[this].id, -2)
				dec things[this].vars[V_PLAYER_DEADMAXROT], 1
			else
				done2 = 1
			endif
			
			if done1 = 1 and done2 = 1
				things[this].state = STATE_DEAD
				things[this].vars[V_PLAYER_DEADMAXMOVE] = tgame.ms + 1000
				SpawnThing(things, T_HUDCLIPCOUNTER, 0, PROG_COUNTER, THING_TYPE_NONE)
				SetObjectCollisionMode(things[this].id,0)
			endif
		endcase
		
		case STATE_DEAD
			if tgame.ms > things[this].vars[V_PLAYER_DEADMAXMOVE]
				//restart level on death
				tgame.currentslot = tgame.currentslot - 1
				tgame.lives = tgame.lives - 1
				
				if tgame.lives >= 0
					//redo level if still have lives
					tgame.carry_coin = things[T_INVENTORY].vars[V_INVENTORY_COINS]
					ChangeScene(tgame, 4)
				else
					ChangeScene(tgame, 5)
				endif
				
				
				ClearThing(things, this)
			endif
		endcase
		
		case STATE_HIT
			rand as integer
			receive_dmg as integer
			receive_dmg = things[this].vars[V_PLAYER_DMGREC]
			dec things[this].vars[V_PLAYER_HP], receive_dmg
			things[this].vars[V_PLAYER_DMGREC] = 0
			
			//play ugh sound when hit
			rand = Random(0,1)
			if rand = 0 then PlaySound(SND_UGH1)
			if rand = 1 then PlaySound(SND_UGH2)
			
			if things[T_HUDHEALTH].used = YES
				things[T_HUDHEALTH].vars[V_COUNTER_NUMREC] = -receive_dmg
				things[T_HUDHEALTH].state = STATE_UPDATE
			endif
			
			if things[T_HUDDMG].used = YES
				things[T_HUDDMG].state = STATE_EFFECTRED
			endif
			
			if things[this].vars[V_PLAYER_HP] <= 0
				if things[T_HUDDMG].used = YES
					things[T_HUDDMG].state = STATE_EFFECTREDSTAY //make screen turn red
				endif
				
				if things[T_WEAP].used = YES	//put away weap
					things[T_WEAP].state = STATE_DEAD
				endif
				
				//kill inventory
				If things[T_INVENTORY].used = YES
					things[T_INVENTORY].state = STATE_DEAD
				endif
				
				//show you died msg
				ShowMessage(things, 0, POS_CENTER, 3000, 64)
				
				//play death sound
				PlaySound(SND_DIE)
				
				things[this].state = STATE_DEADPREPARE
			else
				things[this].state = STATE_MAIN
			endif
		endcase
		
		case STATE_MAIN
			player_old as ObjInfo
			player_new as ObjInfo
			action_activate as integer
			object_hit as integer
			hits as integer
			index as integer
			slope as integer
			steepslope as integer
			ground as integer
			wall as integer
			founddoor as integer
			foundtrigger as integer
			resetjump as integer
			sc_size as integer
			turn as integer
			falling as integer
			moved as integer
			joyl_x as float
			joyl_y as float
			joyr_x as float
			joyr_y as float
			pressjump as integer
			
			sc_size = 2
			
			joyl_x = GetVirtualJoystickX(JOYL)
			joyl_y = GetVirtualJoystickY(JOYL)
			joyr_x = GetVirtualJoystickX(JOYR)
			joyr_y = GetVirtualJoystickX(JOYR)
			
			//print(things[this].vars[V_PLAYER_HP])
			
			GetObjectInfo(things[this].id, player_old)
			
			things[this].vars[V_PLAYER_ACCEL] = 0
			things[this].vars[V_PLAYER_STRAFEACCEL] = 0
			things[this].vars[V_PLAYER_MOVED] = 0
			
			If GetRawKeyState(KEY_W) = 1  or joyl_y < 0
				if joyl_y <> 0
					things[this].vars[V_PLAYER_ACCEL] = joyl_y * 0.016 * -1
				else
					things[this].vars[V_PLAYER_ACCEL] =  things[this].vars[V_PLAYER_ACCELSTEP]
				endif
				moved=1
			elseif GetRawKeyState(KEY_S) = 1 or joyl_y > 0
				if joyl_y <> 0
					things[this].vars[V_PLAYER_ACCEL] = joyl_y * 0.016
				else
					things[this].vars[V_PLAYER_ACCEL] =  things[this].vars[V_PLAYER_ACCELSTEP]
				endif
				things[this].vars[V_PLAYER_ACCEL] =  - things[this].vars[V_PLAYER_ACCELSTEP]
				moved=1
			endif
			
			
			if GetRawKeyState(KEY_A) = 1 or joyr_x < 0
				if joyr_x <> 0
					things[this].vars[V_PLAYER_STRAFEACCEL] = joyr_x * 0.016
				else
					things[this].vars[V_PLAYER_STRAFEACCEL] =  - things[this].vars[V_PLAYER_STRAFEACCELSTEP]
				endif
				moved=1
			elseif GetRawKeyState(KEY_D) = 1 or joyr_x > 0
				if joyr_x <> 0
					things[this].vars[V_PLAYER_STRAFEACCEL] = joyr_x * 0.016 
				else
					things[this].vars[V_PLAYER_STRAFEACCEL] =  things[this].vars[V_PLAYER_STRAFEACCELSTEP]
				endif
				moved=1
			endif
			
			things[this].vars[V_PLAYER_MOVED] = moved
			
			if GetRawKeyState(KEY_J) = 1
				RotateObjectLocalY(things[this].id, -2.8)
				turn = -1
			elseif GetRawKeyState(KEY_K) = 1
				RotateObjectLocalY(things[this].id, 2.8)
				turn = 1
			endif
			RotateObjectLocalY(things[this].id, joyl_x * 2)
			
			
			If GetRawKeyPressed(KEY_SPACE) = 1 and things[this].vars[V_PLAYER_JUMPING] = 0 and things[this].vars[V_PLAYER_FALLING] = 0
				pressjump = 1
			elseif GetVirtualButtonPressed(VBUTTON1) = 1 and things[this].vars[V_PLAYER_JUMPING] = 0 and things[this].vars[V_PLAYER_FALLING] = 0
				pressjump = 1
			endif
			
			If pressjump = 1
				PlaySound(SND_JUMP)
				things[this].vars[V_PLAYER_JUMPSPEED] = things[this].vars[V_PLAYER_JUMPINIT]
				things[this].vars[V_PLAYER_JUMPING] = 1
			endif
			
			If GetRawKeyPressed(KEY_E) = 1 or GetVirtualButtonPressed(VBUTTON2) = 1
				action_activate = 1
			endif
			
			if things[this].vars[V_PLAYER_FALLING] = 1
				things[this].vars[V_PLAYER_JUMPSPEED] = things[this].vars[V_PLAYER_JUMPSPEED] - 0.03
			elseif things[this].vars[V_PLAYER_JUMPING] = 1
				things[this].vars[V_PLAYER_JUMPSPEED] = things[this].vars[V_PLAYER_JUMPSPEED] - 0.03
				if things[this].vars[V_PLAYER_JUMPSPEED] < 0
					things[this].vars[V_PLAYER_JUMPSPEED] = 0
					things[this].vars[V_PLAYER_FALLING] = 1
				endif
			endif
			
			things[this].vars[V_PLAYER_SPEED] =  things[this].vars[V_PLAYER_SPEED] + things[this].vars[V_PLAYER_ACCEL]
			things[this].vars[V_PLAYER_SPEED] = things[this].vars[V_PLAYER_SPEED] * things[this].vars[V_PLAYER_FRICTION] //friction
			
			things[this].vars[V_PLAYER_STRAFESPEED] =  things[this].vars[V_PLAYER_STRAFESPEED] + things[this].vars[V_PLAYER_STRAFEACCEL]
			things[this].vars[V_PLAYER_STRAFESPEED] = things[this].vars[V_PLAYER_STRAFESPEED] * things[this].vars[V_PLAYER_FRICTION] //friction
			
			MoveObjectLocalZ(things[this].id, things[this].vars[V_PLAYER_SPEED])
			MoveObjectLocalX(things[this].id, things[this].vars[V_PLAYER_STRAFESPEED])
			MoveObjectLocalY(things[this].id,-0.2 + things[this].vars[V_PLAYER_JUMPSPEED])
			
			/*If turn = 1
				RotateObjectLocalY(things[this].id, Abs(things[this].vars[V_PLAYER_SPEED]) * 12)
			elseif turn = -1
				RotateObjectLocalY(things[this].id, (Abs(things[this].vars[V_PLAYER_SPEED]) * 12) * -1)
			endif
			*/
			//print(things[this].vars[V_PLAYER_SPEED])
			//print(things[this].vars[V_PLAYER_ACCEL])
			
			GetObjectInfo(things[this].id, player_new)

			//play walk sound
			if (things[this].vars[V_PLAYER_SPEED] <= -0.05 or things[this].vars[V_PLAYER_SPEED] >= 0.05) and things[this].vars[V_PLAYER_JUMPING] = 0 and things[this].vars[V_PLAYER_FALLING] = 0
				if tgame.ms > things[this].vars[V_PLAYER_WALKSNDNEXTT] 
					if things[this].vars[V_PLAYER_WALKSNDNUM] = 1
						things[this].vars[V_PLAYER_WALKSNDNUM] = 0
						PlaySound(SND_WALK1)
					elseif things[this].vars[V_PLAYER_WALKSNDNUM] = 0
						things[this].vars[V_PLAYER_WALKSNDNUM] = 1
						PlaySound(SND_WALK2)
					endif
					things[this].vars[V_PLAYER_WALKSNDNEXTT] = tgame.ms + 300
				endif
			endif

			if player_new.y < -10
				things[this].state = STATE_HIT
				things[this].vars[V_PLAYER_DMGREC] = 11
			endif

			if action_activate = 1
				//TRIGGER HANDLER
				Handler(things, player_old, player_new, sc_size, T_TRIGGERSTART, T_TRIGGEREND, STATE_IDLE, STATE_TRIGGER)
				//DOOR HANDLER
				Handler(things, player_old, player_new, sc_size, T_DOORSTART, T_DOOREND, STATE_IDLE, STATE_OPENDOOR)
			endif
			
			SetObjectCollisionMode(things[this].id, 0)	//prevent from hitting self 
			
			//handler for items
			Handler(things, player_old, player_new, sc_size, T_ITEMSSTART, T_ITEMEND, STATE_MAIN, STATE_DEAD)
			
			object_hit = ObjectSphereSlide(0,player_old.x, player_old.y, player_old.z, player_new.x, player_new.y, player_new.z, 1)
			if object_hit <> 0
				hits = GetObjectRayCastNumHits()
				yn as integer
				hitangle as float
				for index = 0 to hits
					hitangle = Acos(GetObjectRayCastNormalY(index))					
					
					If hitangle >= 88.0 and hitangle <= 92		//if hits vertical wall
						wall = 1
					elseif hitangle >= 56 and hitangle <= 87
						steepslope = 1
					elseif hitangle >= 1 and hitangle <= 55
						slope = 1
						resetjump = 1
					elseif hitangle = 0
						ground = 1
						resetjump = 1	
					elseif hitangle >= 140 and hitangle <= 220 //hit top
						ground = 1
						resetjump = 1
					endif
					
					if slope = 1
						SetObjectPosition(things[this].id, player_new.x, GetObjectRayCastSlideY(index), player_new.z )	//slide vertically only
					endif
					
					if steepslope = 1
						SetObjectPosition(things[this].id, GetObjectRayCastSlideX(index), GetObjectRayCastSlideY(index), GetObjectRayCastSlideZ(index) )
					endif
					
					if ground = 1
						SetObjectPosition(things[this].id, GetObjectRayCastSlideX(index), GetObjectRayCastSlideY(index), GetObjectRayCastSlideZ(index) )
					endif
					
					if wall = 1
						SetObjectPosition(things[this].id, GetObjectRayCastSlideX(index), GetObjectRayCastSlideY(index), GetObjectRayCastSlideZ(index) )
					endif
					
					if resetjump = 1
						if things[this].vars[V_PLAYER_JUMPING] <> 0
							PlaySound(SND_LAND) 
						endif
						things[this].vars[V_PLAYER_FALLING] = 0
						things[this].vars[V_PLAYER_JUMPING] = 0
						things[this].vars[V_PLAYER_JUMPSPEED] = 0
					endif
				next
			else
				things[this].vars[V_PLAYER_FALLING] = 1
			endif
			SetObjectCollisionMode(things[this].id, 1) 
			
			/*
			//------------character animation----------
			animspeed as float
			tweentime as float
			p as ObjInfo
			GetObjectInfo(things[this].id, p)
			tweentime = 0.2
			
			if things[this].vars[V_PLAYER_JUMPSPEED] <= -0.01	//if character is falling really fast switch to falling pose
				if things[this].vars[V_PLAYER_FALLANIM] = 0
					things[this].vars[V_PLAYER_FALLANIM] = 1
					things[this].vars[V_PLAYER_JUMPANIM] = 0
					things[this].vars[V_PLAYER_IDLEANIM] = 0
					things[this].vars[V_PLAYER_RUNANIM] = 0
					things[this].vars[V_PLAYER_ACTIONANIM] = 0
					SetObjectAnimationSpeed(things[this].vars[V_PLAYER_CHARID], 1)
					PlayObjectAnimation(things[this].vars[V_PLAYER_CHARID], "", ANIM_FALL_B, ANIM_FALL_E, 0, tweentime)
				endif
			elseif things[this].vars[V_PLAYER_JUMPING] = 1	//if character is jumping switch to jump animation
				if things[this].vars[V_PLAYER_JUMPANIM] = 0
					things[this].vars[V_PLAYER_FALLANIM] = 0
					things[this].vars[V_PLAYER_JUMPANIM] = 1
					things[this].vars[V_PLAYER_IDLEANIM] = 0
					things[this].vars[V_PLAYER_RUNANIM] = 0
					things[this].vars[V_PLAYER_ACTIONANIM] = 0
					SetObjectAnimationSpeed(things[this].vars[V_PLAYER_CHARID], 2)
					PlayObjectAnimation(things[this].vars[V_PLAYER_CHARID], "", ANIM_JUMP_B, ANIM_JUMP_E, 0, 0)
				endif
			elseif action_activate = 1	//kick off the action animation
				if things[this].vars[V_PLAYER_ACTIONANIM] = 0
					things[this].vars[V_PLAYER_FALLANIM] = 0
					things[this].vars[V_PLAYER_JUMPANIM] = 0
					things[this].vars[V_PLAYER_IDLEANIM] = 0
					things[this].vars[V_PLAYER_RUNANIM] = 0
					things[this].vars[V_PLAYER_ACTIONANIM] = 1
					SetObjectAnimationSpeed(things[this].vars[V_PLAYER_CHARID], 2)
					PlayObjectAnimation(things[this].vars[V_PLAYER_CHARID], "", ANIM_ACTION_B, ANIM_ACTION_E, 0, tweentime)
				endif
			else				//else either do idle animation or running animation
				if things[this].vars[V_PLAYER_ACTIONANIM] = 1	//continue playing the action animation if its still playing...
					if GetObjectIsAnimating(things[this].vars[V_PLAYER_CHARID]) = 0
						things[this].vars[V_PLAYER_ACTIONANIM] = 0
					endif
				elseif things[this].vars[V_PLAYER_SPEED] >= -0.01 and things[this].vars[V_PLAYER_SPEED] <= 0.01  and  things[this].vars[V_PLAYER_IDLEANIM] = 0
				
					things[this].vars[V_PLAYER_FALLANIM] = 0
					things[this].vars[V_PLAYER_JUMPANIM] = 0
					things[this].vars[V_PLAYER_IDLEANIM] = 1
					things[this].vars[V_PLAYER_RUNANIM] = 0
					things[this].vars[V_PLAYER_ACTIONANIM] = 0
					SetObjectAnimationSpeed(things[this].vars[V_PLAYER_CHARID], 1)
					PlayObjectAnimation(things[this].vars[V_PLAYER_CHARID], "", ANIM_IDLE_B, ANIM_IDLE_E, 1, tweentime)

					//PlayObjectAnimation(things[this].vars[V_PLAYER_CHARID], "", ANIM_ACTION_B, ANIM_ACTION_E, 1, tweentime)
				elseif (things[this].vars[V_PLAYER_SPEED] > 0.01 and things[this].vars[V_PLAYER_RUNANIM] = 0) or (things[this].vars[V_PLAYER_SPEED] < -0.01 and things[this].vars[V_PLAYER_RUNANIM] = 0)
					things[this].vars[V_PLAYER_FALLANIM] = 0
					things[this].vars[V_PLAYER_JUMPANIM] = 0
					things[this].vars[V_PLAYER_IDLEANIM] = 0
					things[this].vars[V_PLAYER_RUNANIM] = 1
					things[this].vars[V_PLAYER_ACTIONANIM] = 0
					SetObjectAnimationSpeed(things[this].vars[V_PLAYER_CHARID], things[this].vars[V_PLAYER_SPEED] * 30)
					PlayObjectAnimation(things[this].vars[V_PLAYER_CHARID], "", ANIM_RUN_B, ANIM_RUN_E, 0, tweentime)
				endif
				
				//loop the run animation and change animation speed depending on character speed
				if things[this].vars[V_PLAYER_RUNANIM] = 1
					animspeed = things[this].vars[V_PLAYER_SPEED] * 30
					if animspeed < 0
						animspeed = Abs(animspeed)
					endif
					SetObjectAnimationSpeed(things[this].vars[V_PLAYER_CHARID], animspeed)
					If GetObjectIsAnimating(things[this].vars[V_PLAYER_CHARID]) = 0
						PlayObjectAnimation(things[this].vars[V_PLAYER_CHARID], "", ANIM_RUN_B, ANIM_RUN_E, 0, 0)
					endif
				endif
			endif
			
			//make character model follow the box
			SetObjectPosition(things[this].vars[V_PLAYER_CHARID], p.x, p.y-1,p.z)
			SetObjectRotation(things[this].vars[V_PLAYER_CHARID], p.xrot, p.yrot+180, p.zrot)
			*/
		endcase
	endselect
endfunction

function ProgCar(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			MoveObjectLocalY(things[this].id, 10)
			SetObjectCollisionMode(things[this].id, 0) 		//prevent hitting self
			things[this].vars[V_PLAYER_ACCELSTEP] = 0.01
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			player_old as ObjInfo
			player_new as ObjInfo
			steer as integer
			GetObjectInfo(things[this].id, player_old)
			
			If GetRawKeyState(KEY_W) = 1
				things[this].vars[V_PLAYER_ACCEL] =  things[this].vars[V_PLAYER_ACCELSTEP]
			elseif GetRawKeyState(KEY_S) = 1
				things[this].vars[V_PLAYER_ACCEL] =  - things[this].vars[V_PLAYER_ACCELSTEP]
			else
				things[this].vars[V_PLAYER_ACCEL] = 0
			endif
			
			If GetRawKeyState(KEY_A) = 1
				steer = -1
				//RotateObjectLocalY(things[this].id, -1)
			elseif GetRawKeyState(KEY_D) = 1
				steer = 1
				//RotateObjectLocalY(things[this].id, 1)
			endif
			
			things[this].vars[V_PLAYER_SPEED] =  things[this].vars[V_PLAYER_SPEED] + things[this].vars[V_PLAYER_ACCEL]
			
			things[this].vars[V_PLAYER_SPEED] = things[this].vars[V_PLAYER_SPEED] * 0.997 //friction
			
			
			MoveObjectLocalZ(things[this].id, things[this].vars[V_PLAYER_SPEED])
				
			if things[this].vars[V_PLAYER_SPEED] > 0.5
				if steer = -1	
					RotateObjectLocalY(things[this].id, -0.5)
				elseif steer = 1
					RotateObjectLocalY(things[this].id, 0.5)
				endif
			else
				if steer = -1	
					RotateObjectLocalY(things[this].id, -things[this].vars[V_PLAYER_SPEED])
				elseif steer = 1
					RotateObjectLocalY(things[this].id, things[this].vars[V_PLAYER_SPEED])
				endif
			endif
			
			MoveObjectLocalY(things[this].id, -0.5)		//gravity
			print(things[this].vars[V_PLAYER_SPEED])
			print(things[this].vars[V_PLAYER_ACCEL])
			
			object_hit as integer
			hits as integer
			hitstotal as integer
			index as integer
			GetObjectInfo(things[this].id, player_new)
			object_hit = ObjectSphereSlide(0,player_old.x, player_old.y, player_old.z, player_new.x, player_new.y, player_new.z, 0.5)
			if object_hit <> 0
				SetObjectPosition(things[this].id, GetObjectRayCastSlideX(0), 	GetObjectRayCastSlideY(0), GetObjectRayCastSlideZ(0) )
				hits =GetObjectRayCastNumHits()
				yn as integer
				for index = 0 to hitstotal
					
					yn = GetObjectRayCastNormalY( index)
					If yn = 0		//if hits vertical wall
						things[this].vars[V_PLAYER_SPEED] = things[this].vars[V_PLAYER_SPEED] * 0.60
					endif
					
					
					
					Print(GetObjectRayCastNormalX( index ))
					
					Print(GetObjectRayCastNormalY( index ))
					
					Print(GetObjectRayCastNormalZ( index ))
					//if GetObjectRayCastHitID( index ) <> things[T_LEVELGEO].vars[V_LEVELGEO_PLANE]
					//	//things[this].vars[V_PLAYER_SPEED] = 0
					//	things[this].vars[V_PLAYER_SPEED] = things[this].vars[V_PLAYER_SPEED] * 0.90
					//endif
				next
			endif
			
			
		endcase
	endselect
endfunction

function CameraControl(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT	
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			rotspeed as float
			movspeed as float
			msg_filewrite as string
			movspeed = 0.8
			rotspeed = 2
			
			startx as float
			starty as float
			fDiffY as float
			fDiffX as float
			angx as float
			angy as float
			pressed as integer
			newX as float
			
			if ( GetPointerPressed() )
				startx = GetPointerX()
				starty = GetPointerY()
				angx = GetCameraAngleX(CAM_MAIN)
				angy = GetCameraAngleY(CAM_MAIN)
				pressed = 1
			endif
			
			if ( GetPointerState() = 1 )
				fDiffX = (GetPointerX() - startx)/1.0
				fDiffY = (GetPointerY() - starty)/1.0
				newX = angx + fDiffY
				if ( newX > 89 ) then newX = 89
				if ( newX < -89 ) then newX = -89
				SetCameraRotation( CAM_MAIN, newX, angy + fDiffX, 0)
			endif
			
			//rem Gravity on camera
			SetCameraPosition(CAM_MAIN,getcamerax(CAM_MAIN),getcameray(CAM_MAIN),getcameraz(CAM_MAIN))
			
			if ( GetRawKeyState( 87 ) ) then MoveCameraLocalZ( 1, movspeed )
			if ( GetRawKeyState( 83 ) ) then MoveCameraLocalZ( 1, -movspeed )
			if ( GetRawKeyState( 65 ) ) then MoveCameraLocalX( 1, -movspeed )
			if ( GetRawKeyState( 68 ) ) then MoveCameraLocalX( 1, movspeed )
			if ( GetRawKeyState( 90 ) ) then MoveCameraLocalY( 1, -movspeed) //move down
			if ( GetRawKeyState( 88 ) ) then MoveCameraLocalY( 1, movspeed)	//move up
			
			if ( GetRawKeyState( 38 ) ) then RotateCameraLocalX(1, -rotspeed) //up
			if ( GetRawKeyState( 40 ) ) then RotateCameraLocalX(1, rotspeed) //down
			if ( GetRawKeyState( 37 ) ) then RotateCameraLocalY(1, -rotspeed) //left
			if ( GetRawKeyState( 39 ) ) then RotateCameraLocalY(1, rotspeed) //right
			
			


			
			
			
			if ( GetRawKeyState( 77 ) ) //M to change mode
				
			elseif ( GetRawKeyState( 82 ) ) //R to Reset camera
				SetCameraPosition(1, 0, 0 ,0)
				SetCameraRotation(1, 0, 0, 0)
			elseif ( GetRawKeyState( 79 ) ) //O to location and rotation to clipboard
				OpenToWrite(1,"cameralr.txt")
				WriteLine(1, "X:"+ STR(GetCameraX(1)))
				WriteLine(1, "Y:"+ STR(getCameraY(1)))
				WriteLine(1, "Z:"+ STR(GetCameraZ(1)))
				WriteLine(1, "ANGLEX:" + STR(GetCameraAngleX(1)))
				WriteLine(1, "ANGLEY:" + STR(GetCameraAngleY(1)))
				WriteLine(1, "ANGLEZ:" + STR(GetCameraAngleZ(1)))
				CloseFile(1)
				msg_filewrite = "File Written to " + GetWritePath()
				// /Users/mack/Library/Containers/com.thegamecreators.AGKTestAppMacOS/Data/Library/Application Support/AGK Player/media
			endif
			
			Print("X:"+ STR(GetCameraX(1)))
			Print("Y:"+ STR(getCameraY(1)))
			Print("Z:"+ STR(GetCameraZ(1)))
			Print("ANGLEX:"+ STR(GetCameraAngleX(1)))
			Print("ANGLEY:"+ STR(GetCameraAngleY(1)))
			Print("ANGLEZ:"+ STR(GetCameraAngleZ(1)))
			Print(msg_filewrite)
			//http://www.appgamekit.com/documentation/guides/scancodes.htm
			//render and game screen focal length and ratio needs to match 35
		endcase
	endselect
endfunction

function AnimController(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT	
			things[this].vars[V_ANIMC_STARTTIME] = 0
			things[this].vars[V_ANIMC_ENDTIME] = -1
			things[this].vars[V_ANIMC_TTIME] = 0
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			rotspeed as float
			movspeed as float
			movspeed = 0.1
			rotspeed = 0.5

			if ( GetRawKeyState( 87 ) ) then MoveCameraLocalZ( 1, movspeed )
			if ( GetRawKeyState( 83 ) ) then MoveCameraLocalZ( 1, -movspeed )
			if ( GetRawKeyState( 65 ) ) then MoveCameraLocalX( 1, -movspeed )
			if ( GetRawKeyState( 68 ) ) then MoveCameraLocalX( 1, movspeed )
			if ( GetRawKeyState( 90 ) ) then MoveCameraLocalY( 1, -movspeed) //move down
			if ( GetRawKeyState( 88 ) ) then MoveCameraLocalY( 1, movspeed)	//move up

			//look
			if ( GetRawKeyState( KEY_I ) ) then RotateCameraLocalX(1, -rotspeed) //up
			if ( GetRawKeyState( KEY_K ) ) then RotateCameraLocalX(1, rotspeed) //down
			if ( GetRawKeyState( KEY_J ) ) then RotateCameraLocalY(1, -rotspeed) //left
			if ( GetRawKeyState( KEY_L ) ) then RotateCameraLocalY(1, rotspeed) //right

			if (GetRawKeyState( KEY_Q)) then dec things[this].vars[V_ANIMC_STARTTIME], 0.01
			if (GetRawKeyState( KEY_E)) then inc things[this].vars[V_ANIMC_STARTTIME], 0.01

			if (GetRawKeyState( KEY_O)) then dec things[this].vars[V_ANIMC_ENDTIME], 0.01
			if (GetRawKeyState( KEY_P)) then inc things[this].vars[V_ANIMC_ENDTIME], 0.01
			
			If (GetRawKeyState( KEY_N)) then dec things[this].vars[V_ANIMC_TTIME], 0.01
			If (GetRawKeyState( KEY_M)) then inc things[this].vars[V_ANIMC_TTIME], 0.01

			if ( GetRawKeyState( 82 ) ) //R to Reset camera
				SetCameraPosition(1, 0, 0 ,0)
				SetCameraRotation(1, 0, 0, 0)
			endif

			if GetObjectIsAnimating(things[this].id) = 0
				PlayObjectAnimation(things[this].id, "", things[this].vars[V_ANIMC_STARTTIME], things[this].vars[V_ANIMC_ENDTIME], 0, things[this].vars[V_ANIMC_TTIME])
			endif

			Print("X:"+ STR(GetCameraX(1)))
			Print("Y:"+ STR(getCameraY(1)))
			Print("Z:"+ STR(GetCameraZ(1)))
			Print("ANGLEX:"+ STR(GetCameraAngleX(1)))
			Print("ANGLEY:"+ STR(GetCameraAngleY(1)))
			Print("ANGLEZ:"+ STR(GetCameraAngleZ(1)))
			Print("ANIM START:" + STR(things[this].vars[V_ANIMC_STARTTIME]))
			Print("ANIM END:" + STR(things[this].vars[V_ANIMC_ENDTIME]))
			Print("TRANSITION:" + STR(things[this].vars[V_ANIMC_TTIME]))
			
			/*l
			bone as integer
			bone = GetObjectBoneByName(things[this].id, "LARMUP")
			SetObjectBoneCanAnimate( things[this].id, bone, 0 )
			RotateObjectBoneLocalX(things[this].id, bone, 1)
			*/
		endcase
	endselect
endfunction
