void setup() {
  size(600, 700);  // 設定畫布大小
  textAlign(CENTER, CENTER);  // 文字置中對齊
}

void draw() {
  background(0);  // 背景顏色為黑色
  
  textSize(48);
  fill(255);  // 白色文字
  text("SHOOTER GAME", width / 2, height / 2 - 100);  // 顯示遊戲標題
  
  textSize(28);
  fill(255, 200, 0);  // 黃色文字
  text("Press ENTER to Start", width / 2, height / 2);  // 提示開始遊戲
}

void keyPressed() {
  if (keyCode == ENTER) {
    // 進入遊戲邏輯 (這部分會在後續步驟中實作)
  }
}
