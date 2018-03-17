boolean blnPrintTrailPts= false;
boolean isRecord= false;
boolean blDrawField= true;
boolean blDrawMesh= true;

PrintWriter output;
void exportTrails() { 
  if (blnPrintTrailPts == true) {
    output = createWriter("output/" + timestamp() +"_TrailPts.txt");

    for (int i=0; i<AllAgents.size(); i++) {
      Agent a= (Agent) AllAgents.get(i);
      String st= "";
      for (int j=0; j<a.trailPop.size(); j++) {
        Vec3D loc= (Vec3D) a.trailPop.get(j);
        st= st + loc.x + "," + loc.y + "," + loc.z + ";";
      }
      output.println(st);
    }

    output.flush();
    output.close();

    println("trail points have been exported");

    blnPrintTrailPts= false;
  }
}


PrintWriter output2;
void exportVectorField() { 
  //output2 = createWriter("output/" + timestamp() +"_FieldPts.txt");
  output2 = createWriter("input/FieldPts.txt");

  for (int i=0; i<AllFieldAgents.size(); i++) {
    Field f= (Field) AllFieldAgents.get(i);

    Vec3D loc= f.loc;
    String st= loc.x + "," + -1 * loc.y + "," + loc.z;
    output2.println(st);

    Vec3D locTarget= f.locTarget;
    st= locTarget.x + "," + -1 * locTarget.y + "," + locTarget.z;
    output2.println(st);
  }

  output2.flush();
  output2.close();

  println("Field points have been exported");
}



String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}


void keyPressed() {

  if (key == 'x') {
    blnPrintTrailPts = !blnPrintTrailPts;
  }

  if (key == 'i' ) {
    isRecord = !isRecord;
  }

  if (key == 'j') {
    saveFrame ("output/image" + timestamp() + ".png");
  }

  if (key == 'f') {
    blDrawField= !blDrawField;
  }

  if (key == '1') {
    setupVectorField();
  }

  if (key == '2') {
    exportVectorField();
  }

  if (key == '3') {
    importVectorField();
  }

  if (key == '4') {
    //setupImportAgent();
    setupRandomAgents(200);//agent pop
  }

  if (key == 'c') {
    getCamState();
  }

  if (key =='v') {
    setCamState();
  }

  if (key == 'm') {
    blDrawMesh= !blDrawMesh;
  }
}

