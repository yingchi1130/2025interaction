//week11_2_pacman_part1_mouth_m_dm_open_close
//小精靈張嘴
void setup(){
  size(500, 500); 
}
int x = 250, y = 250;
float m = 0, dm = 0.05; //嘴巴大小mouth, 嘴巴改變量diff of m
void draw(){
  background(0);
  fill(255, 255, 0); //黃色的
  //ellipse(x, y, 30, 30);
  arc(x, y, 30, 30, +m, PI*2 - m); //有個弧度,從正0.5 到-0.5
  if(m>=1 || m<0) dm = -dm; //正負倒過來
  m += dm;
}
