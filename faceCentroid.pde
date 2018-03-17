class faceCentroid {

  Vec3D pos= new Vec3D();
  Vec3D faceNormal= new Vec3D();
  Vec3D faceNormal2= new Vec3D();
  ArrayList vertexPoints= new ArrayList();
  int index; 

  faceCentroid(ArrayList _vertexPoints, int _index) {
    vertexPoints= _vertexPoints;
    index = _index; 

    Initialize();
  }

  void Initialize() {
    CalculateCentroid();
    CalculateNormal();
  }


  void update() {
    display();
    //displayNormal();
  }

  void CalculateNormal() {
    //Temporal, using 3 vertices only ============
    Vec3D a= (Vec3D) vertexPoints.get(0);
    Vec3D b= (Vec3D) vertexPoints.get(1);
    Vec3D c= (Vec3D) vertexPoints.get(2);

    Vec3D v1 = b.sub(a);
    Vec3D v2 = c.sub(a);
    faceNormal = v1.cross(v2);
    faceNormal.normalize();
    faceNormal.scaleSelf(10); 
    faceNormal2 = pos.sub(c); 
    faceNormal2.normalize();
    faceNormal2.scaleSelf(10);
    //============================================
  }

  void CalculateCentroid() {
    int count=0;
    for (int i=0; i<vertexPoints.size(); i++) {
      Vec3D v= (Vec3D) vertexPoints.get(i);
      pos.addSelf(v);
      count++;
    }
    pos.scaleSelf(1/float(count));
  }

  void display() { 
    stroke(150); 
    strokeWeight(0.6);
    //noFill();
    fill(100, 100, 100, 50); 
    beginShape();
    for (int i=0; i<vertexPoints.size(); i++) {
      Vec3D v= (Vec3D) vertexPoints.get(i);
      VecVertex(v);
    }
    endShape(CLOSE);
  }

  void displayNormal() {
    Vec3D temp2 = faceNormal.copy();
    temp2.scaleSelf(5); 
    Vec3D temp = pos.add(temp2); 
    stroke(255, 0, 0); 
    strokeWeight(1);
    line(temp.x, temp.y, temp.z, pos.x, pos.y, pos.z);
  }

  void VecVertex(Vec3D v) {
    vertex(v.x, v.y, v.z);
  }
}

