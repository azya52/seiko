/*
 * ucDisassembler.cpp
 * Seiko cal. UW01 (UW02) simple disassembler, see https://github.com/azya52/seiko
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

#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <string.h>
#include "instructions.h"

using namespace std;

int main(int argc, char *argv[]) {
	FILE *source;
	FILE *outfile;
	
	if (argv[1]==NULL || (source = fopen(argv[1], "rb")) == NULL) {
		printf("Could not open source file: %s\n", argv[1]);
		return 0;
	}

	char* foutname;
	if (argv[2] == NULL) {
		foutname = new char[strlen(argv[1]) + 4 + 1];
		strcpy(foutname, argv[1]);
		strcat(foutname, ".asm");
	}
	else {
		foutname = new char[strlen(argv[2])+1];
		strcpy(foutname, argv[2]);
	}

	if ((outfile = fopen(foutname, "w")) == NULL) {
		printf("Could not create file: %s\n", argv[2]);
		return 0;
	}

	unsigned char word[2];
	int offset = 0;
	fprintf(outfile, "          ORG 0\n", offset);
	while (fread(word, 2, 1, source) != 0) {
		int instruction = ((word[0] & 0xFF )<<8) | word[1];
		fprintf(outfile, "L%04d:    ", offset);
		int i;
		for (i = 0; i < INSTR_COUNT; i++) {
			if ((instruction & instr_set[i].opmask) == instr_set[i].opcode) {
				fprintf(outfile, "%s", instr_set[i].name);
				int args[ARG_MAX_COUNT] = {0,0};
				for (int j = 0; j < INSTR_SIZE; j++) {
					if (instr_set[i].desc[j] > 0) {
						args[instr_set[i].desc[j]-1] <<= 1;
						args[instr_set[i].desc[j]-1] |= (instruction >> (INSTR_SIZE-j-1)) & 0x0001;
					}
				}
				int arg_n = 0;
				while (instr_set[i].arg_type[arg_n] != AT_NONE && arg_n<ARG_MAX_COUNT) {
					if (arg_n > 0) {
						fprintf(outfile, ",");
					}
					if (instr_set[i].arg_type[arg_n] == AT_ADR12) {
						if (args[arg_n] > 3072) {
							fprintf(outfile, " L%04d", args[arg_n]-3072);
						} else {
							fprintf(outfile, " 0x%04x", args[arg_n]);
						}
					} else 
					if (instr_set[i].arg_type[arg_n] == AT_ADR11) {
						fprintf(outfile, " L%04d", args[arg_n]/2);
					}
					else
					if (instr_set[i].arg_type[arg_n] == AT_ADR10) {
						fprintf(outfile, " L%04d", args[arg_n]);
					} else
					if (instr_set[i].arg_type[arg_n] == AT_ADR5) {
						fprintf(outfile, " +%d", args[arg_n]);
					} else
					if (instr_set[i].arg_type[arg_n] == AT_REG) {
						fprintf(outfile, " %s", general_reg[args[arg_n]]);
					} else
					if (instr_set[i].arg_type[arg_n] == AT_IOREG) {
						fprintf(outfile, " %s", io_reg[args[arg_n]]);
					} else {
						fprintf(outfile, " %d", args[arg_n]);
					}
					arg_n++;
				}
				break;
			}
		}
		
		if (i == INSTR_COUNT) {
			fprintf(outfile, "DW 0x%04x", instruction & 0xFFFF);
		}
		fprintf(outfile, "\n");
		offset++;
	}
	fprintf(outfile, "          END", offset);
	fclose(outfile);
	fclose(source);
	return 0;
}

