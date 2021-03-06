FlowField           flowField2;
ArrayList<Particle2> particles2; 
boolean initializedFlowField2 = false;

int particlesIncrementFF2 = 10;

void flowField2() {  
  
  if (!initializedFlowField2) {
    initFlowField2();
    initializedFlowField2 = true;
  }
  
  translate(
    xPadding, 
    0, 
    zTranslate
  );
  
  background(0);
  
  flowField2.updateField();
  
  for (int x = 0; x < kinect2.depthWidth; x += particlesIncrementFF2) {
    for (int y = 0; y < kinect2.depthHeight; y += particlesIncrementFF2) {
      int offset = x + y * kinect2.depthWidth;
      int z = depth[offset];
      if (z > maxDepth || z == 0) {
        continue;
      }

      Particle2 particle = new Particle2(
        x * particleSpacing + random(-8, 8), 
        y * particleSpacing + random(-8, 8),
        subtractZ - z
      );
      particles2.add(particle);
    }
  } 

  
  for (int i = 0; i < particles2.size(); i++) {
    particles2.get(i).update();
    particles2.get(i).render();
    if (particles2.get(i).age > particles2.get(i).lifeSpan) {
      particles2.remove(i);
    }
  }
}


class Particle2 {
  PVector location;
  PVector velocity;
  
  float speed;
  float lifeSpan;
  float age;
  
  ArrayList<PVector> history;
  
  Particle2 (float x, float y, float z) {
    location = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    
    lifeSpan = random(3, 16);
    speed    = random(2, 10);
    
    history = new ArrayList<PVector>();
  }
  
  void update() {
    // get current velocity
    if (!onBeat) {
      velocity = flowField2.lookupVelocity(location);
      velocity.mult(speed);
      history.add(location.copy());
      location.add(velocity);
      age++;
    }

    
  }
  
  void render() {
    strokeWeight(2);
    stroke(r, g, b, 50);
    strokeWeight(2); 
    noFill();
    beginShape();
      vertex(location.x, location.y, location.z);    
      for (int i = 0; i < history.size(); i++) {
       
         vertex(
           history.get(i).x, 
           history.get(i).y, 
           history.get(i).z
         );
      }
    
    endShape();
  }
}

class FlowField2 {
   PVector[][] grid;
   int   cols, rows;
   int   resolution;
   float zNoise = 0.0;
   
   FlowField2 (int res) {
     resolution = res;
     rows = height/resolution;
     cols = width/ resolution;
     grid = new PVector[cols][rows];
   }
   
   void updateField() {
     float xNoise = 0;
     for (int i = 0; i < cols; i++) {
       float yNoise = 0;
       for (int j = 0; j < rows; j++) {
         float angle = radians(
           (noise(
             xNoise, 
             yNoise, 
             zNoise)
            ) * 200);
         grid[i][j] = PVector.fromAngle(angle);
         yNoise += 0.1;
       }
       xNoise += 0.1;
     }
     zNoise += 0.05;
   
   }
  
  PVector lookupVelocity(PVector particleLocation) {
    int column = int(
      constrain(
        particleLocation.x / resolution, 
        0, 
        cols - 1)
      );
    int row = int(
      constrain(
        particleLocation.y / resolution, 
        0, 
        rows - 1)
       );
    return grid[column][row].copy();
  }
}

void initFlowField2() {
  flowField2 = new FlowField(5);
  particles2 = new ArrayList<Particle2>();
}