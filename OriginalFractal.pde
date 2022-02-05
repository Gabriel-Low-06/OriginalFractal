void setup() {
  size(1100, 700);
}
ArrayList<snowFrac>puffs = new ArrayList<snowFrac>();
void fireFractal(float x, float y, float size) {
  if (size>random(50, 110)) {
    fireFractal(x+(size*random(0, .5)), y-(size*(random(.01, .1))), size*random(.7, .9));
    fireFractal(x-(size*random(-.1, .3)), y-(size*random(.01, .1)), size*random(.7, .9));
    //fireFractal(x+size*(random(.1,.2)),y-(size*.6),size*random(.3,.6));
  }
  fill(255, random(120, 140), random(20, 40), 135);
  pushMatrix();
  translate(x, y);
  rotate(random(-.3, .3));
  translate(-x, -y);
  triangle(x, y, x+size/2, y, x+size/4, y-size*1.4);
  triangle(x+size/random(3, 4), y-size*random(1.4, 1.8), x+size/random(3.5, 5), y-size*random(1.4, 1.6), x+size/4, y-size);
  fill(255, random(190, 250), random(100, 250));
  triangle(x+(size/8), y, x+(size*.75*.5), y, x+(size*.35*.5), y-size*1);
  popMatrix();
}
void tree(float x, float y, float xSize, float ySize) {
  strokeWeight((abs(xSize)+ySize)/24);
  stroke(100+(ySize*.7), constrain(255-(ySize*3),90,255), 63);
  line(x-xSize/2, y+ySize/2, x+xSize/2, y-ySize/2);
  if (xSize>15 || ySize>15) {
    tree(x+xSize/2, y-ySize*7/8, 0, (ySize)*3/4);
    if (xSize==0) {
      xSize=ySize;
      x-=xSize/2;
    }
    tree(x+xSize*3/4, y-ySize*3/4, xSize/2, ySize/2);
    tree(x+xSize*1/4, y-ySize*3/4, -xSize/2, ySize/2);
  }
}

void flake(int x, int y, int xLength, int yLength) {
  line(x-xLength/2, y-yLength/2, x+xLength/2, y+yLength/2);
  if (xLength>5 ||yLength>5) {
    flake(x+xLength/3, y+yLength/3, yLength/2, xLength/2);
    flake(x-xLength/3, y-yLength/3, yLength/2, xLength/2);
    flake(x, y, yLength/2, xLength/2);
  }
}

class snowFrac {
  float x, y, xspeed, size, transparency;
  snowFrac() {
    x=random(250, 800);
    size=random(10, 70);
    y=random(-100, 0);
    transparency=255;
    xspeed=random(-2, 2);
  }
  boolean show() {
    x+=xspeed;
    y+=1;
    transparency-=.6;
    stroke(255, 255, 255, transparency);
    flake((int)x, (int)y, (int) size, 0);
    flake((int)x, (int)y, 0, (int)size);
    if (transparency<0) {
      return false;
    }
    return true;
  }
}
void draw() {
  background(0, 0, 0);
  tree(800, 780, 300, 225);
  noStroke();
  fireFractal(300, 720, 200);
  noFill();
  if (Math.random()>.995) {
    puffs.add(new snowFrac());
  }
  for (int i=0; i<puffs.size(); i++) {
    if (puffs.get(i).show()==false) {
      puffs.remove(i);
      i--;
    }
  }
}
