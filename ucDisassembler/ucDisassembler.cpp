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

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "instructions.h"

int main(int argc, char *argv[]) {
	FILE *source;
	FILE *outfile;
	
	int offset = 0x1800;
	
	if (argc <= 1) {
		printf("Usage: \n\t ucDisassembler [-a <start address>] <input file name> <output file name>\n");
		return 0;
	}

	char *opts = (char *)"a:";
	int opt;
	while ((opt = getopt(argc, argv, opts)) != -1) {
		switch (opt) {
			case 'a': 
				offset = atoi(optarg);
				break;
		}
	}
	
	if (argv[optind]==NULL || (source = fopen(argv[optind], "rb")) == NULL) {
		printf("Could not open source file: %s\n", argv[optind]);
		return 0;
	}
	
	char* foutname;
	if (argv[optind+1] == NULL) {
		foutname = new char[strlen(argv[optind]) + 4 + 1];
		strcpy(foutname, argv[optind]);
		strcat(foutname, ".asm");
	}
	else {
		foutname = new char[strlen(argv[optind+1])+1];
		strcpy(foutname, argv[optind+1]);
	}
	
	if ((outfile = fopen(foutname, "w")) == NULL) {
		printf("Could not create file: %s\n", argv[2]);
		return 0;
	}
	
	unsigned char word[2];
	fprintf(outfile, "          ORG %04x\n", offset);
	int pc = offset / 2;
	
	fseek(source, 0 , SEEK_END);
	long source_size = ftell(source);
	fseek(source, 0 , SEEK_SET);// needed for next read from beginning of file
	
	int first_pc = offset / 2;
	int last_pc = source_size / 2 + pc;
	
	while (fread(word, 2, 1, source) != 0) {
		int instruction = ((word[0] & 0xFF )<<8) | word[1];
		fprintf(outfile, "L%04d:    ", pc);
		int i;
		for (i = 0; i < INSTR_COUNT; i++) {
			if ((instruction & instr_set[i].opmask) == instr_set[i].opcode) {
				fprintf(outfile, "%s", instr_set[i].name);
				int args[ARG_MAX_COUNT] = {0,};
				for (int j = 0; j < INSTR_SIZE; j++) {
					if (instr_set[i].desc[j] != AT_NONE) {
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
						if ((args[arg_n] >= first_pc) && (args[arg_n] < last_pc)) {
							fprintf(outfile, " L%04d", args[arg_n] - first_pc);
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
						fprintf(outfile, " L%04d", pc + args[arg_n] + 1);
					} else
					if (instr_set[i].arg_type[arg_n] == AT_REG) {
						fprintf(outfile, " %s", general_reg[args[arg_n]]);
					} else
					if (instr_set[i].arg_type[arg_n] == AT_IOREG) {
						fprintf(outfile, " %s", io_reg[args[arg_n]]);
					} else
					if (instr_set[i].arg_type[arg_n] == AT_CHR) {
						fprintf(outfile, " %x\t;%c", args[arg_n], args[arg_n]);
					}
					else {
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
		pc++;
	}
	fclose(outfile);
	fclose(source);
	return 0;
}

