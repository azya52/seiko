##define curPosL RB5	
##define curPosH RB6

##define drawValue RD0

##define secAppendL RC0
##define secAppendH RC1
##define checkSecZero RC2

##define bigDigitAdr RA2

##define currentMode RA3

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
	JMP 0x2DF		
	JMP 0x383		
	JMP 0x2A9
	JMP 0x307
	JMP 0x39C
	JMP 0x09B
	JMP 0x98F
	RET
	RET
	

start:
	CLRM RB1, RB3%8
    LDI RB2, 0b1100
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
	LDI RB2, 0b1100
	MVCA RB3,RB4
	CPI RB3, 0
	JZ btn_mode_startapp
	LDI RB3, 0b0000
	RET
  btn_mode_startapp:
	PLAI 125 
	CALL OS_CLS
	LDI RB3, 0b1000
	JMP redraw
		
redraw:
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
	JC e1
	PLAI 0                          ;draw
	STLI 0xEE                       ;one
	PLAI 10                         ;draw
	STLI 0xE6                       ;one
	PLAI 20                         ;draw
	STLI 0xEA                       ;one
	SBI drawValue, 10
e1:
	LDI curPosL, 1
	LDI curPosH, 0
	CALL drawBigDigit
	
	;dayOfWeek
	PLAI 30
	MVCA drawValue, RA7
	CALL drawDayOfWeek
	LDI drawValue, 0xC
	LDI drawValue+1, 0x2
	STLM drawValue, (drawValue+1)%8
	
	;dayOfMonth
	MVCA drawValue,RA5
	CPJR drawValue, 0, +1
	STL drawValue
	MVCA drawValue,RA4
	STL drawValue
	
	;Month
	PLAI 37
	MVCA drawValue, RA6
	CALL drawMonth
	JMP 0x98F
	
tick:
	LCRB B3
	LARB B0
	;seconds
	LDI secAppendH, 8
	LDI secAppendL, 0
	MVCA drawValue,RB6
	MOV checkSecZero, drawValue
	LDI drawValue+1, 0
	ADM secAppendL, drawValue+1
	ADM secAppendL, drawValue+1
	PLAI 8
	STLM secAppendL, secAppendH%8
	PLAI 18
	INC secAppendL, (secAppendL+1)%8
	STLM secAppendL, secAppendH%8
	
	LDI secAppendH, 8
	LDI secAppendL, 0
	MVCA drawValue,RB5
	ADD checkSecZero, drawValue
	LDI drawValue+1, 0
	ADM secAppendL, drawValue+1
	ADM secAppendL, drawValue+1
	PLAI 9
	STLM secAppendL, secAppendH%8
	PLAI 19
	INC secAppendL, (secAppendL+1)%8
	STLM secAppendL, secAppendH%8	
	
	CPI checkSecZero, 0
	JZ redraw
	JMP 0x98F

	
drawBigDigit:
	LDI bigDigitAdr, bigDigitAdr2
	LDI bigDigitAdr-1, bigDigitAdr1
	LDI bigDigitAdr-2, bigDigitAdr0
	
	CLRM drawValue+1, 2
	ADM bigDigitAdr-2, drawValue+2
	ADM bigDigitAdr-2, drawValue+2
	
	LDI drawValue, 4
	LDI drawValue+1, 1
	
  drawBigDigit_loop1:
	PLAM curPosL, curPosH%8
	PSAM bigDigitAdr-2,bigDigitAdr%8
	CALL OS_PRINT0-2
	
	ADI curPosL, 10
	JNC drawBigDigit_if1
	INC curPosH, curPosH%8
  drawBigDigit_if1:
  
    ADM bigDigitAdr-2, drawValue+2
	CPI curPosH, 2
	JNZ drawBigDigit_loop1
	RET
	
drawDayOfWeek:
	LDI bigDigitAdr, dayOfWeekAdr2
	LDI bigDigitAdr-1, dayOfWeekAdr1
	LDI bigDigitAdr-2, dayOfWeekAdr0
	JMP drawLine3
	
drawMonth:
	LDI bigDigitAdr, monthAdr2
	LDI bigDigitAdr-1, monthAdr1
	LDI bigDigitAdr-2, monthAdr0
	
drawLine3:
	CLRM drawValue+1, 2
	ADM bigDigitAdr-2, drawValue+2
	ADM bigDigitAdr-2, drawValue+2
	ADM bigDigitAdr-2, drawValue+2
	PSAM bigDigitAdr-2,bigDigitAdr%8
	CALL OS_PRINT0-3
	RET
	
bigDigit:
	DW 0xF5EE	;0
	DW 0x20EE	;1
	DW 0xF5EE	;2
	DW 0xF5EE	;3
	DW 0xEEEE	;4
	DW 0xF5FA	;5
	DW 0xF5EE	;6
	DW 0xF5EE	;7
	DW 0xF5EE	;8
	DW 0xF5EE	;9
	
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