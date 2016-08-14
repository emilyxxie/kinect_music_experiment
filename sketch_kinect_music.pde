import org.openkinect.processing.*; //<>// //<>// //<>//
import de.voidplus.leapmotion.*;
import java.awt.Frame;
import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.*; 
import java.io.*;

Kinect2                kinect2;
AudioInput             song;
Minim                  minim;
ddf.minim.analysis.FFT fft;
BeatDetect             beat;

float cycle = 0;

float particlesIncrement = 2;
//float particleSpacing = 1.5;
float yPadding;
float xPadding;
float randomIncrement = 10;

// z axis related stuff
float zTranslate = 1700;
float subtractZ = 0;
//float maxDepth = 2600;

// home params
float maxDepth = 2100;
float particleSpacing = 1.8;

int[] depth;

// interval between beats
float beatInterval;
boolean onBeat;

float r;
float g;
float b;



void setup() {
  fullScreen(P3D, 2);
  xPadding = width / 5;
  
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  
  minim = new Minim(this);
  song  = minim.getLineIn();
  beat  = new BeatDetect();
  
  // set initial values
  r = 255;
  g = 255;
  b = 255;
}


void draw() {
  pushMatrix();
  beat.detect(song.mix);
  
  if ( beat.isOnset() ) {
    onBeat = true;
    r = random(255);
    g = random(255);
    b = random(255);
  } else {
    onBeat = false;
  }
  
  depth = kinect2.getRawDepth();

  if (cycle <= 800) {
    replication();
  } else if (cycle <= 1600) {
    flowField();
  } else if (cycle <= 2400) {
    flowField2();
  }
  
  if (cycle >= 300) {
    cycle = 0;
  }
   //flowField2(); // yes
  // duplicate(); // yes
   //pointCloud(); 
   //flashyLines();
  //replication();
   //flowField(); // yes

  popMatrix();
  textSize(17);
  text("@emilyxxie", width - 100, height - 10);
  cycle++;
}