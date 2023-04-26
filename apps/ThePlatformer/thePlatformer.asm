    ;The Platformer
    ;Game for Seiko UC-2000
    ;azya, 2023

    ##define jumpFrame RA0
    ;Order matters
    ##define hopmanPlatformLevel RA1
    ##define jumpAdder RA2
    ##define curPlatforms RA3
    ##define platformCharLevel3L RA4
    ##define platformCharLevel3H RA5
    ##define footCharL RA6
    ##define footCharH RA7

    ;RB0-RB7 temp variables
    ##define buttonsState RB7
    
    ;RC0-RC3 top-level temp variables
    ##define stage RC4
    ##define gameFlags RC5
    ##define failFlags RC6
    ##define fails RC7

    ##define scoresL RD0
    ##define scoresM RD1
    ##define scoresH RD2
    ##define gameCounter RD4
    ##define platformsPtrL RD5
    ##define platformsPtrM RD6
    ##define platformsPtrH RD7

    ##define beepOff 3
    ##define showHopman 0

    ##define strFinish strFinishLevel3 - 9

    ##define clearScreen 0x7D
    ##define resetScanline 0x7F
    ##define drawMode 0x77
    
    ##define tremoloOn 0b0100
    ##define tremoloOff 0b0010
    ##define beep 0b0001

    ##define btnMode 3
    ##define btnTransmit 2
    ##define btnRight 1
    ##define btnLeft 0

    ;embedded subroutines
    ##define clearCurrentBank 0x8F2
    ##define enableAutoRedraw 0x7EF
    ##define print4RAMBytes 0xBD0 - 4
    ##define print5RAMBytes 0xBD0 - 5
    ##define print6RAMBytes 0xBD0 - 6
    ##define print7RAMBytes 0xBD0 - 7
    ##define print10RAMBytes 0xBD0 - 10

    jmp start
    jmp 0x190
    jmp 0x11A
    jmp 0x109
    jmp 0x0E0
    jmp 0x243
    jmp 0x283
    jmp 0x2DF
    jmp 0x383
    jmp 0x2A9
    jmp 0x307
    jmp 0x39C
    jmp 0x09B
    jmp 0x98F
    ret


gameOver:

saveTop:
    psai topScores
    ldsm RB0, RB2 % 8
    cpm scoresL, RB2
    jc saveTopEnd
    psai topScores
    stsm scoresL, scoresH % 8
saveTopEnd:

    stlia clearScreen
    plai 13
    call print4RAMBytes
    plai 23
    call print4RAMBytes
    call delaySecondWith7F

    plai 12
    call print6RAMBytes
    plai 23
    stli '0'
    call printScores
    stlia resetScanline
    call waitStartKey


start:
    stlia 0x78           ;disable auto redraw
    outi SR13, 0b0110    ;Timer0 1/32 s. and 1 s. enable

    lcrb B3
    larb B0

drawStartScreen:
    stlia clearScreen
    plai 30
    psai topScores
    ldsm scoresL, scoresH % 8
    call printScores
    plai 35
    psai strStart
    call print5RAMBytes

    stlia resetScanline
    ldi RB6, 6
    ldi RB7, 2

drawStartLoop:
    stli 0x00           ;switch to text mode
drawStartLine:
    stlia drawMode      ;switch to direct grahpic mode

drawStartLoopStart:
    stlsa 0             ;copy bitmap bytes to LCD memory
    stlsa 0             ;10 bytes for one scan line
    stlsa 0             ;the least significant 5 bits from each byte are used
    stlsa 0             ; 
    stlsa 0             ; 
    stlsa 0             ; 
    stlsa 0             ; 
    stlsa 0             ; 
    stlsa 0             ; 
    stlsa 0             ; 

    plai drawMode

    dec RB6, RB6 % 8
    jnz drawStartLoop

    stli 0x00           ;switch to text mode

    ldi RB6, 7
    dec RB7, RB7 % 8
    jnz drawStartCheckExit

    ;32 cycles delay
    ldi RB6, 3
    ldi RB0, 15
drawStartSkipLine:
    dec RB0, RB0 % 8
    jnz drawStartSkipLine

drawStartCheckExit:
    jnc drawStartLine
    call waitStartKey


prepareGame:
    call clearCurrentBank

    ldi platformCharLevel3H, 0xE
    
    mvca gameFlags, RC5
    xori gameFlags, 1 << beepOff

    ldi platformsPtrL, (platforms * 2) & 0x0F
    ldi platformsPtrM, ((platforms * 2) >> 4) & 0x0F
    ldi platformsPtrH, ((platforms * 2) >> 8) & 0x0F


nextStage:
    incb stage, stage % 8
    jc prepareGame
    ldi hopmanPlatformLevel, 1
    ldi fails, 0
    stlia clearScreen
    plai 11
    psai strStage
    call print6RAMBytes
    stl stage
    call delaySecondWith7F
    btjr buttonsState, btnTransmit, nextStageSelect
    cpjr buttonsState, 0, nextStageGoStart
    cpi stage, 9
    jnz startRun
    plai 21
    call print7RAMBytes
    call delaySecondWith7F
nextStageGoStart:
    jmp startRun
nextStageSelect:
    inc platformsPtrL, platformsPtrH % 8
    psam platformsPtrL, platformsPtrH % 8
    ldsm RB0, RB0 % 8
    btjr RB0, 3, +1
    jmp nextStage
    jmp nextStageSelect


fail:
    ldi RC0, 5
    ldi RC1, 0xF
failBlinkLoop:
    xori RC1, 0xE
    add fails, RC1
    ldi RB0, 3
    call delayToRB0
failBeep:
    btjr gameFlags, beepOff, failBeepSkip
    outi SR15, tremoloOn
failBeepSkip:
    call drawBlink
    outi SR15, tremoloOff
    dec RC0, RC0 % 8
    jnz failBlinkLoop

    cpfjr fails, failGoGameOver

findRespawn:
    andi gameCounter, 0b1110
findRespawnLoop:
    call draw
    
    psam platformsPtrL, platformsPtrH % 8
    dec platformsPtrL, platformsPtrH % 8
    ldsm jumpFrame, hopmanPlatformLevel % 8
    btjr hopmanPlatformLevel, 3, findRespawnEnd

    sbbi scoresL, 2
    jnc findRespawnLoop
    decb scoresM, scoresH % 8
    jnc findRespawnLoop
findRespawnClearScores:
    clrm scoresL, scoresH % 8
    jmp findRespawnLoop

failGoGameOver:
    jmp gameOver

findRespawnEnd:
    andi hopmanPlatformLevel, 0b0011


startRun:
    outi SR7, 0
    ldi footCharL, 0x3
    ldi footCharH, 0x2
    ldi jumpFrame, 0
    ldi RC0, 5
    andi gameFlags, ((1 << showHopman) ^ 0xF)
startRunBlinkLoop:
    call drawBlink
    ldi RB0, 6
    call delayToRB0
    btjr buttonsState, btnRight, startRunEnd
    dec RC0, RC0 % 8
    jnz startRunBlinkLoop
startRunEnd:
    andi gameFlags, ((1 << showHopman) ^ 0xF)


gameLoop:
    inc gameCounter, gameCounter % 8
    btjr gameCounter, 0, +2
    inc platformsPtrL, platformsPtrH % 8
    incb scoresL, scoresH % 8
    
    call draw 

checkFail:
    cpjr failFlags, 0, checkFailEnd
    btjr failFlags, 3, checkFailGoFinish
    jmp fail
checkFailGoFinish:
    jmp finish
checkFailEnd:

processJump:
    cpjr jumpFrame, 0, processJumpEnd
    ldi footCharL, 0x3
    add jumpFrame, jumpAdder
    cpi jumpFrame, 6
    jc gameLoop
    ldi jumpFrame, 0
    inc hopmanPlatformLevel, hopmanPlatformLevel % 8
    jmp gameLoop
processJumpEnd:

checkFall:
    ijmr hopmanPlatformLevel
    jmp fail
    jmp checkFallCase1
    jmp checkFallCase2
checkFallCase3:
    btjr curPlatforms, 2, fall
    jmp checkFallEnd
checkFallCase2:
    btjr curPlatforms, 1, fall
    jmp checkFallEnd
checkFallCase1:
    btjr curPlatforms, 0, fall
checkFallEnd:

stepClick:
    btjr gameFlags, beepOff, stepClickSkip
    btjr gameCounter, 0, stepClickSkip
    outi SR15, tremoloOn
    outi SR15, tremoloOff
stepClickSkip:

footAnimation:
    ldi footCharL, 0x6
    btjr gameCounter, 1, +1
    ldi footCharL, 0x9

checkButton:
    in buttonsState, SR7
    cpjr buttonsState, 0, keyNotPressed
jumpBeep:
    btjr gameFlags, beepOff, jumpBeepSkip
    outi SR15, beep
jumpBeepSkip:
    btjr buttonsState, btnMode, modeBtnPressed
    outi SR7, 0

jump:
    ldi jumpAdder, 1
    ;check platform above
    btjr curPlatforms, 2, +1
    cpjr hopmanPlatformLevel, 1, jumpLow
    cpjr hopmanPlatformLevel, 3, jumpLow

    btjr buttonsState, btnRight, jumpHigh

jumpLow:
    dec hopmanPlatformLevel, hopmanPlatformLevel % 8
    ldi jumpFrame, 3
    jmp gameLoop

fall:
    dec hopmanPlatformLevel, hopmanPlatformLevel % 8
    ldi jumpAdder, 15 ;-1

jumpHigh:
    ldi jumpFrame, 1
keyNotPressed:
    jmp gameLoop


waitStartKey:
    outi SR7, 0
waitStartKeyLoop:
    in buttonsState, SR7
    btjr buttonsState, btnRight, delaySelectEnd
    btjr buttonsState, btnMode, modeBtnPressed
    jmp waitStartKeyLoop


delaySecondWith7F:
    stlia resetScanline
delaySecond:
    ldi RB0, 15
delayToRB0:
    in RB1, SR14
    add RB1, RB0
delaySelectLoop:
    in RB2, SR14
    in buttonsState, SR7
    btjr buttonsState, btnRight, delaySelectEnd
    btjr buttonsState, btnTransmit, delaySelectEnd
    btjr buttonsState, btnMode, modeBtnPressed
    cmp RB2, RB1
    jnz delaySelectLoop
delaySelectEnd:
    outi SR7, 0
delaySelectRet:
    ret


modeBtnPressed:
    outi SR13, 0b1110    ;Timer0 1/32 s. disable
    call enableAutoRedraw
    jmp 0x243


drawBlink:
    xori gameFlags, 1 << showHopman

draw:

drawPlatforms:
    psam platformsPtrL, platformsPtrH % 8
    ldsm RB0, RB1 % 8

    ldi RB3, 0x0

drawLives:
    plai 3
    stlia clearScreen
    ijmr fails
    stli 0x98
    stli 0x98
    stli 0x98
    stli ' '

drawScores:
    call printScoresAt07

    btjr gameCounter, 0, drawPlatformsOdd

drawPlatformsEven:
    ldsm curPlatforms, curPlatforms % 8

    ldi RB2, 0xA
    ldi RB5, 0x1
    ldi RB4, 0x4
    ldi RB7, 0x1
    ldi RB6, 0xE

    ldi platformCharLevel3L, 0x7
    btjr curPlatforms, 2, +1
    ldi platformCharLevel3L, 0x8
    
drawPlatformsLoop:
    btjr RB0, 2, +2
    plam RB2, RB3 % 8
    stli 0xE8

    btjr RB0, 1, +2
    plam RB4, RB5 % 8
    stli 0xE8

    btjr RB0, 0, +2
    plam RB6, RB7 % 8
    stli 0xE8

    cpjr RB2, 3, drawPlatformsLoopEnd
    ldsm RB0, RB1 % 8
    inc RB2, RB3 % 8
    inc RB4, RB4 % 8
    inc RB6, RB7 % 8
    jmp drawPlatformsLoop

drawPlatformsLoopEnd:
    jmp drawPlatformsEnd

drawPlatformsOdd:
    stlsa 40 ;skip byte
    ldsm RB4, RB4 % 8

    btjr curPlatforms, 2, +3
    btjr RB4, 2, +1
    jmp $+10                     ;XX
    ldi platformCharLevel3L, 0xD ;X0
    btjr RB4, 2, +2              ;00
    ldi platformCharLevel3L, 0xF ;0X
    andi curPlatforms, 0b1011
    btjr RB4, 1, +1
    andi curPlatforms, 0b1101
    btjr RB4, 0, +1
    andi curPlatforms, 0b1110

    psam platformsPtrL, platformsPtrH % 8
    stlsa 40 ;skip byte
    btjr RB0, 2, drawPlatformsLevel3loop0
drawPlatformsLevel3loop1:
    incb RB3, RB3 % 8
    ldsm RB1, RB2 % 8
    btjr RB1, 2, +3
    stli 0xE8       ;XX
    jnc drawPlatformsLevel3loop1
    jmp drawPlatformsLevel2
    stli 0xED       ;X0
    jc drawPlatformsLevel2

drawPlatformsLevel3loop0:
    incb RB3, RB3 % 8
    ldsm RB1, RB2 % 8
    btjr RB1, 2, +3
    stli 0xEF       ;0X
    jnc drawPlatformsLevel3loop1
    jmp drawPlatformsLevel2
    stli 0x00       ;00
    jnc drawPlatformsLevel3loop0

drawPlatformsLevel2:
    psam platformsPtrL, platformsPtrH % 8
    stlsa 40 ;skip byte
    btjr RB0, 1, drawPlatformsLevel2loop0
drawPlatformsLevel2loop1:
    incb RB3, RB3 % 8
    ldsm RB1, RB2 % 8
    btjr RB1, 1, +3
    stli 0xE8       ;XX
    jnc drawPlatformsLevel2loop1
    jmp drawPlatformsLevel1
    stli 0xED       ;X0
    jc drawPlatformsLevel1

drawPlatformsLevel2loop0:
    incb RB3, RB3 % 8
    ldsm RB1, RB2 % 8
    btjr RB1, 1, +3
    stli 0xEF       ;0X
    jnc drawPlatformsLevel2loop1
    jmp drawPlatformsLevel1
    stli 0x00       ;00
    jnc drawPlatformsLevel2loop0

drawPlatformsLevel1:
    psam platformsPtrL, platformsPtrH % 8
    stlsa 40 ;skip byte
    btjr RB0, 0, drawPlatformsLevel1loop0
drawPlatformsLevel1loop1:
    incb RB3, RB3 % 8
    ldsm RB1, RB2 % 8
    btjr RB1, 0, +3
    stli 0xE8       ;XX
    jnc drawPlatformsLevel1loop1
    jmp drawPlatformsEnd
    stli 0xED       ;X0
    jc drawPlatformsEnd

drawPlatformsLevel1loop0:
    incb RB3, RB3 % 8
    ldsm RB1, RB2 % 8
    btjr RB1, 0, +3
    stli 0xEF       ;0X
    jnc drawPlatformsLevel1loop1
    jmp drawPlatformsEnd
    stli 0x00       ;00
    jnc drawPlatformsLevel1loop0
drawPlatformsEnd:


drawHopman:
    cpjr hopmanPlatformLevel, 1, setHopmanSALevel1
    cpjr hopmanPlatformLevel, 2, setHopmanSALevel2
    cpjr hopmanPlatformLevel, 0, setHopmanSALevel0

setHopmanSALevel3:
    psai foot30
    stsm footCharL, footCharH % 8

    psai hopman30
    jmp setHopmanSAEnd

setHopmanSALevel0:
    psai hopman04
    btjr jumpFrame, 2, setHopmanSAEnd
    psai hopman03
    btjr jumpFrame, 1, setHopmanSAEnd
    psai hopman01
    cpjr jumpFrame, 1, setHopmanSAEnd
    psai hopman00
    jmp setHopmanSAEnd

setHopmanSALevel1:
    psai foot10
    stsm footCharL, footCharH % 8

    psai hopman10
    cpjr jumpFrame, 0, setHopmanSAEnd
    psai hopman11
    cpjr jumpFrame, 1, setHopmanSAEnd
    psai hopman12
    cpjr jumpFrame, 2, setHopmanSAEnd
    psai hopman13
    cpjr jumpFrame, 3, setHopmanSAEnd
    psai hopman14
    jmp setHopmanSAEnd

setHopmanSALevel2:
    psai foot20
    stsm footCharL, footCharH % 8

    psai hopman20
    cpjr jumpFrame, 0, setHopmanSAEnd
    psai hopman21
    cpjr jumpFrame, 1, setHopmanSAEnd
    psai hopman22
    cpjr jumpFrame, 2, setHopmanSAEnd
    psai hopman23
    cpjr jumpFrame, 3, setHopmanSAEnd
    psai hopman24
setHopmanSAEnd:
    
    mov failFlags, curPlatforms
    xori failFlags, 0b1111
    
    call delaySync

    ;let's start Racing the Beam
displayLine1:
    ldsm RB1, RB1 % 8
    stlsa 1
    stlia resetScanline

    btjr gameFlags, showHopman, delaySync

    ldi RB0, 6
displayLine1loop:
    btjr RB1, 3, +1
    jmp displayLine1loopSkip
    stlsa 1
displayLine1loopSkip:
    dec RB0, RB0 % 8
    jnz displayLine1loop

displayLine2:
    plai 11
    ldsm RB1, RB1 % 8
    cpjr RB1, 0, displayLine2Skip

displayLine2loop4:
    adi RB0, 4
    stlsa 11
    ldsm RB1, RB1 % 8
    jnc displayLine2loop4

    cpjr RB1, 0, displayLine2Skip3

displayLine2loop3:
    adi RB0, 6
    stlsa 11
    jnc displayLine2loop3
    jmp displayLine4

displayLine2Skip3:
    stlm platformCharLevel3L, platformCharLevel3H % 8
    andi failFlags, 0b1000  ;no collision on this line

delaySync:
    outi SR12, 0b1000
delaySyncLoop:
    in RB0, SR12
    btjr RB0, 3, drawEnd
    jmp delaySyncLoop

displayLine2Skip:
    cpm RB0, RB7    ;wait 8 cycles
    cpm RB0, RB6    ;wait 7 cycles
    andi failFlags, 0b1011  ;no collision on this line
    call displayLineDelay

displayLine4:
    ldsm RB3, RB3 % 8
    clrm RB0, RB1 % 8    ;wait 2 cycles and clear RB1 for dec in loops
    ldi RB0, 7    
    btjr RB3, 0, displayLine4loop

displayLine4skip3:
    andi failFlags, 0b1110  ;no collision on this line
    call displayLineDelay
    cpjr RB4, 0, displayLine4skip4

displayLine4loop:
    dec RB0, RB1 % 8
    stlsa 31
    jnz displayLine4loop
    jmp displayLine3

displayLine4skip4:
    cpm RB0, RB7    ;wait 8 cycles
    cpm RB0, RB7    ;wait 8 cycles

displayLine3:
    ldsm RB3, RB3 % 8
    ldi RB0, 7
    btjr RB3, 0, displayLine3loop

displayLine3skip3:
    andi failFlags, 0b1101  ;no collision on this line
    call displayLineDelay
    cpjr RB4, 0, drawEnd

displayLine3loop:
    dec RB0, RB1 % 8
    stlsa 21
    jnz displayLine3loop

drawEnd:
    ret

displayLineDelay:
    ldsm RB3, RB4 % 8
    cpm RB0, RB4    ;wait 5 cycles
    ldi RB0, 4
    ret


finish:
finishTremolo:
    btjr gameFlags, beepOff, finishTremoloSkip
    outi SR15, tremoloOn
finishTremoloSkip:
    ldi footCharL, 0x6
    ldi hopmanPlatformLevel, 1
    ldi jumpFrame, 0
    ldi RC1, ((strFinish) * 2) & 0x0F
    ldi RC2, (((strFinish) * 2) >> 4) & 0x0F
    ldi RC3, (((strFinish) * 2) >> 8) & 0x0F
finishLoop:
    btjr RC1, 0, +1
    xori footCharL, 0b1111

    incb scoresL, scoresH % 8
    incb scoresL, scoresH % 8
    call printScoresAt07

    ;plai 10
    call printLineByRC13

    ;add 17
    ldi RB1, 0x1
    ldi RB2, 0x1
    ldi RB3, 0
    call printLineByRC13withAdd

    ldsm RC0, RC0 % 8

    ;add 26
    ldi RB1, 0xA
    call printLineByRC13withAdd

    ;sub 43
    ldi RB2, 0x2
    sbm RC1, RB3

    ori gameFlags, 1 << showHopman
    cpjr RC0, 1, +1
    andi gameFlags, ((1 << showHopman) ^ 0xF)

    call drawHopman
    call delaySync

    cpi RC0, 0x8
    jnz finishLoop

    outi SR15, tremoloOff

    inc platformsPtrL, platformsPtrH % 8
    ldi footCharL, 0x3
    call draw 

    call delaySecond
    cpi stage, 9
    jz gameOver
    jmp nextStage

printLineByRC13withAdd:
    adm RC1, RB3
printLineByRC13:
    psam RC1, RC3 % 8
    jmp print10RAMBytes

printScoresAt07:
    plai 7
printScores:
    stl scoresH
    stl scoresM
    stl scoresL
    ret

hopman14:
    db 0x00 ;1 00 - skip next 6 bytes
    
    db 0x28 ;1-00110
    db 0xFC ;2-00011
    db 0x7E ;3-01111
    db 0x3C ;4-10000
    db 0x26 ;5-10101
    db 0x6D ;6-10101
    ;+7
hopman04:
    db 0x00 ;7-00000
    
    db 0x00 ;7 00 - skip next 6 bytes

    db 0x10 ;7 10 - skip next 2 bytes
    db 0x00 ;4-00000
    db 0x22 ;3-01011
    db 0x96 ;2-01110
    db 0xFF ;1-11111

    db 0x01 ;7-00000
    db 0x6D ;6-10101
    db 0x6D ;5-10101
    db 0x3C ;4-10000
    db 0x7E ;3-01111
    db 0xFC ;2-00011
    ;+1
hopman24:
    db 0x28 ;1-00010
    db 0xFC ;2-00011
    db 0x7E ;3-01111
    db 0x3C ;4-10000
    db 0x26 ;5-10101
    db 0x6D ;6-10101
    db 0x00 ;7-00000

    db 0xFF ;1-11111
    db 0x96 ;2-01110
    db 0x22 ;3-01010
    ;+2
hopman01:
    db 0x00 ;1 00 - skip next 6 bytes

    db 0x00 ;1 00 - skip next 6 bytes

    db 0x57 ;7-01010
    db 0x98 ;6-01110
    db 0x73 ;5-01110
    db 0xFF ;4-11111
    db 0x00 ;3-00000
    db 0xC2 ;2-10101
    db 0xC2 ;1-10101   

    db 0x33 ;7-01110
    db 0x9B ;6-00111
    db 0x8E ;5-00001

    ;+4
hopman21:
    db 0x08 ;1-00000
    db 0x00 ;2-00000 
    db 0x00 ;3-00000
    db 0x00 ;4-00000
    db 0x88 ;5-00110
    db 0xFB ;6-00011
    db 0x47 ;7-01111

    db 0xC2 ;1-10101
    db 0xC2 ;2-10101
    db 0x00 ;3-00000
    db 0xFF ;4-11111
    db 0x73 ;5-01110
    db 0x98 ;6-01110
    db 0x6B ;7-10010
    ;+2
hopman10:
    db 0x00 ;1 00 - skip next 6 bytes
    
    db 0x00 ;1 00 - skip next 6 bytes
    
    db 0x10 ;7 00 - skip next 2 bytes
foot10:
    db 0x23 ;4-01010
    db 0xFA ;3-01110
    db 0xFF ;2-11111
    db 0x42 ;1-11110
    
    db 0x6D ;7-10101
    db 0x6D ;6-10101
    db 0x4C ;5-10000
    db 0xFA ;4-01110
    db 0xE5 ;3-00111
    db 0x5D ;2-00001
    ;+1
hopman22:
    db 0x08 ;1-00000
    db 0x34 ;2-00110
    db 0x9B ;3-00011
    db 0x39 ;4-01111
    db 0x4C ;5-10000
    db 0x6D ;6-10101
    db 0x6D ;7-10101

    db 0xFF ;1-11111
    db 0x96 ;2-01110
    db 0x61 ;3-01110
    db 0x6B ;4-10100
    ;+1
hopman13:
    db 0x00 ;1 00 - skip next 6 bytes
    
    db 0x66 ;1-00110
    db 0xFC ;2-00011
    db 0x7E ;3-01111
    db 0x3C ;4-10000
    db 0x26 ;5-10101
    db 0x6D ;6-10101
    ;+7
hopman03:
    db 0x00 ;1 00 - skip next 6 bytes
    
    db 0x00 ;1 00 - skip next 6 bytes

    db 0x10 ;7 10 - skip next 2 bytes
    db 0x00 ;4-00000
    db 0x24 ;3-10100
    db 0x96 ;2-01110
    db 0xFF ;1-11111

    db 0x01 ;7-00000
    db 0x6D ;6-10101
    db 0x6D ;5-10101
    db 0x3C ;4-10000
    db 0x7E ;3-01111
    db 0xFC ;2-00011
    ;+1
hopman23:
    db 0x9B ;1-00110
    db 0xFC ;2-00011
    db 0x7E ;3-01111
    db 0x3C ;4-10000
    db 0x26 ;5-10101
    db 0x40 ;6-10101
    db 0x00 ;7-00000

    db 0xFF ;1-11111
    db 0x96 ;2-01110
    db 0x24 ;3-10100
    ;+2
hopman00:
    db 0x00 ;1 00 - skip next 6 bytes

    db 0x00 ;1 00 - skip next 6 bytes

    db 0x6D ;7-10101
    db 0x6D ;6-10101
    db 0x4C ;5-10000
    db 0xFA ;4-01110
    db 0xE5 ;3-00111
    db 0x5D ;2-00001
    ;+2
hopman20:
    db 0x00 ;1 00 - skip next 6 bytes
    
    db 0x02 ;1-00000
    db 0x2F ;2-00001
    db 0xE5 ;3-00111
    db 0x24 ;4-01110
    db 0x4C ;5-10000
    db 0x6D ;6-10101
    db 0x6D ;7-10101
    
    db 0x00 ;7 00 - skip next 6 bytes

    db 0x10 ;7 10 - skip next 2 bytes
foot20:
    db 0x23 ;4-01010
    db 0x61 ;3-01110
    db 0xFF ;2-11111
    db 0x42 ;1-11110

hopman30:
    db 0x08 ;1-00000
    db 0x5D ;2-00001
    db 0xE5 ;3-00111
    db 0xFA ;4-01110
    db 0x4C ;5-10000
    db 0x6D ;6-10101
    db 0x6D ;7-10101
   
    db 0x42 ;1-11110
    db 0xFF ;2-11111
    db 0xFA ;3-01110
foot30:
    db 0xE4 ;4-01010
    ;+1
hopman12:
    db 0x00 ;1 00 - skip next 6 bytes
    
    db 0x01 ;1-00000
    db 0x34 ;2-00110
    db 0x9B ;3-00011
    db 0x39 ;4-01111
    db 0x4C ;5-10000
    db 0x6D ;6-10101
    db 0x6D ;7-10101
    
    db 0x00 ;7 00 - skip next 6 bytes

    db 0x10 ;7 10 - skip next 2 bytes
    db 0x6B ;4-10100
    db 0x61 ;3-01110
    db 0x96 ;2-01110
    db 0xFF ;1-11111

hopman11:
    db 0x00 ;1 00 - skip next 6 bytes

    db 0x01 ;1-00000
    db 0x00 ;2-00000
    db 0x00 ;3-00000
    db 0x00 ;4-00000
    db 0x88 ;5-00110
    db 0xFB ;6-00011
    db 0x47 ;7-01111
    
    db 0x00 ;7 00 - skip next 6 bytes

    db 0x6B ;7-10010
    db 0x98 ;6-01110
    db 0x73 ;5-01110
    db 0xFF ;4-11111
    db 0x00 ;3-00000
    db 0xC2 ;2-10101
    db 0xC2 ;1-10101

strStart:
    ds "START"
bitmap:
    db 0b00000, 0b00000, 0b00000, 0b10000, 0b00000, 0b00000, 0b00000, 0b01000, 0b01111, 0b00101
    db 0b00000, 0b00000, 0b00000, 0b11000, 0b00000, 0b00000, 0b00000, 0b10100, 0b01010, 0b01011
    db 0b00000, 0b00000, 0b00000, 0b01110, 0b00000, 0b00000, 0b00000, 0b11100, 0b10001, 0b01110
    db 0b10111, 0b11100, 0b00000, 0b00001, 0b00000, 0b00000, 0b00000, 0b10100, 0b10111, 0b01010
    db 0b10010, 0b01101, 0b00000, 0b10101, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000
    db 0b10010, 0b11101, 0b00000, 0b10101, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000
 
    db 0b01111, 0b00011, 0b01110, 0b11111, 0b11111, 0b01110, 0b01111, 0b01111, 0b11111, 0b01111
    db 0b10111, 0b00011, 0b10111, 0b01110, 0b00111, 0b10111, 0b10111, 0b10111, 0b00111, 0b10111
    db 0b10011, 0b00011, 0b10011, 0b01110, 0b00011, 0b10011, 0b10011, 0b10101, 0b00011, 0b10011
    db 0b01111, 0b00011, 0b11111, 0b01110, 0b01111, 0b10011, 0b01111, 0b10101, 0b01111, 0b01111
    db 0b00011, 0b00011, 0b10011, 0b01110, 0b00011, 0b10011, 0b10011, 0b10101, 0b00011, 0b10011
    db 0b00011, 0b00011, 0b10011, 0b01110, 0b00011, 0b10011, 0b10011, 0b10101, 0b00011, 0b10011
    db 0b00011, 0b11111, 0b10011, 0b01010, 0b00011, 0b01110, 0b10011, 0b10101, 0b11111, 0b10011

    db 0b10010, 0b01010, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b10100, 0b01001
    db 0b10010, 0b01110, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b10111, 0b01001
    db 0b10111, 0b01010, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b10111, 0b11101
    ;Order matters
strFinishLevel3:
    ;ds "         "
    db 0xFF,
    ds "FINISH"
    db 0xFF
    ;Order matters
strFinishLevel2:
    ds "         "
    db 0xFF
    ds "      "
    db 0xFF
    ds "        "
    db 0x01
    ;Order matters
strFinishLevel1:
    db 0xE8, 0xE8, 0xE8, 0xE8, 0xE8, 0xE8, 0xE8, 0xE8, 0xE8
    db 0xFF
    db 0xE8, 0xE8, 0xE8, 0xE8, 0xE8, 0xE8
    db 0xFF
    db 0xE8, 0xE8, 0xE8, 0xE8, 0xE8, 0xE8, 0xE8, 0xE8, 0xE8

topScores:
    db 0, 0
    ;Order matters
strGameOver:
    ds "GAMEOVER"
    ;Order matters
strScores:
    ds "SCORE"
    ;Order matters
strStage:
    ds "STAGE "
    ;Order matters
    db 0x62, 0x79, 0x20, 0x44, 0x49, 0x4D, 0x41

platforms:

;Stage 1
    db 0x0E,0x0E,0x0E,0x0E,0x0E,0x9E,0x0E,0x0E,0x0E,0x0E,
    db 0x0F,0x0D,0x0D,0x0D,0x0F,0x0B,0x0B,0x0B,0x0F,0xAD,
    db 0x0D,0x0D,0x0D,0x0F,0x0F,0x0F,0x0D,0x0D,0x0D,0x0F,
    db 0x0F,0x0F,0xAD,0x0D,0x0D,0x0D,0x0F,0x0F,0x0F,0x0F,
    db 0x0E,0x0E,0x0E,0x0F,0x0F,0x0D,0x0F,0x0F,0x0B,0x0B,
    db 0x0F,0x0B,0x0B,0x0F,0x0B,0x0B,0x0F,0x0F,0x9E,0x0E,
    db 0x0E,0x0F,0x0F,0x0F,0x0E,0x0E,0x0F,0x0F,0x0F,0x0E,
    db 0x0E,0x0F,0x0F,0x0F,0x16,

;Stage 2
    db 0x0E,0x0E,0x0E,0x0E,0x0E,0x9E,0x0E,0x0E,0x0E,0x0E,
    db 0x0F,0x0F,0x0D,0x0D,0x0D,0x0F,0xBB,0x0B,0x0B,0x0B,
    db 0x0F,0x0B,0x0B,0x0F,0x0D,0x0F,0x0D,0x0D,0x0E,0x9E,
    db 0x0E,0x0E,0x0E,0x0D,0x0D,0x0F,0x0F,0x0F,0x0F,0x0D,
    db 0x0D,0x0F,0x0F,0x0F,0x0F,0x0D,0x0D,0x0F,0xBB,0x0B,
    db 0x0B,0x0B,0x0F,0x0F,0x0F,0x9E,0x0A,0x0A,0x0A,0x0B,
    db 0x0A,0x0B,0x0A,0x0B,0x9A,0x0A,0x0E,0x0E,0x0E,0x0E,
    db 0x0F,0x0E,0x0A,0x0E,0x16,

;Stage 3
    db 0x0E,0x0E,0x0E,0x0E,0x0E,0x9E,0x0E,0x0E,0x0E,0x0E,
    db 0x0F,0x0F,0x0F,0x0E,0x0F,0x0F,0x0F,0x9E,0x0E,0x0E,
    db 0x0E,0x0E,0x0F,0x0A,0x0A,0x0E,0x0E,0xAD,0x0D,0x0D,
    db 0x0D,0x0F,0x0B,0x0B,0x0F,0x0F,0x0B,0x0B,0x0F,0x0F,
    db 0x0F,0x0D,0x0D,0x0F,0x0F,0x0F,0x9E,0x0E,0x0E,0x0E,
    db 0x0F,0x0F,0x0F,0x0D,0x0D,0x0F,0x0E,0x0E,0x0E,0x0F,
    db 0x0F,0x0F,0x0D,0x0F,0x0F,0x0F,0x0F,0x0E,0x0F,0x0F,
    db 0x0F,0x0D,0x0F,0x0F,0x0F,0x0F,0x16,

;Stage 4
    db 0x0E,0x0E,0x0E,0x0E,0x0E,0x9E,0x0E,0x0E,0x0E,0x0E,
    db 0x0C,0x0C,0x0C,0x0C,0x08,0x0E,0x0E,0x0E,0x0E,0x0C,
    db 0x0C,0x0C,0x0C,0x08,0x0E,0x0E,0x0E,0x0E,0x0C,0x0C,
    db 0x0C,0x0C,0x08,0x0E,0x9E,0x0E,0x0E,0x0E,0x0F,0x0F,
    db 0x0F,0x0D,0x0F,0x0F,0x0F,0x0B,0x0F,0x0F,0x0F,0x0D,
    db 0x0F,0x0F,0x0F,0x0F,0xAD,0x0D,0x0D,0x0D,0x0B,0x0D,
    db 0x0D,0x0D,0x0B,0x0D,0x0D,0x0D,0x0B,0x0D,0x0D,0x0D,
    db 0x0F,0x0F,0x0F,0x0F,0x16,

;Stage 5
    db 0x0E,0x0E,0x0E,0x0E,0x0E,0x9E,0x0E,0x0E,0x0E,0x0E,
    db 0x0C,0x0E,0x0C,0x0E,0x0C,0x9E,0x0E,0x0E,0x0A,0x0B,
    db 0x0A,0x0B,0x0A,0x0B,0x0A,0x0B,0x0A,0x9E,0x0E,0x0E,
    db 0x0E,0x0C,0x0C,0x0E,0x0E,0x0E,0x0A,0x0E,0x0A,0x0E,
    db 0x9A,0x0E,0x0A,0x0E,0x0E,0x0F,0x0F,0x0F,0x0D,0x0D,
    db 0x0F,0x0F,0x0F,0x0B,0x0B,0x0F,0x0F,0x0F,0x0D,0x0D,
    db 0x0F,0x0F,0x0F,0x0F,0x0F,0x9A,0x0A,0x0E,0x0E,0x0D,
    db 0x0E,0x0E,0x0A,0x0A,0x16,

;Stage 6
    db 0x0E,0x0E,0x0E,0x0E,0x0E,0x9E,0x0E,0x0E,0x0E,0x0E,
    db 0x0C,0x0E,0x0C,0x0E,0x0E,0x0E,0x0C,0x0E,0x0E,0x0F,
    db 0x0F,0x0E,0x0F,0x0E,0x0F,0x0F,0x0F,0x9E,0x0E,0x0E,
    db 0x0E,0x0D,0x0D,0x0D,0x09,0x0F,0x0F,0x0F,0x0A,0x0A,
    db 0x0A,0x0E,0x0E,0xAC,0x0E,0x0E,0x0E,0x0F,0x0F,0x0F,
    db 0x0E,0x0F,0x0F,0x0F,0x0E,0x0F,0x0F,0x0F,0x0E,0x0F,
    db 0x0F,0x0F,0x0D,0x0D,0x0F,0x0E,0x0F,0x0F,0x0F,0x0D,
    db 0x0F,0x0F,0x0F,0x0F,0x16,

;Stage 7
    db 0x0E,0x0E,0x0E,0x0E,0x0E,0x9E,0x0E,0x0E,0x0E,0x0E,
    db 0x0F,0x0F,0x0D,0x0D,0x0D,0x09,0x0D,0x0F,0x0F,0x0E,
    db 0xAD,0x0D,0x0D,0x0F,0x0F,0x0E,0x0E,0x0E,0x0F,0x0E,
    db 0x0F,0x0E,0x0F,0x0F,0x0E,0x0F,0x0E,0x0F,0x9E,0x0E,
    db 0x0E,0x0E,0x0F,0x0F,0x0F,0x0D,0x0F,0x0F,0x0F,0x0B,
    db 0x0F,0x0F,0x0F,0x0F,0x0E,0x0F,0x0F,0x0F,0x0F,0x0E,
    db 0x0F,0x0F,0x0F,0x0F,0x0E,0x0E,0x0D,0x0D,0x0F,0x0F,
    db 0x0A,0x0E,0x0E,0x0E,0x16,

;Stage 8
    db 0x0E,0x0E,0x0E,0x0E,0x0E,0x9E,0x0E,0x0E,0x0E,0x0E,
    db 0x0C,0x0E,0x0C,0x0E,0x0E,0x0E,0x0C,0x0E,0x0E,0x0F,
    db 0x0F,0x0F,0x0F,0x0E,0x0F,0x0F,0x0F,0x0E,0x0F,0x0F,
    db 0x0F,0x0F,0x0E,0x0F,0x0F,0x0F,0x0D,0x0F,0x0F,0x0B,
    db 0x0F,0x0E,0x0E,0x0B,0x9E,0x0E,0x0E,0x0E,0x0F,0x0F,
    db 0x0F,0x0D,0x0F,0x0F,0x0B,0x0F,0x0F,0x0F,0x0F,0x0E,
    db 0x0F,0x0F,0x0F,0x0D,0x0F,0x0B,0x0F,0x0F,0x0F,0x0A,
    db 0x16,

;Stage 9
    db 0x0E,0x0E,0x0E,0x0E,0x0E,0x9E,0x0E,0x0E,0x0E,0x0E,
    db 0x0F,0x0F,0xAD,0x0D,0x0D,0x0D,0x0F,0x0E,0x0B,0x0A,
    db 0x0B,0x0E,0x0B,0x0B,0x0E,0x0A,0x0B,0x0A,0x0E,0x0B,
    db 0x0B,0x0E,0x0B,0x0A,0x0F,0x0E,0x0F,0xAD,0x0D,0x0D,
    db 0x0D,0x0F,0x0E,0x0A,0x0A,0x0E,0x0E,0x0A,0x0A,0x0E,
    db 0x9E,0x0A,0x0A,0x0E,0x0E,0x0F,0x0D,0x0F,0x0D,0x0F,
    db 0x0D,0x0F,0x0F,0x0B,0x0F,0x0E,0x0E,0x0B,0x0E,0x0B,
    db 0x16,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,