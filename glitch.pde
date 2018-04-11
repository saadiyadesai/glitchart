import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI  kinect;
PImage in;
PImage out;
int[] userMap;
PImage rgbImage;
float fullScreenScale;
int enter, leave;

void setup() {
  fullScreen(P3D); 
  fullScreenScale = width / float(640);
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.enableRGB();
  out = loadImage("out.png");
  in = loadImage("in.png");
}

void draw() {  
  kinect.update();  
  rgbImage = kinect.rgbImage();
  scale(fullScreenScale, fullScreenScale);
  boolean flag = false;
  color randomColor = color(random(255), random(255), random(255), 255);
  userMap = kinect.userMap();
  for (int i = 0; i < userMap.length; i++)
  {

    if (kinect.getNumberOfUsers() != 0 && kinect.getNumberOfUsers() < 6)
    {
      if (userMap[i] == 1)
      {
        // green lines glitch
        if (i%10 == 0)
        {
          if (millis()%30==0) 
          {
            rgbImage.pixels[i]=color(204, 255, 0);
          } 
          else
          {
            rgbImage.pixels[i]=color(0, 0, 255);
          }
        } 
        if (i%8 == 0)
        {
          rgbImage.pixels[i]=color(57, 255, 20);
        } 
        if ( i% 6 ==0)
        {
          rgbImage.pixels[i] = color(0, 255, 0);
        }
      } 
      else if (userMap[i] == 2)
      {
        // crt glitch
        rgbImage.pixels[i]= color(random(255));
      } 
      else if (userMap[i] == 3)
      {
        // horizontal crt with colours and more transparent
        if (random(100) < 50 || (flag == true && random(100) < 80))
        {
          flag = true;
          color pixelColor = rgbImage.pixels[i];
          float mixPercentage = .5 + random(50)/100;
          rgbImage.pixels[i]=  lerpColor(pixelColor, randomColor, mixPercentage);
        } 
        else
        {
          flag = false;
          randomColor = color(random(255), random(255), random(255), 255);
        }
      } 
      else if (userMap[i] == 4)
      {
        // psychedelic glitch does nothing to black colours
        rgbImage.pixels[i] *= -3;
      } 
      else if (userMap[i] == 5)
      {
        // psychedelic glitch but also affects the color black 
        rgbImage.pixels[i] = 100 + rgbImage.pixels[i] * 3;
      }
    }
    else
    {
      // party mode
      if (userMap[i] != 0)
      {
        color pixelColor = rgbImage.pixels[i];
        float mixPercentage = .5 + random(50)/100;
        rgbImage.pixels[i]=  lerpColor(pixelColor, randomColor, mixPercentage);
      }
    }
  }
  rgbImage.updatePixels();
  image(rgbImage, 0, 0);
  scale(1.1);
  stroke(100); 
  smooth();
  //glitch whole screen user enter
  if (enter != 0)
  {
    image(out, 0, 0);
    enter--;
  } 
  //glitch whole screen user leaving
  if (leave != 0)
  {
    image(in, 0, 0);
    leave--;
  }
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  enter = 20;
  println("onNewUser - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  leave = 20;
  println("onLostUser - userId: " + userId);
}