PImage biberNervigBild;

class NervenderBiber {
  float size = 100;
  float speed = 5;
  float x, y = 70;
  float xR = 1, yR = 1;
  
  void draw() {
    x += xR * speed;
    y += yR * speed;
    if (x < 0) xR = 1;
    if (x > width-size) xR = -1;
    if (y < 0) yR = 1;
    if (y > height-size) yR = -1;
    image(biberNervigBild, x, y, size, size);
  }
}
