//week11_3_pacman_part2_move_x_y_void_keyPressed
//修改自week11_2_pacman_part1_mouth_m_dm_open_close
//小精靈張嘴(在動)
void setup(){
  size(500, 500); 
}
int x = 250, y = 250, dx=0, dy=0;
float m = 0, dm = 0.05; //嘴巴大小mouth, 嘴巴改變量diff of m
void draw(){
  background(0);
  fill(255, 255, 0); //黃色的
  arc(x, y, 30, 30, +m, PI*2 - m); //有個弧度,從正0.5 到-0.5
  x+=dx; //改變座標
  y+=dy; //改變座標
  if(m>=1 || m<0) dm = -dm; //正負倒過來
  m += dm;
}
void keyPressed(){
 if(keyCode==LEFT) { dx = -1; dy=0; }
 if(keyCode==RIGHT) { dx = +1; dy=0; }
 if(keyCode==UP) { dx = 0; dy=-1; }
 if(keyCode==DOWN) { dx = 0; dy=+1; }
}
