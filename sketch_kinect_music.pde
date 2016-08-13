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
float yPadding;
float xPadding;
float yRotate = 0;
float randomIncrement = 10;
float zTranslate = 1700;
//float subtractZ = 1700;

float subtractZ = 0;

float maxDepth = 2500;

// interval between beats
float beatInterval;

float r;
float g;
float b;

float yRotateIncrement = 0.002;

boolean moveBackward = true;


void setup() {
  xPadding = width / 5;
  fullScreen(P3D);
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  
  minim = new Minim(this);
  song = minim.getLineIn();
  beat = new BeatDetect();
  
  // set initial values
  r = 255;
  g = 255;
  b = 255;
}


void draw() {
  pushMatrix();
  //flashyLines();
  pointCloud();

  popMatrix();
  textSize(17);
  text("@emilyxxie", width - 100, height - 10);
}


void pointCloud() {
  
  background(0);
  
  beat.detect(song.mix);
  
  if ( beat.isOnset() ) {
    r = random(255);
    g = random(255);
    b = random(255);
    if (zTranslate == 1700) {
      zTranslate = 1600;
    } else {
      zTranslate = 1700;
    }
  }
  
  
  rotateY(yRotate);
  translate(xPadding, 0, zTranslate);
  
  // get raw depth of image as array of integers
  int[] depth = kinect2.getRawDepth();

  stroke(r, g, b);
  strokeWeight(2);
  noFill();
  
  beginShape(POINTS);
  // depthWidth and depthHeight are fixed values as set by the device
  for (int x = 0; x < kinect2.depthWidth; x += particlesIncrement) {
    for (int y = 0; y < kinect2.depthHeight; y += particlesIncrement) {
      int offset = x + y * kinect2.depthWidth;
      int z = depth[offset];
      if (z > maxDepth || z == 0) {
        continue;
      }
      
  
      if (beat.isOnset()) {
        int decision = round(random(4));  
        if (decision == 1) {
          vertex(
            x * particleSpacing,
            (y * particleSpacing) + tan(y) * 20,
            subtractZ - z
          );
        } else {
          vertex(
            (x * particleSpacing) + tan(x) * 20,
            y * particleSpacing,
            subtractZ - z
          );
        }
      } else {
        vertex(
          x * particleSpacing, 
          y * particleSpacing, 
          subtractZ - z
        );
      }
    }
  }
  endShape();

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
  
}

void flashyLines() {
  
  
  beat.detect(song.mix);
 
  translate(
    xPadding, 
    0, 
    zTranslate
  );
  
  background(0);

  beat.detect(song.mix);
  
  if ( beat.isOnset() ) {
    
    r = random(255);
    g = random(255);
    b = random(255);
    
  }
  
  // get raw depth of image as array of integers
  int[] depth = kinect2.getRawDepth();

  stroke(r, g, b, 40);
  strokeWeight(2);
  noFill();
  
  beginShape(QUADS);
  // depthWidth and depthHeight are fixed values as set by the device
  for (int x = 0; x < kinect2.depthWidth; x += particlesIncrement) {
    for (int y = 0; y < kinect2.depthHeight; y += particlesIncrement) {
      int offset = x + y * kinect2.depthWidth;
      int z = depth[offset];
      if (z > maxDepth || z == 0) {
        continue;
      }
      strokeWeight(random(0, 5));
      vertex(
        x * particleSpacing + random(-randomIncrement, randomIncrement), 
        y * particleSpacing + random(-randomIncrement, randomIncrement), 
        subtractZ - z
      );
    }
  }
  endShape();

}