//  圖片
PImage playerImg, enemyImg, bossImg,bgImg;  // 玩家、敵人、BOSS 和背景圖片

//  遊戲狀態
final int MENU = 0, GAME_PLAY = 1, GAME_BOSS = 2, GAME_WIN = 3, GAME_OVER = 4;  // 定義遊戲不同狀態
int gameState = MENU;  // 初始遊戲狀態為主選單

//  玩家資料
float playerX, playerY;  // 玩家座標
boolean left, right, up, down;  // 玩家移動方向
int playerHP = 100;  // 玩家血量
int score = 0;       // 玩家分數
int level = 1;       // 關卡等級
int maxLevel = 2;    // 最大關卡數

//  子彈、敵人
ArrayList<Bullet> bullets = new ArrayList<Bullet>();  // 玩家子彈列表
ArrayList<Enemy> enemies = new ArrayList<Enemy>();    // 敵人列表
ArrayList<EnemyBullet> enemyBullets = new ArrayList<EnemyBullet>();  // 敵人子彈列表
Boss boss;                  // BOSS
boolean bossSpawned = false;  // BOSS 是否生成

// 敵人生成控制
int enemiesToSpawn = 0;     // 要生成的敵人數量
int enemyTimer = 0;         // 敵人生成計時器
int spawnMin = 80, spawnMax = 110, spawnInterval = 80;  // 生成間隔控制

// 初始化
void setup() {
  size(600, 700);  // 設定遊戲畫布大小

  // 載入圖片
  playerImg = loadImage("player.png");  // 玩家圖片
  enemyImg  = loadImage("enemy.png");   // 敵人圖片
  bossImg   = loadImage("boss.png");    // BOSS圖片
  bgImg = loadImage("background.png");  // 背景圖片

  playerX = width/2;  // 玩家初始X座標在畫面中間
  playerY = height - 80;  // 玩家初始Y座標靠近畫面底部

  rectMode(CENTER);  // 矩形繪製模式以中心為基準
  textAlign(CENTER, CENTER);  // 文字置中對齊
}

// 主循環
void draw() {
  //background(0);  // 背景顏色(註解掉)
  imageMode(CORNER);  // 圖片繪製模式以左上角為基準
  image(bgImg, 0, 0, width, height);  // 畫背景圖

  if (gameState == MENU) drawMenu();          // 如果在主選單，畫選單畫面
  else if (gameState == GAME_PLAY) runGame(); // 如果在遊戲中，執行遊戲邏輯
  else if (gameState == GAME_BOSS) runBoss(); // 如果在BOSS戰，執行BOSS邏輯
  else if (gameState == GAME_WIN) drawWin();  // 勝利畫面
  else if (gameState == GAME_OVER) drawGameOver();  // 遊戲結束畫面
}

// 主選單
void drawMenu() {
  fill(255);  // 設定文字顏色為白色
  textSize(48);  // 文字大小
  text("SHOOTER GAME", width/2, height/2 - 120);  // 顯示遊戲標題

  textSize(28);  
  fill(255, 200, 0);  
  text("Press ENTER to Start", width/2, height/2 + 40);  // 提示開始遊戲

  fill(255);  
  text("Press ESC to Quit", width/2, height/2 + 100);  // 提示退出遊戲
}

// 開始關卡
void startLevel(int lv) {
  level = lv;  // 設定關卡

  if (lv == 1) score = 0;  // 第一關重置分數

  bullets.clear();        // 清空玩家子彈
  enemyBullets.clear();   // 清空敵人子彈
  enemies.clear();        // 清空敵人
  bossSpawned = false;    // 重置BOSS生成
  playerHP = 100;         // 重置玩家血量

  enemiesToSpawn = 10 + level * 6;  // 計算本關要生成的敵人數量
  spawnMin = (level == 1) ? 90 : 70;  // 敵人生成最小間隔
  spawnMax = (level == 1) ? 120 : 100; // 敵人生成最大間隔
  spawnInterval = int(random(spawnMin, spawnMax));  // 隨機生成間隔
  enemyTimer = 0;  // 重置計時器

  gameState = GAME_PLAY;  // 切換遊戲狀態為遊戲中
}


// 遊戲循環
void runGame() {
  updatePlayer();  // 更新玩家位置
  drawPlayer();    // 繪製玩家

  updateBullets();      // 更新玩家子彈
  updateEnemies();      // 更新敵人
  updateEnemyBullets(); // 更新敵人子彈
  drawHUD();            // 繪製HUD(分數、血量)

  if (playerHP <= 0) { 
    gameState = GAME_OVER;  // 玩家死亡，遊戲結束
    return; 
  }

  if (enemiesToSpawn == 0 && enemies.size() == 0 && !bossSpawned) {
    boss = new Boss(level);  // 生成BOSS
    bossSpawned = true;      // 記錄BOSS已生成
    gameState = GAME_BOSS;   // 進入BOSS戰
  }
}


// BOSS 戰
void runBoss() {

  updatePlayer();  // 更新玩家位置
  drawPlayer();    // 繪製玩家

  updateBullets();       // 更新玩家子彈
  updateEnemyBullets();  // 更新敵人子彈

  boss.update();   // 更新BOSS邏輯
  boss.draw();     // 繪製BOSS

  drawHUD();       // 繪製HUD

  if (playerHP <= 0) { gameState = GAME_OVER; return; }  // 玩家死亡，遊戲結束
  if (boss.hp <= 0) {  // BOSS死亡
    if (level < maxLevel) startLevel(level + 1);  // 升級到下一關
    else gameState = GAME_WIN;  // 遊戲勝利
  }
}


// 勝利畫面
void drawWin() {
  background(0);  // 黑色背景
  fill(255, 255, 0);  // 黃色文字
  textSize(48);  
  text("YOU WIN!", width/2, 260);  // 顯示勝利文字

  fill(255);  
  textSize(28);  
  text("Final Score: " + score, width/2, 350);  // 顯示最終分數
  text("Press ENTER to return menu", width/2, 420);  // 提示返回選單
}


// 遊戲結束畫面
void drawGameOver() {
  background(0);  // 黑色背景
  fill(255, 100, 100);  // 紅色文字
  textSize(48);  
  text("GAME OVER", width/2, 260);  // 顯示遊戲結束文字

  fill(255);  
  textSize(28);  
  text("Score: " + score, width/2, 350);  // 顯示分數
  text("Press ENTER to return", width/2, 430);  // 提示返回選單
}


// 玩家
void updatePlayer() {
  float speed = 5;  // 玩家移動速度

  if (left) playerX -= speed;   // 向左移動
  if (right) playerX += speed;  // 向右移動
  if (up) playerY -= speed;     // 向上移動
  if (down) playerY += speed;   // 向下移動

  playerX = constrain(playerX, 30, width-30);  // 限制X範圍
  playerY = constrain(playerY, 30, height-30); // 限制Y範圍

  //if (frameCount % 10 == 0) shootWeapon();  // 自動射擊(註解掉)
}

void drawPlayer() {
  imageMode(CENTER);  // 圖片中心對齊
  image(playerImg, playerX, playerY, 50, 50);  // 繪製玩家圖片
}

void shootWeapon() {
  if (level == 1) {  
    bullets.add(new Bullet(playerX, playerY-20));  // 發射單發子彈
  } else if (level == 2) {
    bullets.add(new Bullet(playerX-10, playerY-20));  // 發射雙發子彈
    bullets.add(new Bullet(playerX+10, playerY-20));
  }
}


// 玩家子彈
void updateBullets() {
  for (int i = bullets.size()-1; i >= 0; i--) {  // 反向遍歷列表，避免刪除錯位
    Bullet b = bullets.get(i);  
    b.update();  // 更新子彈位置
    b.draw();    // 繪製子彈
    if (b.remove) bullets.remove(i);  // 移除超出畫面子彈
  }
}


// 敵人
void updateEnemies() {

  if (enemiesToSpawn > 0) {  
    enemyTimer++;  
    if (enemyTimer >= spawnInterval) {  // 到達生成時間
      enemies.add(new Enemy(random(50, width-50), -50, level));  // 生成敵人
      enemiesToSpawn--;  
      enemyTimer = 0;  
      spawnInterval = int(random(spawnMin, spawnMax));  // 隨機下一個生成間隔
    }
  }

  for (int i = enemies.size()-1; i >= 0; i--) {  // 反向遍歷敵人列表
    Enemy e = enemies.get(i);  
    e.update();  // 更新敵人位置
    e.draw();    // 繪製敵人

    if (frameCount % max(10, 100 - level*10) == 0) {  // 敵人發射子彈
      for (int a=-20; a<=20; a+=20)
        enemyBullets.add(new EnemyBulletAngled(e.x, e.y+20, a));
    }

    if (dist(e.x, e.y, playerX, playerY) < 30) {  // 碰撞檢測
      playerHP -= 15;  
      enemies.remove(i);  
      continue;  
    }

    for (int j = bullets.size()-1; j >= 0; j--) {  // 玩家子彈碰撞敵人
      if (dist(bullets.get(j).x, bullets.get(j).y, e.x, e.y) < 25) {
        score += 10;  
        bullets.remove(j);  
        enemies.remove(i);  
        break;  
      }
    }

    if (e.y > height+50) enemies.remove(i);  // 超出畫面敵人移除
  }
}


// 敵人子彈
void updateEnemyBullets() {
  for (int i = enemyBullets.size()-1; i >= 0; i--) {  // 反向遍歷
    EnemyBullet eb = enemyBullets.get(i);  
    eb.update();  // 更新位置
    eb.draw();    // 繪製子彈

    if (dist(eb.x, eb.y, playerX, playerY) < 20) {  // 撞到玩家
      playerHP -= 10;  
      enemyBullets.remove(i);  
      continue;  
    }

    if (eb.y > height || eb.y < 0 || eb.x < 0 || eb.x > width)  // 超出畫面移除
      enemyBullets.remove(i);
  }
}


// HUD
void drawHUD() {
  fill(255);  
  textSize(20);  
  text("Score: " + score, 80, 30);  // 顯示分數
  text("Level: " + level, 80, 55);  // 顯示關卡

  fill(255, 0, 0);  
  rect(500, 35, 120, 18);  // 血量底色

  fill(0, 255, 0);  
  rect(500-(100-playerHP)*1.2/2, 35, playerHP*1.2, 18);  // 顯示血量條

  fill(255);  
  text("HP: " + playerHP, 500, 65);  // 顯示血量文字
}


// 鍵盤控制
void keyPressed() {
  if (keyCode == LEFT) left = true;  
  if (keyCode == RIGHT) right = true;  
  if (keyCode == UP) up = true;  
  if (keyCode == DOWN) down = true;  
  if (key == 'j' || key == 'J') shootWeapon();  // 按 J 發射子彈

  if (gameState == MENU && keyCode == ENTER) startLevel(1);  // 主選單按 ENTER 開始遊戲
  if ((gameState == GAME_OVER || gameState == GAME_WIN) && keyCode == ENTER)
    gameState = MENU;  // 遊戲結束或勝利按 ENTER 返回選單
}

void keyReleased() {
  if (keyCode == LEFT) left = false;  
  if (keyCode == RIGHT) right = false;  
  if (keyCode == UP) up = false;  
  if (keyCode == DOWN) down = false;  
}


// 類別：玩家子彈
class Bullet {
  float x, y, speed = 10;  // 子彈座標和速度
  boolean remove = false;   // 是否刪除

  Bullet(float x, float y) { this.x = x; this.y = y; }  // 建構子

  void update() {
    y -= speed;  // 子彈往上移動
    if (y < -20) remove = true;  // 超出畫面標記刪除
  }

  void draw() {
    fill(255, 255, 0);  
    ellipse(x, y, 8, 15);  // 繪製子彈
  }
}


// 類別：角度子彈
class BulletAngle extends Bullet {
  float vx, vy;  // 子彈x、y速度

  BulletAngle(float x, float y, float angle) {
    super(x, y);  
    float rad = radians(angle);  
    vx = sin(rad) * 7;  
    vy = -cos(rad) * 7;  
  }

  void update() {
    x += vx;  
    y += vy;  
    if (y < -20) remove = true;  // 超出畫面刪除
  }
}


// 類別：敵人
class Enemy {
  float x, y, speed, angle=0;  
  int type;  

  Enemy(float x, float y, int level) {
    this.x = x;  
    this.y = y;  
    type = int(random(0, 5));  // 隨機敵人類型
    speed = (2 + level * 0.7) * 0.85;  // 敵人速度
  }

  void update() {
    if      (type==0) y += speed;  // 直走
    else if (type==1){ y += speed; x += sin(y*0.05)*6; }  // 波浪
    else if (type==2){ y += speed; angle += 0.1; x += sin(angle)*6; }  // 振盪
    else if (type==3){ y += speed; x += (playerX-x)*0.02; }  // 追蹤玩家
    else if (type==4){ y += speed; x += cos(y*0.03)*8; }  // 另一種波浪

    x = constrain(x, 20, width-20);  // 限制X範圍
  }

  void draw() {
    imageMode(CENTER);  
    image(enemyImg, x, y, 50, 50);  // 繪製敵人
  }
}


// 類別：敵人子彈
class EnemyBullet {
  float x, y, speed = 6;  
  boolean remove = false;  

  EnemyBullet(float x, float y) { this.x=x; this.y=y; }

  void update() { y += speed * 0.95; }  // 往下移動

  void draw() {
    fill(255, 150, 0);  
    ellipse(x, y, 8, 12);  // 繪製敵人子彈
  }
}


// 類別：角度敵人子彈
class EnemyBulletAngled extends EnemyBullet {
  float vx, vy;  

  EnemyBulletAngled(float x, float y, float angle) {
    super(x, y);  
    float rad = radians(angle);  
    vx = sin(rad)*5;  
    vy = cos(rad)*5;  
  }

  void update() {
    x += vx;  
    y += vy * 0.75;  
    if (y>height || y<0 || x<0 || x>width) remove = true;  // 超出畫面刪除
  }
}


// 類別：BOSS
class Boss {
  float x, y, hp, dir=3, angle=0;  
  int phase = 1;  

  Boss(int lv) {
    x = width/2;  
    y = 140;  
    hp = 50 + lv * 100;  // 血量隨關卡增加
  }

  void update() {
    x += dir;  
    if (x < 120 || x > width-120) dir *= -1;  // 到邊界反向

    if (phase == 1) {  
      y += sin(frameCount * 0.03) * 0.5;  // 微幅上下移動
      if (frameCount % 60 == 0)
        enemyBullets.add(new EnemyBullet(x, y+50));  // 發射子彈
    }

    if (phase == 2) {  
      if (dir > 0) dir = min(dir+0.05, 5);  
      else         dir = max(dir-0.05, -5);  

      if (frameCount % 45 == 0) {  
        for (int a=-30; a<=30; a+=15)
          enemyBullets.add(new EnemyBulletAngled(x, y+50, a));  // 角度子彈
      }
    }

    if (hp < (50 + level*50) && phase == 1)
      phase = 2;  // 血量低於一定值切換階段

    for (int i = bullets.size()-1; i >= 0; i--) {  
      Bullet b = bullets.get(i);  
      if (dist(b.x, b.y, x, y) < 60) {  
        bullets.remove(i);  
        hp -= 5;  // 被玩家子彈擊中扣血
      }
    }
  }

  void draw() {
    imageMode(CENTER);  
    image(bossImg, x, y, 180, 140);  // 繪製BOSS

    fill(255);  
    textSize(20);  
    text("Boss HP: " + int(hp), width/2, 80);  // 顯示BOSS血量
  }
}
