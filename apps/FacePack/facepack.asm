##define curPosL RB5	
##define curPosH RB6
##define currentFace RB7

##define drawValue RD0
##define drawValueH RD1

##define sadrL RA0
##define sadrM RA1
##define sadrH RA2

##define adderL RB0
##define adderM RB1
##define adderH RB2

##define onesAdr2 ((((ones & 0x3FF)*2)>>8) & 0x0F)
##define onesAdr1 ((((ones & 0x3FF)*2)>>4) & 0x0F)
##define onesAdr0 ((((ones & 0x3FF)*2)   ) & 0x0F)

##define textTimeAdr2 ((((textTime & 0x3FF)*2)>>8) & 0x0F)
##define textTimeAdr1 ((((textTime & 0x3FF)*2)>>4) & 0x0F)
##define textTimeAdr0 ((((textTime & 0x3FF)*2)   ) & 0x0F)

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
	INC currentFace, currentFace%8
	CALL redraw
	JMP 0x2DF
	
btn_left:
	LCRB B3
	DEC currentFace, currentFace%8
	CALL redraw
	JMP 0x383
	
tick:
	LCRB B3
	ANDI currentFace, 0b11
	IJMR currentFace
	JMP tick_face0
	JMP tick_face1
	JMP tick_face2
	JMP 0x190
	
redraw:
	PLAI 125 
	CALL OS_CLS
	LCRB B3
	ANDI currentFace, 0b11
	IJMR currentFace
	JMP redraw_face0
	JMP redraw_face1
	JMP redraw_face2
	REt
	
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
	
	;dots
	PLAI 3
	STLI 0xED
	PLAI 23
	STLI 0xE9
	
	;minutes
	MVCA drawValue,RA1
	LDI curPosL, 4
	LDI curPosH, 0
	CALL drawBigDigit
		
	MVCA drawValue,RA0
	LDI curPosL, 6
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
	
;
; face BCD
;
tick_face1:
	LCRB B0
	CPI RB5, 0
	JNZ seconds_face1
	CPI RB6, 0
	JNZ seconds_face1
		
redraw_face1:
	LCRB B3
	LARB B0	
	
	;hours
	MVCA drawValue, RA2
	CPI drawValue,10
	JC redraw_face1_if0
	LDI drawValueH, 1
	SBI drawValue, 10
  redraw_face1_if0:
    LDI drawValueH, 0
	MVCA sadrH, RA3
	CPJR sadrH, 0, redraw_face1_if2
	LDI sadrL, 2
	ADM drawValue, sadrH
  redraw_face1_if2:
	
	PLAI 2
	CALL draw_bit3
	STLI 0x83
	PLAI 12
	CALL draw_bit2
	STLI 0x83
	PLAI 22
	CALL draw_bit1
	STLI 0x83
	PLAI 32
	CALL draw_bit0
	STLI 0x83
	
	MOV drawValue, drawValueH
	PLAI 21
	CALL draw_bit1
	PLAI 31
	CALL draw_bit0

	;minutes
	MVCA drawValue,RA1
	PLAI 14
	CALL draw_bit2
	PLAI 24
	CALL draw_bit1
	PLAI 34
	CALL draw_bit0
	
	MVCA drawValue,RA0
	PLAI 5
	CALL draw_bit3
	STLI 0x83
	PLAI 15
	CALL draw_bit2
	STLI 0x83
	PLAI 25
	CALL draw_bit1
	STLI 0x83
	PLAI 35
	CALL draw_bit0
	STLI 0x83
	
seconds_face1:
	LCRB B3
	LARB B0
	
	;seconds
	MVCA drawValue,RB6
	PLAI 17
	CALL draw_bit2
	PLAI 27
	CALL draw_bit1
	PLAI 37
	CALL draw_bit0
	
	MVCA drawValue,RB5
	PLAI 8
	CALL draw_bit3
	PLAI 18
	CALL draw_bit2
	PLAI 28
	CALL draw_bit1
	PLAI 38
	CALL draw_bit0
	
	JMP 0x98F
	
draw_bit0:
	BTJR drawValue, 0, draw_bit_set
	JMP draw_bit_clear

draw_bit1:
	BTJR drawValue, 1, draw_bit_set
	JMP draw_bit_clear

draw_bit2:
	BTJR drawValue, 2, draw_bit_set
	JMP draw_bit_clear

draw_bit3:
	BTJR drawValue, 3, draw_bit_set
	JMP draw_bit_clear
	 
draw_bit_clear:
	STLI 0xDB
	RET
	
draw_bit_set:
	STLI 0xFF
	RET
	
;
; face Text Time
;
tick_face2:
	LCRB B0
	CPI RB5, 0
	JNZ redraw_face2_end1
	CPI RB6, 0
	JNZ redraw_face2_end1
		
redraw_face2:
	LCRB B3
	LARB B0	
	
	PLAI 125 
	CALL OS_CLS
	
	;hours
	PLAI 0
	MVCA drawValue, RA2
	CPI drawValue, 0
	JNZ redraw_face2_else0
	LDI drawValue, 12
  redraw_face2_else0:
	CALL drawTextTimeOnes
  
	;minutes
	MVCA drawValue,RA1
	CPI drawValue, 0
	JZ redraw_face2_str1
	CPI drawValue, 2
	JC redraw_face2_str1ten
	PLAI 10
	SBI drawValue, 2
	CALL drawTextTimeTens
	JMP redraw_face2_str2ones
  redraw_face2_str1ten:
	MVCA drawValueH,RA0
	ADD drawValue, drawValueH
	PLAI 10
	JMP redraw_face2_str2
  redraw_face2_str1:
	PLAI 10
	MVCA drawValue,RA0
	CPI drawValue, 0
	JZ redraw_face2_str2
	STLI 'O'
	STLI 'H'
  redraw_face2_str2ones:
	PLAI 20
  redraw_face2_str2:
	CALL drawTextTimeOnes
  redraw_face2_end0:
	
	;dayOfWeek
	PLAI 30
	MVCA drawValue, RA7
	CALL drawDayOfWeek
	
  redraw_face2_end1:
	
	JMP 0x98F
	
drawTextTimeTens:
	LDI sadrH, onesAdr2
	LDI sadrM, onesAdr1
	LDI sadrL, onesAdr0
	JMP drawTextTime
	
drawTextTimeOnes:
	LDI sadrH, textTimeAdr2
	LDI sadrM, textTimeAdr1
	LDI sadrL, textTimeAdr0
		
drawTextTime:
	CLRM adderL, adderH%8
	LDI adderL, 9

  drawTextTime_loop0:
	CPJR drawValue, 0, drawTextTime_loop0_end
	ADM sadrL, adderH
	DEC drawValue, drawValue%8
	JMP drawTextTime_loop0
  drawTextTime_loop0_end:
    PSAM sadrL,sadrH%8
	CALL OS_PRINT0-9
  
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
	
textTime:
ones:
	DS "O\'CLOCK  ONE      TWO      THREE    FOUR     FIVE     SIX      SEVEN    EIGHT    NINE     TEN      ELEVEN   TWELVE   THIRTEEN FOURTEEN FIFTEEN  SIXTEEN  SEVENTEENEIGHTEEN NINETEEN "
tens: 
	DS "TWENTY   THIRTY   FORTY    FIFTY    SIXTY    SEVENTY  EIGHTY   NINETY   "
  
	END