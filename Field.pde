class Field extends Ple_Agent {
  PApplet p5;
  Vec3D locTarget;
  float angleValue;
  
  Vec3D velOrg= new Vec3D();
  float fieldForce= 10; //normalize all the field vel to this amount

  Field (PApplet _p5, Vec3D _loc) {
    super (_p5, _loc);
    
    locTarget= loc.add(gravity);
  }

  void render() {
    float value= map (angleValue, 0.7, 1.1, 0, 255);
    color c= toneMap.getARGBToneFor(value);

    //stroke(c);
    //strokeWeight(4);
    //point(loc.x, loc.y, loc.z);

    stroke(c);
    //stroke(0);
    strokeWeight(1.5);
    //Vec3D temp= vel.copy();
    Vec3D temp= velOrg.copy();
    line(loc.x, loc.y, loc.z, loc.x+temp.x, loc.y+temp.y, loc.z+temp.z);
  }

  void SetDirection(ArrayList AllSprings) {

    //Step 1: Get All Connection Crvs
    ArrayList connectionCrvs= new ArrayList();
    ArrayList connectionCrvsTarget= new ArrayList();
    //ArrayList connectionCrvsAngle= new ArrayList();

    for (int i= 0; i < AllSprings.size(); i++) {
      Spring crv = (Spring) AllSprings.get(i); 
      float distanceA= loc.distanceTo(crv.a);
      float distanceB= loc.distanceTo(crv.b);

      if (distanceA < 0.1) {
        connectionCrvs.add(crv);
        connectionCrvsTarget.add(crv.b);
      }
      else if (distanceB < 0.1) {
        connectionCrvs.add(crv);
        connectionCrvsTarget.add(crv.a);
      }
    }


    //=====================================
    if (connectionCrvs.size() >0) {
      //Step 2: Return All Angles Between Direction 
      float[] angles= new float[connectionCrvs.size()];
      for (int i=0; i<connectionCrvsTarget.size(); i++) {
        Vec3D target= (Vec3D) connectionCrvsTarget.get(i);
        Vec3D targetDir= target.sub(loc);
        targetDir.normalizeTo(gravity.magnitude());

        float angle= targetDir.angleBetween(gravity, true);

        // stroke(0, 0, 255);
        // strokeWeight(4);
        // point(target.x, target.y, target.z);

        // stroke(0);
        // text(angle, target.x, target.y, target.z);
        // println(angle);

        angles[i]= angle;
      }

      //Step 3: Sort Smallest Angled One
      for (int i=0; i< connectionCrvs.size(); i++) {
        for (int j=0; j< i; j++) {
          if (angles[i]< angles[j]) {
            float aTemp= angles[i];
            angles[i]= angles[j];
            angles[j]= aTemp;

            Spring crvTemp= (Spring) connectionCrvs.get(i);
            Spring crvTempJ= (Spring) connectionCrvs.get(j);
            connectionCrvs.set(i, crvTempJ);
            connectionCrvs.set(j, crvTemp);

            Vec3D crvTargetTemp= (Vec3D) connectionCrvsTarget.get(i);
            Vec3D crvTargetTempJ= (Vec3D) connectionCrvsTarget.get(j);
            connectionCrvsTarget.set(i, crvTargetTempJ);
            connectionCrvsTarget.set(j, crvTargetTemp);
          }
        }
      }

      Spring crvNext= (Spring) connectionCrvs.get(0);
      //crvNext.blPath= true;
      angleValue= angles[0];

      //Step 4: Get Target Loc
      locTarget= (Vec3D) connectionCrvsTarget.get(0);
      vel = locTarget.sub(loc);
      
      //Step 5: normalize vel and save the original
      velOrg = vel.copy();
      vel.normalizeTo(fieldForce);
    }
    //=====================================
  }
}

