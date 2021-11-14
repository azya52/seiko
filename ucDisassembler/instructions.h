#define INSTR_COUNT 61
#define INSTR_SIZE 16
#define ARG_MAX_COUNT 3

enum arg_type {AT_NONE, AT_REG, AT_IOREG, AT_ADR12, AT_ADR11, AT_ADR10, AT_ADR5, AT_IMD, AT_CHR};

const char* general_reg[32] = {
	"RA0","RA1","RA2","RA3","RA4","RA5","RA6","RA7",
	"RB0","RB1","RB2","RB3","RB4","RB5","RB6","RB7",
	"RC0","RC1","RC2","RC3","RC4","RC5","RC6","RC7",
	"RD0","RD1","RD2","RD3","RD4","RD5","RD6","RD7"
};

const char* io_reg[16] = {
	"SR0","SR1","SR2","SR3","SR4","SR5","SR6","SR7",
	"SR8","SR9","SR10","SR11","SR12","SR13","SR14","SR15"
};

const char* bank[4] = {
	"B0","B1","B2","B3"
};

typedef struct {
	const char* name;
	int opcode;
	int opmask;
	int desc[INSTR_SIZE];
	arg_type arg_type[ARG_MAX_COUNT];
	int label;
} instruction_s;

static const instruction_s instr_set[INSTR_COUNT]{
	{ "ADD",  0x0000, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "ADB",  0x0400, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "SUB",  0x0800, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "SBB",  0x0C00, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "ADI",  0x1000, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,0 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "ADBI", 0x1400, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,0 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "SBI",  0x1800, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,0 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "SBBI", 0x1C00, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,0 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "ADM",  0x2000, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "ADBM", 0x2400, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "SBM",  0x2800, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "SBBM", 0x2C00, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "CMP",  0x3000, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "CPM",  0x3400, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "CPI",  0x3800, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,0 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "LCRB", 0x3C00, 0xFE00,{ 0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0 },{ AT_IMD, AT_NONE, AT_NONE } },
	{ "LARB", 0x3E00, 0xFE00,{ 0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0 },{ AT_IMD, AT_NONE, AT_NONE } },
	{ "ANDI", 0x4000, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,0 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "ORI",  0x4400, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,0 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "XORI", 0x4800, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,0 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "INC",  0x4C00, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "INCB", 0x4C08, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "DEC",  0x4C10, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "DECB", 0x4C18, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "RSHM", 0x5000, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "LSHM", 0x5008, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "IN",   0x5400, 0xFC10,{ 0,0,0,0,0,0,1,1,1,1,1,0,2,2,2,2 },{ AT_REG, AT_IOREG, AT_NONE } },
	{ "OUT",  0x5800, 0xFC10,{ 0,0,0,0,0,0,2,2,2,2,2,0,1,1,1,1 },{ AT_IOREG, AT_REG, AT_NONE } },
	{ "OUTI", 0x5C00, 0xFC30,{ 0,0,0,0,0,0,2,2,2,2,0,0,1,1,1,1 },{ AT_IOREG, AT_IMD, AT_NONE } },
	{ "PSAM", 0x6000, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "PLAM", 0x6010, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "LDSM", 0x6408, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "STSM", 0x6400, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "STLM", 0x6800, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "STL",  0x6C00, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0 },{ AT_REG, AT_NONE, AT_NONE } },
	{ "PSAI", 0x7000, 0xF800,{ 0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1 },{ AT_ADR11, AT_NONE, AT_NONE } },
	{ "PLAI", 0x7800, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,1 },{ AT_IMD, AT_NONE, AT_NONE } },
	{ "STLS", 0x7C00, 0xFC18,{ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },{ AT_NONE, AT_NONE, AT_NONE } },
	{ "STLSA",0x7C08, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,1 },{ AT_IMD, AT_NONE, AT_NONE } },
	{ "STLI", 0x7C10, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,1 },{ AT_CHR, AT_NONE, AT_NONE } },
	{ "STLIA",0x7C18, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,1 },{ AT_IMD, AT_NONE, AT_NONE } },
	{ "MOV",  0x8000, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "MOVM", 0x8400, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "LDI",  0x8800, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,0 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "CLRM", 0x8C00, 0xFC18,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,2,2,2 },{ AT_REG, AT_IMD, AT_NONE } },
	{ "MVAC", 0x9000, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "MVACM",0x9400, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "MVCA", 0x9800, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "MVCAM",0x9C00, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_REG, AT_NONE } },
	{ "CALL", 0xA000, 0xF000,{ 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1 },{ AT_ADR12, AT_NONE, AT_NONE } },
	{ "RET",  0xB000, 0xFFFF,{ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },{ AT_NONE, AT_NONE, AT_NONE } },
	{ "CPFJR",0xB400, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2 },{ AT_REG, AT_ADR5, AT_NONE } },
	{ "IJMR", 0xB800, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0 },{ AT_REG, AT_NONE, AT_NONE } },
	{ "WFI",  0xBC00, 0xFFFF,{ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },{ AT_NONE, AT_NONE, AT_NONE } },
	{ "JMP",  0xC000, 0xF000,{ 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1 },{ AT_ADR12, AT_NONE, AT_NONE } },
	{ "JZ",   0xD000, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1 },{ AT_ADR10, AT_NONE, AT_NONE } },
	{ "JNZ",  0xD400, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1 },{ AT_ADR10, AT_NONE, AT_NONE } },
	{ "JC",   0xD800, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1 },{ AT_ADR10, AT_NONE, AT_NONE } },
	{ "JNC",  0xDC00, 0xFC00,{ 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1 },{ AT_ADR10, AT_NONE, AT_NONE } },
	{ "BTJR", 0xE000, 0xF000,{ 0,0,0,0,2,2,1,1,1,1,1,3,3,3,3,3 },{ AT_REG, AT_IMD, AT_ADR5 } },
	{ "CPJR", 0xF000, 0xF000,{ 0,0,0,0,2,2,1,1,1,1,1,3,3,3,3,3 },{ AT_REG, AT_IMD, AT_ADR5 } }
};
