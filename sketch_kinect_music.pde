import org.openkinect.processing.*; //<>// //<>//
import de.voidplus.leapmotion.*;
import java.awt.Frame;
import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.*; 
import java.io.*;

Kinect2                kinect2;
AudioPlayer            song;
//AudioInput             song; // use whatever is playing on computer
Minim                  minim;
ddf.minim.analysis.FFT fft;
BeatDetect             beat;

float particlesIncrement = 2;
float particleSpacing = 2;
float hPadding;
float wPadding;
float yRotate = 0;
float zTranslate = -700;

float r;
float g;
float b;
float yRotateIncrement = 0.006;

boolean moveBackward = true;

void setup() {
  //size(800, 600, P3D);
  wPadding = width / 5;
  fullScreen(P3D, 2);
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  
  minim = new Minim(this);
  song  = minim.loadFile("gone_too_soon.mp3", 1024);

  //minim = new Minim(this);
  //// for when using computer audio input
  //song = minim.getLineIn();
  song.play();
  beat = new BeatDetect();
  r = 255;
  g = 255;
  b = 255;
}


void draw() {
  background(0);
  
  beat.detect(song.mix);
  
  if ( beat.isOnset() ) {
    r = random(255);
    g = random(255);
    b = random(255);
    if (zTranslate == -700) {
      zTranslate = -670;
    } else {
      zTranslate = -700;
    }
    
  }
  
  
  rotateY(yRotate);
  translate(wPadding, 0, zTranslate);
  
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
      if (z < 1) {
        continue;
      }
      
  
      if (beat.isOnset()) {
        int decision = round(random(4));  
        if (decision == 1) {
          vertex(
            x * particleSpacing,
            (y * particleSpacing) + tan(y) * 20,
            z
          );
        } else {
          vertex(
            (x * particleSpacing) + tan(x) * 20,
            y * particleSpacing,
            z
          );
        }
      } else {
        vertex(
          x * particleSpacing, 
          y * particleSpacing, 
          z
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