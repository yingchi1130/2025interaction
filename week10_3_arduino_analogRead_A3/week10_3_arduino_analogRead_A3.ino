//week10_3_arduino_analogRead_A3
//把 joystick 的 Y 的線,經由麵包版幫忙,接到 MakerUNO 另一邊的 A3
//不能接其他的,因要接有~小蟲符號的, 代表aralog 訊號
void setup() {
  pinMode(2, INPUT_PULLUP);
  //pinMode(3, INPUT); //有小蟲符號 代表aralog 訊號
  pinMode(8, OUTPUT); //發聲

}

void loop() {
  int now = analogRead(A3);
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
