float playerX, playerY;
boolean left, right, up, down;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

class Bullet {
  float x, y, speed = 10;
  boolean remove = false;
  
  Bullet(float x, float y) { this.x = x; this.y = y; }
  
  void update() { y -= speed; if (y < -20) remove = true; }
  void draw() { fill(255, 255, 0); ellipse(x, y, 8, 15); }
}

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
  
  // 繪製玩家
  fill(0, 255, 0);
  rect(playerX, playerY, 50, 50);  // 玩家顯示
  
  // 更新與繪製子彈
  for (int i = bullets.size() - 1; i >= 0; i--) {
    bullets.get(i).update();
    bullets.get(i).draw();
    if (bullets.get(i).remove) bullets.remove(i);  // 刪除超出畫面的子彈
  }
}

void keyPressed() {
  if (keyCode == LEFT) left = true;
  if (keyCode == RIGHT) right = true;
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
  if (key == 'j' || key == 'J') shootWeapon();  // 按 J 鍵發射子彈
}

void keyReleased() {
  if (keyCode == LEFT) left = false;
  if (keyCode == RIGHT) right = false;
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
}

void shootWeapon() {
  bullets.add(new Bullet(playerX, playerY - 20));  // 發射單發子彈
}
