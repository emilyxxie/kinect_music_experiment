FlowField           flowField;
ArrayList<Particle> particles; 
boolean initializedFlowField = false;

int particlesIncrementFF = 5;

void flowField() {  
  
  if (!initializedFlowField) {
    initFlowField();
    initializedFlowField = true;
  }
  
  translate(
    xPadding, 
    0, 
    zTranslate
  );
  
  background(0);
  
  flowField.updateField();
  
  for (int x = 0; x < kinect2.depthWidth; x += particlesIncrementFF) {
    for (int y = 0; y < kinect2.depthHeight; y += particlesIncrementFF) {
      int offset = x + y * kinect2.depthWidth;
      int z = depth[offset];
      if (z > maxDepth || z == 0) {
        continue;
      }

      Particle particle = new Particle(
        x * particleSpacing, 
        y * particleSpacing,
        subtractZ - z
      );
      particles.add(particle);
    }
  } 

  
  for (int i = 0; i < particles.size(); i++) {
    particles.get(i).update();
    particles.get(i).render();
    if (particles.get(i).age > particles.get(i).lifeSpan) {
      particles.remove(i);
    }
  }
}


class Particle {
  PVector location;
  PVector velocity;
  
  float speed;
  float lifeSpan;
  float age;
  
  
  Particle (float x, float y, float z) {
    location = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    
    lifeSpan = random(3, 15);
    speed    = random(2, 10);
  }
  
  void update() {
    // get current velocity
    if (!onBeat) {
      velocity = flowField.lookupVelocity(location);
      velocity.mult(speed);
      location.add(velocity);
      age++;
    }
    
  }
  
  void render() {
    strokeWeight(2);
    stroke(r, g, b, 100);
    strokeWeight(2); 
    point(location.x, location.y, location.z);
  }
}

class FlowField {
   PVector[][] grid;
   int   cols, rows;
   int   resolution;
   float zNoise = 0.0;
   
   FlowField (int res) {
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
            ) * 700);
         grid[i][j] = PVector.fromAngle(angle);
         yNoise += 0.1;
       }
       xNoise += 0.1;
     }
     zNoise += 0.03;
   
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

void initFlowField() {
  flowField = new FlowField(20);
  particles = new ArrayList<Particle>();
}