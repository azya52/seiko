##define curPosL RB5	
##define curPosH RB6

##define bigDigitValue RD0

##define bigDigitAdr RA2

##define bigDigitAdr2 ((((bigDigit & 0x3FF)*2)>>8) & 0x0F)
##define bigDigitAdr1 ((((bigDigit & 0x3FF)*2)>>4) & 0x0F)
##define bigDigitAdr0 ((((bigDigit & 0x3FF)*2)   ) & 0x0F)
	
	ORG 0 
	JMP start		;start prog
	JMP tick
	JMP 0x11A
	JMP 0x109
	JMP 0x0E0
	JMP btn_mode	;btn mode
	JMP 0x283		;btn transm
	JMP 0x2DF		;btn right
	JMP 0x383		;btn left
	JMP 0x2A9
	JMP 0x307
	JMP 0x39C
	JMP 0x09B
	JMP 0x98F
	RET
	RET
	

start:
	CLRM RB1, RB3%8
    LDI RB2, 0xF
    LCRB B2
	JMP 0x227
	
btn_mode:
	CPJR RB3, 0, btn_mode_startapp
	CLRM RB1, RB3%8
	JMP 0x243
  btn_mode_startapp:
	LDI RB3, 8
	LDI RB1, 1
	JMP 0x243
	
tick:
	LCRB B3
	LARB B0
	
	MVCAM RA5,RB6
	PLAI 37
	STL RA6
	STL RA5
	
	PLAI 3                          ;draw
	STLI 0xED                       ;dots
	PLAI 23                         ;draw
	STLI 0xE9                       ;dots
	
	MVCA bigDigitValue,RA0
	LDI curPosL, 6
	LDI curPosH, 0
	CALL drawBigDigit
	
	MVCA bigDigitValue,RA1
	LDI curPosL, 4
	LDI curPosH, 0
	CALL drawBigDigit
	
	MVCA bigDigitValue, RA2
	CPI bigDigitValue,10
	JC e1
	PLAI 0                          ;draw
	STLI 0xEE                       ;one
	PLAI 10                         ;draw
	STLI 0xE6                       ;one
	PLAI 20                         ;draw
	STLI 0xEA                       ;one
	SBI bigDigitValue, 10
e1:
	LDI curPosL, 1
	LDI curPosH, 0
	CALL drawBigDigit
	
	CLRM RD4, 5
	MVCAM RD4,RA5
	PLAI 30
	STL RD5
	STL RD4
	
	JMP 0x98F
	
drawBigDigit:
	LDI bigDigitAdr, bigDigitAdr2
	LDI bigDigitAdr-1, bigDigitAdr1
	LDI bigDigitAdr-2, bigDigitAdr0
	
	CLRM bigDigitValue+1, 2
	ADM bigDigitAdr-2, bigDigitValue+2
	ADM bigDigitAdr-2, bigDigitValue+2
	
	LDI bigDigitValue, 4
	LDI bigDigitValue+1, 1
	
	LDI RC1,2
  drawBigDigit_loop1:
	PLAM curPosL, curPosH%8
	PSAM bigDigitAdr-2,bigDigitAdr%8
	CALL OS_PRINT0-2
	
	ADI curPosL, 10
	JNC drawBigDigit_if1
	INC curPosH, curPosH%8
  drawBigDigit_if1:
    PLAM curPosL, curPosH%8
    
    ADM bigDigitAdr-2, bigDigitValue+2
	DEC RC1,RC1%8
	JNC drawBigDigit_loop1
	RET
	
bigDigit:
	DW 0xF0F4
	DW 0x20F4
	DW 0xF0F4
	DW 0xF0F4
	DW 0xE5E5
	DW 0xF0F1
	DW 0xF0F1
	DW 0xF0F4
	DW 0xF0F4
	DW 0xF0F4
	
	DW 0xE5E5
	DW 0x20E5
	DW 0xF0F2
	DW 0x20FD
	DW 0xECFD
	DW 0xECF4
	DW 0xE5F4
	DW 0x20E5
	DW 0xE5FD
	DW 0xECFD
	
	DW 0xECF2
	DW 0x20EC
	DW 0xECF1
	DW 0xECF2
	DW 0x20EC	
	DW 0xECF2
	DW 0xECF2
	DW 0x20EC	
	DW 0xECF2
	DW 0xECF2
	
	END