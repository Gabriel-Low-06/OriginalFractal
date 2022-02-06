void setup() {
  size(1100, 700);
  wood = loadImage("firewood-lumberjack-log-splitters-wood-78689ed69d835690b2628f3106915222.png");
  snow  = new ArrayList<snowFrac>();
  //load image of logs, initialize arraylist of snowFractalFlakes
}
PImage wood; //decalre image of wood and snowFractalFlakes
ArrayList<snowFrac>snow;

void fireFractal(float x, float y, float size) { //recursive code to generate fire
  if (size>random(50, 110)) {  //if this flame is bigger than a certain size, add two new, smaller flames to the left and right
    fireFractal(x+(size*random(0, .5)), y-(size*(random(.01, .1))), size*random(.7, .9));
    fireFractal(x-(size*random(-.1, .3)), y-(size*random(.01, .1)), size*random(.7, .9));
  }
  fill(255, random(120, 140), random(20, 40), 135); //make the flame  a slightly randomized shade of oragne
  pushMatrix();
  translate(x, y);
  rotate(random(-.3, .3)); //rotate the flame slightly, randomly
  translate(-x, -y);
  triangle(x, y, x+size/2, y, x+size/4, y-size*1.4); //draw the main flame
  triangle(x+size/random(3, 4), y-size*random(1.4, 1.8), x+size/random(3.5, 5), y-size*random(1.4, 1.6), x+size/4, y-size); //draw the flickers on top of the flame
  fill(255, random(190, 250), random(100, 250));
  triangle(x+(size/8), y, x+(size*.75*.5), y, x+(size*.35*.5), y-size*1); //draw the white-hot center of the flame
  popMatrix();
}

void fractalTree(float x, float y, float xSize, float ySize) { //recursive fractal to draw a nice tree
  strokeWeight((abs(xSize)+ySize)/24); //make the tree thicker at the base and thinner on the branches
  stroke(100+(ySize*.7), constrain(255-(ySize*3), 90, 255), 63); //make the tree fade from brown to green as it stretches through the branches
  line(x-xSize/2, y+ySize/2, x+xSize/2, y-ySize/2); //draw the branch of the tree
  if (xSize>15 || ySize>15) {
    fractalTree(x+xSize/2, y-ySize*7/8, 0, (ySize)*3/4); //call the function for the branch above the given one
    if (xSize==0) {
      xSize=ySize;
      x-=xSize/2;
    }
    fractalTree(x+xSize*3/4, y-ySize*3/4, xSize/2, ySize/2); //call function for the branch to the right
    fractalTree(x+xSize*1/4, y-ySize*3/4, -xSize/2, ySize/2); //call function for the branch to the left
  }
}

void FractalFlake(int x, int y, int xLength, int yLength) { //recursive fractal to draw an easy snowFractalFlake
  line(x-(xLength/2), y-(yLength/2), x+(xLength/2), y+(yLength/2)); //draw the given line of the snowFractalFlake
  if (xLength>5 ||yLength>5) {
    FractalFlake(x+(xLength/3), y+(yLength/3), yLength/2, xLength/2); //call the function to make three lines through the middle of this line
    FractalFlake(x-(xLength/3), y-(yLength/3), yLength/2, xLength/2);
    FractalFlake(x, y, yLength/2, xLength/2);
  }
}

class snowFrac { //holder class to store the locations and sizes of snowFractalFlake fractals
  private float x, y, xspeed, howBig, transparency;
  snowFrac() {
    x=random(250, 800); //initializes the snowFractalFlake somewhere above the screen, with opaque transparency and a random x velocity
    howBig=random(10, 70);
    y=random(-100, 0);
    transparency=255;
    xspeed=random(-2, 2);
  }
  boolean show() {
    x+=xspeed; //update x position based on speed
    y+=1; //make snowFractalFlake fall
    transparency-=.6; //make snowFractalFlake fade
    stroke(255, 255, 255, (int)transparency);
    FractalFlake((int)x, (int)y, (int) howBig, 0); //draw the snowFractalFlake using the fractal
    FractalFlake((int)x, (int)y, 0, (int)howBig);
    if (transparency<0) {
      return false; //if it's completely faded, return false so that it will be removed from the arraylist
    }
    return true;
  }
}
void draw() {
  background(0, 0, 0); //reset frame  
  tint(150, 100, 100); //draw pile of logs
  image(wood, 180, 630, 200, 120);
  image(wood, 360, 630, 200, 120); 
  fill(255, 255, 255); //draw moon
  noStroke(); 
  ellipse(100, 100, 100, 100);
  fill(0, 0, 0);
  ellipse(135, 100, 90, 90);
  
  fractalTree(800, 780, 300*(1-(abs((float)Math.sin(millis()*.00016))*.4)), 225*(1+(abs((float)Math.cos(millis()*.0004))*.03)));
  //draw a fractalTree on the right side, oscilatting back on forth under a sin wave
  
  noStroke();
  fireFractal(300, 700, 200); //draw the fire fractal on top of the logs
  
  noFill(); //periodically add new snowflakes to the scene
  if (Math.random()>.995) {
    snow.add(new snowFrac());
  }
  for (int i=0; i<snow.size(); i++) {
    if (snow.get(i).show()==false) { //draw all the snowFractalFlakes
      snow.remove(i); //if they've faded, remove from memory
      i--;
    }
  }
}
