class Agent extends Ple_Agent {
  PApplet p5;

  ArrayList trailPop;
  float trailSizeMax;

  Agent(PApplet _p5, Vec3D _loc) {
    super (_p5, _loc);

    //vel= new Vec3D (0, 0, -10);
    maxspeed = 2 ;
    maxforce = 1 ;

    trailPop= new ArrayList();
    trailSizeMax= 1000;
    loc = nearestPt(AllVertices);
    
    //Vec3D locSnap= nearestPt(AllVertices);
    //loc.z = locSnap.z;
  }

  void render() {
    stroke(0);
    strokeWeight(4);
    point(loc.x, loc.y, loc.z);
  }

  void run() {
    ////1. Flock:
    //flock(AllAgents, 80, 40, 30, 1, 0.5, 1.5);

    ////2. Follow Field:
    Vec3D follow = followField(AllFieldAgents, 30);
    follow.scaleSelf(5);
    acc.addSelf(follow);

    ////3. Snap to mesh vertices:
    Vec3D target = nearestPt(AllVertices);
    Vec3D steer = steer(target);
    steer.scaleSelf(0.01);
    acc.addSelf(steer);

    ////Other:
    if (loc.z > -750) {
      update();
    }
    trail();
  }

  void trail() {
    Vec3D trailpt = loc.copy();
    trailPop.add(trailpt);

    //beginShape();
    for ( int i = 0 ;  i < trailPop.size()-1; i++) {
      Vec3D temp = (Vec3D) trailPop.get(i);
      Vec3D temp2 = (Vec3D) trailPop.get(i+1);
      stroke(50);
      strokeWeight(1.2);
      //point(temp.x, temp.y, temp.z);
      //vertex(temp.x, temp.y, temp.z);
      line(temp.x, temp.y, temp.z, temp2.x, temp2.y, temp2.z);
    }
    //endShape();

    if (trailPop.size() > trailSizeMax) {
      trailPop.remove(0);
    }
  }


  Vec3D followField(ArrayList vectors, float localRangeOfVis) {
    Vec3D sum = new Vec3D();
    int count = 0; 

    for ( int i = 0; i <vectors.size(); i++) {
      Field other =  (Field) vectors.get(i);
      float d = loc.distanceTo(other.loc);
      if (( d < localRangeOfVis) && ( d>0)) {

        Vec3D followVec = other.vel.copy(); 
        followVec.scaleSelf(1/d);
        sum.addSelf(followVec);
        count++;
      }
    }
    if (count>0) {
      sum.scaleSelf(1/(float)count);
      sum.limit(maxforce);
    }
    return sum;
  }

  Vec3D steer (Vec3D target) {
    target.subSelf(loc); 
    float d = target.magnitude();
    if (d>0) {
      target.normalize();
      target.scaleSelf(maxspeed);
      target.subSelf(vel); 
      target.limit(maxforce);
    } 
    else {
      target = new Vec3D();
    }
    return target;
  }

  Vec3D nearestPt(ArrayList AllVectors) {
    Vec3D neatestPt= new Vec3D(9999, 9999, 9999);
    float nestestdist= 9999999;

    for (int i= 0; i < AllVectors.size(); i++) {
      Vec3D other = (Vec3D) AllVectors.get(i);  

      float distance= loc.distanceTo(other);
      if (distance>0 && distance < nestestdist) {
        neatestPt= other.copy();
        nestestdist= distance;
      }
    }

    return neatestPt;
  }
}

