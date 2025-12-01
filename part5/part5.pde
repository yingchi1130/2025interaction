ArrayList<Bullet> bullets = new ArrayList<Bullet>();  // 儲存玩家的子彈
ArrayList<Enemy> enemies = new ArrayList<Enemy>();    // 儲存敵人
int score = 0;  // 玩家分數
float playerX, playerY;  // 玩家座標
boolean left, right, up, down;  // 玩家控制
int enemyTimer = 0;  // 敵人生成計時器
int spawnInterval = 100;  // 敵人生成間隔

// 玩家子彈類別
class Bullet {
  float x, y, speed = 10;  // 子彈的座標和速度
  boolean remove = false;  // 是否刪除

  Bullet(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // 更新子彈位置
  void update() {
    y -= speed;  // 子彈向上移動
    if (y < -20) remove = true;  // 超出畫面標記為刪除
  }

  // 繪製子彈
  void draw() {
    fill(255, 255, 0);  // 子彈顏色為黃色
    ellipse(x, y, 8, 15);  // 繪製圓形子彈
  }
}

// 敵人類別
class Enemy {
  float x, y, speed;  // 敵人的座標和速度

  Enemy(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }

  // 更新敵人位置
  void update() {
    y += speed;  // 敵人向下移動
  }

  // 繪製敵人
  void draw() {
    fill(255, 0, 0);  // 敵人顏色為紅色
    rect(x, y, 50, 50);  // 繪製方形敵人
  }
}

void setup() {
  size(600, 700);  // 設定畫布大小
  playerX = width / 2;  // 玩家初始X座標
  playerY = height - 80;  // 玩家初始Y座標
}

void draw() {
  background(0);  // 背景顏色為黑色

  // 生成敵人
  enemyTimer++;
  if (enemyTimer >= spawnInterval) {
    enemies.add(new Enemy(random(50, width - 50), -50, random(2, 5)));  // 生成敵人
    enemyTimer = 0;  // 重置計時器
  }

  // 更新並繪製敵人
  if (enemies.size() > 0) {  // 確保列表非空再處理
    for (int i = enemies.size() - 1; i >= 0; i--) {  // 反向遍歷
      Enemy enemy = enemies.get(i);
      enemy.update();
      enemy.draw();
  
      // 檢查玩家的子彈是否碰撞到敵人
      if (bullets.size() > 0) {  // 確保子彈列表非空
        for (int j = bullets.size() - 1; j >= 0; j--) {
          // 計算子彈與敵人的距離，假設子彈和敵人都是圓形
          if (dist(bullets.get(j).x, bullets.get(j).y, enemy.x + 25, enemy.y + 25) < 35) {
            bullets.remove(j);  // 移除子彈
            enemies.remove(i);  // 移除敵人
            score += 10;  // 每擊中一個敵人加10分
            break;  // 跳出內層迴圈，避免重複計算碰撞
          }
        }
      }
  
      // 如果敵人超出畫面，移除敵人
      if (enemy.y > height + 50) {
        enemies.remove(i);
      }
    }
  }

  // 更新並繪製子彈
  if (bullets.size() > 0) {  // 確保子彈列表非空
    for (int i = bullets.size() - 1; i >= 0; i--) {
      bullets.get(i).update();
      bullets.get(i).draw();
      if (bullets.get(i).remove) bullets.remove(i);  // 刪除超出畫面的子彈
    }
  }

  // 顯示分數
  fill(255);
  textSize(20);
  text("Score: " + score, 20, 30);  // 顯示目前的分數
  
  // 玩家控制
  movePlayer();
  drawPlayer();
}

// 控制玩家移動
void movePlayer() {
  float speed = 5;  // 移動速度

  if (left) playerX -= speed;  
  if (right) playerX += speed;  
  if (up) playerY -= speed;  
  if (down) playerY += speed;  

  // 限制玩家不超出畫面邊界
  playerX = constrain(playerX, 30, width - 30);
  playerY = constrain(playerY, 30, height - 30);
}

// 繪製玩家
void drawPlayer() {
  fill(0, 255, 0);  // 玩家顏色為綠色
  rect(playerX, playerY, 50, 50);  // 繪製玩家
}

// 發射子彈
void keyPressed() {
  if (key == 'j' || key == 'J') shootWeapon();  // 按 J 鍵發射子彈
  if (keyCode == LEFT) left = true;  // 玩家向左移動
  if (keyCode == RIGHT) right = true;  // 玩家向右移動
  if (keyCode == UP) up = true;  // 玩家向上移動
  if (keyCode == DOWN) down = true;  // 玩家向下移動
}

// 停止玩家移動
void keyReleased() {
  if (keyCode == LEFT) left = false;  // 停止向左移動
  if (keyCode == RIGHT) right = false;  // 停止向右移動
  if (keyCode == UP) up = false;  // 停止向上移動
  if (keyCode == DOWN) down = false;  // 停止向下移動
}

// 發射子彈
void shootWeapon() {
  bullets.add(new Bullet(playerX + 25, playerY));  // 玩家在其位置發射子彈
}
