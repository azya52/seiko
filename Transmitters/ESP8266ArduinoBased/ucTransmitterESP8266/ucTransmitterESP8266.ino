// min  -24000-12, 23600-12; mid - 16384-8; bad - 14336-7, 12288-6; vbad - 8192-4, 15000-8
#define TRANSM_FREQ 32768
unsigned long SLEEP_CICLES = ESP.getCpuFreqMHz()*1000000/(TRANSM_FREQ*2); 

void setup() {
  Serial.begin(2400);
  delay(500);
  pinMode(5, OUTPUT);
}

void send(char b){
  int parity = b^(b>>4);
  parity ^= parity>>2;
  parity ^= parity>>1;
  parity &= 0x01;

  int sendWord = b | (parity<<8) | (0x01<<9) | (0x01<<10);
  byte sendBit = 1;
  unsigned long start = ESP.getCycleCount();
  while(sendWord){
    for (int i = 0; i < 16; i++) { //min 12
      while (ESP.getCycleCount()-start < SLEEP_CICLES);
      start += SLEEP_CICLES;
      digitalWrite(5, sendBit);
      while (ESP.getCycleCount()-start < SLEEP_CICLES);
      start += SLEEP_CICLES;
      digitalWrite(5, LOW);
    }
    sendBit = !(sendWord & 0x01);
    sendWord >>= 1;
  }
}

void loop() {
  if ( Serial.available() ){
    char received = Serial.read();
    send(received);
    Serial.write(received);
    Serial.write(0x13);
  }
}
