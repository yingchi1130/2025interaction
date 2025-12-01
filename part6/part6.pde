
// 遊戲狀態
final int MENU = 0, GAME_PLAY = 1, GAME_BOSS = 2, GAME_WIN = 3, GAME_OVER = 4; // 定義遊戲不同狀態的常數
int gameState = MENU; // 初始化遊戲狀態為主選單

// 玩家資料
float playerX, playerY; // 玩家座標
boolean left, right, up, down; // 玩家移動方向布林值
int playerHP = 100; // 玩家血量
int score = 0; // 分數
int level = 1; // 當前關卡
int maxLevel = 2; // 最大關卡

// 子彈與敵人

ArrayList<Bullet> bullets = new ArrayList<Bullet>(); // 玩家子彈列表
ArrayList<Enemy> enemies = new ArrayList<Enemy>(); // 敵人列表
ArrayList<EnemyBullet> enemyBullets = new ArrayList<EnemyBullet>(); // 敵人子彈列表
Boss boss; // BOSS 物件
boolean bossSpawned = false; // BOSS 是否生成

// 敵人生成控制
int enemiesToSpawn = 0; // 剩餘要生成的敵人數量
int enemyTimer = 0; // 計時器，用於控制敵人生成間隔
int spawnMin = 80, spawnMax = 110, spawnInterval = 80; // 敵人生成的隨機範圍與間隔


// 初始化
void setup() {
  size(600, 700); // 設定視窗大小
  playerX = width/2; // 玩家初始 X 座標置中
  playerY = height - 80; // 玩家初始 Y 座標靠近底部
  rectMode(CENTER); // 設定矩形以中心為座標
  textAlign(CENTER, CENTER); // 設定文字置中對齊
}


// 主循環
void draw() {
  background(0); // 清空背景為黑色

  // 根據遊戲狀態呼叫不同函式
  if(gameState == MENU) drawMenu(); // 顯示主選單
  else if(gameState == GAME_PLAY) runGame(); // 遊戲主循環
  else if(gameState == GAME_BOSS) runBoss(); // BOSS 戰
  else if(gameState == GAME_WIN) drawWin(); // 勝利畫面
  else if(gameState == GAME_OVER) drawGameOver(); // 遊戲結束畫面
}


// 主選單
void drawMenu() {
  fill(255); // 白色文字
  textSize(48); // 大標題文字大小
  text("SHOOTER GAME", width/2, height/2 - 120); // 遊戲標題

  textSize(28); // 選單文字大小
  fill(255, 200, 0); // 黃色文字
  text("Press ENTER to Start", width/2, height/2 + 40); // 開始遊戲提示

  fill(255); // 白色文字
  text("Press ESC to Quit", width/2, height/2 + 100); // 離開遊戲提示
}


// 開始關卡
void startLevel(int lv){
  level = lv; // 設定關卡
  if(lv == 1)score = 0; // 分數歸零
  bullets.clear(); // 清空玩家子彈
  enemyBullets.clear(); // 清空敵人子彈
  enemies.clear(); // 清空敵人
  bossSpawned = false; // 重置 BOSS 狀態
  playerHP = 100; // 重置玩家血量

  enemiesToSpawn = 10 + level*6; // 計算本關要生成的敵人數量
  spawnMin = (level==1)?90:70; // 根據關卡設定敵人生成最小間隔
  spawnMax = (level==1)?120:100; // 根據關卡設定敵人生成最大間隔
  spawnInterval = int(random(spawnMin, spawnMax)); // 隨機生成初始間隔
  enemyTimer = 0; // 重置敵人生成計時器

  gameState = GAME_PLAY; // 將遊戲狀態改為進行中
}


// 遊戲循環
void runGame() {
  updatePlayer(); // 更新玩家位置
  drawPlayer(); // 繪製玩家

  updateBullets(); // 更新玩家子彈
  updateEnemies(); // 更新敵人
  updateEnemyBullets(); // 更新敵人子彈
  drawHUD(); // 繪製分數、血量等資訊

  if(playerHP <= 0){ gameState = GAME_OVER; return; } // 玩家血量歸零時遊戲結束

  // 如果所有敵人都生成完且場上沒有敵人且 BOSS 尚未生成
  if(enemiesToSpawn == 0 && enemies.size() == 0 && !bossSpawned){
    boss = new Boss(level); // 生成 BOSS
    bossSpawned = true; // 標記 BOSS 已生成
    gameState = GAME_BOSS; // 切換遊戲狀態為 BOSS 戰
  }
}


// BOSS 戰
void runBoss() {
  updatePlayer(); // 更新玩家位置
  drawPlayer(); // 繪製玩家

  updateBullets(); // 更新玩家子彈
  updateEnemyBullets(); // 更新敵人子彈

  boss.update(); // 更新 BOSS 狀態
  boss.draw(); // 繪製 BOSS

  drawHUD(); // 繪製分數、血量

  if(playerHP <= 0){ gameState = GAME_OVER; return; } // 玩家血量歸零遊戲結束
  if(boss.hp <= 0){ // BOSS 血量歸零
    if(level < maxLevel) startLevel(level+1); // 還有關卡就進入下一關
    else gameState = GAME_WIN; // 否則勝利
  }
}

// 勝利與遊戲結束畫面
void drawWin() {
  background(0); // 黑色背景
  fill(255, 255, 0); // 黃色文字
  textSize(48); // 大字
  text("YOU WIN!", width/2, 260); // 勝利訊息

  fill(255); // 白色文字
  textSize(28); // 中字
  text("Final Score: "+score, width/2, 350); // 顯示最終分數
  text("Press ENTER to return menu", width/2, 420); // 返回主選單提示
}

void drawGameOver() {
  background(0); // 黑色背景
  fill(255, 100, 100); // 紅色文字
  textSize(48); // 大字
  text("GAME OVER", width/2, 260); // 遊戲結束訊息

  fill(255); // 白色文字
  textSize(28); // 中字
  text("Score: "+score, width/2, 350); // 顯示分數
  text("Press ENTER to return", width/2, 430); // 返回主選單提示
}

// 玩家
void updatePlayer(){
  float speed = 5; // 玩家移動速度
  if(left) playerX -= speed; // 向左移動
  if(right) playerX += speed; // 向右移動
  if(up) playerY -= speed; // 向上移動
  if(down) playerY += speed; // 向下移動

  playerX = constrain(playerX, 30, width-30); // 限制 X 範圍
  playerY = constrain(playerY, 30, height-30); // 限制 Y 範圍

  // 自動連續射擊，每 10 幀射一次
  if(frameCount % 10 == 0) shootWeapon();
}

void drawPlayer(){
  fill(0, 200, 255); // 藍色
  triangle(playerX-20, playerY+20, playerX+20, playerY+20, playerX, playerY-20); // 畫三角形表示玩家
}

void shootWeapon(){
  if(level==1) bullets.add(new Bullet(playerX, playerY-20)); // 關卡 1 單發子彈
  else if(level==2){
    bullets.add(new Bullet(playerX-10, playerY-20)); // 關卡 2 左右雙發子彈
    bullets.add(new Bullet(playerX+10, playerY-20));
  }
}

// 子彈
void updateBullets(){
  for(int i = bullets.size()-1; i >= 0; i--){ // 逆序遍歷以方便刪除
    Bullet b = bullets.get(i); // 取得子彈
    b.update(); // 更新子彈位置
    b.draw(); // 繪製子彈
    if(b.remove) bullets.remove(i); // 超出畫面則刪除
  }
}

// 敵人
void updateEnemies(){
  // 生成敵人
  if(enemiesToSpawn > 0){
    enemyTimer++; // 計時
    if(enemyTimer >= spawnInterval){ // 達到生成間隔
      enemies.add(new Enemy(random(50, width-50), -50, level)); // 隨機生成敵人
      enemiesToSpawn--; // 減少剩餘生成數量
      enemyTimer = 0; // 重置計時器
      spawnInterval = int(random(spawnMin, spawnMax)); // 隨機下一次生成間隔
    }
  }

  for(int i = enemies.size()-1; i >= 0; i--){ // 遍歷敵人
    Enemy e = enemies.get(i);
    e.update(); // 更新敵人位置
    e.draw(); // 繪製敵人

    // 敵人射擊
    if(frameCount % max(10, 100-level*10) == 0){
      for(int a=-20; a<=20; a+=20) enemyBullets.add(new EnemyBulletAngled(e.x, e.y+20, a)); // 發射子彈
    }

    // 撞到玩家
    if(dist(e.x, e.y, playerX, playerY) < 30){
      playerHP -= 15; // 玩家扣血
      enemies.remove(i); // 刪除敵人
      continue;
    }

    // 被玩家子彈打中
    for(int j = bullets.size()-1; j>=0; j--){
      if(dist(bullets.get(j).x, bullets.get(j).y, e.x, e.y)<25){
        score += 10; // 得分
        bullets.remove(j); // 刪除子彈
        enemies.remove(i); // 刪除敵人
        break;
      }
    }

    // 離開畫面就刪掉
    if(e.y > height+50) enemies.remove(i);
  }
}


// 敵人子彈
void updateEnemyBullets(){
  for(int i = enemyBullets.size()-1; i >= 0; i--){
    EnemyBullet eb = enemyBullets.get(i);
    eb.update(); // 更新子彈位置
    eb.draw(); // 繪製子彈

    if(dist(eb.x, eb.y, playerX, playerY)<20){ // 撞到玩家
      playerHP -= 10;
      enemyBullets.remove(i);
      continue;
    }

    if(eb.y>height || eb.y<0 || eb.x<0 || eb.x>width) enemyBullets.remove(i); // 超出畫面刪除
  }
}


// HUD
void drawHUD(){
  fill(255); // 白色文字
  textSize(20);
  text("Score: "+score, 80,30); // 顯示分數
  text("Level: "+level, 80,55); // 顯示關卡

  // 血條
  fill(255,0,0); rect(500,35,120,18); // 血條背景（紅色）
  fill(0,255,0); rect(500-(100-playerHP)*1.2/2,35,playerHP*1.2,18); // 綠色血量
  fill(255); text("HP: "+playerHP,500,65); // 顯示血量數值
}


// 鍵盤控制
void keyPressed(){
  if(keyCode == LEFT) left=true; // 按下左鍵
  if(keyCode == RIGHT) right=true; // 按下右鍵
  if(keyCode == UP) up=true; // 按下上鍵
  if(keyCode == DOWN) down=true; // 按下下鍵

  if(gameState == MENU && keyCode == ENTER) startLevel(1); // 在選單按 ENTER 開始遊戲
  if((gameState == GAME_OVER || gameState == GAME_WIN) && keyCode == ENTER) gameState = MENU; // 遊戲結束或勝利按 ENTER 回選單
}

void keyReleased(){
  if(keyCode == LEFT) left=false; // 放開左鍵
  if(keyCode == RIGHT) right=false; // 放開右鍵
  if(keyCode == UP) up=false; // 放開上鍵
  if(keyCode == DOWN) down=false; // 放開下鍵
}


// 類別
class Bullet{
  float x,y,speed=10; boolean remove=false; // 子彈座標、速度、是否刪除
  Bullet(float x,float y){ this.x=x; this.y=y; } // 建構子設定初始位置
  void update(){ y-=speed; if(y<-20) remove=true; } // 更新位置，超出畫面標記刪除
  void draw(){ fill(255,255,0); ellipse(x,y,8,15); } // 繪製子彈
}

class BulletAngle extends Bullet{
  float vx,vy; // 子彈水平與垂直速度
  BulletAngle(float x,float y,float angle){
    super(x,y);
    float rad=radians(angle); // 角度轉弧度
    vx = sin(rad)*7; vy = -cos(rad)*7; // 計算水平與垂直速度
  }
  void update(){ x+=vx; y+=vy; if(y<-20) remove=true; } // 更新位置，超出畫面刪除
}

class Enemy{
  float x,y,speed,angle=0; int type; // 敵人座標、速度、角度、類型
  Enemy(float x,float y,int level){
    this.x=x; this.y=y;
    type=int(random(0,5)); // 隨機選擇敵人型態
    speed=(2+level*0.7)*0.75; // 根據關卡設定速度
  }
  void update(){
    if(type==0) y+=speed; // 直線下落
    else if(type==1){ y+=speed; x+=sin(y*0.05)*6; } // 波浪下落
    else if(type==2){ y+=speed; angle+=0.1; x+=sin(angle)*6; } // 正弦曲線下落
    else if(type==3){ y+=speed; x+=(playerX-x)*0.02; } // 跟隨玩家
    else if(type==4){ y+=speed; x+=cos(y*0.03)*8; } // 另一種波浪
    x=constrain(x,20,width-20); // 限制水平範圍
  }
  void draw(){ fill(255,0,0); rect(x,y,40,40); } // 繪製敵人
}

class EnemyBullet{
  float x,y,speed=6; boolean remove=false; // 子彈座標、速度、是否刪除
  EnemyBullet(float x,float y){ this.x=x; this.y=y; } // 建構子設定初始位置
  void update(){ y+=speed*0.75; } // 更新位置
  void draw(){ fill(255,150,0); ellipse(x,y,8,12); } // 繪製子彈
}

class EnemyBulletAngled extends EnemyBullet{
  float vx,vy; // 子彈水平與垂直速度
  EnemyBulletAngled(float x,float y,float angle){
    super(x,y);
    float rad=radians(angle); // 角度轉弧度
    vx = sin(rad)*5; vy = cos(rad)*5; // 計算速度
  }
  void update(){ x+=vx; y+=vy*0.75; if(y>height||y<0||x<0||x>width) remove=true; } // 更新位置，超出刪除
}

class Boss{
  float x,y,hp,dir=3,angle=0; int phase=1; // 座標、血量、方向、角度、階段
  Boss(int lv){ x=width/2; y=140; hp=200+lv*100; } // 建構子，設定位置與血量
  void update(){
    x+=dir; if(x<120||x>width-120) dir*=-1; // 左右移動到邊界反向

    if(phase==1){
      y+=sin(frameCount*0.03)*0.5; // Y軸小幅震動
      if(frameCount%60==0) enemyBullets.add(new EnemyBullet(x,y+50)); // 每 60 幀發射子彈
    }
    if(phase==2){
      if(dir>0) dir=min(dir+0.05,5); else dir=max(dir-0.05,-5); // 調整速度
      if(frameCount%45==0){
        for(int a=-30;a<=30;a+=15) enemyBullets.add(new EnemyBulletAngled(x,y+50,a)); // 發射多角度子彈
      }
    }

    if(hp<(200+level*50) && phase==1) phase=2; // 血量低於一定值切換階段

    for(int i=bullets.size()-1;i>=0;i--){ // 玩家子彈打到 BOSS
      Bullet b=bullets.get(i);
      if(dist(b.x,b.y,x,y)<60){ bullets.remove(i); hp-=5; }
    }
  }
  void draw(){ fill(200,50,255); ellipse(x,y,160,100); fill(255); textSize(20); text("Boss HP: "+int(hp), width/2,80); } // 繪製 BOSS 與血量
}
