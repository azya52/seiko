;Seiko UC-2000
;6 watch faces
;azya, 2017

#//BANK 3
##define drawBitStyle RB4
##define currentFace RB7

##define curPosL RC0    
##define curPosH RC1

##define drawValue RD0
##define drawValueH RD1

##define sadrL RA0
##define sadrM RA1
##define sadrH RA2

##define adderL RB0
##define adderM RB1
##define adderH RB2

#//BANK 1
##define btnPressed RD1

##define onesAdr2 ((ones >> 8) & 0x0F)
##define onesAdr1 ((ones >> 4) & 0x0F)
##define onesAdr0 (ones & 0x0F)

##define tensAdr2 ((tens >> 8) & 0x0F)
##define tensAdr1 ((tens >> 4) & 0x0F)
##define tensAdr0 (tens & 0x0F)

##define teensAdr2 ((teens >> 8) & 0x0F)
##define teensAdr1 ((teens >> 4) & 0x0F)
##define teensAdr0 (teens & 0x0F)

##define bigDigitAdr2 ((bigDigit >> 8) & 0x0F)
##define bigDigitAdr1 ((bigDigit >> 4) & 0x0F)
##define bigDigitAdr0 (bigDigit & 0x0F)

##define veryBigDigitAdr2 ((veryBigDigit >> 8) & 0x0F)
##define veryBigDigitAdr1 ((veryBigDigit >> 4) & 0x0F)
##define veryBigDigitAdr0 (veryBigDigit & 0x0F)

##define dayOfWeekAdr2 ((dayOfWeek >> 8) & 0x0F)
##define dayOfWeekAdr1 ((dayOfWeek >> 4) & 0x0F)
##define dayOfWeekAdr0 (dayOfWeek & 0x0F)

##define monthAdr2 ((month >> 8) & 0x0F)
##define monthAdr1 ((month >> 4) & 0x0F)
##define monthAdr0 (month & 0x0F)
    
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

start:
        CLRM RB1, RB3%8
        LDI RB2, 0b1110
        LCRB B0
        LDI RB4, 2
        JMP 0x227
    
btn_mode:
        IN btnPressed, SR8
        BTJR btnPressed, 1, change_face
        CALL check_watch_screen
        JMP 0x243
    
change_face:
        LCRB B3
        INC currentFace, currentFace%8
        CPI currentFace, 7
        JC redraw
        LDI currentFace, 0
        JMP redraw

btn_transmit:
        CALL check_watch_screen
        JMP 0x283

check_watch_screen:
        LARB B0
        LDI RB2, 0b1110
        MVCA RB3,RB4
        CPI RB3, 0
        JZ btn_mode_startapp
        LDI RB3, 0b0000
        RET
    btn_mode_startapp:
        LDI RB3, 0b1000
        JMP redraw

tick:
        LCRB B3
        LARB B0    
        MVCAM RB5, RB6

        CPI RB5, 0
        JNZ tick_face
        CPI RB6, 0
        JZ redraw

tick_face:
        IJMR currentFace
        JMP seconds_face0
        JMP seconds_bigHour
        JMP 0x98F
        JMP seconds_face1
        JMP seconds_face2
        JMP 0x98F
        JMP 0x190
    
redraw:
        LCRB B3
        LARB B0    
        PLAI 125                            ;clear
        CALL OS_PRINTZERO0-2                ;screen
        IJMR currentFace
        JMP redraw_face0
        JMP redraw_bigHour
        JMP redraw_bigHourMinute
        JMP redraw_face1
        JMP redraw_face2
        JMP redraw_face3
        LCRB B0
        JMP OS_PRINTWATCH
    
;
; face big style
;
redraw_face0:
        ;hours
        MVCA drawValue, RA2
        CPI drawValue,10
        JC redraw_face0_less0
        PLAI 0                          ;draw
        STLI 0xEE                      
        PLAI 10                         
        STLI 0xE6                     
        PLAI 20                         
        STLI 0xEA                       ;one
        SBI drawValue, 10
    redraw_face0_less0:
        LDI curPosL, 1
        CALL drawBigDigit
        
        ;dots
        PLAI 3
        STLI 0xED
        PLAI 23
        STLI 0xE9
        
        ;minutes
        MVCA drawValue,RA1
        LDI curPosL, 4
        CALL drawBigDigit
            
        MVCA drawValue,RA0
        LDI curPosL, 6
        CALL drawBigDigit
    
        ;dayOfWeek
        PLAI 30
        MVCA drawValue, RA7
        CALL drawDayOfWeek
        STLI ','
        
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
        JNC seconds_face0_nc0
        INC drawValue+1, (drawValueH)%8
    seconds_face0_nc0:
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
        LDI adderL, 6
        CALL posToText    
        
        LDI curPosH, 0
        LDI drawValue, 3
    drawBigDigit_loop0:
        PLAM curPosL, curPosH%8
        CALL OS_PRINT0-2
        ADI curPosL, 10
        JNC drawBigDigit_nc0
        INC curPosH, curPosH%8
    drawBigDigit_nc0:
        DEC drawValue, drawValue%8
        JNZ drawBigDigit_loop0
        RET
    
drawDayOfWeek:
        LDI sadrH, dayOfWeekAdr2
        LDI sadrM, dayOfWeekAdr1
        LDI sadrL, dayOfWeekAdr0
        LDI adderL, 9
        CALL posToText    
        JMP OS_PRINT0-3
    
drawMonth:
        LDI sadrH, monthAdr2
        LDI sadrM, monthAdr1
        LDI sadrL, monthAdr0
        LDI adderL, 3
        DEC drawValue, drawValue%8
        CALL posToText    
        JMP OS_PRINT0-3

;
; face big hour
;
redraw_bigHour:
        ;hours
        CALL convert12HEXto24DEC
        LDI curPosL, 4
        CALL drawVeryBigDigit
        
        MOV drawValue, drawValueH
        LDI curPosL, 1
        CALL drawVeryBigDigit
        
        ;minutes
        MVCA drawValue,RA1
        LDI drawValueH, 8    
        ADD drawValue,drawValue
        PLAI 7
        STLM drawValue, (drawValueH)%8
        PLAI 17
        INC drawValue, (drawValueH)%8
        STLM drawValue, (drawValueH)%8
        
        MVCA drawValue,RA0
        ADD drawValue,drawValue
        JNC redraw_bigHour_nc0
        INC drawValue+1, (drawValueH)%8
    redraw_bigHour_nc0:
        PLAI 8
        STLM drawValue, (drawValueH)%8
        PLAI 18
        INC drawValue, (drawValueH)%8
        STLM drawValue, (drawValueH)%8
    
seconds_bigHour:
        ;seconds
        PLAI 27
        MVCA drawValue,RB6
        STL drawValue        
        MVCA drawValue,RB5
        STL drawValue
    
        JMP 0x98F

drawVeryBigDigit:
        LDI sadrH, veryBigDigitAdr2
        LDI sadrM, veryBigDigitAdr1
        LDI sadrL, veryBigDigitAdr0
        LDI adderL, 12
        CALL posToText    
        
        LDI curPosH, 0
        LDI drawValue, 4
    drawVeryBigDigit_loop0:
        PLAM curPosL, curPosH%8
        CALL OS_PRINT0-3
        ADI curPosL, 10
        JNC drawVeryBigDigit_nc0
        INC curPosH, curPosH%8
    drawVeryBigDigit_nc0:
        DEC drawValue, drawValue%8
        JNZ drawVeryBigDigit_loop0
        RET
        
;
; face big hour & minute
;
redraw_bigHourMinute:
        ;hours
        MVCA drawValue, RA2
        CPI drawValue,10
        JC redraw_bigHour_less0
        PLAI 0                          ;draw
        STLI 0x82                       ;small
        PLAI 10                         
        STLI 0x83                       ;one
        SBI drawValue, 10
    redraw_bigHour_less0:
        LDI curPosL, 1
        CALL drawVeryBigDigit
        
        ;minutes
        MVCA drawValue,RA1
        LDI curPosL, 4
        CALL drawVeryBigDigit
        
        MVCA drawValue,RA0
        LDI curPosL, 7
        CALL drawVeryBigDigit
     
        JMP 0x98F
        
;
; face BCD
;
redraw_face1:
        LDI drawBitStyle, 0
        ;hours
        CALL convert12HEXto24DEC
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
        CALL draw_bit0
        STLI 0x83
        PLAI 25
        CALL draw_bit1
        STLI 0x83
        PLAI 15
        CALL draw_bit2
        STLI 0x83
        PLAI 5
        CALL draw_bit3
        STLI 0x83

seconds_face1:
        ;seconds
        MVCA drawValue,RB6
        PLAI 17
        CALL draw_bit2
        PLAI 27
        CALL draw_bit1
        PLAI 37
        CALL draw_bit0
        
        MVCA drawValue,RB5
        CALL draw_bit0
        PLAI 28
        CALL draw_bit1
        PLAI 18
        CALL draw_bit2
        PLAI 8
        CALL draw_bit3

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
        IJMR drawBitStyle
        STLI 0xDB
        RET
        STLI 0xDF
        RET
        STLI 0xA1
        RET
    
draw_bit_set:
        IJMR drawBitStyle
        STLI 0xFF
        RET
        STLI 0xE9
        RET
        STLI 0xED
        RET
        
convert12HEXto24DEC:
        MVCA drawValue, RA2
        CPI drawValue, 12
        JNZ convert12HEXto24DEC_neq0
        LDI drawValue, 0
    convert12HEXto24DEC_neq0:    
        LDI drawValueH, 0
        INCB drawValue, drawValueH%8                    ;convert
        DECB drawValue, drawValueH%8                    ;hex to dec
    convert12HEXto24DEC_less0:
        MVCA adderM, RA3
        CPJR adderM, 0, convert12HEXto24DEC_eq0
        LDI adderL, 2
        ADBM drawValue, adderM
    convert12HEXto24DEC_eq0:        
        RET
        
;
; face Binary
;
redraw_face2:
        LDI drawBitStyle, 0
        ;hours
        CALL convert12HEXto24DEC
        PLAI 14
        CALL face2_draw_4bits
        PLAI 13
        CALL draw_bit0
    
        ;minutes
        MVCAM drawValue, RA1
        PLAI 24
        CALL face2_draw_4bits
        PLAI 22
        CALL face2_draw_2bits
        
        ;date
        LDI drawBitStyle, 2
        MVCA drawValueH,RA5
        MVCA drawValue,RA4
        PLAI 4
        CALL face2_draw_4bits
        PLAI 3
        CALL draw_bit0
    
seconds_face2:
        ;seconds
        LDI drawBitStyle, 4
        MVCA drawValueH,RB6
        MVCA drawValue,RB5
        PLAI 34
        CALL face2_draw_4bits
        PLAI 32
        CALL face2_draw_2bits
        
        JMP 0x98F

face2_draw_4bits:
        CALL dec2hex
        CALL draw_bit3
        CALL draw_bit2
face2_draw_2bits:
        CALL draw_bit1
        CALL draw_bit0
        MOV drawValue, drawValueH
        RET
        
dec2hex:
        CLRM adderL, adderH%8
        
    dec2hex_loop0:
        CPJR drawValueH, 0, dec2hex_end
        DEC drawValueH, drawValueH%8
        ADI adderL, 0xA
        JNC dec2hex_loop0
        INC adderM, adderM%8
        JMP dec2hex_loop0
        
    dec2hex_end:
        ADM drawValue, adderM
        RET

;
; face Text Time
;
redraw_face3:
        PLAI 125                            ;clear
        CALL OS_PRINTZERO0-2                ;screen
        
        ;hours
        PLAI 11
        MVCA drawValue, RA2
        CPI drawValue, 10
        JC redraw_face3_less0
        SBI drawValue, 10
        CALL drawTextTimeTeens
        JMP redraw_face3_minutes
    redraw_face3_less0:
        CALL drawTextTimeOnes
      
    redraw_face3_minutes:
        ;minutes
        MVCA drawValue,RA1
        PLAI 21
        CPI drawValue, 0
        JZ redraw_face3_str1
        CPI drawValue, 2
        JC redraw_face3_str1ten
        SBI drawValue, 2
        CALL drawTextTimeTens
        MVCA drawValue,RA0
        CPI drawValue, 0
        JNZ redraw_face3_str2ones
        JMP redraw_face3_end0
    redraw_face3_str1ten:
        MVCA drawValue,RA0
        CALL drawTextTimeTeens
        JMP redraw_face3_end0
    redraw_face3_str1:
        MVCA drawValue,RA0
        STLI 'O'
        CPI drawValue, 0
        JNZ redraw_face3_oh
        STLI '\''        
        JMP redraw_face3_str2
    redraw_face3_oh:
        STLI 'H'
    redraw_face3_str2ones:
        PLAI 31
    redraw_face3_str2:
        CALL drawTextTimeOnes
    redraw_face3_end0:
        
        ;dayOfWeek
        PLAI 1
        MVCA drawValue, RA7
        CALL drawDayOfWeek
        CALL OS_PRINT0-6
        
        JMP 0x98F
    
drawTextTimeTeens:
        LDI sadrH, teensAdr2
        LDI sadrM, teensAdr1
        LDI sadrL, teensAdr0
        LDI adderL, 9
        CALL posToText    
        JMP OS_PRINT0-9
    
drawTextTimeTens:
        LDI sadrH, tensAdr2
        LDI sadrM, tensAdr1
        LDI sadrL, tensAdr0
        LDI adderL, 7
        CALL posToText
        JMP OS_PRINT0-7
    
drawTextTimeOnes:
        LDI sadrH, onesAdr2
        LDI sadrM, onesAdr1
        LDI sadrL, onesAdr0
        LDI adderL, 5
        CALL posToText
        JMP OS_PRINT0-5
        
posToText:
        CLRM adderL+1, adderH%8
    drawTextTime_loop0:
        CPJR drawValue, 0, drawTextTime_loop0_end
        ADM sadrL, adderH
        DEC drawValue, drawValue%8
        JMP drawTextTime_loop0
    drawTextTime_loop0_end:
        PSAM sadrL,sadrH%8
        RET
    
bigDigit:
        DB 0xF5, 0xEE    ;0
        DB 0xE6, 0xE6    ;0
        DB 0xF3, 0xEA    ;0
        DB 0x20, 0xEE    ;1
        DB 0x20, 0xE6    ;1
        DB 0x20, 0xEA    ;1
        DB 0xF5, 0xEE    ;2
        DB 0xF5, 0xEA    ;2
        DB 0xF3, 0xEA    ;2
        DB 0xF5, 0xEE    ;3
        DB 0xFA, 0xE6    ;3
        DB 0xF3, 0xEA    ;3
        DB 0xEE, 0xEE    ;4
        DB 0xF3, 0xE6    ;4
        DB 0x20, 0xEA    ;4    
        DB 0xF5, 0xEE    ;5
        DB 0xF3, 0xEE    ;5
        DB 0xF3, 0xEA    ;5
        DB 0xF5, 0xEE    ;6
        DB 0xFE, 0xEE    ;6
        DB 0xF3, 0xEA    ;6
        DB 0xF5, 0xEE    ;7
        DB 0x20, 0xE6    ;7
        DB 0x20, 0xEA    ;7    
        DB 0xF5, 0xEE    ;8
        DB 0xFE, 0xE6    ;8
        DB 0xF3, 0xEA    ;8
        DB 0xF5, 0xEE    ;9
        DB 0xF3, 0xE6    ;9
        DB 0xF3, 0xEA    ;9
        
veryBigDigit:
        DB 0xFF, 0xE7, 0xE6    ;0
        DB 0xFF, 0x20, 0xE6    ;0
        DB 0xFF, 0x20, 0xE6    ;0
        DB 0xFF, 0xE8, 0xE6    ;0
        DB 0xEB, 0xFF, 0x20    ;1
        DB 0x20, 0xFF, 0x20    ;1
        DB 0x20, 0xFF, 0x20    ;1
        DB 0x20, 0xFF, 0x20    ;1
        DB 0xFF, 0xE7, 0xE6    ;2
        DB 0xE8, 0xE8, 0xE6    ;2
        DB 0xFF, 0x20, 0x20    ;2
        DB 0xFF, 0xE8, 0xED    ;2
        DB 0xFF, 0xE7, 0xE6    ;3
        DB 0x20, 0xE8, 0xEA    ;3
        DB 0x20, 0x20, 0xE6    ;3
        DB 0xFF, 0xE8, 0xE6    ;3
        DB 0xFF, 0x20, 0xE6    ;4
        DB 0xFF, 0xE8, 0xE6    ;4
        DB 0x20, 0x20, 0xE6    ;4
        DB 0x20, 0x20, 0xE6    ;4
        DB 0xFF, 0xE7, 0xE9    ;5
        DB 0xFF, 0xE8, 0xED    ;5
        DB 0x20, 0x20, 0xE6    ;5
        DB 0xFF, 0xE8, 0xE6    ;5
        DB 0xFF, 0xE7, 0xEA    ;6
        DB 0xFF, 0xE8, 0xED    ;6
        DB 0xFF, 0x20, 0xE6    ;6
        DB 0xFF, 0xE8, 0xE6    ;6
        DB 0xFF, 0xE7, 0xE6    ;7
        DB 0x20, 0xEF, 0xEA    ;7
        DB 0x20, 0xFF, 0x20    ;7
        DB 0x20, 0xFF, 0x20    ;7
        DB 0xFF, 0xE7, 0xE6    ;8
        DB 0xFF, 0xE8, 0xE6    ;8
        DB 0xFF, 0x20, 0xE6    ;8
        DB 0xFF, 0xE8, 0xE6    ;8
        DB 0xFF, 0xE7, 0xE6    ;9
        DB 0xFF, 0xE8, 0xE6    ;9
        DB 0x20, 0x20, 0xE6    ;9
        DB 0xFF, 0xE8, 0xE6    ;9
            
dayOfWeek:
        DS "SUNDAY   MONDAY   TUESDAY  WEDNESDAYTHURSDAY FRIDAY   SATURDAY "
month:
        DS "JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
ones:
        DS "CLOCKONE  TWO  THREEFOUR FIVE SIX  SEVENEIGHTNINE "
teens:
        DS "TEN      ELEVEN   TWELVE   THIRTEEN FOURTEEN FIFTEEN  SIXTEEN  SEVENTEENEIGHTEEN NINETEEN "
tens: 
        DS "TWENTY THIRTY FORTY  FIFTY  SIXTY  SEVENTYEIGHTY NINETY "
