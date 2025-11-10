//week10_5_arduino_serial_joystick_to_processing
//修改自week10_4_arduino_serial_monitor_joystick_Serial_println
//但不是使用 Serial.println() 要改用 Serial.write() 0-1023 vs. 0-255 差了4倍
void setup() {
  Serial.begin(9600);
  pinMode(2, INPUT_PULLUP);
  pinMode(9, OUTPUT);
}

void loop() {
  delay(30); //改成慢一點,才不會太粗糙 1000Hz / processing 每秒60次
  int now = analogRead(A3) / 4; //小心 要除以4 才能順利由Serial.write()送出
  Serial.write(now); //把0-255的數值送出去
  if(now > 200) tone(8, 784, 100);
  if(now < 50) tone(8, 523, 100);
}
