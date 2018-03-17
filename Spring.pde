class Spring {
  Vec3D a;
  Vec3D b;

  boolean blPath;

  Spring(Vec3D _a, Vec3D _b) {
    a= _a;
    b= _b;

    blPath= false;
  }

  void run() {
  }

  void render() {
    if (!blPath) {
      stroke(155, 100);
      strokeWeight(1);
    }
    else {
      stroke(255, 0, 0);
      strokeWeight(1);
    }
    line(a.x, a.y, a.z, b.x, b.y, b.z);
  }
}

