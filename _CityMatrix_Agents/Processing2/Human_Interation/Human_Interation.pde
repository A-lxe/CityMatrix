color[] pix;
ArrayList<Agent> agent;
PGraphics pgWaleed;

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

void setup(){
  size(800,800);
  pgWaleed = createGraphics(800, 800);
  PImage img = loadImage("MAP_sidewalk_buffer_800pxl.png");
  img.loadPixels();
  pix = img.pixels;
  agent = new ArrayList<Agent>();
  for (int i = 0; i < 300; i++) {
    newAgent(559,643,1);
    //newAgent(351,452,1);
    newAgent(358,542,1);
    //newAgent(107,95,1);
  }
//    for (int i = 0; i < 1; i++) {
//    newAgent(557,642,2);
//    //newAgent(352,450,2);
//    newAgent(358,540,2);
//    //newAgent(105,93,2);
//  }
}

void draw(){
  pgWaleed.beginDraw();
  pgWaleed.background(0);
  for (Agent a : agent) {
  a.applyBehaviors(agent);
  a.run();
  }
  pgWaleed.endDraw();
  image(pgWaleed, 0, 0); 
}
void mousePressed(){
  newAgent(mouseX, mouseY, 2);
  newAgent(mouseX, mouseY, 1);
  newAgent(mouseX, mouseY, 2);
  newAgent(mouseX, mouseY, 1);
  newAgent(mouseX, mouseY, 2);
  newAgent(mouseX, mouseY, 1);
  newAgent(mouseX, mouseY, 2);
  newAgent(mouseX, mouseY, 1);
  newAgent(mouseX, mouseY, 2);
  newAgent(mouseX, mouseY, 1);
  newAgent(mouseX, mouseY, 2);
  newAgent(mouseX, mouseY, 1);
  newAgent(mouseX, mouseY, 2);
  newAgent(mouseX, mouseY, 1);
  newAgent(mouseX, mouseY, 2);
  newAgent(mouseX, mouseY, 1);
}

void newAgent( int x,int y, int _colr) {
  int colr = _colr;
  float maxspeed = random(0.5,4.0);
  float maxforce = .01;
  agent.add(new Agent(new PVector(x,y), maxspeed, maxforce, colr));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

class Agent{
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float wdelta;
  float maxforce;
  float maxspeed;
  int agentLoc;
  int newagentLoc;
  int k=0;
  
  Agent( PVector l, float ms, float mf, int _k) {
    location = l.get();
    r = 1.5;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(-10, 10);
    k=_k;
  }
  
  void applyBehaviors(ArrayList agents) {
    agentLoc = pix[(int)abs(location.y%800)*800 + (int)location.x];    
    if (agentLoc == -1){
        PVector wand = new PVector();
        wand= wander();
        wand.mult(5);
        acceleration.add(wand);
////        PVector go = seek(location);
////        go.mult(5);
////        applyForce(go);
////        acceleration.add(go);
      }
    try{
      if (agentLoc == -16777216){ //-16777216
        //println(location);
        PVector a = avoid(location);  
        //println(a.heading());
        a.mult(10);
        applyForce(a);
        acceleration.add(a);
      } 
      
      
    }catch(ArrayIndexOutOfBoundsException e){
    }
    PVector s = separate(agents);
    s.mult(10);
    applyForce(s);
    acceleration.add(s);
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  public void run() {
    update();
    borders();
    render();
  }

  PVector separate (ArrayList boids) {
    float desiredseparation = r*7;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Agent other = (Agent) boids.get(i);
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d); 
        steer.add(diff);
        count++;            
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }
  PVector wander() {
    wdelta += random(-1, 1);
    PVector center = location.get();
    center.mult(2.0);
    center.add(location); 
    PVector offset = new PVector((wdelta), (wdelta));
    PVector target = PVector.add(center, offset);
    PVector steer = seek(target);   
    return steer;
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(100*maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce); 
    return steer;
  }
  
  PVector avoid(PVector target) {
    PVector steer; 
    PVector velocity2 = new PVector(velocity.x*sin(r),velocity.y*cos(r));
    PVector desired = new PVector(0,0);//PVector.sub(target, velocity2); //velocity, target
    float distance = mag2(desired);
//    if (distance > 0 && distance < (100)*(100)) {
      desired.normalize();
      desired.mult(0);
      //println
      //velocity = new PVector(velocity.x*sin(r),velocity.y*cos(r));
      steer = PVector.sub(desired, velocity);  // desired, velocity
      //println(acceleration);
      steer.cross(velocity);
      steer.add(acceleration);
      steer.mult(random(1.0,20.0));//steer = PVector.add(steer, rndmV);
//      newagentLoc = pix[(int)abs(location.y%800)*800 + (int)location.x];
//      if (newagentLoc == -1){
//        seek(steer);
//      }
//    }
//    else {
//      steer = new PVector(0,0);
//      println("ive been used");
//      steer = PVector.sub(velocity,desired);
//      steer.mult(maxspeed);//*100
//      steer.normalize();
//    }
    return steer;
  }

  void render() {
 
    if (k==1){
      pgWaleed.fill(43, 191, 189);
      pgWaleed.stroke(43, 191, 189);
    }
    if (k==2){
      pgWaleed.fill(255, 74, 74);
      pgWaleed.stroke(255, 74, 74);
    }
    
    pgWaleed.pushMatrix();
    pgWaleed.translate(location.x, location.y);
    pgWaleed.ellipse(0, 0, r, r);
    pgWaleed.popMatrix();
 
  }

  void borders() {
    if (location.x < -r) location.x = 800+r;
    if (location.y < -r) location.y = 800+r;
    if (location.x > 800+r) location.x = -r;
    if (location.y > 800+r) location.y = -r;
  }
  
  float mag2(PVector v) {
    return (v.x*v.x + v.y*v.y + v.z*v.z);
  }
}

  
