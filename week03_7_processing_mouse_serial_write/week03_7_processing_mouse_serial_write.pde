//week03_7_processing_mouse_serial_write
import processing.serial.*; //使用Serial外掛
Serial myPort;
void setup(){
  size(400, 400);
  myPort = new Serial(this, "COM3", 9600);
} //COM3 COM4 COM5 還是 COM6  要查電腦
void mousePressed(){
  myPort.write("b"); //用USB傳字母'b'
}
void draw(){
  if(mousePressed) background(#FF0000);
  else background(#00FF00);
}
