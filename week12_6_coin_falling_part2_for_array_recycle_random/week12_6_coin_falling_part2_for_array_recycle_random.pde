//week12_6_coin_falling_part2_for_array_recycle_random
//修改自week12_5_coins_falling_part1_PImage_image_y
//接金幣 (3) for迴圈 很多個 (4) 金幣回收再利用
PImage imgCoin;
void setup(){
  size(300,500);
  imgCoin = loadImage("coin.png");
  for(int i=0;i<10;i++){
    x[i] = random(300-100);
    y[i] = -100 - random(1000);
  }
}
float [] x = new float[10];
float [] y = new float[10];
void draw(){
  background(255);
  for(int i=0;i<10;i++){
    image(imgCoin, x[i], y[i], 100, 100);
    y[i] += 3; //往下掉  
    if(y[i]>500){
      x[i] = random(300-100);
      y[i] = -100 - random(200);
    }
  }
}
