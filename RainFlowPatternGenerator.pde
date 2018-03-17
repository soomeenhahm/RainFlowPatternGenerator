//Rainflow Pattern Generator on Mesh Network
//using OBJ input
//Author: Soomeen Hahm
//CopyWirte: Soomeen Hahm On Behalf of SoomeenHahm Design Ltd
//soomeenhahm.com
//Last modified: 07 Nov 2016
//Version: GravityPath32_g

import toxi.geom.*;
import peasy.*;
import plethora.core.*;
import java.util.Calendar;
import toxi.color.*;

//world size
int wWidth= 1800;   //x
int hHeight= 1600;   //y
int dDepth = 1600;   //z

//camera
PeasyCam cam;
Vec3D camCenter= new Vec3D (0, 0, 0);

ToneMap toneMap;

ArrayList AllVertices;
ArrayList AllSprings;
ArrayList AllAgents;
ArrayList AllFieldAgents;
ArrayList vertexList= new ArrayList();
ArrayList faceCentroids= new ArrayList();

Vec3D gravity= new Vec3D (0, 0, -10);



void setup() {
  size(1280, 720, OPENGL);
  smooth();
  background(255);

  setupCamera();
  setCamState();

  setupToneMap();

  setupData();
  importObj();

  /*
  for (int i=0; i<AllFieldAgents.size(); i++) {
   Field f= (Field) AllFieldAgents.get(i);
   println(f.angleValue);
   }
   */
}

void draw() {
  frameRate(30);
  background(255);

  //drawVertices();

  if (blDrawMesh) updateMesh();

  if (blDrawField) {
    //drawSprings();
    drawField();
  }



  runAgents();  
  drawAgents();

  //drawOrigin();
  //drawBox();

  exportTrails();

  if (isRecord) saveFrame ("output/image" + timestamp() + ".png");
}


void getCamState() {  
  float r[]= cam.getRotations();
  float p[]= cam.getPosition();
  double d= cam.getDistance();

  println("rotation: " + r[0] + "," + r[1] + "," + r[2] );
  println("position: " + p[0] + "," + p[1] + "," + p[2] );
  println("distance: " + d);
}

void setCamState() {
  setupCamera();
  
  /*cam.setDistance(2384);
  cam.lookAt(camCenter.x, camCenter.y, camCenter.z-170);
  cam.rotateX(-0.42164472);
  cam.rotateY(-1.0211276);
  cam.rotateZ(1.0705822);*/

  cam.rotateX(-0.9243515);
  cam.rotateY(0.5571371);
  cam.rotateZ(-0.37238687);
}


//------------------------------------------------------------------------------------------------------------
//Setup:
//------------------------------------------------------------------------------------------------------------
void setupCamera() {
  cam= new PeasyCam(this, camCenter.x, camCenter.y, camCenter.z, 2000);        
  cam.setActive(true);
}

void setupToneMap() {
  // create a color gradient for 256 values
  ColorGradient grad=new ColorGradient();
  // NamedColors are preset colors, but any TColor can be added
  // see javadocs for list of names:
  // http://toxiclibs.org/docs/colorutils/toxi/color/NamedColor.html
  grad.addColorAt(0, NamedColor.RED);
  grad.addColorAt(64, NamedColor.YELLOW);
  grad.addColorAt(128, NamedColor.GREEN);
  grad.addColorAt(192, NamedColor.BLUE);
  grad.addColorAt(255, NamedColor.CYAN);
  // this gradient is used to map simulation values to colors
  // the first 2 parameters define the min/max values of the
  // input range (Gray-Scott produces values in the interval of 0.0 - 0.5)
  // setting the max = 0.33 increases the contrast
  toneMap=new ToneMap(0, 255, grad);

  //use it like this:
  //color c= toneMap.getARGBToneFor(angleValue);
}

//------------------------------------------------------------------------------------------------------------
//Update:
//------------------------------------------------------------------------------------------------------------

void runAgents() {
  for (int i=0; i<AllAgents.size(); i++) {
    Agent a= (Agent) AllAgents.get(i);
    a.run();
  }
}

void runSprings() {  
  for (int i=0; i<AllSprings.size(); i++) {
    Spring s= (Spring) AllSprings.get(i);
    s.run();
  }
}

void updateMesh() {
  for (int i = 0; i < faceCentroids.size(); i++) {
    faceCentroid f = (faceCentroid) faceCentroids.get(i);
    f.update();
  }
}

//------------------------------------------------------------------------------------------------------------
//Draw:
//------------------------------------------------------------------------------------------------------------
void drawVertices() {
  for (int i=0; i<AllVertices.size(); i++) {
    Vec3D loc= (Vec3D) AllVertices.get(i);
    stroke(255, 0, 0);
    strokeWeight(4);
    point(loc.x, loc.y, loc.z);
  }
}

void drawSprings() {  
  for (int i=0; i<AllSprings.size(); i++) {
    Spring ca= (Spring) AllSprings.get(i);
    ca.render();
  }
}

void drawField() {
  for (int i=0; i<AllFieldAgents.size(); i++) {
    Field f= (Field) AllFieldAgents.get(i);
    f.render();
  }
}

void drawAgents() {
  for (int i=0; i<AllAgents.size(); i++) {
    Agent s= (Agent) AllAgents.get(i);
    s.render();
  }
}

void drawBox() {
  stroke(200);                
  strokeWeight(1);
  noFill();
  box(wWidth, hHeight, dDepth);
}

void drawOrigin() {
  strokeWeight(1);
  stroke(255, 0, 0);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 100);
}
