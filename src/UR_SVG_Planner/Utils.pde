boolean checkBounds(float val, float min, float max){
  
  boolean ok = val >= min && val <= max;
  
  if (!ok) {
    println("Coordinate is out of bounds! Not allowed to export program, verify your SVG file or your bound limits!");
    System.exit(1);
  }
 
  return ok;
}

float deg2rad(float d){
  return d*(PI/180); 
}

float rad2deg(float r){
  return r*(180/PI); 
}
