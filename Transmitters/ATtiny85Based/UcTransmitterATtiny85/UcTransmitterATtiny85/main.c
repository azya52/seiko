/*
 * UcTransmitterATtiny85.c
 * For ucTransmitter (see https://github.com/azya52/seiko) based on 
 * ATtiny85 with software UART. Normally works on an 8MHz internal oscillator,
 * but if the chip is not calibrated properly, an external quartz may be required.
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

#define PORT_COIL PB4
#define TRANSM_FREQ 32768

#include <avr/io.h>
#include <stdlib.h>
#include <avr/interrupt.h>
#include "softuart.h"

int SLEEP_CICLES = F_CPU/(TRANSM_FREQ*2);

void timer_init() {
	TCCR1 |= (1 << CS10);
}

void portes_init() {
	DDRB = 0x01 << PORT_COIL;
	PORTB = 0;
}

void send(unsigned char b){
	int parity = b^(b>>4);
	parity ^= parity>>2;
	parity ^= parity>>1;
	parity &= 0x01;

	int sendWord = b | (parity<<8) | (0x01<<9) | (0x01<<10);
	unsigned char sendBit = 1;
	unsigned char start = TCNT1;
	while(sendWord){
		for (int i = 0; i < 16; i++) {
			while ((unsigned char)(TCNT1-start) < SLEEP_CICLES);
			start += SLEEP_CICLES;
			PORTB |= sendBit << PORT_COIL;
			while ((unsigned char)(TCNT1-start) < SLEEP_CICLES);
			start += SLEEP_CICLES;
			PORTB &= ~(1 << PORT_COIL);
		}
		sendBit = !(sendWord & 0x01);
		sendWord >>= 1;
	}
}

int main(void) {
	timer_init();
	portes_init();
	softuart_init();
	sei();
	while (1) {
		if (softuart_kbhit()) {
			char c=softuart_getchar();
			cli();
			send(c);
			sei();
			softuart_init();
			softuart_putchar(c);
			softuart_putchar(0x13);
		}
    }
}

