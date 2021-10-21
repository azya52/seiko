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
#include <stdarg.h>

// We assume the first ORG is the lowest address
#define START unsigned int genasm(int _solo_pass) { \
   unsigned tmp=0;\
   unsigned cur_line=0;\
   unsigned _start_add=0x1800;\
   unsigned _solo_add=0;\
   _solo_info.psize=16; \
   _solo_info.begin=0; \
   _solo_info.memsize=4096; \
   _solo_info.ary=malloc(_solo_info.memsize);\
	unsigned int getPCfromLabel(unsigned int lbl) {\
		return ((lbl + _start_add)/2);\
	}\
	unsigned int getPCfromInt(unsigned short pc) {\
		return pc;\
	}
#define END _solo_info.end=_solo_add/2-1; return _solo_add/2; }

#define DEFLABEL(l) static unsigned int l;
#define LABEL(l) l = _solo_add;
#define LINE(line) cur_line = line;
#define DW(n) ADDOPCODE(n);
#define DB(n,...) DATA(n, __VA_ARGS__)
#define $ _solo_add

#define ORG(n) {\
	if(_solo_add == 0)\
		_start_add=n;\
	else\
		if ((n - _start_add) < _solo_add) {\
			fprintf(stderr,"Line %d: An attempt was made to move the location counter backwards with the ORG directive\n", cur_line);\
		}\
		_solo_add = (n-_start_add);\
	}

#define DATA(...) {\
	unsigned ns[] = {__VA_ARGS__};\
	int n_size = sizeof(ns)/sizeof(unsigned);\
	for (int i = 0; i < n_size; i++) {\
		CHKSIZE(ns[i],8)\
		if(_solo_add % 2 == 0) {\
			_solo_info.ary[_solo_add++/2]=(ns[i] & 0xFF)<<8;\
		} else {\
			_solo_info.ary[_solo_add++/2]|=(ns[i] & 0xFF);\
		}\
	}\
}\

#define GETPC(X)\
	_Generic((X),\
	unsigned short: getPCfromInt,\
	unsigned int: getPCfromLabel,\
	default: getPCfromInt\
)(X)

#define CHKSIZE(n,bits)\
	if (n>>bits) {\
		fprintf(stderr,"Line %d: Value %d out of range\n", cur_line, n);\
		_solo_info.err = 1;\
	}\
	
#define ADDOPCODE(opcode) _solo_info.ary[_solo_add/2]=opcode; _solo_add = (_solo_add + 2)

	
#define CHKEVEN() if(_solo_add%2 != 0) DATA(0)

#define UC0(op) CHKEVEN(); ADDOPCODE(op)
#define UC1_23(op,r1) CHKEVEN(); CHKSIZE(r1,2); ADDOPCODE(op|(r1<<3))
#define UC1_55(op,r1) CHKEVEN(); CHKSIZE(r1,5); ADDOPCODE(op|(r1<<5))
#define UC1_8(op,r) CHKEVEN(); CHKSIZE(r,8); ADDOPCODE(op|((r&0xF0)<<2)|((r&0x08)<<2)|(r&0x07))
#define UC2(op,r1,r2) CHKEVEN(); CHKSIZE(r1,5); CHKSIZE(r2,5); ADDOPCODE(op|(r1<<5)|r2)
#define UC2_425(op,r1,r2) CHKEVEN(); CHKSIZE(r1,4); CHKSIZE(r2,5); ADDOPCODE(op|(r1<<6)|r2)
#define UC2_541(op,r1,r2) CHKEVEN(); CHKSIZE(r1,5); CHKSIZE(r2,4); ADDOPCODE(op|(r1<<5)|(r2<<1))
#define UCJ11(op,l) CHKEVEN(); tmp=((l % 2048) & 0x7FF); CHKSIZE(tmp,11); ADDOPCODE((op)|(tmp))
#define UCJ12(op,l) CHKEVEN(); CHKSIZE(l,12); ADDOPCODE((op)|(l))
#define UCJ10(op,l) CHKEVEN(); tmp=l & 0x3FF; CHKSIZE(tmp,10); ADDOPCODE((op)|(tmp))
#define UCJ3(op,R,I,a) CHKEVEN(); tmp=a; if(a>31) tmp=(a-_solo_add)/2-1; CHKSIZE(I,2); CHKSIZE(R,5); CHKSIZE(tmp,5); ADDOPCODE(op|(I<<10)|(R<<5)|(tmp))
#define UC2_523(op,R,I,i) CHKEVEN(); CHKSIZE(R,5); CHKSIZE(I,2); CHKSIZE(i,3); ADDOPCODE(op|(R<<5)|(I<<3)|i)

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
#define OUT(d,s) UC2(0x5800,s,d)
#define OUTI(d,i) UC2_425(0x5C00,i,d)
#define PSAM(R,r) UC2_523(0x6000,R,0,r)
#define PLAM(R,r) UC2_523(0x6000,R,2,r)
#define LDSM(R,r) UC2_523(0x6400,R,1,r)
#define STSM(R,r) UC2_523(0x6400,R,0,r)
#define STLM(R,r) UC2_523(0x6800,R,0,r)
#define STL(R) UC1_55(0x6C00,R)
#define PSAI(l) UCJ11(0x7000,l)
#define PLAI(i) UC1_8(0x7800,i)
#define STLS UC0(0x7C00)
#define STLSA(a) UC1_8(0x7C08,a)
#define STLI(i) UC1_8(0x7C10,i)
#define STLIA(i) UC1_8(0x7C18,i)

#define MOV(d,s) UC2(0x8000,d,s) 
#define MOVM(d,s) UC2(0x8400,d,s) 
#define LDI(r,i) UC2_541(0x8800,r,i) 
#define CLRM(R,r) UC2_523(0x8C00,R,0,r) 
#define MVAC(d,s) UC2(0x9000,d,s)
#define MVACM(d,s) UC2(0x9400,d,s)
#define MVCA(d,s) UC2(0x9800,d,s)
#define MVCAM(d,s) UC2(0x9C00,d,s)
#define CALL(l) UCJ12(0xA000,GETPC(l))
#define RET UC0(0xB000) 
#define CPFJR(R,l) UCJ3(0xB400,R,0,l)
#define IJMR(R) UC1_55(0xB800,R)
#define WFI UC0(0xBC00)
#define JMP(l) UCJ12(0xC000,GETPC(l))
#define JZ(l) UCJ10(0xD000,GETPC(l))
#define JNZ(l) UCJ10(0xD400,GETPC(l))
#define JC(l) UCJ10(0xD800,GETPC(l))
#define JNC(l) UCJ10(0xDC00,GETPC(l))
#define BTJR(R,I,l) UCJ3(0xE000,R,I,l)
#define CPJR(R,I,l) UCJ3(0xF000,R,I,l)

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

#define SR0 0
#define SR1 1
#define SR2 2
#define SR3 3
#define SR4 4
#define SR5 5
#define SR6 6
#define SR7 7
#define SR8 8
#define SR9 9
#define SR10 10
#define SR11 11
#define SR12 12
#define SR13 13
#define SR14 14
#define SR15 15

#define OS_CLRCB 0x8F2	//clear registers of the current bank
#define OS_PRINTLINE10 0x9CB //print "----------" (OS_PRINTLINE0-5 + OS_PRINTLINE0-5) (part of CALCULATOR)
#define OS_PRINTSTARLINE5 0x9C1 //print "*****"
#define OS_PRINTSTARLINE10 0x9C0 //print "**********"
#define OS_PRINTWATCH 0xA1F //draw watch screen with values from current bank
#define OS_PRINTDAYOFWEEK 0xA33	//Current day of week + 0:0000 (part of WATCH)
#define OS_PRINTALARMSCR 0xAFB //print alarm screen (part of ALARM)
#define OS_PRINTAM 0xB30 //print AM. 0xB12 same
#define OS_PRINTPM 0xB32 //print PM. 0xB14 same
#define OS_MEMOB 0xB85 //print memoB (part of MEMO)
#define OS_BIGB 0xB8A //print big B (part of MEMO)
#define OS_PRINT3LINE 0xBAC //print 3 line pointed at by SA register (it sets by PSAI), the fourth line is filled with "*" (part of MEMO)
#define OS_PRINT0 0xBD0 //print line pointed at by SA register (it sets by PSAI), char count 0-10, use like "CALL OS_PRINT0-5" (print 5 chars)
#define OS_PRINTSTAR0 0xBD6 //print "*", 0-5, use like "CALL OS_PRINTSTAR0-3" (print "***")
#define OS_PRINTLINE0 0xBDC //print "-", 0-5, use like "CALL OS_PRINTLINE0-3" (print "---")
#define OS_PRINTZERO0 0xBE6 //print 0x0 char, 0-5, use like "CALL OS_PRINTSTAR0-3" (print "   ")
#define OS_COPY0BTOCB 0xBE7 //copy 0 bank to current
#define OS_PRINTDAY 0xBDD


#endif
