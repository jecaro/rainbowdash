#include "Rainbow.h"
#include "Commands.h"
#include <avr/pgmspace.h>

unsigned char buffer[2][96] = {
	{
		0x00, 0x00, 0x00, 0x4B, 0x00, 0x00, 0x04, 0xBF,
		0x00, 0x00, 0x4B, 0xFF, 0x00, 0x04, 0xBF, 0xFF,
		0x00, 0x4B, 0xFF, 0xFF, 0x04, 0xBF, 0xFF, 0xFF,
		0x4B, 0xFF, 0xFF, 0xFF, 0xBF, 0xFF, 0xFF, 0xFD,
		0xFF, 0xFD, 0x71, 0x00, 0xFF, 0xD7, 0x10, 0x00,
		0xFD, 0xF1, 0x00, 0x00, 0xDA, 0x10, 0x00, 0x00,
		0x71, 0x00, 0x00, 0x01, 0x10, 0x00, 0x00, 0x17,
		0x00, 0x00, 0x01, 0x7E, 0x00, 0x00, 0x17, 0xEF,
		0x06, 0xEF, 0xFF, 0xFF, 0x6E, 0xFF, 0xFF, 0xFF,
		0xEF, 0xFF, 0xFF, 0xFA, 0xFF, 0xFF, 0xFF, 0xA3,
		0xFF, 0xFF, 0xFA, 0x30, 0xFF, 0xFA, 0xA3, 0x00,
		0xFF, 0xFA, 0x30, 0x00, 0xFF, 0xA3, 0x00, 0x00
	},
	{
		0x00, 0x00, 0x00, 0x4B, 0x00, 0x00, 0x04, 0xBF,
		0x00, 0x00, 0x4B, 0xFF, 0x00, 0x04, 0xBF, 0xFF,
		0x00, 0x4B, 0xFF, 0xFF, 0x04, 0xBF, 0xFF, 0xFF,
		0x4B, 0xFF, 0xFF, 0xFF, 0xBF, 0xFF, 0xFF, 0xFD,
		0xFF, 0xFD, 0x71, 0x00, 0xFF, 0xD7, 0x10, 0x00,
		0xFD, 0xF1, 0x00, 0x00, 0xDA, 0x10, 0x00, 0x00,
		0x71, 0x00, 0x00, 0x01, 0x10, 0x00, 0x00, 0x17,
		0x00, 0x00, 0x01, 0x7E, 0x00, 0x00, 0x17, 0xEF,
		0x06, 0xEF, 0xFF, 0xFF, 0x6E, 0xFF, 0xFF, 0xFF,
		0xEF, 0xFF, 0xFF, 0xFA, 0xFF, 0xFF, 0xFF, 0xA3,
		0xFF, 0xFF, 0xFA, 0x30, 0xFF, 0xFA, 0xA3, 0x00,
		0xFF, 0xFA, 0x30, 0x00, 0xFF, 0xA3, 0x00, 0x00
	}
};

unsigned char whichbuf = 1;
unsigned char waiting = 1;
unsigned char command[5] = { 0, 0, 0, 0, 0 };

void setup() {
	cli();
	init_sh();
	set_buffer(buffer[0]);
	init_timer2();
	sei();
	Serial.begin(9600);
}

void loop() {
	if (waiting) {
		if (Serial.available() > 0) {
			if (Serial.read() == 'R') {
				waiting = 0;
			}
		}
	}
	if (!waiting) {
		if (Serial.available() >= 4) {
			command[1] = Serial.read();
			command[2] = Serial.read();
			command[3] = Serial.read();
			command[4] = Serial.read();
			if (is_command_buffered(command)) {
				do_command(buffer[whichbuf], command);
				set_next_buffer(buffer[whichbuf]);
				whichbuf ^= 1;
			} else {
				do_command(buffer[whichbuf ^ 1], command);
			}
			waiting = 1;
		}
	}
}

ISR(TIMER2_OVF_vect) {
	timer2_isr();
}
