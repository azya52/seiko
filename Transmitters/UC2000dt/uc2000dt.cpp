#include <iostream>
#include <stdlib.h>
#include <unistd.h>
#include "SerialPort.h"
#include <time.h>

bool send(SerialPort *comPort, FILE *source, bool runAferLoad){
	fseek(source, 0, SEEK_END);
	uint16_t fileSize = ftell(source);
	rewind(source);

	char *buffer = new char[fileSize];
    if (fread (buffer,1,fileSize,source) != fileSize) {
        std::cout << "File read error";
        delete [] buffer;
        return false;
    }
    
	int rcFileSize = fileSize;
	char *rData = new char[3];

	for (int page = 0, pos = 0; page < 8, pos < fileSize; page++) {
		comPort->writeSerialPort(0x04);
		Sleep(100);
		comPort->writeSerialPort((char)page);  //write to page
		Sleep(100);
		comPort->writeSerialPort(0); //start from
		Sleep(100);
		
		for (int i = 0; i < 256; i++) {
			pos = page * 256 + i;
			if (pos < fileSize) {
				comPort->writeSerialPort(buffer[pos]);
			} else {
				comPort->writeSerialPort(0x00);
			}
			Sleep(11);
			if ((i+1) % 4 == 0) {
				std::cout << (int)(pos/(double)(rcFileSize+255-(rcFileSize%256))*100) << "%\r";
			}
		}
		Sleep(100);
	}
	
	comPort->writeSerialPort(0x11);
	Sleep(100);
	comPort->writeSerialPort(0x18);
	if (runAferLoad) {
		Sleep(100);
		comPort->writeSerialPort(0x07);
		Sleep(100);
		comPort->writeSerialPort(0x18);
	}

    delete [] buffer;
	delete [] rData;
    return true;
}

int main(int argc, char *argv[]) {
	setbuf(stdout, NULL);
	
	if (argc <= 1) {
		printf("Usage: \n\t rc20dt [-p <port name>] [-r] <file name>\n\n\t\t-p\tCOM port (COM#)\n\t\t-r\trun the program after loading\n");
		return 0;
	}

	int boudRate = 2400;
	char portName[13] = "\\\\.\\COM1";

	bool runAferLoad = false;
	char *opts = (char *)"rp:";
	int opt;
	while ((opt = getopt(argc, argv, opts)) != -1) {
		switch (opt) {
			case 'p': 
				strncpy(portName+4, optarg, 5);
				break;
			case 'r': 
				runAferLoad = true;
				break;
		}
	}
	
	char **inputFiles = argv + optind;
	int inputFilesCount = argc - optind;

	std::cout << "Connect to RC20 on port " << portName << " with " << boudRate << " boud rate...\n";

	SerialPort *comPort = new SerialPort(portName, boudRate);
	if (comPort->isConnected()) {
		std::cout << "Connection Established\n";
	} else {
		std::cout << "Check port name\n";
		return 1;
	}
	
	if (inputFilesCount > 0) {
		FILE *source;
		if (inputFiles[0] == NULL || (source = fopen(inputFiles[0], "rb")) == NULL) {
			std::cout << "Could not open file \"" << inputFiles[0] << "\"\n";
			comPort->~SerialPort();
			return 1;
		}
		if(send(comPort, source, runAferLoad)){
			std::cout << "Send complete\n";
		} else {
			std::cout << "Data send error\n";
		}
		fclose(source);
	}

	comPort->~SerialPort();
	return 0;
}