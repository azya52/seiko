/*
 * uc2000.inc
 * Seiko cal. UW01 (UW02) instruction set,
 * for axasm (https://github.com/wd5gnr/axasm) assembler.
 * (see https://github.com/azya52/seiko)
 * Copyright (c) 2017, Alexander Zakharyan
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */ 
 
#ifndef __SOLO_ASM_INC
#define __SOLO_ASM_INC
#include <stdio.h> 
#include <stdlib.h>
#include <soloasm.h>

// We assume the first ORG is the lowest address
#define ORG(n) unsigned int genasm(int _solo_pass) { \
   unsigned preDATAadr=0;\
   unsigned tmp=0;\
   unsigned dbi=0;\
   unsigned _solo_add=n;\
   _solo_info.psize=16; \
   _solo_info.begin=n; \
   _solo_info.memsize=4096; \
   _solo_info.ary=malloc(_solo_info.memsize)

#define REORG(n) _solo_add=n;
#define END _solo_info.end=_solo_add-1; return _solo_add; }

#define DEFLABEL(l) static unsigned l
#define LABEL(l) if(dbi==1) DATA(0); l=_solo_add+0xC00; 
#define DW(n) _solo_info.ary[_solo_add++]=(n)

#define DATA(n) if(dbi==1) {\
		_solo_info.ary[_solo_add++]|=n;\
		dbi--;\
	} else {\
		_solo_info.ary[_solo_add]=n<<8;\
		dbi++;\
	}\
	
#define DB(n) DATA(n)

#define CHKSIZE(n,bits) if (n>>bits) fprintf(stderr,"Warning: value %04X out of range at %04d\n",n,_solo_add)
#define UC0(op) _solo_info.ary[_solo_add++]=op
#define UC1_23(op,r1) CHKSIZE(r1,2); _solo_info.ary[_solo_add++]=(op|(r1<<3))
#define UC1_55(op,r1) CHKSIZE(r1,5); _solo_info.ary[_solo_add++]=(op|(r1<<5))
#define UC1_8(op,r) CHKSIZE(r,8); _solo_info.ary[_solo_add++]=(op|((r&0xF0)<<2)|((r&0x08)<<2)|(r&0x07))
#define UC2(op,r1,r2) CHKSIZE(r1,5); CHKSIZE(r2,5); _solo_info.ary[_solo_add++]=(op|(r1<<5)|r2)
#define UC2_541(op,r1,r2) CHKSIZE(r1,5); CHKSIZE(r2,4); _solo_info.ary[_solo_add++]=op|(r1<<5)|(r2<<1)
#define UCJ(op,l) _solo_info.ary[_solo_add++]=((op)|(l))
#define UCJ11(op,l) tmp=(l & 0x3FF)*2; CHKSIZE(tmp,11); UCJ(op,tmp)
#define UCJ12(op,l) CHKSIZE(l,12); UCJ(op,l)
#define UCJ10(op,l) tmp=l & 0x3FF; CHKSIZE(tmp,10); UCJ(op,tmp)
#define UCJ3(op,R,I,a) tmp=a; if(a>31) tmp=(a & 0x3FF)-_solo_add-1; CHKSIZE(I,2); CHKSIZE(R,5); CHKSIZE(tmp,5); _solo_info.ary[_solo_add++]=(op|(I<<10)|(R<<5)|(tmp))
#define UC2_523(op,R,I,i) CHKSIZE(R,5); CHKSIZE(I,2); CHKSIZE(i,3); _solo_info.ary[_solo_add++]=(op|(R<<5)|(I<<3)|i)

#define ADD(d,s) UC2(0x0000,d,s) 
#define ADB(d,s) UC2(0x0400,d,s) 
#define SUB(d,s) UC2(0x0800,d,s)
#define SBB(d,s) UC2(0x0C00,d,s)
#define ADI(R,I) UC2_541(0x1000,R,I) 
#define ADBI(R,I) UC2_541(0x1400,R,I) 
#define SBI(R,I) UC2_541(0x1800,R,I)
#define SBBI(R,I) UC2_541(0x1C00,R,I)
#define ADM(d,s) UC2(0x2000,d,s) 
#define ADBM(d,s) UC2(0x2400,d,s) 
#define SBM(d,s) UC2(0x2800,d,s) 
#define SBBM(d,s) UC2(0x2C00,d,s) 
#define CMP(r1,r2) UC2(0x3000,r1,r2) 
#define CPM(r1,r2) UC2(0x3400,r1,r2) 
#define CPI(r,i) UC2_541(0x3800,r,i) 
#define LCRB(b) UC1_23(0x3C00,b) 
#define LARB(b) UC1_23(0x3E00,b) 
#define ORI(r,i) UC2_541(0x4400,r,i) 
#define ANDI(r,i) UC2_541(0x4000,r,i) 
#define XORI(r,i) UC2_541(0x4800,r,i) 
#define INC(r,i) UC2_523(0x4C00,r,0,i)
#define INCB(r,i) UC2_523(0x4C00,r,1,i)
#define DEC(r,i) UC2_523(0x4C00,r,2,i)
#define DECB(r,i) UC2_523(0x4C00,r,3,i)
#define RSHM(r,i) UC2_523(0x5000,r,0,i)
#define LSHM(r,i) UC2_523(0x5000,r,1,i)
#define IN(d,s) UC2(0x5400,d,s)

#define PSAM(R,r) UC2_523(0x6000,R,0,r);
#define PLAM(R,r) UC2_523(0x6000,R,2,r);
#define LDSM(R,r) UC2_523(0x6400,R,1,r);
#define STSM(R,r) UC2_523(0x6400,R,0,r);
#define STLM(R,r) UC2_523(0x6800,R,0,r)
#define STL(R) UC1_55(0x6C00,R)
#define PSAI(l) UCJ11(0x7000,l);
#define PLAI(i) UC1_8(0x7800,i)
#define STLI(i) UC1_8(0x7C10,i)

#define MOV(d,s) UC2(0x8000,d,s) 
#define MOVM(d,s) UC2(0x8400,d,s) 
#define LDI(r,i) UC2_541(0x8800,r,i) 
#define CLRM(R,r) UC2_523(0x8C00,R,0,r) 
#define MVAC(d,s) UC2(0x9000,d,s)
#define MVACM(d,s) UC2(0x9400,d,s)
#define MVCA(d,s) UC2(0x9800,d,s)
#define MVCAM(d,s) UC2(0x9C00,d,s)
#define CALL(l) UCJ12(0xA000,l)
#define RET UC0(0xB000) 
#define CPFJR(R,a) UCJ3(0xB400,R,0,a)
#define IJMR(R) UC1_55(0xB800,R)
#define NOP UC0(0xBC00)
#define JMP(l) UCJ12(0xC000,l)
#define JZ(l) UCJ10(0xD000,l)
#define JNZ(l) UCJ10(0xD400,l)
#define JC(l) UCJ10(0xD800,l)
#define JNC(l) UCJ10(0xDC00,l)
#define BTJR(R,I,a) UCJ3(0xE000,R,I,a)
#define CPJR(R,I,a) UCJ3(0xF000,R,I,a)

#define B0 0	//register page
#define B1 1
#define B2 2
#define B3 3

#define RA0 0
#define RA1 1
#define RA2 2
#define RA3 3
#define RA4 4
#define RA5 5
#define RA6 6
#define RA7 7
#define RB0 8
#define RB1 9
#define RB2 10
#define RB3 11
#define RB4 12
#define RB5 13
#define RB6 14
#define RB7 15
#define RC0 16
#define RC1 17
#define RC2 18
#define RC3 19
#define RC4 20
#define RC5 21
#define RC6 22
#define RC7 23
#define RD0 24
#define RD1 25
#define RD2 26
#define RD3 27
#define RD4 28
#define RD5 29
#define RD6 30
#define RD7 31

#define IO0 0
#define IO1 1
#define IO2 2
#define IO3 3
#define IO4 4
#define IO5 5
#define IO6 6
#define IO7 7
#define IO8 8
#define IO9 9
#define IO10 10
#define IO11 11
#define IO12 12
#define IO13 13
#define IO14 14
#define IO15 15

#define OS_CLRCB 0x8F2	//zero registers of the current bank
#define OS_CLS 0xBE4 //clear screen
#define OS_COPY0BTOCB 0xBE7 //copy 0 bank to current
#define OS_PRINT0 0xBD0
#define OS_PRINTLINE 0xBD7
#define OS_PRINTDAY 0xBDD


#endif
