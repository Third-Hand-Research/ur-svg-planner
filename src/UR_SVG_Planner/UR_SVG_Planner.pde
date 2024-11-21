import geomerative.*;

/* --------- CONFIG --------- */

float minX = 0.0; // minimum X is 0m
float maxX = 1.0; // maximum X is 0.5m
float minY = 0.0; // minimum Y is 0m
float maxY = 1.0; // maximum Y is 0.5m
float minZ = -0.1; // minimum Y is 0m
float maxZ = 0.1; // maximum Y is 0.5m

boolean homeAtStart = true; // send the tool to the home position on program start, useful to verify tool alignment against a reference
boolean homeAtEnd = true; // send the tool to the home position on program end
boolean homeAfterEveryPath = false; // go home after each path
float homeX = 0.0; // X home coordinate
float homeY = 0.0; // Y home coordinate
float homeZ = -0.1; // Z home coordinate

boolean dipBeforeEveryPath = false; // dip the tool after every path
float dipX = 0.0; // X dip coordinate
float dipY = 0.0; // Y dip coordinate
float dipZ = 0.0; // Z dip coordinate
float dipApproach = -0.1; // Z dip approach coordinate

boolean popUpBeforeStart = false; // after homing, popup window to wait for user input before starting
boolean popUpBeforeEveryPath = false; // after homing, popup window to wait for user input before starting
boolean loopProgram = false; // should the program keep looping or stop after finishing once

boolean useOnlyCentroid = false; // follow individual paths or only punch down on path's centroid.
boolean followPathVector = false; // TODO follow path's vector, can cause trouble if exceeding axis max rotation

boolean useDigitalOutput = false; // output digital output commands to turn on/off some peripherals
int digitalOutputId = 0; // digital output number

float rapid_ms = 0.25; // rapid velocity to link between operations, similar to gcode G0 , meters/sec
float feed_ms = 0.01; // feed velocity during process operations, similar to gcode G1, meters/sec
float accel_mss = 0.2; // global acceleration/deceleration, meters/s2
float blend_radius_m = 0.001; // global blending radius, meters

float approach = -0.05; // approach above process start/stop, meters
float processZ = 0.0; // how deep to go when processing a path

String feature = "plane_1"; // feature plane from which to process, Installation Feature name

String filename_in = "data/smiley.svg"; // SVG input filename, in the /data folder of the sketch
String filename_out = "data/output.script"; // URScript output filename, in the /data folder of the sketch

/* --------- DO NOT CHANGE AFTER THIS -------- */

Post post;
RShape grp;
RPoint[][] pointPaths;

float dpi_to_meter = (25.4/72) / 1000; // scale factor from 72 DPI to meters
float meter_to_px = 1000; // display factor from meters to 1mm = 1 pixel
boolean ignoringStyles = true;

void setup(){
  size(1000, 1000); // display area is 1m x 1m

  RG.init(this);
  RG.ignoreStyles(ignoringStyles);

  grp = RG.loadShape(filename_in);

  // polygonizer settings, change if needed
  RG.setPolygonizer(RG.ADAPTATIVE);
  // RG.setPolygonizerAngle(PI/100);
  // RG.setPolygonizerStep(20);
  // RG.setPolygonizerLength(20);

  // convert 2D array, a list of list of XY points, one list per SVG path
  pointPaths = grp.getPointsInPaths();
  
  // instantiate post processor with output filename
  post = new Post(filename_out);

  // if nothing in polygonized file, error out
  if (pointPaths == null) {
    println("There is a problem with the selected SVG file! Make sure the filename is correct or that the file is a valid SVG.");
    exit();
  }
}

void draw(){

  background(127);
  noFill();
  
  // draw bounded surface
  fill(255);
  noStroke();
  rect(minX*meter_to_px, minY*meter_to_px, (minX+maxX)*meter_to_px, (minY+maxY)*meter_to_px);

  // setup config variables
  post.print("#set parameters");
  post.print("global rapid_ms = " + rapid_ms);
  post.print("global feed_ms = " + feed_ms);
  post.print("global accel_ms = " + accel_mss);
  post.print("global blend_radius_m = " + blend_radius_m);
  post.print("global feature = " + feature);
  
  // home at start
  if (homeAtStart) post.movel(homeX, homeY, homeZ, 0);
  
  // popup at start
  if (popUpBeforeStart) post.popup("Start program?");

  stroke(0);
  noFill();
  beginShape();

  // loop through all paths of the polygonized SVG
  for(int i = 0; i<pointPaths.length; i++){

    // check if path is valid
    if (pointPaths[i] != null) {
      
      // popup before continuing
      if (popUpBeforeEveryPath) post.popup("Process next path?");
      
      // containers for centroid calculation
      float centerX = 0.0;
      float centerY = 0.0;
      
      // dip tool
      if (dipBeforeEveryPath) {
        post.movel(dipX, dipY, dipApproach);
        post.movel(dipX, dipY, dipZ, 0);
        post.movel(dipX, dipY, dipApproach);
      }
      
      // if not using centroid, move above start of path
      if (!useOnlyCentroid) {
        post.movel(pointPaths[i][0].x*dpi_to_meter, pointPaths[i][0].y*dpi_to_meter, approach);
        
        // start drawing path
        beginShape(); 
        // draw starting point
        vertex(pointPaths[i][0].x*dpi_to_meter*meter_to_px, pointPaths[i][0].y*dpi_to_meter*meter_to_px);
        // draw circle to indicate start position
        ellipse(pointPaths[i][pointPaths[i].length-1].x*dpi_to_meter*meter_to_px, pointPaths[i][pointPaths[i].length-1].y*dpi_to_meter*meter_to_px, 3, 3);
      }
      
      // set digital output HIGH if we need to turn on some device (solenoid, valve, servo, motor, light..)
      if (useDigitalOutput) post.setDO(digitalOutputId, true);
      
      // loop through all points from path
      for(int j = 0; j<pointPaths[i].length; j++){
        
        if (!useOnlyCentroid) {
          // draw segment
          vertex(pointPaths[i][j].x*dpi_to_meter*meter_to_px, pointPaths[i][j].y*dpi_to_meter*meter_to_px);
          // go through point
          post.movel(pointPaths[i][j].x*dpi_to_meter, pointPaths[i][j].y*dpi_to_meter, processZ);
        } else {
          // if using centroid, add up each path point to compute center
          centerX += pointPaths[i][j].x*dpi_to_meter;
          centerY += pointPaths[i][j].y*dpi_to_meter;
        }
      }
      
      // if not using center, move above last point
      if (!useOnlyCentroid) {
        
        // move above last point
        post.movel(pointPaths[i][pointPaths[i].length-1].x*dpi_to_meter, pointPaths[i][pointPaths[i].length-1].y*dpi_to_meter, approach);

        // finish segment
        endShape();
        
      } else {
        
        // if using centroid, compute center
        centerX /= pointPaths[i].length;
        centerY /= pointPaths[i].length;
        
        // go above center, down and up
        post.movel(centerX, centerY, approach);
        post.movel(centerX, centerY, processZ, 0);
        post.movel(centerX, centerY, approach);
        
        // display centroid
        ellipse(centerX * meter_to_px, centerY * meter_to_px, 5, 5);
      }
      
      // set digital output LOW to turn off whatever device is used
      if (useDigitalOutput) post.setDO(digitalOutputId, false);
     
      // go home after processing each path
      if (homeAfterEveryPath) post.movel(homeX, homeY, homeZ, 0);
    }
  }

  // go home at end of file
  if (homeAtEnd) post.movel(homeX, homeY, homeZ, 0);
  
  // should we keep looping or halt at the end?
  if (!loopProgram) post.halt();

  println("program line count: "+post.getCount());
  post.export();
  
  fill(0);
  text("Program line number: "+post.getCount(), 20, 30);

  println("export successful!");

  noLoop();
  // exit();
}

void mousePressed(){
   exit();
}
