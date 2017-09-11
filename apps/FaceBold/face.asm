##define curPosL RB5	
##define curPosH RB6
##define currentFace RB7

##define drawValue RD0
##define drawValueH RD1

##define sadrL RA0
##define sadrM RA1
##define sadrH RA2

##define bigDigitAdr2 ((((bigDigit & 0x3FF)*2)>>8) & 0x0F)
##define bigDigitAdr1 ((((bigDigit & 0x3FF)*2)>>4) & 0x0F)
##define bigDigitAdr0 ((((bigDigit & 0x3FF)*2)   ) & 0x0F)

##define dayOfWeekAdr2 ((((dayOfWeek & 0x3FF)*2)>>8) & 0x0F)
##define dayOfWeekAdr1 ((((dayOfWeek & 0x3FF)*2)>>4) & 0x0F)
##define dayOfWeekAdr0 ((((dayOfWeek & 0x3FF)*2)   ) & 0x0F)

##define monthAdr2 ((((month & 0x3FF)*2)>>8) & 0x0F)
##define monthAdr1 ((((month & 0x3FF)*2)>>4) & 0x0F)
##define monthAdr0 ((((month & 0x3FF)*2)   ) & 0x0F)
	
	ORG 0 
	JMP start		
	JMP tick
	JMP 0x11A
	JMP 0x109
	JMP 0x0E0
	JMP btn_mode	
	JMP btn_transmit
	JMP btn_right		
	JMP btn_left	
	JMP 0x2A9
	JMP 0x307
	JMP 0x39C
	JMP 0x09B
	JMP 0x98F
	RET

start:
	CLRM RB1, RB3%8
    LDI RB2, 0b1111
    LCRB B0
	LDI RB4, 2
	JMP 0x227
	
btn_mode:
	CALL check_watch_screen
	JMP 0x243
	
btn_transmit:
	CALL check_watch_screen
	JMP 0x283

check_watch_screen:
	LARB B0
	LDI RB2, 0b1111
	MVCA RB3,RB4
	CPI RB3, 0
	JZ btn_mode_startapp
	LDI RB3, 0b0000
	RET
  btn_mode_startapp:
	LDI RB3, 0b1000
	JMP redraw

btn_right:
	LCRB B3
	LDI currentFace, 1
	CALL redraw
	;INC currentFace, currentFace%8
	JMP 0x2DF
	
btn_left:
	LCRB B3
	LDI currentFace, 0
	CALL redraw
	;DEC currentFace, currentFace%8
	JMP 0x383
	
tick:
	LCRB B3
	;ANDI currentFace, 0b01
	IJMR currentFace
	JMP tick_face0
	JMP 0x190
	
redraw:
	PLAI 125 
	CALL OS_CLS

	LCRB B3
	;ANDI currentFace, 0b01
	IJMR currentFace
	JMP redraw_face0
	RET
	
;
; face big style
;
	
tick_face0:
	LCRB B0
	CPI RB5, 0
	JNZ seconds_face0
	CPI RB6, 0
	JNZ seconds_face0
		
redraw_face0:
	LCRB B3
	LARB B0
	
	;dots
	PLAI 3
	STLI 0xED
	PLAI 23
	STLI 0xE9
	
	;minutes
	MVCA drawValue,RA0
	LDI curPosL, 6
	LDI curPosH, 0
	CALL drawBigDigit
	
	MVCA drawValue,RA1
	LDI curPosL, 4
	LDI curPosH, 0
	CALL drawBigDigit
	
	;hours
	MVCA drawValue, RA2
	CPI drawValue,10
	JC redraw_if0
	PLAI 0                          ;draw
	STLI 0xEE                      
	PLAI 10                         
	STLI 0xE6                     
	PLAI 20                         
	STLI 0xEA                       ;one
	SBI drawValue, 10
  redraw_if0:
	LDI curPosL, 1
	LDI curPosH, 0
	CALL drawBigDigit
	
	;dayOfWeek
	PLAI 30
	MVCA drawValue, RA7
	CALL drawDayOfWeek
	LDI drawValue, 0xC
	LDI drawValueH, 0x2
	STLM drawValue, (drawValueH)%8
	
	;dayOfMonth
	MVCA drawValue,RA5
	CPJR drawValue, 0, +1
	STL drawValue
	MVCA drawValue,RA4
	STL drawValue
	
	;month
	PLAI 37
	MVCA drawValue, RA6
	CALL drawMonth
	
seconds_face0:
	LCRB B3
	LARB B0
	
	;seconds
	MVCA drawValue,RB6
	LDI drawValueH, 8	
	ADD drawValue,drawValue
	PLAI 8
	STLM drawValue, (drawValueH)%8
	PLAI 18
	INC drawValue, (drawValueH)%8
	STLM drawValue, (drawValueH)%8
	
	MVCA drawValue,RB5
	ADD drawValue,drawValue
	JNC tick_if0
	INC drawValue+1, (drawValueH)%8
  tick_if0:
	PLAI 9
	STLM drawValue, (drawValueH)%8
	PLAI 19
	INC drawValue, (drawValueH)%8
	STLM drawValue, (drawValueH)%8

	JMP 0x98F

drawBigDigit:
	LDI sadrH, bigDigitAdr2
	LDI sadrM, bigDigitAdr1
	LDI sadrL, bigDigitAdr0
	
	CLRM drawValueH, (drawValueH+1)%8
	ADM sadrL, drawValue+2
	ADM sadrL, drawValue+2
	
	LDI drawValue, 4
	LDI drawValueH, 1
	
  drawBigDigit_loop1:
	PLAM curPosL, curPosH%8
	PSAM sadrL,sadrH%8
	CALL OS_PRINT0-2
	
	ADI curPosL, 10
	JNC drawBigDigit_if1
	INC curPosH, curPosH%8
  drawBigDigit_if1:
  
    ADM sadrL, drawValue+2
	CPI curPosH, 2
	JNZ drawBigDigit_loop1
	RET
	
drawDayOfWeek:
	LDI sadrH, dayOfWeekAdr2
	LDI sadrM, dayOfWeekAdr1
	LDI sadrL, dayOfWeekAdr0
	JMP drawLine3
	
drawMonth:
	LDI sadrH, monthAdr2
	LDI sadrM, monthAdr1
	LDI sadrL, monthAdr0
	
drawLine3:
	CLRM drawValueH, (drawValueH+1)%8
	ADM sadrL, drawValue+2
	ADM sadrL, drawValue+2
	ADM sadrL, drawValue+2
	PSAM sadrL,sadrH%8
	CALL OS_PRINT0-3
	RET
	
bigDigit:
	;top
	DW 0xF5EE	;0
	DW 0x20EE	;1
	DW 0xF5EE	;2
	DW 0xF5EE	;3
	DW 0xEEEE	;4
	DW 0xF5EE   ;FA	;5
	DW 0xF5EE	;6
	DW 0xF5EE	;7
	DW 0xF5EE	;8
	DW 0xF5EE	;9
	;middle
	DW 0xE6E6	;0
	DW 0x20E6	;1
	DW 0xF5EA	;2
	DW 0xFAE6	;3
	DW 0xF3E6	;4
	DW 0xF3EE	;5
	DW 0xFEEE	;6
	DW 0x20E6	;7
	DW 0xFEE6	;8
	DW 0xF3E6	;9
	;bottom
	DW 0xF3EA	;0
	DW 0x20EA	;1
	DW 0xF3EA	;2
	DW 0xF3EA	;3
	DW 0x20EA	;4	
	DW 0xF3EA	;5
	DW 0xF3EA	;6
	DW 0x20EA	;7	
	DW 0xF3EA	;8
	DW 0xF3EA	;9
	
			
dayOfWeek:
	DS "SUNMONTUEWEDTHUFRISAT"

month:
	DS "JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
	
	END