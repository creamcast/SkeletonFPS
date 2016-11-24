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
global global_mapL0 as integer[0] //layer0
global global_mapL1 as integer[0] //layer1
global global_mapL2 as integer[0] //layer2
global global_currentobj as integer[] //objects in map
//global global_current_save_slot as integer

function TemplateController2(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			
		endcase
	endselect
endfunction

function ProgMapSetup(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			pos as Coord2D
			txtsize as integer
			edit1 as integer
			edit2 as integer
			txt0 as integer
			txt1 as integer
			txt2 as integer
			txt0 = CreateText("MAP SETUP")
			txt1 = CreateText("SLOT:")
			txt2 = CreateText("SIZE:")
			edit1 = CreateEditBox()
			edit2 = CreateEditBox()
			things[this].vars[V_MAPSETUP_TXT0] = txt0 
			things[this].vars[V_MAPSETUP_TXT1] = txt1
			things[this].vars[V_MAPSETUP_TXT2] = txt2
			things[this].vars[V_MAPSETUP_EDIT1] = edit1
			things[this].vars[V_MAPSETUP_EDIT2] = edit2
			
			txtsize = 32
			
			SetTextFontImage(txt0, IMG_MAINFONT)
			SetTextSize(txt0, txtsize) 
			GetHudPos(tgame, GetTextTotalWidth(txt0), GetTextTotalHeight(txt0), POS_TOPLEFT, pos)
			SetTextPosition(txt0, pos.x, pos.y)
			
			SetTextFontImage(txt1, IMG_MAINFONT)
			SetTextSize(txt1, txtsize) 
			GetHudPos(tgame, GetTextTotalWidth(txt1), GetTextTotalHeight(txt2), POS_CENTERLEFT, pos)
			SetTextPosition(txt1, pos.x, pos.y)
			
			GetHudPos(tgame, GetEditBoxWidth(edit1), GetEditBoxHeight(edit1), POS_CENTER, pos)
			SetEditBoxPosition(edit1, pos.x, pos.y)
			SetEditBoxText(edit1, "0")
			
			SetTextFontImage(txt2, IMG_MAINFONT)
			SetTextSize(txt2, txtsize)
			GetHudPos(tgame, GetTextTotalWidth(txt2), GetTextTotalHeight(txt2), POS_BOTTOMLEFT, pos)
			SetTextPosition(txt2, pos.x, pos.y)
			
			GetHudPos(tgame, GetEditBoxWidth(edit2), GetEditBoxHeight(edit2), POS_BOTTOMCENTER, pos)
			SetEditBoxPosition(edit2, pos.x, pos.y)
			SetEditBoxText(edit2, "10")
			
			AddVirtualButton(VBUTTON1, tgame.window_width - 64, tgame.window_height - 64, 64)
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			If GetVirtualButtonPressed(VBUTTON1) = 1
				slot as integer
				size as integer
				slot = Val(GetEditBoxText(things[this].vars[V_MAPSETUP_EDIT1]))
				size = Val(GetEditBoxText(things[this].vars[V_MAPSETUP_EDIT2]))
				tgame.currentslot = slot
				tgame.mapsize = size
				things[this].state = STATE_DEAD
			endif
		endcase
		
		case STATE_DEAD
			ChangeScene(tgame, 3)
			DeleteText(things[this].vars[V_MAPSETUP_TXT2])
			DeleteText(things[this].vars[V_MAPSETUP_TXT1])
			DeleteText(things[this].vars[V_MAPSETUP_TXT0])
			DeleteEditBox(things[this].vars[V_MAPSETUP_EDIT1])
			DeleteEditBox(things[this].vars[V_MAPSETUP_EDIT2])
		endcase
	endselect
endfunction

function ProgChooseBox(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_IDLE
			
		endcase
		
		case STATE_MAIN
			msg as string
			textid as integer
			pos as Coord2D
			btnsize as integer
			
			things[this].vars[V_CHOOSEBOX_LASTRESULT] = 0
			
			if things[this].vars[V_CHOOSEBOX_MSGSLOT] = 0 then msg = "Overwrite map in Slot " + str(tgame.currentslot) + CHR(13) + Chr(10) + "and save the current map?"
			if things[this].vars[V_CHOOSEBOX_TXTID] <> 0 then DeleteText(things[this].vars[V_CHOOSEBOX_TXTID])			
			
			//create text prompt
			things[this].vars[V_CHOOSEBOX_TXTID] = CreateText(msg)
			textid = things[this].vars[V_CHOOSEBOX_TXTID]
			SetTextFontImage(textid, IMG_MAINFONT)	
			SetTextSize(textid, 32)	
			GetHudPos(tgame, GetTextTotalWidth(textid), GetTextTotalHeight(textid), POS_CENTER, pos)
			SetTextPosition(textid, pos.x, pos.y - 64)

			//create yes and no buttons
			btnsize = 96
			
			AddVirtualButton(VBUTTON8, tgame.window_width/2 - btnsize, pos.y + btnsize + (btnsize/2)-64, btnsize)
			AddVirtualButton(VBUTTON9, tgame.window_width/2 + btnsize, pos.y + btnsize + (btnsize/2)-64, btnsize)
			SetVirtualButtonImageUp(VBUTTON8, IMG_DIALOGBTNYES)
			SetVirtualButtonImageDown(VBUTTON8, IMG_DIALOGBTNYES)
			SetVirtualButtonImageUp(VBUTTON9, IMG_DIALOGBTNNO)
			SetVirtualButtonImageDown(VBUTTON9, IMG_DIALOGBTNNO)	
			SetVirtualButtonAlpha(VBUTTON8, 255)
			SetVirtualButtonAlpha(VBUTTON9, 255)		

			//create BG
			things[this].vars[V_CHOOSEBOX_BGSPRITEID] = CreateSprite(IMG_GCOLORBLUE)
			SetSpriteSize(things[this].vars[V_CHOOSEBOX_BGSPRITEID], tgame.window_width, tgame.window_height/2)
			SetSpritePosition(things[this].vars[V_CHOOSEBOX_BGSPRITEID], 0, pos.y - pos.y/2)

			things[this].state = STATE_CHOOSE
		endcase
		
		case STATE_CHOOSE
			userinput as integer
			userinput = 0
			If GetVirtualButtonPressed(VBUTTON8) = 1 //yes
				userinput = 1
				things[this].vars[V_CHOOSEBOX_LASTRESULT] = 1
			elseif GetVirtualButtonPressed(VBUTTON9) = 1 //no
				userinput = 1
				things[this].vars[V_CHOOSEBOX_LASTRESULT] = 2
			endif
			
			if userinput = 1
				things[this].state = STATE_IDLE
				DeleteText(things[this].vars[V_CHOOSEBOX_TXTID])
				DeleteSprite(things[this].vars[V_CHOOSEBOX_BGSPRITEID])
				DeleteVirtualButton(VBUTTON9)
				DeleteVirtualButton(VBUTTON8)
			endif
		endcase
	endselect
endfunction

function ProgExportMap(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			//***************************CHOOSE SAVESLOT HERE***************************
			things[this].vars[V_EXPORT_SAVESLOT] = tgame.currentslot
			//-----------------------
			AddVirtualButton(VBUTTON4, tgame.window_width - 128/2, 128/2, 128)
			SetVirtualButtonImageUp(VBUTTON4, IMG_MEBTNEXPORTUP)
			SetVirtualButtonImageDown(VBUTTON4, IMG_MEBTNEXPORTDN)
			SetVirtualButtonAlpha(VBUTTON4, 255)
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			If GetVirtualButtonPressed(VBUTTON4)
				things[this].state = STATE_SAVE
			endif
		endcase
		
		case STATE_SAVE
			if things[T_CHOOSEBOX].used = YES
				things[T_CHOOSEBOX].state = STATE_MAIN	//show dialog
			endif
			things[this].state = STATE_WAIT
		endcase
		
		case STATE_WAIT
			If things[T_CHOOSEBOX].used = YES
				if things[T_CHOOSEBOX].vars[V_CHOOSEBOX_LASTRESULT] <> 0
					if things[T_CHOOSEBOX].vars[V_CHOOSEBOX_LASTRESULT] = 1 //yes
						things[this].state = STATE_EXPORT
					elseif things[T_CHOOSEBOX].vars[V_CHOOSEBOX_LASTRESULT] = 2 //no
						things[this].state = STATE_MAIN
					endif
				endif
			endif
		endcase
		
		case STATE_EXPORT
			filename as string
			file as integer
			layernow as integer
			nowx as integer
			nowy as integer
			count as integer
			linesize as integer
			max as integer
			slot as integer
			i as integer
			currentobj as integer
			
			if things[T_MAP].used = YES
				linesize = things[T_MAP].vars[V_MAP_MAPSIZE]
			endif
				
			slot = things[this].vars[V_EXPORT_SAVESLOT]
			filename = "slot" + Str(slot) + ".txt"
			file = OpenToWrite(filename,0)
			
			if file <> 0
				WriteLine(file, STR(linesize))
				WriteLine(file, MAPFILE_NEWLAYER)
				for i = 0 to global_mapL0.length - 1
					WriteLine(file, STR(global_mapL0[i]))
				next
				WriteLine(file, MAPFILE_NEWLAYER)
				for i = 0 to global_mapL1.length - 1
					WriteLine(file, STR(global_mapL1[i]))
				next
				WriteLine(file, MAPFILE_NEWLAYER)
				for i = 0 to global_mapL2.length - 1
					WriteLine(file, STR(global_mapL2[i]))
				next
				WriteLIne(file, MAPFILE_END)
				CloseFile(file)
				
				ShowMessage(things, 12, POS_CENTER, 2000, 28)
			else
				ShowMessage(things, 13, POS_CENTER, 2000, 28)
			endif
			things[this].state = STATE_MAIN
		endcase
	endselect
endfunction

function ProgMapCam(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			SetCameraRotation(CAM_MAIN, 0,0,0)
			SetCameraFOV(CAM_MAIN, 100)
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			movedx as float
			movedy as float
			movspeed as float
			
			movspeed = 0.4
			
			if ( GetPointerPressed() )
				things[this].vars[V_MAPCAM_STARTX] = GetPointerX()
				things[this].vars[V_MAPCAM_STARTY] = GetPointerY()
			elseif ( GetPointerState() = 1 )
				movedx = GetPointerX() - things[this].vars[V_MAPCAM_STARTX]
				movedx = movedx * 0.01
				movedy = GetPointerY() - things[this].vars[V_MAPCAM_STARTY]
				movedy = movedy * 0.01
				RotateCameraLocalX(CAM_MAIN, movedy)
				RotateCameraGlobalY(CAM_MAIN, movedx)
			endif
			
			if GetRawKeyState(KEY_W) = 1
				MoveCameraLocalZ( 1, movspeed )
			elseif GetRawKeyState(KEY_S) = 1
				MoveCameraLocalZ( 1, -movspeed )
			endif
			
			If GetRawKeyState(KEY_A) = 1
				MoveCameraLocalX( 1, -movspeed )
			elseif GetRawKeyState(KEY_D) = 1
				MoveCameraLocalX( 1, movspeed )
			endif
			
			If GetRawKeyState(KEY_Z) = 1
				MoveCameraLocalY(CAM_MAIN, -movspeed)
			endif
			
			If GetRawKeyState(KEY_X) = 1
				MoveCameraLocalY(CAM_MAIN, movspeed)
			endif
			
			If GetRawKeyPressed(KEY_R) = 1
				SetCameraRotation(CAM_MAIN, 0,0,0)
				SetCameraPosition(CAM_MAIN, 0,0,0)
			endif
		endcase
	endselect
endfunction

function ProgObjectPreview(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			
		endcase
		
		case STATE_UPDATE
			templatenum as integer
			rotated as integer
			if things[this].id <> 0
				DeleteObjectWithChildren(things[this].id)
				things[this].id = 0
			endif			
			if things[T_TILESELECT].used = YES
				templatenum = things[T_TILESELECT].vars[V_TS_DRAWTILE]
			endif
			if templatenum <> 0
				if templatenum > TMPL_LAST
					templatenum = templatenum - TMPL_LAST
					rotated = 1
				endif
				things[this].id = CloneTObject(tgame, templatenum)
				if rotated = 1
					RotateObjectLocalY(things[this].id, 90)
				endif
				SetObjectDepthRange( things[this].id, 0, 0.05 )
				SetObjectPosition(things[this].id, 0,0,0)
				SetObjectVisible(things[this].id,0)
			endif
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			if things[this].id <> 0
				cx as float
				cy as float
				cz as float
				cxrot as float
				cyrot as float
				czrot as float
				cx = GetCameraX(CAM_MAIN)
				cy = GetCameraY(CAM_MAIN)
				cz = GetCameraZ(CAM_MAIN)
				cxrot = GetCameraAngleX(CAM_MAIN)
				cyrot = GetCameraAngleY(CAM_MAIN)
				czrot = GetCameraAngleZ(CAM_MAIN)
				SetCameraRotation(CAM_MAIN, 25, 0, 0)
				SetCameraPosition(CAM_MAIN, 45, 50, -40)	
				SetObjectVisible(things[this].id, 1)
				DrawObject(things[this].id)
				SetObjectVisible(things[this].id, 0)
				SetCameraPosition(CAM_MAIN, cx, cy, cz)		//set cam back to original position
				SetCameraRotation(CAM_MAIN, cxrot, cyrot, czrot)
			endif
		endcase
	endselect
endfunction

function ProgTileSelect(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			things[this].vars[V_MAP_TSIZE] = TILESIZE
			things[this].vars[V_TS_MAPX] = 0
			things[this].vars[V_TS_MAPY] = 0
			things[this].vars[V_TS_DTCOUNT] = 0
			things[this].vars[V_TS_DRAWTILE] = 0
			SetObjectColor(things[this].id, 0, 50, 0, 255)
			SetObjectColorEmissive(things[this].id, 0,200,0)
			SetObjectPosition(things[this].id, 0, 0, 0)
			
			btnsize as integer 
			btnsize = 64
			AddVirtualButton(VBUTTON5, 0 + btnsize/2, tgame.window_height - btnsize/2, btnsize)
			SetVirtualButtonImageUp(VBUTTON5, IMG_MEBTNLEFTUP)
			SetVirtualButtonImageDown(VBUTTON5, IMG_MEBTNLEFTDN)
			AddVirtualButton(VBUTTON6, 0 + btnsize * 4, tgame.window_height - btnsize/2, btnsize)
			SetVirtualButtonImageUp(VBUTTON6, IMG_MEBTNRIGHTUP)
			SetVirtualButtonImageDown(VBUTTON6, IMG_MEBTNRIGHTDN)
			
			SetVirtualButtonAlpha(VBUTTON5, 255)
			SetVirtualButtonAlpha(VBUTTON6, 255)
			
			things[this].state = STATE_MAIN
		endcase
		
		case STATE_MAIN
			moveamount as integer
			maxdtcount as integer
			moveamount = things[this].vars[V_MAP_TSIZE]
			x as integer
			y as integer
			layer as integer
			maxsize as integer
			
			if things[T_MAP].used = YES
				maxsize = things[T_MAP].vars[V_MAP_MAPSIZE]
			endif
			
			If GetRawKeyPressed(KEY_J) = 1
				things[this].vars[V_TS_MAPX] = things[this].vars[V_TS_MAPX] - 1
				if things[this].vars[V_TS_MAPX] < 0
					things[this].vars[V_TS_MAPX] = 0
				else
					MoveObjectLocalX(things[this].id, -moveamount)
				endif
				
			endif
			
			If GetRawKeyPressed(KEY_L) = 1
				things[this].vars[V_TS_MAPX] = things[this].vars[V_TS_MAPX] + 1
				
				if things[this].vars[V_TS_MAPX] >= maxsize
					things[this].vars[V_TS_MAPX] = maxsize - 1
				else
					MoveObjectLocalX(things[this].id, moveamount)
				endif
			endif
			
			If GetRawKeyPressed(KEY_I) = 1
				things[this].vars[V_TS_MAPY] = things[this].vars[V_TS_MAPY] + 1
				if things[this].vars[V_TS_MAPY] >= maxsize
					things[this].vars[V_TS_MAPY] = maxsize - 1
				else
					MoveObjectLocalZ(things[this].id, moveamount)
				endif
			endif
			
			If GetRawKeyPressed(KEY_K) = 1
				things[this].vars[V_TS_MAPY] = things[this].vars[V_TS_MAPY] - 1
				if things[this].vars[V_TS_MAPY] < 0
					things[this].vars[V_TS_MAPY] = 0
				else
					MoveObjectLocalZ(things[this].id, -moveamount)
				endif
			endif
			
			//cycle through avaliable tiles
			c as integer
			//**************************************************************
			maxdtcount = 49 //set max templates
			//**************************************************************
			
			If GetVirtualButtonPressed(VBUTTON5) = 1 or GetVirtualButtonPressed(VBUTTON6) = 1 or GetRawKeyPressed(KEY_E) = 1 or GetRawKeyPressed(KEY_Q) = 1
				things[this].vars[V_TS_ROTATE] = 0	//reset rotation
				
				If GetVirtualButtonPressed(VBUTTON6) = 1 or GetRawKeyPressed(KEY_E) = 1
					inc things[this].vars[V_TS_DTCOUNT], 1
					if things[this].vars[V_TS_DTCOUNT] > maxdtcount
						things[this].vars[V_TS_DTCOUNT] = 0
					endif
				else
					dec things[this].vars[V_TS_DTCOUNT], 1
					if things[this].vars[V_TS_DTCOUNT] < 0
						things[this].vars[V_TS_DTCOUNT] = maxdtcount
					endif
				endif
				
				c = things[this].vars[V_TS_DTCOUNT]
				//**************************************************************
				//========================TEMPLATES HERE========================
				select c 
					case 0 : things[this].vars[V_TS_DRAWTILE] = 0 : endcase
					case 1 : things[this].vars[V_TS_DRAWTILE] = TMPL_GRASS: endcase
					case 2 : things[this].vars[V_TS_DRAWTILE] = TMPL_FLOORCEIL : endcase
					case 3 : things[this].vars[V_TS_DRAWTILE] = TMPL_WCSTARTNORTH : endcase
					case 4 : things[this].vars[V_TS_DRAWTILE] = TMPL_WCSTARTSOUTH : endcase
					case 5 : things[this].vars[V_TS_DRAWTILE] = TMPL_WCSTARTNORTH + TMPL_LAST : endcase
					case 6 : things[this].vars[V_TS_DRAWTILE] = TMPL_WCSTARTSOUTH + TMPL_LAST : endcase					
					case 7 : things[this].vars[V_TS_DRAWTILE] = TMPL_WALL : endcase
					case 8 : things[this].vars[V_TS_DRAWTILE] = TMPL_WALL + TMPL_LAST : endcase
					case 9 : things[this].vars[V_TS_DRAWTILE] = TMPL_TWALLNORTH : endcase
					case 10 : things[this].vars[V_TS_DRAWTILE] = TMPL_TWALLSOUTH : endcase
					case 11 : things[this].vars[V_TS_DRAWTILE] = TMPL_TWALLNORTH + TMPL_LAST : endcase
					case 12 : things[this].vars[V_TS_DRAWTILE] = TMPL_TWALLSOUTH + TMPL_LAST : endcase
					case 13 : things[this].vars[V_TS_DRAWTILE] = TMPL_WALLCORNER : endcase
					case 14 : things[this].vars[V_TS_DRAWTILE] = TMPL_WALLDOORFRAME : endcase
					case 15 : things[this].vars[V_TS_DRAWTILE] = TMPL_WALLDOORFRAME + TMPL_LAST : endcase
					case 16 : things[this].vars[V_TS_DRAWTILE] = TMPL_WALLDOOR : endcase
					case 17 : things[this].vars[V_TS_DRAWTILE] = TMPL_WALLDOOR + TMPL_LAST : endcase
					case 18 : things[this].vars[V_TS_DRAWTILE] = TMPL_MEREDWALLDOOR : endcase
					case 19 : things[this].vars[V_TS_DRAWTILE] = TMPL_MEBLUWALLDOOR : endcase
					case 20 : things[this].vars[V_TS_DRAWTILE] = TMPL_MEYELWALLDOOR : endcase
					case 21 : things[this].vars[V_TS_DRAWTILE] = TMPL_MEREDWALLDOOR + TMPL_LAST : endcase
					case 22 : things[this].vars[V_TS_DRAWTILE] = TMPL_MEBLUWALLDOOR + TMPL_LAST : endcase
					case 23 : things[this].vars[V_TS_DRAWTILE] = TMPL_MEYELWALLDOOR + TMPL_LAST : endcase
					case 24 : things[this].vars[V_TS_DRAWTILE] = TMPL_CRATE : endcase
					case 25 : things[this].vars[V_TS_DRAWTILE] = TMPL_BARREL : endcase
					case 26 : things[this].vars[V_TS_DRAWTILE] = TMPL_FBARREL : endcase
					case 27 : things[this].vars[V_TS_DRAWTILE] = TMPL_FBARREL3 : endcase
					case 28 : things[this].vars[V_TS_DRAWTILE] = TMPL_FBARREL3 + TMPL_LAST : endcase
					case 29 : things[this].vars[V_TS_DRAWTILE] = TMPL_TORCH : endcase
					case 30 : things[this].vars[V_TS_DRAWTILE] = TMPL_EXIT1 : endcase
					case 31 : things[this].vars[V_TS_DRAWTILE] = TMPL_KEYR : endcase
					case 32 : things[this].vars[V_TS_DRAWTILE] = TMPL_KEYB : endcase
					case 33 : things[this].vars[V_TS_DRAWTILE] = TMPL_KEYY : endcase
					case 34 : things[this].vars[V_TS_DRAWTILE] = TMPL_MEDPACK : endcase
					case 35 : things[this].vars[V_TS_DRAWTILE] = TMPL_AMMO : endcase
					case 36 : things[this].vars[V_TS_DRAWTILE] = TMPL_COIN : endcase
					case 37 : things[this].vars[V_TS_DRAWTILE] = TMPL_ITEMPISTOL : endcase
					case 38 : things[this].vars[V_TS_DRAWTILE] = TMPL_ITEMRIFLE : endcase
					case 39 : things[this].vars[V_TS_DRAWTILE] = TMPL_ITEMLAUNCHER : endcase
					case 40 : things[this].vars[V_TS_DRAWTILE] = TMPL_MEPLAYER : endcase
					case 41 : things[this].vars[V_TS_DRAWTILE] = TMPL_DEER : endcase
					case 42 : things[this].vars[V_TS_DRAWTILE] = TMPL_GOLEM : endcase
					case 43 : things[this].vars[V_TS_DRAWTILE] = TMPL_SKELETON : endcase
					case 44 : things[this].vars[V_TS_DRAWTILE] = TMPL_SKELSOLDIER : endcase
					case 45 : things[this].vars[V_TS_DRAWTILE] = TMPL_REDLIGHT : endcase
					case 46 : things[this].vars[V_TS_DRAWTILE] = TMPL_BLUELIGHT : endcase
					case 47 : things[this].vars[V_TS_DRAWTILE] = TMPL_GREENLIGHT: endcase
					case 48 : things[this].vars[V_TS_DRAWTILE] = TMPL_WHITELIGHT : endcase
					case 49 : things[this].vars[V_TS_DRAWTILE] = TMPL_LAST : endcase
				endselect
				//==============================================================
				//**************************************************************
				if things[T_OBJPRV].used = YES
					things[T_OBJPRV].state = STATE_UPDATE
				endif
			endif
			
			x = things[this].vars[V_TS_MAPX]
			y = things[this].vars[V_TS_MAPY]
			
			//Print("CURSORX:" + STR(x))
			//Print("CURSORY:" + STR(y))
			//PRINT("TILE:" + STR(things[this].vars[V_TS_DRAWTILE]))
		endcase
	endselect
endfunction

function ProgMap(tgame ref as Game, things ref as Thing[], this as integer)
	select things[this].state
		case STATE_INIT
			mapsize as integer
			buttonsize as integer
			things[this].vars[V_MAP_TOGGLELAYERCOLOR] = 1
			things[this].vars[V_MAP_TSIZE] = TILESIZE
			things[this].vars[V_MAP_MAPSIZE] = tgame.mapsize	 //*********CHOOSE MAP SIZE HERE**************
			mapsize = things[this].vars[V_MAP_MAPSIZE]
			global_mapL0.length = mapsize * mapsize
			global_mapL1.length = mapsize * mapsize
			global_mapL2.length = mapsize * mapsize
			
			//create layer switch buttons
			buttonsize = 128
			AddVirtualButton(VBUTTON1, buttonsize/2, buttonsize/2, buttonsize)
			AddVirtualButton(VBUTTON2, buttonsize/2 + buttonsize, buttonsize/2, buttonsize)
			AddVirtualButton(VBUTTON3, buttonsize/2 + buttonsize + buttonsize,  buttonsize/2, buttonsize)
			SetVirtualButtonImageUp(VBUTTON1, IMG_MEBTNLAYER1UP)
			SetVirtualButtonImageUp(VBUTTON2, IMG_MEBTNLAYER2DN)
			SetVirtualButtonImageUp(VBUTTON3, IMG_MEBTNLAYER3DN)
			SetVirtualButtonImageDown(VBUTTON1, IMG_MEBTNLAYER1UP)
			SetVirtualButtonImageDown(VBUTTON2, IMG_MEBTNLAYER2DN)
			SetVirtualButtonImageDown(VBUTTON3, IMG_MEBTNLAYER3DN)
			SetVirtualButtonAlpha(VBUTTON1, 255)
			SetVirtualButtonAlpha(VBUTTON2, 255)
			SetVirtualButtonAlpha(VBUTTON3, 255)
			
			
			AddVirtualButton(VBUTTON7, tgame.window_width - buttonsize/2, tgame.window_height - buttonsize/2, buttonsize)
			SetVirtualButtonImageUp(VBUTTON7, IMG_MEBTNPLACEUP)
			SetVirtualButtonImageDown(VBUTTON7, IMG_MEBTNPLACEDN)
			SetVirtualButtonAlpha(VBUTTON7, 255)
			
			AddVirtualButton(VBUTTON10, tgame.window_width - buttonsize/2 - buttonsize, tgame.window_height - buttonsize/2, buttonsize)
			SetVirtualButtonImageUp(VBUTTON10, IMG_MEBTNDEL)
			SetVirtualButtonImageDown(VBUTTON10, IMG_MEBTNDEL)
			SetVirtualButtonAlpha(VBUTTON10, 255)
			things[this].state = STATE_RELOAD
			//exitfunction
			//========LOAD EXISTING MAP=======
			saveslot as integer
			filename as string
			fileid as integer
			mindex as integer
			saveslot = tgame.currentslot
			filename = "slot" + STR(saveslot) + ".txt"
			If GetFileExists(filename) = 1
				fileid = OpenToRead(filename)
				things[this].vars[V_MAP_MAPSIZE] = Val(ReadLine(fileid))
				mapsize = things[this].vars[V_MAP_MAPSIZE]
				global_mapL0.length = mapsize * mapsize
				global_mapL1.length = mapsize * mapsize
				global_mapL2.length = mapsize * mapsize
				
				ReadLine(fileid) //readnewlayer
				for mindex = 0 to global_mapL0.length - 1
					global_mapL0[mindex] = Val(ReadLine(fileid))
				next
				
				ReadLine(fileid) //readnewlayer
				for mindex = 0 to global_mapL1.length - 1
					global_mapL1[mindex] = Val(ReadLine(fileid))
				next
				
				ReadLine(fileid) //readnewlayer
				for mindex = 0 to global_mapL2.length - 1
					global_mapL2[mindex] = Val(ReadLine(fileid))
				next
				CloseFile(fileid)
			endif	
			//========LOAD EXISTING MAP=======
		endcase
		
		//reloads map
		case STATE_RELOAD
			tmpstr as string
			i as integer
			count as integer
			max as integer
			linesize as integer
			currentobj as integer
			nowx as integer
			nowy as integer
			tile_size as integer
			tmpobjid as integer
			layernow as integer
			rotated as integer
			
			//get maximum array size and max line size
			max = things[this].vars[V_MAP_MAPSIZE] * things[this].vars[V_MAP_MAPSIZE]
			linesize = things[this].vars[V_MAP_MAPSIZE]
			
			
			//delete all objects on map
			for i = 0 to global_currentobj.length
				if global_currentobj[i] <> 0
					DeleteObject(global_currentobj[i])
				endif
			next
			global_currentobj.length = -1
			
			//create objects on all layers
			layernow = 0
			for layernow = 0 to 2
				nowx = 0
				nowy = 0
				count = 0
				tile_size = things[this].vars[V_MAP_TSIZE] 
				for i = 0 to max
					
					if layernow = 0
						currentobj = global_mapL0[i]
					elseif layernow = 1
						currentobj = global_mapL1[i]
					elseif layernow = 2
						currentobj = global_mapL2[i]
					endif
					
					if currentobj <> 0 
						rotated = 0
						if currentobj > TMPL_LAST //rotated version
							currentobj = currentobj - TMPL_LAST //get template number							
							rotated = 1
						endif
						tmpobjid = CloneTObject(tgame, currentobj)
						
						if rotated = 1
							RotateObjectLocalY(tmpobjid, 90)
						endif
					else
						tmpobjid = 0
					endif		
					
					if tmpobjid <> 0
						SetObjectPosition(tmpobjid, nowx, 0, nowy)	
						if  currentobj = TMPL_GREENLIGHT or currentobj	= TMPL_REDLIGHT or currentobj = TMPL_WHITELIGHT or currentobj = TMPL_BLUELIGHT
							MoveObjectLocalY(tmpobjid, 24)
						endif
						if things[this].vars[V_MAP_TOGGLELAYERCOLOR] = 1
							if layernow = 0
								SetObjectColorEmissive(tmpobjid, 200,0,0)
							elseif layernow = 1
								SetObjectColorEmissive(tmpobjid, 0,200,0)
							elseif layernow = 2
								SetObjectColorEmissive(tmpobjid, 0,0,200)
							endif
						endif
						global_currentobj.insert(tmpobjid)
					endif
					
					//next
					nowx = nowx + tile_size
					inc count
					if count >= linesize
						count = 0
						nowx = 0
						nowy = nowy + tile_size
					endif
				next
			next
			
			things[this].state = STATE_IDLE
		endcase
		
		case STATE_IDLE
			x as integer
			y as integer
			layer_now as integer
			
			layer_now = things[this].vars[V_MAP_LAYERNOW]
			
			If GetRawKeyPressed(KEY_O) = 1
				if things[this].vars[V_MAP_TOGGLELAYERCOLOR] = 1
					things[this].vars[V_MAP_TOGGLELAYERCOLOR] = 0
				elseif things[this].vars[V_MAP_TOGGLELAYERCOLOR] = 0
					things[this].vars[V_MAP_TOGGLELAYERCOLOR] = 1
				endif
				things[this].state = STATE_RELOAD
			endif
			
			If GetRawKeyPressed(KEY_SPACE) = 1 or GetVirtualButtonPressed(VBUTTON7) = 1
				If things[T_TILESELECT].used = YES
					x=things[T_TILESELECT].vars[V_TS_MAPX]
					y=things[T_TILESELECT].vars[V_TS_MAPY]
					
					if layer_now = 0
						SetMapVal(global_mapL0, things[this].vars[V_MAP_MAPSIZE], x, y, things[T_TILESELECT].vars[V_TS_DRAWTILE])
					elseif layer_now = 1
						SetMapVal(global_mapL1, things[this].vars[V_MAP_MAPSIZE], x, y, things[T_TILESELECT].vars[V_TS_DRAWTILE])
					elseif layer_now = 2
						SetMapVal(global_mapL2, things[this].vars[V_MAP_MAPSIZE], x, y, things[T_TILESELECT].vars[V_TS_DRAWTILE])
					endif
					
					things[this].state = STATE_RELOAD
				endif
			endif
			
			If GetRawKeyPressed(KEY_F1) = 1
				fi as integer
				for fi = 0 to global_mapL0.length - 1
					global_mapL0[fi] = things[T_TILESELECT].vars[V_TS_DRAWTILE]
				next
				things[this].state = STATE_RELOAD
			endif
			
			if GetVirtualButtonPressed(VBUTTON10) = 1
				If things[T_TILESELECT].used = YES
					x=things[T_TILESELECT].vars[V_TS_MAPX]
					y=things[T_TILESELECT].vars[V_TS_MAPY]
					if layer_now = 0
						SetMapVal(global_mapL0, things[this].vars[V_MAP_MAPSIZE], x, y, 0)
					elseif layer_now = 1
						SetMapVal(global_mapL1, things[this].vars[V_MAP_MAPSIZE], x, y, 0)
					elseif layer_now = 2
						SetMapVal(global_mapL2, things[this].vars[V_MAP_MAPSIZE], x, y, 0)
					endif
					things[this].state = STATE_RELOAD
				endif
			endif
			
			//cycle layers
			
			If GetVirtualButtonPressed(VBUTTON1) = 1
				things[this].vars[V_MAP_LAYERNOW] = 0
				SetVirtualButtonImageUp(VBUTTON1, IMG_MEBTNLAYER1UP)
				SetVirtualButtonImageUp(VBUTTON2, IMG_MEBTNLAYER2DN)
				SetVirtualButtonImageUp(VBUTTON3, IMG_MEBTNLAYER3DN)
				SetVirtualButtonImageDown(VBUTTON1, IMG_MEBTNLAYER1UP)
				SetVirtualButtonImageDown(VBUTTON2, IMG_MEBTNLAYER2DN)
				SetVirtualButtonImageDown(VBUTTON3, IMG_MEBTNLAYER3DN)
			elseif GetVirtualButtonPressed(VBUTTON2) = 1
				things[this].vars[V_MAP_LAYERNOW] = 1
				SetVirtualButtonImageUp(VBUTTON1, IMG_MEBTNLAYER1DN)
				SetVirtualButtonImageUp(VBUTTON2, IMG_MEBTNLAYER2UP)
				SetVirtualButtonImageUp(VBUTTON3, IMG_MEBTNLAYER3DN)
				SetVirtualButtonImageDown(VBUTTON1, IMG_MEBTNLAYER1DN)
				SetVirtualButtonImageDown(VBUTTON2, IMG_MEBTNLAYER2UP)
				SetVirtualButtonImageDown(VBUTTON3, IMG_MEBTNLAYER3DN)
			elseif GetVirtualButtonPressed(VBUTTON3) = 1
				things[this].vars[V_MAP_LAYERNOW] = 2
				SetVirtualButtonImageUp(VBUTTON1, IMG_MEBTNLAYER1DN)
				SetVirtualButtonImageUp(VBUTTON2, IMG_MEBTNLAYER2DN)
				SetVirtualButtonImageUp(VBUTTON3, IMG_MEBTNLAYER3UP)
				SetVirtualButtonImageDown(VBUTTON1, IMG_MEBTNLAYER1DN)
				SetVirtualButtonImageDown(VBUTTON2, IMG_MEBTNLAYER2DN)
				SetVirtualButtonImageDown(VBUTTON3, IMG_MEBTNLAYER3UP)
			endif
			
		endcase
	endselect
endfunction
