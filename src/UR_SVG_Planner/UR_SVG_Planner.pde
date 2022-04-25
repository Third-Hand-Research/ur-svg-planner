import geomerative.*;

PrintWriter ur;

RShape grp;
RPoint[][] pointPaths;

float rescale = 0.3521/1000; // scale factor from SVG unitless to meters
float dispscale = rescale*1000; // display factor from meters to 1mm = 1 pixel

boolean ignoringStyles = true;

void setup(){
  size(1000, 1000); // work area is 1m x 1m

  RG.init(this);
  RG.ignoreStyles(ignoringStyles);

  grp = RG.loadShape("smiley.svg");

  RG.setPolygonizer(RG.ADAPTATIVE);
  //RG.setPolygonizerAngle(PI/100);
  // RG.setPolygonizerStep(20);
  // RG.setPolygonizerLength(20);

  pointPaths = grp.getPointsInPaths();
  
  if (pointPaths == null) {
    println("There is a problem with the selected SVG file! Make sure the filename is correct or that the file is a valid SVG.");
    exit();
  }
}

void draw(){
  
  background(255);
  noFill();
    
  int lineCount = 0; // simple line counter to keep track of final file size
  
  String p = "data/file.script";
  ur = createWriter(p);
  
  ur.println("def Print():\n" +
    "  #set parameters\n" +
    "  global rapid_ms = 0.25\n" + // 0.25m/s
    "  global feed_ms = 0.01\n" + // 0.01m/s
    "  global accel_mss = 0.25\n" + // 0.25m/ss
    "  global blend_radius_m = 0.005\n" + // blend 5mm in corners to prevent stopping at each points
    "  global approach = 0.03\n" + // approach every segment at 3cm above the Feature plane
    "  global feature = Plane_1\n"); // execute all movements relative to this Feature plane
  lineCount += 8;
  
  ur.println("  movel(pose_trans(feature, p[0,0,-0.1,0,0,0]), rapid_ms, accel_mss, 0, 0)"); // start the path by going home to make sure we are well calibrated
  ur.println("  sleep(2)"); // wait a bit just to give time in case of mistake

  stroke(0);
  noFill();
  beginShape();
  
  // loop through all paths of the SVG
  for(int i = 0; i<pointPaths.length; i++){

    if (pointPaths[i] != null) {
      beginShape();
      // set digital output 1 to HIGH if we need to turn on some device (solenoid, valve, servo..)
      ur.println("  set_standard_digital_out(1,True)");
      // move above start of path
      ur.println("  movel(pose_trans(feature, p["+pointPaths[i][0].x*rescale+","+pointPaths[i][0].y*rescale+",-approach,0,0,0]), accel_ms, rapid_ms, 0, blend_radius_m)");
      lineCount+=2;
      
      // draw starting point
      vertex(pointPaths[i][0].x*dispscale, pointPaths[i][0].y*dispscale);
      // draw circle to indicate start position
      ellipse(pointPaths[i][pointPaths[i].length-1].x*dispscale, pointPaths[i][pointPaths[i].length-1].y*dispscale, 3, 3);
      
      // loop through all points from path
      for(int j = 0; j<pointPaths[i].length-1; j++){
        // draw segment
        vertex(pointPaths[i][j].x*dispscale, pointPaths[i][j].y*dispscale);
        // go through point
        ur.println("  movel(pose_trans(feature, p["+pointPaths[i][j].x*rescale+","+pointPaths[i][j].y*rescale+",0,0,0,0]), accel_mss, feed_ms, 0, blend_radius_m)");
        lineCount++;  
      }
      
      // finish segment
      endShape();
      // set digital output 1 to LOW to turn off whatever device might be plugged in
      ur.println("  set_standard_digital_out(1,False)");
      ur.println("  movel(pose_trans(feature, p["+pointPaths[i][pointPaths[i].length-1].x*rescale+","+pointPaths[i][pointPaths[i].length-1].y*rescale+",-approach,0,0,0]), accel_mss, rapid_ms, 0, blend_radius_m)");
      lineCount+=2;
    }
  }
  
  // go above origin at the end of the file
  ur.println("  movel(pose_trans(feature, p[0,0,-0.1,0,0,0]), accel_ms, rapid_ms, 0, 0)");
  ur.println("end");
  ur.println("Print()");
  lineCount+=3;
  
  println("program line count: "+lineCount);
  ur.flush();
  ur.close();

  println("export successful!");

  noLoop();
  // exit();
}

void mousePressed(){
   exit();
}
