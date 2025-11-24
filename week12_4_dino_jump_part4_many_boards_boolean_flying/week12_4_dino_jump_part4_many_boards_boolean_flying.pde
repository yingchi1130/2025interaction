//week12_4_dino_jump_part4_many_boards_boolean_flying
//修改自week12_3_dino_jump_part3_boardX_falling
//恐龍跳跳跳 (3)板子 (4)卡在板子上
PImage img;
void setup(){
  size(300,500);
  img = loadImage("dino.gif");
}
//float boardX = 200, boardY = 400;
float [] boardX = {50,200,100,200}; //把原來1個的變數,變很多個的陣列
float [] boardY = {100,200,300,400};
float x = 200, y = 400, dx=0, dy=0;
void draw(){
  background(255);
  boolean flying = true;
  for(int i=0; i<4; i++){
    rect(boardX[i], boardY[i], 100, 5); 
    if(y+100 <= boardY[i] && y+dy+100 >= boardY[i] && boardX[i] <= x+100 && x <= boardX[i]+100){
    y = boardY[i] - 100;
    dy = 0;
    flying = false; //卡在板子上,就不是飛行    
  }
 }
 if(flying){ //如果有在飛行
    y += dy;
    if(y<400) dy += 0.98;
    else{
      dy = 0;
      flying = false;
    }
  }
  image(img, x, y, 100, 100);
  x += dx;
}
void keyPressed(){
  if(keyCode==UP) dy = -15;
  if(keyCode==LEFT) dx = -1; //左
  if(keyCode==RIGHT) dx = +1; //右
}
void keyReleased(){
  if(keyCode==LEFT || keyCode==RIGHT) dx = 0; //放開不要再左右移動了 
}
