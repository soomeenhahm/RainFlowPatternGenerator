void setupData() {
  AllVertices= new ArrayList();
  AllSprings= new ArrayList();
  AllFieldAgents= new ArrayList();
  AllAgents= new ArrayList();


  setupVertices();
  setupSpring();
  //setupVectorField();
  //ImportVectorField();

  //setupImportAgent();

  println("vertex count: " + AllVertices.size());
  println("spring count: " + AllSprings.size());
  println("initial agent count: " + AllAgents.size());
}

void importObj() {
  String objStrings[] = loadStrings("input/Mesh.obj");
  for (int i = 0; i<objStrings.length; i++) {
    String[] parts =  split(objStrings[i], ' ');
    if (parts[0].equals("v")) {
      float x1 = float(parts[1]);
      float y1 = float(parts[2]);
      float z1 = float(parts[3]);
      Vec3D pointLoc = new Vec3D(x1, -y1, z1);
      vertexList.add(pointLoc);
    }
    //println(vertexList);
    int index = 0;
    if (parts[0].equals("f")) {
      ArrayList vertexPoints = new ArrayList();
      for (int j=1; j<parts.length; j++) {
        String[] num = split(parts[j], '/');
        int index1 = int(num[0])-1;
        Vec3D v= (Vec3D) vertexList.get(index1);
        vertexPoints.add(v);
      }
      faceCentroid tempCentroid = new faceCentroid(vertexPoints, index);
      faceCentroids.add(tempCentroid);      
      index++;
      //println("size"+sCentroidPop.size());
    }

    //println(sCentroidPop.size());
  }
}

void setupRandomAgents(int pop) {
  for (int i= 0; i < pop; i++) {    
      Vec3D loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), dDepth*0.4);
      Agent a= new Agent(this, loc);

      AllAgents.add(a);    
  }

  println("agent count: " + pop);
}



void setupImportAgent() {

  ArrayList AgentLocs= ImportText("input/AgentPts.txt");

  for (int i= 0; i < AgentLocs.size(); i++) {
    if (random(0, 1) < 1) {
      Vec3D loc= (Vec3D) AgentLocs.get(i);
      Agent a= new Agent(this, loc);

      AllAgents.add(a);

      float prop= ((i+1) / float(AgentLocs.size())) * 100;
      //println("importing agents " + i + " of " + SeedLocs.size() + " , " + prop + "% done" );
      println("importing agents: " +  prop + "% done" );
    }
  }

  println("agent count: " + AgentLocs.size());
}


void setupVertices() {

  ArrayList Locs= ImportText("input/Springs.txt");

  for (int i= 0; i < Locs.size(); i=i+2) {
    Vec3D a= (Vec3D) Locs.get(i);
    Vec3D b= (Vec3D) Locs.get(i+1);

    if (i == 0) {
      AllVertices.add(a);
      AllVertices.add(b);
    }
    else {
      testDuplicate(AllVertices, a, 0, 0.01);
      testDuplicate(AllVertices, b, 0, 0.01);
    }

    float prop= ((i+1) / float(Locs.size())) * 100;
    //println("vertex calculating on " + i + " of " + Loc_Start.size() + "= " + prop + "%" );
    println("importing vertices: " +  prop + "% done" );
  }

  //println("vertex count: " + AllVertices.size());
}

Vec3D testDuplicate(ArrayList AllVertices, Vec3D Vtest, float MinTolerence, float MaxTolerence) {
  boolean blnSame= false;
  Vec3D Vactual = Vtest;
  for (int i=0; i< AllVertices.size(); i++) {
    Vec3D other= (Vec3D) AllVertices.get (i);
    float dist= other.distanceTo(Vtest);
    //if ((dist > MinTolerence) & (dist  < MaxTolerence)) { 
    if (dist< MaxTolerence) { 
      blnSame= true;
      Vactual = other;
    }
  }

  if (blnSame == false) {
    AllVertices.add(Vtest);
  }

  return Vactual;
}


void setupSpring() {

  ArrayList Locs= ImportText("input/Springs.txt");

  for (int i= 0; i < Locs.size(); i = i+2) {
    Vec3D a= (Vec3D) Locs.get(i);
    a= testDuplicate(AllVertices, a, 0, 0.01);

    Vec3D b= (Vec3D) Locs.get(i+1);
    b= testDuplicate(AllVertices, b, 0, 0.01);

    Spring ca= new Spring(a, b);
    AllSprings.add(ca);

    float prop= ((i+1) / float(Locs.size())) * 100;
    //println("spring calculating on " + i + " of " + Loc_Start.size() + "= " + prop + "%" );
    println("importing springs: " +  prop + "% done" );
  }

  //println("spring count: " + AllSprings.size());
}


void setupVectorField() {
  if (AllFieldAgents.size() <= 0) {
    for (int i=0; i< AllVertices.size(); i++) {
      Vec3D loc= (Vec3D) AllVertices.get (i);
      Field f= new Field(this, loc);
      f.SetDirection(AllSprings);

      AllFieldAgents.add(f);

      float prop= ((i+1) / float(AllVertices.size())) * 100;
      println("setting up vector field: " +  prop + "% done" );
    }
  }

  println("Field count: " + AllFieldAgents.size());
  blDrawField= true;
}



void importVectorField() {
  if (AllFieldAgents.size() <= 0) {
    ArrayList Locs= ImportText("input/FieldPts.txt");

    for (int i= 0; i < Locs.size(); i = i+2) {
      Vec3D a= (Vec3D) Locs.get(i);
      Vec3D b= (Vec3D) Locs.get(i+1);

      Vec3D vel= b.sub(a);
      vel.normalizeTo(gravity.magnitude());

      float angle= vel.angleBetween(gravity, true);

      Field f= new Field(this, a);
      f.locTarget= b;
      f.vel= vel;
      f.angleValue= angle;
      AllFieldAgents.add(f);

      float prop= ((i+1) / float(Locs.size())) * 100;
      //println("spring calculating on " + i + " of " + Loc_Start.size() + "= " + prop + "%" );
      println("importing field points: " +  prop + "% done" );
    }
  }

  println("Field count: " + AllFieldAgents.size());
  blDrawField= true;
}


ArrayList ImportText(String fileName) {
  ArrayList collection= new ArrayList();
  String lines[]= loadStrings(fileName);
  for (int i=0; i<lines.length; i++) {
    float values[]= float(lines[i].split(","));
    Vec3D loc= new Vec3D(values[0], -1 * values[1], values[2]);

    collection.add(loc);
  }

  return collection;
}

