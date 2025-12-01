ArrayList<Enemy> enemies = new ArrayList<Enemy>();
int enemiesToSpawn = 10;
int enemyTimer = 0;
int spawnInterval = 80;

class Enemy {
  float x, y, speed;
  Enemy(float x, float y, float speed) { this.x = x; this.y = y; this.speed = speed; }
  void update() { y += speed; }
  void draw() { fill(255, 0, 0); rect(x, y, 50, 50); }
}

void setup() {
  size(600, 700);
}

void draw() {
  background(0);
  
  // 生成敵人
  enemyTimer++;
  if (enemyTimer >= spawnInterval && enemiesToSpawn > 0) {
    enemies.add(new Enemy(random(50, width - 50), -50, 2));  // 隨機生成敵人
    enemiesToSpawn--;
    enemyTimer = 0;
  }
  
  // 更新敵人位置
  for (int i = enemies.size() - 1; i >= 0; i--) {
    enemies.get(i).update();
    enemies.get(i).draw();
    if (enemies.get(i).y > height + 50) enemies.remove(i);  // 移出畫面外的敵人
  }
}
