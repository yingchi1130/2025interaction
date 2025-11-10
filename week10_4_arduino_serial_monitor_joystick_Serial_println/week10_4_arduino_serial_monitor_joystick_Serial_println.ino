//week10_4_arduino_serial_monitor_joystick_Serial_println
//修改自week10_3_arduino_analogRead_A3
//把 joystick 的 Y 的線,經由麵包版幫忙,接到 MakerUNO 另一邊的 A3
//不能接其他的,因要接有~小蟲符號的, 代表aralog 訊號
void setup() {
  Serial.begin(9600); //開啟USB傳輸
  pinMode(2, INPUT_PULLUP);
  pinMode(8, OUTPUT); //發聲

}

void loop() { //一秒鐘,會跑1000HZ
delay(100); //慢一點, 避免processing來不及處理, 眼睛看不到
  int now = analogRead(A3);
  Serial.println(now);
  //想利用 Serial Monitor 來看看會送出什麼訊號
  if(now > 800){ //高
    tone(8, 523, 100); //發出523 的Do
    delay(100);
    tone(8, 784, 100); //發出784 的So
    delay(100);
  }else if(now < 200){
    tone(8, 784, 100); //發出784 的So
    delay(100);
    tone(8, 523, 100); //發出523 的Do
    delay(100);
  }
}
