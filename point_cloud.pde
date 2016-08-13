float yRotateIncrement = 0.002;
float yRotate = 0;
boolean moveBackward = true;

void pointCloud() {
  background(0);
  
  if ( onBeat ) {
    if (zTranslate == 1700) {
      zTranslate = 1750;
    } else {
      zTranslate = 1700;
    }
  }
  
  rotateY(yRotate);
  translate(xPadding, 0, zTranslate);
 
  stroke(r, g, b);
  strokeWeight(2);
  noFill();
  
  beginShape(POINTS);
  for (int x = 0; x < kinect2.depthWidth; x += particlesIncrement) {
    for (int y = 0; y < kinect2.depthHeight; y += particlesIncrement) {
      int offset = x + y * kinect2.depthWidth;
      int z = depth[offset];
      if (z > maxDepth || z == 0) {
        continue;
      }
      
  
      if (onBeat) {
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