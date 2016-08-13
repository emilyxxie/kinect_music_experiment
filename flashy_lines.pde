void flashyLines() {
  
  translate(
    xPadding, 
    0, 
    zTranslate
  );
  
  background(0);

  stroke(r, g, b, 40);
  strokeWeight(2);
  noFill();
  
  beginShape(QUADS);
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