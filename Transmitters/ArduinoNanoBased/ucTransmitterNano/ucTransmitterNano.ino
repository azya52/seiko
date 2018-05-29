#define TRANSM_FREQ 32768
#define COIL_PIN 2
unsigned long SLEEP_uSEC = 1000000/TRANSM_FREQ/2;

void setup() {
  Serial.begin(9600);
  while (!Serial) {
  }
  pinMode(COIL_PIN, OUTPUT);
}

void send(byte b){
  int parity = b^(b>>4);
  parity ^= parity>>2;
  parity ^= parity>>1;
  parity &= 0x01;

  int sendWord = b | (parity<<8) | (0x01<<9) | (0x01<<10);
  byte sendBit = 1;
  unsigned long start = micros();
  while(sendWord){
    for (int i = 0; i < 16; i++) { //min 12
      while (micros()-start < SLEEP_uSEC);
      start += SLEEP_uSEC;
      digitalWrite(COIL_PIN, sendBit);
      while (micros()-start < SLEEP_uSEC);
      start += SLEEP_uSEC;
      digitalWrite(COIL_PIN, LOW);
    }
    sendBit = !(sendWord & 0x01);
    sendWord >>= 1;
  }
}

void loop() {
  if ( Serial.available() ){
    byte received = Serial.read();
    send(received);
    Serial.write(received);
    Serial.write(0x13);
    Serial.flush();
  }
}
