
//  圖片
PImage playerImg, enemyImg, bossImg,bgImg;


//  遊戲狀態
final int MENU = 0, GAME_PLAY = 1, GAME_BOSS = 2, GAME_WIN = 3, GAME_OVER = 4;
int gameState = MENU;

//  玩家資料
float playerX, playerY;
boolean left, right, up, down;
int playerHP = 100;
int score = 0;
int level = 1;
int maxLevel = 2;


//  子彈、敵人
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<EnemyBullet> enemyBullets = new ArrayList<EnemyBullet>();
Boss boss;
boolean bossSpawned = false;

// 敵人生成控制
int enemiesToSpawn = 0;
int enemyTimer = 0;
int spawnMin = 80, spawnMax = 110, spawnInterval = 80;


// 初始化
void setup() {
  size(600, 700);

  // 載入圖片
  playerImg = loadImage("player.png");
  enemyImg  = loadImage("enemy.png");
  bossImg   = loadImage("boss.png");
  bgImg = loadImage("background.png");

  playerX = width/2;
  playerY = height - 80;

  rectMode(CENTER);
  textAlign(CENTER, CENTER);
}


// 主循環
void draw() {
  //background(0);
  imageMode(CORNER);
  image(bgImg, 0, 0, width, height);

  if (gameState == MENU) drawMenu();
  else if (gameState == GAME_PLAY) runGame();
  else if (gameState == GAME_BOSS) runBoss();
  else if (gameState == GAME_WIN) drawWin();
  else if (gameState == GAME_OVER) drawGameOver();
}


// 主選單
void drawMenu() {
  fill(255);
  textSize(48);
  text("SHOOTER GAME", width/2, height/2 - 120);

  textSize(28);
  fill(255, 200, 0);
  text("Press ENTER to Start", width/2, height/2 + 40);

  fill(255);
  text("Press ESC to Quit", width/2, height/2 + 100);
}


// 開始關卡
void startLevel(int lv) {
  level = lv;

  if (lv == 1) score = 0;

  bullets.clear();
  enemyBullets.clear();
  enemies.clear();
  bossSpawned = false;
  playerHP = 100;

  enemiesToSpawn = 10 + level * 6;
  spawnMin = (level == 1) ? 90 : 70;
  spawnMax = (level == 1) ? 120 : 100;
  spawnInterval = int(random(spawnMin, spawnMax));
  enemyTimer = 0;

  gameState = GAME_PLAY;
}


// 遊戲循環
void runGame() {
  updatePlayer();
  drawPlayer();

  updateBullets();
  updateEnemies();
  updateEnemyBullets();
  drawHUD();

  if (playerHP <= 0) { 
    gameState = GAME_OVER; 
    return; 
  }

  if (enemiesToSpawn == 0 && enemies.size() == 0 && !bossSpawned) {
    boss = new Boss(level);
    bossSpawned = true;
    gameState = GAME_BOSS;
  }
}


// BOSS 戰
void runBoss() {

  updatePlayer();
  drawPlayer();

  updateBullets();
  updateEnemyBullets();

  boss.update();
  boss.draw();

  drawHUD();

  if (playerHP <= 0) { gameState = GAME_OVER; return; }
  if (boss.hp <= 0) {
    if (level < maxLevel) startLevel(level + 1);
    else gameState = GAME_WIN;
  }
}


// 勝利畫面
void drawWin() {
  background(0);
  fill(255, 255, 0);
  textSize(48);
  text("YOU WIN!", width/2, 260);

  fill(255);
  textSize(28);
  text("Final Score: " + score, width/2, 350);
  text("Press ENTER to return menu", width/2, 420);
}


// 遊戲結束畫面
void drawGameOver() {
  background(0);
  fill(255, 100, 100);
  textSize(48);
  text("GAME OVER", width/2, 260);

  fill(255);
  textSize(28);
  text("Score: " + score, width/2, 350);
  text("Press ENTER to return", width/2, 430);
}


// 玩家
void updatePlayer() {
  float speed = 5;

  if (left) playerX -= speed;
  if (right) playerX += speed;
  if (up) playerY -= speed;
  if (down) playerY += speed;

  playerX = constrain(playerX, 30, width-30);
  playerY = constrain(playerY, 30, height-30);

  //if (frameCount % 10 == 0) shootWeapon();
}

void drawPlayer() {
  imageMode(CENTER);
  image(playerImg, playerX, playerY, 50, 50);
}

void shootWeapon() {
  if (level == 1) {
    bullets.add(new Bullet(playerX, playerY-20));
  } else if (level == 2) {
    bullets.add(new Bullet(playerX-10, playerY-20));
    bullets.add(new Bullet(playerX+10, playerY-20));
  }
}


// 玩家子彈
void updateBullets() {
  for (int i = bullets.size()-1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.draw();
    if (b.remove) bullets.remove(i);
  }
}


// 敵人
void updateEnemies() {

  if (enemiesToSpawn > 0) {
    enemyTimer++;
    if (enemyTimer >= spawnInterval) {
      enemies.add(new Enemy(random(50, width-50), -50, level));
      enemiesToSpawn--;
      enemyTimer = 0;
      spawnInterval = int(random(spawnMin, spawnMax));
    }
  }

  for (int i = enemies.size()-1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.draw();

    if (frameCount % max(10, 100 - level*10) == 0) {
      for (int a=-20; a<=20; a+=20)
        enemyBullets.add(new EnemyBulletAngled(e.x, e.y+20, a));
    }

    if (dist(e.x, e.y, playerX, playerY) < 30) {
      playerHP -= 15;
      enemies.remove(i);
      continue;
    }

    for (int j = bullets.size()-1; j >= 0; j--) {
      if (dist(bullets.get(j).x, bullets.get(j).y, e.x, e.y) < 25) {
        score += 10;
        bullets.remove(j);
        enemies.remove(i);
        break;
      }
    }

    if (e.y > height+50) enemies.remove(i);
  }
}


// 敵人子彈
void updateEnemyBullets() {
  for (int i = enemyBullets.size()-1; i >= 0; i--) {
    EnemyBullet eb = enemyBullets.get(i);
    eb.update();
    eb.draw();

    if (dist(eb.x, eb.y, playerX, playerY) < 20) {
      playerHP -= 10;
      enemyBullets.remove(i);
      continue;
    }

    if (eb.y > height || eb.y < 0 || eb.x < 0 || eb.x > width)
      enemyBullets.remove(i);
  }
}


// HUD
void drawHUD() {
  fill(255);
  textSize(20);
  text("Score: " + score, 80, 30);
  text("Level: " + level, 80, 55);

  fill(255, 0, 0);
  rect(500, 35, 120, 18);

  fill(0, 255, 0);
  rect(500-(100-playerHP)*1.2/2, 35, playerHP*1.2, 18);

  fill(255);
  text("HP: " + playerHP, 500, 65);
}


// 鍵盤控制
void keyPressed() {
  if (keyCode == LEFT) left = true;
  if (keyCode == RIGHT) right = true;
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
  if (key == 'j' || key == 'J') shootWeapon();


  if (gameState == MENU && keyCode == ENTER) startLevel(1);
  if ((gameState == GAME_OVER || gameState == GAME_WIN) && keyCode == ENTER)
    gameState = MENU;
}

void keyReleased() {
  if (keyCode == LEFT) left = false;
  if (keyCode == RIGHT) right = false;
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
}


// 類別：玩家子彈
class Bullet {
  float x, y, speed = 10;
  boolean remove = false;

  Bullet(float x, float y) { this.x = x; this.y = y; }

  void update() {
    y -= speed;
    if (y < -20) remove = true;
  }

  void draw() {
    fill(255, 255, 0);
    ellipse(x, y, 8, 15);
  }
}


// 類別：角度子彈
class BulletAngle extends Bullet {
  float vx, vy;

  BulletAngle(float x, float y, float angle) {
    super(x, y);
    float rad = radians(angle);
    vx = sin(rad) * 7;
    vy = -cos(rad) * 7;
  }

  void update() {
    x += vx;
    y += vy;
    if (y < -20) remove = true;
  }
}


// 類別：敵人
class Enemy {
  float x, y, speed, angle=0;
  int type;

  Enemy(float x, float y, int level) {
    this.x = x;
    this.y = y;
    type = int(random(0, 5));
    speed = (2 + level * 0.7) * 0.85;
  }

  void update() {
    if      (type==0) y += speed;
    else if (type==1){ y += speed; x += sin(y*0.05)*6; }
    else if (type==2){ y += speed; angle += 0.1; x += sin(angle)*6; }
    else if (type==3){ y += speed; x += (playerX-x)*0.02; }
    else if (type==4){ y += speed; x += cos(y*0.03)*8; }

    x = constrain(x, 20, width-20);
  }

  void draw() {
    imageMode(CENTER);
    image(enemyImg, x, y, 50, 50);
  }
}


// 類別：敵人子彈
class EnemyBullet {
  float x, y, speed = 6;
  boolean remove = false;

  EnemyBullet(float x, float y) { this.x=x; this.y=y; }

  void update() { y += speed * 0.95; }

  void draw() {
    fill(255, 150, 0);
    ellipse(x, y, 8, 12);
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
    if (y>height || y<0 || x<0 || x>width) remove = true;
  }
}


// 類別：BOSS
class Boss {
  float x, y, hp, dir=3, angle=0;
  int phase = 1;

  Boss(int lv) {
    x = width/2;
    y = 140;
    hp = 200 + lv * 100;
  }

  void update() {
    x += dir;
    if (x < 120 || x > width-120) dir *= -1;

    if (phase == 1) {
      y += sin(frameCount * 0.03) * 0.5;
      if (frameCount % 60 == 0)
        enemyBullets.add(new EnemyBullet(x, y+50));
    }

    if (phase == 2) {
      if (dir > 0) dir = min(dir+0.05, 5);
      else         dir = max(dir-0.05, -5);

      if (frameCount % 45 == 0) {
        for (int a=-30; a<=30; a+=15)
          enemyBullets.add(new EnemyBulletAngled(x, y+50, a));
      }
    }

    if (hp < (200 + level*50) && phase == 1)
      phase = 2;

    for (int i = bullets.size()-1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      if (dist(b.x, b.y, x, y) < 60) {
        bullets.remove(i);
        hp -= 5;
      }
    }
  }

  void draw() {
    imageMode(CENTER);
    image(bossImg, x, y, 180, 140);

    fill(255);
    textSize(20);
    text("Boss HP: " + int(hp), width/2, 80);
  }
}
