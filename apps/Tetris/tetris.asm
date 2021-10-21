;Seiko UC-2000
;Tetris game
;azya, 2017

        ##define brdAdr RA2    
        ##define brdValTop RA3    
        ##define brdValBtm RA4    
        ##define ind RA5    
        ##define drawLine RA6
        ##define appState RA7
        
        ##define curLine RB0
        ;9, 10
        ##define preLine RB3
        ##define scoresL RB4
        ;13, 14
        ##define scoresH RB7
        
        ##define piceAngle RC0
        ##define piceNum RC1
        ##define piceSelecter RC2
        ##define piceShift RC3
        ##define scoresAddL RC4
        ;21;22
        ##define scoresAddH RC7
        ##define curPosL RC4
        ##define curPosH RC5
        
        ##define piceLn0t RD0
        ##define piceLn0b RD1
        ##define piceLn1t RD2
        ##define piceLn1b RD3
        ##define piceLn2t RD4
        ##define piceLn2b RD5
        ##define piceLn3t RD6
        ##define piceLn3b RD7
        
        ##define brdAdr2b ((board >> 8) & 0x0F)
        ##define brdAdr1b ((board >> 4) & 0x0F)
        ##define brdAdr0b (board & 0x0F)
        
        ##define picesAdr2b ((pices >> 8) & 0x0F)
        ##define picesAdr1b ((pices >> 4) & 0x0F)
        ##define picesAdr0b (pices & 0x0F)
    
        JMP start        ;start prog
        JMP timer
        JMP 0x11A
        JMP 0x109
        JMP 0x0E0
        JMP btn_mode    ;btn mode
        JMP btn_transm    ;btn transm
        JMP btn_right    ;btn right
        JMP btn_left    ;btn left
        JMP 0x2A9
        JMP 0x307
        JMP 0x39C
        JMP 0x09B
        JMP update_screen
        RET

start:
        CLRM RB1, RB3%8
        LDI RB2, 0b1111
        LCRB B2
        LDI appState, 1
        JMP 0x227
    
btn_mode:
        CPJR RB3, 0, btn_mode_startapp
        CLRM RB1, RB3%8
        JMP 0x243
    btn_mode_startapp:
        LDI RB3, 8
        LDI RB1, 1
        JMP 0x243

btn_transm:
        LARB B3
        LCRB B2
        ADI piceAngle, 4
        JMP update_screen
    
btn_right:
        LARB B3
        LCRB B2
        CPJR appState, 2, btn_right_c1
        CALL prepareNewGame
        JMP 0x2DF
    btn_right_c1:
        INC piceShift, piceShift%8
        JMP 0x2DF
    
btn_left:
        LARB B3
        LCRB B2
        DEC piceShift, piceShift%8
        JMP 0x383
    
timer:
        LARB B3
        LCRB B2
        CPJR appState, 2, timer_draw
        CPJR appState, 3, timer_clear_lines_screen
        JMP 0x190
    timer_clear_lines_screen:
        LDI appState, 2
        JMP update_screen
    timer_draw:
        INC curLine, curLine%8
        JMP update_screen
    
update_screen:
        LARB B3
        LCRB B2
        CPJR appState, 2, update_screen_draw
        PLAI 125            ;clear
        STLI 0                ;screen
        CPJR appState, 0, update_screen_gover
        CPJR appState, 3, update_screen_clear_lines
    update_screen_start:
        PLAI 12
        PSAI dsTETRIS
        CALL OS_PRINT0-6
        JMP 0x98F
    update_screen_gover:
        PLAI 10
        PSAI dsGAMEOVER
        CALL OS_PRINT0-10
        JMP update_screen_print_scores
    update_screen_clear_lines:
        PLAI 10
        PSAI dsScore
        CALL OS_PRINT0-8
        STL scoresAddL+1
        STL scoresAddL
        PSAI dsTotal
    update_screen_print_scores:
        CALL OS_PRINT0-6
        STL scoresH
        STL scoresH-1
        STL scoresH-2
        STL scoresL
        JMP 0x98F
    update_screen_draw:
        CALL updatePice
        CALL draw
        JMP 0x98F

prepareNewGame:
        CALL OS_CLRCB
        LDI appState, 2
         LDI brdAdr, brdAdr2b
        LDI brdAdr-1, brdAdr1b
        LDI brdAdr-2, brdAdr0b
        PSAM brdAdr-2, brdAdr%8    
        CLRM scoresL, scoresH%8
        CLRM brdValTop, brdValBtm%8
        LDI ind, 10
    prepareNewGame_loop:
        STSM brdValTop, brdValBtm%8
        DEC ind, ind%8
        JNC prepareNewGame_loop
        
prepareNewPice:
        CLRM curLine, preLine%8
        LDI piceShift, 2
    prepareNewPice_random:
          IN piceAngle, 14
        ADD piceNum, piceAngle
        CPI piceNum, 7
        JNC prepareNewPice_random
        LDI piceAngle, 0
        CMP scoresAddL, scoresAddL+1
        JZ updatePice
        ADBM scoresL, scoresAddH
        LDI appState, 3
        JMP update_screen
    
updatePice:
        LDI brdAdr, picesAdr2b
        LDI brdAdr-1, picesAdr1b
        LDI brdAdr-2, picesAdr0b
        ADM brdAdr-2, piceSelecter
        PSAM brdAdr-2, brdAdr%8    
        LDSM piceLn0t, piceLn0b%8
        LDSM piceLn1t, piceLn1b%8
        LDSM piceLn2t, piceLn2b%8
        LDSM piceLn3t, piceLn3b%8
    
shiftPice:
        MOV ind, piceShift
    shiftPice_loop:
        CPJR ind, 0, shiftPice_end
        ADM piceLn0t, piceLn3b
        BTJR piceLn1t, 0, +4
        BTJR piceLn2t, 0, +3
        BTJR piceLn3t, 0, +2
        DEC ind, ind%8
        JMP shiftPice_loop
        JMP processCollision    
    shiftPice_end:
  
        CPI preLine, 15
        JNZ checkCollision
storePice:
        LDI brdAdr, brdAdr2b
        LDI brdAdr-1, brdAdr1b
        LDI brdAdr-2, brdAdr0b
        ADM brdAdr-2, curLine+2
        CLRM scoresAddL, scoresAddH%8
    
        LDI ind, 3
    storePice_loop:
        PSAM brdAdr-2, brdAdr%8    
        LDSM brdValTop, brdValBtm%8
        
        XORI piceLn0t, 0xF
        XORI piceLn0b, 0xF
        BTJR piceLn0t, 0, +1
        ORI brdValTop, 1
        BTJR piceLn0t, 1, +1
        ORI brdValTop, 2
        BTJR piceLn0t, 2, +1
        ORI brdValTop, 4
        BTJR piceLn0t, 3, +1
        ORI brdValTop, 8
        BTJR piceLn0b, 0, +1
        ORI brdValBtm, 1
        BTJR piceLn0b, 1, +1
        ORI brdValBtm, 2
        BTJR piceLn0b, 2, +1
        ORI brdValBtm, 4
        BTJR piceLn0b, 3, +1
        ORI brdValBtm, 8
        
        PSAM brdAdr-2, brdAdr%8    
        STSM brdValTop, brdValBtm%8
        
        ;удаляем заполненные линии
        CMP piceLn0t, piceLn0b
        JZ storePice_loop2_end
        CPI brdValTop, 0xF
        JNZ storePice_loop2_end
        CPI brdValBtm, 0xF
        JNZ storePice_loop2_end
        MVACM brdAdr-2, brdAdr%8
        ADBM scoresAddL, scoresAddH
        INCB scoresAddL, scoresAddH%8
    storePice_loop2:
        DEC brdAdr-2, brdAdr%8
        PSAM brdAdr-2, brdAdr%8    
        LDSM brdValTop, brdValBtm%8
        STSM brdValTop, brdValBtm%8
        CPJR brdValBtm, 0, +1
        JMP storePice_loop2
        CPJR brdValTop, 0, +1
        JMP storePice_loop2
        MVCAM brdAdr-2, brdAdr%8
    storePice_loop2_end:
      
        LSHM piceLn3b, 0
        LSHM piceLn3b, 0
        
        INC brdAdr-2, brdAdr%8
        DEC ind, ind%8
        JNC storePice_loop
    
        JMP prepareNewPice
    
checkCollision:
        LDI brdAdr, brdAdr2b
        LDI brdAdr-1, brdAdr1b
        LDI brdAdr-2, brdAdr0b
        ADM brdAdr-2, curLine+2
        PSAM brdAdr-2, brdAdr%8    
        
        MVACM piceLn0t, piceLn3b
        LDI ind, 4
    checkCollision_loop:
        LDSM brdValTop, brdValBtm%8
       
    checkCollision_loop2:
        CMP piceLn0t, piceLn0b
        JZ checkCollision_end2
        ADM piceLn0t, piceLn0b
        JC checkCollision_compare
        ADM brdValTop, brdValBtm
        JMP checkCollision_loop2
    checkCollision_compare:
        ADM brdValTop, brdValBtm
        JC processCollision
        JMP checkCollision_loop2
    checkCollision_end2:
        
        LSHM piceLn3b, 0
        LSHM piceLn3b, 0
        DEC ind, ind%8
        JNZ checkCollision_loop
        MVCAM piceLn0t, piceLn3b    
        
        MVACM piceAngle, piceShift     ;сохраняем валидную
        MOV preLine, curLine           ;позицию фигуры
        RET

processCollision:
        CPJR curLine, 0, gameOver
        CMP curLine, preLine
        JZ processCollision_pre
        MOV curLine, preLine           ;восстанавливаем валидную позицию фигуры
        LDI preLine, 15                ;маркер, что фигура уперлась в пол и нужна новая
    processCollision_pre:
        MVCAM piceAngle, piceShift     ;восстанавливаем валидную позицию фигуры
        JMP updatePice

gameOver:
        LDI appState, 0
        JMP update_screen
  
draw:
        plai 0x74                      ;disable
        stli 1                         ;redraw
        LDI brdAdr, brdAdr2b
        LDI brdAdr-1, brdAdr1b
        LDI brdAdr-2, brdAdr0b
        PSAM brdAdr-2, brdAdr%8
        MVAC curLine, curLine
        LDI curPosL, 0xE
        LDI curPosH, 0x1
    
        LDI ind, 0
    draw_loop2:
        LDSM brdValTop, brdValBtm%8
        
        CMP curLine, ind
        JNZ draw_ORend
        XORI piceLn0b, 0xF
        XORI piceLn0t, 0xF
        BTJR piceLn0b, 0, +1
        ORI brdValBtm, 1
        BTJR piceLn0b, 1, +1
        ORI brdValBtm, 2
        BTJR piceLn0b, 2, +1
        ORI brdValBtm, 4
        BTJR piceLn0b, 3, +1
        ORI brdValBtm, 8
        BTJR piceLn0t, 0, +1
        ORI brdValTop, 1
        BTJR piceLn0t, 1, +1
        ORI brdValTop, 2
        BTJR piceLn0t, 2, +1
        ORI brdValTop, 4
        BTJR piceLn0t, 3, +1
        ORI brdValTop, 8
        LSHM piceLn3b, 0
        LSHM piceLn3b, 0
        CMP piceLn0t, piceLn0b
        JZ draw_ORend
        INC curLine, curLine%8  
    draw_ORend:
   
        CPJR ind, 0, draw_b1
    draw_loop3:
        PLAM curPosL, curPosH%8
        BTJR brdValBtm, 2, +5
        BTJR brdValBtm, 3, +2
        STLI 0x20
        JMP draw_else2
        STLI 0xE8
        JMP draw_else2
        BTJR brdValBtm, 3, +2
        STLI 0xE7
        JMP draw_else2
        STLI 0xFF
    draw_else2:    
        ADM brdValTop, brdValBtm
        ADM brdValTop, brdValBtm
        SBI curPosL, 0xA
        JNC draw_loop3
        DEC curPosH, curPosH%8
        JNC draw_loop3
    
        LDI curPosH, 0x1
        ADI curPosL, 0x9
        JNC draw_b1
        INC curPosH, curPosH%8
    draw_b1:
        INC ind, ind%8
        CPI ind, 11
        JNZ draw_loop2

        MVCA curLine, curLine
        stlia 0x74                ;enable redraw
        RET
    
dsTETRIS:
        DS "TETRIS"
        
dsGAMEOVER:
        DS "GAME OVER!"
        
dsScore:
        DS "Score  +"
        
dsTotal:
        DS "Total "
    
board:
        DB 0b00000000
        DB 0b00000000
        DB 0b00000000
        DB 0b00000000
        DB 0b00000000
        DB 0b00000000
        DB 0b00000000
        DB 0b00000000
        DB 0b00000000
        DB 0b00000000
        DB 0b00000000
        DB 0b11111111
    
pices:
        DB 0b00000000 ;o1
        DB 0b00000011
        DB 0b00000011
        DB 0b00000000
        DB 0b00000000 ;o2
        DB 0b00000011
        DB 0b00000011
        DB 0b00000000
        DB 0b00000000 ;o3
        DB 0b00000011
        DB 0b00000011
        DB 0b00000000
        DB 0b00000000 ;o4
        DB 0b00000011
        DB 0b00000011
        DB 0b00000000
        DB 0b00000000 ;I1
        DB 0b00001111
        DB 0b00000000
        DB 0b00000000
        DB 0b00000001 ;I2
        DB 0b00000001
        DB 0b00000001
        DB 0b00000001
        DB 0b00000000 ;I1
        DB 0b00001111
        DB 0b00000000
        DB 0b00000000
        DB 0b00000001 ;I2
        DB 0b00000001
        DB 0b00000001
        DB 0b00000001
        DB 0b00000000 ;s1
        DB 0b00000011
        DB 0b00000110
        DB 0b00000000
        DB 0b00000010 ;s2
        DB 0b00000011
        DB 0b00000001
        DB 0b00000000
        DB 0b00000000 ;s3
        DB 0b00000011
        DB 0b00000110
        DB 0b00000000
        DB 0b00000010 ;s4
        DB 0b00000011
        DB 0b00000001
        DB 0b00000000
        DB 0b00000000 ;z1
        DB 0b00000110
        DB 0b00000011
        DB 0b00000000
        DB 0b00000001 ;z2
        DB 0b00000011
        DB 0b00000010
        DB 0b00000000
        DB 0b00000000 ;z3
        DB 0b00000110
        DB 0b00000011
        DB 0b00000000
        DB 0b00000001 ;z4
        DB 0b00000011
        DB 0b00000010
        DB 0b00000000
        DB 0b00000000 ;L1
        DB 0b00000111
        DB 0b00000100
        DB 0b00000000
        DB 0b00000010 ;L2
        DB 0b00000010
        DB 0b00000011
        DB 0b00000000 
        DB 0b00000001 ;L3
        DB 0b00000111
        DB 0b00000000
        DB 0b00000000
        DB 0b00000011 ;L4
        DB 0b00000001
        DB 0b00000001
        DB 0b00000000
        DB 0b00000000 ;J1
        DB 0b00000111
        DB 0b00000001
        DB 0b00000000
        DB 0b00000001 ;J2
        DB 0b00000001
        DB 0b00000011
        DB 0b00000000 
        DB 0b00000100 ;J3
        DB 0b00000111
        DB 0b00000000
        DB 0b00000000
        DB 0b00000011 ;J4
        DB 0b00000010
        DB 0b00000010
        DB 0b00000000
        DB 0b00000000 ;T1
        DB 0b00000111
        DB 0b00000010
        DB 0b00000000
        DB 0b00000010 ;T2
        DB 0b00000011
        DB 0b00000010
        DB 0b00000000 
        DB 0b00000010 ;T3
        DB 0b00000111
        DB 0b00000000
        DB 0b00000000
        DB 0b00000001 ;T4
        DB 0b00000011
        DB 0b00000001
        DB 0b00000000