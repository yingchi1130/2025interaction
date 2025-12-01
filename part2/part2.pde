float playerX, playerY;
boolean left, right, up, down;

void setup() {
  size(600, 700);
  playerX = width / 2;
  playerY = height - 80;
}

void draw() {
  background(0);
  
  // 玩家控制
  float speed = 5;
  if (left) playerX -= speed;
  if (right) playerX += speed;
  if (up) playerY -= speed;
  if (down) playerY += speed;
  
  // 限制玩家移動範圍
  playerX = constrain(playerX, 30, width - 30);
  playerY = constrain(playerY, 30, height - 30);
  
  // 繪製玩家
  fill(0, 255, 0);
  rect(playerX, playerY, 50, 50);  // 使用方塊表示玩家
}

//鍵盤操作
void keyPressed() {
  if (keyCode == LEFT) left = true;
  if (keyCode == RIGHT) right = true;
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
}
//鍵盤釋放
void keyReleased() {
  if (keyCode == LEFT) left = false;
  if (keyCode == RIGHT) right = false;
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
}
