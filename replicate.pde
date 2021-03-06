int totalReplicates = 1;
int totalBeats = 1;
int beatsToReplication = 40;
float zRotate = 0;
int framesToRotation = 100;
int framesSinceReplication = 0;
boolean moveBackwardR = false;

float yRotateIncrement = 0.0004;
float yRotate = 0;

void replication() {  
  if (onBeat) {
    if (zTranslate == 1700) {
      zTranslate = 1750;
    } else {
      zTranslate = 1700;
    }
    totalBeats += 1;
  }
  
  if (totalBeats % beatsToReplication == 0) {
    // speed up the second plant
    totalBeats += (beatsToReplication - 5);
    totalReplicates++;
    totalReplicates = constrain(totalReplicates, 1, 3);
  }
  
  translate(
    xPadding, 
    0, 
    zTranslate
  );
    if (moveBackwardR) {
      yRotate += yRotateIncrement;
    } else {
      yRotate -= yRotateIncrement;
    }
    
    if (yRotate >= 0.06) {
      moveBackwardR = false;
    } 
    
    if (yRotate <= -0.06) {
      moveBackwardR = true;
    }
  
  rotateX(yRotate);
  rotateZ(yRotate);
  
  background(0);

  stroke(r, g, b);
  strokeWeight(1);
  noFill();
 
  beginShape(POINTS);
  for (int x = 0; x < kinect2.depthWidth; x += particlesIncrement) {
    for (int y = 0; y < kinect2.depthHeight; y += particlesIncrement) {
      for (int i = 0; i < totalReplicates; i++) {
        int offset = x + y * kinect2.depthWidth;
        int z = depth[offset];
        if (z > maxDepth || z == 0) {
          continue;
        }
        
    
        if (onBeat) {
          int decision = round(random(4));  
          if (decision == 1) {
            vertex(
              x * particleSpacing  + (i * 200) + sin(frameCount),
              (y * particleSpacing) + (i * 200) + sin(frameCount) + tan(y) * 20,
              subtractZ - z  + (i * 200) + sin(frameCount)
            );
          } else {
            vertex(
              (x * particleSpacing) + tan(x) * 20  + (i * 200) + sin(frameCount),
              y * particleSpacing  + (i * 200) + sin(frameCount),
              subtractZ - z  + (i * 200) + sin(frameCount)
            );
          }
        } else {
          vertex(
            x * particleSpacing + (i * frameCount % width - 100) + sin(frameCount), 
            y * particleSpacing + (i * frameCount % 40) + sin(frameCount), 
            subtractZ - z + (i  * frameCount % 500) + sin(frameCount)
          );
        }
      }
    }
  }
  endShape();
  
}