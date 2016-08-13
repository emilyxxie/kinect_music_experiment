import org.openkinect.processing.*; //<>// //<>//
import de.voidplus.leapmotion.*;
import java.awt.Frame;
import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.*; 
import java.io.*;

Kinect2                kinect2;
//AudioPlayer            song;
AudioInput             song; // use whatever is playing on computer
Minim                  minim;
ddf.minim.analysis.FFT fft;
BeatDetect             beat;


float particlesIncrement = 2;
float particleSpacing = 1.5;
float hPadding;
float wPadding;
float yRotate = 0;
float randomIncrement = 10;
//float zTranslate = -700;
//float zTranslate = -1000;
float zTranslate = 0;
float subtractZ = 1700;

// interval between beats
float beatInterval;

float r;
float g;
float b;
float yRotateIncrement = 0.006;

boolean moveBackward = true;

void setup() {
  //size(800, 600, P3D);
  wPadding = width / 5;
  fullScreen(P3D);
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  minim = new Minim(this);
  //song  = minim.loadFile("gone_too_soon.mp3", 1024);

  minim = new Minim(this);
  //// for when using computer audio input
  song = minim.getLineIn();
  //song.play();
  beat = new BeatDetect();
  r = 255;
  g = 255;
  b = 255;
}


void draw() {
  randomIncrement = frameCount % 30;
  randomIncrement = 30 - randomIncrement;
  
  background(0);
  
  beat.detect(song.mix);
  
  if ( beat.isOnset() ) {
    r = random(255);
    g = random(255);
    b = random(255);
    //if (zTranslate == 0) {
    //  zTranslate = -50;
    //  //zTranslate 
    //} else {
    //  zTranslate = 0;
    //}
    
  } else {
    //background(0, 10);
  }
  
  
  //rotateY(yRotate);
  //translate(wPadding, 0, zTranslate);
  
  // get raw depth of image as array of integers
  int[] depth = kinect2.getRawDepth();

  stroke(r, g, b, 50);
  strokeWeight(2);
  noFill();
  beginShape(QUADS);
  
  // depthWidth and depthHeight are fixed values as set by the device
  for (int x = 0; x < kinect2.depthWidth; x += particlesIncrement) {
    for (int y = 0; y < kinect2.depthHeight; y += particlesIncrement) {
      int offset = x + y * kinect2.depthWidth;
      int z = depth[offset];
      if (z > 2500 || z == 0) {
        continue;
      }
      if (beat.isOnset()) {
        vertex(
          x * particleSpacing + random(-randomIncrement, randomIncrement), 
          y * particleSpacing + random(-randomIncrement, randomIncrement), 
          subtractZ - z
        );
        //int decision = round(random(4));  
        //if (decision == 1) {
        //  vertex(
        //    x * particleSpacing,
        //    (y * particleSpacing) + tan(y) * 20,
        //    subtractZ - z
        //  );
        //} else {
        //  vertex(
        //    (x * particleSpacing) + tan(x) * 20,
        //    y * particleSpacing,
        //    subtractZ - z
        //  );
        //}
      } else {
        strokeWeight(random(0, 5));
        vertex(
          x * particleSpacing + random(-randomIncrement, randomIncrement), 
          y * particleSpacing + random(-randomIncrement, randomIncrement), 
          subtractZ - z
        );
      }
    }
  }
  endShape();
  
  // used in the camera rotation
  if (moveBackward) {
    yRotate += yRotateIncrement;
  } else {
    yRotate -= yRotateIncrement;
  }
  
  if (yRotate >= 0.700) {
    moveBackward = false;
  } 
  
  if (yRotate <= -0.4) {
    moveBackward = true;
  }
  textSize(17);
  text("@emilyxxie", width - 100, height - 10);
}